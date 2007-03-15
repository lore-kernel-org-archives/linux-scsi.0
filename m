From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 6/7] aacraid: fix srb ioctl for 64 bits
Date: Thu, 15 Mar 2007 10:27:32 -0700
Message-ID: <1173979652.30374.26.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXCOR1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:27:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

The raw srb ioctl is supposed to be able to take packets with 32 and 64 bit
virtual address SG elements, it did not handle the frames with 64 bit SG
elements well when communicating with 64 bit DMA capable adapters, and it did
not handle the 32 bit limited DMA adapters at all.  The enclosed patch now
handles all four quadrants (32 bit / 64 bit SG elements in SRB requests + 32
bit or 64 bit DMA capable adapters)

This fix is required before Java based management applications in a 64 bit user
space can submit raw srb requests to the array physical components via the
ioctl mechanism, the allocated user memory pool on 64 bit machines under this
environment forced the management software's hands to submit 64 bit user space
virtual address SG elements in via the ioctl.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:30:16.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:30:21.000000000 -0700
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -468,7 +468,7 @@ static int aac_send_raw_srb(struct aac_d
 	void *sg_list[32];
 	u32   sg_indx = 0;
 	u32 byte_count = 0;
-	u32 actual_fibsize = 0;
+	u32 actual_fibsize64, actual_fibsize = 0;
 	int i;
 
 
@@ -481,7 +481,7 @@ static int aac_send_raw_srb(struct aac_d
 		return -EPERM;
 	}
 	/*
-	 *	Allocate and initialize a Fib then setup a BlockWrite command
+	 *	Allocate and initialize a Fib then setup a SRB command
 	 */
 	if (!(srbfib = aac_fib_alloc(dev))) {
 		return -ENOMEM;
@@ -548,129 +548,183 @@ static int aac_send_raw_srb(struct aac_d
 		rcode = -EINVAL;
 		goto cleanup;
 	}
-	if (dev->dac_support == 1) {
+	actual_fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry) +
+		((user_srbcmd->sg.count & 0xff) * sizeof(struct sgentry));
+	actual_fibsize64 = actual_fibsize + (user_srbcmd->sg.count & 0xff) *
+	  (sizeof(struct sgentry64) - sizeof(struct sgentry));
+	/* User made a mistake - should not continue */
+	if ((actual_fibsize != fibsize) && (actual_fibsize64 != fibsize)) {
+		dprintk((KERN_DEBUG"aacraid: Bad Size specified in "
+		  "Raw SRB command calculated fibsize=%lu;%lu "
+		  "user_srbcmd->sg.count=%d aac_srb=%lu sgentry=%lu;%lu "
+		  "issued fibsize=%d\n",
+		  actual_fibsize, actual_fibsize64, user_srbcmd->sg.count,
+		  sizeof(struct aac_srb), sizeof(struct sgentry),
+		  sizeof(struct sgentry64), fibsize));
+		rcode = -EINVAL;
+		goto cleanup;
+	}
+	if ((data_dir == DMA_NONE) && user_srbcmd->sg.count) {
+		dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
+		rcode = -EINVAL;
+		goto cleanup;
+	}
+	byte_count = 0;
+	if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
 		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
 		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
-		struct user_sgmap* usg;
-		byte_count = 0;
 
 		/*
 		 * This should also catch if user used the 32 bit sgmap
 		 */
-		actual_fibsize = sizeof(struct aac_srb) - 
-			sizeof(struct sgentry) +
-			((upsg->count & 0xff) * 
-		 	sizeof(struct sgentry));
-		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
-			dprintk((KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n"));
-			rcode = -EINVAL;
-			goto cleanup;
-		}
-		usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
-		  + sizeof(struct sgmap), GFP_KERNEL);
-		if (!usg) {
-			dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
-			rcode = -ENOMEM;
-			goto cleanup;
-		}
-		memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
-		  + sizeof(struct sgmap));
-		actual_fibsize = sizeof(struct aac_srb) - 
-			sizeof(struct sgentry) + ((usg->count & 0xff) * 
-			 	sizeof(struct sgentry64));
-		if ((data_dir == DMA_NONE) && upsg->count) {
-			kfree (usg);
-			dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
-			rcode = -EINVAL;
-			goto cleanup;
-		}
+		if (actual_fibsize64 == fibsize) {
+			actual_fibsize = actual_fibsize64;
+			for (i = 0; i < upsg->count; i++) {
+				u64 addr;
+				void* p;
+				/* Does this really need to be GFP_DMA? */
+				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+				if(p == 0) {
+					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					  upsg->sg[i].count,i,upsg->count));
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				addr = (u64)upsg->sg[i].addr[0];
+				addr += ((u64)upsg->sg[i].addr[1]) << 32;
+				sg_user[i] = (void __user *)(ptrdiff_t)addr;
+				sg_list[i] = p; // save so we can clean up later
+				sg_indx = i;
+
+				if( flags & SRB_DataOut ){
+					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
+						rcode = -EFAULT;
+						goto cleanup;
+					}
+				}
+				addr = pci_map_single(dev->pdev, p, upsg->sg[i].count, data_dir);
 
-		for (i = 0; i < usg->count; i++) {
-			u64 addr;
-			void* p;
-			/* Does this really need to be GFP_DMA? */
-			p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
-			if(p == 0) {
-				kfree (usg);
-				dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				  usg->sg[i].count,i,usg->count));
+				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
+				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
+				byte_count += upsg->sg[i].count;
+				psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);
+			}
+		} else {
+			struct user_sgmap* usg;
+			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
+			  + sizeof(struct sgmap), GFP_KERNEL);
+			if (!usg) {
+				dprintk((KERN_DEBUG"aacraid: Allocation error in Raw SRB command\n"));
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)(long)usg->sg[i].addr;
-			sg_list[i] = p; // save so we can clean up later
-			sg_indx = i;
-
-			if( flags & SRB_DataOut ){
-				if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+			memcpy (usg, upsg, actual_fibsize - sizeof(struct aac_srb)
+			  + sizeof(struct sgmap));
+			actual_fibsize = actual_fibsize64;
+
+			for (i = 0; i < usg->count; i++) {
+				u64 addr;
+				void* p;
+				/* Does this really need to be GFP_DMA? */
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+				if(p == 0) {
 					kfree (usg);
-					dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n")); 
-					rcode = -EFAULT;
+					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					  usg->sg[i].count,i,usg->count));
+					rcode = -ENOMEM;
 					goto cleanup;
 				}
-			}
-			addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+				sg_user[i] = (void __user *)(ptrdiff_t)usg->sg[i].addr;
+				sg_list[i] = p; // save so we can clean up later
+				sg_indx = i;
+
+				if( flags & SRB_DataOut ){
+					if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
+						kfree (usg);
+						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
+						rcode = -EFAULT;
+						goto cleanup;
+					}
+				}
+				addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
 
-			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
-			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
-			psg->sg[i].count = cpu_to_le32(usg->sg[i].count);  
-			byte_count += usg->sg[i].count;
+				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
+				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
+				byte_count += usg->sg[i].count;
+				psg->sg[i].count = cpu_to_le32(usg->sg[i].count);
+			}
+			kfree (usg);
 		}
-		kfree (usg);
-
 		srbcmd->count = cpu_to_le32(byte_count);
 		psg->count = cpu_to_le32(sg_indx+1);
 		status = aac_fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
 	} else {
 		struct user_sgmap* upsg = &user_srbcmd->sg;
 		struct sgmap* psg = &srbcmd->sg;
-		byte_count = 0;
 
-		actual_fibsize = sizeof (struct aac_srb) + (((user_srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
-		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
-			dprintk((KERN_DEBUG"aacraid: Bad Size specified in "
-			  "Raw SRB command calculated fibsize=%d "
-			  "user_srbcmd->sg.count=%d aac_srb=%d sgentry=%d "
-			  "issued fibsize=%d\n",
-			  actual_fibsize, user_srbcmd->sg.count,
-			  sizeof(struct aac_srb), sizeof(struct sgentry),
-			  fibsize));
-			rcode = -EINVAL;
-			goto cleanup;
-		}
-		if ((data_dir == DMA_NONE) && upsg->count) {
-			dprintk((KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n"));
-			rcode = -EINVAL;
-			goto cleanup;
-		}
-		for (i = 0; i < upsg->count; i++) {
-			dma_addr_t addr; 
-			void* p;
-			p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
-			if(p == 0) {
-				dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				  upsg->sg[i].count, i, upsg->count));
-				rcode = -ENOMEM;
-				goto cleanup;
-			}
-			sg_user[i] = (void __user *)(long)upsg->sg[i].addr;
-			sg_list[i] = p; // save so we can clean up later
-			sg_indx = i;
-
-			if( flags & SRB_DataOut ){
-				if(copy_from_user(p, sg_user[i],
-						upsg->sg[i].count)) {
-					dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n")); 
-					rcode = -EFAULT;
+		if (actual_fibsize64 == fibsize) {
+			struct user_sgmap64* usg = (struct user_sgmap64 *)upsg;
+			for (i = 0; i < upsg->count; i++) {
+				u64 addr;
+				void* p;
+				/* Does this really need to be GFP_DMA? */
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+				if(p == 0) {
+					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					  usg->sg[i].count,i,usg->count));
+					rcode = -ENOMEM;
 					goto cleanup;
 				}
+				addr = (u64)usg->sg[i].addr[0];
+				addr += ((u64)usg->sg[i].addr[1]) << 32;
+				sg_user[i] = (void __user *)(ptrdiff_t)addr;
+				sg_list[i] = p; // save so we can clean up later
+				sg_indx = i;
+
+				if( flags & SRB_DataOut ){
+					if(copy_from_user(p,sg_user[i],usg->sg[i].count)){
+						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
+						rcode = -EFAULT;
+						goto cleanup;
+					}
+				}
+				addr = pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+
+				psg->sg[i].addr = cpu_to_le32(addr & 0xffffffff);
+				byte_count += usg->sg[i].count;
+				psg->sg[i].count = cpu_to_le32(usg->sg[i].count);
 			}
-			addr = pci_map_single(dev->pdev, p,
-				upsg->sg[i].count, data_dir);
+		} else {
+			for (i = 0; i < upsg->count; i++) {
+				dma_addr_t addr;
+				void* p;
+				p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
+				if(p == 0) {
+					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					  upsg->sg[i].count, i, upsg->count));
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				sg_user[i] = (void __user *)(ptrdiff_t)upsg->sg[i].addr;
+				sg_list[i] = p; // save so we can clean up later
+				sg_indx = i;
+
+				if( flags & SRB_DataOut ){
+					if(copy_from_user(p, sg_user[i],
+							upsg->sg[i].count)) {
+						dprintk((KERN_DEBUG"aacraid: Could not copy sg data from user\n"));
+						rcode = -EFAULT;
+						goto cleanup;
+					}
+				}
+				addr = pci_map_single(dev->pdev, p,
+					upsg->sg[i].count, data_dir);
 
-			psg->sg[i].addr = cpu_to_le32(addr);
-			psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);  
-			byte_count += upsg->sg[i].count;
+				psg->sg[i].addr = cpu_to_le32(addr);
+				byte_count += upsg->sg[i].count;
+				psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);
+			}
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
 		psg->count = cpu_to_le32(sg_indx+1);
@@ -689,7 +743,8 @@ static int aac_send_raw_srb(struct aac_d
 
 	if( flags & SRB_DataIn ) {
 		for(i = 0 ; i <= sg_indx; i++){
-			byte_count = le32_to_cpu((dev->dac_support == 1)
+			byte_count = le32_to_cpu(
+			  (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)
 			      ? ((struct sgmap64*)&srbcmd->sg)->sg[i].count
 			      : srbcmd->sg.sg[i].count);
 			if(copy_to_user(sg_user[i], sg_list[i], byte_count)){

-- 
Mark Haverkamp <markh@linux-foundation.org>

