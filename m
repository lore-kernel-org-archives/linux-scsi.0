Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7325C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjAXT1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbjAXT1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:27:24 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA5474DD;
        Tue, 24 Jan 2023 11:27:23 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id v23so15763842plo.1;
        Tue, 24 Jan 2023 11:27:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw2FyW/YD0inA9y0t6RX6j1hwJWKEzlegEpvBujXKD0=;
        b=VnxHevzymDm31VMfHw0Xqlt0GFmlvMGzJzfAvuyL/5LM9e07K8KjJhYMIQPzFCmHaz
         nkNJumaqff3oOe5LJEMoKJObfxwYtM6/G+cdWaQPP5CUZYXTpQul2kra/SxfUbtzKLhU
         pvwV6VHYR+TF3no6psRk+KnH0/7RxGiaysnc4fjJfCZtdN47dcbWFZT+L5ihV430I4gr
         RGYhj4DryWOhMY7G0DZI1V/fTqcX/dg2iJ20rV63u/WezQMKW3Xu+dRjKFt71Rl5u/yl
         7eyVsYUQcHIVLDT3tNfQZeTAnI+npvxVIxQnOWwMxcAAqvc/i+5VFbPF2LtsYskn8eG8
         +kgQ==
X-Gm-Message-State: AFqh2kp/1LL9PBOLmhLh/fes4C+eQ3WlFQaXTkR8xNpboJ3DflXr73R1
        /vPV2RBXNVuxZMjHD2TYHHQ=
X-Google-Smtp-Source: AMrXdXvAYq4ZzRkTWDjNmXGgIePzTSZN0X78jqlynxTH9OIhtYtCc13jwjmBH7g7U4FxXN1TtvizrA==
X-Received: by 2002:a17:902:da8d:b0:194:dd88:ea1e with SMTP id j13-20020a170902da8d00b00194dd88ea1emr24383017plx.31.1674588442947;
        Tue, 24 Jan 2023 11:27:22 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id bi8-20020a170902bf0800b0019605a51d50sm2037463plb.61.2023.01.24.11.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:27:22 -0800 (PST)
Message-ID: <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
Date:   Tue, 24 Jan 2023 11:27:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-2-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
> be executed using duration-limits targets. The duration target to apply
> to a command is indicated using the priority level. Up to 8 levels are
> supported, with level 0 indiating "no limit".
> 
> This priority class has effect only if the target device supports the
> command duration limits feature and this feature is enabled by the user.
> 
> While it is recommended to not use an ioscheduler when using the
> IOPRIO_CLASS_DL priority class, if using the BFQ or mq-deadline scheduler,
> IOPRIO_CLASS_DL is mapped to IOPRIO_CLASS_RT.
> 
> The reason for this is twofold:
> 1) Each priority level for the IOPRIO_CLASS_DL priority class represents a
> duration limit descriptor (DLD) inside the device. Users can configure
> these limits themselves using passthrough commands, so from a block layer
> perspective, Linux has no idea of how each DLD is actually configured.
> 
> By mapping a command to IOPRIO_CLASS_RT, the chance that a command exceeds
> its duration limit (because it was held too long in the scheduler) is
> decreased. It is still possible to use the IOPRIO_CLASS_DL priority class
> for "low priority" IOs by configuring a large limit in the respective DLD.
> 
> 2) On ATA drives, IOPRIO_CLASS_DL commands and NCQ priority commands
> (IOPRIO_CLASS_RT) cannot be used together. A mix of CDL and high priority
> commands cannot be sent to a device. By mapping IOPRIO_CLASS_DL to
> IOPRIO_CLASS_RT, we ensure that a device will never receive a mix of these
> two incompatible priority classes.

Implementing duration limit support using the I/O priority mechanism 
makes it impossible to configure the I/O priority for commands that have 
a duration limit. Shouldn't the duration limit be independent of the I/O 
priority? Am I perhaps missing something?

Thanks,

Bart.

