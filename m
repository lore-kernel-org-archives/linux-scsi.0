Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D71AC49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 15:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27AC26135C
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 15:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhFXQAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 12:00:10 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:37675 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhFXQAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 12:00:09 -0400
Received: by mail-pj1-f43.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so6200866pjs.2;
        Thu, 24 Jun 2021 08:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNPyI3PP0vBeDkcG5QDbVbgGr456i/jWuZ+4BoW2nFA=;
        b=T/IvlQ3qu66BrxjLDyQbuPswUtgN2I5SXC1H4d4Lu2O9gPv9W1Thmsh8UoZSPzUC4L
         jfUgrhXcUK4thlh/OPO9opNw9ATlIxe04gtTlOREPYjnw+SJzLW3cw4w6JwQWFRQE7Er
         9hR0c4uZ7Dy8I2LZahmDitNJJ/iy1Eaa6DYOUDa27U+fUTNw6i3OEFjvz/n18umYGwUu
         2akQkqvOvA7Ui0C6GH2hUVqDChDAcjTyDmFJRoGvVsQHxKw8FxqdEqxi7feM1U5YNu0i
         QHDABI08TLVhz5Hhaj163rYYl9V5e7vhjM1DpWwvIGttTVG87ZxSFYuglHCulr/uBIef
         8RfQ==
X-Gm-Message-State: AOAM533YQ6mtbzpvI5AotgK3GF6kLK+JKOUvfVi4QUctKPBeOYjEj0+j
        +d9sgSFmPqo7zpPjs5FG5AM=
X-Google-Smtp-Source: ABdhPJybahGMsYCFVC9Qq7zo6CtCFkedYR+Sm/HdAWn8RecMMo4lvmsUEVVukk57D63q39WFh/DvQQ==
X-Received: by 2002:a17:90a:a395:: with SMTP id x21mr6117690pjp.63.1624550269778;
        Thu, 24 Jun 2021 08:57:49 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c2sm2952757pjv.10.2021.06.24.08.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 08:57:48 -0700 (PDT)
Subject: Re: [PATCH 1/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
To:     Sergey Samoylenko <s.samoylenko@yadro.com>,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20210624111926.63176-1-s.samoylenko@yadro.com>
 <20210624111926.63176-2-s.samoylenko@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5981680f-96ad-3c4e-6640-c3cca709a57c@acm.org>
Date:   Thu, 24 Jun 2021 08:57:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624111926.63176-2-s.samoylenko@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/21 4:19 AM, Sergey Samoylenko wrote:
> +	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u,"
> +		" XCOPY operation failed\n", rc, sense_rc);

Please do not split format strings across multiple lines. Checkpatch
should have complained about this.

Thanks,

Bart.
