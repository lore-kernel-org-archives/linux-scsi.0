Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BF6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 18:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347417AbiDRSm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 14:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiDRSm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 14:42:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E7165A9;
        Mon, 18 Apr 2022 11:40:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lc2so28346311ejb.12;
        Mon, 18 Apr 2022 11:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vSMD5tZaQY3VxVrqnvWTg6ERREdi/3N3yoNkf/fiGwk=;
        b=AuVu10OK2iVJMn+A5X128j7vyLDMUbtjEgBXYjqXi84QJi6aOhLr2xa8diVl2AWRNx
         O/alJT5lPH6NS1nGBNQ8eLnGRlLjwZXiuuuVLJsbNj8XV1VBW3btSEoue9QMDzz4qkov
         wQyAYWB7D/Mlh1KlXJq3VbTMQmHOWtp/d1DGOE1GHRg8Po9GMTgPLU8L6GcGOJd0iN/h
         LXwlvsqX0z9bVbyZYxCDnP2qIDJdiS7Jd9IdcpSAUrpZikuLJNn2FQFbzX+nYt2bVg8N
         E8x43kp5ALuJNdV4JD2Z/gk2F1Xl3OITZuOcRb+npPWWgNOZgz3PF9WwrTEF8W006Vns
         g+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vSMD5tZaQY3VxVrqnvWTg6ERREdi/3N3yoNkf/fiGwk=;
        b=dFFjcABN+KvvUciDf1AiQaMb2hz0h8ckT9Ij7Za3bU4I0iBPGu8HlzleZpW7Q5Drs8
         dO1wS7MYqsKlQLVoOO69AA1pkOtbRO3gFYchRTe1B7XVbDqizLC4q1du+JbZA55NJwsY
         cl827fY7xFp80CWXIA3VPn5JzQj27qpMwedHEFfZVlzNW3IMk0ECsQ0F8oavSB45mJCR
         buJbc2l69lew7lVOOjRmlePoWv5uM74GtmHJb613PCRvwClDFKv/X6j8ddsrzJ11lEDO
         AL4uxKHPnovZlgVgbcDrMiwF5/bjn2+sMPNOY4rSPkEO3XrCogXsz7B0W1XhAKNXGspW
         JN1Q==
X-Gm-Message-State: AOAM532yAf8qrQK3MQ0/BQKOcvXvPFti4rEbQ2okVMP/wOSXXvRb8Fje
        R9PkWsSf7k1ILO0CU87pExfq9k+Oxxg=
X-Google-Smtp-Source: ABdhPJxzxb7vPsOwaDOgJoXth65vpTEOaoQRsQ/xMLYNQ/FXIeP7VKMyzVaN3l+uQ4WHMGZJcAFVjQ==
X-Received: by 2002:a17:907:980a:b0:6db:799c:cb44 with SMTP id ji10-20020a170907980a00b006db799ccb44mr10063369ejc.485.1650307216042;
        Mon, 18 Apr 2022 11:40:16 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm4835316ejc.25.2022.04.18.11.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 11:40:15 -0700 (PDT)
Message-ID: <5015edcc-0b62-4c1f-d4f4-ec0d7a1470d7@gmail.com>
Date:   Mon, 18 Apr 2022 20:40:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220417052604.120942-1-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220417052604.120942-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

just some remarks regarding the new comment.

Bodo

On 17.04.22 07:26, Xiaoguang Wang wrote:

... snip ...

>   static const struct vm_operations_struct tcmu_vm_ops = {
> @@ -3205,12 +3228,19 @@ static void find_free_blocks(void)
>   			udev->dbi_max = block;
>   		}
>   
> +		/*
> +		 * Release the block pages.
> +		 * Also note that since tcmu_vma_fault() gets one extra page
> +		 * refcount, tcmu_blocks_release() won't free pages if pages
> +		 * are in page fault procedure, which means it's safe to

s/in page fault procedure/mapped/

> +		 * call tcmu_blocks_release() before unmap_mapping_range().

"... before unmap_mapping_range(), which drops the refcount of pages it
unmaps and thus releases those pages."

Please feel free to find an even better wording.

> +		 */
> +		pages_freed = tcmu_blocks_release(udev, start, end - 1);
> +
>   		/* Here will truncate the data area from off */
>   		off = udev->data_off + (loff_t)start * udev->data_blk_size;
>   		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>   
> -		/* Release the block pages */
> -		pages_freed = tcmu_blocks_release(udev, start, end - 1);
>   		mutex_unlock(&udev->cmdr_lock);
>   
>   		total_pages_freed += pages_freed;
