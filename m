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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C48C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 21:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D53AF207D3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 21:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knIBq9oV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHXVmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVmw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 17:42:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB60DC061574;
        Mon, 24 Aug 2020 14:42:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o4so6570950wrn.0;
        Mon, 24 Aug 2020 14:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=hkARozwEXZJVRsmCa4FsWOarTsVSbx9L2pp/ThDbffw=;
        b=knIBq9oV5ZdXmHcbgn/kURoApVFwIuY5ZXEgUVupmzKeR/GzaQsx/D1AgoW9iM2AZo
         E0vOqcjTp4MrN7Dx0Q+cZFPrvDSUambr75qx592tyS+81bWVoYWeKiIdA4AU5Rlg2Rc2
         USAKOtDY+OfzBVI6oWLHFjPDzQ6lyX0uLPYfy+78kwZLlhC9PtlyT1U7Gf35G+3XkPFt
         G3VMH05l+l0OO8A7tJr1OsLbUBXexkeRXmieu+oKk1sDL4YdVk3ZmfK2YHdH6Ns0JIW7
         0/sK3VZkF5RfnfNXuyGCe18l4r4aVDmY8EGuZwKOLmOPG58hauBf8QXrsrj6HHofVZBT
         0Q/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hkARozwEXZJVRsmCa4FsWOarTsVSbx9L2pp/ThDbffw=;
        b=AcOctC1teTby5FgcmXuJ4KBOudlffVlKE2y4QR8ddqAnHIgkzbEZmWgv9GbeW/jaww
         WzBLrXqU1ElsR+tNmH9IEwPtB5FfxGcHyIWOJTaRvHZt8INqS5P2+We1sRJdNww4Emkl
         tCFyMs+NWO0XlyrfNJ5bB0PDOkxbQfQYMch0uvX9P8zXV0sYRNs5dUIIwfgJjteljSox
         KNqTW/QtZQf4wpDnPLbPt8QVReL4oinxomlm+ZdKExSOms0T5CZqv6BX7wmDzAn88vBg
         YiXbx1sAIdn3RSyKIGYBz3xA0nZBmjTdpfD9c0AFmBXXSR5hMkQH5mZ5S1ftCmdtz4FU
         wy4A==
X-Gm-Message-State: AOAM530oFKujTjTTcurIPGTI1sKggoikZF0sPmvdCOWuvZbJO4IqcrXU
        p6v5PDplneniqdeS0chXOJex9/Ugt3ytIRlf
X-Google-Smtp-Source: ABdhPJyj3e46TgMt/sLQrGzqR+7Yrt9u/xxxCUdaD7yGd+UoWdKmYEquZ5Ai38Bl4okVH5SiX6yOag==
X-Received: by 2002:adf:83c5:: with SMTP id 63mr7441486wre.321.1598305369981;
        Mon, 24 Aug 2020 14:42:49 -0700 (PDT)
Received: from [192.168.0.18] (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id b14sm26542424wrj.93.2020.08.24.14.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 14:42:49 -0700 (PDT)
Subject: Re: [PATCH] scsi: qla2xxx: Remove unnecessary call to memset
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
From:   Alex Dewar <alex.dewar90@gmail.com>
Message-ID: <c6f52893-6fa4-f5f8-42a8-9a2482f16c45@gmail.com>
Date:   Mon, 24 Aug 2020 22:42:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820185149.932178-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-20 19:51, Alex Dewar wrote:
> In qla25xx_set_els_cmds_supported(), a call is made to
> dma_alloc_coherent() followed by zeroing the memory with memset. This is
> unnecessary as dma_alloc_coherent() already zeros memory. Remove.
>
> Issue identified with Coccinelle.
>
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
Gentle ping?
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 2 --
>   1 file changed, 2 deletions(-)
>
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

