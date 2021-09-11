Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7EDC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 21:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC01611AD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 21:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhIKVkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 17:40:05 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:46709 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhIKVkF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 17:40:05 -0400
Received: by mail-pf1-f180.google.com with SMTP id y17so5162046pfl.13
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 14:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Doh3U5Adf7Y7BzinkFQtBZHUA9ISxy+tk3BoDzsUlbE=;
        b=xTNNZNg8WUwvCpVbQUIq80xCN7243c3dN3J++oi4JhHdzC85CAZCM5usOG96M5fhXQ
         9K6kTTXCB8vJ8G+xGEvdqFbLM0pTXIAtjJgNL3+N5FEcR5fDurDEQE+Jy3l8JzrFQYWV
         iL8Hc1yHg8cYrWCbbd2w/zoz2+vzOuGUFJPWAY8rbs2it2R1i7wp3JwmbOrDSwNEZBhj
         JRoBVUq4pySTotpjT+iZPlWMRTUrGriZQytoSWctL7Ywz8/attm3YpdYG1NBuE04zzlN
         Pq6yBbviaTB4lsI7i1sGt8tGte+SHgSQpM+6AzLcA55o4+xUJ10Cz5hdQMNV34Fb1F7y
         PaEw==
X-Gm-Message-State: AOAM532RCgdcT2CcBZMH8zChEJi8yO1ERjf3ad5V4c4NOLt+5lCGY7BD
        bSlEtsFpq5G39hXFV2mE6Hs=
X-Google-Smtp-Source: ABdhPJwTidQI0O52gLtaoOE6hQIz5B68tw6jwwukq4lbBP9vqRB9Cfah8Kd+GqRKmVysLpSe6z7o5g==
X-Received: by 2002:a63:4622:: with SMTP id t34mr4007407pga.293.1631396331947;
        Sat, 11 Sep 2021 14:38:51 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:8e23:83c0:a404:a54f? ([2601:647:4000:d7:8e23:83c0:a404:a54f])
        by smtp.gmail.com with UTF8SMTPSA id 23sm2931882pgk.89.2021.09.11.14.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 14:38:50 -0700 (PDT)
Message-ID: <6ca39c4f-37b7-c1fa-3ce5-c60bf6d30cbf@acm.org>
Date:   Sat, 11 Sep 2021 14:38:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] scsi: sd: Make sd_spinup_disk less noisy
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Christian Loehle <cloehle@hyperstone.com>
References: <a2d0a249-6035-9697-626a-e14ec50ef6ee@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a2d0a249-6035-9697-626a-e14ec50ef6ee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/21 05:11, Heiner Kallweit wrote:
> For my personal taste sd_spinup_disk() is a little bit noisy after
> 848ade90ba9c ("scsi: sd: Do not exit sd_spinup_disk() quietly").

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
