Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB28C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 19:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACC9610C7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 19:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhDBTi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:38:27 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:40588 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhDBTi1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 15:38:27 -0400
Received: by mail-pj1-f51.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so5006911pjq.5
        for <linux-scsi@vger.kernel.org>; Fri, 02 Apr 2021 12:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MlmIpanZZGDlwLKbZ6UwcCF9D+FZagmLW9tQiQzdX7s=;
        b=S182PIsh1EjWQJrGJA7oWgS/ZZkUqqDe/iHSyRLuYDosbFH/YJ8tyODjDsypmSnrkI
         MtnMjs8X8ZhsNEmLV6O3LpzftWINWMve9wHHP/HCkVXziWfSRQmw+hkM6w5mIwmiSE1d
         1Vx1kuTNVqexPkdLgvdfTKcPquEp+Wj5K0gv30fiHkvgJ7SViSSmT3N5DrYjo5HkS4aF
         hfrkX5a2cxalLJ/p80kSu4RmCtE+XY6nNdvf0iRyRRVYBqpAQgR6OPLMsoV4spzQSHpz
         Ox4kEVZ075AJQ+iWkcUjnhl81rnm4tVredX427qzOAixlH14m1L1aMf1QwyM1MX0/1MA
         7ASg==
X-Gm-Message-State: AOAM530VljeBAtq8wB93/0nCdxdVnyXMKmXFgfwUtOg4qOJQS/kkVmoK
        tEifNCj9ilskqU8iKw9X/H8=
X-Google-Smtp-Source: ABdhPJxdcO6SeU9jQOedd3NyaVnxF7WjgPeomsdcegW7yb21+4BpYGkZlGFcwlzeW08PxPL4C+TLhg==
X-Received: by 2002:a17:90a:1463:: with SMTP id j90mr15382744pja.205.1617392305519;
        Fri, 02 Apr 2021 12:38:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b5d6:3f29:a586:36e2? ([2601:647:4000:d7:b5d6:3f29:a586:36e2])
        by smtp.gmail.com with ESMTPSA id c12sm9133994pfp.17.2021.04.02.12.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 12:38:24 -0700 (PDT)
Subject: Re: [PATCH] scsi: scsi_transport_srp: don't block target in
 SRP_PORT_LOST state
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
References: <20210401091105.8046-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <af2a5e04-8ed8-f33c-68f9-84483c18e2d5@acm.org>
Date:   Fri, 2 Apr 2021 12:38:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210401091105.8046-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/21 2:11 AM, mwilck@suse.com wrote:
> rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and
> the SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
> srp_reconnect_work(), a warning is printed:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
