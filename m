Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D27DCA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2BD20830
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfJ1UtW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:49:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43453 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1UtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:49:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id l24so7740453pgh.10;
        Mon, 28 Oct 2019 13:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HBgNemMhR9CUsDe/6tQk2VfkcoWYsw39YAXnZT0ZnH4=;
        b=lFHglUnChLx9cB68s4qqjfezpYcGMoTVvPYru5JioSS0faNra8tAePbKviOO3lEtbo
         KdctVh7Pbq0kI29N9my86aj/PPYGgroIKl4+12TjQ0WdekozVOZLGhOndxfriz0m3WO7
         YIJCOgLEhvM1fV0ZcWNThjWxQaDIwwWmmJoJwrW3tSuINA/bLarvkz3gbbL2aJ9q0WLf
         0/4n01SnFQrquEb/y0sZ15ZjIXXKZ6TL2aG3PdX24McnqM7br04yXXXAf+zdgYYX45IY
         lcuHBjzhw52Fru6qRhlK0KrRTxw5EpHcKx4FGZYljjs5AbVCNvM0r0grljrbVZchM8a3
         G8zQ==
X-Gm-Message-State: APjAAAU3+56defQycorerbpQ5iMKdUp0nvii8XeNE/wFUEEh/MPJL4d4
        H8xo9Yv90/p+niPxuOreq+0=
X-Google-Smtp-Source: APXvYqwQ4ry51rhVYgmLz2b5bp2lq6bYQba/60wABozGNpXhyFV0GSW5uq1QIq3i06N0XaA180/qNg==
X-Received: by 2002:a62:1ac6:: with SMTP id a189mr22586809pfa.96.1572295761570;
        Mon, 28 Oct 2019 13:49:21 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 184sm12199766pfu.58.2019.10.28.13.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 13:49:20 -0700 (PDT)
Subject: Re: [PATCH 9/9] ASoC/fsl_spdif: Use put_unaligned_be24() instead of
 open-coding it
To:     Mark Brown <broonie@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028200700.213753-10-bvanassche@acm.org>
 <20191028202414.GK5015@sirena.co.uk>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <31dc0244-834f-0829-352f-77b468b18857@acm.org>
Date:   Mon, 28 Oct 2019 13:49:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028202414.GK5015@sirena.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 1:24 PM, Mark Brown wrote:
> On Mon, Oct 28, 2019 at 01:07:00PM -0700, Bart Van Assche wrote:
>> This patch makes the code easier to read.
> 
> I only have this patch from the series but no cover letter, what's the
> story with dependencies?

Hi Mark,

The entire patch series including the cover letter is available on e.g. 
the Lore linux-kernel archive: 
https://lore.kernel.org/lkml/20191028200700.213753-1-bvanassche@acm.org/T/#t

Thanks,

Bart.


