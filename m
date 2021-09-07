Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AE0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D386103D
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhIGAcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 20:32:05 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:34462 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhIGAcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 20:32:05 -0400
Received: by mail-pg1-f179.google.com with SMTP id f129so8227009pgc.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Sep 2021 17:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KyaXEdZf6tsZJsZ6z5gZpGwC1GQoIBcK6etYhYbY4pA=;
        b=McgIrh0DrdDKogvEYg0nt6FtCoxz/Nl4JC2F43GTX6keQ7WJ6FwGWKjffljTEjftwM
         C/w00QuHb3j69LEptcQOWYlx97yHTIcI8qrWgO2+zEza4s1Gq9JUlLDnLgXl1cWXIxEW
         tznU5kFEI9SyTw2MHdytuIbcrrRvvrP/CCbeCOdrXRr+6a/1ypQpka6hGoOE5SWwTXh5
         sBU9TY0y62kWBrzoAJiKS0LhzLdL8xkDbQIrpqInY7b/iWs8CB5Pae1uRaTYTYC/G94q
         QC8T+D2R674lGke6aM1fsPb0SyImgWFNJH+7iF9ggiFtmhtR5JecPeTiVb5k+chEqwcD
         SK6g==
X-Gm-Message-State: AOAM533qh8xMF/Z0zKCQ/jt5xOfqu5CdAV8VKd4lC+clyDQmLo5lfCny
        zItyJvbXL8rSncIq0zy75pTrlqQqSts=
X-Google-Smtp-Source: ABdhPJwMSAKsBCNoxFMOcUvM/yHFhUOCBIC++tQdb8k7q92GkHUSps/7HXvqR2GjojV6SmpufTZHLQ==
X-Received: by 2002:a63:8c4d:: with SMTP id q13mr14431625pgn.92.1630974659329;
        Mon, 06 Sep 2021 17:30:59 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:6d38:bd0e:234b:803? ([2601:647:4000:d7:6d38:bd0e:234b:803])
        by smtp.gmail.com with UTF8SMTPSA id d3sm11067439pga.7.2021.09.06.17.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 17:30:58 -0700 (PDT)
Message-ID: <c93f3010-13c9-e07f-1458-b6b47a27057b@acm.org>
Date:   Mon, 6 Sep 2021 17:30:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] scsi: sd: free 'scsi_disk' device via put_device
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210906090112.531442-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210906090112.531442-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/21 02:01, Ming Lei wrote:
> Once the device is initialized via device_initialize(), it should be
> freed via put_device, so fix it. Meantime get the parent before adding
> device, the release handler can work as expected always.

Since we are in the middle of the merge window this is probably not the 
best time to post patches. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
