From: Edmund Nadolski <edmund.nadolski@intel.com>
Subject: RE: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Fri, 8 Apr 2011 17:55:18 -0600
Message-ID: <20110408235518.GD18265@aontest.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1DHX5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 19:57:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: dan.j.williams@intel.com, linux-scsi@vger.kernel.org, dmilburn@redhat.com, dave.jiang@intel.com, ed.ciechanowski@intel.com, jacek.danecki@intel.com, jeffrey.d.skirvin@intel.com, artur.wojcik@intel.com

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, April 02, 2011 6:15 AM
> To: Williams, Dan J
> Cc: linux-scsi; David Milburn; Jiang, Dave; Ciechanowski, Ed; Nadolski,
> Edmund; Danecki, Jacek; Skirvin, Jeffrey D
> Subject: [PATCH, RFC] isci: simplify dma coherent allocation
> 
> Remove the insane infrastructure for preallocating coheren DMA regions,
> and just allocate the memory where needed.  This also gets rid of the
> aligment adjustments given that Documentation/DMA-API-HOWTO.txt sais:
> 
>   "The cpu return address and the DMA bus master address are both
>    guaranteed to be aligned to the smallest PAGE_SIZE order which
>    is greater than or equal to the requested size.  This invariant
>    exists (for example) to guarantee that if you allocate a chunk
>    which is smaller than or equal to 64 kilobytes, the extent of the
>    buffer you receive will not cross a 64K boundary."
> 


The above patch introduces an issue where the dmam_alloc_coherent()
gets called in a path where the scic_lock is held, resulting in the
following trace at boot:

[    7.638222] isci: Intel(R) C600 SAS Controller Driver
[    7.644006] isci 0000:08:00.0: driver configured for A2 silicon (rev: 0)
[    7.660558] isci 0000:08:00.0: OEM SAS parameters (version: 1.0) loaded (firmware)
[    7.669148] isci 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.680288] scsi0 : isci
[    7.684369] ------------[ cut here ]------------
[    7.684754] Fixed MDIO Bus: probed
[    7.684780] PPP generic driver version 2.4.2
[    7.684818] tun: Universal TUN/TAP device driver, 1.6
[    7.684819] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.684900] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.684924]   alloc irq_desc for 19 on node -1
[    7.684925]   alloc kstat_irqs on node -1
[    7.684930] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    7.684945] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    7.684948] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.684987] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    7.685019] ehci_hcd 0000:00:1a.7: debug port 1
[    7.688901] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    7.688915] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xb2a26000
[    7.776136] WARNING: at kernel/lockdep.c:2469 lockdep_trace_alloc+0xcc/0xe0()
[    7.784190] Hardware name: S5520SC
[    7.789306] Modules linked in:
[    7.792852] Pid: 178, comm: scsi_scan_0 Not tainted 2.6.36+ #8
[    7.799450] Call Trace:
[    7.802259]  [<ffffffff8105fe1f>] warn_slowpath_common+0x7f/0xc0
[    7.809050]  [<ffffffff8105fe7a>] warn_slowpath_null+0x1a/0x20
[    7.815647]  [<ffffffff81098a6c>] lockdep_trace_alloc+0xcc/0xe0
[    7.822345]  [<ffffffff8114617c>] __kmalloc_track_caller+0x5c/0x1f0
[    7.829428]  [<ffffffff8138db60>] ? dmam_alloc_coherent+0x40/0x170
[    7.836415]  [<ffffffff8138d8b0>] ? dmam_coherent_release+0x0/0xa0
[    7.843403]  [<ffffffff813873c1>] devres_alloc+0x31/0x70
[    7.849416]  [<ffffffff8138db60>] dmam_alloc_coherent+0x40/0x170
[    7.856201]  [<ffffffff8104dfc0>] ? finish_task_switch+0x0/0xf0
[    7.862899]  [<ffffffff813c40b9>] scic_sds_controller_initialized_state_start_handler+0x49/0x3a0
[    7.872827]  [<ffffffff813c2e55>] scic_controller_start+0x25/0x60
[    7.879715]  [<ffffffff813bfdaa>] isci_host_scan_start+0x5a/0x80
[    7.886508]  [<ffffffff813aa5c7>] do_scsi_scan_host+0x37/0xa0
[    7.893008]  [<ffffffff813aa655>] do_scan_async+0x25/0x180
[    7.899215]  [<ffffffff813aa630>] ? do_scan_async+0x0/0x180
[    7.905515]  [<ffffffff810820c6>] kthread+0xb6/0xc0
[    7.911044]  [<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
[    7.917732]  [<ffffffff815a3dd0>] ? restore_args+0x0/0x30
[    7.923844]  [<ffffffff81082010>] ? kthread+0x0/0xc0
[    7.929468]  [<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10
[    7.936358] ---[ end trace 5f1d70f62673caee ]---
[    7.951100] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00


The below patch moves the alloc out of the lock path, which eliminates
the lockdep warning.  Please review and let me know your comments.

Thanks,
Ed


>From d5258d99ae9658190622db0795646166a9eac2e4 Mon Sep 17 00:00:00 2001
From: Edmund Nadolski <edmund.nadolski@intel.com>
Date: Fri, 8 Apr 2011 09:02:10 -0600
Subject: [PATCH] isci: do not call dmam_alloc_coherent with scic_lock held

Moves the dmam_alloc_coherent() calls into a context where the
scic_lock is not held.

Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
---
 drivers/scsi/isci/core/scic_controller.h           |    3 +
 drivers/scsi/isci/core/scic_sds_controller.c       |   94 ++++++++++++--------
 drivers/scsi/isci/core/scic_sds_controller.h       |    9 ++
 .../isci/core/scic_sds_unsolicited_frame_control.c |   37 ++------
 .../isci/core/scic_sds_unsolicited_frame_control.h |    2 +-
 drivers/scsi/isci/host.c                           |    4 +
 6 files changed, 81 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/isci/core/scic_controller.h b/drivers/scsi/isci/core/scic_controller.h
index 236c583..5196e1b 100644
--- a/drivers/scsi/isci/core/scic_controller.h
+++ b/drivers/scsi/isci/core/scic_controller.h
@@ -84,6 +84,9 @@ void scic_controller_disable_interrupts(
 enum sci_status scic_controller_initialize(
 	struct scic_sds_controller *controller);
 
+enum sci_status scic_controller_ram_alloc(
+	struct scic_sds_controller *controller);
+
 u32 scic_controller_get_suggested_start_timeout(
 	struct scic_sds_controller *controller);
 
diff --git a/drivers/scsi/isci/core/scic_sds_controller.c b/drivers/scsi/isci/core/scic_sds_controller.c
index f4ced45..eae250c 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.c
+++ b/drivers/scsi/isci/core/scic_sds_controller.c
@@ -226,51 +226,25 @@ static void scic_sds_controller_initialize_power_control(struct scic_sds_control
 	scic->power_control.phys_granted_power = 0;
 }
 
-static enum sci_status
+void
 scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 {
-	struct device *dev = scic_to_dev(scic);
-	dma_addr_t dma_handle;
-	enum sci_status result;
-
-	scic->completion_queue = dmam_alloc_coherent(dev,
-			scic->completion_queue_entries * sizeof(u32),
-			&dma_handle, GFP_KERNEL);
-	if (!scic->completion_queue)
-		return SCI_FAILURE;
-
-	writel(lower_32_bits(dma_handle),
+	writel(lower_32_bits(scic->cq_handle),
 		&scic->smu_registers->completion_queue_lower);
-	writel(upper_32_bits(dma_handle),
+	writel(upper_32_bits(scic->cq_handle),
 		&scic->smu_registers->completion_queue_upper);
 
-	scic->remote_node_context_table = dmam_alloc_coherent(dev,
-			scic->remote_node_entries *
-				sizeof(union scu_remote_node_context),
-			&dma_handle, GFP_KERNEL);
-	if (!scic->remote_node_context_table)
-		return SCI_FAILURE;
-
-	writel(lower_32_bits(dma_handle),
+	writel(lower_32_bits(scic->rnc_handle),
 		&scic->smu_registers->remote_node_context_lower);
-	writel(upper_32_bits(dma_handle),
+	writel(upper_32_bits(scic->rnc_handle),
 		&scic->smu_registers->remote_node_context_upper);
 
-	scic->task_context_table = dmam_alloc_coherent(dev,
-			scic->task_context_entries *
-				sizeof(struct scu_task_context),
-			&dma_handle, GFP_KERNEL);
-	if (!scic->task_context_table)
-		return SCI_FAILURE;
-
-	writel(lower_32_bits(dma_handle),
+	writel(lower_32_bits(scic->tc_handle),
 		&scic->smu_registers->host_task_table_lower);
-	writel(upper_32_bits(dma_handle),
+	writel(upper_32_bits(scic->tc_handle),
 		&scic->smu_registers->host_task_table_upper);
 
-	result = scic_sds_unsolicited_frame_control_construct(scic);
-	if (result)
-		return result;
+	scic_sds_unsolicited_frame_control_construct(scic);
 
 	/*
 	 * Inform the silicon as to the location of the UF headers and
@@ -285,6 +259,54 @@ scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 		&scic->scu_registers->sdma.uf_address_table_lower);
 	writel(upper_32_bits(scic->uf_control.address_table.physical_address),
 		&scic->scu_registers->sdma.uf_address_table_upper);
+}
+
+enum sci_status
+scic_controller_ram_alloc(struct scic_sds_controller *scic)
+{
+	struct scic_sds_unsolicited_frame_control *ufc = &scic->uf_control;
+	struct device *dev = scic_to_dev(scic);
+	size_t size;
+
+	scic->completion_queue = dmam_alloc_coherent(dev,
+			scic->completion_queue_entries * sizeof(u32),
+			&scic->cq_handle, GFP_KERNEL);
+	if (!scic->completion_queue)
+		return SCI_FAILURE;
+
+	scic->remote_node_context_table = dmam_alloc_coherent(dev,
+			scic->remote_node_entries *
+				sizeof(union scu_remote_node_context),
+			&scic->rnc_handle, GFP_KERNEL);
+	if (!scic->remote_node_context_table)
+		return SCI_FAILURE;
+
+	scic->task_context_table = dmam_alloc_coherent(dev,
+			scic->task_context_entries *
+				sizeof(struct scu_task_context),
+			&scic->tc_handle, GFP_KERNEL);
+	if (!scic->task_context_table)
+		return SCI_FAILURE;
+
+	/*
+	 * The UF buffer address table size must be programmed to a power
+	 * of 2.  Find the first power of 2 that is equal to or greater then
+	 * the number of unsolicited frame buffers to be utilized.
+	 */
+	ufc->address_table.count = SCU_MIN_UF_TABLE_ENTRIES;
+	while (ufc->address_table.count < ufc->buffers.count &&
+	       ufc->address_table.count < SCU_ABSOLUTE_MAX_UNSOLICITED_FRAMES)
+		ufc->address_table.count <<= 1;
+
+	size = ufc->buffers.count * SCU_UNSOLICITED_FRAME_BUFFER_SIZE +
+		ufc->address_table.count * sizeof(dma_addr_t) +
+		ufc->buffers.count *
+			sizeof(struct scu_unsolicited_frame_header);
+
+	scic->ufb_vaddr = dmam_alloc_coherent(dev, size, &scic->ufb_handle,
+					      GFP_KERNEL);
+	if (!scic->ufb_vaddr)
+		return SCI_FAILURE;
 
 	return SCI_SUCCESS;
 }
@@ -2934,9 +2956,7 @@ static enum sci_status scic_sds_controller_initialized_state_start_handler(
 	u16 index;
 	enum sci_status result;
 
-	result = scic_sds_controller_ram_initialization(scic);
-	if (result)
-		return result;
+	scic_sds_controller_ram_initialization(scic);
 
 	/* Build the TCi free pool */
 	sci_pool_initialize(scic->tci_pool);
diff --git a/drivers/scsi/isci/core/scic_sds_controller.h b/drivers/scsi/isci/core/scic_sds_controller.h
index 163a9e1..a7d137e 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.h
+++ b/drivers/scsi/isci/core/scic_sds_controller.h
@@ -228,6 +228,15 @@ struct scic_sds_controller {
 	 */
 	u8 remote_device_sequence[SCI_MAX_REMOTE_DEVICES];
 
+	/*
+	 * Virtual address and DMA handles for dmam_alloc_coherent
+	 */
+	dma_addr_t	cq_handle;	/* Completion Queue */
+	dma_addr_t	rnc_handle;	/* Remote Node Context */
+	dma_addr_t	tc_handle;	/* Task Context */
+	dma_addr_t	ufb_handle;	/* Unsolicited Frame Buffer */
+	void		*ufb_vaddr;
+
 	/**
 	 * This field is a pointer to the memory allocated by the driver for the task
 	 * context table.  This data is shared between the hardware and software.
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
index 61abf1d..258673b 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
@@ -135,7 +135,7 @@ static void scic_sds_unsolicited_frame_control_construct_frames(
 	}
 }
 
-enum sci_status
+void
 scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 {
 	struct scic_sds_unsolicited_frame_control *uf_control = &scic->uf_control;
@@ -144,19 +144,6 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	u32 used_uf_buffer_bytes;
 	u32 unused_uf_header_bytes;
 	u32 used_uf_header_bytes;
-	dma_addr_t uf_buffer_phys_address;
-	void *uf_buffer_virt_address;
-	size_t size;
-
-	/*
-	 * The UF buffer address table size must be programmed to a power
-	 * of 2.  Find the first power of 2 that is equal to or greater then
-	 * the number of unsolicited frame buffers to be utilized.
-	 */
-	uf_control->address_table.count = SCU_MIN_UF_TABLE_ENTRIES;
-	while (uf_control->address_table.count < uf_control->buffers.count &&
-	       uf_control->address_table.count < SCU_ABSOLUTE_MAX_UNSOLICITED_FRAMES)
-		uf_control->address_table.count <<= 1;
 
 	/*
 	 * Prepare all of the memory sizes for the UF headers, UF address
@@ -172,19 +159,11 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	used_uf_header_bytes     = used_uf_header_entries
 				   * sizeof(struct scu_unsolicited_frame_header);
 
-	size = used_uf_buffer_bytes + used_uf_header_bytes +
-			uf_control->address_table.count * sizeof(dma_addr_t);
-
-
 	/*
 	 * The Unsolicited Frame buffers are set at the start of the UF
 	 * memory descriptor entry. The headers and address table will be
 	 * placed after the buffers.
 	 */
-	uf_buffer_virt_address = dmam_alloc_coherent(scic_to_dev(scic), size,
-							&uf_buffer_phys_address, GFP_KERNEL);
-	if (!uf_buffer_virt_address)
-		return SCI_FAILURE;
 
 	/*
 	 * Program the location of the UF header table into the SCU.
@@ -197,12 +176,12 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	 *   NULL.
 	 */
 	uf_control->headers.physical_address =
-				uf_buffer_phys_address +
+				scic->ufb_handle +
 				used_uf_buffer_bytes -
 				unused_uf_header_bytes;
 
 	uf_control->headers.array =
-				uf_buffer_virt_address +
+				scic->ufb_vaddr +
 				used_uf_buffer_bytes -
 				unused_uf_header_bytes;
 
@@ -214,12 +193,12 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	 *   64-bit boundary and headers are on a 64-bytes in size.
 	 */
 	uf_control->address_table.physical_address =
-				uf_buffer_phys_address +
+				scic->ufb_handle +
 				used_uf_buffer_bytes +
 				used_uf_header_bytes;
 
 	uf_control->address_table.array =
-				uf_buffer_virt_address +
+				scic->ufb_vaddr +
 				used_uf_buffer_bytes +
 				used_uf_header_bytes;
 
@@ -238,13 +217,11 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	 * address table to NULL. */
 	scic_sds_unsolicited_frame_control_construct_frames(
 		uf_control,
-		uf_buffer_phys_address,
-		uf_buffer_virt_address,
+		scic->ufb_handle,
+		scic->ufb_vaddr,
 		unused_uf_header_entries,
 		used_uf_header_entries
 		);
-
-	return SCI_SUCCESS;
 }
 
 /**
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
index 906514e..b002872 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
@@ -249,7 +249,7 @@ struct scic_sds_unsolicited_frame_control {
 
 struct scic_sds_controller;
 
-enum sci_status scic_sds_unsolicited_frame_control_construct(
+void scic_sds_unsolicited_frame_control_construct(
 	struct scic_sds_controller *scic);
 
 enum sci_status scic_sds_unsolicited_frame_control_get_header(
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 21e1a59..a3c415c 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -447,6 +447,10 @@ int isci_host_init(struct isci_host *isci_host)
 		return -ENODEV;
 	}
 
+	status = scic_controller_ram_alloc(isci_host->core_controller);
+	if (status != SCI_SUCCESS)
+		return -ENOMEM;
+
 	/*
 	 * keep the pool alloc size around, will use it for a bounds checking
 	 * when trying to convert virtual addresses to physical addresses
-- 
1.7.0.4

