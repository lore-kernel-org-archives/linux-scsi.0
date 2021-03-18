Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54398C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C32A64EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhCRTLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:11:12 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:43941 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbhCRTKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 15:10:47 -0400
Received: by mail-pf1-f169.google.com with SMTP id q5so4164532pfh.10
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 12:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ewjX2VaCx6Ynh0BXSyMQ1cAi6993ibBty1C0yHyHLyI=;
        b=Kp9dqhD16p6IcUfnrdtWEOtd6+Z1MYOJQKFhAIz4EiMcx2GXvQtpWON+aV1h3S47t9
         m8pCqfxBYLLA0L2K7zSQ8XoegrKx5nUkdnTEdzok+eZtmX6brWYARQoU0bHAxC2O2r0y
         HOjTwonvxHXrUuMrr02bx+NqOgiVVcNHgyQSW4HeiCsRXiGYPXffVHN1lULp3HcS8Vd4
         WolF7jrGr7lAH3ov3zZwTZnOk+f/OZXutdS0bt6lyY0P+CVqPj/s4pUB+bZgFJOxwbki
         p+3TrnjDwvOBtd6f5drULFeFu7nezf6+uXDNyczEKlGiai916A9RAcSJgr+4vhrN6qIq
         Cmew==
X-Gm-Message-State: AOAM5332nWhjd0D3Ug6dKrCQpb9WssEROXrI20TbS+rhixIxrVHlcF65
        Ku0FegolNgsngJQdoLXbjhQ=
X-Google-Smtp-Source: ABdhPJwgzgn3/apViQcZhxEkHfg7Keharr5fz9zy+WbaKn2itXEzbjuxz9/SWvJZR7b6FPTPUtZV2g==
X-Received: by 2002:a05:6a00:47:b029:1f7:ff05:c771 with SMTP id i7-20020a056a000047b02901f7ff05c771mr5572942pfk.29.1616094646781;
        Thu, 18 Mar 2021 12:10:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e363:cf60:5c8:c27b? ([2601:647:4000:d7:e363:cf60:5c8:c27b])
        by smtp.gmail.com with ESMTPSA id 25sm3131690pfh.199.2021.03.18.12.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 12:10:45 -0700 (PDT)
Subject: Re: [PATCH v2 4/6] qla2xxx: Suppress Coverity complaints about
 dseg_r*
To:     Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-5-bvanassche@acm.org>
 <b04f8794-caa7-a21a-0c5f-363dd4ea6e43@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4f784043-1ea3-0aee-d927-ce9ccaeeeb09@acm.org>
Date:   Thu, 18 Mar 2021 12:10:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b04f8794-caa7-a21a-0c5f-363dd4ea6e43@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/18/21 9:00 AM, Lee Duncan wrote:
> I dislike such an uncommented change just to keep a tool happy. Could
> you add a comment in qla_mr.h saying why these are one-element-long
> arrays, just so nobody optimizes those out later?
I will add a comment. Thanks for the feedback.

Bart.
