Return-Path: <SRS0=bc2H=DS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2BBC433E7
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Oct 2020 22:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC5E2078B
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Oct 2020 22:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387693AbgJKWYi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Oct 2020 18:24:38 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:45934 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387645AbgJKWYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2020 18:24:38 -0400
Received: by mail-pf1-f182.google.com with SMTP id e7so2692589pfn.12;
        Sun, 11 Oct 2020 15:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AqObdLhUgOUlrQshODzcn/Ls6pDIPsoS6TCJy6eUjqY=;
        b=qUspBJGhOWRboBWmP+SH9437Tn71cNe+K9yxBSVjg1z3E4u2SzQkToZeOGt39ng23u
         Nm9FAI7qQ0aoWPVg2AshRs1gPoVM3zOVJh8dOAKHpTPlIfMCZzh31bL46+A/bhEp5rUe
         +AMaSfj6gsR5ASf5+qpI1+qguqSSF5nYOJSdtMR7hkPk9OEESmH+VPstqK0JR+JMvmQt
         g9+2Q6+FzzzirX7Z//tpStDqw4DHGfxJqv7vbRy1jsbCOsOy0vidNxdZnu3+3C4524G6
         wXEidIjkc7/sFD7hi2LwH8uz3PvEutj9WVK8Yedw31l6dRpkTFtNf3a2ASG+cU9c+OLP
         b+kA==
X-Gm-Message-State: AOAM530gMwg4lM0qwl6GJESwSV9vdKNYeKhqjaVmBiMnyv07r/2Jun47
        MZx+Ju2rANmtPqjgUwaqD8FZTDjpFzyE+w==
X-Google-Smtp-Source: ABdhPJwEXU/mzCTTn6sCXqEwFYgPzG6Y/l4rSY2yPD+wS06MPjjRhBEhq1TDfo9EMqGrJyvd4Lx0rg==
X-Received: by 2002:a17:90a:7802:: with SMTP id w2mr16864226pjk.160.1602455076844;
        Sun, 11 Oct 2020 15:24:36 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s186sm3143414pfc.171.2020.10.11.15.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 15:24:36 -0700 (PDT)
Subject: Re: lib/scatterlist.c : sgl_alloc_order promises more than it
 delivers
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
References: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
 <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
 <d487005a-ef6c-549f-7006-c7056cf3f36d@interlog.com>
 <da346d8f-b27e-7880-10e8-f2617e0ec7ff@acm.org>
 <c4da2372-2957-5ad1-1433-f5d5b6e6b85d@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a9a2a37a-218b-a75d-103d-d15194e2e020@acm.org>
Date:   Sun, 11 Oct 2020 15:24:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <c4da2372-2957-5ad1-1433-f5d5b6e6b85d@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/20 2:21 PM, Douglas Gilbert wrote:
> My testing suggests using a store built with sgl_alloc_order() *** is a
> little faster but with a lower standard deviation (i.e. spread) on timings
> from repeated tests.

sgl_alloc_order() supports allocating SG-lists with higher order pages.
Allocating such S/G-lists is a workaround for the segment count limitations
of some DMA engines. Are you perhaps using sgl_alloc_order() for allocating
long-living data buffers? sgl_alloc_order() was not intended to be used for
that purpose. Anyway, if your use case can be implemented without introducing
any drawbacks for other users, feel free to submit a patch.

Thanks,

Bart.


