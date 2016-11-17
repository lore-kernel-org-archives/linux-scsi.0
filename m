From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] lpfc: use PCI-layer irq affinity handling
Date: Thu, 17 Nov 2016 16:14:53 +0100
Message-ID: <1479395693-5781-3-git-send-email-hch@lst.de>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcKQRF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 12:05:56 -0500
In-Reply-To: <1479395693-5781-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org

Use the PCI_IRQ_AFFINITY flags to pci_alloc_irq_vectors to get automatic
assignment of irq affinity from the core PCI and interrupt handling code.

For blk-mq we just have to wire it up to the default map_queues handler,
and for the non blk-mq case we keep a local copy of the map_queues helper,
which operates on the lpfc-internal lpfc_hba structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/lpfc/lpfc.h      |   3 -
 drivers/scsi/lpfc/lpfc_attr.c | 168 --------------------
 drivers/scsi/lpfc/lpfc_init.c | 346 +++---------------------------------------
 drivers/scsi/lpfc/lpfc_scsi.c |  35 ++---
 drivers/scsi/lpfc/lpfc_sli4.h |  16 +-
 5 files changed, 38 insertions(+), 530 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e4a57cf..8b205a2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -711,7 +711,6 @@ struct lpfc_hba {
 #define LPFC_FCF_FOV 1		/* Fast fcf failover */
 #define LPFC_FCF_PRIORITY 2	/* Priority fcf failover */
 	uint32_t cfg_fcf_failover_policy;
-	uint32_t cfg_fcp_io_sched;
 	uint32_t cfg_fcp2_no_tgt_reset;
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
@@ -789,8 +788,6 @@ struct lpfc_hba {
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
-	atomic_t fcp_qidx;		/* next work queue to post work to */
-
 	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
 	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
 	phys_addr_t pci_bar2_map;     /* Physical address for PCI BAR2 */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c847755..b4825bd 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4189,157 +4189,6 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba, int val)
 static DEVICE_ATTR(lpfc_fcp_imax, S_IRUGO | S_IWUSR,
 		   lpfc_fcp_imax_show, lpfc_fcp_imax_store);
 
-/**
- * lpfc_state_show - Display current driver CPU affinity
- * @dev: class converted to a Scsi_host structure.
- * @attr: device attribute, not used.
- * @buf: on return contains text describing the state of the link.
- *
- * Returns: size of formatted string.
- **/
-static ssize_t
-lpfc_fcp_cpu_map_show(struct device *dev, struct device_attribute *attr,
-		      char *buf)
-{
-	struct Scsi_Host  *shost = class_to_shost(dev);
-	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_vector_map_info *cpup;
-	int  len = 0;
-
-	if ((phba->sli_rev != LPFC_SLI_REV4) ||
-	    (phba->intr_type != MSIX))
-		return len;
-
-	switch (phba->cfg_fcp_cpu_map) {
-	case 0:
-		len += snprintf(buf + len, PAGE_SIZE-len,
-				"fcp_cpu_map: No mapping (%d)\n",
-				phba->cfg_fcp_cpu_map);
-		return len;
-	case 1:
-		len += snprintf(buf + len, PAGE_SIZE-len,
-				"fcp_cpu_map: HBA centric mapping (%d): "
-				"%d online CPUs\n",
-				phba->cfg_fcp_cpu_map,
-				phba->sli4_hba.num_online_cpu);
-		break;
-	case 2:
-		len += snprintf(buf + len, PAGE_SIZE-len,
-				"fcp_cpu_map: Driver centric mapping (%d): "
-				"%d online CPUs\n",
-				phba->cfg_fcp_cpu_map,
-				phba->sli4_hba.num_online_cpu);
-		break;
-	}
-
-	while (phba->sli4_hba.curr_disp_cpu < phba->sli4_hba.num_present_cpu) {
-		cpup = &phba->sli4_hba.cpu_map[phba->sli4_hba.curr_disp_cpu];
-
-		/* margin should fit in this and the truncated message */
-		if (cpup->irq == LPFC_VECTOR_MAP_EMPTY)
-			len += snprintf(buf + len, PAGE_SIZE-len,
-					"CPU %02d io_chan %02d "
-					"physid %d coreid %d\n",
-					phba->sli4_hba.curr_disp_cpu,
-					cpup->channel_id, cpup->phys_id,
-					cpup->core_id);
-		else
-			len += snprintf(buf + len, PAGE_SIZE-len,
-					"CPU %02d io_chan %02d "
-					"physid %d coreid %d IRQ %d\n",
-					phba->sli4_hba.curr_disp_cpu,
-					cpup->channel_id, cpup->phys_id,
-					cpup->core_id, cpup->irq);
-
-		phba->sli4_hba.curr_disp_cpu++;
-
-		/* display max number of CPUs keeping some margin */
-		if (phba->sli4_hba.curr_disp_cpu <
-				phba->sli4_hba.num_present_cpu &&
-				(len >= (PAGE_SIZE - 64))) {
-			len += snprintf(buf + len, PAGE_SIZE-len, "more...\n");
-			break;
-		}
-	}
-
-	if (phba->sli4_hba.curr_disp_cpu == phba->sli4_hba.num_present_cpu)
-		phba->sli4_hba.curr_disp_cpu = 0;
-
-	return len;
-}
-
-/**
- * lpfc_fcp_cpu_map_store - Change CPU affinity of driver vectors
- * @dev: class device that is converted into a Scsi_host.
- * @attr: device attribute, not used.
- * @buf: one or more lpfc_polling_flags values.
- * @count: not used.
- *
- * Returns:
- * -EINVAL  - Not implemented yet.
- **/
-static ssize_t
-lpfc_fcp_cpu_map_store(struct device *dev, struct device_attribute *attr,
-		       const char *buf, size_t count)
-{
-	int status = -EINVAL;
-	return status;
-}
-
-/*
-# lpfc_fcp_cpu_map: Defines how to map CPUs to IRQ vectors
-# for the HBA.
-#
-# Value range is [0 to 2]. Default value is LPFC_DRIVER_CPU_MAP (2).
-#	0 - Do not affinitze IRQ vectors
-#	1 - Affintize HBA vectors with respect to each HBA
-#	    (start with CPU0 for each HBA)
-#	2 - Affintize HBA vectors with respect to the entire driver
-#	    (round robin thru all CPUs across all HBAs)
-*/
-static int lpfc_fcp_cpu_map = LPFC_DRIVER_CPU_MAP;
-module_param(lpfc_fcp_cpu_map, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(lpfc_fcp_cpu_map,
-		 "Defines how to map CPUs to IRQ vectors per HBA");
-
-/**
- * lpfc_fcp_cpu_map_init - Set the initial sr-iov virtual function enable
- * @phba: lpfc_hba pointer.
- * @val: link speed value.
- *
- * Description:
- * If val is in a valid range [0-2], then affinitze the adapter's
- * MSIX vectors.
- *
- * Returns:
- * zero if val saved.
- * -EINVAL val out of range
- **/
-static int
-lpfc_fcp_cpu_map_init(struct lpfc_hba *phba, int val)
-{
-	if (phba->sli_rev != LPFC_SLI_REV4) {
-		phba->cfg_fcp_cpu_map = 0;
-		return 0;
-	}
-
-	if (val >= LPFC_MIN_CPU_MAP && val <= LPFC_MAX_CPU_MAP) {
-		phba->cfg_fcp_cpu_map = val;
-		return 0;
-	}
-
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"3326 lpfc_fcp_cpu_map: %d out of range, using "
-			"default\n", val);
-	phba->cfg_fcp_cpu_map = LPFC_DRIVER_CPU_MAP;
-
-	return 0;
-}
-
-static DEVICE_ATTR(lpfc_fcp_cpu_map, S_IRUGO | S_IWUSR,
-		   lpfc_fcp_cpu_map_show, lpfc_fcp_cpu_map_store);
-
 /*
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
 # Value range is [2,3]. Default value is 3.
@@ -4409,19 +4258,6 @@ static DEVICE_ATTR(lpfc_max_scsicmpl_time, S_IRUGO | S_IWUSR,
 LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
 
 /*
-# lpfc_fcp_io_sched: Determine scheduling algrithmn for issuing FCP cmds
-# range is [0,1]. Default value is 0.
-# For [0], FCP commands are issued to Work Queues ina round robin fashion.
-# For [1], FCP commands are issued to a Work Queue associated with the
-#          current CPU.
-# It would be set to 1 by the driver if it's able to set up cpu affinity
-# for FCP I/Os through Work Queue associated with the current CPU. Otherwise,
-# roundrobin scheduling of FCP I/Os through WQs will be used.
-*/
-LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algorithm for "
-		"issuing commands [0] - Round Robin, [1] - Current CPU");
-
-/*
 # lpfc_fcp2_no_tgt_reset: Determine bus reset behavior
 # range is [0,1]. Default value is 0.
 # For [0], bus reset issues target reset to ALL devices
@@ -4719,7 +4555,6 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_topology,
 	&dev_attr_lpfc_scan_down,
 	&dev_attr_lpfc_link_speed,
-	&dev_attr_lpfc_fcp_io_sched,
 	&dev_attr_lpfc_fcp2_no_tgt_reset,
 	&dev_attr_lpfc_cr_delay,
 	&dev_attr_lpfc_cr_count,
@@ -4747,7 +4582,6 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_task_mgmt_tmo,
 	&dev_attr_lpfc_use_msi,
 	&dev_attr_lpfc_fcp_imax,
-	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
@@ -5724,7 +5558,6 @@ struct fc_function_template lpfc_vport_transport_functions = {
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
-	lpfc_fcp_io_sched_init(phba, lpfc_fcp_io_sched);
 	lpfc_fcp2_no_tgt_reset_init(phba, lpfc_fcp2_no_tgt_reset);
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
@@ -5743,7 +5576,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_enable_SmartSAN_init(phba, lpfc_enable_SmartSAN);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
-	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c4e8fad..0202d79 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -60,10 +60,6 @@ char *_dump_buf_dif;
 unsigned long _dump_buf_dif_order;
 spinlock_t _dump_buf_lock;
 
-/* Used when mapping IRQ vectors in a driver centric manner */
-uint16_t *lpfc_used_cpu;
-uint32_t lpfc_present_cpu;
-
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
 static int lpfc_sli4_queue_verify(struct lpfc_hba *);
@@ -5175,7 +5171,6 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
 static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_vector_map_info *cpup;
 	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mboxq;
 	int rc, i, hbq_count, max_buf_size;
@@ -5510,40 +5505,15 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_fcf_rr_bmask;
 	}
 
-	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
-					 phba->sli4_hba.num_present_cpu),
-					 GFP_KERNEL);
-	if (!phba->sli4_hba.cpu_map) {
+	phba->sli4_hba.channel_map = kcalloc(nr_cpu_ids,
+			sizeof(*phba->sli4_hba.channel_map), GFP_KERNEL);
+	if (!phba->sli4_hba.channel_map) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3327 Failed allocate memory for msi-x "
 				"interrupt vector mapping\n");
 		rc = -ENOMEM;
 		goto out_free_fcp_eq_hdl;
 	}
-	if (lpfc_used_cpu == NULL) {
-		lpfc_used_cpu = kzalloc((sizeof(uint16_t) * lpfc_present_cpu),
-					 GFP_KERNEL);
-		if (!lpfc_used_cpu) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3335 Failed allocate memory for msi-x "
-					"interrupt vector mapping\n");
-			kfree(phba->sli4_hba.cpu_map);
-			rc = -ENOMEM;
-			goto out_free_fcp_eq_hdl;
-		}
-		for (i = 0; i < lpfc_present_cpu; i++)
-			lpfc_used_cpu[i] = LPFC_VECTOR_MAP_EMPTY;
-	}
-
-	/* Initialize io channels for round robin */
-	cpup = phba->sli4_hba.cpu_map;
-	rc = 0;
-	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-		cpup->channel_id = rc;
-		rc++;
-		if (rc >= phba->cfg_fcp_io_channel)
-			rc = 0;
-	}
 
 	/*
 	 * Enable sr-iov virtual functions if supported and configured
@@ -5594,10 +5564,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	struct lpfc_fcf_conn_entry *conn_entry, *next_conn_entry;
 
 	/* Free memory allocated for msi-x interrupt vector to CPU mapping */
-	kfree(phba->sli4_hba.cpu_map);
-	phba->sli4_hba.num_present_cpu = 0;
-	phba->sli4_hba.num_online_cpu = 0;
-	phba->sli4_hba.curr_disp_cpu = 0;
+	kfree(phba->sli4_hba.channel_map);
 
 	/* Free memory allocated for fast-path work queue handles */
 	kfree(phba->sli4_hba.fcp_eq_hdl);
@@ -7228,9 +7195,6 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 		if (cpu_online(cpu))
 			i++;
 	}
-	phba->sli4_hba.num_online_cpu = i;
-	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
-	phba->sli4_hba.curr_disp_cpu = 0;
 
 	if (i < cfg_fcp_io_channel) {
 		lpfc_printf_log(phba,
@@ -8691,286 +8655,28 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
 	phba->sli.slistat.sli_intr = 0;
 }
 
-/**
- * lpfc_find_next_cpu - Find next available CPU that matches the phys_id
- * @phba: pointer to lpfc hba data structure.
- *
- * Find next available CPU to use for IRQ to CPU affinity.
- */
-static int
-lpfc_find_next_cpu(struct lpfc_hba *phba, uint32_t phys_id)
-{
-	struct lpfc_vector_map_info *cpup;
-	int cpu;
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (lpfc_used_cpu[cpu] == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-
-	/*
-	 * If we get here, we have used ALL CPUs for the specific
-	 * phys_id. Now we need to clear out lpfc_used_cpu and start
-	 * reusing CPUs.
-	 */
-
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		if (lpfc_used_cpu[cpu] == phys_id)
-			lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
-	}
-
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-		/* CPU must be online */
-		if (cpu_online(cpu)) {
-			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
-			    (cpup->phys_id == phys_id)) {
-				return cpu;
-			}
-		}
-		cpup++;
-	}
-	return LPFC_VECTOR_MAP_EMPTY;
-}
-
-/**
- * lpfc_sli4_set_affinity - Set affinity for HBA IRQ vectors
- * @phba:	pointer to lpfc hba data structure.
- * @vectors:	number of HBA vectors
- *
- * Affinitize MSIX IRQ vectors to CPUs. Try to equally spread vector
- * affinization across multple physical CPUs (numa nodes).
- * In addition, this routine will assign an IO channel for each CPU
- * to use when issuing I/Os.
- */
 static int
 lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 {
-	int i, idx, saved_chann, used_chann, cpu, phys_id;
-	int max_phys_id, min_phys_id;
-	int num_io_channel, first_cpu, chan;
-	struct lpfc_vector_map_info *cpup;
-#ifdef CONFIG_X86
-	struct cpuinfo_x86 *cpuinfo;
-#endif
-	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
+	const struct cpumask *mask;
+	int cpu, i;
 
 	/* If there is no mapping, just return */
 	if (!phba->cfg_fcp_cpu_map)
 		return 1;
 
-	/* Init cpu_map array */
-	memset(phba->sli4_hba.cpu_map, 0xff,
-	       (sizeof(struct lpfc_vector_map_info) *
-		phba->sli4_hba.num_present_cpu));
-
-	max_phys_id = 0;
-	min_phys_id = 0xff;
-	phys_id = 0;
-	num_io_channel = 0;
-	first_cpu = LPFC_VECTOR_MAP_EMPTY;
-
-	/* Update CPU map with physical id and core id of each CPU */
-	cpup = phba->sli4_hba.cpu_map;
-	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
-#ifdef CONFIG_X86
-		cpuinfo = &cpu_data(cpu);
-		cpup->phys_id = cpuinfo->phys_proc_id;
-		cpup->core_id = cpuinfo->cpu_core_id;
-#else
-		/* No distinction between CPUs for other platforms */
-		cpup->phys_id = 0;
-		cpup->core_id = 0;
-#endif
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3328 CPU physid %d coreid %d\n",
-				cpup->phys_id, cpup->core_id);
-
-		if (cpup->phys_id > max_phys_id)
-			max_phys_id = cpup->phys_id;
-		if (cpup->phys_id < min_phys_id)
-			min_phys_id = cpup->phys_id;
-		cpup++;
-	}
-
-	phys_id = min_phys_id;
-	/* Now associate the HBA vectors with specific CPUs */
-	for (idx = 0; idx < vectors; idx++) {
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = lpfc_find_next_cpu(phba, phys_id);
-		if (cpu == LPFC_VECTOR_MAP_EMPTY) {
-
-			/* Try for all phys_id's */
-			for (i = 1; i < max_phys_id; i++) {
-				phys_id++;
-				if (phys_id > max_phys_id)
-					phys_id = min_phys_id;
-				cpu = lpfc_find_next_cpu(phba, phys_id);
-				if (cpu == LPFC_VECTOR_MAP_EMPTY)
-					continue;
-				goto found;
-			}
-
-			/* Use round robin for scheduling */
-			phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_ROUND_ROBIN;
-			chan = 0;
-			cpup = phba->sli4_hba.cpu_map;
-			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-				cpup->channel_id = chan;
-				cpup++;
-				chan++;
-				if (chan >= phba->cfg_fcp_io_channel)
-					chan = 0;
-			}
-
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"3329 Cannot set affinity:"
-					"Error mapping vector %d (%d)\n",
-					idx, vectors);
-			return 0;
-		}
-found:
-		cpup += cpu;
-		if (phba->cfg_fcp_cpu_map == LPFC_DRIVER_CPU_MAP)
-			lpfc_used_cpu[cpu] = phys_id;
-
-		/* Associate vector with selected CPU */
-		cpup->irq = pci_irq_vector(phba->pcidev, idx);
-
-		/* Associate IO channel with selected CPU */
-		cpup->channel_id = idx;
-		num_io_channel++;
-
-		if (first_cpu == LPFC_VECTOR_MAP_EMPTY)
-			first_cpu = cpu;
-
-		/* Now affinitize to the selected CPU */
-		i = irq_set_affinity_hint(pci_irq_vector(phba->pcidev, idx),
-					  get_cpu_mask(cpu));
-
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3330 Set Affinity: CPU %d channel %d "
-				"irq %d (%x)\n",
-				cpu, cpup->channel_id,
-				pci_irq_vector(phba->pcidev, idx), i);
-
-		/* Spread vector mapping across multple physical CPU nodes */
-		phys_id++;
-		if (phys_id > max_phys_id)
-			phys_id = min_phys_id;
-	}
-
-	/*
-	 * Finally fill in the IO channel for any remaining CPUs.
-	 * At this point, all IO channels have been assigned to a specific
-	 * MSIx vector, mapped to a specific CPU.
-	 * Base the remaining IO channel assigned, to IO channels already
-	 * assigned to other CPUs on the same phys_id.
-	 */
-	for (i = min_phys_id; i <= max_phys_id; i++) {
-		/*
-		 * If there are no io channels already mapped to
-		 * this phys_id, just round robin thru the io_channels.
-		 * Setup chann[] for round robin.
-		 */
-		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
-			chann[idx] = idx;
-
-		saved_chann = 0;
-		used_chann = 0;
-
-		/*
-		 * First build a list of IO channels already assigned
-		 * to this phys_id before reassigning the same IO
-		 * channels to the remaining CPUs.
-		 */
-		cpup = phba->sli4_hba.cpu_map;
-		cpu = first_cpu;
-		cpup += cpu;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu;
-		     idx++) {
-			if (cpup->phys_id == i) {
-				/*
-				 * Save any IO channels that are
-				 * already mapped to this phys_id.
-				 */
-				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
-					if (saved_chann <=
-					    LPFC_FCP_IO_CHAN_MAX) {
-						chann[saved_chann] =
-							cpup->channel_id;
-						saved_chann++;
-					}
-					goto out;
-				}
-
-				/* See if we are using round-robin */
-				if (saved_chann == 0)
-					saved_chann =
-						phba->cfg_fcp_io_channel;
+	for (i = 0; i < vectors; i++) {
+		mask = pci_irq_get_affinity(phba->pcidev, i);
+		if (!mask)
+			return -EINVAL;
 
-				/* Associate next IO channel with CPU */
-				cpup->channel_id = chann[used_chann];
-				num_io_channel++;
-				used_chann++;
-				if (used_chann == saved_chann)
-					used_chann = 0;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3331 Set IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-out:
-			cpu++;
-			if (cpu >= phba->sli4_hba.num_present_cpu) {
-				cpup = phba->sli4_hba.cpu_map;
-				cpu = 0;
-			} else {
-				cpup++;
-			}
-		}
+		for_each_cpu(cpu, mask)
+			phba->sli4_hba.channel_map[cpu] = i;
 	}
 
-	if (phba->sli4_hba.num_online_cpu != phba->sli4_hba.num_present_cpu) {
-		cpup = phba->sli4_hba.cpu_map;
-		for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
-			if (cpup->channel_id == LPFC_VECTOR_MAP_EMPTY) {
-				cpup->channel_id = 0;
-				num_io_channel++;
-
-				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-						"3332 Assign IO_CHANN "
-						"CPU %d channel %d\n",
-						idx, cpup->channel_id);
-			}
-			cpup++;
-		}
-	}
-
-	/* Sanity check */
-	if (num_io_channel != phba->sli4_hba.num_present_cpu)
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3333 Set affinity mismatch:"
-				"%d chann != %d cpus: %d vectors\n",
-				num_io_channel, phba->sli4_hba.num_present_cpu,
-				vectors);
-
-	/* Enable using cpu affinity for scheduling */
-	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
 	return 1;
 }
 
-
 /**
  * lpfc_sli4_enable_msix - Enable MSI-X interrupt mode to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
@@ -8986,13 +8692,17 @@ static int
 lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 {
 	int vectors, rc, index;
+	struct irq_affinity desc = { 0, };
 
 	/* Set up MSI-X multi-message vectors */
 	vectors = phba->cfg_fcp_io_channel;
-	if (phba->cfg_fof)
+	if (phba->cfg_fof) {
 		vectors++;
+		desc.post_vectors++;
+	}
 
-	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors, PCI_IRQ_MSIX);
+	rc = pci_alloc_irq_vectors_affinity(phba->pcidev, 2, vectors,
+			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
 	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
@@ -9046,10 +8756,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 cfg_fail_out:
 	/* free the irq already requested */
 	for (--index; index >= 0; index--) {
-		int irq = pci_irq_vector(phba->pcidev, index);
-
-		irq_set_affinity_hint(irq, NULL);
-		free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
+		free_irq(pci_irq_vector(phba->pcidev, index),
+			&phba->sli4_hba.fcp_eq_hdl[index]);
 	}
 
 	/* Unconfigure MSI-X capability structure */
@@ -9199,10 +8907,8 @@ lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 
 		/* Free up MSI-X multi-message vectors */
 		for (index = 0; index < phba->cfg_fcp_io_channel; index++) {
-			int irq = pci_irq_vector(phba->pcidev, index);
-
-			irq_set_affinity_hint(irq, NULL);
-			free_irq(irq, &phba->sli4_hba.fcp_eq_hdl[index]);
+			free_irq(pci_irq_vector(phba->pcidev, index),
+				&phba->sli4_hba.fcp_eq_hdl[index]);
 		}
 
 		if (phba->cfg_fof)
@@ -11345,7 +11051,6 @@ static struct miscdevice lpfc_mgmt_dev = {
 static int __init
 lpfc_init(void)
 {
-	int cpu;
 	int error = 0;
 
 	printk(LPFC_MODULE_DESC "\n");
@@ -11369,12 +11074,6 @@ lpfc_init(void)
 		return -ENOMEM;
 	}
 
-	/* Initialize in case vector mapping is needed */
-	lpfc_used_cpu = NULL;
-	lpfc_present_cpu = 0;
-	for_each_present_cpu(cpu)
-		lpfc_present_cpu++;
-
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
 		fc_release_transport(lpfc_transport_template);
@@ -11411,7 +11110,6 @@ lpfc_exit(void)
 				(1L << _dump_buf_dif_order), _dump_buf_dif);
 		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
 	}
-	kfree(lpfc_used_cpu);
 	idr_destroy(&lpfc_hba_index);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1b0ef79..f28b4e6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <asm/unaligned.h>
 #include <linux/crc-t10dif.h>
+#include <linux/blk-mq-pci.h>
 #include <net/checksum.h>
 
 #include <scsi/scsi.h>
@@ -3875,33 +3876,16 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 				  struct lpfc_scsi_buf *lpfc_cmd)
 {
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
-	struct lpfc_vector_map_info *cpup;
-	int chann, cpu;
-	uint32_t tag;
-	uint16_t hwq;
 
 	if (cmnd && shost_use_blk_mq(cmnd->device->host)) {
-		tag = blk_mq_unique_tag(cmnd->request);
-		hwq = blk_mq_unique_tag_to_hwq(tag);
+		u32 tag = blk_mq_unique_tag(cmnd->request);
 
-		return hwq;
-	}
-
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
-	    && phba->cfg_fcp_io_channel > 1) {
-		cpu = smp_processor_id();
-		if (cpu < phba->sli4_hba.num_present_cpu) {
-			cpup = phba->sli4_hba.cpu_map;
-			cpup += cpu;
-			return cpup->channel_id;
-		}
+		return blk_mq_unique_tag_to_hwq(tag);
+	} else {
+		return phba->sli4_hba.channel_map[raw_smp_processor_id()];
 	}
-	chann = atomic_add_return(1, &phba->fcp_qidx);
-	chann = (chann % phba->cfg_fcp_io_channel);
-	return chann;
 }
 
-
 /**
  * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
  * @phba: The Hba for which this call is being executed.
@@ -5569,6 +5553,13 @@ lpfc_slave_destroy(struct scsi_device *sdev)
 	return;
 }
 
+static int lpfc_map_queues(struct Scsi_Host *shost)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+
+	return blk_mq_pci_map_queues(&shost->tag_set, vport->phba->pcidev);
+}
+
 /**
  * lpfc_create_device_data - creates and initializes device data structure for OAS
  * @pha: Pointer to host bus adapter structure.
@@ -5935,6 +5926,7 @@ struct scsi_host_template lpfc_template = {
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
 	.scan_finished		= lpfc_scan_finished,
+	.map_queues		= lpfc_map_queues,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
@@ -5960,6 +5952,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
 	.scan_finished		= lpfc_scan_finished,
+	.map_queues		= lpfc_map_queues,
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index dfbb25e..a5bbce8 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -449,15 +449,6 @@ struct lpfc_sli4_lnk_info {
 					 LPFC_FOF_IO_CHAN_NUM)
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 
-/* Used for IRQ vector to CPU mapping */
-struct lpfc_vector_map_info {
-	uint16_t	phys_id;
-	uint16_t	core_id;
-	uint16_t	irq;
-	uint16_t	channel_id;
-};
-#define LPFC_VECTOR_MAP_EMPTY	0xffff
-
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -605,11 +596,8 @@ struct lpfc_sli4_hba {
 	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
 	uint32_t physical_port;
 
-	/* CPU to vector mapping information */
-	struct lpfc_vector_map_info *cpu_map;
-	uint16_t num_online_cpu;
-	uint16_t num_present_cpu;
-	uint16_t curr_disp_cpu;
+	/* CPU to vector mapping information (for the non blk-mq case) */
+	unsigned int *channel_map;
 };
 
 enum lpfc_sge_type {
-- 
2.1.4

