Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF66C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 23:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCFXlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 18:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjCFXlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 18:41:13 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE974FA93
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 15:41:07 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so14827466pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 15:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678146066;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvucD3FPPzAJ/aSPL2/W9Hj5N0HRrc+dCrfCXMqZo74=;
        b=7pmFHyl/x0eJwSBG1wiUn17P2HXKMtWS6nn4sWSZJcIk0dwSRTjPx5VhM7Yt+tuFR+
         kQFY+A2wVIOR3Ipz5x46MfqgHxusmjTl4dBQigqVrMu2Moe7j2GXGAy+hz6UZ60LUrBm
         jW/kkYowO2YQZsdMGGpK+JqBCXouZ8SFzqEzCm7Vw62EjHX6jliv59NgqT5uFzeRy3a7
         vESc9WdjLqT6r+EbKgRk6s4kR1Ou+LrgiL4NcvTJtQWKUOR/V34nfCNVZp+SOuUl6aUg
         n6piozqXt0HByvG1Buxx0w+0NE2RfDcrpXuKC0zqg7xLGSaLmR3On2pmWXeQqflUzgGu
         87nQ==
X-Gm-Message-State: AO0yUKX7uOKj8nE0w08bGKT5xz3pxCdrXTnfWKHqc5QnGXhyWNswFWfo
        M99murQkzqyAax3jlaBethg=
X-Google-Smtp-Source: AK7set8bQoSMkKX03lYVSgMd2kfksLkY6q3YswS7CCkhKTvVT8g7tjGQTVo818JSQ/bVSADduFxDhQ==
X-Received: by 2002:a17:902:ebd2:b0:19a:96ea:3850 with SMTP id p18-20020a170902ebd200b0019a96ea3850mr11195743plg.17.1678146065390;
        Mon, 06 Mar 2023 15:41:05 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id lh6-20020a170903290600b00198e7d97171sm7176535plb.128.2023.03.06.15.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 15:41:04 -0800 (PST)
Message-ID: <23461135-a35c-1705-dd5f-90b16f75fa1b@acm.org>
Date:   Mon, 6 Mar 2023 15:41:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-3-bvanassche@acm.org>
 <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com>
 <d8503629-3151-b408-a298-9583ec71a099@acm.org>
 <59da25c2-a903-d004-ba23-712df9259f5e@oracle.com>
 <d438393a-4047-40e7-c6fc-15ba6631973c@acm.org>
 <0b74e472-f743-bcc2-48ed-3e564a6c0714@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0b74e472-f743-bcc2-48ed-3e564a6c0714@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 15:34, Finn Thain wrote:
> Would it alter the driver .o files? If not, the changes won't require
> actual testing.

Hi Finn,

My understanding is that declaring a static data structure const may 
move it to another section in the .o file but otherwise that the .o file 
should not be affected. I agree that retesting shouldn't be necessary 
for patches that only involve making data structures const.

Thanks,

Bart.

