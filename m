From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/8]  qla2xxx: DMA pool/api usage
Date: Mon, 6 Sep 2004 21:27:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042733.GA29585@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:50367 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267565AbUIGE3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:29:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1873 04/09/06 11:34:15 andrew.vasquez@qlogic.com +4 -0
  Rework driver DMA allocations to use the DMA pool APIs
  to minimize potential run-time allocation failures.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h  |   32 ++++-
 drivers/scsi/qla2xxx/qla_init.c |  100 +++++-------------
 drivers/scsi/qla2xxx/qla_mbx.c  |   25 ++--
 drivers/scsi/qla2xxx/qla_os.c   |  218 +++++++++++++++++++++++++---------------
 4 files changed, 206 insertions(+), 169 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:07:20 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:07:20 -07:00
@@ -26,8 +26,10 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/pci.h>
+#include <linux/dma-mapping.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/dmapool.h>
 #include <linux/mempool.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
@@ -2029,6 +2031,16 @@
 	struct qla_fw_info *fw_info;
 };
 
+/* Return data from MBC_GET_ID_LIST call. */
+struct gid_list_info {
+	uint8_t	al_pa;
+	uint8_t	area;
+	uint8_t	domain;		
+	uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
+	uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
+};
+#define GID_LIST_SIZE (sizeof(struct gid_list_info) * MAX_FIBRE_DEVICES)
+
 /*
  * Linux Host Adapter structure
  */
@@ -2240,8 +2252,6 @@
 
 	struct io_descriptor	io_descriptors[MAX_IO_DESCRIPTORS];
 	uint16_t		iodesc_signature;
-	port_database_t		*iodesc_pd;
-	dma_addr_t		iodesc_pd_dma;
 
 	/* OS target queue pointers. */
 	os_tgt_t		*otgt[MAX_FIBRE_DEVICES];
@@ -2276,10 +2286,22 @@
 	uint32_t        timer_active;
 	struct timer_list        timer;
 
-	/* Firmware Initialization Control Block data */
-	dma_addr_t	init_cb_dma;         /* Physical address. */
+	dma_addr_t	gid_list_dma;
+	struct gid_list_info *gid_list;
+
+	dma_addr_t	rlc_rsp_dma;
+	rpt_lun_cmd_rsp_t *rlc_rsp;
+
+	/* Small DMA pool allocations -- maximum 256 bytes in length. */ 
+#define DMA_POOL_SIZE	256
+	struct dma_pool *s_dma_pool;
+
+	dma_addr_t	init_cb_dma;
 	init_cb_t       *init_cb;
-  
+
+	dma_addr_t	iodesc_pd_dma;
+	port_database_t *iodesc_pd;
+
 	/* These are used by mailbox operations. */
 	volatile uint16_t mailbox_out[MAILBOX_REGISTER_COUNT];
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:20 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:20 -07:00
@@ -51,8 +51,7 @@
 static void qla2x00_lun_discovery(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_rpt_lun_discovery(scsi_qla_host_t *, fc_port_t *,
     inq_cmd_rsp_t *, dma_addr_t);
-static int qla2x00_report_lun(scsi_qla_host_t *, fc_port_t *,
-    rpt_lun_cmd_rsp_t *, dma_addr_t);
+static int qla2x00_report_lun(scsi_qla_host_t *, fc_port_t *);
 static fc_lun_t *qla2x00_cfg_lun(scsi_qla_host_t *, fc_port_t *, uint16_t,
     inq_cmd_rsp_t *, dma_addr_t);
 static fc_lun_t * qla2x00_add_lun(fc_port_t *, uint16_t);
@@ -690,8 +689,9 @@
 		return;
 
 	/* Attempt to claim larger area for request queue. */
-	request_ring = pci_alloc_consistent(ha->pdev,
-	    (request_q_length + 1) * sizeof(request_t), &request_dma);
+	request_ring = dma_alloc_coherent(&ha->pdev->dev,
+	    (request_q_length + 1) * sizeof(request_t), &request_dma,
+	    GFP_KERNEL);
 	if (request_ring == NULL)
 		return;
 
@@ -702,7 +702,7 @@
 	    "(%d -> %d)...\n", ha->request_q_length, request_q_length);
 
 	/* Clear old allocations. */
-	pci_free_consistent(ha->pdev,
+	dma_free_coherent(&ha->pdev->dev,
 	    (ha->request_q_length + 1) * sizeof(request_t), ha->request_ring,
 	    ha->request_dma);
 
@@ -1711,50 +1711,28 @@
 
 	uint16_t	index;
 	uint16_t	entries;
-	struct dev_id {
-		uint8_t	al_pa;
-		uint8_t	area;
-		uint8_t	domain;		
-		uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
-		uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
-	} *id_list;
-#define MAX_ID_LIST_SIZE (sizeof(struct dev_id) * MAX_FIBRE_DEVICES)
-	dma_addr_t	id_list_dma;
 	char		*id_iter;
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
 
 	found_devs = 0;
 	new_fcport = NULL;
-
 	entries = MAX_FIBRE_DEVICES;
-	id_list = pci_alloc_consistent(ha->pdev, MAX_ID_LIST_SIZE,
-	    &id_list_dma);
-	if (id_list == NULL) {
-		DEBUG2(printk("scsi(%ld): Failed to allocate memory, No local "
-		    "loop\n", ha->host_no));
-
-		qla_printk(KERN_WARNING, ha,
-		    "Memory Allocation failed - port_list");
-
-		ha->mem_err++;
-		return (QLA_MEMORY_ALLOC_FAILED);
-	}
-	memset(id_list, 0, MAX_ID_LIST_SIZE);
 
 	DEBUG3(printk("scsi(%ld): Getting FCAL position map\n", ha->host_no));
 	DEBUG3(qla2x00_get_fcal_position_map(ha, NULL));
 
 	/* Get list of logged in devices. */
-	rval = qla2x00_get_id_list(ha, id_list, id_list_dma, &entries);
-	if (rval != QLA_SUCCESS) {
+	memset(ha->gid_list, 0, GID_LIST_SIZE);
+	rval = qla2x00_get_id_list(ha, ha->gid_list, ha->gid_list_dma,
+	    &entries);
+	if (rval != QLA_SUCCESS)
 		goto cleanup_allocation;
-	}
 
 	DEBUG3(printk("scsi(%ld): Entries in ID list (%d)\n",
 	    ha->host_no, entries));
-	DEBUG3(qla2x00_dump_buffer((uint8_t *)id_list,
-	    entries * sizeof(struct dev_id)));
+	DEBUG3(qla2x00_dump_buffer((uint8_t *)ha->gid_list,
+	    entries * sizeof(struct gid_list_info)));
 
 	/* Allocate temporary fcport for any new fcports discovered. */
 	new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
@@ -1782,18 +1760,18 @@
 	}
 
 	/* Add devices to port list. */
-	id_iter = (char *)id_list;
+	id_iter = (char *)ha->gid_list;
 	for (index = 0; index < entries; index++) {
-		domain = ((struct dev_id *)id_iter)->domain;
-		area = ((struct dev_id *)id_iter)->area;
-		al_pa = ((struct dev_id *)id_iter)->al_pa;
+		domain = ((struct gid_list_info *)id_iter)->domain;
+		area = ((struct gid_list_info *)id_iter)->area;
+		al_pa = ((struct gid_list_info *)id_iter)->al_pa;
 		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-			loop_id =
-			    (uint16_t)((struct dev_id *)id_iter)->loop_id_2100;
+			loop_id = (uint16_t)
+			    ((struct gid_list_info *)id_iter)->loop_id_2100;
 			id_iter += 4;
 		} else {
-			loop_id =
-			    le16_to_cpu(((struct dev_id *)id_iter)->loop_id);
+			loop_id = le16_to_cpu(
+			    ((struct gid_list_info *)id_iter)->loop_id);
 			id_iter += 6;
 		}
 
@@ -1864,8 +1842,6 @@
 	}
 
 cleanup_allocation:
-	pci_free_consistent(ha->pdev, MAX_ID_LIST_SIZE, id_list, id_list_dma);
-
 	if (new_fcport)
 		kfree(new_fcport);
 
@@ -1973,7 +1949,7 @@
 	dma_addr_t	inq_dma;
 	uint16_t	lun;
 
-	inq = pci_alloc_consistent(ha->pdev, sizeof(inq_cmd_rsp_t), &inq_dma);
+	inq = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &inq_dma);
 	if (inq == NULL) {
 		qla_printk(KERN_WARNING, ha,
 		    "Memory Allocation failed - INQ\n");
@@ -1989,7 +1965,7 @@
 		}
 	}
 
-	pci_free_consistent(ha->pdev, sizeof(inq_cmd_rsp_t), inq, inq_dma);
+	dma_pool_free(ha->s_dma_pool, inq, inq_dma);
 }
 
 /*
@@ -2013,8 +1989,6 @@
 	int			rval;
 	uint32_t		len, cnt;
 	uint16_t		lun;
-	rpt_lun_cmd_rsp_t	*rlc;
-	dma_addr_t		rlc_dma;
 
 	/* Assume a failed status */
 	rval = QLA_FUNCTION_FAILED;
@@ -2023,30 +1997,19 @@
 	if ((fcport->flags & FCF_RLC_SUPPORT) == 0)
 		return (rval);
 
-	rlc = pci_alloc_consistent(ha->pdev, sizeof(rpt_lun_cmd_rsp_t),
-	    &rlc_dma);
-	if (rlc == NULL) {
-		qla_printk(KERN_WARNING, ha,
-			"Memory Allocation failed - RLC");
-		return QLA_MEMORY_ALLOC_FAILED;
-	}
-
-	rval = qla2x00_report_lun(ha, fcport, rlc, rlc_dma);
-	if (rval != QLA_SUCCESS) {
-		pci_free_consistent(ha->pdev, sizeof(rpt_lun_cmd_rsp_t), rlc,
-		    rlc_dma);
+	rval = qla2x00_report_lun(ha, fcport);
+	if (rval != QLA_SUCCESS)
 		return (rval);
-	}
 
 	/* Always add a fc_lun_t structure for lun 0 -- mid-layer requirement */
 	qla2x00_add_lun(fcport, 0);
 
 	/* Configure LUN list. */
-	len = be32_to_cpu(rlc->list.hdr.len);
+	len = be32_to_cpu(ha->rlc_rsp->list.hdr.len);
 	len /= 8;
 	for (cnt = 0; cnt < len; cnt++) {
-		lun = CHAR_TO_SHORT(rlc->list.lst[cnt].lsb,
-		    rlc->list.lst[cnt].msb.b);
+		lun = CHAR_TO_SHORT(ha->rlc_rsp->list.lst[cnt].lsb,
+		    ha->rlc_rsp->list.lst[cnt].msb.b);
 
 		DEBUG3(printk("scsi(%ld): RLC lun = (%d)\n", ha->host_no, lun));
 
@@ -2057,8 +2020,6 @@
 	}
 	atomic_set(&fcport->state, FCS_ONLINE);
 
-	pci_free_consistent(ha->pdev, sizeof(rpt_lun_cmd_rsp_t), rlc, rlc_dma);
-
 	return (rval);
 }
 
@@ -2069,8 +2030,6 @@
  * Input:
  *	ha:		adapter state pointer.
  *	fcport:		FC port structure pointer.
- *	mem:		pointer to dma memory object for report LUN IOCB
- *			packet.
  *
  * Returns:
  *	qla2x00 local function return status code.
@@ -2079,15 +2038,18 @@
  *	Kernel context.
  */
 static int
-qla2x00_report_lun(scsi_qla_host_t *ha,
-    fc_port_t *fcport, rpt_lun_cmd_rsp_t *rlc, dma_addr_t rlc_dma)
+qla2x00_report_lun(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	int rval;
 	uint16_t retries;
 	uint16_t comp_status;
 	uint16_t scsi_status;
+	rpt_lun_cmd_rsp_t *rlc;
+	dma_addr_t rlc_dma;
 
 	rval = QLA_FUNCTION_FAILED;
+	rlc = ha->rlc_rsp;
+	rlc_dma = ha->rlc_rsp_dma;
 
 	for (retries = 3; retries; retries--) {
 		memset(rlc, 0, sizeof(rpt_lun_cmd_rsp_t));
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	2004-09-06 12:07:20 -07:00
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	2004-09-06 12:07:20 -07:00
@@ -1403,7 +1403,7 @@
 	DEBUG11(printk("qla2x00_get_port_database(%ld): entered.\n",
 	    ha->host_no);)
 
-	pd = pci_alloc_consistent(ha->pdev, PORT_DATABASE_SIZE, &pd_dma);
+	pd = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &pd_dma);
 	if (pd  == NULL) {
 		DEBUG2_3_11(printk("qla2x00_get_port_database(%ld): **** "
 		    "Mem Alloc Failed ****", ha->host_no);)
@@ -1464,7 +1464,7 @@
 		fcport->port_type = FCT_TARGET;
 
 gpd_error_out:
-	pci_free_consistent(ha->pdev, PORT_DATABASE_SIZE, pd, pd_dma);
+	dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
@@ -1617,14 +1617,12 @@
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	link_stat_t *stat_buf;
-	dma_addr_t phys_address = 0;
-
+	dma_addr_t stat_buf_dma;
 
 	DEBUG11(printk("qla2x00_get_link_status(%ld): entered.\n",
 	    ha->host_no);)
 
-	stat_buf = pci_alloc_consistent(ha->pdev, sizeof(link_stat_t),
-	    &phys_address);
+	stat_buf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &stat_buf_dma);
 	if (stat_buf == NULL) {
 		DEBUG2_3_11(printk("qla2x00_get_link_status(%ld): Failed to "
 		    "allocate memory.\n", ha->host_no));
@@ -1641,10 +1639,10 @@
 	} else {
 		mcp->mb[1] = loop_id << 8;
 	}
-	mcp->mb[2] = MSW(phys_address);
-	mcp->mb[3] = LSW(phys_address);
-	mcp->mb[6] = MSW(MSD(phys_address));
-	mcp->mb[7] = LSW(MSD(phys_address));
+	mcp->mb[2] = MSW(stat_buf_dma);
+	mcp->mb[3] = LSW(stat_buf_dma);
+	mcp->mb[6] = MSW(MSD(stat_buf_dma));
+	mcp->mb[7] = LSW(MSD(stat_buf_dma));
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
@@ -1688,8 +1686,7 @@
 		rval = BIT_1;
 	}
 
-	pci_free_consistent(ha->pdev, sizeof(link_stat_t), stat_buf,
-	    phys_address);
+	dma_pool_free(ha->s_dma_pool, stat_buf, stat_buf_dma);
 
 	return rval;
 }
@@ -2409,7 +2406,7 @@
 	char *pmap;
 	dma_addr_t pmap_dma;
 
-	pmap = pci_alloc_consistent(ha->pdev, FCAL_MAP_SIZE, &pmap_dma);
+	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &pmap_dma);
 	if (pmap  == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): **** Mem Alloc Failed ****",
 		    __func__, ha->host_no));
@@ -2438,7 +2435,7 @@
 		if (pos_map)
 			memcpy(pos_map, pmap, FCAL_MAP_SIZE);
 	}
-	pci_free_consistent(ha->pdev, FCAL_MAP_SIZE, pmap, pmap_dma);
+	dma_pool_free(ha->s_dma_pool, pmap, pmap_dma);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:20 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:20 -07:00
@@ -1819,28 +1819,27 @@
 	 * assist in setting the proper dma mask.
 	 */
 	if (sizeof(dma_addr_t) > 4) {
-		/* Update our PCI device dma_mask for full 64 bits */
-		if (pci_set_dma_mask(ha->pdev, 0xffffffffffffffffULL) == 0) {
+		if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK) == 0) {
 			ha->flags.enable_64bit_addressing = 1;
 			ha->calc_request_entries = qla2x00_calc_iocbs_64;
 			ha->build_scsi_iocbs = qla2x00_build_scsi_iocbs_64;
 
 			if (pci_set_consistent_dma_mask(ha->pdev,
-			    0xffffffffffffffffULL)) {
+			    DMA_64BIT_MASK)) {
 				qla_printk(KERN_DEBUG, ha, 
 				    "Failed to set 64 bit PCI consistent mask; "
 				    "using 32 bit.\n");
 				pci_set_consistent_dma_mask(ha->pdev,
-				    0xffffffffULL);
+				    DMA_32BIT_MASK);
 			}
 		} else {
 			qla_printk(KERN_DEBUG, ha,
 			    "Failed to set 64 bit PCI DMA mask, falling back "
 			    "to 32 bit MASK.\n");
-			pci_set_dma_mask(ha->pdev, 0xffffffff);
+			pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
 		}
 	} else {
-		pci_set_dma_mask(ha->pdev, 0xffffffff);
+		pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
 	}
 }
 
@@ -2815,6 +2814,7 @@
 static uint8_t
 qla2x00_mem_alloc(scsi_qla_host_t *ha)
 {
+	char	name[16];
 	uint8_t   status = 1;
 	int	retry= 10;
 
@@ -2825,9 +2825,9 @@
 		 * bug where available mem is not allocated until after a
 		 * little delay and a retry.
 		 */
-		ha->request_ring = pci_alloc_consistent(ha->pdev,
-		    ((ha->request_q_length + 1) * (sizeof(request_t))),
-		    &ha->request_dma);
+		ha->request_ring = dma_alloc_coherent(&ha->pdev->dev,
+		    (ha->request_q_length + 1) * sizeof(request_t),
+		    &ha->request_dma, GFP_KERNEL);
 		if (ha->request_ring == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Memory Allocation failed - request_ring\n");
@@ -2839,9 +2839,9 @@
 			continue;
 		}
 
-		ha->response_ring = pci_alloc_consistent(ha->pdev,
-		    ((ha->response_q_length + 1) * (sizeof(response_t))),
-		    &ha->response_dma);
+		ha->response_ring = dma_alloc_coherent(&ha->pdev->dev,
+		    (ha->response_q_length + 1) * sizeof(response_t),
+		    &ha->response_dma, GFP_KERNEL);
 		if (ha->response_ring == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Memory Allocation failed - response_ring\n");
@@ -2853,9 +2853,49 @@
 			continue;
 		}
 
+		ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
+		    &ha->gid_list_dma, GFP_KERNEL);
+		if (ha->gid_list == NULL) {
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - gid_list\n");
+
+			qla2x00_mem_free(ha);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ/10);
+
+			continue;
+		}
+
+		ha->rlc_rsp = dma_alloc_coherent(&ha->pdev->dev,
+		    sizeof(rpt_lun_cmd_rsp_t), &ha->rlc_rsp_dma, GFP_KERNEL);
+		if (ha->rlc_rsp == NULL) {
+			qla_printk(KERN_WARNING, ha,
+				"Memory Allocation failed - rlc");
+
+			qla2x00_mem_free(ha);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ/10);
+
+			continue;
+		}
+
+		snprintf(name, sizeof(name), "qla2xxx_%ld", ha->host_no);
+		ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+		    DMA_POOL_SIZE, 8, 0);
+		if (ha->s_dma_pool == NULL) {
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - s_dma_pool\n");
+
+			qla2x00_mem_free(ha);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ/10);
+
+			continue;
+		}
+
 		/* get consistent memory allocated for init control block */
-		ha->init_cb = pci_alloc_consistent(ha->pdev,
-		    sizeof(init_cb_t), &ha->init_cb_dma);
+		ha->init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->init_cb_dma);
 		if (ha->init_cb == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Memory Allocation failed - init_cb\n");
@@ -2868,6 +2908,22 @@
 		}
 		memset(ha->init_cb, 0, sizeof(init_cb_t));
 
+		/* Get consistent memory allocated for Get Port Database cmd */
+		ha->iodesc_pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->iodesc_pd_dma);
+		if (ha->iodesc_pd == NULL) {
+			/* error */
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - iodesc_pd\n");
+
+			qla2x00_mem_free(ha);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ/10);
+
+			continue;
+		}
+		memset(ha->iodesc_pd, 0, PORT_DATABASE_SIZE);
+
 		/* Allocate ioctl related memory. */
 		if (qla2x00_alloc_ioctl_mem(ha)) {
 			qla_printk(KERN_WARNING, ha,
@@ -2895,8 +2951,9 @@
 		/* Allocate memory for SNS commands */
 		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 			/* Get consistent memory allocated for SNS commands */
-			ha->sns_cmd = pci_alloc_consistent(ha->pdev,
-			    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma);
+			ha->sns_cmd = dma_alloc_coherent(&ha->pdev->dev,
+			    sizeof(struct sns_cmd_pkt), &ha->sns_cmd_dma,
+			    GFP_KERNEL);
 			if (ha->sns_cmd == NULL) {
 				/* error */
 				qla_printk(KERN_WARNING, ha,
@@ -2911,8 +2968,8 @@
 			memset(ha->sns_cmd, 0, sizeof(struct sns_cmd_pkt));
 		} else {
 			/* Get consistent memory allocated for MS IOCB */
-			ha->ms_iocb = pci_alloc_consistent(ha->pdev,
-			    sizeof(ms_iocb_entry_t), &ha->ms_iocb_dma);
+			ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+			    &ha->ms_iocb_dma);
 			if (ha->ms_iocb == NULL) {
 				/* error */
 				qla_printk(KERN_WARNING, ha,
@@ -2930,8 +2987,9 @@
 			 * Get consistent memory allocated for CT SNS
 			 * commands
 			 */
-			ha->ct_sns = pci_alloc_consistent(ha->pdev,
-			    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma);
+			ha->ct_sns = dma_alloc_coherent(&ha->pdev->dev,
+			    sizeof(struct ct_sns_pkt), &ha->ct_sns_dma,
+			    GFP_KERNEL);
 			if (ha->ct_sns == NULL) {
 				/* error */
 				qla_printk(KERN_WARNING, ha,
@@ -2946,22 +3004,6 @@
 			memset(ha->ct_sns, 0, sizeof(struct ct_sns_pkt));
 		}
 
-		/* Get consistent memory allocated for Get Port Database cmd */
-		ha->iodesc_pd = pci_alloc_consistent(ha->pdev,
-		    PORT_DATABASE_SIZE, &ha->iodesc_pd_dma);
-		if (ha->iodesc_pd == NULL) {
-			/* error */
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - iodesc_pd\n");
-
-			qla2x00_mem_free(ha);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ/10);
-
-			continue;
-		}
-		memset(ha->iodesc_pd, 0, PORT_DATABASE_SIZE);
-
 		/* Done all allocations without any error. */
 		status = 0;
 
@@ -3016,52 +3058,67 @@
 	/* free sp pool */
 	qla2x00_free_sp_pool(ha);
 
-	if (ha->iodesc_pd) {
-		pci_free_consistent(ha->pdev, PORT_DATABASE_SIZE,
-		    ha->iodesc_pd, ha->iodesc_pd_dma);
-	}
-
-	if (ha->sns_cmd) {
-		pci_free_consistent(ha->pdev,
-		    sizeof(struct sns_cmd_pkt), ha->sns_cmd, ha->sns_cmd_dma);
-	}
-
-	if (ha->ct_sns) {
-		pci_free_consistent(ha->pdev,
-		    sizeof(struct ct_sns_pkt), ha->ct_sns, ha->ct_sns_dma);
-	}
-	if (ha->ms_iocb) {
-		pci_free_consistent(ha->pdev,
-		    sizeof(ms_iocb_entry_t), ha->ms_iocb, ha->ms_iocb_dma);
-	}
-
-	if (ha->init_cb) {
-		pci_free_consistent(ha->pdev,
-		    sizeof(init_cb_t), ha->init_cb, ha->init_cb_dma);
-	}
+	if (ha->sns_cmd)
+		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
+		    ha->sns_cmd, ha->sns_cmd_dma);
+
+	if (ha->ct_sns)
+		dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
+		    ha->ct_sns, ha->ct_sns_dma);
+
+	if (ha->ms_iocb)
+		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
+
+	if (ha->iodesc_pd)
+		dma_pool_free(ha->s_dma_pool, ha->iodesc_pd, ha->iodesc_pd_dma);
+
+	if (ha->init_cb)
+		dma_pool_free(ha->s_dma_pool, ha->init_cb, ha->init_cb_dma);
+
+	if (ha->s_dma_pool)
+		dma_pool_destroy(ha->s_dma_pool);
+
+	if (ha->rlc_rsp)
+		dma_free_coherent(&ha->pdev->dev,
+		    sizeof(rpt_lun_cmd_rsp_t), ha->rlc_rsp,
+		    ha->rlc_rsp_dma);
+
+	if (ha->gid_list)
+		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
+		    ha->gid_list_dma);
+
+	if (ha->response_ring)
+		dma_free_coherent(&ha->pdev->dev,
+		    (ha->response_q_length + 1) * sizeof(response_t),
+		    ha->response_ring, ha->response_dma);
 
-	if (ha->request_ring) {
-		pci_free_consistent(ha->pdev,
-		    ((ha->request_q_length + 1) * (sizeof(request_t))),
+	if (ha->request_ring)
+		dma_free_coherent(&ha->pdev->dev,
+		    (ha->request_q_length + 1) * sizeof(request_t),
 		    ha->request_ring, ha->request_dma);
-	}
-
-	if (ha->response_ring) {
-		pci_free_consistent(ha->pdev,
-		    ((ha->response_q_length + 1) * (sizeof(response_t))),
-		    ha->response_ring, ha->response_dma);
-	}
 
-	ha->iodesc_pd = NULL;
-	ha->iodesc_pd_dma = 0;
+	ha->sns_cmd = NULL;
+	ha->sns_cmd_dma = 0;
 	ha->ct_sns = NULL;
+	ha->ct_sns_dma = 0;
 	ha->ms_iocb = NULL;
-
+	ha->ms_iocb_dma = 0;
+	ha->iodesc_pd = NULL;
+	ha->iodesc_pd_dma = 0;
 	ha->init_cb = NULL;
-	ha->request_ring = NULL;
-	ha->request_dma = 0;
+	ha->init_cb_dma = 0;
+
+	ha->s_dma_pool = NULL;
+
+	ha->rlc_rsp = NULL;
+	ha->rlc_rsp_dma = 0;
+	ha->gid_list = NULL;
+	ha->gid_list_dma = 0;
+
 	ha->response_ring = NULL;
 	ha->response_dma = 0;
+	ha->request_ring = NULL;
+	ha->request_dma = 0;
 
 	list_for_each_safe(fcpl, fcptemp, &ha->fcports) {
 		fcport = list_entry(fcpl, fc_port_t, list);
@@ -3080,16 +3137,15 @@
 	}
 	INIT_LIST_HEAD(&ha->fcports);
 
-	if (ha->fw_dump) {
+	if (ha->fw_dump)
 		free_pages((unsigned long)ha->fw_dump, ha->fw_dump_order);
-		ha->fw_dump = NULL;
-	}
 
-	if (ha->fw_dump_buffer) {
+	if (ha->fw_dump_buffer)
 		vfree(ha->fw_dump_buffer);
-		ha->fw_dump_reading = 0;
-		ha->fw_dump_buffer = NULL;
-	}
+
+	ha->fw_dump = NULL;
+	ha->fw_dump_reading = 0;
+	ha->fw_dump_buffer = NULL;
 }
 
 /*
