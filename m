Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA167C05027
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 18:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjCNSNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 14:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNSNm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 14:13:42 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404031CBED;
        Tue, 14 Mar 2023 11:13:37 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id ay18so10287205pfb.2;
        Tue, 14 Mar 2023 11:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678817617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shjOGf3us/BM8xDvslDFXavV6ys4MahLutw/vfYX6aM=;
        b=FHNky5FbRujLsGDqo9HBt4O9FAe386beercnMTVbIbgVw8TAGKzMooYdNsU1sCRRxS
         JXWlvwjZa3hNDGNlsDLscuQVboTSb5BbIHsUYCyZEqsMT5W5nt78Hi2Syv1TLNqhO3+w
         UdqDfr2oOGnYK9nBspmt6nPBQ1Z12JLFP2+j+9VppMtP0BjyovCC9mTiw4YT1nKJydgB
         /olW/5eJrHmVn6UNMQzi//hXvbtFQHNVxhU20/dMU1dOSAn2cWP1oysui5Jt7nOEEI8s
         xwpZArnaHgLT39vTE1SbDB71B0TIs5aCrIgQj1mwaUr8XIz7UCw//lDGNJExGfIuo76r
         bjpw==
X-Gm-Message-State: AO0yUKULsB+7BMBudDJsUDZk4HqqrGft3lFGQMduG7mfA2bfN7drC5+v
        RNEhU+Sg5NoBsw6jnEGkWGg=
X-Google-Smtp-Source: AK7set/Km0QT0pAtwmzkW3cd3nztFqhRP9idHwCg5shq5E/ZsERUt/xe28cabD1HwLK76qUKkC+5cQ==
X-Received: by 2002:a62:1a4c:0:b0:623:79d9:a8e6 with SMTP id a73-20020a621a4c000000b0062379d9a8e6mr6482026pfa.19.1678817616607;
        Tue, 14 Mar 2023 11:13:36 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cdb:df66:226e:e52a? ([2620:15c:211:201:9cdb:df66:226e:e52a])
        by smtp.gmail.com with ESMTPSA id g24-20020aa78198000000b0058b927b9653sm1965634pfi.92.2023.03.14.11.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 11:13:36 -0700 (PDT)
Message-ID: <70bf37fb-bc66-d341-7c2d-bf1785ba464f@acm.org>
Date:   Tue, 14 Mar 2023 11:13:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v6] scsi: ufs: core: Add trace event for MCQ
Content-Language: en-US
To:     Ziqi Chen <quic_ziqichen@quicinc.com>, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, quic_nguyenb@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:TRACING" <linux-trace-kernel@vger.kernel.org>
References: <1678792580-3178-1-git-send-email-quic_ziqichen@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1678792580-3178-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/14/23 04:15, Ziqi Chen wrote:
>   	TP_printk(
> -		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x",
> -		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
> -		__entry->tag, __entry->doorbell, __entry->transfer_len,
> -		__entry->intr, __entry->lba, (u32)__entry->opcode,
> -		str_opcode(__entry->opcode), (u32)__entry->group_id
> +		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
> +		 show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
> +		 __entry->tag, __entry->doorbell, __entry->transfer_len, __entry->intr,
> +		 __entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
> +		 (u32)__entry->group_id, __entry->hwq_id

The alignment of the TP_printk() arguments looks odd. Please make sure 
that arguments 2 and later start in the same column as the opening 
double quote (") instead of one column to the right of that double quote.

Thanks,

Bart.

