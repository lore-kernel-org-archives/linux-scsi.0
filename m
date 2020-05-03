Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964A9C28CBC
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 14:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7DA20836
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 14:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GpzPA3Xl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgECOmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgECOmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 10:42:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78099C061A0E
        for <linux-scsi@vger.kernel.org>; Sun,  3 May 2020 07:42:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l25so4946713pgc.5
        for <linux-scsi@vger.kernel.org>; Sun, 03 May 2020 07:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5kF7tOB8NIP61SrpOZNQ+9pKtsEJhMKDr//+OJNXUhs=;
        b=GpzPA3XlurS74coUQ8ZY24hfJUgOk468ZKqNWqThv24neHF9lDrn+DR08yD54Lnpww
         tTCvtqVJ5ZFH/PgK2+HKIn/1dIrEWDOW9oXijt5KOl1aBRuEQEeSkpDd0obp2pQMvj2w
         6iYB4Vox2HPq3WQ0FMy2AsV8v2nF4adoLITtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5kF7tOB8NIP61SrpOZNQ+9pKtsEJhMKDr//+OJNXUhs=;
        b=c1kG7QUJMiypAYRYmnZUiO6mnXsLiGpJIkumUBs3ik6Hn1mvzkUO7x+IFwsFhXsYKJ
         bHmNGNlQmTRm/X01eLUHFka/NPElXa8CbkDG6qbg8Z/9ZdRL4QtqbueJg0++lxz9J8sY
         V9qclOFxfRIMKZRMg9NrggoD7gI8OnJbOoMY4wApUkkY4eweU3UA088zJnDMTHK13yAm
         ABOkKhJWoXtHifvyGEXI8qX9O/wGP90rYnxcpNfl817lON/SRKrmiNuZ58hlbT5NoMkr
         OKW5X6OPnK8QNVXh946l+zRu0W8L0bFD6FXQsCkMqY6TrzCiXBgBePVh8VoH5jb0SJAt
         s2lQ==
X-Gm-Message-State: AGi0PubverUGOR/uRcxRjhLZiVmbgoVoZGi2KJl19xmrrQhhh5u+iohU
        qlX+I8mNxrYR2iDMWnit1DcA3oZFF7I=
X-Google-Smtp-Source: APiQypJNZ0G3nByn3nmGcsGiNsSy0/OJkNx7qy3zorpvfagTYovuVBHdvVfXxbx5sJeKX2dbUE9AYA==
X-Received: by 2002:a63:f707:: with SMTP id x7mr13647210pgh.374.1588516923817;
        Sun, 03 May 2020 07:42:03 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mj4sm4548796pjb.0.2020.05.03.07.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 07:42:03 -0700 (PDT)
Subject: Re: [PATCH 1/9] lpfc: Synchronize NVME transport and lpfc driver
 devloss_tmo
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
 <20200501214310.91713-2-jsmart2021@gmail.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <3d45f9aa-c9f0-693d-c040-ffd7c75effe4@broadcom.com>
Date:   Sun, 3 May 2020 07:42:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214310.91713-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/1/2020 2:43 PM, James Smart wrote:
> The driver is not passing it's devloss tmo to the nvme-fc transport when
> registering the remote port. Thus devloss tmo for the nvme-fc remote port
> will be set to the transport's default. This causes driver actions to be
> out of sync with transport actions and out of sync with scsi actions for
> perhaps the same remote port.
>
> This is especially notable in the following scenario: while remote port
> is attached, devloss is changed globally for lpfc remote ports via lpfc
> sysfs parameter. lpfc ties this change in with nvme-fc transport. If the
> device disconnects long enough for devloss to expire thus the existing
> remote port is deleted, then the remote port is re-discovered, the newly
> created remote port will end up set at the transport default, not lpfc's
> value.
>
> Fix by setting devloss tmo value when registering the remote port.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 12d2b2775773..43df08aeecf1 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -2296,6 +2296,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   
>   	rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
>   	rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
> +	rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
>   
>   	spin_lock_irq(&vport->phba->hbalock);
>   	oldrport = lpfc_ndlp_get_nrport(ndlp);

Please drop this patch from this set.  Christoph is having me change a 
patch submitted to the nvme tree that will require this change and one 
other lpfc modification. Easier to manage if this patch merges via the 
nvme tree rather than the scsi tree.

-- james

