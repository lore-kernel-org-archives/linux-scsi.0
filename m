From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 01:27:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098833278.4914.24.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp9.wanadoo.fr ([193.252.22.22]:19641 "EHLO
	mwinf0904.wanadoo.fr") by vger.kernel.org with ESMTP
	id S261478AbUJZVXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 17:23:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Let me present an interesting problem :

Some SAN hardware present for a same LUN a bunch of valid paths and  a
bunch ghost paths. In my case, the ghosts responds to standard INQUIRY
(EVPD 0x83, 0x80, ...) but the READ_CAPACITY fails :

Attached scsi generic sg29 at scsi2, channel 0, id 3, lun 0,  type 12
  Vendor: DEC       Model: HSG80             Rev: V86S
  Type:   Direct-Access                      ANSI SCSI revision: 02
sdw : READ CAPACITY failed.
sdw : status=0, message=00, host=0, driver=08 
Current sd: sense key Not Ready
Additional sense: Logical unit not ready, initializing cmd. required
sdw: asking for cache data failed
sdw: assuming drive cache: write through
 /dev/scsi/host2/bus0/target3/lun1:<6>Device sdw not ready.
end_request: I/O error, dev sdw, sector 0
Buffer I/O error on device sdw, logical block 0
Device sdw not ready.
end_request: I/O error, dev sdw, sector 0
Buffer I/O error on device sdw, logical block 0
 unable to read partition table
Attached scsi disk sdw at scsi2, channel 0, id 3, lun 1


Somehow the sysfs attribute gets set to a random value :

# cat /sys/block/sdw/size
2097152

Say /dev/sdq is valid path to the same LUN. Its size is rightly reported
as 213338334 512-byte blocks.

Now when I want to map a multipath target over those two paths, the
device-mapper faithfully rejects saying /dev/sdw is too small for a
213338334 blocks devmap.

So what is the correct way to treat this situation ?

1) make the /sys/block/*/size attribute writable
2) resurrect a BLKSETSIZE ioctl
3) make device-mapper less strict, and hope we can fix the size by a
device rescan when it get activated
4) sell the culprit hardware

Other ideas ? Can someone provide help and kernel coding skills ?

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

