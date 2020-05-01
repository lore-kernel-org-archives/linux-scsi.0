Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7926C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C189920857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgEARsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:48:07 -0400
Received: from verein.lst.de ([213.95.11.211]:48107 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbgEARsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 13:48:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CE75E68D13; Fri,  1 May 2020 19:48:04 +0200 (CEST)
Date:   Fri, 1 May 2020 19:48:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 01/41] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
Message-ID: <20200501174804.GE23795@lst.de>
References: <20200430131904.5847-1-hare@suse.de> <20200430131904.5847-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-2-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:24PM +0200, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..5358f553f526 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1885,6 +1885,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>  	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>  	shost->tag_set.queue_depth = shost->can_queue;
> +	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;

Insteda of just passing through the value I think we should remove
them from can_queue here - as seen in the few patches the current
behavior of summing both up seems to cause a fair amount of
confusion.

Also I'd merge this with the patch to actually allocate reserved
command, as that is one actual unit of useful functionality.
