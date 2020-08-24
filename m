Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED72C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 21:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56DEF2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 21:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0ldp5eh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHXVw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 17:52:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE07AC061574;
        Mon, 24 Aug 2020 14:52:55 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so306113wmk.1;
        Mon, 24 Aug 2020 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:cc:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=fvCy+pd4+670VEadUx/STXeESbdU05FA+XcBzh8qwhM=;
        b=g0ldp5ehGRJv6TOD7Dgo5dZrK1aZ9VzHX7DEHSwb/osmS5DKVm8URMmEvAqtzClwPh
         bbEPR+jsFS6oX3cucJgdAYTLqvvI+AguH3GEBHRjjEy6oz1EscPbBeb558408DHTqys7
         HKlVT8o+fglHtwGV94F1V2GNWLj+hEPwT3VZdL1Vb1vQ6egs8MNYz7IrxWh0qt+60BeB
         AOJ4/YWtX5EXVZi74cpx9DGiV81y9jLH0nsJMCZnR8oAsrYOrMpOGoGt7breTnN66pqU
         wlss69U3QSi7Z/VJMnAFfmokP6Zh1JxPFVR8vIJPEYQpFoaMVwoEP7rEE0xPFur7x6+O
         TMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fvCy+pd4+670VEadUx/STXeESbdU05FA+XcBzh8qwhM=;
        b=EzEeAEi3KpH+9QSupUrDk6TQPSNi9xObb5du0IJ4ejWw8LtQUP4Ohl2tL/lTbYpIM2
         pGdP/i8Rh7uTewDIyLEKJiU0w9E8luR49AVtyJUESHMMShc2hJtlTwmB3+QvpFv1rSqh
         QBFS+Not/Y55koMpFR9c7MrHID59EzSY6sUNJhu1ScjLWbFfC7dHuI7kDGvd/GeR6HfZ
         J+Jv8t9Ac1yRuk1uF6HOo0Ykw7N+XPeBaX/xa2vg+Wm/Fv5DjHdpJ2pmUU2fvL3ogBIs
         Hz91zzJNtEyfJyRWAkRFjxZ2ukKyLIC1lsv455DlH7Qt5CCumNGSlbPEQr8JhwfJFIv4
         LdXQ==
X-Gm-Message-State: AOAM531NoW9BHzNQM1HbIlIVzDL8ygDwGUADX7JlKq3TQuzfMDAHyHhQ
        riFqaqr42K6J+d4nDf46eRU=
X-Google-Smtp-Source: ABdhPJy2rKadPI2zBNw4ktmc+uBMPzsdcjYrNMDw9BWJupDR16/7H7KQ8nJSvv2V5QRkFlIGlSSUQA==
X-Received: by 2002:a1c:a54e:: with SMTP id o75mr1176138wme.181.1598305974420;
        Mon, 24 Aug 2020 14:52:54 -0700 (PDT)
Received: from [192.168.0.18] (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id s8sm1571334wmc.1.2020.08.24.14.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 14:52:53 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
Cc:     GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, njavali@marvell.com
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
 <20200820234952.317313-1-alex.dewar90@gmail.com>
From:   Alex Dewar <alex.dewar90@gmail.com>
Message-ID: <8f829bd7-fb2b-44af-44ea-130b08c1fd70@gmail.com>
Date:   Mon, 24 Aug 2020 22:52:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820234952.317313-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-21 00:49, Alex Dewar wrote:
> dma_alloc_coherent() already zeroes memory, so the extra call to
> memset() is unnecessary.
>
> Issue identified with Coccinelle.
>
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Gentle ping? I've just realised that this is the one we want, not the v1 
I just replied to.
> ---
> v2: I've noticed a few other places in the scsi subsystem with this
> pattern, so lets fix them all with one patch.
> ---
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
>   drivers/scsi/mvsas/mv_init.c        | 4 ----
>   drivers/scsi/pmcraid.c              | 1 -
>   drivers/scsi/qla2xxx/qla_mbx.c      | 2 --
>   4 files changed, 8 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index b66d3f9b717f..36b6c0d67353 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5259,7 +5259,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
>   		_base_release_memory_pools(ioc);
>   		goto retry_allocation;
>   	}
> -	memset(ioc->request, 0, sz);
>   
>   	if (retry_sz)
>   		ioc_err(ioc, "request pool: dma_alloc_coherent succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kb)\n",
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 978f5283c883..6aa2697c4a15 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -246,19 +246,16 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>   				     &mvi->tx_dma, GFP_KERNEL);
>   	if (!mvi->tx)
>   		goto err_out;
> -	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
>   	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
>   					 &mvi->rx_fis_dma, GFP_KERNEL);
>   	if (!mvi->rx_fis)
>   		goto err_out;
> -	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
>   
>   	mvi->rx = dma_alloc_coherent(mvi->dev,
>   				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
>   				     &mvi->rx_dma, GFP_KERNEL);
>   	if (!mvi->rx)
>   		goto err_out;
> -	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
>   	mvi->rx[0] = cpu_to_le32(0xfff);
>   	mvi->rx_cons = 0xfff;
>   
> @@ -267,7 +264,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>   				       &mvi->slot_dma, GFP_KERNEL);
>   	if (!mvi->slot)
>   		goto err_out;
> -	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
>   
>   	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
>   				       TRASH_BUCKET_SIZE,
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index aa9ae2ae8579..d99568fdf4af 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4716,7 +4716,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
>   			return -ENOMEM;
>   		}
>   
> -		memset(pinstance->hrrq_start[i], 0, buffer_size);
>   		pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
>   		pinstance->hrrq_end[i] =
>   			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 226f1428d3e5..e00f604bbf7a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4925,8 +4925,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>   		return QLA_MEMORY_ALLOC_FAILED;
>   	}
>   
> -	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
> -
>   	/* List of Purex ELS */
>   	cmd_opcode[0] = ELS_FPIN;
>   	cmd_opcode[1] = ELS_RDP;

