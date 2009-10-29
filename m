From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Thin provisioning support
Date: Thu, 29 Oct 2009 01:48:31 -0400
Message-ID: <4AE92CAF.4090708@interlog.com>
References: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060702020208000609030206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55060 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZJ2Fsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 01:48:30 -0400
In-Reply-To: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>

This is a multi-part message in MIME format.
--------------060702020208000609030206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Martin K. Petersen wrote:
> This version fixes 64-bit modulo on 32-bit as well as inadvertent map
> updates when TP was disabled.
> 
> 
> 
> Implement support for thin provisioning in scsi_debug.  No actual memory
> de-allocation is taking place.  The intent is to emulate a thinly
> provisioned storage device, not to be one.
> 
> There are four new module options:
> 
>  - unmap_granularity specifies the granularity at which to track mapped
>    blocks (specified in number of logical blocks).  2048 (1 MB) is a
>    realistic value for disk arrays although some may have a finer
>    granularity.
> 
>  - unmap_alignment specifies the first LBA which is naturally aligned on
>    an unmap_granularity boundary.
> 
>  - unmap_max_desc specifies the maximum number of ranges that can be
>    unmapped using one UNMAP command.  If this is 0, only WRITE SAME is
>    supported and UNMAP will cause a check condition.
> 
>  - unmap_max_blocks specifies the maximum number of blocks that can be
>    unmapped using a single UNMAP command.  Default is 0xffffffff.
> 
> These parameters are reported in the new and extended block limits VPD.
> 
> If unmap_granularity is specified the device is tagged as thin
> provisioning capable in READ CAPACITY(16).  A bitmap is allocated to
> track whether blocks are mapped or not.  A WRITE request will cause a
> block to be mapped.  So will WRITE SAME unless the UNMAP bit is set.
> 
> Blocks can be unmapped using either WRITE SAME or UNMAP.  No accounting
> is done to track partial blocks.  This means that only whole blocks will
> be marked free.  This is how the array people tell me their firmwares
> work.
> 
> GET LBA STATUS is also supported.  This command reports whether a block
> is mapped or not, and how long the adjoining mapped/unmapped extent is.
> 
> The block allocation bitmap can also be viewed from user space via:
> 
> 	/sys/bus/pseudo/drivers/scsi_debug/map
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

While testing scsi_debug with these patches I found a
problem with the Block Limits VPD page function. The
length returned by the inquiry_evpd_b0() function was
too short. A patch to fix that and a cosmetic change
(that the form factor of scsi_debug is less than 1.8
inches) is attached.

Signed-of-by: Douglas Gilbert <dgilbert@interlog.com>


--------------060702020208000609030206
Content-Type: text/x-patch;
 name="sdebug2631dg1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug2631dg1.patch"

--- linux/drivers/scsi/scsi_debug.c2631mp2	2009-10-14 11:41:17.000000000 -0400
+++ linux/drivers/scsi/scsi_debug.c	2009-10-15 14:52:08.000000000 -0400
@@ -685,10 +685,12 @@
 }
 
 
+/* Block limits VPD page (SBC-3) */
 static unsigned char vpdb0_data[] = {
-	/* from 4th byte */ 0,0,0,4,
-	0,0,0x4,0,
-	0,0,0,64,
+	/* from 4th byte */ 0,0,0,4, 0,0,0x4,0, 0,0,0,64,
+	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
+	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
 };
 
 static int inquiry_evpd_b0(unsigned char * arr)
@@ -731,11 +733,14 @@
 	return sizeof(vpdb0_data);
 }
 
+/* Block device characteristics VPD page (SBC-3) */
 static int inquiry_evpd_b1(unsigned char *arr)
 {
 	memset(arr, 0, 0x3c);
 	arr[0] = 0;
-	arr[1] = 1;
+	arr[1] = 1;	/* non rotating medium (e.g. solid state) */
+	arr[2] = 0;
+	arr[3] = 5;	/* less than 1.8" */
 
 	return 0x3c;
 }

--------------060702020208000609030206--
