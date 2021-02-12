Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58942C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2781E64DF0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhBLThM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:37:12 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:46773 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhBLThJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:37:09 -0500
Received: by mail-pf1-f180.google.com with SMTP id k13so120629pfh.13;
        Fri, 12 Feb 2021 11:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=unVxmz+xOQPB7o/zuFYcQQ1FE1kdo2SmhfY8aeKbxnQ=;
        b=hSLXOmQUA/TExEPGNeTTREsLZKz3hu9GVdbj4NrS/+XPT3sTJ0+1f+vddOPf8UnE3c
         ERDfIVHqhSPSYvjJZcavkw3QSwDaw2zPWvmT5i8lwmsU/DuX5A9D35Zx0Yk7B80/Z8Sw
         +8Uc7gtZBaq2Pa9qeKO4N8NZ2eyhXWh+urBrwWPH083VntXnPEdEOP6r0RiEH2uveh5P
         YDidyzQqgAbm4scnSZNXGJqqVaChlySX1vIq06hevrygRfUhZjDWPznDNhdxfCwuWM+U
         qyvEp2XaP4R3mC36lke9K8N/reQBv+UHjS4ZbAk4PLfjyk5/skpVtUo87vmpaq9b2/4a
         yhzw==
X-Gm-Message-State: AOAM530VVagd4HYceKeS0hyMRvAfe67hth1u0DK+VjX+6tTC+J4wRVJm
        e80EcCKPrHkoGGBp5ZfHlWCkj4glpXY=
X-Google-Smtp-Source: ABdhPJwNnyeQ9clhWQ7N64jvCYwcynhRmo7RPRtpfds9uBKMjN+28fqJ3AJnHmPR6VIUUQSbZG4l/g==
X-Received: by 2002:a63:3d0:: with SMTP id 199mr4718074pgd.4.1613158588075;
        Fri, 12 Feb 2021 11:36:28 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1506:bcba:266a:29b2? ([2601:647:4000:d7:1506:bcba:266a:29b2])
        by smtp.gmail.com with ESMTPSA id r4sm9761471pgp.16.2021.02.12.11.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:36:27 -0800 (PST)
Subject: Re: [PATCH 05/25] srpt: Convert to new submission API
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-6-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cae53934-c26c-e0e6-1339-e1fa767c0cd9@acm.org>
Date:   Fri, 12 Feb 2021 11:36:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212072642.17520-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/21 11:26 PM, Mike Christie wrote:
> target_submit_cmd_map_sgls is being removed, so convert srpt to
> the new submission API.
> 
> srpt uses target_stop_session to sync session shutdown with lio core,
> so we use target_init_cmd/target_submit_prep/target_submit, because
> target_init_cmd will detect the target_stop_session call and return
> an error.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
