Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24944C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 00:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A4E64ECF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 00:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhBSAXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 19:23:18 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37803 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhBSAXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 19:23:14 -0500
Received: by mail-pf1-f179.google.com with SMTP id b145so2659750pfb.4;
        Thu, 18 Feb 2021 16:22:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fhtP97i5BTlzs7oWtg22H1k26YH/Kjx2PLZ7YFLoAaU=;
        b=o94JpXCI9/PZ8AELG6D4c542j4XjPJE3tRFcOzn98jH6ADPULWy0BxzDiwyJPlqgGc
         eEFrtYma1Clk1nsV5XNN9sVtfT9W0CHiTQnptFbPWmrGNcaW9faiXxWI5JbYiS8YBLGW
         tljIPv1iZDDaIx8+eA82uXl5I8af3RJDye5GQjP6kzd59ZYjXpb8CA0MJQnyI4P62rEx
         JPZSDi5e60ZyEgQizzRr/yTjfIg8Ob1Xw32RE6lBrugcizJZJsGSPbV8aWF9vOZ+Psrt
         hAz6r5TP6g2fAd4mrq31fNB0Fsu/1ZtIaY0tme3zLB7rPDJwNlIPjVs2xc73Vh+1+Epi
         tj7w==
X-Gm-Message-State: AOAM532Futea4aZBN+duFZKfo2Z5fnKtARN3SayUuEI7RkQpu0YEURYN
        ERPpfaWOw+vGLvS3Ll0bV1yCrruhQ78=
X-Google-Smtp-Source: ABdhPJy2kAXGH26DluN3n5CL0K5sSrbLh+oQ/28STPilrF/fDBDf1/JKchHrmI2zv70DDjC/hcsjeA==
X-Received: by 2002:a62:29c4:0:b029:1ec:f930:f5f2 with SMTP id p187-20020a6229c40000b02901ecf930f5f2mr6677885pfp.4.1613694153193;
        Thu, 18 Feb 2021 16:22:33 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u31sm7350816pgl.9.2021.02.18.16.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 16:22:32 -0800 (PST)
Subject: Re: [PATCH 05/25] srpt: Convert to new submission API
To:     Mike Christie <michael.christie@oracle.com>, bostroesser@gmail.com,
        mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-6-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5de66bb7-d45f-a59a-2a05-af3711469be6@acm.org>
Date:   Thu, 18 Feb 2021 16:22:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/21 12:27 PM, Mike Christie wrote:
> target_submit_cmd_map_sgls is being removed, so convert srpt to
> the new submission API.
> 
> srpt uses target_stop_session to sync session shutdown with lio core,
> so we use target_init_cmd/target_submit_prep/target_submit, because
> target_init_cmd will detect the target_stop_session call and return
> an error.


Reviewed-by: Bart Van Assche <bvanassche@acm.org>
