From: Manu <nobody@guzu.net>
Subject: [BUG] Fusion MPT 2.6.8 driver and multi LUN device
Date: Tue, 01 Mar 2005 11:04:05 +0100
Message-ID: <42243E15.5070502@guzu.net>
Reply-To: linux-kernel@guzu.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from 26.mail-out.ovh.net ([213.186.42.179]:15332 "EHLO
	26.mail-out.ovh.net") by vger.kernel.org with ESMTP id S261850AbVCAKEv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 05:04:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Under a fresh Mandrake 10.1 with a 2.6.8 kernel, the Fusion MPT driver 
do recognize the HP tape autoloader. The autoloader is composed of tape 
drive (on LUN 0) and the changer (on LUN 1).
The message comes from scsi_scan.c :
     printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
	       " than allowed by the host adapter\n",
	       devname, lun);

Playing a bit with printk it looks like the num_luns is well computed 
(the value is 2), but the 2 LUN values seems to be miss-aligned.
When displaying the 8 bytes raw buffer (through lunp) in the loop :
  00 00 00 00 00 00 00 00
  00 00 01 00 00 00 00 00

I think the second buffer should be :
  00 01 00 00 00 00 00 00

Which, when computed, gives 1 instead of 16777216 (0x1000000).

The autoloader works like a charm under the 2.4.27 kernel provided with 
the Mandrake 10.1.

- Emmanuel Varagnat

PS: the 2 harddrives in RAID1 are well working, even with the 2.6.8 kernel.

