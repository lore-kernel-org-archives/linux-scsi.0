Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE402C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D492187F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfKGV3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:29:18 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44302 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGV3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 16:29:18 -0500
Received: by mail-pl1-f194.google.com with SMTP id az9so1643155plb.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 13:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIULOXNcWNILu0MY9K0Ob/k9n6KXTYAbkofGtfp/Ta4=;
        b=Z4XMqPvnI3u+zaKngzjEvcckCT7ewIWTgjsh+Mrd0xvaXpDMLZlAI/h/7P8hnRkBVR
         dfczJVkj/oHPfIOKq9ebUwHpXsguJAM1CYrf2ABLZf2m30QxM1m+LyJxz3D8F16vcCMD
         QpW1u/JcPOGNdKWVtH+fW4r8Wg8fNXaQ1nDxpwgtrnpbNOTRs8hb56vIg6RQttGqgLBZ
         9Drdu4udzK1aN1Lw84GDIPY1+RUOGHHNddLZ2+7pDYAJgwGghcGnamCy3AGqMztsHoID
         w62fOcwBGBxGd21RrZBCFowzEqN3K/Fol6He/m9IXpAYgdFCJJzJsYMhR7y59fTaou+K
         iKxw==
X-Gm-Message-State: APjAAAWN9SnuWnDwwKtq++5tm2iW6ymOdwzrvphmw/Vj4qNFDmlkZgt6
        cxffEEZdRyM3gwgucjJExZyXoMzx
X-Google-Smtp-Source: APXvYqyeajbbTROOZHyYC1fSYLlLAbDJ/l0CEddU402LXjJHblJE/iGknxKN/mbZKdSDUu8mLf9U8Q==
X-Received: by 2002:a17:90a:ca0e:: with SMTP id x14mr8231436pjt.95.1573162155359;
        Thu, 07 Nov 2019 13:29:15 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m13sm2870342pga.70.2019.11.07.13.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 13:29:14 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: qla2xxx: initialize fc4_type_priority
To:     Martin Wilck <Martin.Wilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191107164848.31837-1-martin.wilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <66aebeac-61bd-8c4e-437d-f1423ecfc901@acm.org>
Date:   Thu, 7 Nov 2019 13:29:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107164848.31837-1-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 8:49 AM, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> ha->fc4_type_priority is currently initialized only in
> qla81xx_nvram_config(). That makes it default to NVMe for other adapters.
> Fix it.
> 
> Fixes: 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port support")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 7cb7545..2a016a8 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2214,8 +2214,18 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
>   	ql_dbg(ql_dbg_init, vha, 0x0061,
>   	    "Configure NVRAM parameters...\n");
>   
> +	/* Let priority default to FCP, can be overridden by nvram_config */
> +	ha->fc4_type_priority = FC4_PRIORITY_FCP;
> +
>   	ha->isp_ops->nvram_config(vha);
>   
> +	if (ha->fc4_type_priority != FC4_PRIORITY_FCP &&
> +	    ha->fc4_type_priority != FC4_PRIORITY_NVME)
> +		ha->fc4_type_priority = FC4_PRIORITY_FCP;
> +
> +	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
> +	       ha->fc4_type_priority == FC4_PRIORITY_FCP ? "FCP" : "NVMe");
> +
>   	if (ha->flags.disable_serdes) {
>   		/* Mask HBA via NVRAM settings? */
>   		ql_log(ql_log_info, vha, 0x0077,
> @@ -8521,8 +8531,6 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>   
>   	/* Determine NVMe/FCP priority for target ports */
>   	ha->fc4_type_priority = qla2xxx_get_fc4_priority(vha);
> -	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
> -	    ha->fc4_type_priority & BIT_0 ? "FCP" : "NVMe");
>   
>   	if (rval) {
>   		ql_log(ql_log_warn, vha, 0x0076,

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
