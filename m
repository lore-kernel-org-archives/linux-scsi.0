Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53268C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2739961028
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhEXBdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 21:33:39 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:40599 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhEXBdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 21:33:39 -0400
Received: by mail-pl1-f178.google.com with SMTP id n8so8585730plf.7;
        Sun, 23 May 2021 18:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/iD3hUpPGd4ZOnzXl6gABzu1r0gr7/yG9XxFyjXRrGE=;
        b=A5oHjlCGtcdQoeBlrD7L9ZjrWrIfQtOvmI0/G2q6TczZNTBKG3Tc7aQac174lyILTn
         Ua/KyotJUFTjJ7ux/HO1apUzBq8LLT0MTsmBYLFuzisXjKraKaQtGplYuY3Q5IaJPuGp
         qK74xcJakaOewXaTKwObumzT5H6vMXKRWayhNhyxRjK79STujPDwD3exvlF2X62KNewV
         NrarE63c/l549ILzBYNpYXohRv+c+dsJnxJkvd19pvsLsltrmZ7BWoZJJyUBgUh4WzHK
         eNYD35T1bdhLBHjFVfgQvGejwSh+GA0lYvq52OVaL0jio0MaFFQd0FGWrTWSUKP0meuL
         ub6g==
X-Gm-Message-State: AOAM530iMpRbygkeVZHYmpFDLdD7AVbYYEsvsty+jIUp7uFLabcQlldd
        HaoCF57H9LmCZzDbabjGLVVBIBrIFE8=
X-Google-Smtp-Source: ABdhPJzOiFJTvw6ceC3bwVQrG2Qslzo/Gc4RIey+SJg8v70Y5/gsm8S3o6hNf4Aie39B9G/K1HOkrw==
X-Received: by 2002:a17:90a:e09:: with SMTP id v9mr21766970pje.202.1621819931489;
        Sun, 23 May 2021 18:32:11 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 24sm9701733pgz.77.2021.05.23.18.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 18:32:10 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Let command trace only for the cmd !=
 null case
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210523211409.210304-1-huobean@gmail.com>
 <20210523211409.210304-3-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1d06cc01-a642-e8e0-a251-1b392e4935c7@acm.org>
Date:   Sun, 23 May 2021 18:32:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210523211409.210304-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 2:14 PM, Bean Huo wrote:
> +	opcode = cmd->cmnd[0];
> +	if ((opcode == READ_10) || (opcode == WRITE_10)) {
> +		/*
> +		 * Currently we only fully trace read(10) and write(10)
> +		 * commands
> +		 */
> +		if (cmd->request && cmd->request->bio)
> +			lba = cmd->request->bio->bi_iter.bi_sector;

Why does the lba assignment occur inside the if-statement for the
READ_10 and WRITE_10 cases? Has it been considered to move that
assignment before this if-statement?

Does 'lba' represent an offset in units of 512 bytes (sector_t) or an
LBA (logical block address)? In the former case, please rename the
variable 'lba' into 'sector' or 'start_sector'. In the latter case,
please use sectors_to_logical().

Why are READ_16 and WRITE_16 ignored?

Please remove the 'if (cmd->request)' checks since these are not necessary.

> +	} else if (opcode == UNMAP) {
> +		if (cmd->request) {
> +			lba = scsi_get_lba(cmd);
> +			transfer_len = blk_rq_bytes(cmd->request);
>  		}
>  	}

The name of the variable 'transfer_len' is wrong since blk_rq_bytes()
returns the number of bytes affected on the storage medium instead of
the number of bytes transferred from the host to the storage controller.

>  /**
> - * Describes the ufs rpmb wlun.
> - * Used only to send uac.
> + * Describes the ufs rpmb wlun. Used only to send uac.
>   */

Is this change related to the rest of this patch?

Thanks,

Bart.
