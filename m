Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CC3C47247
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0979206D6
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD3RL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 13:11:29 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47575 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgD3RL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 13:11:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2B74E20416A;
        Thu, 30 Apr 2020 19:11:27 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XDDN2oJT8TLV; Thu, 30 Apr 2020 19:11:19 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 47A8420415B;
        Thu, 30 Apr 2020 19:11:17 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4cd3cb8a-b61a-54c8-bc0a-da8a1bdc3b70@interlog.com>
Date:   Thu, 30 Apr 2020 13:11:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 9:18 a.m., Hannes Reinecke wrote:
> Add helper functions to retrieve SCSI commands from the reserved
> tag pool.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_lib.c    | 35 +++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h |  3 +++
>   2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5358f553f526..d0972744ea7f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1901,6 +1901,41 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>   	blk_mq_free_tag_set(&shost->tag_set);
>   }
>   
> +/**
> + * scsi_get_reserved_cmd - allocate a SCSI command from reserved tags
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + */
> +struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
> +					int data_direction)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +
> +	rq = blk_mq_alloc_request(sdev->request_queue,
> +				  data_direction == DMA_TO_DEVICE ?
> +				  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,

after consulting: https://en.cppreference.com/w/c/language/operator_precedence
I think that the above expression can be written as:

(data_direction == DMA_TO_DEVICE) ? REQ_OP_SCSI_OUT : (REQ_OP_SCSI_IN | REQ_NOWAIT),

So is REQ_NOWAIT not needed with REQ_OP_SCSI_OUT ?

Please note that scripts/checkpatch.pl does _not_ complain when parentheses
are used around bitwise operators in complex expressions. And I reckon this
expression qualifies as complex.

Doug Gilbert


Note: in that reference the terniary operator gets this note: "The expression
in the middle of the conditional operator (between ? and :) is parsed as if
parenthesized: its precedence relative to ?: is ignored". Who knew?
