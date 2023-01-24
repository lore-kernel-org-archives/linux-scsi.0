Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A6FC25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 15:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbjAXPXq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 10:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbjAXPXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 10:23:43 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCD34A1E1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 07:23:41 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso18912792pjg.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 07:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/97CwpnO96t1RAxTarmy9oareVcs5VTJLSu/Mly5WU=;
        b=jUFssXpczg2Y16GaWj2052BM23VfTJmMkxqhtspg8ullZNJnSQnkKQfvZuvU/qwDjz
         rGHTIF+vi+DT70mTJmJVhpljN85tot9R8Y4jRHEEqyYT0NYyPdZPz6x5cXB4x4KPh786
         dUIf52Y2LmZimRTYDGN8u4ndJI+vdg9glLvOUObj37CBh8cTNM4nOkz8FPjVqdK8TVat
         Mtk/iuzTm0VY/6x7HONCbIZIhe6qqSaM/N+bVGiiH9/Kz8AU0I2c5hkVJudNsZiu1fMi
         M9UK3GLB3qGEsOVSQiPOy/Ir6Bn+FYZEcNW10C6zCG50CdfMuXolxm3lAvvE6qRpVWz+
         nY/g==
X-Gm-Message-State: AFqh2kpvlEJvwRYdix1hCa8vTUZGPuPQUDOIKbxOBwb1J/9m8B/L4EuD
        yUGZPRv3RqyU39JxOLzcCks=
X-Google-Smtp-Source: AMrXdXtPIvkvgrbmUJtmDlJbv+hzmDvseJONKnmBxONm60ZiO2ExP2t1NO4kF/iG0vaXoKoH6kgjmg==
X-Received: by 2002:a17:903:22c1:b0:194:a662:259 with SMTP id y1-20020a17090322c100b00194a6620259mr36408201plg.63.1674573821031;
        Tue, 24 Jan 2023 07:23:41 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902690400b001894198d0ebsm1821998plk.24.2023.01.24.07.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 07:23:40 -0800 (PST)
Message-ID: <e84388f4-4e33-d7a7-a121-a02dfd9038a5@acm.org>
Date:   Tue, 24 Jan 2023 07:23:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
Content-Language: en-US
To:     mwilck@suse.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20230124143025.3464-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124143025.3464-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 06:30, mwilck@suse.com wrote:
> +/**
> + * scsi_device_put_nosleep  -  release a reference to a scsi_device
> + * @sdev:	device to release a reference on.
> + *
> + * Description: Release a reference to the scsi_device and decrements the use
> + * count of the underlying LLDD module. This function may only be called from
> + * a call context where it is certain that the reference dropped is not the
> + * last one.
> + */

The above comment does not cover the call from scsi_device_put(). That 
could be addressed by adding the following text at the end of the above 
comment: " or from a context in which it is allowed to sleep". However, 
if that text would be added the function name 
("scsi_device_put_nosleep()") would become confusing. How about 
open-coding scsi_device_put_nosleep() in scsi_device_put() to prevent 
this confusion?

Thanks,

Bart.
