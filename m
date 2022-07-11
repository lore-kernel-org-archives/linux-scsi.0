Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FAECCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 11:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiGKLPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiGKLOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 07:14:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FF02A97C;
        Mon, 11 Jul 2022 03:33:11 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r6so5658957edd.7;
        Mon, 11 Jul 2022 03:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1GCJehKMVh67LFeD1JnTYbzHuUl8KoAUJZ/LzXJ26d0=;
        b=ezSLHI21rnDOf0gnSHju5x9ydDMgzLfsiw5DpchykFJtSf1zg859tEl87UigYRrpYn
         ZDMFKpUNhsvXI3WAp/wEYjaxNAy5CxjX9pWzX9Q2wNXNk+22LxWsCkbaVJIE2n862ZIY
         eAs76eDhto8Ps0vwZ5oQrqtBk9jutXV4ZpdniAaBAq7dtjz7igxOr2hkBbjxuy+f/q03
         bYY7jG5v0BdHdlZMxFvhEW6B1sSKMXkAtCDsnedgJQSbMZuljV5I5dfq5F81Hs5yQNSu
         TEFCRPA94t/y06OdEXkwmteL8K2sFMK68hrngRCmA+kmovbyo2/WzpIvuxRHlNdpX3Lk
         wjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1GCJehKMVh67LFeD1JnTYbzHuUl8KoAUJZ/LzXJ26d0=;
        b=Ecn4L8JTslD9F5FGNwGLt8ZZpcrvfPbe37Hcr5d5FQRmNGUDGa/UBDDLoFeEevHgoJ
         LVApAD1m1GpBow88qYaI5tRH293dspHtsfPPCr23XFnhbtyKzp9epZeILCdowaMIUvrH
         QkvZ8PtNXBpQvHH3t2JQS3eo5RikChlZ9lei5hyeY2D2UDyvGAj+P/3ywpRAMqkNr0r+
         drkdansB7WtL7BDQFuI0BXc2hXWGnH7mkCIw/T0B1a9iqmFejG/cpptBWFEAlArOxD4l
         JjazBs3lnmoUHSDetJWN/Q+tfyFLr4UGGSbNNnBs+WNWlWMtKEQ2oI5Hw9JQcnk9Lg1M
         +ehw==
X-Gm-Message-State: AJIora9BQ2mIhAtY8AwTaVzBbbwLh1v8F7VXfmhWs8PfO/MXIOkMbgXW
        9B4A2wotlUgeN5HBSo/Kegk=
X-Google-Smtp-Source: AGRyM1s6+Z13KkuvP1kPMUSDsXTLqE/MY6y4RykdDsAFF2MxE1/eGqojVLeQpSEa4bhD2Ov0IF00xQ==
X-Received: by 2002:aa7:dcc2:0:b0:43a:b180:bb12 with SMTP id w2-20020aa7dcc2000000b0043ab180bb12mr20413389edu.119.1657535590452;
        Mon, 11 Jul 2022 03:33:10 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1d9fa.dynamic.kabel-deutschland.de. [188.193.217.250])
        by smtp.gmail.com with ESMTPSA id gz16-20020a170907a05000b00722e203633esm2525614ejc.122.2022.07.11.03.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 03:33:09 -0700 (PDT)
Message-ID: <bc4d910a-216a-76ea-4141-3d7562db7d8c@gmail.com>
Date:   Mon, 11 Jul 2022 12:33:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] scsi: target: tcmu: check cmd aborted earlier
Content-Language: en-US
To:     Guixin Liu <kanie@linux.alibaba.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1657251175-116098-1-git-send-email-kanie@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <1657251175-116098-1-git-send-email-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Liu,

to be honest I don't like this change.

Why do we check CMD_T_ABORTED here? It's just because a concurrently
incoming TMR might already have aborted the cmd, and we don't want to
queue up aborted cmds in tcmu.

But that means, we better check CMD_T_ABORTED after taking cmdr_lock,
because we might sleep a while waiting for the lock, which opens a
possibly long time frame for new TMRs.

So, I'd prefer to have the overhead of alloc/free over not catching
aborted cmds, which causes even more overhead.
  
Bodo

On 08.07.22 05:32, Guixin Liu wrote:
> Lift the check of cmd aborted to the head of tcmu_queue_cmd(), which
> avoids pointless tcmu_cmd allocation if the cmd is already aborted.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 3deaeec..c1c1d2f 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1204,16 +1204,18 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	struct se_device *se_dev = se_cmd->se_dev;
>   	struct tcmu_dev *udev = TCMU_DEV(se_dev);
>   	struct tcmu_cmd *tcmu_cmd;
> -	sense_reason_t scsi_ret = TCM_CHECK_CONDITION_ABORT_CMD;
> -	int ret = -1;
> +	sense_reason_t scsi_ret;
> +	int ret;
> +
> +	if (se_cmd->transport_state & CMD_T_ABORTED)
> +		return TCM_CHECK_CONDITION_ABORT_CMD;
>   
>   	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
>   	if (!tcmu_cmd)
>   		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>   
>   	mutex_lock(&udev->cmdr_lock);
> -	if (!(se_cmd->transport_state & CMD_T_ABORTED))
> -		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
> +	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
>   	if (ret < 0)
>   		tcmu_free_cmd(tcmu_cmd);
>   	else
