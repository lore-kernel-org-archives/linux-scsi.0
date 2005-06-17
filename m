From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: regression fix (update)
Date: Fri, 17 Jun 2005 07:51:54 -0700
Message-ID: <1119019914.23848.10.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15788 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261989AbVFQOwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 10:52:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

The fixes for sparse warnings mixed in with the fixups for
the raw_srb handler resulted in a bug that showed up in the 32 bit
environments when trying to issue calls directly to the physical devices
that are part of the arrays (ioctl scsi passthrough).

Received from Mark Salyzyn at adaptec.
Applied comment from Christoph to remove cpu_to_le32(0)
It applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -451,7 +451,7 @@ static int aac_send_raw_srb(struct aac_d
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	if (!(srbfib = fib_alloc(dev))) {
-		return -1;
+		return -ENOMEM;
 	}
 	fib_init(srbfib);
 
@@ -492,7 +492,7 @@ static int aac_send_raw_srb(struct aac_d
 	srbcmd->lun      = cpu_to_le32(user_srbcmd->lun);
 	srbcmd->flags    = cpu_to_le32(flags);
 	srbcmd->timeout  = cpu_to_le32(user_srbcmd->timeout);
-	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
+	srbcmd->retry_limit = 0; // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(user_srbcmd->cdb_size);
 	
 	switch (flags & (SRB_DataIn | SRB_DataOut)) {
@@ -508,7 +508,7 @@ static int aac_send_raw_srb(struct aac_d
 	default:
 		data_dir = DMA_NONE;
 	}
-	if (le32_to_cpu(srbcmd->sg.count) > (sizeof(sg_list)/sizeof(sg_list[0]))) {
+	if (user_srbcmd->sg.count > (sizeof(sg_list)/sizeof(sg_list[0]))) {
 		dprintk((KERN_DEBUG"aacraid: too many sg entries %d\n",
 		  le32_to_cpu(srbcmd->sg.count)));
 		rcode = -EINVAL;
@@ -592,7 +592,7 @@ static int aac_send_raw_srb(struct aac_d
 		struct sgmap* psg = &srbcmd->sg;
 		byte_count = 0;
 
-		actual_fibsize = sizeof (struct aac_srb) + (((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * sizeof (struct sgentry));
+		actual_fibsize = sizeof (struct aac_srb) + (((user_srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			dprintk((KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n"));
 			rcode = -EINVAL;
@@ -639,7 +639,7 @@ static int aac_send_raw_srb(struct aac_d
 
 	if (status != 0){
 		dprintk((KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n")); 
-		rcode = -1;
+		rcode = -ENXIO;
 		goto cleanup;
 	}
 


-- 
Mark Haverkamp <markh@osdl.org>

