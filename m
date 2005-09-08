From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: legacy megaraid driver bug in mm-series
Date: Thu, 8 Sep 2005 15:35:47 +0100
Message-ID: <20050908143547.GA9741@infradead.org>
References: <20050907025258.35100c34.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2457 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751366AbVIHOfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 10:35:48 -0400
Content-Disposition: inline
In-Reply-To: <20050907025258.35100c34.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Jack Byer <ojbyer@usa.net>

On Wed, Sep 07, 2005 at 02:52:58AM -0700, Andrew Morton wrote:
> 
> 
> Begin forwarded message:

This looks preyyu much like a breakage because we're now always sending
S/G list down the scsi layer.

The patch below brings over code to handle that case from the megaraid_mbox
driver.  It's still wrong for the case someone sends a MODE_SENSE from
highmem userspace, but it should at least boot with the patch applied.


Index: scsi-misc-2.6/drivers/scsi/megaraid.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/megaraid.c	2005-08-13 13:53:52.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/megaraid.c	2005-09-08 16:34:06.000000000 +0200
@@ -621,8 +621,6 @@
 	if(islogical) {
 		switch (cmd->cmnd[0]) {
 		case TEST_UNIT_READY:
-			memset(cmd->request_buffer, 0, cmd->request_bufflen);
-
 #if MEGA_HAVE_CLUSTERING
 			/*
 			 * Do we support clustering and is the support enabled
@@ -653,7 +651,19 @@
 #endif
 
 		case MODE_SENSE:
-			memset(cmd->request_buffer, 0, cmd->cmnd[4]);
+			if (cmd->use_sg) {
+				struct scatterlist	*sgl;
+				caddr_t			vaddr;
+
+				sgl = (struct scatterlist *)cmd->request_buffer;
+				vaddr = (caddr_t)
+					(page_address((&sgl[0])->page)
+					+ (&sgl[0])->offset);
+
+				memset(vaddr, 0, cmd->cmnd[4]);
+			} else {
+				memset(cmd->request_buffer, 0, cmd->cmnd[4]);
+			}
 			cmd->result = (DID_OK << 16);
 			cmd->scsi_done(cmd);
 			return NULL;
