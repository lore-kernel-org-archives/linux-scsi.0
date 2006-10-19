From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Thu, 19 Oct 2006 11:42:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610191100460.6471-100000@iolanthe.rowland.org>
References: <20061018223058.65f1cf5e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52496 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1946126AbWJSPmZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 11:42:25 -0400
In-Reply-To: <20061018223058.65f1cf5e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@osdl.org>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 18 Oct 2006, Andrew Morton wrote:

> Begin forwarded message:
> 
> Date: Sun, 15 Oct 2006 12:20:02 +0300 (EEST)
> From: Meelis Roos <mroos@linux.ee>
> To: Linux Kernel list <linux-kernel@vger.kernel.org>
> Subject: garbled usb storage scsi vendor & model in 2.6.19-rc1
> 
> 
> This 2.6.19-rc1-g53a5fbdc kernel, compiled for x86_64. Plugging in a USB 
> storage device gave this in dmesg:
> 
> usb 2-2: new full speed USB device using ohci_hcd and address 4
> usb 2-2: configuration #1 chosen from 1 choice
> scsi2 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 4
> usb-storage: waiting for device to settle before scanning
> scsi 2:0:0:0: Direct-Access     ugin.upd .dpkg-new  PQ: 0 ANSI: 0 CCS

> Notice the line
> scsi 2:0:0:0: Direct-Access     ugin.upd .dpkg-new  PQ: 0 ANSI: 0 CCS
> 
> The data is garbage here (obviously I'm running debian and have done 
> daily upgrade recently). Other than that message, the device appeared 
> running fine. But it still worries.

Try using the patch below.  If you still see the same garbage showing up, 
it must be because the drive is sending this garbage to your computer.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -478,7 +478,7 @@ static int scsi_probe_lun(struct scsi_de
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
 
-		memset(inq_result, 0, try_inquiry_len);
+		memset(inq_result, 0, max(36, try_inquiry_len));
 
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,

