From: James Smart <James.Smart@Emulex.Com>
Subject: [Comments Needed] scan vs remove_target deadlock
Date: Mon, 10 Apr 2006 14:25:08 -0400
Message-ID: <1144693508.3820.33.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63208 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932085AbWDJSZL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 14:25:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3AIP9rf008294
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 11:25:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We've seen a very nasty deadlock condition between the scan code and
the scsi remove code, when the sdev block/unblock functionality is
used. The scsi_scan mutex is taken as a very coarse lock over the
scan code, and will be held across multiple SCSI i/o's while the
scan is proceeding. The scan may be on a single lun basis, or on a
target basis. The jist is - it's held a loooonnng time. Additionally,
the scan code uses the block request queue for scan i/o's.  In the case
where the block/unblock interfaces are being used (fc transport), the
request queue can be stopped - which stops scanning.  If the same or
unrelated sdev is then to be removed, we enter a deadlock waiting for
the scan mutex to be released. In most cases, a background timer fires
that unblocks the sdev and things eventually unclog (granted a *lot*
of time may have gone by). In a few cases, we are seeing the sdev
request queue get plugged, then this deadlock really locks up. One last
observation: don't mix scan code and other work on the same workq.
Workq flushing will fall over fast.


I'd like to poll the wisdom of those on this list as to the best way
to approach this issue:

- The plugged queue logic needs to be tracked down. Anyone have any
  insights ?
- The scan mutex, as coarse as it is, is really broken. It would be
  great to reduce the lock holding so the lock isn't held while an
  i/o is pending. This change would be extremely invasive to the scan
  code. Any other alternatives ?
- If an sdev is "blocked", we shouldn't be wasting our time scanning it.
  Should we be adding this checks before sending each scan i/o, or is
  there a better lower-level function place this check ? Should we be
  creating an explicit return code, or continue to piggy-back on
  DID_NO_CONNECT ? How do we deal with a scan i/o which may already be
  queued when the device is blocked ?
- Similarly, we need to make sure error handling doesn't take the device
  offline when it's blocked. scsi_eh_stu() and scsi_eh_bus_device_reset()
  should gracefully handle error conditions (including blocked). Right
  now, if a host replies with DID_IMM_RETRY or DID_BUS_BUSY, the device
  could be taken offline.
- Anything else ?

Comments appreciated....

-- james s


