Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A294BC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 03:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiGKDj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 23:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGKDj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 23:39:27 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5758213DEA;
        Sun, 10 Jul 2022 20:39:26 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so3772156pjf.2;
        Sun, 10 Jul 2022 20:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QE7JJYPymJYEjSIRg5jCrbP1FqM2+RCByJ/BFBKot1A=;
        b=vvLc8fqTIgWxiYsD9rHI9Lzk0drMsSfSaySPNZysynJFunZIytXBr2iznmjtZ8AV0Z
         yW4RmvG4HTgf8qozYFgIhtYybn6jK0ZPBLvywUHMmC488jnLOjfA711D57F083nrtRBW
         /xlPeQWzGB6RW1u+7Mrz5H4XQUHAxQTID5FiJlOxlNWKvfcsMaGAwhDZdNKJTMExvq2W
         0XqUauZZvK/VW9EcgZBNZNsOCqumdz7GTGxphZie9U4vCqF3o+AEow17WI8FeGmBYrSG
         STvWlgTcq5H9lMEdvJQmg/4rGxkMnhL4MuGt7eRf0PVcalEdkMfdl4uxjZHCEjOp1fgk
         EvPw==
X-Gm-Message-State: AJIora+vIPSfaaKyXLvgDzp1uwtOKg+HYK1zcOBmmYaQLP8fzxNLLJ7U
        2iNJ0WzuUdST3CyJ+Bd0KgU=
X-Google-Smtp-Source: AGRyM1su0xHZ6Ef0N6HO80MhMbx7u3fom5ZT26vDFPPmAs9nMDqcs/2xpps8t6IEicgZawPau+/WUQ==
X-Received: by 2002:a17:90b:4c8c:b0:1ef:bff6:c964 with SMTP id my12-20020a17090b4c8c00b001efbff6c964mr14952558pjb.36.1657510765658;
        Sun, 10 Jul 2022 20:39:25 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z2-20020a1709027e8200b0016be2bb8e68sm3432786pla.303.2022.07.10.20.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 20:39:24 -0700 (PDT)
Message-ID: <43810471-af38-570f-8cce-7b0f927bdc2d@acm.org>
Date:   Sun, 10 Jul 2022 20:39:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: megaraid: clear READ queue map's nr_queues
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Guangwu Zhang <guazhang@redhat.com>
References: <20220706125942.528533-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220706125942.528533-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/6/22 05:59, Ming Lei wrote:
> megaraid scsi driver sets set->nr_maps as 3 if poll_queues is > 0, and
> blk-mq actually initializes each map's nr_queues as nr_hw_queues, so
> megaraid driver has to clear READ queue map's nr_queues, otherwise queue
> map becomes broken if poll_queues is set as non-zero.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
