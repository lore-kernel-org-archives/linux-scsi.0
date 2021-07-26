Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CABBC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E289860F6E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhGZT7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 15:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhGZT7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 15:59:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D20160F93;
        Mon, 26 Jul 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627332011;
        bh=jQKf1yPaVAGcaRW3GfVqbr6BTwPqbM/91QWOZPscGD8=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=AfCMCftxc1MD7k8kYQ5CgRhRTSD9DSJrDjRYeYetfbUKr+XCaRpGGA3S47ipia5Mq
         XIZFsp+lbykeBVzbKpIKdBnqmmo7Q/iaMN2tjH59qEKV5c7SA/KppcPqDO4o1quh01
         qGrs20jvwnWtLdLJ6ymF71gfFE804CmBLzzMtWWZD3oYSWKHaDZkPAk8LvsbgOWC1A
         T0SfG9db7SJHBW3Vd24GC1ObcGiakufeULKX3a1KUhPtqlrDM8F6Sv25NcTDqD8Hwg
         bcho4bZyWKQmJeR8sGSlZId7hZNlFHB3n+nTqBuI9miNL+rL5gSO28Nbe5P+pHzHcv
         6gMktnn0+TPKw==
Subject: Re: [PATCH v2 3/3] scsi: qla2xxx: remove unused variable 'status'
To:     Bill Wendling <morbo@google.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210714091747.2814370-1-morbo@google.com>
 <20210726201924.3202278-1-morbo@google.com>
 <20210726201924.3202278-4-morbo@google.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <52726cd7-48d0-4600-aac1-bc39fc60bf66@kernel.org>
Date:   Mon, 26 Jul 2021 13:40:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726201924.3202278-4-morbo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/2021 1:19 PM, 'Bill Wendling' via Clang Built Linux wrote:
> Fix the clang build warning:
> 
>    drivers/scsi/qla2xxx/qla_nx.c:2209:6: error: variable 'status' set but not used [-Werror,-Wunused-but-set-variable]
>          int status = 0;
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

It has been unused since the function's introduction in commit 
a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support.").

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>   drivers/scsi/qla2xxx/qla_nx.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 615e44af1ca6..11aad97dfca8 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -2166,7 +2166,6 @@ qla82xx_poll(int irq, void *dev_id)
>   	struct qla_hw_data *ha;
>   	struct rsp_que *rsp;
>   	struct device_reg_82xx __iomem *reg;
> -	int status = 0;
>   	uint32_t stat;
>   	uint32_t host_int = 0;
>   	uint16_t mb[8];
> @@ -2195,7 +2194,6 @@ qla82xx_poll(int irq, void *dev_id)
>   		case 0x10:
>   		case 0x11:
>   			qla82xx_mbx_completion(vha, MSW(stat));
> -			status |= MBX_INTERRUPT;
>   			break;
>   		case 0x12:
>   			mb[0] = MSW(stat);
> 
