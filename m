From: Wakko Warner <wakko@animx.eu.org>
Subject: Possible bug with 2.6.20 and SG_IO
Date: Fri, 8 Jun 2007 19:20:22 -0400
Message-ID: <20070608232022.GA32331@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:36970 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbXFHXqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jun 2007 19:46:01 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.64 #1 (Debian Bug?  What bug /\oo/\))
	id 1Hwnkk-0008SC-Lv
	for linux-scsi@vger.kernel.org; Fri, 08 Jun 2007 19:20:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Please keep me in the CC.

I was attempting to send an INQUIRY to a scsi device using /dev/sg* and
SG_IO.  My first attempt hard locked the machine.

My code was:
 memset(&sg_io, 0, sizeof(sg_io));
 sg_io.interface_id='S';
 sg_io.dxfer_direction=SG_DXFER_FROM_DEV;
 sg_io.cmd_len=sizeof(cmd);
 sg_io.cmdp=(void *)&cmd;
 sg_io.timeout=1000; /* 1 second */
 sg_io.dxferp=inq;
 if (sense)
 {
  sg_io.mx_sb_len=sizeof(*sense);
  sg_io.sbp=(void *)sense;
 }
 
 if (ioctl(fd, SG_IO, &sg_io) == -1)
  return -1;

I'm fairly new to SG_IO so I didn't notice what I did wrong until it was too
late.  I did not set sg_io.dxfer_len=sizeof(*inq) !  This was with sg8, a
scsi processor (saf-te device) on an aic7xxx (aha-39160) controller.

I decided to try it on my laptop, sg1 (a usb flash drive) just gave me some
bizare data, sg0 (an IDE cdrom using ide-scsi) hard locked the machine. 
The kernel version on this machine is 2.6.18.

I'm wondering if I hit a bug since the sg_io.dxfer_len was 0 when it locked
up.  Maybe the SG_IO code should detect that if there is an xfer to/from the
device and sg_io.dxfer_len is 0 returning -1 ?

P.S. I know ide-scsi is depreciated and I have problems with it.  I intend
to migrate that machine to libata on the next kernel upgrade.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
