From: Andries.Brouwer@cwi.nl
Subject: Re: [linux-usb-devel] SCSI layer assumes 1GB for drive w/o media?
Date: Wed, 4 Feb 2004 16:38:32 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200402041538.i14FcWu27938.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:37078 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S262130AbUBDPjR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 10:39:17 -0500
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org, greg@kroah.com
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

	I have a USB card reader that shipped as part of my new computer.
	I am using 2.4.25-pre8 and seeing something rather odd -- it is
	detecting medium not present, then proceeds to guess the device
	has a 1 GB disk...

	Additional sense indicates Medium not present
	sdb : block size assumed to be 512 bytes, disk size 1GB.  
	 sdb: I/O error: dev 08:10, sector 0
	 I/O error: dev 08:10, sector 0
	ldm_validate_partition_table(): Disk read failed.
	 I/O error: dev 08:10, sector 0
	 unable to read partition table

As you already say, this is a SCSI-layer business
and has nothing to do with USB.

I think I once fixed this a little: after getting "Medium not present"
it is meaningless to continue and try to read the partition table.
Maybe that is in 2.6 only and should be backported to 2.4.

Concerning the 1 GB - that was added long ago to accommodate Jaz disks.
It is a strange hack and probably superfluous today.

Andries - no time today

