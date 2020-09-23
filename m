Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C249C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 018012223E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 06:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIWGrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:47:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:51536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWGrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 02:47:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A857FAB0E;
        Wed, 23 Sep 2020 06:48:20 +0000 (UTC)
Subject: Re: [PATCH V3 for 5.11 11/12] scsi: make sure sdev->queue_depth is <=
 shost->can_queue
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
 <20200923013339.1621784-12-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8efef2bb-377a-9a3c-2261-d41dc0e9bdf8@suse.de>
Date:   Wed, 23 Sep 2020 08:47:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923013339.1621784-12-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/20 3:33 AM, Ming Lei wrote:
> Obviously scsi device's queue depth can't be > host's can_queue,
> so make it explicitely in scsi_change_queue_depth().
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 24619c3bebd5..cc6ff1ae8c16 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -223,6 +223,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>    */
>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>   {
> +	depth = min_t(int, depth, sdev->host->can_queue);
> +
>   	if (depth > 0) {
>   		sdev->queue_depth = depth;
>   		wmb();
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
