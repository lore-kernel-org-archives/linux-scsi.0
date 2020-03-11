Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A28C10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 15:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40891206E7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 15:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgCKPMq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 11:12:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35981 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbgCKPMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 11:12:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id c7so1384470pgw.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 08:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrusJYJp9iBD9reRS50wQ1J3cISwwLSD/U91nbiIDzE=;
        b=Y95BtmqsptFvYXgtv2vCzaToHLyjBh2ff+TwBzy5cE8TTyPu8/BTuK/DpzNensMKQh
         UIY36f3PAizv+UqgZh6cHY2Lr1Enjnxn9M+kAQKkksty5ULHdE5GFjk9zGfvfNGIbcO6
         49BBZ/gLPU1taoGDI4lt0+c8T4UPPmlDYhW+bM/6/bD/3ScitbB1JFBbZX3glAziE50I
         gkOsgXYKhS4yQBRte6AsA2lh8h+HNKvbTD0LsHbKpmZz7c53DRBow2GGYdkR8T91Tofc
         nHd2jrifziOwZ43Er6fvXj5exZW4h0uv8NRDGNKJvqnlpykW+/GM0+A3f9J17PSb4PIz
         S69w==
X-Gm-Message-State: ANhLgQ2dL3qwWbeW399Yfi+R8LvfG+hwsq8z7wlIZqquKEnZZ1ebDEcG
        h3R+OC6Dg45jPXQZHEWxydwUoKrI
X-Google-Smtp-Source: ADFU+vsWtx1+6VL1l8NNxZipZrAUfvTRFNIeUpkwX7nw4a6M8HraGULbYBwoW1kIovxOIugsY25Law==
X-Received: by 2002:a63:715:: with SMTP id 21mr3261570pgh.234.1583939564573;
        Wed, 11 Mar 2020 08:12:44 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m11sm5856547pjl.18.2020.03.11.08.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 08:12:43 -0700 (PDT)
Subject: Re: [PATCH 7/8] scsi: core: Use scnprintf() for avoiding potential
 buffer overflow
To:     Takashi Iwai <tiwai@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20200311091630.22565-1-tiwai@suse.de>
 <20200311091630.22565-8-tiwai@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <facacb36-2f60-e1ee-b3df-b66a2ba76744@acm.org>
Date:   Wed, 11 Mar 2020 08:12:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311091630.22565-8-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/20 2:16 AM, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().

Reviewed-by: Bart van Assche <bvanassche@acm.org>
