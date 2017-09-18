From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH V2] megaraid: kmemleak: Track page allocation for fusion
Date: Mon, 18 Sep 2017 20:40:05 +0530
Message-ID: <f582abfe99a5a00f876d5bbefdb306fe@mail.gmail.com>
References: <20170915052152.5032-1-shuwang@redhat.com> <20170915180007.GA24045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:53240 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932467AbdIRPKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2017 11:10:08 -0400
Received: by mail-lf0-f52.google.com with SMTP id b127so863719lfe.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2017 08:10:07 -0700 (PDT)
In-Reply-To: <20170915180007.GA24045@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, shuwang@redhat.com
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com, catalin.marinas@arm.com

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, September 15, 2017 11:30 PM
> To: shuwang@redhat.com
> Cc: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> shivasharan.srikanteshwara@broadcom.com; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; megaraidlinux.pdl@broadcom.com; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; chuhu@redhat.com;
> yizhan@redhat.com; catalin.marinas@arm.com
> Subject: Re: [PATCH V2] megaraid: kmemleak: Track page allocation for
fusion
>
> I think the megaraid fusion code has a deeper problem here.
>
> Instead of playing weird games with get_free_pages and vmalloc the
structure
> just needs to shrink by moving all the arrays of MAX_MSIX_QUEUES_FUSION
> size into a separate allocation for each, and then we have normall,
small
> kmalloc allocations.

Hi Christoph,
We understand your suggestion on shrinking the size of fusion_context so
that we can use kmalloc to allocate the structure.
Size of fusion_context structure now is about 179kB and it is contributed
almost entirely by log_to_span array (~176kB).
The rest of the arrays do not make as much difference to the size.
We will send a new patch that separates allocation for log_to_span array
from fusion_context.
For now it is a Nack for this patch then.

crash> struct -o fusion_context
struct fusion_context {
       [0] struct megasas_cmd_fusion **cmd_list;
       [8] dma_addr_t req_frames_desc_phys;
      [16] u8 *req_frames_desc;
      [24] struct dma_pool *io_request_frames_pool;
      [32] dma_addr_t io_request_frames_phys;
      [40] u8 *io_request_frames;
      [48] struct dma_pool *sg_dma_pool;
      [56] struct dma_pool *sense_dma_pool;
      [64] dma_addr_t reply_frames_desc_phys[128];
    [1088] union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc[128];
    [2112] struct dma_pool *reply_frames_desc_pool;
    [2120] u16 last_reply_idx[128];
    [2376] u32 reply_q_depth;
    [2380] u32 request_alloc_sz;
    [2384] u32 reply_alloc_sz;
    [2388] u32 io_frames_alloc_sz;
    [2392] struct MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY *rdpq_virt;
    [2400] dma_addr_t rdpq_phys;
    [2408] u16 max_sge_in_main_msg;
    [2410] u16 max_sge_in_chain;
    [2412] u8 chain_offset_io_request;
    [2413] u8 chain_offset_mfi_pthru;
    [2416] struct MR_FW_RAID_MAP_DYNAMIC *ld_map[2];
    [2432] dma_addr_t ld_map_phys[2];
    [2448] struct MR_DRV_RAID_MAP_ALL *ld_drv_map[2];
    [2464] u32 max_map_sz;
    [2468] u32 current_map_sz;
    [2472] u32 old_map_sz;
    [2476] u32 new_map_sz;
    [2480] u32 drv_map_sz;
    [2484] u32 drv_map_pages;
    [2488] struct MR_PD_CFG_SEQ_NUM_SYNC *pd_seq_sync[2];
    [2504] dma_addr_t pd_seq_phys[2];
    [2520] u8 fast_path_io;
    [2528] struct LD_LOAD_BALANCE_INFO *load_balance_info;
    [2536] u32 load_balance_info_pages;
    [2544] LD_SPAN_INFO log_to_span[256];
  [182768] u8 adapter_type;
  [182776] struct LD_STREAM_DETECT **stream_detect_by_ld; }
SIZE: 182784

Thanks,
Shivasharan
