From: "=?utf-8?B?amFja193YW5n?=" <jack_wang@usish.com>
Subject: =?utf-8?B?UmU6IFtSRkMgUEFUQ0ggMS82XSBpc2NpOiBpbml0aWFsaXphdGlvbg==?=
Date: Mon, 7 Feb 2011 15:58:46 +0800
Message-ID: <201102071558449371072@usish.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:56554 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BGH6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 02:58:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?RGFuIFdpbGxpYW1z?= <dan.j.williams@intel.com>, =?utf-8?B?amFtZXMuYm90dG9tbGV5?= <james.bottomley@suse.de>
Cc: =?utf-8?B?ZGF2ZS5qaWFuZw==?= <dave.jiang@intel.com>, =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?amFjZWsuZGFuZWNraQ==?= <jacek.danecki@intel.com>, =?utf-8?B?ZWQuY2llY2hhbm93c2tp?= <ed.ciechanowski@intel.com>, =?utf-8?B?amVmZnJleS5kLnNraXJ2aW4=?= <jeffrey.d.skirvin@intel.com>, =?utf-8?B?ZWRtdW5kLm5hZG9sc2tp?= <edmund.nadolski@intel.com>


+
+ /**
+  * check interrupt_handler's status and call completion_handler if true,
+  * link_up events should be coming from the scu core lib, as phy's come
+  * online. for each link_up from the core, call
+  * get_received_identify_address_frame, copy the frame into the
+  * sas_phy object and call libsas notify_port_event(PORTE_BYTES_DMAED).
+  * continue to return zero from thee scan_finished routine until

[Jack] Here "thee" seams typo of "the"




+static struct coherent_memory_info *isci_host_alloc_mdl_struct(
+ struct isci_host *isci_host,
+ u32 size)
+{
+ struct coherent_memory_info *mdl_struct;
+ void *uncached_address = NULL;
+
+
+ mdl_struct = devm_kzalloc(&isci_host->pdev->dev,
+   sizeof(*mdl_struct),
+   GFP_KERNEL);
+ if (!mdl_struct)
+ return NULL;
+
+ INIT_LIST_HEAD(&mdl_struct->node);
+
+ uncached_address = dmam_alloc_coherent(&isci_host->pdev->dev,
+        size,
+        &mdl_struct->dma_handle,
+        GFP_KERNEL);
+ if (!uncached_address)
+ return NULL;
+
+ /* memset the whole memory area. */
+ memset((char *)uncached_address, 0, size);
[Jack] cast void * is not needed.
+ mdl_struct->vaddr = uncached_address;
+ mdl_struct->size = (size_t)size;
+
+ return mdl_struct;
+}
+
+static void isci_host_build_mde(
+ struct sci_physical_memory_descriptor *mde_struct,
+ struct coherent_memory_info *mdl_struct)
+{
+ unsigned long address = 0;
+ dma_addr_t dma_addr = 0;
+
+ address = (unsigned long)mdl_struct->vaddr;
[Jack] Why cast void vadd to usigned long? This may cause problem on x64.

+ dma_addr = mdl_struct->dma_handle;
+
+ /* to satisfy the alignment. */
+ if ((address % mde_struct->constant_memory_alignment) != 0) {
+ int align_offset
+ = (mde_struct->constant_memory_alignment
+    - (address % mde_struct->constant_memory_alignment));
+ address += align_offset;
+ dma_addr += align_offset;
+ }
+
+ mde_struct->virtual_address = (void *)address;
+ mde_struct->physical_address = dma_addr;
+ mdl_struct->mde = mde_struct;
+}
+



+
+ /* stop the comtroller and wait for completion.  */
[Jack] controller.

+

+
+static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev)
+{
+ return pci_get_drvdata(pdev);
+}
+
[Jack] This wrap is not needed I think.


+static inline
+enum isci_status isci_host_get_state(
+ struct isci_host *isci_host)
+{
+ return isci_host->status;
+}
[Jack] This wrap is not needed too.



