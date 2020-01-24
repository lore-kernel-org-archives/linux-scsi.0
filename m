Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD910C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 10:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 813262071A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 10:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R0X7CIyv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgAXKrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 05:47:01 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38075 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgAXKrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 05:47:01 -0500
Received: by mail-oi1-f196.google.com with SMTP id l9so1427468oii.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 02:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PdiIfgD5HGtJCIsqXk3zJrbZqL9KmZgz3r4zxgPm4Zg=;
        b=R0X7CIyvhnKW916aDLtOwCtsQGO0xqjVHHSPRo+30ljBLWixuzXCMgDm2TM6Vz6sDd
         7kYkw9mOk5a3M4/njMle1NqV2M6t4AoBHk7XRUsD2acaQz+kZUWlqK4+jSPKvS4oZwN0
         QjroB71Wpx8IxJv6+AuvPYwB+hSLJQD6fmj4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PdiIfgD5HGtJCIsqXk3zJrbZqL9KmZgz3r4zxgPm4Zg=;
        b=OREgNnz2ZsO4G3L920CwkWNHU2ry0hCeSi70/qS+Bw6UM/C0IHbe1tPQRLqZaV0fO8
         7ACyzlCyUF3Ct2C81hWdhwOuyr1CjbG/HEzI7Z0ixg/d1SooCASad2592wkDA59BBO3I
         2n2pY5FAc0hpUeqfdAkdOLmzxmbZVGbYteYvKKDcBNHS6c+BLdq79tL7fZD69dElqm6M
         9kwCqxNSX8XpMB7lYptvm++Fa5NJ3i3KTPksTyXZ4u2HYSAJqJ50+ViTumpdd+CiFyYZ
         Vwtwm/FWbRwOT6zjDsFEoor03Eakm/ERPMSD8Q7KcGVpEwbnDS48VKKD3C//bDxvhB55
         4OAg==
X-Gm-Message-State: APjAAAW4ZO1/MF+f/sZAMh67zpRftZol5816O0+3qmtkrxoqREjoIGvc
        NjUM4I3oY8PV7gOgTaMnfF6Lu4hTbnMPDfdK/RZVqQ==
X-Google-Smtp-Source: APXvYqxto+G2xpQHf+hFzkleLZrqsAaqQLXY9LNTFqAY7wu7IJAjEmCN3RdhxQ7eGEcpJlrw6aoMt1QqeFnD/FbreXU=
X-Received: by 2002:aca:4d4f:: with SMTP id a76mr1608041oib.26.1579862819436;
 Fri, 24 Jan 2020 02:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20200117134506.633586-1-hch@lst.de>
In-Reply-To: <20200117134506.633586-1-hch@lst.de>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Fri, 24 Jan 2020 16:16:47 +0530
Message-ID: <CAK=zhgpVDti+qRwnj=Jg+RtmO_b3Bu00q_TvrNWGCjTU=4humg@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: don't change the dma coherent mask after allocations
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra Basappa <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        abdhalee@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 7:15 PM Christoph Hellwig <hch@lst.de> wrote:
>
> The DMA layer does not allow changing the DMA coherent mask after
> there are outstanding allocations.  Stop doing that and always
> use a 32-bit coherent DMA mask in mpt3sas.

Our HBA hardware has a requirement that each set of RDPQ reply
descriptor pools should be within the 4gb region. so to accommodate
this requirement driver is first setting the DMA coherent mask to 32
bit then allocating the RDPQ pools and then resetting the DMA coherent
make to 64 and allocating the remaining pools.

if we completely set the DMA coherent mask to 32 bit then there are
chances that sometimes driver may not get requested memory within the
first 4gb region and HBA initialization may fail. So instead of
setting the DMA coherent mask to 32 bit, we follow the same below
logic which megaraid_sas driver is doing now. i.e we first allocate
set of rdpq pools at once and check this allocated block is within the
4gb region, if not then free this block and allocate a new block from
aligned pci pool.

                 /* reply desc pool requires to be in same 4 gb region.
                 * Below function will check this.
                 * In case of failure, new pci pool will be created with updated
                 * alignment.
                 * For RDPQ buffers, driver always allocate two
separate pci pool.
                 * Alignment will be used such a way that next allocation if
                 * success, will always meet same 4gb region requirement.
                 * rdpq_tracker keep track of each buffer's physical,
                 * virtual address and pci pool descriptor. It will help driver
                 * while freeing the resources.
                 *
                 */
                if (!megasas_check_same_4gb_region(instance, rdpq_chunk_phys[i],
                                                   chunk_size)) {
                        dma_pool_free(fusion->reply_frames_desc_pool,
                                      rdpq_chunk_virt[i],
                                      rdpq_chunk_phys[i]);

                        rdpq_chunk_virt[i] =

dma_pool_alloc(fusion->reply_frames_desc_pool_align,
                                               GFP_KERNEL, &rdpq_chunk_phys[i]);
                        if (!rdpq_chunk_virt[i]) {
                                dev_err(&instance->pdev->dev,
                                        "Failed from %s %d\n",
                                        __func__, __LINE__);
                                return -ENOMEM;
                        }
                        fusion->rdpq_tracker[i].dma_pool_ptr =
                                        fusion->reply_frames_desc_pool_align;
                } else {
                        fusion->rdpq_tracker[i].dma_pool_ptr =
                                        fusion->reply_frames_desc_pool;
                }

Next week I will post the patch with above logic implemented in mpt3sas driver.

Regards,
Sreekanth


>
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 67 ++++++++---------------------
>  drivers/scsi/mpt3sas/mpt3sas_base.h |  2 -
>  2 files changed, 19 insertions(+), 50 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index fea3cb6a090b..3b51bed05008 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2706,58 +2706,38 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
>  static int
>  _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
>  {
> -       u64 required_mask, coherent_mask;
>         struct sysinfo s;
> -       /* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
> -       int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
> -
> -       if (ioc->is_mcpu_endpoint)
> -               goto try_32bit;
> +       int dma_mask;
>
> -       required_mask = dma_get_required_mask(&pdev->dev);
> -       if (sizeof(dma_addr_t) == 4 || required_mask == 32)
> -               goto try_32bit;
> -
> -       if (ioc->dma_mask)
> -               coherent_mask = DMA_BIT_MASK(dma_mask);
> +       if (ioc->is_mcpu_endpoint ||
> +           sizeof(dma_addr_t) == 4 ||
> +           dma_get_required_mask(&pdev->dev) <= 32)
> +               dma_mask = 32;
> +       /* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
> +       else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
> +               dma_mask = 63;
>         else
> -               coherent_mask = DMA_BIT_MASK(32);
> +               dma_mask = 64;
>
>         if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
> -           dma_set_coherent_mask(&pdev->dev, coherent_mask))
> -               goto try_32bit;
> -
> -       ioc->base_add_sg_single = &_base_add_sg_single_64;
> -       ioc->sge_size = sizeof(Mpi2SGESimple64_t);
> -       ioc->dma_mask = dma_mask;
> -       goto out;
> -
> - try_32bit:
> -       if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
> +           dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))
>                 return -ENODEV;
>
> -       ioc->base_add_sg_single = &_base_add_sg_single_32;
> -       ioc->sge_size = sizeof(Mpi2SGESimple32_t);
> -       ioc->dma_mask = 32;
> - out:
> +       if (dma_mask > 32) {
> +               ioc->base_add_sg_single = &_base_add_sg_single_64;
> +               ioc->sge_size = sizeof(Mpi2SGESimple64_t);
> +       } else {
> +               ioc->base_add_sg_single = &_base_add_sg_single_32;
> +               ioc->sge_size = sizeof(Mpi2SGESimple32_t);
> +       }
> +
>         si_meminfo(&s);
>         ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
> -                ioc->dma_mask, convert_to_kb(s.totalram));
> +                dma_mask, convert_to_kb(s.totalram));
>
>         return 0;
>  }
>
> -static int
> -_base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
> -                                     struct pci_dev *pdev)
> -{
> -       if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
> -               if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
> -                       return -ENODEV;
> -       }
> -       return 0;
> -}
> -
>  /**
>   * _base_check_enable_msix - checks MSIX capabable.
>   * @ioc: per adapter object
> @@ -5030,14 +5010,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
>                 total_sz += sz;
>         } while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
>
> -       if (ioc->dma_mask > 32) {
> -               if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
> -                       ioc_warn(ioc, "no suitable consistent DMA mask for %s\n",
> -                                pci_name(ioc->pdev));
> -                       goto out;
> -               }
> -       }
> -
>         ioc->scsiio_depth = ioc->hba_queue_depth -
>             ioc->hi_priority_depth - ioc->internal_depth;
>
> @@ -6965,7 +6937,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>         ioc->smp_affinity_enable = smp_affinity_enable;
>
>         ioc->rdpq_array_enable_assigned = 0;
> -       ioc->dma_mask = 0;
>         if (ioc->is_aero_ioc)
>                 ioc->base_readl = &_base_readl_aero;
>         else
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index faca0a5e71f8..e57cade1155c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -1011,7 +1011,6 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
>   * @ir_firmware: IR firmware present
>   * @bars: bitmask of BAR's that must be configured
>   * @mask_interrupts: ignore interrupt
> - * @dma_mask: used to set the consistent dma mask
>   * @pci_access_mutex: Mutex to synchronize ioctl, sysfs show path and
>   *                     pci resource handling
>   * @fault_reset_work_q_name: fw fault work queue
> @@ -1185,7 +1184,6 @@ struct MPT3SAS_ADAPTER {
>         u8              ir_firmware;
>         int             bars;
>         u8              mask_interrupts;
> -       int             dma_mask;
>
>         /* fw fault handler */
>         char            fault_reset_work_q_name[20];
> --
> 2.24.1
>
