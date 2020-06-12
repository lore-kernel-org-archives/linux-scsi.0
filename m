Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB361C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 17:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA185207F7
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 17:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFLRtC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 13:49:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:38336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgFLRtC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Jun 2020 13:49:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 227E5AB8F;
        Fri, 12 Jun 2020 17:49:04 +0000 (UTC)
Subject: Re: [PATCH] qla2xxx: Set NVME status code for failed NVME FCP request
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org
References: <20200604100745.89250-1-dwagner@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <95091326-e5b4-e747-b187-21a049a1c541@suse.de>
Date:   Fri, 12 Jun 2020 19:48:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604100745.89250-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/20 12:07 PM, Daniel Wagner wrote:
> The qla2xxx driver knows when request was processed successfully or
> not. But it always sets the NVME status code to 0/NVME_SC_SUCCESS. The
> upper layer needs to figure out from the rcv_rsplen and
> transferred_length variables if the request was successfully. This is
> not always possible, e.g. when the request data length is 0, the
> transferred_length is also set 0 which is interpreted as success in
> nvme_fc_fcpio_done(). Let's inform the upper
> layer (nvme_fc_fcpio_done()) when something went wrong.
> 
> nvme_fc_fcpio_done() maps all non NVME_SC_SUCCESS status codes to
> NVME_SC_HOST_PATH_ERROR. There isn't any benefit to map the QLA status
> code to the NVME status code. Therefore, let's use NVME_SC_INTERNAL to
> indicate an error which aligns it with the lpfc driver.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index d66d47a0f958..fa695a4007f8 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -139,11 +139,12 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
>   	sp->priv = NULL;
>   	if (priv->comp_status == QLA_SUCCESS) {
>   		fd->rcv_rsplen = le16_to_cpu(nvme->u.nvme.rsp_pyld_len);
> +		fd->status = NVME_SC_SUCCESS;
>   	} else {
>   		fd->rcv_rsplen = 0;
>   		fd->transferred_length = 0;
> +		fd->status = NVME_SC_INTERNAL;
>   	}
> -	fd->status = 0;
>   	spin_unlock_irqrestore(&priv->cmd_lock, flags);
>   
>   	fd->done(fd);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
