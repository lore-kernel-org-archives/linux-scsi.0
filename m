From: Pat LaVarre <p.lavarre@ieee.org>
Subject: CDC_RAM for lk 2.4, PATCH proposed
Date: 15 Apr 2004 10:52:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082047960.15520.82.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:25595 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264340AbUDOQw6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 12:52:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mckellj@iomega.com, linux-scsi@vger.kernel.org

Jens A:

Would you consider for 2.4.27, a patch written to give us CDC_RAM alone?

I ask because I notice, we don't need the problematic op x46
GPCMD_GET_CONFIGURATION feature x0028 MRW for 2.4.27 to support
CDC_RAM.  We only need that for MRW.

Pat LaVarre

P.S.

I speak from a context of you & John M having already done most of the
work:

--- http://sourceforge.net/projects/iomrrdtools/
--- Release Name: writable-patch-0.2
--- http://sourceforge.net/project/shownotes.php?release_id=229527
...
http://w1.894.telia.com/~u89404340/patches/packet/2.4/cd-mrw-2.4.23-rc1.patch.bz2
...
not ... complete MRW [like] lk 2.6.2+
one drive ... respond incorrectly
when doing the GET_CONFIGURATION with 0x28 ...
main reason ... not introduced into lk 2.4.
---

I ask because people connecting the recently announced Iomega RRD drives
have asked me how to mkfs ext in 2.4, to which my answer as yet is
sorry, can't help you, except for people willing to mkfs in /dev/loop
and sg_dd the disc image across.

Also I'm guessing feature fetch per se could be broadly compatible,
because today I grabbed one sample of one of the massively distributed
Microsoft XP SP1 instances beginning USB life:

https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-April/000214.html

The first three commands I see are:

-i x24 -y "12 00:00:00 24 00" // standard "INQUIRY" GPCMD_INQUIRY
-i 8 -y "46 00 00:00:00:00 00 00:08 00" // header alone of GPCMD_GET_CONFIGURATION
-i x80 -y "46 00 00:00:00:00 00 00:80 00" // total available length
...

Soon thereafter my sample proceeds with such familiar &
sufficient-to-discover-rewritable talk as:

-i x20 -y "5A 08 2A:00:00:00 00 00:20 00" // "Capabilities" GPMODE_CAPABILITIES_PAGE
...
-i x0C -y "46 00 00:20:00:00 00 00:0C 00" // "Random Writable" CDF_RWRT
...
-i x0C -y "46 00 00:24:00:00 00 00:0C 00" // "Hardware Defect Management" CDF_HWDM
...


