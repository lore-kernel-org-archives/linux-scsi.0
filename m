Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFF7C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 17:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjERRrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 13:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjERRrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 13:47:16 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90CC10C9
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 10:47:15 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-25332b3915bso1937183a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 10:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684432035; x=1687024035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kxNbciM4mRemyV+sMIpt3wytbEh8UNOTKizZ6tgdukA=;
        b=SJAjD13+kS0PX5A+e+rOSsFlH5IzhxF2MoKtlM4nlJO+NAGv7ayazCNnF4+sD52gSW
         diIYEgZx2lk1UMm9nML8/tekDLmqLkVWr9YLRUOkX5Z12vxdYrh9GRD0r/rAyBIf4hMR
         Uo7JyD+VpPiu0yZ+qbvIumOJ5/O7lAkp6B18dc2uT4SWK/cRGWRurLllcqdTzYi8sre3
         4CKQpQG3FvEMF4cVeXselMl9mv9vLvdn7OLjM+bcd1GaJZoiKIjo0pLWV72IT6aa6Gtr
         DD7S5b6CQmJhcyuWAp1GOJ7qwo//4nURkQHHKVbqqzdU/WM71Qn/yxoX7f+3j8Icqz7q
         gh1g==
X-Gm-Message-State: AC+VfDwbckbesUCebD0ZE3+/vZEj/6ctnQzQMeWLFwIFp2i1J0LIGVW4
        5sDW1B70MmJyHaXFcpI+HIQw4Ce+TBg=
X-Google-Smtp-Source: ACHHUZ4vdcXNn2PJMndGRtKQsn5yWqtEZZDaR3nDmlV8bHSDk5EhvwyUcr948hOELiSkF+l+2a00/w==
X-Received: by 2002:a17:902:d486:b0:1a6:bd5c:649d with SMTP id c6-20020a170902d48600b001a6bd5c649dmr4175499plg.56.1684432035270;
        Thu, 18 May 2023 10:47:15 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e80800b001a94a497b50sm1756605plg.20.2023.05.18.10.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 10:47:14 -0700 (PDT)
Message-ID: <3f93a5d3-e227-ee1a-0ca9-07e43a1c874b@acm.org>
Date:   Thu, 18 May 2023 10:47:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 7/8] qla2xxx: klocwork - correct the index of array
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
References: <20230518075841.40363-1-njavali@marvell.com>
 <20230518075841.40363-8-njavali@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230518075841.40363-8-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/23 00:58, Nilesh Javali wrote:
> +	port_dstate_str_sz = sizeof(port_dstate_str)/sizeof(char *);

Please use ARRAY_SIZE() instead of open-coding it.

> @@ -121,7 +123,8 @@ qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
>   		    old_val, (old_val << shiftbits) | state)) {
>   			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
>   			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
> -			    fcport->port_name, port_dstate_str[old_val & mask],
> +			    fcport->port_name, ((old_val & mask) < port_dstate_str_sz) ?
> +				    port_dstate_str[old_val & mask] : "Unknown",
>   			    port_dstate_str[state], fcport->d_id.b24);

Please do not introduce more parentheses than necessary. The outer 
parentheses can be removed from the ((old_val & mask) < 
port_dstate_str_sz) expression without reducing readability.

Thanks,

Bart.

