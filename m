Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5179C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 29 May 2022 23:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiE2XEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 19:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiE2XEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 19:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C94F31370
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 16:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653865442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QfA6UHdmD6AfDXf89CPlsdUhs1JGy6QuSQscvfoYwvU=;
        b=VJFKs/KG8b6/SiOCOF+AgrVd86VGoq2uBoKZMdEAm+1y30eiAXURr7IBAt+itLfvxhtMkU
        Rp09cP0hy83DvCoTkcdz8WlxdIpmc2InCLRkhgcd6RnhPZOGFmNZWfee1U54BfDA5Uog3A
        t9W4QfBw4DZBTvNRa0kNpWu/eOf6n1I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-3L_bWk3yNb-avLnUQunGng-1; Sun, 29 May 2022 19:04:00 -0400
X-MC-Unique: 3L_bWk3yNb-avLnUQunGng-1
Received: by mail-wm1-f71.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so6051792wmj.0
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 16:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfA6UHdmD6AfDXf89CPlsdUhs1JGy6QuSQscvfoYwvU=;
        b=VhWcSN83K+IqrG79HS13e8V9ShH6vqaaa6/jFZQao7u3hlbj91nozeO7B6REAlK6e3
         wgwzD/ncEUD+tcPaYaGMceG542JDP4OsuBmEoGKG3oAzIalto+axaLzApYE6sh5XnvMV
         swbANGbN6oXcB0WnN9cWYVGBsDClGC3qKnop2IUppFs/E1zljrZ+NBI2OWZ2m9B3CAkU
         o9eyQQEVSEhyWQpuV586iBPdpnqryvuXK4gExVrXYsNtRgAv1uZPcD0huSiGb/B6mL5L
         YjGPiO4KbyFr9zenQ6wX4M1+XmPia6nJaIkJWbacxvRaH9IjGCeZHNsNx8fte+TzqZZ2
         Yozw==
X-Gm-Message-State: AOAM531bzscZO3U5jBvMchJF4jwK7EuTkLd+dxOiJ1KUZxZbrVxBjCcs
        Ad46jYO4bPOZdnapJKYug1qOdBom3nemCryvYssOhH9nhelS2/AMM22sBye7AbfsfevCVicyT55
        nXhupLQd5AJPd10my5TOm9w==
X-Received: by 2002:a05:600c:c5:b0:39c:1396:b489 with SMTP id u5-20020a05600c00c500b0039c1396b489mr399592wmm.146.1653865438996;
        Sun, 29 May 2022 16:03:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqRZXyAmmQh2eZzD7j1relm4FzT2zt1M4JHI7qlma3IXTujk/tbky1ZdtkzPHV4VR3uBskNw==
X-Received: by 2002:a05:600c:c5:b0:39c:1396:b489 with SMTP id u5-20020a05600c00c500b0039c1396b489mr399590wmm.146.1653865438794;
        Sun, 29 May 2022 16:03:58 -0700 (PDT)
Received: from [192.168.0.106] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id ay5-20020a05600c1e0500b0039765a7add4sm8701735wmb.29.2022.05.29.16.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 16:03:57 -0700 (PDT)
Message-ID: <2004629b-4da6-8499-ea3f-709468178b42@redhat.com>
Date:   Mon, 30 May 2022 01:03:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mpi3mr: rework mrioc->bsg_device model to fix up smatch
 warnings
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220526170157.58274-1-sumit.saxena@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <20220526170157.58274-1-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/26/22 19:01, Sumit Saxena wrote:
> During driver unload, "mrioc->bsg_device" reference count becomes negative.
> Also, as reported in [1], driver's bsg_device model had few more 
> bugs so reworked it to fix up them.
>
> [1] https://marc.info/?l=linux-scsi&m=165183971411991&w=2
>
> Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

I've been seeing the issue when rmmod the driver, with this patch it's gone.

Tested-by: Tomas Henzl <thenzl@redhat.com>

