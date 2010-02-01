From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 15185] New: Sending a 48bit ATA-Command with "CheckCondition"
 through SG_IO does not return correct 48bit sense descriptor
Date: Mon, 01 Feb 2010 13:11:38 -0500
Message-ID: <4B67195A.9060806@interlog.com>
References: <bug-15185-11613@http.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080609050901040604050200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51157 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab0BASLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:11:44 -0500
In-Reply-To: <bug-15185-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080609050901040604050200
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15185
> 
>            Summary: Sending a 48bit ATA-Command with "CheckCondition"
>                     through SG_IO does not return correct 48bit sense
>                     descriptor
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.31
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: stefan.huebner@stud.tu-ilmenau.de
>         Regression: No
> 
> 
> Example: sending a correct "READ_NATIVE_MAX_ADDRESS_EXT" to /dev/sdd (opened
> O_RDWR | O_NONBLOCK) via ATA_PASSTHROUGH_16 (SCSI-Command 0x85) with the EXTEND
> and the CHECK_CONDITION bits set to 1 yields sense data in descriptor-format. 
> Unfortunately, the descriptor does not have EXTEND set, and by that only
> returns 24 Bits of LBA.
> 
> This obviously is a bug, as the SAT-2 Draft says: "If the sense data is for an
> ATA PASS-THROUGH (16) command with the EXTEND bit set to one, then the SATL
> shall return the 48-bit extended status and shall set the EXTEND bit to one."
> 
> Contents of important data-structures for SG_IO:
> sg_io_hdr.cmdlen = 16
> *sg_io_hdr.cmdp = {0x85 0x07 0x20 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> 0x00 0x00 0x27 0x00}
> 
> sense-data after command:
> 0x72 0x00 0x00 0x00 0x00 0x00 0x00 0x0e 0x09 0x0c 0x00 0x00 0x00 0x00 0x00 0xaf
> 0x00 0x6d 0x00 0x70 0x00 0x50
> meaning: descriptor-sense, no error
> descriptor:
>  code=0x09 -> ATA-Return descriptor
>  length=0x0c
>  EXTEND=0
>  Error = 0x00
>  SectorCount = 0x00
>  LBA_Low = 0xaf
>  LBA_Mid = 0x6d
>  LBA_High= 0x70
>  Device  = 0
>  Status  = DeviceReady | DeferredWriteError
> 
> The drive used should be reporting a native max lba of 0x74706daf (1.02TB), so
> the expected sense data should look like:
> 0x72 0x00 0x00 0x00 0x00 0x00 0x00 0x0e 0x09 0x0c 0x01 0x00 0x00 0x00 0x6d 0xaf
> 0x74 0x70 0x00 0x00 0x00 0x50

This bug does not occur in lk 2.6.30 but does in lk
2.6.32 . There was a pretty large rework of libata
in that period and there is obvious bug in
drivers/ata/libata-scsi.c that causes this.

The attached patch fixes this problem in lk 2.6.32 in
my test.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>





--------------080609050901040604050200
Content-Type: text/x-patch;
 name="latascsi2632.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="latascsi2632.diff"

--- linux/drivers/ata/libata-scsi.c	2009-12-03 11:11:13.000000000 -0500
+++ linux/drivers/ata/libata-scsi.c2632dpg1	2010-02-01 10:55:36.000000000 -0500
@@ -2825,7 +2825,7 @@
 	 * write indication (used for PIO/DMA setup), result TF is
 	 * copied back and we don't whine too much about its failure.
 	 */
-	tf->flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	if (scmd->sc_data_direction == DMA_TO_DEVICE)
 		tf->flags |= ATA_TFLAG_WRITE;
 


--------------080609050901040604050200--
