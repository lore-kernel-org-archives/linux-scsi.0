Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C927C7EE29
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 16:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbjFHQ24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbjFHQ2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 12:28:53 -0400
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925B02119
        for <linux-scsi@vger.kernel.org>; Thu,  8 Jun 2023 09:28:50 -0700 (PDT)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-33b0bfb76cfso2606925ab.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jun 2023 09:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686241729; x=1688833729;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57FUmdVNH/lzVT+bcNFGneW+WLVlTYYM9YvlzlkZXxo=;
        b=CdTHtkmLdr44qzT1vSaNfYnN8ibO9Zy2qc9vHOaE6HJ8a/vIe2mV4g41PInvnIISyu
         ORuBkuecOe8NRF5BDWcXisyCBi4Q3+BDzOTv7LEpAO5KiCP2F53jo2qHU6xJQTyHVOb+
         5JdAuEtB3As+ZMFXR1GmXirhuwKeZozqfNJcIVnfO7QdtOtE56QBQOwfL0MSoyBTD5ro
         ddm6Z8F3GZPcYT4AbfAwzgnUDB/by2AxzpE4S7vO5MpMNKHyKwR9EBtMPjHrzDgYe2/0
         R2QWN1BHc6ly9qPiU5sDSwbgKwBbybLrrIT3BTg7J7ENKNBzAOmpzPpKPX/NQGzMDx+F
         GaDg==
X-Gm-Message-State: AC+VfDyZsBu1YDeIGtRUu53yU/oxlg7Tg1cQw24rJ4R2VCrUr6dyZuAK
        bTxmfOD8wTyyXGf3a9JBdIg=
X-Google-Smtp-Source: ACHHUZ6OODtNwkes39SiMPmFuQMusAuqulr2Jdd+nCIAyRXLreWvGDTKvzCKYhITqRJYyg/WPHKntg==
X-Received: by 2002:a92:3206:0:b0:33d:3b69:2d23 with SMTP id z6-20020a923206000000b0033d3b692d23mr7960012ile.19.1686241729384;
        Thu, 08 Jun 2023 09:28:49 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id iz2-20020a170902ef8200b001aaf2172418sm1649296plb.95.2023.06.08.09.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 09:28:48 -0700 (PDT)
Message-ID: <cc269205-71cc-19a8-c83c-a908c2f2a587@acm.org>
Date:   Thu, 8 Jun 2023 09:28:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/3] ufs: poll pmc until another pa request is
 completed
Content-Language: en-US
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        sc.suh@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com,
        kwangwon.min@samsung.com, junwoo80.lee@samsung.com
References: <cover.1685927620.git.kwmad.kim@samsung.com>
 <CGME20230605012508epcas2p140e42906361b870e20b1e734e9e4df06@epcas2p1.samsung.com>
 <67ce698df39ca0c277c078dca729d7f607b9feb2.1685927620.git.kwmad.kim@samsung.com>
 <4eda6575-c124-3ca3-e772-567a7014d895@acm.org>
 <005801d999b4$38cb2260$aa616720$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <005801d999b4$38cb2260$aa616720$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/23 19:52, Kiwoong Kim wrote:
> I got it and I have one question.
> 
> The reason why I bound all the three things is
> because I thought they were tangled each other. I felt that the first patch relies
> on both the second one and the third one and the helper named __ufshcd_poll_uic_pwr
> in the third one calls ufshcd_ready_for_uic_cmd where the change of the second one is applied.
> So I thought I should care this sort of conflict in terms of the driver's working.
> Don't submitters need to care this?

Sorry but the above is not clear to me so I don't know what to answer.

As you may have noticed, the request for one change per patch is a 
common request. From Documentation/process/submitting-patches.rst: 
"Solve only one problem per patch. If your description starts to get 
long, that's a sign that you probably need to split up your patch.
See :ref:`split_changes`."

Thanks,

Bart.
