From: Christian Vilhelm <christian.vilhelm@univ-lille2.fr>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Thu, 15 Oct 2009 08:01:03 +0200
Message-ID: <4AD6BA9F.1060704@univ-lille2.fr>
References: <3CD4E24D4F537D439B71EB28963F98F46815EA2115@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.univ-lille2.fr ([194.254.117.6]:56735 "EHLO
	smtp.univ-lille2.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbZJOGBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 02:01:50 -0400
In-Reply-To: <3CD4E24D4F537D439B71EB28963F98F46815EA2115@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Meena Shanmugam, TLS-Chennai" <smeena@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tfjellstrom@shaw.ca" <tfjellstrom@shaw.ca>

Meena Shanmugam, TLS-Chennai wrote:
> Hi,
> 
> I am also facing the same problem with this driver. I'm using Adaptec ASC-1045 which uses the Marvell 88SE6440 chip. In my case, this could be reproduced with RAID-5 configured with 3 SATA drives. While analysing the problem, it looks like the prd table is getting corrupted in the SATA path triggers the issue.
> 
> ----mvs_sas.c---
>  726 #ifndef DISABLE_HOTPLUG_DMA_FIX
>  727         if (task->data_dir == DMA_FROM_DEVICE)
>  728                 MVS_CHIP_DISP->dma_fix(asi->bulk_buffer_dma,
>  729                         TRASH_BUCKET_SIZE, tei->n_elem, buf_prd);
>  730 #endif
> -----------
> 
> The hang issue doesn't occur after enabling DISABLE_HOTPLUG_DMA_FIX in mvs_sas.h file. Please let me know if this fix solves the issue. Btw, I'm not sure about the reason why this macro is disabled by default. Someone who is aware about this change can throw light on this. Meanwhile, I'm running some overnight test to see if this workaround/fix is harmless.

I just tried that, enabling DISABLE_HOTPLUG_DMA_FIX. I still get the 
error when creating an array, it just worked a little further (building 
for two minutes before hanging instead of immediately).

Christian Vilhelm.

-- 
/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\
|       Christian Vilhelm : christian.vilhelm@univ-lille2.fr         |
|            Reality is for people who lack imagination              |
\____________________________________________________________________/
