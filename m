Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07988CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0BA20650
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 17:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJ3RBM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:01:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33507 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfJ3RBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 13:01:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so1273900plk.0;
        Wed, 30 Oct 2019 10:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Hqv8i+AR9TRYPckK/WGbIykqow54FWDwE946IIRHBc=;
        b=Tg+HHyW/HdbbU1hHcn8Jc8ICHHEvhAJbbeO5IRhr5HbUUwJfiCs7ZoHaN3q9wAW6QL
         WrIiY3O0XwpVPwV5JPciyO0y9qiYQgOucHlIdKH4Qdfi9H968eCJwN36xuW8pVjtCPPp
         sHTJEzN02swAbYP7wZYCmKdkWScxXGpQs1JwUNaoGCfRdzPJx56xYmga4ADX3XwPP7/l
         z/TPxEOa14cPUL91czvrRz324lO/Lrtlj0UOrHrIlkjF2iZEigk4WEy9W+TxcFWNo+3G
         Xnq4RHJ2cNaE41+LpY+ilyOOwbGzTMnwNEtYQ2eBp/T/lNazIWA+y5Qca5sQGtiD/1Ao
         fBZQ==
X-Gm-Message-State: APjAAAUyvdGyXGpUlakZzFcrf/kIdcvGrzz0uLvSjvsXLj/+IYbH9/FR
        ANq79ddt12dV68BL9mCGVIk=
X-Google-Smtp-Source: APXvYqwi3wv9j+EpabDZ5W82Hg7DelWl6yuFiOqNbuTSa2OtZBf59/Vg+i5VfW8sRpdksNWcV2WB6g==
X-Received: by 2002:a17:902:8ecc:: with SMTP id x12mr1135180plo.134.1572454869413;
        Wed, 30 Oct 2019 10:01:09 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id q6sm417225pgn.44.2019.10.30.10.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 10:01:08 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
 <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
 <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
Date:   Wed, 30 Oct 2019 10:01:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 9:21 AM, Damien Le Moal wrote:
> If you feel strongly about it, I have absolutely no problem with
> dropping the patch. I just would like that it be dropped for the right
> reasons...

Hi Damien,

What I'm wondering about is how the SCSI core should support residual
overflow. Should a new member be introduced in struct scsi_request?
Should resid_len be changed from unsigned int to int or should we
perhaps follow yet another approach?

Thanks,

Bart.

