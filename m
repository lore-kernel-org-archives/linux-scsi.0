From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Wed, 13 Apr 2011 16:41:14 -0700
Message-ID: <BANLkTikL1GR+b+eA=gXfkHDgR49kTzhYPQ@mail.gmail.com>
References: <20110408235518.GD18265@aontest.lm.intel.com>
	<1302676349.30034.36.camel@dwillia2-linux>
	<20110413164425.GA4279@infradead.org>
	<BANLkTi=-9kf1ddmC_weQ0H_wRAi-wa6TZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46947 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DMXlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 19:41:16 -0400
Received: by fxm17 with SMTP id 17so800898fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2011 16:41:14 -0700 (PDT)
In-Reply-To: <BANLkTi=-9kf1ddmC_weQ0H_wRAi-wa6TZA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "Nadolski, Edmund" <edmund.nadolski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Wojcik, Artur" <artur.wojcik@intel.com>

On Wed, Apr 13, 2011 at 12:44 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> On Wed, Apr 13, 2011 at 9:44 AM, hch@infradead.org <hch@infradead.org=
> wrote:
>> On Tue, Apr 12, 2011 at 11:32:29PM -0700, Dan Williams wrote:
>>> Thanks. =A0We can do this a bit simpler and just move ram initializ=
ation
>>> completely out of the start path, where it does not really belong.
>>>
>>> I'll fold the fix below into the patch.
>>
>> That looks much better than the initial version. =A0I'm still not su=
re
>> there actually is much of a point of doing a lot of work in the
>> start state handler. =A0Is there any fundamental reason for delaying=
 work
>> from the normal init path?
>>
>
> Probably everything above "/* Start all of the ports on this
> controller */" can be moved to the normal init path. =A0"Start" shoul=
d
> just be "turn on the phys".
>
> However, we'll need to revisit this allocation code when adding
> power-management support (post 2.6.39) since the allocation is tied t=
o
> the register re-initialization. =A0Probably just add a devres group t=
o
> handle all the dma host memory areas for the controller, rather than
> track the allocations individually. =A0But the simple patch is
> sufficient for now.
>

One more change to fold in...  Ed notes that we previously zeroed
these allocations.  Validation to date has been with that zeroing in
place, so I'd prefer to avoid surprises.  Also combined the
unidentified frame allocation and register init into one routine.

(potentially whitespace damaged incremental diff):

diff --git a/drivers/scsi/isci/core/scic_sds_controller.c
b/drivers/scsi/isci/core/scic_sds_controller.c
index 4aae7b6..ff155b6 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.c
+++ b/drivers/scsi/isci/core/scic_sds_controller.c
@@ -230,13 +230,14 @@ int scic_controller_mem_init(struct
scic_sds_controller *scic)
 {
 	struct device *dev =3D scic_to_dev(scic);
 	dma_addr_t dma_handle;
-	enum sci_status result;

 	scic->completion_queue =3D dmam_alloc_coherent(dev,
 			scic->completion_queue_entries * sizeof(u32),
 			&dma_handle, GFP_KERNEL);
 	if (!scic->completion_queue)
 		return -ENOMEM;
+	memset(scic->completion_queue, 0,
+	       scic->completion_queue_entries * sizeof(u32));

 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->completion_queue_lower);
@@ -249,6 +250,8 @@ int scic_controller_mem_init(struct
scic_sds_controller *scic)
 			&dma_handle, GFP_KERNEL);
 	if (!scic->remote_node_context_table)
 		return -ENOMEM;
+	memset(scic->remote_node_context_table, 0,
+	       scic->remote_node_entries * sizeof(union scu_remote_node_conte=
xt));

 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->remote_node_context_lower);
@@ -261,31 +264,15 @@ int scic_controller_mem_init(struct
scic_sds_controller *scic)
 			&dma_handle, GFP_KERNEL);
 	if (!scic->task_context_table)
 		return -ENOMEM;
+	memset(scic->task_context_table, 0,
+	       scic->task_context_entries * sizeof(struct scu_task_context));

 	writel(lower_32_bits(dma_handle),
 		&scic->smu_registers->host_task_table_lower);
 	writel(upper_32_bits(dma_handle),
 		&scic->smu_registers->host_task_table_upper);

-	result =3D scic_sds_unsolicited_frame_control_construct(scic);
-	if (result)
-		return result;
-
-	/*
-	 * Inform the silicon as to the location of the UF headers and
-	 * address table.
-	 */
-	writel(lower_32_bits(scic->uf_control.headers.physical_address),
-		&scic->scu_registers->sdma.uf_header_base_address_lower);
-	writel(upper_32_bits(scic->uf_control.headers.physical_address),
-		&scic->scu_registers->sdma.uf_header_base_address_upper);
-
-	writel(lower_32_bits(scic->uf_control.address_table.physical_address)=
,
-		&scic->scu_registers->sdma.uf_address_table_lower);
-	writel(upper_32_bits(scic->uf_control.address_table.physical_address)=
,
-		&scic->scu_registers->sdma.uf_address_table_upper);
-
-	return 0;
+	return scic_sds_unsolicited_frame_control_init(scic);
 }

 /**
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.=
c
b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
index 9e393e5..e3b43dc 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
@@ -135,7 +135,7 @@ static void
scic_sds_unsolicited_frame_control_construct_frames(
 	}
 }

-int scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *scic)
+int scic_sds_unsolicited_frame_control_init(struct scic_sds_controller=
 *scic)
 {
 	struct scic_sds_unsolicited_frame_control *uf_control =3D &scic->uf_c=
ontrol;
 	u32 unused_uf_header_entries;
@@ -143,8 +143,8 @@ int
scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *sci
 	u32 used_uf_buffer_bytes;
 	u32 unused_uf_header_bytes;
 	u32 used_uf_header_bytes;
-	dma_addr_t uf_buffer_phys_address;
-	void *uf_buffer_virt_address;
+	dma_addr_t dma_addr;
+	void *vaddr;
 	size_t size;

 	/*
@@ -180,10 +180,10 @@ int
scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *sci
 	 * memory descriptor entry. The headers and address table will be
 	 * placed after the buffers.
 	 */
-	uf_buffer_virt_address =3D dmam_alloc_coherent(scic_to_dev(scic), siz=
e,
-							&uf_buffer_phys_address, GFP_KERNEL);
-	if (!uf_buffer_virt_address)
+	vaddr =3D dmam_alloc_coherent(scic_to_dev(scic), size, &dma_addr, GFP=
_KERNEL);
+	if (!vaddr)
 		return -ENOMEM;
+	memset(vaddr, 0, size);

 	/*
 	 * Program the location of the UF header table into the SCU.
@@ -195,15 +195,11 @@ int
scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *sci
 	 *   headers, since we program the UF address table pointers to
 	 *   NULL.
 	 */
-	uf_control->headers.physical_address =3D
-				uf_buffer_phys_address +
-				used_uf_buffer_bytes -
-				unused_uf_header_bytes;
+	uf_control->headers.physical_address =3D dma_addr + used_uf_buffer_by=
tes -
+					       unused_uf_header_bytes;

-	uf_control->headers.array =3D
-				uf_buffer_virt_address +
-				used_uf_buffer_bytes -
-				unused_uf_header_bytes;
+	uf_control->headers.array =3D vaddr + used_uf_buffer_bytes -
+				    unused_uf_header_bytes;

 	/*
 	 * Program the location of the UF address table into the SCU.
@@ -212,15 +208,12 @@ int
scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *sci
 	 *   byte boundary already due to above programming headers being on =
a
 	 *   64-bit boundary and headers are on a 64-bytes in size.
 	 */
-	uf_control->address_table.physical_address =3D
-				uf_buffer_phys_address +
-				used_uf_buffer_bytes +
-				used_uf_header_bytes;
+	uf_control->address_table.physical_address =3D dma_addr +
+						     used_uf_buffer_bytes +
+						     used_uf_header_bytes;

-	uf_control->address_table.array =3D
-				uf_buffer_virt_address +
-				used_uf_buffer_bytes +
-				used_uf_header_bytes;
+	uf_control->address_table.array =3D vaddr + used_uf_buffer_bytes +
+					  used_uf_header_bytes;

 	uf_control->get =3D 0;

@@ -235,13 +228,25 @@ int
scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *sci
 	 * If the user provided less then the maximum amount of memory,
 	 * then be sure that we programm the first entries in the UF
 	 * address table to NULL. */
-	scic_sds_unsolicited_frame_control_construct_frames(
-		uf_control,
-		uf_buffer_phys_address,
-		uf_buffer_virt_address,
-		unused_uf_header_entries,
-		used_uf_header_entries
-		);
+	scic_sds_unsolicited_frame_control_construct_frames(uf_control,
+							    dma_addr,
+							    vaddr,
+							    unused_uf_header_entries,
+							    used_uf_header_entries);
+
+	/*
+	 * Inform the silicon as to the location of the UF headers and
+	 * address table.
+	 */
+	writel(lower_32_bits(scic->uf_control.headers.physical_address),
+		&scic->scu_registers->sdma.uf_header_base_address_lower);
+	writel(upper_32_bits(scic->uf_control.headers.physical_address),
+		&scic->scu_registers->sdma.uf_header_base_address_upper);
+
+	writel(lower_32_bits(scic->uf_control.address_table.physical_address)=
,
+		&scic->scu_registers->sdma.uf_address_table_lower);
+	writel(upper_32_bits(scic->uf_control.address_table.physical_address)=
,
+		&scic->scu_registers->sdma.uf_address_table_upper);

 	return 0;
 }
diff --git a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.=
h
b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
index 4eb244c..120a213 100644
--- a/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
+++ b/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
@@ -249,7 +249,7 @@ struct scic_sds_unsolicited_frame_control {

 struct scic_sds_controller;

-int scic_sds_unsolicited_frame_control_construct(struct
scic_sds_controller *scic);
+int scic_sds_unsolicited_frame_control_init(struct scic_sds_controller=
 *scic);

 enum sci_status scic_sds_unsolicited_frame_control_get_header(
 	struct scic_sds_unsolicited_frame_control *uf_control,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
