From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Sat, 2 Apr 2011 08:15:04 -0400
Message-ID: <20110402121504.GA30913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1DBMPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 08:15:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Remove the insane infrastructure for preallocating coheren DMA regions,
and just allocate the memory where needed.  This also gets rid of the
aligment adjustments given that Documentation/DMA-API-HOWTO.txt sais:

  "The cpu return address and the DMA bus master address are both
   guaranteed to be aligned to the smallest PAGE_SIZE order which
   is greater than or equal to the requested size.  This invariant
   exists (for example) to guarantee that if you allocate a chunk
   which is smaller than or equal to 64 kilobytes, the extent of the
   buffer you receive will not cross a 64K boundary."

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_base_memory_descriptor_list.c	2011-04-01 17:40:50.020129597 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,159 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-/**
- * This file contains the base implementation for the memory descriptor list.
- *    This is currently comprised of MDL iterator methods.
- *
- *
- */
-
-#include "sci_environment.h"
-#include "sci_base_memory_descriptor_list.h"
-
-/*
- * ******************************************************************************
- * * P U B L I C   M E T H O D S
- * ****************************************************************************** */
-
-void sci_mdl_first_entry(
-	struct sci_base_memory_descriptor_list *base_mdl)
-{
-	base_mdl->next_index = 0;
-
-	/*
-	 * If this MDL is managing another MDL, then recursively rewind that MDL
-	 * object as well. */
-	if (base_mdl->next_mdl != NULL)
-		sci_mdl_first_entry(base_mdl->next_mdl);
-}
-
-
-void sci_mdl_next_entry(
-	struct sci_base_memory_descriptor_list *base_mdl)
-{
-	/*
-	 * If there is at least one more entry left in the array, then change
-	 * the next pointer to it. */
-	if (base_mdl->next_index < base_mdl->length)
-		base_mdl->next_index++;
-	else if (base_mdl->next_index == base_mdl->length) {
-		/*
-		 * This MDL has exhausted it's set of entries.  If this MDL is managing
-		 * another MDL, then start iterating through that MDL. */
-		if (base_mdl->next_mdl != NULL)
-			sci_mdl_next_entry(base_mdl->next_mdl);
-	}
-}
-
-
-struct sci_physical_memory_descriptor *sci_mdl_get_current_entry(
-	struct sci_base_memory_descriptor_list *base_mdl)
-{
-	if (base_mdl->next_index < base_mdl->length)
-		return &base_mdl->mde_array[base_mdl->next_index];
-	else if (base_mdl->next_index == base_mdl->length) {
-		/*
-		 * This MDL has exhausted it's set of entries.  If this MDL is managing
-		 * another MDL, then return it's current entry. */
-		if (base_mdl->next_mdl != NULL)
-			return sci_mdl_get_current_entry(base_mdl->next_mdl);
-	}
-
-	return NULL;
-}
-
-/*
- * ******************************************************************************
- * * P R O T E C T E D   M E T H O D S
- * ****************************************************************************** */
-
-void sci_base_mdl_construct(
-	struct sci_base_memory_descriptor_list *mdl,
-	struct sci_physical_memory_descriptor *mde_array,
-	u32 mde_array_length,
-	struct sci_base_memory_descriptor_list *next_mdl)
-{
-	mdl->length     = mde_array_length;
-	mdl->mde_array  = mde_array;
-	mdl->next_index = 0;
-	mdl->next_mdl   = next_mdl;
-}
-
-/* --------------------------------------------------------------------------- */
-
-bool sci_base_mde_is_valid(
-	struct sci_physical_memory_descriptor *mde,
-	u32 alignment,
-	u32 size,
-	u16 attributes)
-{
-	/* Only need the lower 32 bits to ensure alignment is met. */
-	u32 physical_address = lower_32_bits(mde->physical_address);
-
-	if (
-		((((unsigned long)mde->virtual_address) & (alignment - 1)) != 0)
-		|| ((physical_address & (alignment - 1)) != 0)
-		|| (mde->constant_memory_alignment != alignment)
-		|| (mde->constant_memory_size != size)
-		|| (mde->virtual_address == NULL)
-		|| (mde->constant_memory_attributes != attributes)
-		) {
-		return false;
-	}
-
-	return true;
-}
-
Index: linux-2.6/drivers/scsi/isci/core/sci_memory_descriptor_list.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_memory_descriptor_list.h	2011-04-01 17:40:50.032130044 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,168 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCI_MEMORY_DESCRIPTOR_LIST_H_
-#define _SCI_MEMORY_DESCRIPTOR_LIST_H_
-
-/**
- * This file contains all of the basic data types utilized by an SCI user or
- *    implementor.
- *
- *
- */
-
-
-
-struct sci_base_memory_descriptor_list;
-
-/**
- *
- *
- * SCI_MDE_ATTRIBUTES These constants depict memory attributes for the Memory
- * Descriptor Entries (MDEs) contained in the MDL.
- */
-#define SCI_MDE_ATTRIBUTE_CACHEABLE              0x0001
-#define SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS  0x0002
-
-/**
- * struct sci_physical_memory_descriptor - This structure defines a description
- *    of a memory location for the SCI implementation.
- *
- *
- */
-struct sci_physical_memory_descriptor {
-	/**
-	 * This field contains the virtual address associated with this descriptor
-	 * element. This field shall be zero when the descriptor is retrieved from
-	 * the SCI implementation.  The user shall set this field prior
-	 * sci_controller_start()
-	 */
-	void *virtual_address;
-
-	/**
-	 * This field contains the physical address associated with this desciptor
-	 * element. This field shall be zero when the descriptor is retrieved from
-	 * the SCI implementation.  The user shall set this field prior
-	 * sci_controller_start()
-	 */
-	dma_addr_t physical_address;
-
-	/**
-	 * This field contains the size requirement for this memory descriptor.
-	 * A value of zero for this field indicates the end of the descriptor
-	 * list.  The value should be treated as read only for an SCI user.
-	 */
-	u32 constant_memory_size;
-
-	/**
-	 * This field contains the alignment requirement for this memory
-	 * descriptor.  A value of zero for this field indicates the end of the
-	 * descriptor list.  All other values indicate the number of bytes to
-	 * achieve the necessary alignment.  The value should be treated as
-	 * read only for an SCI user.
-	 */
-	u32 constant_memory_alignment;
-
-	/**
-	 * This field contains an indication regarding the desired memory
-	 * attributes for this memory descriptor entry.
-	 * Notes:
-	 * - If the cacheable attribute is set, the user can allocate
-	 *   memory that is backed by cache for better performance. It
-	 *   is not required that the memory be backed by cache.
-	 * - If the physically contiguous attribute is set, then the
-	 *   entire memory must be physically contiguous across all
-	 *   page boundaries.
-	 */
-	u16 constant_memory_attributes;
-
-};
-
-/**
- * sci_mdl_first_entry() - This method simply rewinds the MDL iterator back to
- *    the first memory descriptor entry in the list.
- * @mdl: This parameter specifies the memory descriptor list that is to be
- *    rewound.
- *
- */
-void sci_mdl_first_entry(
-	struct sci_base_memory_descriptor_list *mdl);
-
-/**
- * sci_mdl_next_entry() - This method simply updates the "current" pointer to
- *    the next sequential memory descriptor.
- * @mdl: This parameter specifies the memory descriptor list for which to
- *    return the next memory descriptor entry in the list.
- *
- * none.
- */
-void sci_mdl_next_entry(
-	struct sci_base_memory_descriptor_list *mdl);
-
-/**
- * sci_mdl_get_current_entry() - This method simply returns the current memory
- *    descriptor entry.
- * @mdl: This parameter specifies the memory descriptor list for which to
- *    return the current memory descriptor entry.
- *
- * This method returns a pointer to the current physical memory descriptor in
- * the MDL. NULL This value is returned if there are no descriptors in the list.
- */
-struct sci_physical_memory_descriptor *sci_mdl_get_current_entry(
-	struct sci_base_memory_descriptor_list *mdl);
-
-
-#endif  /* _SCI_MEMORY_DESCRIPTOR_LIST_H_ */
-
Index: linux-2.6/drivers/scsi/isci/host.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/host.c	2011-04-01 17:40:50.089129355 +0200
+++ linux-2.6/drivers/scsi/isci/host.c	2011-04-01 17:41:15.124129630 +0200
@@ -170,96 +170,6 @@ void isci_host_stop_complete(struct isci
 	wake_up(&ihost->eventq);
 }
 
-static struct coherent_memory_info *isci_host_alloc_mdl_struct(
-	struct isci_host *isci_host,
-	u32 size)
-{
-	struct coherent_memory_info *mdl_struct;
-	void *uncached_address = NULL;
-
-
-	mdl_struct = devm_kzalloc(&isci_host->pdev->dev,
-				  sizeof(*mdl_struct),
-				  GFP_KERNEL);
-	if (!mdl_struct)
-		return NULL;
-
-	INIT_LIST_HEAD(&mdl_struct->node);
-
-	uncached_address = dmam_alloc_coherent(&isci_host->pdev->dev,
-					       size,
-					       &mdl_struct->dma_handle,
-					       GFP_KERNEL);
-	if (!uncached_address)
-		return NULL;
-
-	/* memset the whole memory area. */
-	memset((char *)uncached_address, 0, size);
-	mdl_struct->vaddr = uncached_address;
-	mdl_struct->size = (size_t)size;
-
-	return mdl_struct;
-}
-
-static void isci_host_build_mde(
-	struct sci_physical_memory_descriptor *mde_struct,
-	struct coherent_memory_info *mdl_struct)
-{
-	unsigned long address = 0;
-	dma_addr_t dma_addr = 0;
-
-	address = (unsigned long)mdl_struct->vaddr;
-	dma_addr = mdl_struct->dma_handle;
-
-	/* to satisfy the alignment. */
-	if ((address % mde_struct->constant_memory_alignment) != 0) {
-		int align_offset
-			= (mde_struct->constant_memory_alignment
-			   - (address % mde_struct->constant_memory_alignment));
-		address += align_offset;
-		dma_addr += align_offset;
-	}
-
-	mde_struct->virtual_address = (void *)address;
-	mde_struct->physical_address = dma_addr;
-	mdl_struct->mde = mde_struct;
-}
-
-static int isci_host_mdl_allocate_coherent(
-	struct isci_host *isci_host)
-{
-	struct sci_physical_memory_descriptor *current_mde;
-	struct coherent_memory_info *mdl_struct;
-	u32 size = 0;
-
-	struct sci_base_memory_descriptor_list *mdl_handle =
-		&isci_host->core_controller->mdl;
-
-	sci_mdl_first_entry(mdl_handle);
-
-	current_mde = sci_mdl_get_current_entry(mdl_handle);
-
-	while (current_mde != NULL) {
-
-		size = (current_mde->constant_memory_size
-			+ current_mde->constant_memory_alignment);
-
-		mdl_struct = isci_host_alloc_mdl_struct(isci_host, size);
-		if (!mdl_struct)
-			return -ENOMEM;
-
-		list_add_tail(&mdl_struct->node, &isci_host->mdl_struct_list);
-
-		isci_host_build_mde(current_mde, mdl_struct);
-
-		sci_mdl_next_entry(mdl_handle);
-		current_mde = sci_mdl_get_current_entry(mdl_handle);
-	}
-
-	return 0;
-}
-
-
 /**
  * isci_host_completion_routine() - This function is the delayed service
  *    routine that calls the sci core library's completion handler. It's
@@ -523,8 +433,6 @@ int isci_host_init(struct isci_host *isc
 	tasklet_init(&isci_host->completion_tasklet,
 		     isci_host_completion_routine, (unsigned long)isci_host);
 
-	INIT_LIST_HEAD(&(isci_host->mdl_struct_list));
-
 	INIT_LIST_HEAD(&isci_host->requests_to_complete);
 	INIT_LIST_HEAD(&isci_host->requests_to_errorback);
 
@@ -539,11 +447,6 @@ int isci_host_init(struct isci_host *isc
 		return -ENODEV;
 	}
 
-	/* populate mdl with dma memory. scu_mdl_allocate_coherent() */
-	err = isci_host_mdl_allocate_coherent(isci_host);
-	if (err)
-		return err;
-
 	/*
 	 * keep the pool alloc size around, will use it for a bounds checking
 	 * when trying to convert virtual addresses to physical addresses
Index: linux-2.6/drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_base_memory_descriptor_list.h	2011-04-01 17:40:50.040129961 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,153 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_
-#define _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_
-
-/**
- * This file contains the protected interface structures, constants and
- *    interface methods for the struct sci_base_memory_descriptor_list object.
- *
- *
- */
-
-
-#include "sci_memory_descriptor_list.h"
-
-
-/**
- * struct sci_base_memory_descriptor_list - This structure contains all of the
- *    fields necessary to implement a simple stack for managing the list of
- *    available controller indices.
- *
- *
- */
-struct sci_base_memory_descriptor_list {
-	/**
-	 * This field indicates the length of the memory descriptor entry array.
-	 */
-	u32 length;
-
-	/**
-	 * This field is utilized to provide iterator pattern functionality.
-	 * It indicates the index of the next memory descriptor in the iteration.
-	 */
-	u32 next_index;
-
-	/**
-	 * This field will point to the list of memory descriptors.
-	 */
-	struct sci_physical_memory_descriptor *mde_array;
-
-	/**
-	 * This field simply allows a user to chain memory descriptor lists
-	 * together if desired.  This field will be initialized to NULL.
-	 */
-	struct sci_base_memory_descriptor_list *next_mdl;
-
-};
-
-/**
- * sci_base_mdl_construct() - This method is invoked to construct an memory
- *    descriptor list. It initializes the fields of the MDL.
- * @mdl: This parameter specifies the memory descriptor list to be constructed.
- * @mde_array: This parameter specifies the array of memory descriptor entries
- *    to be managed by this list.
- * @mde_array_length: This parameter specifies the size of the array of entries.
- * @next_mdl: This parameter specifies a subsequent MDL object to be managed by
- *    this MDL object.
- *
- * none.
- */
-void sci_base_mdl_construct(
-	struct sci_base_memory_descriptor_list *mdl,
-	struct sci_physical_memory_descriptor *mde_array,
-	u32 mde_array_length,
-	struct sci_base_memory_descriptor_list *next_mdl);
-
-/**
- * sci_base_mde_construct() -
- *
- * This macro constructs an memory descriptor entry with the given alignment
- * and size
- */
-#define sci_base_mde_construct(mde, alignment, size, attributes) \
-	{ \
-		(mde)->constant_memory_alignment  = (alignment); \
-		(mde)->constant_memory_size       = (size); \
-		(mde)->constant_memory_attributes = (attributes); \
-	}
-
-/**
- * sci_base_mde_is_valid() - This method validates that the memory descriptor
- *    is correctly filled out by the SCI User
- * @mde: This parameter is the mde entry to validate
- * @alignment: This parameter specifies the expected alignment of the memory
- *    for the mde.
- * @size: This parameter specifies the memory size expected for the mde its
- *    value should not have been changed by the SCI User.
- * @attributes: This parameter specifies the attributes for the memory
- *    descriptor provided.
- *
- * bool This method returns an indication as to whether the supplied MDE is
- * valid or not. true The MDE is valid. false The MDE is not valid.
- */
-bool sci_base_mde_is_valid(
-	struct sci_physical_memory_descriptor *mde,
-	u32 alignment,
-	u32 size,
-	u16 attributes);
-
-#endif /* _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.c	2011-04-01 17:40:50.048130584 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c	2011-04-01 18:01:17.564130159 +0200
@@ -226,171 +226,67 @@ static void scic_sds_controller_initiali
 	scic->power_control.phys_granted_power = 0;
 }
 
-#define SCU_REMOTE_NODE_CONTEXT_ALIGNMENT       (32)
-#define SCU_TASK_CONTEXT_ALIGNMENT              (256)
-#define SCU_UNSOLICITED_FRAME_ADDRESS_ALIGNMENT (64)
-#define SCU_UNSOLICITED_FRAME_BUFFER_ALIGNMENT  (1024)
-#define SCU_UNSOLICITED_FRAME_HEADER_ALIGNMENT  (64)
-
-/**
- * This method builds the memory descriptor table for this controller.
- * @this_controller: This parameter specifies the controller object for which
- *    to build the memory table.
- *
- */
-static void scic_sds_controller_build_memory_descriptor_table(
-	struct scic_sds_controller *this_controller)
-{
-	sci_base_mde_construct(
-		&this_controller->memory_descriptors[SCU_MDE_COMPLETION_QUEUE],
-		SCU_COMPLETION_RAM_ALIGNMENT,
-		(sizeof(u32) * this_controller->completion_queue_entries),
-		(SCI_MDE_ATTRIBUTE_CACHEABLE | SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS)
-		);
-
-	sci_base_mde_construct(
-		&this_controller->memory_descriptors[SCU_MDE_REMOTE_NODE_CONTEXT],
-		SCU_REMOTE_NODE_CONTEXT_ALIGNMENT,
-		this_controller->remote_node_entries * sizeof(union scu_remote_node_context),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-
-	sci_base_mde_construct(
-		&this_controller->memory_descriptors[SCU_MDE_TASK_CONTEXT],
-		SCU_TASK_CONTEXT_ALIGNMENT,
-		this_controller->task_context_entries * sizeof(struct scu_task_context),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-
-	/*
-	 * The UF buffer address table size must be programmed to a power
-	 * of 2.  Find the first power of 2 that is equal to or greater then
-	 * the number of unsolicited frame buffers to be utilized. */
-	scic_sds_unsolicited_frame_control_set_address_table_count(
-		&this_controller->uf_control
-		);
-
-	sci_base_mde_construct(
-		&this_controller->memory_descriptors[SCU_MDE_UF_BUFFER],
-		SCU_UNSOLICITED_FRAME_BUFFER_ALIGNMENT,
-		scic_sds_unsolicited_frame_control_get_mde_size(this_controller->uf_control),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-}
-
-/**
- * This method validates the driver supplied memory descriptor table.
- * @this_controller:
- *
- * enum sci_status
- */
-static enum sci_status scic_sds_controller_validate_memory_descriptor_table(
-	struct scic_sds_controller *this_controller)
-{
-	bool mde_list_valid;
-
-	mde_list_valid = sci_base_mde_is_valid(
-		&this_controller->memory_descriptors[SCU_MDE_COMPLETION_QUEUE],
-		SCU_COMPLETION_RAM_ALIGNMENT,
-		(sizeof(u32) * this_controller->completion_queue_entries),
-		(SCI_MDE_ATTRIBUTE_CACHEABLE | SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS)
-		);
-
-	if (mde_list_valid == false)
-		return SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD;
-
-	mde_list_valid = sci_base_mde_is_valid(
-		&this_controller->memory_descriptors[SCU_MDE_REMOTE_NODE_CONTEXT],
-		SCU_REMOTE_NODE_CONTEXT_ALIGNMENT,
-		this_controller->remote_node_entries * sizeof(union scu_remote_node_context),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-
-	if (mde_list_valid == false)
-		return SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD;
-
-	mde_list_valid = sci_base_mde_is_valid(
-		&this_controller->memory_descriptors[SCU_MDE_TASK_CONTEXT],
-		SCU_TASK_CONTEXT_ALIGNMENT,
-		this_controller->task_context_entries * sizeof(struct scu_task_context),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-
-	if (mde_list_valid == false)
-		return SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD;
-
-	mde_list_valid = sci_base_mde_is_valid(
-		&this_controller->memory_descriptors[SCU_MDE_UF_BUFFER],
-		SCU_UNSOLICITED_FRAME_BUFFER_ALIGNMENT,
-		scic_sds_unsolicited_frame_control_get_mde_size(this_controller->uf_control),
-		SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS
-		);
-
-	if (mde_list_valid == false)
-		return SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD;
-
-	return SCI_SUCCESS;
-}
-
-/**
- * This method initializes the controller with the physical memory addresses
- *    that are used to communicate with the driver.
- * @this_controller:
- *
- */
-static void scic_sds_controller_ram_initialization(
-	struct scic_sds_controller *this_controller)
+static enum sci_status
+scic_sds_controller_ram_initialization(struct scic_sds_controller *scic)
 {
-	struct sci_physical_memory_descriptor *mde;
-
-	/*
-	 * The completion queue is actually placed in cacheable memory
-	 * Therefore it no longer comes out of memory in the MDL. */
-	mde = &this_controller->memory_descriptors[SCU_MDE_COMPLETION_QUEUE];
-	this_controller->completion_queue = (u32 *)mde->virtual_address;
-	writel(lower_32_bits(mde->physical_address), \
-		&this_controller->smu_registers->completion_queue_lower);
-	writel(upper_32_bits(mde->physical_address),
-		&this_controller->smu_registers->completion_queue_upper);
+	struct device *dev = scic_to_dev(scic);
+	dma_addr_t dma_handle;
+	enum sci_status result;
 
-	/*
-	 * Program the location of the Remote Node Context table
-	 * into the SCU. */
-	mde = &this_controller->memory_descriptors[SCU_MDE_REMOTE_NODE_CONTEXT];
-	this_controller->remote_node_context_table = (union scu_remote_node_context *)
-						     mde->virtual_address;
-	writel(lower_32_bits(mde->physical_address),
-		&this_controller->smu_registers->remote_node_context_lower);
-	writel(upper_32_bits(mde->physical_address),
-		&this_controller->smu_registers->remote_node_context_upper);
-
-	/* Program the location of the Task Context table into the SCU. */
-	mde = &this_controller->memory_descriptors[SCU_MDE_TASK_CONTEXT];
-	this_controller->task_context_table = (struct scu_task_context *)
-					      mde->virtual_address;
-	writel(lower_32_bits(mde->physical_address),
-		&this_controller->smu_registers->host_task_table_lower);
-	writel(upper_32_bits(mde->physical_address),
-		&this_controller->smu_registers->host_task_table_upper);
-
-	mde = &this_controller->memory_descriptors[SCU_MDE_UF_BUFFER];
-	scic_sds_unsolicited_frame_control_construct(
-		&this_controller->uf_control, mde, this_controller
-		);
+	scic->completion_queue = dmam_alloc_coherent(dev,
+			scic->completion_queue_entries * sizeof(u32),
+			&dma_handle, GFP_KERNEL);
+	if (!scic->completion_queue)
+		return SCI_FAILURE;
+
+	writel(lower_32_bits(dma_handle),
+		&scic->smu_registers->completion_queue_lower);
+	writel(upper_32_bits(dma_handle),
+		&scic->smu_registers->completion_queue_upper);
+
+	scic->remote_node_context_table = dmam_alloc_coherent(dev,
+			scic->remote_node_entries *
+				sizeof(union scu_remote_node_context),
+			&dma_handle, GFP_KERNEL);
+	if (!scic->remote_node_context_table)
+		return SCI_FAILURE;
+
+	writel(lower_32_bits(dma_handle),
+		&scic->smu_registers->remote_node_context_lower);
+	writel(upper_32_bits(dma_handle),
+		&scic->smu_registers->remote_node_context_upper);
+
+	scic->task_context_table = dmam_alloc_coherent(dev,
+			scic->task_context_entries *
+				sizeof(struct scu_task_context),
+			&dma_handle, GFP_KERNEL);
+	if (!scic->task_context_table)
+		return SCI_FAILURE;
+
+	writel(lower_32_bits(dma_handle),
+		&scic->smu_registers->host_task_table_lower);
+	writel(upper_32_bits(dma_handle),
+		&scic->smu_registers->host_task_table_upper);
+
+	result = scic_sds_unsolicited_frame_control_construct(scic);
+	if (result)
+		return result;
 
 	/*
 	 * Inform the silicon as to the location of the UF headers and
 	 * address table.
 	 */
-	writel(lower_32_bits(this_controller->uf_control.headers.physical_address),
-		&this_controller->scu_registers->sdma.uf_header_base_address_lower);
-	writel(upper_32_bits(this_controller->uf_control.headers.physical_address),
-		&this_controller->scu_registers->sdma.uf_header_base_address_upper);
-
-	writel(lower_32_bits(this_controller->uf_control.address_table.physical_address),
-		&this_controller->scu_registers->sdma.uf_address_table_lower);
-	writel(upper_32_bits(this_controller->uf_control.address_table.physical_address),
-		&this_controller->scu_registers->sdma.uf_address_table_upper);
+	writel(lower_32_bits(scic->uf_control.headers.physical_address),
+		&scic->scu_registers->sdma.uf_header_base_address_lower);
+	writel(upper_32_bits(scic->uf_control.headers.physical_address),
+		&scic->scu_registers->sdma.uf_header_base_address_upper);
+
+	writel(lower_32_bits(scic->uf_control.address_table.physical_address),
+		&scic->scu_registers->sdma.uf_address_table_lower);
+	writel(upper_32_bits(scic->uf_control.address_table.physical_address),
+		&scic->scu_registers->sdma.uf_address_table_upper);
+
+	return SCI_SUCCESS;
 }
 
 /**
@@ -2525,7 +2421,6 @@ static enum sci_status scic_controller_s
 			scic->completion_event_entries = SCU_EVENT_COUNT;
 			scic->completion_queue_entries =
 				SCU_COMPLETION_QUEUE_COUNT;
-			scic_sds_controller_build_memory_descriptor_table(scic);
 			break;
 
 		case SCI_MODE_SIZE:
@@ -2536,7 +2431,6 @@ static enum sci_status scic_controller_s
 			scic->completion_event_entries = SCU_MIN_EVENTS;
 			scic->completion_queue_entries =
 				SCU_MIN_COMPLETION_QUEUE_ENTRIES;
-			scic_sds_controller_build_memory_descriptor_table(scic);
 			break;
 
 		default:
@@ -3040,72 +2934,56 @@ static enum sci_status scic_sds_controll
 	u16 index;
 	enum sci_status result;
 
+	result = scic_sds_controller_ram_initialization(scic);
+	if (result)
+		return result;
+
+	/* Build the TCi free pool */
+	sci_pool_initialize(scic->tci_pool);
+	for (index = 0; index < scic->task_context_entries; index++)
+		sci_pool_put(scic->tci_pool, index);
+
+	/* Build the RNi free pool */
+	scic_sds_remote_node_table_initialize(
+			&scic->available_remote_nodes,
+			scic->remote_node_entries);
+
 	/*
-	 * Make sure that the SCI User filled in the memory descriptor
-	 * table correctly
+	 * Before anything else lets make sure we will not be
+	 * interrupted by the hardware.
 	 */
-	result = scic_sds_controller_validate_memory_descriptor_table(scic);
-
-	if (result == SCI_SUCCESS) {
-		/*
-		 * The memory descriptor list looks good so program the
-		 * hardware
-		 */
-		scic_sds_controller_ram_initialization(scic);
-	}
-
-	if (result == SCI_SUCCESS) {
-		/* Build the TCi free pool */
-		sci_pool_initialize(scic->tci_pool);
-		for (index = 0; index < scic->task_context_entries; index++)
-			sci_pool_put(scic->tci_pool, index);
-
-		/* Build the RNi free pool */
-		scic_sds_remote_node_table_initialize(
-				&scic->available_remote_nodes,
-				scic->remote_node_entries);
-	}
+	scic_controller_disable_interrupts(scic);
 
-	if (result == SCI_SUCCESS) {
-		/*
-		 * Before anything else lets make sure we will not be
-		 * interrupted by the hardware.
-		 */
-		scic_controller_disable_interrupts(scic);
+	/* Enable the port task scheduler */
+	scic_sds_controller_enable_port_task_scheduler(scic);
 
-		/* Enable the port task scheduler */
-		scic_sds_controller_enable_port_task_scheduler(scic);
+	/* Assign all the task entries to scic physical function */
+	scic_sds_controller_assign_task_entries(scic);
 
-		/* Assign all the task entries to scic physical function */
-		scic_sds_controller_assign_task_entries(scic);
+	/* Now initialze the completion queue */
+	scic_sds_controller_initialize_completion_queue(scic);
 
-		/* Now initialze the completion queue */
-		scic_sds_controller_initialize_completion_queue(scic);
-
-		/* Initialize the unsolicited frame queue for use */
-		scic_sds_controller_initialize_unsolicited_frame_queue(scic);
-	}
+	/* Initialize the unsolicited frame queue for use */
+	scic_sds_controller_initialize_unsolicited_frame_queue(scic);
 
 	/* Start all of the ports on this controller */
-	for (index = 0;
-	     (index < scic->logical_port_entries) && (result == SCI_SUCCESS);
-	     index++) {
+	for (index = 0; index < scic->logical_port_entries; index++) {
 		struct scic_sds_port *sci_port = &scic->port_table[index];
 
 		result = sci_port->state_handlers->parent.start_handler(
 				&sci_port->parent);
+		if (result)
+			return result;
 	}
 
-	if (result == SCI_SUCCESS) {
-		scic_sds_controller_start_next_phy(scic);
+	scic_sds_controller_start_next_phy(scic);
 
-		isci_timer_start(scic->timeout_timer, timeout);
+	isci_timer_start(scic->timeout_timer, timeout);
 
-		sci_base_state_machine_change_state(&scic->state_machine,
-						    SCI_BASE_CONTROLLER_STATE_STARTING);
-	}
+	sci_base_state_machine_change_state(&scic->state_machine,
+					    SCI_BASE_CONTROLLER_STATE_STARTING);
 
-	return result;
+	return SCI_SUCCESS;
 }
 
 /*
@@ -3658,8 +3536,6 @@ enum sci_status scic_controller_construc
 		&scic->parent, scic_sds_controller_state_table,
 		SCI_BASE_CONTROLLER_STATE_INITIAL);
 
-	sci_base_mdl_construct(&scic->mdl, scic->memory_descriptors,
-				ARRAY_SIZE(scic->memory_descriptors), NULL);
 	sci_base_state_machine_start(&scic->state_machine);
 
 	scic->scu_registers = scu_base;
Index: linux-2.6/drivers/scsi/isci/host.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/host.h	2011-04-01 17:40:50.097132746 +0200
+++ linux-2.6/drivers/scsi/isci/host.h	2011-04-01 17:41:15.128129693 +0200
@@ -75,14 +75,6 @@
 #define ISCI_CAN_QUEUE_VAL 250 /* < SCI_MAX_IO_REQUESTS ? */
 #define SCIC_CONTROLLER_STOP_TIMEOUT 5000
 
-struct coherent_memory_info {
-	struct list_head node;
-	dma_addr_t dma_handle;
-	void *vaddr;
-	size_t size;
-	struct sci_physical_memory_descriptor *mde;
-};
-
 struct isci_host {
 	struct scic_sds_controller *core_controller;
 	union scic_oem_parameters oem_parameters;
@@ -114,7 +106,6 @@ struct isci_host {
 	wait_queue_head_t eventq;
 	struct Scsi_Host *shost;
 	struct tasklet_struct completion_tasklet;
-	struct list_head mdl_struct_list;
 	struct list_head requests_to_complete;
 	struct list_head requests_to_errorback;
 	spinlock_t scic_lock;
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c	2011-04-01 17:40:50.061128936 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c	2011-04-01 18:00:21.968130083 +0200
@@ -68,26 +68,6 @@
 #include "sci_environment.h"
 
 /**
- * The UF buffer address table size must be programmed to a power of 2.  Find
- *    the first power of 2 that is equal to or greater then the number of
- *    unsolicited frame buffers to be utilized.
- * @uf_control: This parameter specifies the UF control object for which to
- *    update the address table count.
- *
- */
-void scic_sds_unsolicited_frame_control_set_address_table_count(
-	struct scic_sds_unsolicited_frame_control *uf_control)
-{
-	uf_control->address_table.count = SCU_MIN_UF_TABLE_ENTRIES;
-	while (
-		(uf_control->address_table.count < uf_control->buffers.count)
-		&& (uf_control->address_table.count < SCU_ABSOLUTE_MAX_UNSOLICITED_FRAMES)
-		) {
-		uf_control->address_table.count <<= 1;
-	}
-}
-
-/**
  * This method will program the unsolicited frames (UFs) into the UF address
  *    table and construct the UF frame structure being modeled in the core.  It
  *    will handle the case where some of the UFs are not being used and thus
@@ -155,23 +135,10 @@ static void scic_sds_unsolicited_frame_c
 	}
 }
 
-/**
- * This method constructs the various members of the unsolicted frame control
- *    object (buffers, headers, address, table, etc).
- * @uf_control: This parameter specifies the unsolicited frame control object
- *    to construct.
- * @mde: This parameter specifies the memory descriptor from which to derive
- *    all of the address information needed to get the unsolicited frame
- *    functionality working.
- * @controller: This parameter specifies the controller object associated with
- *    the uf_control being constructed.
- *
- */
-void scic_sds_unsolicited_frame_control_construct(
-	struct scic_sds_unsolicited_frame_control *uf_control,
-	struct sci_physical_memory_descriptor *mde,
-	struct scic_sds_controller *controller)
+enum sci_status
+scic_sds_unsolicited_frame_control_construct(struct scic_sds_controller *scic)
 {
+	struct scic_sds_unsolicited_frame_control *uf_control = &scic->uf_control;
 	u32 unused_uf_header_entries;
 	u32 used_uf_header_entries;
 	u32 used_uf_buffer_bytes;
@@ -179,10 +146,22 @@ void scic_sds_unsolicited_frame_control_
 	u32 used_uf_header_bytes;
 	dma_addr_t uf_buffer_phys_address;
 	void *uf_buffer_virt_address;
+	size_t size;
+
+	/*
+	 * The UF buffer address table size must be programmed to a power
+	 * of 2.  Find the first power of 2 that is equal to or greater then
+	 * the number of unsolicited frame buffers to be utilized.
+	 */
+	uf_control->address_table.count = SCU_MIN_UF_TABLE_ENTRIES;
+	while (uf_control->address_table.count < uf_control->buffers.count &&
+	       uf_control->address_table.count < SCU_ABSOLUTE_MAX_UNSOLICITED_FRAMES)
+		uf_control->address_table.count <<= 1;
 
 	/*
 	 * Prepare all of the memory sizes for the UF headers, UF address
-	 * table, and UF buffers themselves. */
+	 * table, and UF buffers themselves.
+	 */
 	used_uf_buffer_bytes     = uf_control->buffers.count
 				   * SCU_UNSOLICITED_FRAME_BUFFER_SIZE;
 	unused_uf_header_entries = uf_control->address_table.count
@@ -193,13 +172,19 @@ void scic_sds_unsolicited_frame_control_
 	used_uf_header_bytes     = used_uf_header_entries
 				   * sizeof(struct scu_unsolicited_frame_header);
 
+	size = used_uf_buffer_bytes + used_uf_header_bytes +
+			uf_control->address_table.count * sizeof(dma_addr_t);
+
+
 	/*
 	 * The Unsolicited Frame buffers are set at the start of the UF
 	 * memory descriptor entry. The headers and address table will be
 	 * placed after the buffers.
 	 */
-	uf_buffer_phys_address = mde->physical_address;
-	uf_buffer_virt_address = mde->virtual_address;
+	uf_buffer_virt_address = dmam_alloc_coherent(scic_to_dev(scic), size,
+							&uf_buffer_phys_address, GFP_KERNEL);
+	if (!uf_buffer_virt_address)
+		return SCI_FAILURE;
 
 	/*
 	 * Program the location of the UF header table into the SCU.
@@ -254,10 +239,12 @@ void scic_sds_unsolicited_frame_control_
 	scic_sds_unsolicited_frame_control_construct_frames(
 		uf_control,
 		uf_buffer_phys_address,
-		mde->virtual_address,
+		uf_buffer_virt_address,
 		unused_uf_header_entries,
 		used_uf_header_entries
 		);
+
+	return SCI_SUCCESS;
 }
 
 /**
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h	2011-04-01 17:40:50.069129977 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h	2011-04-01 17:59:28.027629187 +0200
@@ -64,7 +64,6 @@
 #define _SCIC_SDS_UNSOLICITED_FRAME_CONTROL_H_
 
 #include "scu_unsolicited_frame.h"
-#include "sci_memory_descriptor_list.h"
 #include "scu_constants.h"
 #include "sci_status.h"
 
@@ -248,14 +247,10 @@ struct scic_sds_unsolicited_frame_contro
 
 };
 
-void scic_sds_unsolicited_frame_control_set_address_table_count(
-	struct scic_sds_unsolicited_frame_control *uf_control);
-
 struct scic_sds_controller;
-void scic_sds_unsolicited_frame_control_construct(
-	struct scic_sds_unsolicited_frame_control *uf_control,
-	struct sci_physical_memory_descriptor *mde,
-	struct scic_sds_controller *this_controller);
+
+enum sci_status scic_sds_unsolicited_frame_control_construct(
+	struct scic_sds_controller *scic);
 
 enum sci_status scic_sds_unsolicited_frame_control_get_header(
 	struct scic_sds_unsolicited_frame_control *uf_control,
@@ -271,16 +266,4 @@ bool scic_sds_unsolicited_frame_control_
 	struct scic_sds_unsolicited_frame_control *uf_control,
 	u32 frame_index);
 
-/**
- * scic_sds_unsolicited_frame_control_get_mde_size() -
- *
- * This macro simply calculates the size of the memory descriptor entry that
- * relates to unsolicited frames and the surrounding silicon memory required to
- * utilize it.
- */
-#define scic_sds_unsolicited_frame_control_get_mde_size(uf_control) \
-	(((uf_control).buffers.count * SCU_UNSOLICITED_FRAME_BUFFER_SIZE) \
-	 + ((uf_control).address_table.count * sizeof(dma_addr_t)) \
-	 + ((uf_control).buffers.count * sizeof(struct scu_unsolicited_frame_header)))
-
 #endif /* _SCIC_SDS_UNSOLICITED_FRAME_CONTROL_H_ */
Index: linux-2.6/drivers/scsi/isci/Makefile
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/Makefile	2011-04-01 17:40:50.113130166 +0200
+++ linux-2.6/drivers/scsi/isci/Makefile	2011-04-01 17:41:15.132129794 +0200
@@ -25,6 +25,5 @@ isci-objs := init.o phy.o request.o sata
 	     core/scic_sds_smp_remote_device.o \
 	     core/scic_sds_remote_node_table.o \
 	     core/scic_sds_unsolicited_frame_control.o \
-	     core/sci_base_memory_descriptor_list.o \
 	     core/sci_base_state_machine.o \
 	     core/sci_util.o
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.h	2011-04-01 17:40:50.077130025 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h	2011-04-01 17:41:15.132129794 +0200
@@ -68,10 +68,8 @@
 
 #include "sci_pool.h"
 #include "sci_controller_constants.h"
-#include "sci_memory_descriptor_list.h"
 #include "sci_base_state.h"
 #include "sci_base_state_machine.h"
-#include "sci_base_memory_descriptor_list.h"
 #include "scic_config_parameters.h"
 #include "scic_sds_port.h"
 #include "scic_sds_phy.h"
@@ -89,40 +87,6 @@ struct scic_sds_remote_device;
 struct scic_sds_request;
 struct scic_sds_controller;
 
-#define SCU_COMPLETION_RAM_ALIGNMENT            (64)
-
-/**
- * enum scic_sds_controller_memory_descriptors -
- *
- * This enumeration depects the types of MDEs that are going to be created for
- * the controller object.
- */
-enum scic_sds_controller_memory_descriptors {
-	/**
-	 * Completion queue MDE entry
-	 */
-	SCU_MDE_COMPLETION_QUEUE,
-
-	/**
-	 * Remote node context MDE entry
-	 */
-	SCU_MDE_REMOTE_NODE_CONTEXT,
-
-	/**
-	 * Task context MDE entry
-	 */
-	SCU_MDE_TASK_CONTEXT,
-
-	/**
-	 * Unsolicited frame buffer MDE entrys this is the start of the unsolicited
-	 * frame buffer entries.
-	 */
-	SCU_MDE_UF_BUFFER,
-
-	SCU_MAX_MDES
-};
-
-
 /**
  * struct scic_power_control -
  *
@@ -174,13 +138,6 @@ struct scic_sds_controller {
 	struct sci_base_object parent;
 
 	/**
-	 * This field points to the memory descriptor list associated with this
-	 * controller.  The MDL indicates the memory requirements necessary for
-	 * this controller object.
-	 */
-	struct sci_base_memory_descriptor_list mdl;
-
-	/**
 	 * This field contains the information for the base controller state
 	 * machine.
 	 */
@@ -285,12 +242,6 @@ struct scic_sds_controller {
 	union scu_remote_node_context *remote_node_context_table;
 
 	/**
-	 * This field is the array of physical memory requiremets for this controller
-	 * object.
-	 */
-	struct sci_physical_memory_descriptor memory_descriptors[SCU_MAX_MDES];
-
-	/**
 	 * This field is a pointer to the completion queue.  This memory is
 	 * written to by the hardware and read by the software.
 	 */
