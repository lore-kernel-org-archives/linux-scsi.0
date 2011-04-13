From: Dan Williams <dan.j.williams@intel.com>
Subject: RE: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Tue, 12 Apr 2011 23:32:29 -0700
Message-ID: <1302676349.30034.36.camel@dwillia2-linux>
References: <20110408235518.GD18265@aontest.lm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1DMGVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 02:21:53 -0400
In-Reply-To: <20110408235518.GD18265@aontest.lm.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nadolski, Edmund" <edmund.nadolski@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Wojcik, Artur" <artur.wojcik@intel.com>

On Fri, 2011-04-08 at 16:55 -0700, Nadolski, Edmund wrote:
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Saturday, April 02, 2011 6:15 AM
> > To: Williams, Dan J
> > Cc: linux-scsi; David Milburn; Jiang, Dave; Ciechanowski, Ed; Nadolski,
> > Edmund; Danecki, Jacek; Skirvin, Jeffrey D
> > Subject: [PATCH, RFC] isci: simplify dma coherent allocation
> >
> > Remove the insane infrastructure for preallocating coheren DMA regions,
> > and just allocate the memory where needed.  This also gets rid of the
> > aligment adjustments given that Documentation/DMA-API-HOWTO.txt sais:
> >
> >   "The cpu return address and the DMA bus master address are both
> >    guaranteed to be aligned to the smallest PAGE_SIZE order which
> >    is greater than or equal to the requested size.  This invariant
> >    exists (for example) to guarantee that if you allocate a chunk
> >    which is smaller than or equal to 64 kilobytes, the extent of the
> >    buffer you receive will not cross a 64K boundary."
> >
> 
> 
> The above patch introduces an issue where the dmam_alloc_coherent()
> gets called in a path where the scic_lock is held, resulting in the
> following trace at boot:
[..]
> The below patch moves the alloc out of the lock path, which eliminates
> the lockdep warning.  Please review and let me know your comments.
> 
> Thanks,
> Ed
> 
> 
> From d5258d99ae9658190622db0795646166a9eac2e4 Mon Sep 17 00:00:00 2001
> From: Edmund Nadolski <edmund.nadolski@intel.com>
> Date: Fri, 8 Apr 2011 09:02:10 -0600
> Subject: [PATCH] isci: do not call dmam_alloc_coherent with scic_lock held
> 
> Moves the dmam_alloc_coherent() calls into a context where the
> scic_lock is not held.
> 
> Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
> ---
>  drivers/scsi/isci/core/scic_controller.h           |    3 +
>  drivers/scsi/isci/core/scic_sds_controller.c       |   94 ++++++++++++--------
>  drivers/scsi/isci/core/scic_sds_controller.h       |    9 ++
>  .../isci/core/scic_sds_unsolicited_frame_control.c |   37 ++------
>  .../isci/core/scic_sds_unsolicited_frame_control.h |    2 +-
>  drivers/scsi/isci/host.c                           |    4 +
>  6 files changed, 81 insertions(+), 68 deletions(-)
> 

Thanks.  We can do this a bit simpler and just move ram initialization
completely out of the start path, where it does not really belong.

I'll fold the fix below into the patch.

Btw, good catch on the deletion of the unnecessary
scic_sds_unsolicited_frame_control_construct()
uf_control->address_table.count power-of-2 alignment code, but that
really belongs in its own patch set that deletes all the infrastructure
around sci_controller_mode.

In general any patch that adds new structure members or adds more code
than it deletes at this point in the cleanup warrants higher scrutiny.

--
Dan

diff --git a/drivers/scsi/isci/core/scic_controller.h b/drivers/scsi/isci/core/scic_controller.h
index 236c583..649b61a 100644
--- a/drivers/scsi/isci/core/scic_controller.h
+++ b/drivers/scsi/isci/core/scic_controller.h
@@ -144,4 +144,5 @@ enum sci_status scic_controller_free_io_tag(
 
 struct device;
 struct scic_sds_controller *scic_controller_alloc(struct device *dev);
+int scic_controller_mem_init(struct scic_sds_controller *scic);
 #endif  /* _SCIC_CONTROLLER_H_ */
diff --git a/drivers/scsi/isci/core/scic_sds_controller.c b/drivers/scsi/isci/core/scic_sds_controller.c
index f4ced45..4aae7b6 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.c
+++ b/drivers/scsi/isci/core/scic_sds_controller.c
@@ -226,8 +226,7 @@ static void scic_sds_controller_initialize_power_control(struct scic_sds_control
 	scic->power_control.phys_granted_power = 0;
 }
 
-static enum sci_status
-scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
+int scic_controller_mem_init(struct scic_sds_controller *scic)
 {
 	struct device *dev = scic_to_dev(scic);
 	dma_addr_t dma_handle;
@@ -237,7 +236,7 @@ scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 			scic->completion_queue_entries * sizeof(u32),
 			&dma_handle, GFP_KERNEL);
 	if (!scic->completion_queue)
-		return SCI_FAILURE;
+		return -ENOMEM;
 
 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->completion_queue_lower);
@@ -249,7 +248,7 @@ scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 				sizeof(union scu_remote_node_context),
 			&dma_handle, GFP_KERNEL);
 	if (!scic->remote_node_context_table)
-		return SCI_FAILURE;
+		return -ENOMEM;
 
 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->remote_node_context_lower);
@@ -261,7 +260,7 @@ scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 				sizeof(struct scu_task_context),
 			&dma_handle, GFP_KERNEL);
 	if (!scic->task_context_table)
-		return SCI_FAILURE;
+		return -ENOMEM;
 
 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->host_task_table_lower);
@@ -286,7 +285,7 @@ scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 	writel(upper_32_bits(scic->uf_control.address_table.physical_address),
 		&scic->scu_registers->sdma.uf_address_table_upper);
 
-	return SCI_SUCCESS;
+	return 0;
 }
 
 /**
@@ -2934,10 +2933,6 @@ static enum sci_status scic_sds_controller_initialized_state_start_handler(
 	u16 index;
 	enum sci_status result;
 
-	result = scic_sds_controller_ram_initialization(scic);
-	if (result)
-		return result;
-
 	/* Build the TCi free pool */
 	sci_pool_initialize(scic->tci_pool);
 	for (index = 0; index < scic->task_context_entries; index++)
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
index 61abf1d..9e393e5 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
@@ -135,8 +135,7 @@ static void scic_sds_unsolicited_frame_control_construct_frames(
 	}
 }
 
-enum sci_status
-scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
+int scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 {
 	struct scic_sds_unsolicited_frame_control *uf_control = &scic->uf_control;
 	u32 unused_uf_header_entries;
@@ -184,7 +183,7 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 	uf_buffer_virt_address = dmam_alloc_coherent(scic_to_dev(scic), size,
 							&uf_buffer_phys_address, GFP_KERNEL);
 	if (!uf_buffer_virt_address)
-		return SCI_FAILURE;
+		return -ENOMEM;
 
 	/*
 	 * Program the location of the UF header table into the SCU.
@@ -244,7 +243,7 @@ scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 		used_uf_header_entries
 		);
 
-	return SCI_SUCCESS;
+	return 0;
 }
 
 /**
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
index 906514e..4eb244c 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
@@ -249,8 +249,7 @@ struct scic_sds_unsolicited_frame_control {
 
 struct scic_sds_controller;
 
-enum sci_status scic_sds_unsolicited_frame_control_construct(
-	struct scic_sds_controller *scic);
+int scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic);
 
 enum sci_status scic_sds_unsolicited_frame_control_get_header(
 	struct scic_sds_unsolicited_frame_control *uf_control,
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 21e1a59..927f088 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -447,6 +447,10 @@ int isci_host_init(struct isci_host *isci_host)
 		return -ENODEV;
 	}
 
+	err = scic_controller_mem_init(isci_host->core_controller);
+	if (err)
+		return err;
+
 	/*
 	 * keep the pool alloc size around, will use it for a bounds checking
 	 * when trying to convert virtual addresses to physical addresses


