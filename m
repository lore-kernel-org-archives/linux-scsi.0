Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1B0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 12:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355682AbiCPM1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355724AbiCPM1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 08:27:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6876623F;
        Wed, 16 Mar 2022 05:25:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hw13so3751527ejc.9;
        Wed, 16 Mar 2022 05:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IL+GLk+OUHvkfZNfzFD5nXZpkwjDg38KEStHONm2HfY=;
        b=bpfq7c2ayOhmebfs4QzVOR+k87zxLgYcOBsl03zn0j2Yu9ppFmOOR3jKSk3zaatFuM
         ppOt1hcKVekWuvVcYKEfcxw7EcwBOKUjk95tNeajuY/8SqhVB0+liYeqyqfidpQa5YdP
         SMuEH2alky1xJb1PRbmFzcNTTLbZWuUZTK+PlIg1pEMTTY3hMsyZllq5qPYrT9caZXdF
         YL4d4pQ6c6Mq3/TmBxCEgCeA+WIu2kHJRFg4QyElBu5dZTbnSjWXjYWD93o2XZk+lLp+
         jRM2uMh4CkJsvXSwB4ViOKmiDLHLSNZuNO6CEZ15iUqL8CkT3H+SrFUl6Z7dnVcOubY5
         43DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IL+GLk+OUHvkfZNfzFD5nXZpkwjDg38KEStHONm2HfY=;
        b=NiSqaLXAfxHzAC/Vtcj+/jG3/1YelQ6EYwStT7ZdtZqWyK4AeQmTcd2JQj+SpW4CZ7
         ySVdO0KdSWEhdcJuWIwLN209fSTqPUGpGVYYRUuePampZ07JcuE9klivPV3O/CZ8AMnl
         Hzu2u83QmjVzoqWinSzQfAbl8IWaD8uJmrAt8OCGspIqvFEnQIzwHbZowK2AWDPC2BhL
         +GaHa6vwjj3L0HO1DNh15Cm38nutu/DNh9RYBcsHERWcQyyDYK/6jMAbUGP8gOlloYmW
         GXD9Ld6s/Bn2MOcPYJ3rhPZA9E/AroxLOCHjS3f26jEX+TkCmkFiNrOYu5HK3Y3sYjyq
         Zxaw==
X-Gm-Message-State: AOAM532KvlzqgA6CfBrE8f55856OqqcIPvzhqqj2hUfHFhLIN7kLAkoB
        yUFRbkURwJNZvbAo40RaI+aKsvfacUw=
X-Google-Smtp-Source: ABdhPJyEoNPzFlAyrABADipYXBRvhoyYbYZ2LiVPF0/ZJuff4OAltucAaTyqW6AVdUba7ZRGi8qvyg==
X-Received: by 2002:a17:906:2ad5:b0:6cf:9cca:d9db with SMTP id m21-20020a1709062ad500b006cf9ccad9dbmr26103912eje.252.1647433531881;
        Wed, 16 Mar 2022 05:25:31 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1fa42.dynamic.kabel-deutschland.de. [188.193.250.66])
        by smtp.gmail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm905328edb.47.2022.03.16.05.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 05:25:31 -0700 (PDT)
Message-ID: <85bf5adb-631c-d98b-f2e7-d599ca065640@gmail.com>
Date:   Wed, 16 Mar 2022 13:25:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi:target:tcmu: make sure dev blocked before resetting
 ring
Content-Language: en-US
To:     Guixin Liu <kanie@linux.alibaba.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1647417702-129883-1-git-send-email-kanie@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <1647417702-129883-1-git-send-email-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I don't think we need any fix here.

1) Generally userspace can easily violate the ring protocol.
E.g., if userspace uses a currently not existing cmd_id in a cmd
response, it forces tcmu into RING_BROKEN state.
Resetting the ring while processing cmds is just another way to
probably force tcmu into RING_BROKEN.
Why should we try to fix just this one single situation?
If userspace resets the ring, and after that continues to write
responses to the ring for cmds it has read before the reset, we
probably have to fix userspace app.

2) Resetting the ring without being blocked is _not_ forbidden.
The situation you describe is more about resetting the ring while
userspace holds the uio dev open. But even that is not useless, if
userspace just stops to process cmds, resets the ring and then
re-starts processing the ring, including to read the new head and
tail pointers.

Bodo


On 16.03.22 09:01, Guixin Liu wrote:
> If dev is not blocked when resetting ring, then there could be new
> commands coming in after resetting ring, this will make cmd ring broken,
> because tcmu can not find tcmu_cmd when tcmu-runner handled these
> newcome commands.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 7b2a89a..548ad94 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2333,7 +2333,7 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
>   	mutex_unlock(&udev->cmdr_lock);
>   }
>   
> -static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
> +static int tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>   {
>   	struct tcmu_mailbox *mb;
>   	struct tcmu_cmd *cmd;
> @@ -2341,6 +2341,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>   
>   	mutex_lock(&udev->cmdr_lock);
>   
> +	if (!test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags)) {
> +		pr_err("The dev should be blocked before resetting ring.\n");
> +		mutex_unlock(&udev->cmdr_lock);
> +		return -EINVAL;
> +	}
> +
>   	xa_for_each(&udev->commands, i, cmd) {
>   		pr_debug("removing cmd %u on dev %s from ring %s\n",
>   			 cmd->cmd_id, udev->name,
> @@ -2396,6 +2402,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>   	run_qfull_queue(udev, false);
>   
>   	mutex_unlock(&udev->cmdr_lock);
> +	return 0;
>   }
>   
>   enum {
> @@ -2995,7 +3002,10 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
>   		return -EINVAL;
>   	}
>   
> -	tcmu_reset_ring(udev, val);
> +	ret = tcmu_reset_ring(udev, val);
> +	if (ret < 0)
> +		return ret;
> +
>   	return count;
>   }
>   CONFIGFS_ATTR_WO(tcmu_, reset_ring);
