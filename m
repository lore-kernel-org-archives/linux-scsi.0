Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D332C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 23:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D189E60FC2
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Oct 2021 23:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhJaXzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Oct 2021 19:55:14 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38624 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhJaXzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2021 19:55:13 -0400
Received: by mail-pg1-f171.google.com with SMTP id e65so15655939pgc.5;
        Sun, 31 Oct 2021 16:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H59Pp6BOlJqSYGdZY9Uqg+yI/d2/FAFJDCSeL8+4FAU=;
        b=WWcaBinxyeg2wtJTeW/dISNJckpu4+6LsWKHjbzL/2a3pEWC/e/zCEawjp81kArUWD
         YpXAn51AT/jSWf1ftSUd4u+AF6miXgi5ZZqvLiOotTq0GqydWztOeFJnkb0CcNMPwVtd
         ymJQYA3JymOPdCdsorjhP2BNN5JswHu8UtVKgZF16cJq83RKIUxe7wTvYbZoIWXVVW1r
         NkTYLbWpidob70P8OvOcc5jRBl8SoXOhvELQsBx0nUaWtJ0tt5O8v6gaK1kMNOAhZTEY
         5zKoqh7XcNl/HbUfHHMbv2I+xN8q1Y8k1qO5KzULS+QwYKFohJjeYpyGuLZWpLWtg2aU
         2Djg==
X-Gm-Message-State: AOAM532XHcAMjf6nD5NC+QLc0pX8fQ+uaH9f8D2KJpDYHkkca7bWpkqJ
        UQdA4FVvLlXsmCSBWyhnMuDWAUionEA=
X-Google-Smtp-Source: ABdhPJw+sTX+m7/q9aXn57lQOTFSZA1gFsbrodC/8iX6X4sCDsTAHl+IU2l9f0/ICcnwyqIicF+b7w==
X-Received: by 2002:a63:2066:: with SMTP id r38mr19068138pgm.389.1635724360983;
        Sun, 31 Oct 2021 16:52:40 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:5552:3d10:7f96:6911? ([2601:647:4000:d7:5552:3d10:7f96:6911])
        by smtp.gmail.com with ESMTPSA id nv4sm5549414pjb.17.2021.10.31.16.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 16:52:40 -0700 (PDT)
Message-ID: <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
Date:   Sun, 31 Oct 2021 16:52:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
Content-Language: en-US
To:     Justin Piszcz <jpiszcz@lucidpixels.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/21 16:19, Justin Piszcz wrote:
> Diff between 5.14 and 5.15 .config files-- could it be something to do with
> CONFIG_IOMMU_DEFAULT_DMA_LAZY=y?

That's hard to say. Is CONFIG_MAGIC_SYSRQ enabled? If not, please enable 
it and hit Alt-Printscreen-t (dump task list; see also 
Documentation/admin-guide/sysrq.rst) and share the contents of the 
kernel log. If that would not be convenient, please try to bisect this 
issue.

Thanks,

Bart.
