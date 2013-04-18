From: James Smart <james.smart@emulex.com>
Subject: [PATCH 18/22] lpfc 8.3.39: Fixed driver vector mapping to CPU
 affinity
Date: Wed, 17 Apr 2013 20:19:16 -0400
Message-ID: <1366244356.1513.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24333 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRATT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:19:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed driver vector mapping to CPU affinity


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 
 lpfc_attr.c |  137 +++++++++++++++++++++++++
 lpfc_hw4.h  |    5 
 lpfc_init.c |  322 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_sli.c  |   22 ++--
 lpfc_sli4.h |   16 ++
 6 files changed, 488 insertions(+), 15 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:38.186041147 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:52.668041476 -0400
@@ -3799,6 +3799,141 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba
 static DEVICE_ATTR(lpfc_fcp_imax, S_IRUGO | S_IWUSR,
 		   lpfc_fcp_imax_show, lpfc_fcp_imax_store);
 
+/**
+ * lpfc_state_show - Display current driver CPU affinity
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains text describing the state of the link.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_fcp_cpu_map_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_vector_map_info *cpup;
+	int  idx, len = 0;
+
+	if ((phba->sli_rev != LPFC_SLI_REV4) ||
+	    (phba->intr_type != MSIX))
+		return len;
+
+	switch (phba->cfg_fcp_cpu_map) {
+	case 0:
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"fcp_cpu_map: No mapping (%d)\n",
+				phba->cfg_fcp_cpu_map);
+		return len;
+	case 1:
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"fcp_cpu_map: HBA centric mapping (%d): "
+				"%d online CPUs\n",
+				phba->cfg_fcp_cpu_map,
+				phba->sli4_hba.num_online_cpu);
+		break;
+	case 2:
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"fcp_cpu_map: Driver centric mapping (%d): "
+				"%d online CPUs\n",
+				phba->cfg_fcp_cpu_map,
+				phba->sli4_hba.num_online_cpu);
+		break;
+	}
+
+	cpup = phba->sli4_hba.cpu_map;
+	for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
+		if (cpup->irq == LPFC_VECTOR_MAP_EMPTY)
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"CPU %02d io_chan %02d "
+					"physid %d coreid %d\n",
+					idx, cpup->channel_id, cpup->phys_id,
+					cpup->core_id);
+		else
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"CPU %02d io_chan %02d "
+					"physid %d coreid %d IRQ %d\n",
+					idx, cpup->channel_id, cpup->phys_id,
+					cpup->core_id, cpup->irq);
+
+		cpup++;
+	}
+	return len;
+}
+
+/**
+ * lpfc_fcp_cpu_map_store - Change CPU affinity of driver vectors
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: one or more lpfc_polling_flags values.
+ * @count: not used.
+ *
+ * Returns:
+ * -EINVAL  - Not implemented yet.
+ **/
+static ssize_t
+lpfc_fcp_cpu_map_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	int status = -EINVAL;
+	return status;
+}
+
+/*
+# lpfc_fcp_cpu_map: Defines how to map CPUs to IRQ vectors
+# for the HBA.
+#
+# Value range is [0 to 2]. Default value is LPFC_DRIVER_CPU_MAP (2).
+#	0 - Do not affinitze IRQ vectors
+#	1 - Affintize HBA vectors with respect to each HBA
+#	    (start with CPU0 for each HBA)
+#	2 - Affintize HBA vectors with respect to the entire driver
+#	    (round robin thru all CPUs across all HBAs)
+*/
+static int lpfc_fcp_cpu_map = LPFC_DRIVER_CPU_MAP;
+module_param(lpfc_fcp_cpu_map, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(lpfc_fcp_cpu_map,
+		 "Defines how to map CPUs to IRQ vectors per HBA");
+
+/**
+ * lpfc_fcp_cpu_map_init - Set the initial sr-iov virtual function enable
+ * @phba: lpfc_hba pointer.
+ * @val: link speed value.
+ *
+ * Description:
+ * If val is in a valid range [0-2], then affinitze the adapter's
+ * MSIX vectors.
+ *
+ * Returns:
+ * zero if val saved.
+ * -EINVAL val out of range
+ **/
+static int
+lpfc_fcp_cpu_map_init(struct lpfc_hba *phba, int val)
+{
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		phba->cfg_fcp_cpu_map = 0;
+		return 0;
+	}
+
+	if (val >= LPFC_MIN_CPU_MAP && val <= LPFC_MAX_CPU_MAP) {
+		phba->cfg_fcp_cpu_map = val;
+		return 0;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3326 fcp_cpu_map: %d out of range, using default\n",
+			val);
+	phba->cfg_fcp_cpu_map = LPFC_DRIVER_CPU_MAP;
+
+	return 0;
+}
+
+static DEVICE_ATTR(lpfc_fcp_cpu_map, S_IRUGO | S_IWUSR,
+		   lpfc_fcp_cpu_map_show, lpfc_fcp_cpu_map_store);
+
 /*
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
 # Value range is [2,3]. Default value is 3.
@@ -4154,6 +4289,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_poll_tmo,
 	&dev_attr_lpfc_use_msi,
 	&dev_attr_lpfc_fcp_imax,
+	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_wq_count,
 	&dev_attr_lpfc_fcp_eq_count,
 	&dev_attr_lpfc_fcp_io_channel,
@@ -5136,6 +5272,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_enable_rrq_init(phba, lpfc_enable_rrq);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
+	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
 	lpfc_fcp_wq_count_init(phba, lpfc_fcp_wq_count);
 	lpfc_fcp_eq_count_init(phba, lpfc_fcp_eq_count);
 	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:40.561041201 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:52.669041476 -0400
@@ -709,6 +709,7 @@ struct lpfc_hba {
 	uint32_t cfg_poll_tmo;
 	uint32_t cfg_use_msi;
 	uint32_t cfg_fcp_imax;
+	uint32_t cfg_fcp_cpu_map;
 	uint32_t cfg_fcp_wq_count;
 	uint32_t cfg_fcp_eq_count;
 	uint32_t cfg_fcp_io_channel;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2013-04-15 18:26:36.984041120 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2013-04-15 18:26:52.685041477 -0400
@@ -200,6 +200,11 @@ struct lpfc_sli_intf {
 #define LPFC_MAX_IMAX          5000000
 #define LPFC_DEF_IMAX          50000
 
+#define LPFC_MIN_CPU_MAP       0
+#define LPFC_MAX_CPU_MAP       2
+#define LPFC_HBA_CPU_MAP       1
+#define LPFC_DRIVER_CPU_MAP    2  /* Default */
+
 /* PORT_CAPABILITIES constants. */
 #define LPFC_MAX_SUPPORTED_PAGES	8
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:49.344041400 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:52.699041477 -0400
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
+#include <linux/percpu.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -58,6 +59,9 @@ char *_dump_buf_dif;
 unsigned long _dump_buf_dif_order;
 spinlock_t _dump_buf_lock;
 
+/* Used when mapping IRQ vectors in a driver centric manner */
+uint16_t lpfc_used_cpu[LPFC_MAX_CPU];
+
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
 static int lpfc_sli4_queue_verify(struct lpfc_hba *);
@@ -4861,6 +4865,7 @@ lpfc_sli_driver_resource_unset(struct lp
 static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
+	struct lpfc_vector_map_info *cpup;
 	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mboxq;
 	int rc, i, hbq_count, max_buf_size;
@@ -5198,6 +5203,26 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_fcp_eq_hdl;
 	}
 
+	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
+					 phba->sli4_hba.num_present_cpu),
+					 GFP_KERNEL);
+	if (!phba->sli4_hba.cpu_map) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3327 Failed allocate memory for msi-x "
+				"interrupt vector mapping\n");
+		rc = -ENOMEM;
+		goto out_free_msix;
+	}
+	/* Initialize io channels for round robin */
+	cpup = phba->sli4_hba.cpu_map;
+	rc = 0;
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		cpup->channel_id = rc;
+		rc++;
+		if (rc >= phba->cfg_fcp_io_channel)
+			rc = 0;
+	}
+
 	/*
 	 * Enable sr-iov virtual functions if supported and configured
 	 * through the module parameter.
@@ -5217,6 +5242,8 @@ lpfc_sli4_driver_resource_setup(struct l
 
 	return 0;
 
+out_free_msix:
+	kfree(phba->sli4_hba.msix_entries);
 out_free_fcp_eq_hdl:
 	kfree(phba->sli4_hba.fcp_eq_hdl);
 out_free_fcf_rr_bmask:
@@ -5246,6 +5273,11 @@ lpfc_sli4_driver_resource_unset(struct l
 {
 	struct lpfc_fcf_conn_entry *conn_entry, *next_conn_entry;
 
+	/* Free memory allocated for msi-x interrupt vector to CPU mapping */
+	kfree(phba->sli4_hba.cpu_map);
+	phba->sli4_hba.num_present_cpu = 0;
+	phba->sli4_hba.num_online_cpu = 0;
+
 	/* Free memory allocated for msi-x interrupt vector entries */
 	kfree(phba->sli4_hba.msix_entries);
 
@@ -6792,6 +6824,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	int cfg_fcp_io_channel;
 	uint32_t cpu;
 	uint32_t i = 0;
+	uint32_t j = 0;
 

 	/*
@@ -6802,15 +6835,21 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	/* Sanity check on HBA EQ parameters */
 	cfg_fcp_io_channel = phba->cfg_fcp_io_channel;
 
-	/* It doesn't make sense to have more io channels then CPUs */
-	for_each_online_cpu(cpu) {
-		i++;
+	/* It doesn't make sense to have more io channels then online CPUs */
+	for_each_present_cpu(cpu) {
+		if (cpu_online(cpu))
+			i++;
+		j++;
 	}
+	phba->sli4_hba.num_online_cpu = i;
+	phba->sli4_hba.num_present_cpu = j;
+
 	if (i < cfg_fcp_io_channel) {
 		lpfc_printf_log(phba,
 				KERN_ERR, LOG_INIT,
 				"3188 Reducing IO channels to match number of "
-				"CPUs: from %d to %d\n", cfg_fcp_io_channel, i);
+				"online CPUs: from %d to %d\n",
+				cfg_fcp_io_channel, i);
 		cfg_fcp_io_channel = i;
 	}
 
@@ -8310,6 +8349,269 @@ lpfc_sli_disable_intr(struct lpfc_hba *p
 }
 
 /**
+ * lpfc_find_next_cpu - Find next available CPU that matches the phys_id
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * Find next available CPU to use for IRQ to CPU affinity.
+ */
+static int
+lpfc_find_next_cpu(struct lpfc_hba *phba, uint32_t phys_id)
+{
+	struct lpfc_vector_map_info *cpup;
+	int cpu;
+
+	cpup = phba->sli4_hba.cpu_map;
+	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
+		/* CPU must be online */
+		if (cpu_online(cpu)) {
+			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
+			    (lpfc_used_cpu[cpu] == LPFC_VECTOR_MAP_EMPTY) &&
+			    (cpup->phys_id == phys_id)) {
+				return cpu;
+			}
+		}
+		cpup++;
+	}
+
+	/*
+	 * If we get here, we have used ALL CPUs for the specific
+	 * phys_id. Now we need to clear out lpfc_used_cpu and start
+	 * reusing CPUs.
+	 */
+
+	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
+		if (lpfc_used_cpu[cpu] == phys_id)
+			lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
+	}
+
+	cpup = phba->sli4_hba.cpu_map;
+	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
+		/* CPU must be online */
+		if (cpu_online(cpu)) {
+			if ((cpup->irq == LPFC_VECTOR_MAP_EMPTY) &&
+			    (cpup->phys_id == phys_id)) {
+				return cpu;
+			}
+		}
+		cpup++;
+	}
+	return LPFC_VECTOR_MAP_EMPTY;
+}
+
+/**
+ * lpfc_sli4_set_affinity - Set affinity for HBA IRQ vectors
+ * @phba:	pointer to lpfc hba data structure.
+ * @vectors:	number of HBA vectors
+ *
+ * Affinitize MSIX IRQ vectors to CPUs. Try to equally spread vector
+ * affinization across multple physical CPUs (numa nodes).
+ * In addition, this routine will assign an IO channel for each CPU
+ * to use when issuing I/Os.
+ */
+static int
+lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
+{
+	int i, idx, saved_chann, used_chann, cpu, phys_id;
+	int max_phys_id, num_io_channel, first_cpu;
+	struct lpfc_vector_map_info *cpup;
+#ifdef CONFIG_X86
+	struct cpuinfo_x86 *cpuinfo;
+#endif
+	struct cpumask *mask;
+	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
+
+	/* If there is no mapping, just return */
+	if (!phba->cfg_fcp_cpu_map)
+		return 1;
+
+	/* Init cpu_map array */
+	memset(phba->sli4_hba.cpu_map, 0xff,
+	       (sizeof(struct lpfc_vector_map_info) *
+		phba->sli4_hba.num_present_cpu));
+
+	max_phys_id = 0;
+	phys_id = 0;
+	num_io_channel = 0;
+	first_cpu = LPFC_VECTOR_MAP_EMPTY;
+
+	/* Update CPU map with physical id and core id of each CPU */
+	cpup = phba->sli4_hba.cpu_map;
+	for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++) {
+#ifdef CONFIG_X86
+		cpuinfo = &cpu_data(cpu);
+		cpup->phys_id = cpuinfo->phys_proc_id;
+		cpup->core_id = cpuinfo->cpu_core_id;
+#else
+		/* No distinction between CPUs for other platforms */
+		cpup->phys_id = 0;
+		cpup->core_id = 0;
+#endif
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3328 CPU physid %d coreid %d\n",
+				cpup->phys_id, cpup->core_id);
+
+		if (cpup->phys_id > max_phys_id)
+			max_phys_id = cpup->phys_id;
+		cpup++;
+	}
+
+	/* Now associate the HBA vectors with specific CPUs */
+	for (idx = 0; idx < vectors; idx++) {
+		cpup = phba->sli4_hba.cpu_map;
+		cpu = lpfc_find_next_cpu(phba, phys_id);
+		if (cpu == LPFC_VECTOR_MAP_EMPTY) {
+
+			/* Try for all phys_id's */
+			for (i = 1; i < max_phys_id; i++) {
+				phys_id++;
+				if (phys_id > max_phys_id)
+					phys_id = 0;
+				cpu = lpfc_find_next_cpu(phba, phys_id);
+				if (cpu == LPFC_VECTOR_MAP_EMPTY)
+					continue;
+				goto found;
+			}
+
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3329 Cannot set affinity:"
+					"Error mapping vector %d (%d)\n",
+					idx, vectors);
+			return 0;
+		}
+found:
+		cpup += cpu;
+		if (phba->cfg_fcp_cpu_map == LPFC_DRIVER_CPU_MAP)
+			lpfc_used_cpu[cpu] = phys_id;
+
+		/* Associate vector with selected CPU */
+		cpup->irq = phba->sli4_hba.msix_entries[idx].vector;
+
+		/* Associate IO channel with selected CPU */
+		cpup->channel_id = idx;
+		num_io_channel++;
+
+		if (first_cpu == LPFC_VECTOR_MAP_EMPTY)
+			first_cpu = cpu;
+
+		/* Now affinitize to the selected CPU */
+		mask = &cpup->maskbits;
+		cpumask_clear(mask);
+		cpumask_set_cpu(cpu, mask);
+		i = irq_set_affinity_hint(phba->sli4_hba.msix_entries[idx].
+					  vector, mask);
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"3330 Set Affinity: CPU %d channel %d "
+				"irq %d (%x)\n",
+				cpu, cpup->channel_id,
+				phba->sli4_hba.msix_entries[idx].vector, i);
+
+		/* Spread vector mapping across multple physical CPU nodes */
+		phys_id++;
+		if (phys_id > max_phys_id)
+			phys_id = 0;
+	}
+
+	/*
+	 * Finally fill in the IO channel for any remaining CPUs.
+	 * At this point, all IO channels have been assigned to a specific
+	 * MSIx vector, mapped to a specific CPU.
+	 * Base the remaining IO channel assigned, to IO channels already
+	 * assigned to other CPUs on the same phys_id.
+	 */
+	for (i = 0; i <= max_phys_id; i++) {
+		/*
+		 * If there are no io channels already mapped to
+		 * this phys_id, just round robin thru the io_channels.
+		 * Setup chann[] for round robin.
+		 */
+		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+			chann[idx] = idx;
+
+		saved_chann = 0;
+		used_chann = 0;
+
+		/*
+		 * First build a list of IO channels already assigned
+		 * to this phys_id before reassigning the same IO
+		 * channels to the remaining CPUs.
+		 */
+		cpup = phba->sli4_hba.cpu_map;
+		cpu = first_cpu;
+		cpup += cpu;
+		for (idx = 0; idx < phba->sli4_hba.num_present_cpu;
+		     idx++) {
+			if (cpup->phys_id == i) {
+				/*
+				 * Save any IO channels that are
+				 * already mapped to this phys_id.
+				 */
+				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
+					chann[saved_chann] =
+						cpup->channel_id;
+					saved_chann++;
+					goto out;
+				}
+
+				/* See if we are using round-robin */
+				if (saved_chann == 0)
+					saved_chann =
+						phba->cfg_fcp_io_channel;
+
+				/* Associate next IO channel with CPU */
+				cpup->channel_id = chann[used_chann];
+				num_io_channel++;
+				used_chann++;
+				if (used_chann == saved_chann)
+					used_chann = 0;
+
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+						"3331 Set IO_CHANN "
+						"CPU %d channel %d\n",
+						idx, cpup->channel_id);
+			}
+out:
+			cpu++;
+			if (cpu >= phba->sli4_hba.num_present_cpu) {
+				cpup = phba->sli4_hba.cpu_map;
+				cpu = 0;
+			} else {
+				cpup++;
+			}
+		}
+	}
+
+	if (phba->sli4_hba.num_online_cpu != phba->sli4_hba.num_present_cpu) {
+		cpup = phba->sli4_hba.cpu_map;
+		for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
+			if (cpup->channel_id == LPFC_VECTOR_MAP_EMPTY) {
+				cpup->channel_id = 0;
+				num_io_channel++;
+
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+						"3332 Assign IO_CHANN "
+						"CPU %d channel %d\n",
+						idx, cpup->channel_id);
+			}
+			cpup++;
+		}
+	}
+
+	/* Sanity check */
+	if (num_io_channel != phba->sli4_hba.num_present_cpu)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3333 Set affinity mismatch:"
+				"%d chann != %d cpus: %d vactors\n",
+				num_io_channel, phba->sli4_hba.num_present_cpu,
+				vectors);
+
+	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
+	return 1;
+}
+
+
+/**
  * lpfc_sli4_enable_msix - Enable MSI-X interrupt mode to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
  *
@@ -8360,9 +8662,7 @@ enable_msix_vectors:
 				phba->sli4_hba.msix_entries[index].vector,
 				phba->sli4_hba.msix_entries[index].entry);
 
-	/*
-	 * Assign MSI-X vectors to interrupt handlers
-	 */
+	/* Assign MSI-X vectors to interrupt handlers */
 	for (index = 0; index < vectors; index++) {
 		memset(&phba->sli4_hba.handler_name[index], 0, 16);
 		sprintf((char *)&phba->sli4_hba.handler_name[index],
@@ -8390,6 +8690,8 @@ enable_msix_vectors:
 				phba->cfg_fcp_io_channel, vectors);
 		phba->cfg_fcp_io_channel = vectors;
 	}
+
+	lpfc_sli4_set_affinity(phba, vectors);
 	return rc;
 
 cfg_fail_out:
@@ -10667,6 +10969,7 @@ static struct miscdevice lpfc_mgmt_dev =
 static int __init
 lpfc_init(void)
 {
+	int cpu;
 	int error = 0;
 
 	printk(LPFC_MODULE_DESC "\n");
@@ -10693,6 +10996,11 @@ lpfc_init(void)
 			return -ENOMEM;
 		}
 	}
+
+	/* Initialize in case vector mapping is needed */
+	for (cpu = 0; cpu < LPFC_MAX_CPU; cpu++)
+		lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
+
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
 		fc_release_transport(lpfc_transport_template);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2013-04-15 18:26:32.497041017 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2013-04-15 18:26:52.701041477 -0400
@@ -435,6 +435,17 @@ struct lpfc_sli4_lnk_info {
 
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 
+/* Used for IRQ vector to CPU mapping */
+struct lpfc_vector_map_info {
+	uint16_t	phys_id;
+	uint16_t	core_id;
+	uint16_t	irq;
+	uint16_t	channel_id;
+	struct cpumask	maskbits;
+};
+#define LPFC_VECTOR_MAP_EMPTY	0xffff
+#define LPFC_MAX_CPU		256
+
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -568,6 +579,11 @@ struct lpfc_sli4_hba {
 	struct lpfc_iov iov;
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
+
+	/* CPU to vector mapping information */
+	struct lpfc_vector_map_info *cpu_map;
+	uint16_t num_online_cpu;
+	uint16_t num_present_cpu;
 };
 
 enum lpfc_sge_type {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:50.486041427 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:52.730041478 -0400
@@ -7922,15 +7922,21 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 static inline uint32_t
 lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba)
 {
-	int i;
+	struct lpfc_vector_map_info *cpup;
+	int chann, cpu;
 
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU)
-		i = smp_processor_id();
-	else
-		i = atomic_add_return(1, &phba->fcp_qidx);
-
-	i = (i % phba->cfg_fcp_io_channel);
-	return i;
+	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU) {
+		cpu = smp_processor_id();
+		if (cpu < phba->sli4_hba.num_present_cpu) {
+			cpup = phba->sli4_hba.cpu_map;
+			cpup += cpu;
+			return cpup->channel_id;
+		}
+		chann = cpu;
+	}
+	chann = atomic_add_return(1, &phba->fcp_qidx);
+	chann = (chann % phba->cfg_fcp_io_channel);
+	return chann;
 }
 
 /**



