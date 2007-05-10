From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 16:45:35 +0900
Message-ID: <20070510164535F.fujita.tomonori@lab.ntt.co.jp>
References: <1178722514.3695.23.camel@mulgrave.il.steeleye.com>
	<4641FCC8.4040600@panasas.com>
	<20070510155322R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:49258 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbXEJHqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 03:46:17 -0400
In-Reply-To: <20070510155322R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 15:53:22 +0900

> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: Re: [PATCH v2] add bidi support for block pc requests
> Date: Wed, 09 May 2007 19:54:32 +0300
> 
> > James Bottomley wrote:
> > > Actually, the first order of business is to use accessors on the command
> > > pointers in the drivers to free them from the internal layout of the
> > > structure (and where it is allocated).
> > > 
> > Thanks! I totally second that. Let me look into my old patches and come
> > up with all the needed accessors. I hope 3-5 will be enough.
> > I will send some suggestions tomorrow.
> > > 
> > > No, that's why you do the accessors.  Convert all of the common drivers
> > > to accessors on the current structure, then throw the switch to convert
> > > to the new structure (whatever form is finally settled on).  Then any
> > > unconverted drivers break and people fix the ones they care about.
> > 
> > Last time I was able to compile 97% of drivers and convert by search-and-replace
> > the rest. Not a huge deal.
> 
> We need to remove the non-use-sg code in the drivers and convert
> them. So it's a bit more complicated than search-and-replace.

Here's a patch to convert ibmvscsi to use helper functions (though it
needs more testings).

---
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index fbc1d5c..fb764ff 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -353,20 +353,18 @@ static void unmap_cmd_data(struct srp_cm
 	}
 }
 
-static int map_sg_list(int num_entries, 
-		       struct scatterlist *sg,
-		       struct srp_direct_buf *md)
+static int map_sg_list(struct scsi_cmnd *cmd, int nseg, struct srp_direct_buf *md)
 {
 	int i;
+	struct scatterlist *sg;
 	u64 total_length = 0;
 
-	for (i = 0; i < num_entries; ++i) {
+	scsi_for_each_sg(cmd, nseg, i) {
 		struct srp_direct_buf *descr = md + i;
-		struct scatterlist *sg_entry = &sg[i];
-		descr->va = sg_dma_address(sg_entry);
-		descr->len = sg_dma_len(sg_entry);
+		descr->va = sg_dma_address(sg);
+		descr->len = sg_dma_len(sg);
 		descr->key = 0;
-		total_length += sg_dma_len(sg_entry);
+		total_length += sg_dma_len(sg);
  	}
 	return total_length;
 }
@@ -384,43 +382,39 @@ static int map_sg_data(struct scsi_cmnd
 		       struct srp_event_struct *evt_struct,
 		       struct srp_cmd *srp_cmd, struct device *dev)
 {
-
 	int sg_mapped;
 	u64 total_length = 0;
-	struct scatterlist *sg = cmd->request_buffer;
 	struct srp_direct_buf *data =
 		(struct srp_direct_buf *) srp_cmd->add_data;
 	struct srp_indirect_buf *indirect =
 		(struct srp_indirect_buf *) data;
 
-	sg_mapped = dma_map_sg(dev, sg, cmd->use_sg, DMA_BIDIRECTIONAL);
-
-	if (sg_mapped == 0)
+	sg_mapped = scsi_dma_map(dev, cmd);
+	if (!sg_mapped)
+		return 1;
+	else if (sg_mapped < 0)
 		return 0;
+	else if (sg_mapped > SG_ALL) {
+		printk(KERN_ERR
+		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
+		       SG_ALL, sg_mapped);
+		return 0;
+	}
 
 	set_srp_direction(cmd, srp_cmd, sg_mapped);
 
 	/* special case; we can use a single direct descriptor */
 	if (sg_mapped == 1) {
-		data->va = sg_dma_address(&sg[0]);
-		data->len = sg_dma_len(&sg[0]);
-		data->key = 0;
+		map_sg_list(cmd, sg_mapped, data);
 		return 1;
 	}
 
-	if (sg_mapped > SG_ALL) {
-		printk(KERN_ERR
-		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
-		       SG_ALL, sg_mapped);
-		return 0;
-	}
-
 	indirect->table_desc.va = 0;
 	indirect->table_desc.len = sg_mapped * sizeof(struct srp_direct_buf);
 	indirect->table_desc.key = 0;
 
 	if (sg_mapped <= MAX_INDIRECT_BUFS) {
-		total_length = map_sg_list(sg_mapped, sg,
+		total_length = map_sg_list(cmd, sg_mapped,
 					   &indirect->desc_list[0]);
 		indirect->len = total_length;
 		return 1;
@@ -429,61 +423,27 @@ static int map_sg_data(struct scsi_cmnd
 	/* get indirect table */
 	if (!evt_struct->ext_list) {
 		evt_struct->ext_list = (struct srp_direct_buf *)
-			dma_alloc_coherent(dev, 
+			dma_alloc_coherent(dev,
 					   SG_ALL * sizeof(struct srp_direct_buf),
 					   &evt_struct->ext_list_token, 0);
 		if (!evt_struct->ext_list) {
 			printk(KERN_ERR
 			       "ibmvscsi: Can't allocate memory for indirect table\n");
 			return 0;
-			
 		}
 	}
 
-	total_length = map_sg_list(sg_mapped, sg, evt_struct->ext_list);	
+	total_length = map_sg_list(cmd, sg_mapped, evt_struct->ext_list);
 
 	indirect->len = total_length;
 	indirect->table_desc.va = evt_struct->ext_list_token;
 	indirect->table_desc.len = sg_mapped * sizeof(indirect->desc_list[0]);
 	memcpy(indirect->desc_list, evt_struct->ext_list,
 	       MAX_INDIRECT_BUFS * sizeof(struct srp_direct_buf));
-	
  	return 1;
 }
 
 /**
- * map_single_data: - Maps memory and initializes memory decriptor fields
- * @cmd:	struct scsi_cmnd with the memory to be mapped
- * @srp_cmd:	srp_cmd that contains the memory descriptor
- * @dev:	device for which to map dma memory
- *
- * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
- * Returns 1 on success.
-*/
-static int map_single_data(struct scsi_cmnd *cmd,
-			   struct srp_cmd *srp_cmd, struct device *dev)
-{
-	struct srp_direct_buf *data =
-		(struct srp_direct_buf *) srp_cmd->add_data;
-
-	data->va =
-		dma_map_single(dev, cmd->request_buffer,
-			       cmd->request_bufflen,
-			       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(data->va)) {
-		printk(KERN_ERR
-		       "ibmvscsi: Unable to map request_buffer for command!\n");
-		return 0;
-	}
-	data->len = cmd->request_bufflen;
-	data->key = 0;
-
-	set_srp_direction(cmd, srp_cmd, 1);
-
-	return 1;
-}
-
-/**
  * map_data_for_srp_cmd: - Calls functions to map data for srp cmds
  * @cmd:	struct scsi_cmnd with the memory to be mapped
  * @srp_cmd:	srp_cmd that contains the memory descriptor
@@ -513,11 +473,7 @@ static int map_data_for_srp_cmd(struct s
 		return 0;
 	}
 
-	if (!cmd->request_buffer)
-		return 1;
-	if (cmd->use_sg)
-		return map_sg_data(cmd, evt_struct, srp_cmd, dev);
-	return map_single_data(cmd, srp_cmd, dev);
+	return map_sg_data(cmd, evt_struct, srp_cmd, dev);
 }
 
 /* ------------------------------------------------------------
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9f7482d..dd6fdf6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2292,3 +2292,29 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
+{
+	int nseg = 0;
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *) cmd->request_buffer;
+
+		nseg = dma_map_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			return -ENOMEM;
+	}
+	return nseg;
+}
+EXPORT_SYMBOL(scsi_dma_map);
+
+void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd)
+{
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *) cmd->request_buffer;
+		dma_unmap_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
+	}
+}
+EXPORT_SYMBOL(scsi_dma_unmap);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d6948d0..799f204 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -138,4 +138,17 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+extern int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd);
+extern void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd);
+
+/* moved to scatterlist.h after chaining sg */
+#define sg_next(sg) ((sg) + 1)
+
+#define scsi_for_each_sg(cmd, nseg, i)					\
+	for (i = 0, sg = (cmd)->request_buffer; i < nseg;		\
+		sg = sg_next(sg), i++)					\
+
+#define scsi_sg_count(cmd) ((cmd)->use_sg)
+#define scsi_bufferlen(cmd) ((cmd)->request_bufflen)
+
 #endif /* _SCSI_SCSI_CMND_H */
