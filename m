Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190C190664
	for <linux-scsi@vger.kernel.org>; Sat, 11 Oct 2025 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760177130; cv=none; b=WCTC06Djj6r+sryQXLcUciIjRg7aJhAwX+cxVunt0SpZRVqYcvYNWDQ3rZx2piNTXpootqEb7AfkjGpPWDXQ/Tj/hELEfOmgSaV4tOrkF2PBcuinxeXcJIHJWxAbk7R06m5po4vo1b+E0+dQ32KY4Txnrei6fMUoeSMmEGIhdAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760177130; c=relaxed/simple;
	bh=yD7RQeZGhHxZZG7dRcZTyZ46jmCy1pYpkl90r+yN++A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ues5Pt++G8REg/XdC+K8+rXdTQkNCHiOhwEzhGFcxoQZe+cDIWCulfYqq7j7IDZjIh7UIfEjdEsaD9Q/inigIItSwu2U9emJW8gjjjyzoLbim5I1EOrQq5hUJv0IByzcu6SFD0AL/M0b3BzCwW8JAWAa9D+AS7LNjLqx2GaGkaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y89WU1Nt; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y89WU1Nt"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3fc36b99e92so2760101f8f.0
        for <linux-scsi@vger.kernel.org>; Sat, 11 Oct 2025 03:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760177123; x=1760781923; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXYaUmEOzuGL83duQA4oeQUvQii86pnI5j6WSpb5AXg=;
        b=Y89WU1Nt3v0dpsDLjnTv69WOJFVC05Knoiwt4dHQS8nwp2CsLOqvWNsk36RNaEdWIT
         bDKVm5VjmJMtW8fs0NcV10ilc3OZL5HRlkqppS5hEzzcPMRJkM1apEPYAjCcie/jYuw6
         nKm5stq3PKE8BX1KuD0sLRBQm3vvzdJGKE14LyytyKxlWnV8bHT7ivHSAvukyLnD7tLP
         /NEZidtIj+UI+fBxG+lkNLqMS83wmQyMDNAlo6igWvKAa23DIsrssDv23BT3mhCf1qYD
         ckpYNxwHVJdhgbuJXN1KKlV6hw8gTYjXRiUbQY5FWG3iiTMRnhXFSgw65GANb1AlTDN5
         wl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760177123; x=1760781923;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXYaUmEOzuGL83duQA4oeQUvQii86pnI5j6WSpb5AXg=;
        b=PEN24SIp5rs100LnCZd0do/lzZJ+v7t/0zKcoHrHBUoZlGEJx2zNLn1cJ+UY4MCXbH
         uEBUruJ62FFqJXMGynSiIYdkxbdKEZjhmK5c9B2uv4oarNOmSb4sHHbmPnwr6es/c4e9
         DKzttdKMl9rtX5InhpWLyu/gmrXYV79cj6OCXNrcKRe675E/C9E2rcN2YQP7RrtmOt6N
         ENdLo8+uDwepFXvNbYNYShZXbnV9bZNssqdKhcJSxhD+n8ZLxl9u4ngHi/i6yq3/DKx1
         l9RU4FYP8bk4h0YA1DS4S/amog02RGLg4pG4s5nhvuvapWA3796ELJzci0z3DJeIImFh
         7aAA==
X-Forwarded-Encrypted: i=1; AJvYcCVKEcJZpnB4vBUkaermE8n9lsqnN+w21Sz16d+NEeEDzaBrkz7hbhaYKvWOtW5iWdrjFEYPvFpLz+5X@vger.kernel.org
X-Gm-Message-State: AOJu0YykItPrC7NnW3QVoCeAtBQNz/WkItSw22vxV+vEwRM+BEjSIJGn
	WABWvx77HglVRBUBXMBwPSXmmojt/Ip/ErhnRy75BuHcyPKBGmuaFoCA
X-Gm-Gg: ASbGncufJVinujmT4W8R9tiKbvgD5XHUEmKCi0rwTYvumCGKX6wLgJUeMCCURQ/DMuI
	y5XLcv6IqhctdDHeOi5Feo8FvpkmkIpBMbRcJQRwrc5taK/yyOfkDi4LC1pCPZTx2KJF3omL6zj
	YGBpYPBgcyWUDSdQ54u7vsB9unyP3ToRo97287zw0ibAQfso2HPn7lTJzBR/6Am5h0nSZNNNbv7
	qTyWAA91c6YQjhxW1TnoncVVUhBuIbYb79tXx4bP0NvMnzAN0RSKjkKzioNX+CJxuoOzqKT4+uc
	8wD/RXtr9gzju++YoB5VWQuh6A/q8b0Cl808P+ZudKU/7UPZGuwjcZiyIxpgwvL3hqw4eJkCZIK
	bAkxhUCwFzQRlhf4lYHq9IOSgWGxdkubgA0/5SW+DpnjjaqIwAmGY+IlTjVHfRPH+j9uPMJ4q8p
	kSOAfkKCxJs0X3
X-Google-Smtp-Source: AGHT+IED+xW+ElM2Jk98y4tVQY3+aEOn3kG6bLSCsaiJiU9WRcJ/Fl4ROiHdoOx3iLBNRTWKdp4WQg==
X-Received: by 2002:a05:6000:2dc7:b0:3fa:ebaf:4c53 with SMTP id ffacd0b85a97d-42582a055f0mr12786285f8f.29.1760177122484;
        Sat, 11 Oct 2025 03:05:22 -0700 (PDT)
Received: from michalis-linux (adsl-75.176.58.251.tellas.gr. [176.58.251.75])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57cc0esm8322319f8f.6.2025.10.11.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 03:05:21 -0700 (PDT)
Date: Sat, 11 Oct 2025 13:05:21 +0300
From: Michail Tatas <michail.tatas@gmail.com>
To: vishal.bhakta@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: bcm-kernel-feedback-list@broadcom.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: scsi: vmw_pvscsi: fix license+checkpatch warnings
Message-ID: <aOor4Y2zzTBLr5NA@michalis-linux>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As suggested by checkpatch
  Fix licence by adding GPL and removing the address of the Free Software Foundation
  Changed unsigned -> unsigned int
  Added some newlines

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
---
 drivers/scsi/vmw_pvscsi.c | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 32242d86cf5b..6091777dd37b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Linux driver for VMware's para-virtualized SCSI HBA.
  *
@@ -12,11 +13,6 @@
  * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  * NON INFRINGEMENT.  See the GNU General Public License for more
  * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
  */
 
 #include <linux/kernel.h>
@@ -76,16 +72,16 @@ struct pvscsi_adapter {
 	struct work_struct		work;
 
 	struct PVSCSIRingReqDesc	*req_ring;
-	unsigned			req_pages;
-	unsigned			req_depth;
+	unsigned int		req_pages;
+	unsigned int		req_depth;
 	dma_addr_t			reqRingPA;
 
 	struct PVSCSIRingCmpDesc	*cmp_ring;
-	unsigned			cmp_pages;
+	unsigned int		cmp_pages;
 	dma_addr_t			cmpRingPA;
 
 	struct PVSCSIRingMsgDesc	*msg_ring;
-	unsigned			msg_pages;
+	unsigned int		msg_pages;
 	dma_addr_t			msgRingPA;
 
 	struct PVSCSIRingsState		*rings_state;
@@ -325,9 +321,9 @@ static void ll_device_reset(const struct pvscsi_adapter *adapter, u32 target)
 }
 
 static void pvscsi_create_sg(struct pvscsi_ctx *ctx,
-			     struct scatterlist *sg, unsigned count)
+			     struct scatterlist *sg, unsigned int count)
 {
-	unsigned i;
+	unsigned int i;
 	struct PVSCSISGElement *sge;
 
 	BUG_ON(count > PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT);
@@ -348,8 +344,8 @@ static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 			      struct pvscsi_ctx *ctx, struct scsi_cmnd *cmd,
 			      struct PVSCSIRingReqDesc *e)
 {
-	unsigned count;
-	unsigned bufflen = scsi_bufflen(cmd);
+	unsigned int count;
+	unsigned int bufflen = scsi_bufflen(cmd);
 	struct scatterlist *sg;
 
 	e->dataLen = bufflen;
@@ -415,13 +411,13 @@ static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
 				 struct pvscsi_ctx *ctx)
 {
 	struct scsi_cmnd *cmd;
-	unsigned bufflen;
+	unsigned int bufflen;
 
 	cmd = ctx->cmd;
 	bufflen = scsi_bufflen(cmd);
 
 	if (bufflen != 0) {
-		unsigned count = scsi_sg_count(cmd);
+		unsigned int count = scsi_sg_count(cmd);
 
 		if (count != 0) {
 			scsi_dma_unmap(cmd);
@@ -487,7 +483,7 @@ static void pvscsi_setup_all_rings(const struct pvscsi_adapter *adapter)
 {
 	struct PVSCSICmdDescSetupRings cmd = { 0 };
 	dma_addr_t base;
-	unsigned i;
+	unsigned int i;
 
 	cmd.ringsStatePPN   = adapter->ringStatePA >> PAGE_SHIFT;
 	cmd.reqRingNumPages = adapter->req_pages;
@@ -877,11 +873,12 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
  */
 static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < adapter->req_depth; i++) {
 		struct pvscsi_ctx *ctx = &adapter->cmd_map[i];
 		struct scsi_cmnd *cmd = ctx->cmd;
+
 		if (cmd) {
 			scmd_printk(KERN_ERR, cmd,
 				    "Forced reset on cmd %p\n", cmd);
@@ -1037,15 +1034,15 @@ static void pvscsi_process_msg(const struct pvscsi_adapter *adapter,
 	struct Scsi_Host *host = adapter->host;
 	struct scsi_device *sdev;
 
-	printk(KERN_INFO "vmw_pvscsi: msg type: 0x%x - MSG RING: %u/%u (%u) \n",
+	printk(KERN_INFO "vmw_pvscsi: msg type: 0x%x - MSG RING: %u/%u (%u)\n",
 	       e->type, s->msgProdIdx, s->msgConsIdx, s->msgNumEntriesLog2);
 
 	BUILD_BUG_ON(PVSCSI_MSG_LAST != 2);
 
 	if (e->type == PVSCSI_MSG_DEV_ADDED) {
 		struct PVSCSIMsgDescDevStatusChanged *desc;
-		desc = (struct PVSCSIMsgDescDevStatusChanged *)e;
 
+		desc = (struct PVSCSIMsgDescDevStatusChanged *)e;
 		printk(KERN_INFO
 		       "vmw_pvscsi: msg: device added at scsi%u:%u:%u\n",
 		       desc->bus, desc->target, desc->lun[1]);
@@ -1065,6 +1062,7 @@ static void pvscsi_process_msg(const struct pvscsi_adapter *adapter,
 		scsi_host_put(host);
 	} else if (e->type == PVSCSI_MSG_DEV_REMOVED) {
 		struct PVSCSIMsgDescDevStatusChanged *desc;
+
 		desc = (struct PVSCSIMsgDescDevStatusChanged *)e;
 
 		printk(KERN_INFO
@@ -1164,6 +1162,7 @@ static bool pvscsi_setup_req_threshold(struct pvscsi_adapter *adapter,
 		return false;
 	} else {
 		struct PVSCSICmdDescSetupReqCall cmd_msg = { 0 };
+
 		cmd_msg.enable = enable;
 		printk(KERN_INFO
 		       "vmw_pvscsi: %sabling reqCallThreshold\n",
@@ -1204,7 +1203,7 @@ static irqreturn_t pvscsi_shared_isr(int irq, void *devp)
 static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 {
 	struct pvscsi_ctx *ctx = adapter->cmd_map;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < adapter->req_depth; ++i, ++ctx)
 		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
@@ -1328,7 +1327,7 @@ static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
 	header->hostStatus = BTSTAT_INVPARAM;
 	header->scsiStatus = SDSTAT_CHECK;
 
-	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_CONFIG, &cmd, sizeof cmd);
+	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_CONFIG, &cmd, sizeof(cmd));
 
 	if (header->hostStatus == BTSTAT_SUCCESS &&
 	    header->scsiStatus == SDSTAT_GOOD) {
@@ -1489,6 +1488,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&adapter->cmd_pool);
 	for (i = 0; i < adapter->req_depth; i++) {
 		struct pvscsi_ctx *ctx = adapter->cmd_map + i;
+
 		list_add(&ctx->list, &adapter->cmd_pool);
 	}
 
-- 
2.43.0

