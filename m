Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C29C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 16:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443851AbiEFQp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 12:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443847AbiEFQp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 12:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 001F95FF07
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 09:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651855302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ns/SqOIYWFDDNLn6N6Az9wYddqD1NSdVIByobzC2Dtg=;
        b=LbEMuVmihaLDpWYxUQhefBgJojfoXys4nQcUYgDnKhTB9kNB2nCdL1U5SudajVSopMuQpy
        REo6sqnULKxazm2kQaL5awlAN58xmKJB0RCaJ/XwnDknjnq0qXi99eIuZhyKREl8AuHjl6
        dIylzOg6Q7u9+ameLd5AFay1Xtq4azI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-RkHScG-NMqucVJx2Owq3Tw-1; Fri, 06 May 2022 12:41:40 -0400
X-MC-Unique: RkHScG-NMqucVJx2Owq3Tw-1
Received: by mail-pg1-f197.google.com with SMTP id l72-20020a63914b000000b003c1ac4355f5so3874859pge.4
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 09:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ns/SqOIYWFDDNLn6N6Az9wYddqD1NSdVIByobzC2Dtg=;
        b=G5kMh8r/mvrgViF3es1jIuIMwwoCsazT2kkhTDoyAOF2xXdGmgpTLd0m/9hnphvFqH
         X1JJBYgiYvKoasJL+/FdlMzLJ3gns6RZWmAAqrIogPofCdqId5UId1POwrK3gm9cv1qM
         gs83j/MJ2Qc+1oixFoWt+P+SSjD7f5jr+b/a5goDMKC6EB8At4Sw4atvqF3yjuwTe2Tt
         H2Hzj/as6M/i/E85nlw24+e4qfBLQwJL1KW8Zydf+vmeNWtb8hIb7l+XNuBZkgzy+4bm
         Oy28Vm4vED5OeHaF3NBAfvPzB1PodXe2uRVLv4vpJyWVuLRbwk4pOdAtoz0kHk+2R7zz
         KcnQ==
X-Gm-Message-State: AOAM531l5rbrIVju48xBr6FYtoDsDe8BEKh2LcbBpLCfbjhmbmof/MPQ
        DOMMMG46Y5wPJbHbjTkQ4cE/68at7StZGbTfKqfBt6gv0JBdYifZAsE/HbtBdGP5t1bSkhBLizJ
        b1j0y5eir+nH+REXTmiQD0g==
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id r19-20020a6560d3000000b0039cf4315859mr3416353pgv.442.1651855299636;
        Fri, 06 May 2022 09:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiwBcWSbnKafvkJt8JXKHDFlv8ujcbCPoe7r/ZhYmaOnlWq8OOg5il6sVteHbLoKF+tK115w==
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id r19-20020a6560d3000000b0039cf4315859mr3416338pgv.442.1651855299419;
        Fri, 06 May 2022 09:41:39 -0700 (PDT)
Received: from [192.168.1.52] (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090322ce00b0015e8d4eb2dasm2038103plg.292.2022.05.06.09.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 09:41:39 -0700 (PDT)
Message-ID: <f8a981ab6a1c24d132321a628cb01148308e8751.camel@redhat.com>
Subject: Re: [PATCH 11/12] lpfc: Use sg_dma_address and sg_dma_len macros
 for NVMe I/O
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Nigel Kirkland <nkirkland2304@gmail.com>
Date:   Fri, 06 May 2022 09:41:37 -0700
In-Reply-To: <20220506035519.50908-12-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
         <20220506035519.50908-12-jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-05-05 at 20:55 -0700, James Smart wrote:
> NVME I/O problems may be seen on IOMMU enabled platforms. Adapter
> I/O's
> failing with transfer length mismatches.
> 
> The sg list processing routine for nvme I/O is accessing the sg entry
> directly for the length and address fields. On some iommu platforms,
> contigous mappings are compressed to the first sg entry with the sum
> of the lengths set to the sg entry dma_length field. The length
> fields
> are left for later use by the unmap call. As such, the driver didn't
> see
> the actual dma_length value, just the first entries length value.
> Drivers are to use the sg_dma_length and sg_dma_address macros to
> reference the sg entry. The macros select the proper length field
> (dma_length or length) to reference.
> 
> Fix the offending code to use the sg_dma_xxx macros.
> 
> Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c
> b/drivers/scsi/lpfc/lpfc_nvme.c
> index 3aebd01e07fd..5385f4de5523 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1401,8 +1401,8 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
>                                 if ((nseg - 1) == i)
>                                         bf_set(lpfc_sli4_sge_last,
> sgl, 1);
>  
> -                               physaddr = data_sg->dma_address;
> -                               dma_len = data_sg->length;
> +                               physaddr = sg_dma_address(data_sg);
> +                               dma_len = sg_dma_len(data_sg);
>                                 sgl->addr_lo = cpu_to_le32(
>                                                         
> putPaddrLow(physaddr));
>                                 sgl->addr_hi = cpu_to_le32(


