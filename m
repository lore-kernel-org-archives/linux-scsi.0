From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [07/27]
Date: Thu, 17 Feb 2005 12:36:10 -0500
Message-ID: <4214D60A.2080401@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:26257 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262310AbVBQRgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:36:15 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaEr30718
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:14 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaDb21008
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hardware interface. Part 1/3.

diff -Nru a/drivers/scsi/adp94xx/adp94xx_hwi.c b/drivers/scsi/adp94xx/adp94xx_hwi.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/adp94xx_hwi.c	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,1976 @@
+/*
+ * Adaptec ADP94xx SAS HBA device driver for Linux.
+ *
+ * Written by : David Chaw <david_chaw@adaptec.com>
+ * Modified by : Naveen Chandrasekaran <naveen_chandrasekaran@adaptec.com>
+ * 
+ * Copyright (c) 2004 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * $Id: //depot/razor/linux/src/adp94xx_hwi.c#156 $
+ * 
+ */	
+
+#include "adp94xx_osm.h"
+#include "adp94xx_inline.h"
+#if KDB_ENABLE
+#include "linux/kdb.h"
+#endif
+
+/* Local functions' prototypes */
+static u_int	asd_sglist_allocsize(struct asd_softc *asd);
+static int	asd_hwi_init_scbdata(struct asd_softc *asd);
+static int	asd_hwi_reset_hw(struct asd_softc *asd);
+static void	asd_hwi_exit_hw(struct asd_softc *asd);
+static void	asd_hwi_setup_sw_bar(struct asd_softc *asd);
+static int	asd_hwi_init_phys(struct asd_softc *asd);
+static int	asd_hwi_init_ports(struct asd_softc *asd); 
+static void	asd_hwi_alloc_scbs(struct asd_softc *asd);
+static int	asd_hwi_init_sequencers(struct asd_softc *asd);
+static void	asd_hwi_process_dl(struct asd_softc *asd);
+static void	asd_hwi_build_id_frame(struct asd_phy *phy);
+static void	asd_hwi_build_smp_phy_req(struct asd_port *port, int req_type, 
+					  int phy_id, int ctx);
+
+/* SCB completion post routines. */
+static void	asd_hwi_process_phy_comp(struct asd_softc *asd, 
+					 struct scb *scb,
+					 struct control_phy_sb *cntrl_phy);
+static void	asd_hwi_process_edb(struct asd_softc *asd, 
+				    struct asd_done_list *dl_entry);
+static void	asd_hwi_process_prim_event(struct asd_softc *asd,
+					   struct asd_phy *phy,
+					   u_int reg_addr, u_int reg_content);
+static void	asd_hwi_process_phy_event(struct asd_softc *asd, 
+					  struct asd_phy *phy, u_int oob_status,
+					  u_int oob_mode);
+static void	asd_hwi_handle_link_rst_err(struct asd_softc *asd,
+					    struct asd_phy *phy);
+static void	asd_hwi_process_req_task(struct asd_softc *asd,
+					 uint8_t req_type, uint16_t index);
+
+/* Error Handling routines. */
+static void	asd_scb_eh_timeout(u_long arg);
+static void	asd_hwi_abort_scb(struct asd_softc *asd, 
+				  struct scb *scb_to_abort, struct scb *scb);
+static void	asd_hwi_reset_lu(struct asd_softc *asd, 
+				 struct scb *scb_to_reset, struct scb *scb);
+static void	asd_hwi_reset_device(struct asd_softc *asd, 
+				     struct scb *scb_to_reset, struct scb *scb);
+static void	asd_hwi_reset_end_device(struct asd_softc *asd,
+					 struct scb *scb);
+static void	asd_hwi_reset_exp_device(struct asd_softc *asd,
+					 struct scb *scb);
+static void	asd_hwi_report_phy_err_log(struct asd_softc *asd,
+					   struct scb *scb);
+static void	asd_hwi_dump_phy_err_log(struct asd_port *port,
+					 struct scb *scb);
+static void	asd_hwi_reset_port(struct asd_softc *asd, 
+				   struct scb *scb_to_reset, struct scb *scb);
+
+static asd_scb_post_t	asd_hwi_abort_scb_done;
+static asd_scb_post_t	asd_hwi_reset_lu_done;
+static asd_scb_post_t	asd_hwi_reset_device_done;
+static asd_scb_post_t	asd_hwi_reset_end_device_done;
+static asd_scb_post_t	asd_hwi_reset_exp_device_done;
+static asd_scb_post_t	asd_hwi_reset_port_done;
+static asd_scb_eh_post_t asd_hwi_req_task_done;
+
+/* Function prototypes for NVRAM access utilites. */
+#if NVRAM_SUPPORT
+
+static int	asd_hwi_poll_nvram(struct asd_softc *asd);
+static int	asd_hwi_chk_write_status(struct asd_softc *asd, 
+					uint32_t sector_addr, 
+					uint8_t erase_flag); 
+static int	asd_hwi_reset_nvram(struct asd_softc *asd);
+int	asd_hwi_search_nv_cookie(struct asd_softc *asd, 
+			uint32_t *addr,
+			struct asd_flash_dir_layout *pflash_dir_buf);
+
+static int	asd_hwi_erase_nv_sector(struct asd_softc *asd, 
+					uint32_t  sector_addr);
+static int 	asd_hwi_verify_nv_checksum(struct asd_softc *asd, 
+					   u_int segment_id,
+					   uint8_t *segment_ptr, 
+					   u_int bytes_to_read);
+static int	asd_hwi_get_nv_config(struct asd_softc *asd);
+
+static int	asd_hwi_search_nv_id(struct asd_softc *asd, 
+				     u_int setting_id, 
+				     void *dest, u_int *src_offset, 
+				     u_int bytes_to_read);
+static int 	asd_hwi_get_nv_phy_settings(struct asd_softc *asd);
+static int 	asd_hwi_map_lrate_from_sas(u_int sas_link_rate, 
+					   u_int *asd_link_rate);
+static int 	asd_hwi_get_nv_manuf_seg(struct asd_softc *asd, void *dest, 
+					 uint32_t bytes_to_read,
+					 uint32_t *src_offset,
+					 uint16_t signature); 
+static void	asd_hwi_get_nv_phy_params(struct asd_softc *asd);
+
+static int asd_hwi_check_flash(struct asd_softc *asd); 
+
+#endif /* NVRAM_SUPPORT */
+
+/* OCM access routines */
+static int 	asd_hwi_get_ocm_info(struct asd_softc *asd);
+static int 	asd_hwi_get_ocm_entry(struct asd_softc *asd, 
+				      uint32_t entry_type,
+				      struct asd_ocm_entry_format *pocm_de, 
+				      uint32_t *src_offset);
+static int 	asd_hwi_read_ocm_seg(struct asd_softc *asd, void *dest,
+				     uint32_t src_offset, u_int bytes_to_read,
+				     u_int *bytes_read);
+static int 	asd_hwi_set_speed_mask(u_int asd_link_rate, 
+				       uint8_t *asd_speed_mask);
+
+#if SAS_COMSTOCK_SUPPORT
+static void	asd_hwi_get_rtl_ver(struct asd_softc *asd);
+#endif
+
+#ifdef ASD_TEST
+static void 	asd_hwi_dump_phy(struct asd_phy *phy);
+static void 	asd_hwi_dump_phy_id_addr(struct asd_phy *phy);
+#endif
+
+/*
+ * Function:
+ *	asd_sglist_allocsize
+ *
+ * Description:
+ * 	Calculate the optimum S/G List allocation size.  S/G elements used
+ *	for a given transaction must be physically contiguous.  Assume the
+ *	OS will allocate full pages to us, so it doesn't make sense to request
+ *	less than a page.
+ */
+static u_int
+asd_sglist_allocsize(struct asd_softc *asd)
+{
+	uint32_t sg_list_increment;
+	uint32_t sg_list_size;
+	uint32_t max_list_size;
+	uint32_t best_list_size;
+
+	/* Start out with the minimum required for ASD_NSEG. */
+	sg_list_increment = asd_sglist_size(asd);
+	sg_list_size = sg_list_increment;
+
+	/* Get us as close as possible to a page in size. */
+	while ((sg_list_size + sg_list_increment) <= PAGE_SIZE)
+		sg_list_size += sg_list_increment;
+
+	/*
+	 * Try to reduce the amount of wastage by allocating
+	 * multiple pages.
+	 */
+	best_list_size = sg_list_size;
+	max_list_size = roundup(sg_list_increment, PAGE_SIZE);
+	if (max_list_size < 4 * PAGE_SIZE)
+		max_list_size = 4 * PAGE_SIZE;
+	if (max_list_size > (ASD_MAX_ALLOCATED_SCBS * sg_list_increment))
+		max_list_size = (ASD_MAX_ALLOCATED_SCBS * sg_list_increment);
+	while ((sg_list_size + sg_list_increment) <= max_list_size
+	   &&  (sg_list_size % PAGE_SIZE) != 0) {
+		uint32_t new_mod;
+		uint32_t best_mod;
+
+		sg_list_size += sg_list_increment;
+		new_mod = sg_list_size % PAGE_SIZE;
+		best_mod = best_list_size % PAGE_SIZE;
+		if (new_mod > best_mod || new_mod == 0) {
+			best_list_size = sg_list_size;
+		}
+	}
+	return (best_list_size);
+}
+
+static int
+asd_hwi_init_scbdata(struct asd_softc *asd)
+{
+	struct scb	*scb;
+	u_int		 scb_cnt;
+	int		 loop_cnt;
+
+	asd->scbindex = asd_alloc_mem(
+				asd->hw_profile.max_scbs * sizeof(struct scb *),
+				GFP_ATOMIC);
+	if (asd->scbindex == NULL)
+		return (-ENOMEM);
+	
+	memset(asd->scbindex, 0x0, 
+	       asd->hw_profile.max_scbs * sizeof(struct scb *));
+
+	asd->init_level++;
+
+	asd->qinfifo = asd_alloc_mem(
+			   asd->hw_profile.max_scbs * sizeof(*asd->qinfifo),
+			   GFP_ATOMIC);
+
+	if (asd->qinfifo == NULL) {
+		asd_free_mem(asd->scbindex);
+		return (-ENOMEM);
+	}
+
+	asd->init_level++;
+	/*
+	 * Create our DMA tags.  These tags define the kinds of device
+	 * accessible memory allocations and memory mappings we will
+	 * need to perform during normal operation.
+	 */
+	/* DMA tag for our hardware scb structures */
+	if (asd_dma_tag_create(asd, 1, PAGE_SIZE, GFP_ATOMIC, 
+			       &asd->hscb_dmat) != 0) {
+		asd_hwi_exit_hw(asd);
+		goto error_exit;
+	}
+	asd->init_level++;
+
+	/* DMA tag for our S/G structures. */
+	if (asd_dma_tag_create(asd, 8, asd_sglist_allocsize(asd),
+			       GFP_ATOMIC, &asd->sg_dmat) != 0) {
+		asd_hwi_exit_hw(asd);
+		goto error_exit;
+	}
+	asd->init_level++;
+
+	/* Perform initial SCB allocation */
+	asd_hwi_alloc_scbs(asd);
+
+	if (asd->numscbs == 0) {
+		asd_print("%s: Unable to allocate initial scbs\n", 
+			  asd_name(asd));
+		asd_hwi_exit_hw(asd);
+		goto error_exit;
+	}
+	/* 
+	 * Make sure we are able to allocate more than the reserved 
+	 * SCB requirements.
+	 */
+	loop_cnt = 0;
+	while (asd->numscbs < ASD_RSVD_SCBS) {
+		/* 
+		 * Allocate SCB until we have more than the reserved SCBs
+		 * requirement.
+		 */
+		asd_hwi_alloc_scbs(asd);
+		if (++loop_cnt > 4)
+			break;
+	}
+
+	if (asd->numscbs < ASD_RSVD_SCBS) {
+		asd_log(ASD_DBG_ERROR, "Failed to allocate reserved pool of "
+			"SCBs.\n");
+		asd_hwi_exit_hw(asd);
+		goto error_exit;
+	}
+
+	scb_cnt = 0;
+	/* Save certain amount of SCBs as reserved. */
+	while (!list_empty(&asd->free_scbs)) {
+		scb = list_entry(asd->free_scbs.next, struct scb, hwi_links);
+		list_del(&scb->hwi_links);
+		list_add_tail(&scb->hwi_links, &asd->rsvd_scbs);
+		if (++scb_cnt > ASD_RSVD_SCBS)
+			break;
+	}
+	
+	return (0); 
+
+error_exit:
+	return (-ENOMEM);
+}
+
+/* 
+ * Function:
+ *	asd_alloc_softc()
+ *
+ * Description:
+ *	Allocate a softc structure and setup necessary fields.
+ */
+struct asd_softc *
+asd_alloc_softc(asd_dev_t dev)
+{
+	struct asd_softc	*asd;
+	
+	asd = asd_alloc_mem(sizeof(*asd), GFP_KERNEL);
+	if (asd == NULL) {
+		asd_log(ASD_DBG_ERROR, "Unable to alloc softc.\n");
+		return (NULL);
+	}
+	
+	memset(asd, 0x0, sizeof(*asd));
+	INIT_LIST_HEAD(&asd->rsvd_scbs);
+	INIT_LIST_HEAD(&asd->free_scbs);
+	INIT_LIST_HEAD(&asd->pending_scbs);
+	INIT_LIST_HEAD(&asd->timedout_scbs);
+	INIT_LIST_HEAD(&asd->empty_scbs);
+	INIT_LIST_HEAD(&asd->hscb_maps);
+	INIT_LIST_HEAD(&asd->sg_maps);
+	asd->dev = dev;
+
+	if (asd_platform_alloc(asd) != 0) {
+		asd_free_softc(asd);
+		asd = NULL;
+	}
+	return (asd);
+}
+
+/* 
+ * Function:
+ *	asd_free_softc()
+ *
+ * Description:
+ *	Free the host structure and any memory allocated for its member fields.
+ *	Also perform cleanup for module unloading purpose.
+ */
+void
+asd_free_softc(struct asd_softc *asd)
+{
+	asd_platform_free(asd);
+
+	/* Free any internal data structures */
+	asd_hwi_exit_hw(asd);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0) && \
+    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)
+	if (asd->dev != NULL)
+		asd->dev->driver = NULL;
+#endif
+
+	asd_free_mem(asd);			
+}
+
+void
+asd_intr_enable(struct asd_softc *asd, int enable)
+{
+	asd_write_dword(asd, CHIMINTEN, enable ? SET_CHIMINTEN : 0);
+}
+
+static int
+asd_hwi_reset_hw(struct asd_softc *asd)
+{
+	u_int i;
+
+#define ASD_RESET_DELAY	10
+#define ASD_RESET_LOOP_COUNT (1 * 1000000 / ASD_RESET_DELAY)
+	asd_write_dword(asd, COMBIST, HARDRST);
+	for (i = 0; i < ASD_RESET_LOOP_COUNT; i++) {
+		asd_delay(ASD_RESET_DELAY);
+		if (asd_read_dword(asd, CHIMINT) & HARDRSTDET)
+			break;
+	}
+	if (i >= ASD_RESET_LOOP_COUNT) {
+		asd_log(ASD_DBG_ERROR, "Chip reset failed.\n");
+		return (-EIO);
+	}
+
+	return (0);
+} 
+
+/* 
+ * Function:
+ *	asd_hwi_init_hw()
+ *
+ * Description:
+ *      Perform controller specific initialization.
+ */
+int
+asd_hwi_init_hw(struct asd_softc  *asd)
+{
+	union hardware_scb 	*hscb;
+	struct scb		*scb;
+	uint8_t			*next_vaddr;
+	dma_addr_t	 	 next_baddr;
+	dma_addr_t	 	 edb_baddr;
+	size_t		 	 driver_data_size;
+	size_t		 	 dl_size;
+	uint8_t		 	 enabled_phys;
+	u_int		 	 num_edbs;
+	u_int		 	 num_escbs;
+	u_int		 	 i;
+	int		 	 error;
+	u_long			 flags;
+
+	/* Setup the Sliding Window BAR. */
+	asd_hwi_setup_sw_bar(asd);
+
+#if SAS_COMSTOCK_SUPPORT
+	/* 
+	 * Retrieve the RTL number. The RTL Number will be used to decide which
+	 * sequencer version to use.
+	 */  
+	asd_hwi_get_rtl_ver(asd);
+
+	/* No support for COMSTOCK RTL less than version 14. */
+	if (asd->hw_profile.rev_id < COMSTOCK_LATEST_RTL)
+		return (-ENODEV);
+#endif
+
+	/* Allocate SCB data */
+	if (asd_hwi_init_scbdata(asd) != 0)
+		return (-ENOMEM);
+	
+	/*
+	 * DMA tag for our done_list, empty buffers, empty hardware SCBs,
+	 * and sentinel hardware SCB.  These are data host memory structures
+	 * the controller must be able to access.
+	 *
+	 * The number of elements in our done list must be a powerof2
+	 * greater than or equal to 4 that is large enough to guarantee
+	 * it cannot overflow.  Since each done list entry is associated
+	 * with either an empty data buffer or an SCB, add the counts for
+	 * these two objects together and roundup to the next power of 2.
+	 * To ensure our sequencers don't stall, we need two empty buffers
+	 * per sequencer (1 sequencer per-phy plus central seq).  We round
+	 * this up to a multiple of the number of EDBs that we can fit in
+	 * a single empty SCB.
+	 */
+	num_edbs = roundup(2 * (asd->hw_profile.max_phys + 1),
+			   ASD_MAX_EDBS_PER_SCB);
+	/*
+	 * At minimum, allocate 2 empty SCBs so that the sequencers
+	 * always have empty buffers while we are trying to queue more.
+	 */
+	num_edbs = MAX(num_edbs, 2 * ASD_MAX_EDBS_PER_SCB);
+	num_escbs = num_edbs / ASD_MAX_EDBS_PER_SCB;
+	dl_size = asd->hw_profile.max_scbs + num_edbs;
+	dl_size = roundup_pow2(dl_size);
+	asd->dl_wrap_mask = dl_size - 1;
+	dl_size *= sizeof(*asd->done_list);
+
+	driver_data_size = dl_size + (ASD_SCB_SIZE) /* for sentinel */ + 
+			 + (num_escbs * ASD_SCB_SIZE)
+			 + (num_edbs * sizeof(union edb));
+
+	if (asd_dma_tag_create(asd, 8, driver_data_size, GFP_ATOMIC,
+			       &asd->shared_data_dmat) != 0) {
+		asd_hwi_exit_hw(asd);
+		return (-ENOMEM);
+	}
+
+	asd->init_level++;
+
+	/* Allocation of driver data */
+	if (asd_dmamem_alloc(asd, asd->shared_data_dmat,
+			     (void **)&asd->shared_data_map.vaddr, GFP_ATOMIC,
+			     &asd->shared_data_map.dmamap,
+			     &asd->shared_data_map.busaddr) != 0) {
+		asd_hwi_exit_hw(asd);
+		return (-ENOMEM);
+	}
+
+	asd->init_level++;
+
+	/*
+	 * Distribute the memory.
+	 */
+	memset(asd->shared_data_map.vaddr, 0, driver_data_size);
+	asd->done_list = (struct asd_done_list *)asd->shared_data_map.vaddr;
+	asd->dl_valid = ASD_QDONE_PASS_DEF;
+	next_vaddr = asd->shared_data_map.vaddr + dl_size;
+	next_baddr = asd->shared_data_map.busaddr + dl_size;
+
+	/*
+	 * We need one SCB to serve as the "next SCB".  Since the
+	 * tag identifier in this SCB will never be used, there is
+	 * no point in using a valid HSCB tag from an SCB pulled from
+	 * the standard free pool.  So, we allocate this "sentinel"
+	 * specially from the DMA safe memory chunk.
+	 */
+	asd->next_queued_hscb = (union hardware_scb *)next_vaddr;
+	asd->next_queued_hscb_map = &asd->shared_data_map;
+	asd->next_queued_hscb_busaddr = asd_htole64(next_baddr);
+	next_vaddr += ASD_SCB_SIZE;
+	next_baddr += ASD_SCB_SIZE;
+
+	/*
+	 * Since Empty SCBs do not require scatter gather lists
+	 * we also allocate them outside of asd_alloc_scbs().
+	 */
+	hscb = asd->next_queued_hscb + 1;
+	edb_baddr = next_baddr + (num_escbs * ASD_SCB_SIZE);
+	for (i = 0; i < num_escbs; i++, hscb++, next_baddr += ASD_SCB_SIZE) {
+		int j;
+
+		/*
+		 * Allocate ESCBs.
+		 */
+		scb = asd_alloc_mem(sizeof(*scb), GFP_ATOMIC);
+		if (scb == NULL) {
+			error = -ENOMEM;
+			goto exit;
+		}
+		memset(scb, 0, sizeof(*scb));
+		INIT_LIST_HEAD(&scb->hwi_links);
+		INIT_LIST_HEAD(&scb->owner_links);
+		scb->hscb = hscb;
+		scb->hscb_busaddr = asd_htole64(next_baddr);
+		scb->softc = asd;
+		scb->hscb_map = &asd->shared_data_map;
+		hscb->header.index = asd_htole16(asd->numscbs);
+		hscb->header.opcode = SCB_EMPTY_BUFFER;
+		asd->scbindex[asd->numscbs++] = scb;
+		hscb->empty_scb.num_valid_elems = ASD_MAX_EDBS_PER_SCB;
+		for (j = 0; j < ASD_MAX_EDBS_PER_SCB; j++) {
+			hscb->empty_scb.buf_elem[j].busaddr =
+			    asd_htole64(edb_baddr);
+			hscb->empty_scb.buf_elem[j].buffer_size =
+			    asd_htole32(sizeof(union edb));
+			hscb->empty_scb.buf_elem[j].elem_valid_ds =
+			    ELEM_BUFFER_VALID;
+			edb_baddr += sizeof(union edb);
+		}
+		list_add(&scb->hwi_links, &asd->empty_scbs);
+	}
+
+	asd->init_level++;
+
+	/* Allocate Free DDB bitmap. */
+	asd->ddb_bitmap_size = roundup(asd->hw_profile.max_ddbs, BITS_PER_LONG);
+	asd->ddb_bitmap_size /= BITS_PER_LONG;
+	asd->free_ddb_bitmap = asd_alloc_mem((asd->ddb_bitmap_size *
+					      sizeof(u_long)), GFP_ATOMIC);
+	if (asd->free_ddb_bitmap == NULL)
+		return (-ENOMEM);
+	memset(asd->free_ddb_bitmap, 0, asd->ddb_bitmap_size);
+
+	/*
+	 * DDB site 0 and 1 are reserved for the firmware for internal use.
+	 */
+	asd->free_ddb_bitmap[0] |= (3<<0);
+	asd->init_level++;
+
+	/* Retrieve OCM information */
+	if (asd_hwi_get_ocm_info(asd)) {
+		asd_log(ASD_DBG_ERROR, "Failed to retrieve OCM info.\n");
+		/* TBD: return -1; ? */
+	}
+#if NVRAM_SUPPORT
+	/* 
+	 * Retrieves controller NVRAM setting. 
+	 */
+	error = asd_hwi_get_nv_config(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to retrieve NVRAM config.\n");
+	}
+#endif
+
+	/* Initialize the phy and port to default settings. */
+	error = asd_hwi_init_phys(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to init the phys.\n");
+		asd_hwi_exit_hw(asd);
+		goto exit;
+	}
+
+	error = asd_hwi_init_ports(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to init the ports.\n");
+		asd_hwi_exit_hw(asd);
+		goto exit;
+	}
+
+	if (asd_hwi_reset_hw(asd) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to perform Chip reset.\n");
+		asd_hwi_exit_hw(asd);
+		goto exit;
+	}
+
+	asd_write_dword(asd, CHIMINT, PORRSTDET|HARDRSTDET);
+
+	/*
+	 * Reset the producer and consumer index to reflect
+	 * no outstanding SCBs.
+	 */
+	asd->qinfifonext = (asd_read_dword(asd, SCBPRO) & SCBCONS_MASK) >> 16;
+	asd_write_dword(asd, SCBPRO, asd->qinfifonext);
+
+	asd->qinfifonext = asd_read_word(asd, SCBPRO+2);
+
+	/* Disable the Host interrupts. */
+	asd_write_dword(asd, CHIMINTEN, RST_CHIMINTEN);
+
+	/* Initialize and setup the CSEQ and LSEQ. */
+	error = asd_hwi_init_sequencers(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to init the SEQ.\n"); 
+		goto exit;
+	}		
+	
+	/* CSEQ should be ready to run. Start the CSEQ. */
+	error = asd_hwi_start_cseq(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to start the CSEQ.\n"); 
+		goto exit;
+	}		
+
+	/* Start the LSEQ(s). */
+	i = 0;
+	enabled_phys = asd->hw_profile.enabled_phys;
+	while (enabled_phys != 0) {
+		for ( ; i < asd->hw_profile.max_phys; i++) {
+			if (enabled_phys & (1U << i)) {
+				enabled_phys &= ~(1U << i);
+				break;
+			}
+		}
+		
+		error = asd_hwi_start_lseq(asd, i);
+		if (error != 0) {
+			asd_log(ASD_DBG_ERROR,
+				"Failed to start LSEQ %d.\n", i);
+			goto exit;
+		}		
+	}
+
+	asd_lock(asd, &flags);
+
+	/*
+	 * Post all of our empty scbs to the central sequencer.
+	 */
+	list_for_each_entry(scb, &asd->empty_scbs, hwi_links) {
+		asd_hwi_post_scb(asd, scb);
+	}
+
+	asd_unlock(asd, &flags);
+
+	/* Enabled all the phys. */
+	i = 0;
+	enabled_phys = asd->hw_profile.enabled_phys;
+	while (enabled_phys != 0) { 
+		for ( ; i < asd->hw_profile.max_phys; i++) {
+			if (enabled_phys & (1 << i)) {
+				enabled_phys &= ~(1 << i);
+				break;
+			} 
+		}
+	
+		error = asd_hwi_enable_phy(asd, asd->phy_list[i]);
+		if (error != 0) {
+			/*
+			 * TODO: This shouldn't happen.
+			 *       Need more thought on how to proceed.
+			 */
+			asd_log(ASD_DBG_ERROR, "Failed to enable phy %d.\n", i);
+			break;
+		}
+	}
+exit:
+	return (error);         
+}
+
+#if SAS_COMSTOCK_SUPPORT
+/*
+ * Function:
+ *	asd_hwi_get_rtl_ver()
+ *
+ * Description:
+ * 	Retrive the COMSTOCK rtl version.
+ */ 	  	 
+static void
+asd_hwi_get_rtl_ver(struct asd_softc *asd)
+{
+	uint32_t	exsi_base_addr;
+	uint32_t	reg_addr;
+	uint8_t		reg_data;
+
+	exsi_base_addr = EXSI_REG_BASE_ADR + XREGADDR;
+	reg_addr = asd_hwi_swb_read_dword(asd, exsi_base_addr);
+	asd_hwi_swb_write_dword(asd, exsi_base_addr, (uint32_t)
+				(reg_addr & ~(XRADDRINCEN | XREGADD_MASK)));
+	reg_data = asd_hwi_swb_read_byte(asd, EXSI_REG_BASE_ADR + XREGDATAR);
+	asd_hwi_swb_write_dword(asd, exsi_base_addr, reg_addr);
+	
+	asd->hw_profile.rev_id = reg_data;
+}
+#endif /* SAS_COMSTOCK_SUPPORT */
+
+/* 
+ * Function:
+ *	asd_hwi_exit_hw()
+ *
+ * Description:
+ *      Perform controller specific cleanup.
+ */
+static void
+asd_hwi_exit_hw(struct asd_softc *asd)
+{
+	struct scb	*scb;
+	struct map_node	*map;
+	struct asd_phy	*phy;
+	struct asd_port	*port;
+	u_int		 i;
+
+	/*
+	 * Reset the chip so that the sequencers do not
+	 * attempt to DMA data into buffers we are about
+	 * to remove or issue further interrupts.
+	 */
+	/* TBRV: This seems to fail all the time. */
+	//asd_hwi_reset_hw(asd);
+
+	/* Clean up the phy structures */
+	for (i = 0; i <	asd->hw_profile.max_phys; i++) {
+		if (asd->phy_list[i] != NULL) {
+			phy = asd->phy_list[i];
+			/* Free the ID ADDR Frame buffer. */
+			asd_free_dma_mem(asd, phy->id_addr_dmat,
+					 &phy->id_addr_map);
+			asd_free_mem(asd->phy_list[i]);
+		}
+	}
+
+	/* Clean up the port structures */
+	for (i = 0; i < asd->hw_profile.max_ports; i++) {
+		if (asd->port_list[i] != NULL) {
+			port = asd->port_list[i];
+
+			/*
+			 * Free SMP Request Frame buffer.
+			 */
+			asd_free_dma_mem(asd, 
+				port->dc.smp_req_dmat,
+				&port->dc.smp_req_map);
+
+			/*
+			 * Free SMP Response Frame buffer.
+			 */
+			asd_free_dma_mem(asd, 
+				port->dc.smp_resp_dmat,
+				&port->dc.smp_resp_map);
+
+			asd_free_mem(asd->port_list[i]);
+		}
+	}
+
+	/* Free up the SCBs */
+	while (!list_empty(&asd->pending_scbs)) {
+		scb = list_entry(asd->pending_scbs.next, struct scb, hwi_links);
+		list_del(&scb->hwi_links);
+		asd_free_scb_platform_data(asd, scb->platform_data);
+        	asd_free_mem(scb);
+	}
+	while (!list_empty(&asd->rsvd_scbs)) {
+		scb = list_entry(asd->rsvd_scbs.next, struct scb, hwi_links);
+		list_del(&scb->hwi_links);
+		asd_free_scb_platform_data(asd, scb->platform_data);
+        	asd_free_mem(scb);
+	}
+	while (!list_empty(&asd->free_scbs)) {
+		scb = list_entry(asd->free_scbs.next, struct scb, hwi_links);
+		list_del(&scb->hwi_links);
+		asd_free_scb_platform_data(asd, scb->platform_data);
+        	asd_free_mem(scb);
+	}
+	while (!list_empty(&asd->empty_scbs)) {
+		/*
+		 * Empties have no OSM data.
+		 */
+		scb = list_entry(asd->empty_scbs.next, struct scb, hwi_links);
+		list_del(&scb->hwi_links);
+        	asd_free_mem(scb);
+	}
+
+	/* Free up DMA safe memory shared with the controller */
+	while (!list_empty(&asd->hscb_maps)) {
+		map = list_entry(asd->hscb_maps.next, struct map_node, links);
+		list_del(&map->links);
+		asd_dmamem_free(asd, asd->hscb_dmat, map->vaddr, map->dmamap);
+		asd_free_mem(map);
+	}
+	while (!list_empty(&asd->sg_maps)) {
+		map = list_entry(asd->sg_maps.next, struct map_node, links);
+		list_del(&map->links);
+		asd_dmamem_free(asd, asd->sg_dmat, map->vaddr, map->dmamap);
+		asd_free_mem(map);
+	}
+
+	switch (asd->init_level) {
+	default:
+	case 7:
+		asd_free_mem(asd->free_ddb_bitmap);
+		/* FALLTHROUGH */
+	case 6:
+		asd_dmamem_free(asd, asd->shared_data_dmat,
+				asd->shared_data_map.vaddr,
+				asd->shared_data_map.dmamap);
+		/* FALLTHROUGH */
+	case 5:
+		asd_dma_tag_destroy(asd, asd->shared_data_dmat);
+		/* FALLTHROUGH */
+	case 4:
+		asd_dma_tag_destroy(asd, asd->sg_dmat);
+		/* FALLTHROUGH */
+	case 3:
+		asd_dma_tag_destroy(asd, asd->hscb_dmat);
+		/* FALLTHROUGH */
+	case 2:
+		asd_free_mem(asd->qinfifo);
+		/* FALLTHROUGH */
+	case 1:
+		asd_free_mem(asd->scbindex);
+		/* FALLTHROUGH */
+	case 0:
+		break;
+	}
+}
+
+/* 
+ * Function:
+ *	asd_hwi_setup_sw_bar()
+ *
+ * Description:
+ *      Setup the location of internal space where the Sliding Window will
+ *	point to.
+ */
+static void
+asd_hwi_setup_sw_bar(struct asd_softc *asd)
+{
+	/* Setup Sliding Window A and B to point to CHIM_REG_BASE_ADR. */
+	asd_write_dword(asd, PCIC_BASEA, CHIM_REG_BASE_ADR);
+	asd_write_dword(asd, PCIC_BASEB, CHIM_REG_BASE_ADR);
+	
+	asd->io_handle[0]->swb_base = (uint32_t) CHIM_REG_BASE_ADR;        
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_phys()
+ *
+ * Description:
+ *      Alllocate phy structures and intialize them to default settings. 
+ */
+static int
+asd_hwi_init_phys(struct asd_softc *asd)
+{
+	struct asd_phy	*phy;
+	u_int		 phy_id;
+
+        for (phy_id = 0; phy_id < asd->hw_profile.max_phys; phy_id++) {
+        	phy = asd_alloc_mem(sizeof(*phy), GFP_KERNEL);
+                if (phy == NULL) {
+                	asd_log(ASD_DBG_ERROR," Alloc Phy failed.\n");
+                        return (-ENOMEM);
+		}
+                
+		memset(phy, 0x0, sizeof(*phy));
+		
+		/* Fill in the default settings. */
+		phy->id = phy_id;
+		phy->max_link_rate = SAS_30GBPS_RATE;
+		phy->min_link_rate = SAS_15GBPS_RATE;       
+                /*
+                 * Set the phy attributes to support SSP, SMP and STP 
+                 * initiator mode. Target mode is not supported.
+                 */
+		phy->attr = (ASD_SSP_INITIATOR | ASD_SMP_INITIATOR | 
+			     ASD_STP_INITIATOR);
+		
+		/* 
+		 * By default, use the adapter WWN as the SAS address for 
+		 * the phy. 
+		 */
+                memcpy(phy->sas_addr, asd->hw_profile.wwn, SAS_ADDR_LEN);
+
+		/* Allocate buffer for IDENTIFY ADDRESS frame. */
+		if (asd_dma_tag_create(asd, 8, sizeof(struct sas_id_addr),
+				       GFP_ATOMIC, &phy->id_addr_dmat) != 0)
+			return (-ENOMEM);
+
+		if (asd_dmamem_alloc(asd, phy->id_addr_dmat, 
+				    (void **) &phy->id_addr_map.vaddr,
+				    GFP_ATOMIC,
+				    &phy->id_addr_map.dmamap,
+				    &phy->id_addr_map.busaddr) != 0) {
+			asd_dma_tag_destroy(asd, phy->id_addr_dmat);
+			return (-ENOMEM);
+		}
+
+		INIT_LIST_HEAD(&phy->pending_scbs);
+		phy->state = ASD_PHY_UNUSED;
+		phy->src_port = NULL;
+                phy->softc = (void *) asd;
+		INIT_LIST_HEAD(&phy->links);
+		phy->pat_gen = 0;
+		asd->phy_list[phy_id] = phy;
+	}
+	
+	asd_hwi_get_nv_phy_settings(asd);
+	asd_hwi_get_nv_phy_params(asd);
+
+	return (0);	
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_ports()
+ *
+ * Description:
+ *      Alllocate port structures and intialize them to default settings. 
+ */
+static int
+asd_hwi_init_ports(struct asd_softc *asd)
+{
+	struct asd_port	*port;
+	u_char		i;
+
+	for (i = 0; i < asd->hw_profile.max_ports; i++) {
+       		port = asd_alloc_mem(sizeof(*port), GFP_ATOMIC);
+		if (port == NULL) {
+			asd_log(ASD_DBG_ERROR," Alloc Port failed.\n");
+			return (-ENOMEM);
+		}			
+	
+		memset(port, 0x0, sizeof(*port));
+		INIT_LIST_HEAD(&port->phys_attached);
+		INIT_LIST_HEAD(&port->targets);
+		INIT_LIST_HEAD(&port->targets_to_validate);
+
+		if (asd_alloc_dma_mem(asd, sizeof(struct SMPRequest),
+			(void **)&port->dc.SMPRequestFrame,
+			&port->dc.SMPRequestBusAddr,
+			&port->dc.smp_req_dmat,
+			&port->dc.smp_req_map) != 0) {
+
+			return (-ENOMEM);
+		}
+
+		if (asd_alloc_dma_mem(asd, sizeof(struct SMPResponse),
+			(void **)&port->dc.SMPResponseFrame,
+			&port->dc.SMPResponseBusAddr,
+			&port->dc.smp_resp_dmat,
+			&port->dc.smp_resp_map) != 0) {
+
+			/*
+			 * If we get get the response, free the request.
+			 */
+			asd_free_dma_mem(asd, 
+				port->dc.smp_req_dmat,
+				&port->dc.smp_req_map);
+
+			return (-ENOMEM);
+		}
+
+		/*
+		 * The SASInfoFrame includes the length of the list as the 
+		 * first element.
+		 */
+		port->dc.sas_info_len = MAX(
+			(ASD_MAX_LUNS + 1) * sizeof(uint64_t),
+			PRODUCT_SERIAL_NUMBER_LEN);
+
+		if (asd_alloc_dma_mem(asd,
+			port->dc.sas_info_len,
+			(void **)&port->dc.SASInfoFrame,
+			&port->dc.SASInfoBusAddr,
+			&port->dc.sas_info_dmat,
+			&port->dc.sas_info_map) != 0) {
+
+			/*
+			 * If we get get the report luns ...
+			 */
+			asd_free_dma_mem(asd, 
+				port->dc.smp_req_dmat,
+				&port->dc.smp_req_map);
+
+			asd_free_dma_mem(asd, 
+				port->dc.smp_resp_dmat,
+				&port->dc.smp_resp_map);
+
+			return (-ENOMEM);
+		}
+
+		/* Fill in default settings. */
+		port->attr = (ASD_SSP_INITIATOR | ASD_SMP_INITIATOR |
+			      ASD_STP_INITIATOR);
+		port->softc = (void *) asd;
+		port->state = ASD_PORT_UNUSED;
+		port->events = ASD_IDLE;
+		port->link_type = ASD_LINK_UNKNOWN;
+		port->management_type = ASD_DEVICE_NONE;
+		port->id = i;
+		asd->port_list[i] = port;
+	}
+
+	return (0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_alloc_scbs()
+ *
+ * Description:
+ *      Allocate SCB buffers. 
+ */
+static void
+asd_hwi_alloc_scbs(struct asd_softc *asd)
+{
+	struct scb 		*next_scb;
+	union hardware_scb 	*hscb;
+	struct map_node 	*hscb_map;
+	struct map_node 	*sg_map;
+	uint8_t			*segs;
+	dma_addr_t	 	 hscb_busaddr;
+	dma_addr_t	 	 sg_busaddr;
+	int		 	 newcount;
+	int		 	 i;
+
+	if (asd->numscbs >= asd->hw_profile.max_scbs)
+		/* Can't allocate any more */
+		return;
+
+	if (asd->scbs_left != 0) {
+		int offset;
+
+		offset = (PAGE_SIZE / sizeof(*hscb)) - asd->scbs_left;
+		hscb_map = list_entry(asd->hscb_maps.next,
+				      struct map_node, links);
+		hscb = &((union hardware_scb *)hscb_map->vaddr)[offset];
+		hscb_busaddr = hscb_map->busaddr + (offset * sizeof(*hscb));
+	} else {
+		hscb_map = asd_alloc_mem(sizeof(*hscb_map), GFP_ATOMIC);
+
+		if (hscb_map == NULL)
+			return;
+
+		/* Allocate the next batch of hardware SCBs */
+		if (asd_dmamem_alloc(asd, asd->hscb_dmat,
+				     (void **) &hscb_map->vaddr, GFP_ATOMIC,
+				     &hscb_map->dmamap,
+				     &hscb_map->busaddr) != 0) {
+			asd_free_mem(hscb_map);
+			return;
+		}
+
+		list_add(&hscb_map->links, &asd->hscb_maps);
+		hscb = (union hardware_scb *)hscb_map->vaddr;
+		hscb_busaddr = hscb_map->busaddr;
+		asd->scbs_left = PAGE_SIZE / sizeof(*hscb);
+
+		asd_log(ASD_DBG_RUNTIME, "Mapped SCB data. %d SCBs left. "
+			"Total SCBs %d.\n", 
+			asd->scbs_left, asd->numscbs);
+	}
+
+	if (asd->sgs_left != 0) {
+		int offset;
+
+		offset = ((asd_sglist_allocsize(asd) / asd_sglist_size(asd))
+		     		- asd->sgs_left) * asd_sglist_size(asd);
+		sg_map = list_entry(asd->sg_maps.next,
+				    struct map_node, links);
+		segs = sg_map->vaddr + offset;
+		sg_busaddr = sg_map->busaddr + offset;
+	} else {
+		sg_map = asd_alloc_mem(sizeof(*sg_map), GFP_ATOMIC);
+
+		if (sg_map == NULL)
+			return;
+
+		/* Allocate the next batch of S/G lists */
+		if (asd_dmamem_alloc(asd, asd->sg_dmat,
+				     (void **) &sg_map->vaddr, GFP_ATOMIC,
+				     &sg_map->dmamap, &sg_map->busaddr) != 0) {
+			asd_free_mem(sg_map);
+			return;
+		}
+
+		list_add(&sg_map->links, &asd->sg_maps);
+		segs = sg_map->vaddr;
+		sg_busaddr = sg_map->busaddr;
+		asd->sgs_left =
+			asd_sglist_allocsize(asd) / asd_sglist_size(asd);
+	}
+
+	newcount = MIN(asd->scbs_left, asd->sgs_left);
+	newcount = MIN(newcount, (asd->hw_profile.max_scbs - asd->numscbs));
+
+	for (i = 0; i < newcount; i++) {
+		struct asd_scb_platform_data *pdata;
+
+		next_scb = (struct scb *) asd_alloc_mem(sizeof(*next_scb),
+							GFP_ATOMIC);
+		if (next_scb == NULL)
+			break;
+
+		memset(next_scb, 0, sizeof(*next_scb));
+		INIT_LIST_HEAD(&next_scb->hwi_links);
+		INIT_LIST_HEAD(&next_scb->owner_links);
+
+		pdata = asd_alloc_scb_platform_data(asd);
+		if (pdata == NULL) {
+			asd_free_mem(next_scb);
+			break;
+		}
+		next_scb->platform_data = pdata;
+		init_timer(&next_scb->platform_data->timeout);
+		next_scb->hscb_map = hscb_map;
+		next_scb->sg_map = sg_map;
+		next_scb->sg_list = (struct sg_element *)segs;
+		memset(hscb, 0, sizeof(*hscb));
+		next_scb->hscb = hscb;
+		next_scb->hscb_busaddr = asd_htole64(hscb_busaddr);
+		next_scb->sg_list_busaddr = sg_busaddr;
+		next_scb->softc = asd;
+		next_scb->flags = SCB_FLAG_NONE;
+		next_scb->eh_state = SCB_EH_NONE;
+		next_scb->hscb->header.index = asd_htole16(asd->numscbs);
+		asd->scbindex[asd_htole16(asd->numscbs)] = next_scb;
+		
+		/* Add the scb to the free list. */
+		asd_hwi_free_scb(asd, next_scb);
+		hscb++;
+		hscb_busaddr += sizeof(*hscb);
+		segs += asd_sglist_size(asd);
+		sg_busaddr += asd_sglist_size(asd);
+		asd->numscbs++;
+		asd->scbs_left--;
+		asd->sgs_left--;
+	}
+}
+
+/*
+ * Function:
+ *	asd_alloc_ddb
+ *
+ * Description:
+ *      Allocate a DDB site on the controller.
+ *	Returns ASD_INVALID_DDB_INDEX on failure.
+ *	Returns DDB index on success.
+ */
+uint16_t
+asd_alloc_ddb(struct asd_softc *asd)
+{
+	u_int i;
+	u_int bit_index;
+
+	for (i = 0; i < asd->ddb_bitmap_size; i++) {
+		if (asd->free_ddb_bitmap[i] != ~0UL)
+			break;
+	}
+	if (i >= asd->ddb_bitmap_size)
+		return (ASD_INVALID_DDB_INDEX);
+
+	bit_index = ffz(asd->free_ddb_bitmap[i]);
+	asd->free_ddb_bitmap[i] |= 0x1 << bit_index;
+	return ((i * BITS_PER_LONG) + bit_index);
+}
+
+/*
+ * Function:
+ *	asd_free_ddb
+ *
+ * Description:
+ *      Mark the DDB site at "ddb_index" as free.
+ */
+void
+asd_free_ddb(struct asd_softc *asd, uint16_t ddb_index)
+{
+	u_int word_offset;
+	u_int bit_offset;
+
+	word_offset = ddb_index / BITS_PER_LONG;
+	bit_offset = ddb_index & (BITS_PER_LONG - 1);
+	asd->free_ddb_bitmap[word_offset] &= ~(0x1 << bit_offset);
+}
+
+/*
+ * Function:
+ *	asd_hwi_setup_ddb_site()
+ *  
+ * Description:
+ *	Alloc and DDB site and setup the DDB site for the controller.
+ */
+int
+asd_hwi_setup_ddb_site(struct asd_softc *asd, struct asd_target *target)
+{
+	uint16_t	ddb_index;
+
+	/* Allocate a free DDB site. */
+	ddb_index = asd_alloc_ddb(asd);
+	if (ddb_index == ASD_INVALID_DDB_INDEX)
+		return (-1);
+	
+	target->ddb_profile.conn_handle = ddb_index;	
+	
+	asd_hwi_build_ddb_site(asd, target);
+
+	return (0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_sequencers()
+ *
+ * Description:
+ *      Initialize the Central and Link Sequencers. 
+ */
+static int
+asd_hwi_init_sequencers(struct asd_softc *asd)
+{
+	/* Pause the CSEQ. */
+	if (asd_hwi_pause_cseq(asd) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to pause the CSEQ.\n");
+		return (-1);	
+	}
+	
+	/* Pause all the LSEQs. */
+	if (asd_hwi_pause_lseq(asd, asd->hw_profile.enabled_phys) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to pause the LSEQs.\n");
+		return (-1);		
+	}
+	/* Download the sequencers. */
+	if (asd_hwi_download_seqs(asd) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to setup the SEQs.\n");
+		return (-1);
+	}
+
+	/* 
+	 * Initialiaze the DDB site 0 and 1used internally by the
+	 * sequencer.
+	 */
+	asd_hwi_init_internal_ddb(asd);
+
+	/* Setup and initialize the CSEQ and LSEQ(s). */
+	asd_hwi_setup_seqs(asd);
+	
+	return (0);			
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_scb()
+ *
+ * Description:
+ *      Get a free SCB Desc from the free list if any.
+ */
+struct scb *
+asd_hwi_get_scb(struct asd_softc *asd, int rsvd_pool)
+{
+	struct scb	*scb;
+
+	ASD_LOCK_ASSERT(asd);
+
+	if (rsvd_pool == 1) {
+		/* Get an SCB from the reserved pool. */
+		if (list_empty(&asd->rsvd_scbs)) {
+			/*
+		 	 * We shouldn't be running out reserved SCBs.
+		 	 */
+			asd_log(ASD_DBG_ERROR, "Running out reserved SCBs.\n");
+			return (NULL);
+		}
+		scb = list_entry(asd->rsvd_scbs.next, struct scb, hwi_links);
+		scb->flags |= SCB_RESERVED;
+	} else {
+		/* Get an SCB from the free pool. */
+		if (list_empty(&asd->free_scbs)) {
+			asd_hwi_alloc_scbs(asd);
+			if (list_empty(&asd->free_scbs)) {
+				asd_log(ASD_DBG_ERROR, 
+					"Failed to get a free SCB.\n");
+				return (NULL);
+			}
+		}
+		scb = list_entry(asd->free_scbs.next, struct scb, hwi_links);
+	}
+	list_del(&scb->hwi_links);
+	scb->post_stack_depth = 0;
+	return (scb);
+}
+
+/*
+ * Function:
+ *	asd_hwi_enable_phy()
+ *
+ * Description:
+ *	Enable the requested phy.
+ */
+int
+asd_hwi_enable_phy(struct asd_softc *asd, struct asd_phy *phy)
+{
+	struct scb		*scb;
+	uint8_t			phy_id;
+	u_long		 	flags;
+
+	phy_id = phy->id;
+
+#if SAS_COMSTOCK_SUPPORT
+	/*
+ 	 * For COMSTOCK:
+	 * 	1. We need to setup OOB signal detection limits.
+	 */
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_BFLTR), 0x40);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_INIT_MIN), 0x06);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_INIT_MAX), 0x13);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_INIT_NEG), 0x13);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_SAS_MIN), 0x13);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_SAS_MAX), 0x36);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_SAS_NEG), 0x36);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_WAKE_MIN), 0x02);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_WAKE_MAX), 0x06);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_WAKE_NEG), 0x06);
+	asd_hwi_swb_write_word(asd, LmSEQ_OOB_REG(phy_id, OOB_IDLE_MAX), 
+			       0x0080);
+	asd_hwi_swb_write_word(asd, LmSEQ_OOB_REG(phy_id, OOB_BURST_MAX), 
+			       0x0080);
+	/*
+ 	 *	2. Put the OOB in slow clock mode. That corrects most of the 
+	 *	   other timer parameters including the signal transmit values
+	 * 	   for 37.5 MHZ.
+	 */
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, OOB_MODE), SLOW_CLK);
+
+#endif /* SAS_COMSTOCK_SUPPORT */
+				
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, INT_ENABLE_2), 0x0);
+
+
+#if !SAS_COMSTOCK_SUPPORT
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, HOT_PLUG_DELAY),
+			       HOTPLUG_DEFAULT_DELAY);
+
+	/*
+	 * Set the PHY SETTINGS values based on the manufacturing 
+	 * programmed values that we obtained from the NVRAM.
+	 */
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, PHY_CONTROL_0),
+			       phy->phy_ctl0);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, PHY_CONTROL_1),
+			       phy->phy_ctl1);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, PHY_CONTROL_2),
+			       phy->phy_ctl2);
+	asd_hwi_swb_write_byte(asd, LmSEQ_OOB_REG(phy_id, PHY_CONTROL_3),
+			       phy->phy_ctl3);
+#endif
+
+	/* Initialize COMINIT_TIMER timeout. */
+	asd_hwi_swb_write_dword(asd, LmSEQ_TEN_MS_COMINIT_TIMEOUT(phy_id),
+				SAS_DEFAULT_COMINIT_TIMEOUT);
+
+	/* Build Identify Frame address. */
+	asd_hwi_build_id_frame(phy);
+
+	/* Fill in bus address for Identify Frame buffer. */
+	asd_hwi_set_hw_addr(asd, LmSEQ_TX_ID_ADDR_FRAME(phy_id),
+			    phy->id_addr_map.busaddr);
+
+	asd_hwi_control_activity_leds(asd, phy->id, ENABLE_PHY);
+
+	asd_lock(asd, &flags);
+
+	scb = asd_hwi_get_scb(asd, 0);
+	if (scb == NULL) {
+		asd_log(ASD_DBG_ERROR, "Failed to get a free SCB.\n");
+		return (-1);
+	}
+
+	/* Store the phy pointer. */
+	scb->io_ctx = (void *) phy;
+	scb->flags |= SCB_INTERNAL;
+
+	/* Build CONTROL PHY SCB. */
+	asd_hwi_build_control_phy(scb, phy, ENABLE_PHY);
+
+	list_add_tail(&scb->owner_links, &phy->pending_scbs);
+
+	asd_hwi_post_scb(asd, scb);
+
+	asd_unlock(asd, &flags);
+
+	return (0);	
+}
+
+void
+asd_hwi_release_sata_spinup_hold(
+struct asd_softc	*asd,
+struct asd_phy		*phy
+)
+{
+	struct scb		*scb;
+	uint8_t			phy_id;
+	u_long		 	flags;
+
+	phy_id = phy->id;
+				
+	asd_lock(asd, &flags);
+
+	scb = asd_hwi_get_scb(asd, 0);
+	if (scb == NULL) {
+		asd_log(ASD_DBG_ERROR, "Failed to get a free SCB.\n");
+		return;
+	}
+
+	/* Store the phy pointer. */
+	scb->io_ctx = (void *) phy;
+	scb->flags |= SCB_INTERNAL;
+
+	/* Build CONTROL PHY SCB. */
+	asd_hwi_build_control_phy(scb, phy, RELEASE_SPINUP_HOLD);
+
+	list_add_tail(&scb->owner_links, &phy->pending_scbs);
+
+	asd_hwi_post_scb(asd, scb);
+
+	asd_unlock(asd, &flags);
+
+	return;
+}
+
+/* 
+ * Function:
+ *	asd_hwi_process_irq()
+ *
+ * Description:
+ *      Process any interrupts pending for our controller.
+ */
+int
+asd_hwi_process_irq(struct asd_softc *asd)
+{
+	struct asd_done_list	*dl_entry;
+	int			irq_processed;
+	uint32_t		intstat;
+
+	ASD_LOCK_ASSERT(asd);
+
+	/*
+	 * Check if any DL entries need to be processed.  If so,
+	 * bypass a costly read of our interrupt status register
+	 * and assume that the done list entries are the cause of
+	 * our interrupt.
+	 */
+	dl_entry = &asd->done_list[asd->dl_next];
+	if ((dl_entry->toggle & ASD_DL_TOGGLE_MASK) == asd->dl_valid)
+		intstat = DLAVAIL;
+	else
+		intstat = asd_read_dword(asd, CHIMINT);
+	if (intstat & DLAVAIL) {
+		asd_write_dword(asd, CHIMINT, DLAVAIL); 
+		/*
+		 * Ensure that the chip sees that we've cleared
+		 * this interrupt before we walk the done_list.
+		 * Otherwise, we may, due to posted bus writes,
+		 * clear the interrupt after we finish the scan,
+		 * and after the sequencer has added new entries
+		 * and asserted the interrupt again.
+		 *
+		 * NOTE: This extra read, and in fact the clearing
+		 *       of the command complete interrupt, will
+		 *       not be needed on systems using MSI.
+		 */
+		asd_flush_device_writes(asd);
+
+		asd_hwi_process_dl(asd);	
+
+		irq_processed = 1;
+	} else
+		irq_processed = 0;
+	
+	return (irq_processed);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_process_dl()
+ *
+ * Description:
+ *      Process posted Done List entries.
+ */
+static void
+asd_hwi_process_dl(struct asd_softc *asd)
+{
+	struct asd_done_list 	*dl_entry;
+	struct scb		*scb;
+
+	/*
+	 * Look for entries in the done list that have completed.
+	 * The valid_tag completion field indicates the validity
+	 * of the entry - the valid value toggles each time through
+	 * the queue.
+	 */
+	if ((asd->flags & ASD_RUNNING_DONE_LIST) != 0)
+		panic("asd_hwi_process_dl recursion");
+
+	asd->flags |= ASD_RUNNING_DONE_LIST;
+
+	for (;;) {
+		dl_entry = &asd->done_list[asd->dl_next];
+
+		if ((dl_entry->toggle & ASD_DL_TOGGLE_MASK) != asd->dl_valid)
+			break;
+
+		scb = asd->scbindex[dl_entry->index];
+
+		if ((scb->flags & SCB_PENDING) != 0) {
+			list_del(&scb->hwi_links);
+			scb->flags &= ~SCB_PENDING;
+		}
+
+		/* Process DL Entry. */
+		switch (dl_entry->opcode) {
+		case TASK_COMP_WO_ERR:
+		case TASK_COMP_W_UNDERRUN:
+		case TASK_COMP_W_OVERRUN:
+		case TASK_F_W_OPEN_REJECT:
+		case TASK_INT_W_BRK_RCVD:
+		case TASK_INT_W_PROT_ERR:
+		case SSP_TASK_COMP_W_RESP:
+		case TASK_INT_W_PHY_DOWN:
+		case LINK_ADMIN_TASK_COMP_W_RESP:
+		case CSMI_TASK_COMP_WO_ERR:
+		case ATA_TASK_COMP_W_RESP:
+		case TASK_INT_W_NAK_RCVD:
+		case RESUME_COMPLETE:
+		case TASK_INT_W_ACKNAK_TO:
+		case TASK_F_W_SMPRSP_TO:
+		case TASK_F_W_SMP_XMTRCV_ERR:
+		case TASK_F_W_NAK_RCVD:
+		case TASK_ABORTED_BY_ITNL_EXP:
+		case ATA_TASK_COMP_W_R_ERR_RCVD:
+		case TMF_F_W_TC_NOT_FOUND:
+		case TASK_ABORTED_ON_REQUEST:
+		case TMF_F_W_TAG_NOT_FOUND:
+		case TMF_F_W_TAG_ALREADY_FREE:
+		case TMF_F_W_TAG_ALREADY_DONE:
+		case TMF_F_W_CONN_HNDL_NOT_FOUND:
+		case TASK_CLEARED:
+		case TASK_UA_W_SYNCS_RCVD:
+			asd_pop_post_stack(asd, scb, dl_entry);
+			break;
+			
+		case CONTROL_PHY_TASK_COMP:
+		{
+			struct control_phy_sb	*cntrl_phy;
+			
+			cntrl_phy = &dl_entry->stat_blk.control_phy;
+	
+			if (cntrl_phy->sb_opcode == PHY_RESET_COMPLETED) {
+				asd_hwi_process_phy_comp(asd, scb, cntrl_phy);
+			} else {
+				asd_log(ASD_DBG_RUNTIME, "Invalid status "
+					"block upcode.\n");
+			}
+
+			/* 
+			 * Post routine needs to be called if the 
+			 * CONTROL PHY is issued as result of error recovery
+			 * process or from CSMI.
+			 */
+			if ((scb->flags & SCB_RECOVERY) != 0)
+				asd_pop_post_stack(asd, scb, dl_entry);
+
+			break;
+		}
+
+		default:
+			/* 
+			 * Making default case for EDB received and
+			 * and non supported DL opcode. 
+			 */
+			if ((dl_entry->opcode >= 0xC1) && 
+			    (dl_entry->opcode <= 0xC7)) 
+				asd_hwi_process_edb(asd, dl_entry);
+			else
+				asd_log(ASD_DBG_RUNTIME, 
+					"Received unsupported "
+					"DL entry (opcode = 0x%x).\n",
+				  	 dl_entry->opcode);
+
+			break;
+		}
+
+		asd->dl_next = (asd->dl_next + 1) & asd->dl_wrap_mask;
+		if (asd->dl_next == 0)
+			asd->dl_valid ^= ASD_DL_TOGGLE_MASK;
+	}
+
+	asd->flags &= ~ASD_RUNNING_DONE_LIST;
+} 
+
+/*
+ * Function:
+ * 	asd_hwi_process_phy_comp()
+ * 
+ * Description:
+ * 	Process phy reset completion.
+ */
+static void
+asd_hwi_process_phy_comp(struct asd_softc *asd, struct scb *scb,
+			 struct control_phy_sb *cntrl_phy)
+{
+	struct asd_phy			*phy;
+	struct asd_control_phy_hscb 	*cntrlphy_scb;
+
+	cntrlphy_scb = &scb->hscb->control_phy;
+	phy = (struct asd_phy *) scb->io_ctx;
+
+	switch (cntrlphy_scb->sub_func) {
+	case DISABLE_PHY:
+	{
+		asd->hw_profile.enabled_phys &= ~(1 << phy->id);
+		phy->state = ASD_PHY_OFFLINE;
+
+		/*
+		 * Check if this phy is attached to a target.
+	       	 */	 
+		if (phy->src_port != NULL) {
+			/*
+			 * DC: Currently, we treat this similar to loss of 
+			 *     signal scenario.
+			 *     Need to examine the behavior once the phy is
+			 *     is disabled !!
+			 *     Prior to disabling the phy that has target
+			 *     connected, we need to abort all outstanding
+			 *     IO to the affected target ports.
+		         */	 
+			phy->attr = (ASD_SSP_INITIATOR | ASD_SMP_INITIATOR | 
+			     	     ASD_STP_INITIATOR);
+			phy->src_port->events |= ASD_LOSS_OF_SIGNAL;
+			asd_wakeup_sem(&asd->platform_data->discovery_sem);
+		}
+		
+		list_del(&scb->owner_links);	
+		asd_hwi_free_scb(asd, scb);
+		break;
+	}
+
+	case ENABLE_PHY:
+		/* Check the OOB status from the link reset sequence. */
+		if (cntrl_phy->oob_status & CURRENT_OOB_DONE) {
+			if ((asd->hw_profile.enabled_phys & 
+				(1 << phy->id)) == 0)
+				asd->hw_profile.enabled_phys |= (1 << phy->id);
+
+			/* There is a device attached. */
+			if (cntrl_phy->oob_status & CURRENT_DEVICE_PRESENT) {
+				phy->attr |= ASD_DEVICE_PRESENT;
+
+				if (cntrl_phy->oob_status & CURRENT_SPINUP_HOLD)
+					phy->attr |= ASD_SATA_SPINUP_HOLD;
+
+				phy->state = ASD_PHY_WAITING_FOR_ID_ADDR;
+			} else {
+				phy->state = ASD_PHY_ONLINE;
+			}
+
+			/* Get the negotiated connection rate. */
+			if (cntrl_phy->oob_mode & PHY_SPEED_30)
+				phy->conn_rate = SAS_30GBPS_RATE;
+			else if (cntrl_phy->oob_mode & PHY_SPEED_15)
+				phy->conn_rate = SAS_15GBPS_RATE;
+			
+			/* Get the transport mode. */
+			if (cntrl_phy->oob_mode & SAS_MODE)
+				phy->attr |= ASD_SAS_MODE;
+			else if (cntrl_phy->oob_mode & SATA_MODE)
+				phy->attr |= ASD_SATA_MODE;
+		} else if (cntrl_phy->oob_status & CURRENT_SPINUP_HOLD) {
+			/*	
+			 * SATA target attached that has not been transmitted
+			 * COMWAKE (spun-up).
+			 */
+			asd_log(ASD_DBG_RUNTIME, "CURRENT SPINUP HOLD.\n");
+		
+			phy->attr |= ASD_SATA_SPINUP_HOLD;
+			phy->state = ASD_PHY_WAITING_FOR_ID_ADDR;
+
+		} else if (cntrl_phy->oob_status & CURRENT_ERR_MASK) {
+			asd_log(ASD_DBG_ERROR, "OOB ERROR.\n");
+			
+			phy->state = ASD_PHY_OFFLINE;
+		} else {
+			/* 
+			 * This should be the case when no device is
+			 * connected.
+			 */
+			phy->state = ASD_PHY_ONLINE;
+		}
+
+#ifdef ASD_TEST
+		asd_hwi_dump_phy(phy);
+#endif
+
+		if ((scb->flags & SCB_RECOVERY) == 0) {
+			list_del(&scb->owner_links);	
+			asd_hwi_free_scb(asd, scb);
+			asd_wakeup_sem(&asd->platform_data->discovery_sem);
+		} else {
+			scb->eh_status = (phy->state == ASD_PHY_OFFLINE) ?
+					  SCB_EH_FAILED : SCB_EH_SUCCEED;
+		}
+		break;
+
+	case RELEASE_SPINUP_HOLD:
+		/* To be implemented */
+		asd_log(ASD_DBG_RUNTIME,
+			"CONTROL PHY : RELEASE SPINUP HOLD.\n");
+		break;
+	
+	case PHY_NO_OP:
+		asd_log(ASD_DBG_RUNTIME, "CONTROL PHY : PHY NO OP.\n");
+
+		if ((scb->flags & SCB_RECOVERY) != 0) {
+			/*
+		 	 * PHY NO OP control completion. The phy no op was 
+			 * issued after HARD RESET completion.
+		 	 */
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_SUCCEED;
+		}
+		break;
+
+	case EXECUTE_HARD_RESET:
+		asd_log(ASD_DBG_RUNTIME,"CONTROL PHY : EXECUTE HARD RESET.\n");
+
+		if ((scb->flags & SCB_RECOVERY) != 0) {
+			/* 
+	    	 	 * Upon HARD RESET completion, we need to issue 
+			 * PHY NO OP control to enable the hot-plug timer 
+			 * which was disabled prior to issuing HARD RESET.
+		 	 */
+			scb->eh_state = SCB_EH_PHY_NO_OP_REQ;
+			scb->eh_status = SCB_EH_SUCCEED;
+		}
+		break;
+
+	default:
+		asd_log(ASD_DBG_RUNTIME,
+			"CONTROL PHY : INVALID SUBFUNC OPCODE.\n");
+		break;
+	}
+
+	return;
+}
+
+#ifdef ASD_TEST
+static void
+asd_hwi_dump_phy(struct asd_phy  *phy)
+{
+	u_char	i;
+	struct asd_port	*port;
+
+	port = phy->src_port;
+	
+	asd_print("Phy Id = 0x%x.\n", phy->id);
+	asd_print("Phy attr = 0x%x.\n", phy->attr);
+	asd_print("Phy state = 0x%x.\n", phy->state);
+	asd_print("Phy conn_rate = 0x%x.\n", phy->conn_rate);
+	asd_print("Phy src port = %p.\n", phy->src_port);
+	for (i = 0; i < 8; i++)
+		asd_print("Phy %d SAS ADDR[%d]=0x%x.\n", phy->id, i,
+				phy->sas_addr[i]);
+}
+#endif
+
+union edb *
+asd_hwi_indexes_to_edb(struct asd_softc *asd, struct scb **pscb,
+		       u_int escb_index, u_int edb_index)
+{
+	struct scb 		*scb;
+	struct asd_empty_hscb 	*escb;
+	struct empty_buf_elem 	*ebe;
+
+	if (escb_index > asd->hw_profile.max_scbs)
+		return (NULL);
+	scb = asd->scbindex[escb_index];
+	if (scb == NULL)
+		return (NULL);
+	escb = &scb->hscb->empty_scb;
+	ebe = &escb->buf_elem[edb_index];
+	if (ELEM_BUFFER_VALID_FIELD(ebe) != ELEM_BUFFER_VALID)
+		return (NULL);
+	*pscb = scb;
+	return (asd_hwi_get_edb_vaddr(asd, asd_le64toh(ebe->busaddr)));
+}
+
+/*
+ * Function:
+ * 	asd_hwi_process_edb()
+ *
+ * Description:
+ *	Process Empty Data Buffer that was posted by the sequencer.
+ */
+static void
+asd_hwi_process_edb(struct asd_softc *asd, struct asd_done_list *dl_entry)
+{
+	struct edb_rcvd_sb	*edbr;
+	union  edb		*edb;
+	struct scb		*scb;
+	struct asd_phy		*phy;
+	u_char			 phy_id;
+	u_char			 elem_id;
+
+	edbr = &dl_entry->stat_blk.edb_rcvd;
+	elem_id = (dl_entry->opcode & EDB_OPCODE_MASK) - 1;
+	phy_id = edbr->sb_opcode & EDB_OPCODE_MASK;
+	phy = asd->phy_list[phy_id];
+	edbr->sb_opcode &= ~EDB_OPCODE_MASK;	
+	
+	edb = asd_hwi_indexes_to_edb(asd, &scb,
+				     asd_le16toh(dl_entry->index),
+				     elem_id);
+
+	switch (edbr->sb_opcode) {
+	case BYTES_DMAED:
+	{
+		struct bytes_dmaed_subblk	*bytes_dmaed;
+		u_int				 bytes_rcvd;
+
+		bytes_dmaed = &edbr->edb_subblk.bytes_dmaed;
+		bytes_rcvd = asd_le16toh(bytes_dmaed->edb_len) & 
+			     BYTES_DMAED_LEN_MASK;
+
+		if (bytes_rcvd > sizeof(union sas_bytes_dmaed))
+			bytes_rcvd = sizeof(union sas_bytes_dmaed);
+
+		memcpy(&phy->bytes_dmaed_rcvd.id_addr_rcvd, edb, bytes_rcvd);
+		phy->events |= ASD_ID_ADDR_RCVD;
+		phy->state = ASD_PHY_WAITING_FOR_ID_ADDR;
+		asd_wakeup_sem(&asd->platform_data->discovery_sem);
+
+#ifdef ASD_TEST
+		asd_hwi_dump_phy_id_addr(phy);
+#endif
+
+		break;
+	}
+
+	case PRIMITIVE_RCVD:
+	{
+		struct primitive_rcvd_subblk	*prim_rcvd;
+
+		prim_rcvd = &edbr->edb_subblk.prim_rcvd;
+		asd_log(ASD_DBG_RUNTIME,
+			"EDB: PRIMITIVE RCVD. Addr = 0x%x, Cont = 0x%x\n", 
+			 prim_rcvd->reg_addr, prim_rcvd->reg_content);
+		/*
+		 * Only process primitive for phy(s) that already associated
+		 * with port.
+		 */
+		if (phy->src_port != NULL)
+			asd_hwi_process_prim_event(asd, phy,
+						   prim_rcvd->reg_addr,
+						   prim_rcvd->reg_content);
+		break;
+	}
+	
+	case PHY_EVENT:
+	{
+		struct phy_event_subblk *phy_event;
+
+		phy_event = &edbr->edb_subblk.phy_event;
+		asd_log(ASD_DBG_RUNTIME,
+			"EDB: PHY_EVENT. Stat 0x%x, Mode 0x%x, Sigs = 0x%x\n",
+			phy_event->oob_status, phy_event->oob_mode,
+			phy_event->oob_signals);
+
+		phy_event->oob_status &= CURRENT_PHY_MASK;
+		asd_hwi_process_phy_event(asd, phy, 
+					  phy_event->oob_status,
+					  phy_event->oob_mode);
+		break;
+	}
+	
+	case LINK_RESET_ERR:
+	{
+		struct link_reset_err_subblk	*link_rst;
+
+		link_rst = &edbr->edb_subblk.link_reset_err;
+
+		asd_log(ASD_DBG_RUNTIME, "EDB: LINK RESET ERRORS. \n");
+		asd_log(ASD_DBG_RUNTIME, "Timedout waiting %s from Phy %d.\n",
+			((link_rst->error == RCV_FIS_TIMER_EXP) ?
+			 "Initial Device-to-Host Register FIS"  :
+			 "IDENTITY Address Frame"), 
+			phy_id);
+
+		asd_hwi_handle_link_rst_err(asd, phy);
+		break;
+
+	}
+
+	case TIMER_EVENT:
+	{
+		struct timer_event_subblk *timer_event;
+
+		timer_event = &edbr->edb_subblk.timer_event; 
+
+		asd_log(ASD_DBG_RUNTIME, "EDB: TIMER EVENT. Error = 0x%x \n", 
+			timer_event->error);
+		break;
+	}
+	
+	case REQ_TASK_ABORT:
+	{
+		struct req_task_abort_subblk	*req_task_abort;
+			
+		asd_log(ASD_DBG_RUNTIME, "EDB: REQUEST TASK ABORT. \n");
+
+		req_task_abort = &edbr->edb_subblk.req_task_abort; 
+
+		asd_log(ASD_DBG_RUNTIME, "Req TC to Abort = 0x%x, "
+			"Reason = 0x%x.\n", req_task_abort->task_tc_to_abort,
+			req_task_abort->reason);
+
+		asd_hwi_process_req_task(asd, edbr->sb_opcode,
+					 req_task_abort->task_tc_to_abort);
+		break;
+	}
+		
+	case REQ_DEVICE_RESET:
+	{
+		struct req_dev_reset_subblk	*req_dev_reset;
+
+		asd_log(ASD_DBG_RUNTIME, "EDB: REQUEST DEVICE RESET. \n");
+
+		req_dev_reset = &edbr->edb_subblk.req_dev_reset; 
+
+		asd_log(ASD_DBG_RUNTIME, "Req TC to Reset = 0x%x, "
+			"Reason = 0x%x.\n", req_dev_reset->task_tc_to_abort,
+			req_dev_reset->reason);
+
+		asd_hwi_process_req_task(asd, edbr->sb_opcode,
+					 req_dev_reset->task_tc_to_abort);
+		break;
+	}
+
+	default:
+		asd_log(ASD_DBG_RUNTIME, "Invalid EDB opcode.\n");
+		break;
+	}
+		
+	asd_hwi_free_edb(asd, scb, (elem_id));
+}


