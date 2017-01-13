From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [bug report] scsi: megaraid_sas: Add the Support for SAS3.5
 Generic Megaraid Controllers Capabilities
Date: Fri, 13 Jan 2017 14:53:04 -0500
Message-ID: <c6725ba06455ac1000efd69bd56c79a2@mail.gmail.com>
References: <20170113125032.GA11582@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36051 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdAMTxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 14:53:07 -0500
Received: by mail-wm0-f47.google.com with SMTP id c85so79246536wmi.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 11:53:06 -0800 (PST)
In-Reply-To: <20170113125032.GA11582@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>, Christopher Owens <christopher.owens@broadcom.com>

Hi Dan,

I will fix the static checker warning

Thanks
sasi

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Friday, January 13, 2017 7:51 AM
To: sasikumar.pc@broadcom.com
Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
Subject: [bug report] scsi: megaraid_sas: Add the Support for SAS3.5
Generic Megaraid Controllers Capabilities

Hello Sasikumar Chandrasekaran,

This is a semi-automatic email about new static checker warnings.

The patch 9581ebebbe35: "scsi: megaraid_sas: Add the Support for
SAS3.5 Generic Megaraid Controllers Capabilities" from Jan 10, 2017, leads
to the following Smatch complaint:

drivers/scsi/megaraid/megaraid_sas_base.c:5245 megasas_init_fw()
	 error: we previously assumed 'fusion' could be null (see line
5069)

drivers/scsi/megaraid/megaraid_sas_base.c
  5068	
  5069		if (fusion)
                    ^^^^^^
Patch introduces a new NULL check.

  5070			instance->instancet =
&megasas_instance_template_fusion;
  5071		else {
  5072			switch (instance->pdev->device) {
  5073			case PCI_DEVICE_ID_LSI_SAS1078R:
  5074			case PCI_DEVICE_ID_LSI_SAS1078DE:
  5075				instance->instancet =
&megasas_instance_template_ppc;
  5076				break;
  5077			case PCI_DEVICE_ID_LSI_SAS1078GEN2:
  5078			case PCI_DEVICE_ID_LSI_SAS0079GEN2:
  5079				instance->instancet =
&megasas_instance_template_gen2;
  5080				break;
  5081			case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
  5082			case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
  5083				instance->instancet =
&megasas_instance_template_skinny;
  5084				break;
  5085			case PCI_DEVICE_ID_LSI_SAS1064R:
  5086			case PCI_DEVICE_ID_DELL_PERC5:
  5087			default:
  5088				instance->instancet =
&megasas_instance_template_xscale;
  5089				instance->pd_list_not_supported = 1;
  5090				break;
  5091			}
  5092		}
  5093	
  5094		if (megasas_transition_to_ready(instance, 0)) {
  5095			atomic_set(&instance->fw_reset_no_pci_access, 1);
  5096			instance->instancet->adp_reset
  5097				(instance, instance->reg_set);
  5098			atomic_set(&instance->fw_reset_no_pci_access, 0);
  5099			dev_info(&instance->pdev->dev,
  5100				"FW restarted successfully from %s!\n",
  5101				__func__);
  5102	
  5103			/*waitting for about 30 second before retry*/
  5104			ssleep(30);
  5105	
  5106			if (megasas_transition_to_ready(instance, 0))
  5107				goto fail_ready_state;
  5108		}
  5109	
  5110		if (instance->is_ventura) {
  5111			scratch_pad_3 =
  5112
readl(&instance->reg_set->outbound_scratch_pad_3);
  5113	#if VD_EXT_DEBUG
  5114			dev_info(&instance->pdev->dev, "scratch_pad3
0x%x\n",
  5115				scratch_pad_3);
  5116	#endif
  5117			instance->max_raid_mapsize = ((scratch_pad_3 >>
  5118				MR_MAX_RAID_MAP_SIZE_OFFSET_SHIFT) &
  5119				MR_MAX_RAID_MAP_SIZE_MASK);
  5120		}
  5121	
  5122		/* Check if MSI-X is supported while in ready state */
  5123		msix_enable =
(instance->instancet->read_fw_status_reg(reg_set) &
  5124			       0x4000000) >> 0x1a;
  5125		if (msix_enable && !msix_disable) {
  5126			int irq_flags = PCI_IRQ_MSIX;
  5127	
  5128			scratch_pad_2 = readl
  5129
(&instance->reg_set->outbound_scratch_pad_2);
  5130			/* Check max MSI-X vectors */
  5131			if (fusion) {
  5132				if (fusion->adapter_type ==
THUNDERBOLT_SERIES) { /* Thunderbolt Series*/
  5133					instance->msix_vectors =
(scratch_pad_2
  5134						&
MR_MAX_REPLY_QUEUES_OFFSET) + 1;
  5135					fw_msix_count =
instance->msix_vectors;
  5136				} else { /* Invader series supports more
than 8 MSI-x vectors*/
  5137					instance->msix_vectors =
((scratch_pad_2
  5138						&
MR_MAX_REPLY_QUEUES_EXT_OFFSET)
  5139						>>
MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
  5140					if (instance->msix_vectors > 16)
  5141						instance->msix_combined =
true;
  5142	
  5143					if (rdpq_enable)
  5144						instance->is_rdpq =
(scratch_pad_2 & MR_RDPQ_MODE_OFFSET) ?
  5145									1
: 0;
  5146					fw_msix_count =
instance->msix_vectors;
  5147					/* Save 1-15 reply post index
address to local memory
  5148					 * Index 0 is already saved from
reg offset
  5149					 *
MPI2_REPLY_POST_HOST_INDEX_OFFSET
  5150					 */
  5151					for (loop = 1; loop <
MR_MAX_MSIX_REG_ARRAY; loop++) {
  5152
instance->reply_post_host_index_addr[loop] =
  5153							(u32 __iomem *)
  5154							((u8 __iomem
*)instance->reg_set +
  5155
MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
  5156							+ (loop * 0x10));
  5157					}
  5158				}
  5159				if (msix_vectors)
  5160					instance->msix_vectors =
min(msix_vectors,
  5161						instance->msix_vectors);
  5162			} else /* MFI adapters */
  5163				instance->msix_vectors = 1;
  5164			/* Don't bother allocating more MSI-X vectors than
cpus */
  5165			instance->msix_vectors =
min(instance->msix_vectors,
  5166						     (unsigned
int)num_online_cpus());
  5167			if (smp_affinity_enable)
  5168				irq_flags |= PCI_IRQ_AFFINITY;
  5169			i = pci_alloc_irq_vectors(instance->pdev, 1,
  5170						  instance->msix_vectors,
irq_flags);
  5171			if (i > 0)
  5172				instance->msix_vectors = i;
  5173			else
  5174				instance->msix_vectors = 0;
  5175		}
  5176		/*
  5177		 * MSI-X host index 0 is common for all adapter.
  5178		 * It is used for all MPT based Adapters.
  5179		 */
  5180		if (instance->msix_combined) {
  5181			instance->reply_post_host_index_addr[0] =
  5182					(u32 *)((u8 *)instance->reg_set +
  5183
MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET);
  5184		} else {
  5185			instance->reply_post_host_index_addr[0] =
  5186				(u32 *)((u8 *)instance->reg_set +
  5187				MPI2_REPLY_POST_HOST_INDEX_OFFSET);
  5188		}
  5189	
  5190		i = pci_alloc_irq_vectors(instance->pdev, 1, 1,
PCI_IRQ_LEGACY);
  5191		if (i < 0)
  5192			goto fail_setup_irqs;
  5193	
  5194		dev_info(&instance->pdev->dev,
  5195			"firmware supports msix\t: (%d)", fw_msix_count);
  5196		dev_info(&instance->pdev->dev,
  5197			"current msix/online cpus\t: (%d/%d)\n",
  5198			instance->msix_vectors, (unsigned
int)num_online_cpus());
  5199		dev_info(&instance->pdev->dev,
  5200			"RDPQ mode\t: (%s)\n", instance->is_rdpq ?
"enabled" : "disabled");
  5201	
  5202		tasklet_init(&instance->isr_tasklet,
instance->instancet->tasklet,
  5203			(unsigned long)instance);
  5204	
  5205		instance->ctrl_info = kzalloc(sizeof(struct
megasas_ctrl_info),
  5206					GFP_KERNEL);
  5207		if (instance->ctrl_info == NULL)
  5208			goto fail_init_adapter;
  5209	
  5210		/*
  5211		 * Below are default value for legacy Firmware.
  5212		 * non-fusion based controllers
  5213		 */
  5214		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES;
  5215		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
  5216		/* Get operational params, sge flags, send init cmd to
controller */
  5217		if (instance->instancet->init_adapter(instance))
  5218			goto fail_init_adapter;
  5219	
  5220		if (instance->msix_vectors ?
  5221			megasas_setup_irqs_msix(instance, 1) :
  5222			megasas_setup_irqs_ioapic(instance))
  5223			goto fail_init_adapter;
  5224	
  5225		instance->instancet->enable_intr(instance);
  5226	
  5227		dev_info(&instance->pdev->dev, "INIT adapter done\n");
  5228	
  5229		megasas_setup_jbod_map(instance);
  5230	
  5231		/** for passthrough
  5232		 * the following function will get the PD LIST.
  5233		 */
  5234		memset(instance->pd_list, 0,
  5235			(MEGASAS_MAX_PD * sizeof(struct
megasas_pd_list)));
  5236		if (megasas_get_pd_list(instance) < 0) {
  5237			dev_err(&instance->pdev->dev, "failed to get PD
list\n");
  5238			goto fail_get_pd_list;
  5239		}
  5240	
  5241		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
  5242	
  5243		/* stream detection initialization */
  5244		if (instance->is_ventura) {
  5245			fusion->stream_detect_by_ld =
  5246			kzalloc(sizeof(struct LD_STREAM_DETECT *)
  5247			* MAX_LOGICAL_DRIVES_EXT,
  5248                  GFP_KERNEL);

Ugh...  What's with the indenting here?  Normally, I spent some time
reviewing these static checker warnings before I email the reports but
it's hard to even look at this code.  It makes me discouraged to look at
code this ugly.

Everyone hates newbies coming in and sending hundreds of style cleanups
but to me it means that basic style is pretty easy for everyone.  Just
making the code look nice shows me that you at least care a little bit
instead of just pooping out code and merging it into upstream.

Someone emailed me this morning appologizing for introducing an ERR_PTR
dereference.  I'm thinking, that's just a mistake.  We all make mistakes
it's part of being human.  But when I look at this code, I feel sad
because at least put some effort into it...

Anyway, I suspect that this is a false positive but it's too painful to
look at this code so I haven't checked.

  5249                  if (!fusion->stream_detect_by_ld) {
  5250                          dev_err(&instance->pdev->dev,
  5251                                          "unable to allocate stream
detection for pool of LDs\n");
  5252                          goto fail_get_ld_pd_list;
  5253                  }
  5254                  for (i = 0; i < MAX_LOGICAL_DRIVES_EXT; ++i) {
  5255                          fusion->stream_detect_by_ld[i] =
  5256                                  kmalloc(sizeof(struct
LD_STREAM_DETECT),
  5257                                  GFP_KERNEL);
  5258                          if (!fusion->stream_detect_by_ld[i]) {
  5259                                  dev_err(&instance->pdev->dev,
  5260                                          "unable to allocate stream
detect by LD\n ");
  5261                                  for (j = 0; j < i; ++j)
  5262
kfree(fusion->stream_detect_by_ld[j]);
  5263
kfree(fusion->stream_detect_by_ld);
  5264                                  fusion->stream_detect_by_ld =
NULL;
  5265                                  goto fail_get_ld_pd_list;
  5266                          }
  5267
fusion->stream_detect_by_ld[i]->mru_bit_map
  5268                                  = MR_STREAM_BITMAP;
  5269                  }
  5270          }

regards,
dan carpenter
