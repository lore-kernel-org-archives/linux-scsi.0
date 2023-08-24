Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866BCC27C40
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 14:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbjHXOsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 10:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241844AbjHXOsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 10:48:31 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD7C1BD4;
        Thu, 24 Aug 2023 07:48:02 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bf55a81eeaso34417505ad.0;
        Thu, 24 Aug 2023 07:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692888468; x=1693493268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Go0JA+ncTUVKQH5aP2NozeJeq8XplVwTrOGU4aPJmRA=;
        b=KiTENg0bt26Xu/XdDOTeoJAS4Ljw6Xgzuxp/YWfkcrThGPWmDDzc7UIfuyfFIEVHto
         RyZAHgZnArG5HcleAyRdXB5GIDDsvzmkQi0MGBm+bjH8H+DaJ7mMLTaic3FhtfqwO63O
         WUMq3bHq+lB8tUHntoSrFgoc2daF8duqPpf2WSD1SmKE3Wozsaubm6QJxf13pf0Juq2m
         eBtkTck3vmgVztOFEBJsqnPsWrx+yG6ocVK9htkLe7vENzYSzKqi8rVaKHe/t+W8jdTd
         2S65m2jbHpUr2Ss4AorWRujBDvF97u+iigtvM02DthDc5K36ehxmzSCUYhP4wNTbnlZ6
         cGIA==
X-Gm-Message-State: AOJu0YyPoefDuLXrX9AkTcITX1Q+KX7DBtke30EXtAUy/7Dn+DslNE8G
        dJQ2fQzdwh8Go4fTnd9ZAEg=
X-Google-Smtp-Source: AGHT+IFW6UXRkLM6aMG+WThvbRzjw8qMM8hO0l9+4XzDaaDfGlIvrNQZpkMORXUzZGhGBoxuhimc2w==
X-Received: by 2002:a17:902:b709:b0:1bd:a0cd:1860 with SMTP id d9-20020a170902b70900b001bda0cd1860mr10982628pls.64.1692888467851;
        Thu, 24 Aug 2023 07:47:47 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e6ec:4683:972:2d78? ([2620:15c:211:201:e6ec:4683:972:2d78])
        by smtp.gmail.com with ESMTPSA id jg5-20020a17090326c500b001b9d8688956sm12923006plb.144.2023.08.24.07.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 07:47:47 -0700 (PDT)
Message-ID: <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
Date:   Thu, 24 Aug 2023 07:47:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
 <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 16:22, Damien Le Moal wrote:
> The sd driver does have zone append emulation using regular writes. The
> emulation relies on zone write locking to avoid issues with adapters that do not
> have strong ordering guarantees, but that could be adapted to be removed for UFS
> devices with write ordering guarantees. This solution would greatly simplify
> your series since zone append requests are not subject to zone write locking at
> the block layer. So no changes would be needed at that layer.
> 
> However, that implies that your preferred use case (f2fs) must be adapted to use
> zone append instead of regular writes. That in itself may be a bigger-ish
> change, but in the long run, likely a better one I think as that would be
> compatible with NVMe ZNS and also future UFS standards defining a zone append
> command.

Hi Damien,

Thanks for the feedback. I agree that it would be great to have zone append
support in F2FS. However, I do not agree that switching from regular writes
to zone append in F2FS would remove the need for sorting SCSI commands by LBA
in the SCSI error handler. Even if F2FS would submit zoned writes then the
following mechanisms could still cause reordering of the zoned writes after
these have been translated into regular writes:
* The SCSI protocol allows SCSI devices, including UFS devices, to respond
with a unit attention or the SCSI BUSY status at any time. If multiple write
commands are pending and some of the pending SCSI writes are not executed
because of a unit attention or because of another reason, this causes
command reordering.
* Although the link between the UFS controller and the UFS device is pretty
reliable, there is a non-zero chance that a SCSI command is lost. If this
happens the SCSI timeout and error handlers are activated. This can cause
reordering of write commands.

In other words, whether F2FS submits regular writes (REQ_OP_WRITE) or zone
appends (REQ_OP_ZONE_APPEND), I think we need the entire patch series.

Thanks,

Bart.
