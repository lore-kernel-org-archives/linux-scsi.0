Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FA6C6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCXSZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCXSZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:25:45 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28831EBD5;
        Fri, 24 Mar 2023 11:25:43 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id dw14so1830014pfb.6;
        Fri, 24 Mar 2023 11:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679682343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LZKRMSuluRMc0e9BXO5+TDbgf6gy3EYC5wrIH/iS9UE=;
        b=HV5QonHC4o7+mVsjNglxw/oc2P888a6FRMyFTfvR2zqi9SZ0DRzPH9er7RNI6+hIt5
         M2kLxorozulqTuDPPCPjDEzph9bF2wX4UrnpTu3SO5fCbNs/qCBNGhA51+xPPNNdh84w
         WbZ+kmVm+XZgmJdp6BJnNtsqsOqioxhXEUfavK4yy3tJ+Ma78wEZ13Cbx/9vuvItw8Sw
         Ce2wnmfER+qmqjVRbmggy3ShuIlPIeq+0H6Xx+48SLrhJi6tpMyTDcoAhC9WBZR3hGuW
         OYxiHFjAChncGVz1R2MXVpjk3UocZlaKvTffVWam2y8uoTOT8cqaJqVSGa6xq6fSu5d3
         Eqqw==
X-Gm-Message-State: AO0yUKUHrmqYiafBTNdNofe/1/Ioc0ecU+Hd1owGzMPOxxFnSBbclTQa
        gFXZLtG5uFHD78pk8sDt+ps=
X-Google-Smtp-Source: AKy350ZYv1mpvYBouV9n6c8TTxMkUBO8IzS9P0gDxnwkTxznstPza4O2GaiA4I+LyvTxVupCsWuSlw==
X-Received: by 2002:aa7:9a5c:0:b0:628:1347:a619 with SMTP id x28-20020aa79a5c000000b006281347a619mr4097965pfj.10.1679682343388;
        Fri, 24 Mar 2023 11:25:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2421:e16e:b98f:7e76? ([2620:15c:211:201:2421:e16e:b98f:7e76])
        by smtp.gmail.com with ESMTPSA id v5-20020aa78085000000b006254794d5b2sm2401894pff.94.2023.03.24.11.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:25:42 -0700 (PDT)
Message-ID: <298ce171-8738-1cd6-bce6-a846fb6469af@acm.org>
Date:   Fri, 24 Mar 2023 11:25:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 04/18] scsi: Move sd_pr_type to header to share
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/23 11:17, Mike Christie wrote:
> diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
> new file mode 100644
> index 000000000000..44766d7a81d8
> --- /dev/null
> +++ b/include/scsi/scsi_block_pr.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_BLOCK_PR_H
> +#define _SCSI_BLOCK_PR_H
> +
> +#include <uapi/linux/pr.h>
> +
> +enum scsi_pr_type {
> +	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
> +	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
> +	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
> +	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
> +	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
> +	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
> +};
> +
> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> +{
> +	switch (type) {
> +	case PR_WRITE_EXCLUSIVE:
> +		return SCSI_PR_WRITE_EXCLUSIVE;
> +	case PR_EXCLUSIVE_ACCESS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS;
> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	}
> +
> +	return 0;
> +}
> +
> +#endif

Hi Mike,

Has it been considered to move enum scsi_pr_type into 
include/scsi/scsi_common.h and block_pr_type_to_scsi() into 
drivers/scsi/scsi_common.c? Other definitions that are shared between 
SCSI initiator and SCSI target code exist in these files.

Thanks,

Bart.
