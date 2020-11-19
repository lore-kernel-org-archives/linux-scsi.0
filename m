Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6370BC6379D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 10:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC2E246EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 10:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgKSK3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 05:29:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:53876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgKSK3V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 05:29:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 768E3AA4F;
        Thu, 19 Nov 2020 10:29:19 +0000 (UTC)
Subject: Re: [PATCH V5 10/13] megaraid_sas: v2 replace sdev_busy with local
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201119094705.280390-1-ming.lei@redhat.com>
 <20201119095147.GB279559@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0a3b01e0-434b-7962-ffc7-611bc9c680a1@suse.de>
Date:   Thu, 19 Nov 2020 11:29:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201119095147.GB279559@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/20 10:51 AM, Ming Lei wrote:
>  From 4c13ab0b85057de70c523970bbb9d2268e6d980d Mon Sep 17 00:00:00 2001
> From: Kashyap Desai <kashyap.desai@broadcom.com>
> Date: Thu, 19 Nov 2020 12:39:01 +0530
> Subject: [PATCH V5 10/13] megaraid_sas: v2 replace sdev_busy with local
>   counter
> 
> use local tracking of per sdev outstanding command since sdev_busy in
> SML is improved for performance reason using sbitmap (earlier it was
> atomic variable).
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> Fix checkpatch ERROR and WARNING.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas.h        |  2 +
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 47 +++++++++++++++++----
>   2 files changed, 41 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
