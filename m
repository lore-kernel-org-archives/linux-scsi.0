Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA90C10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 08:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66D220873
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 08:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POfxxDLx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgCKIL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 04:11:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726310AbgCKIL0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 04:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583914284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mclFMWusgTyOtMcXNsfUg9sVqxkjUF7Bq9avEjcdG/I=;
        b=POfxxDLxLRxz0GchrXi5J2QGfflxcAJJ8m1RKPDVXWvAOpYfT6l1kxLLp1KmI/rUf78b2Y
        ClXVoU7XfNEMvLGtrUXfmIhnNV7FqUMBi7lHiGZjYdfqyPlmkTUJtZC8kRIIUWYihwdreO
        xmOHQzlc0SeuLcwl0f/+E07TwHg6WNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-sWznBkZzPgyeEBOnUFWxYg-1; Wed, 11 Mar 2020 04:11:22 -0400
X-MC-Unique: sWznBkZzPgyeEBOnUFWxYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 980BC107ACC4;
        Wed, 11 Mar 2020 08:11:20 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E6610372C5;
        Wed, 11 Mar 2020 08:11:06 +0000 (UTC)
Date:   Wed, 11 Mar 2020 16:10:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hare@suse.de, bvanassche@acm.org, hch@infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v2 12/24] hpsa: use reserved commands
Message-ID: <20200311081059.GC31504@ming.t460p>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-13-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583857550-12049-13-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 12:25:38AM +0800, John Garry wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Enable the use of reserved commands, and drop the hand-crafted
> command allocation.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 147 ++++++++++++++------------------------------
>  drivers/scsi/hpsa.h |   1 -
>  2 files changed, 45 insertions(+), 103 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 703f824584fe..c14dd4b6e598 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -244,10 +244,6 @@ static struct hpsa_scsi_dev_t
>  	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
>  		struct sas_rphy *rphy);
>  
> -#define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
> -static const struct scsi_cmnd hpsa_cmd_busy;
> -#define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
> -static const struct scsi_cmnd hpsa_cmd_idle;
>  static int number_of_controllers;
>  
>  static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
> @@ -342,7 +338,7 @@ static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
>  
>  static inline bool hpsa_is_cmd_idle(struct CommandList *c)
>  {
> -	return c->scsi_cmd == SCSI_CMD_IDLE;
> +	return c->scsi_cmd == NULL;
>  }
>  
>  /* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
> @@ -2445,7 +2441,12 @@ static void hpsa_cmd_resolve_events(struct ctlr_info *h,
>  	 * this command has completed.  Then, check to see if the handler is
>  	 * waiting for this command, and, if so, wake it.
>  	 */
> -	c->scsi_cmd = SCSI_CMD_IDLE;
> +	if (c->scsi_cmd && c->cmd_type == CMD_IOCTL_PEND) {
> +		struct scsi_cmnd *scmd = c->scsi_cmd;
> +
> +		scsi_put_reserved_cmd(scmd);
> +	}
> +	c->scsi_cmd = NULL;
>  	mb();	/* Declare command idle before checking for pending events. */
>  	if (dev) {
>  		atomic_dec(&dev->commands_outstanding);
> @@ -5502,7 +5503,6 @@ static void hpsa_cmd_init(struct ctlr_info *h, int index,
>  	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
>  	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
>  	c->h = h;
> -	c->scsi_cmd = SCSI_CMD_IDLE;
>  }
>  
>  static void hpsa_preinitialize_commands(struct ctlr_info *h)
> @@ -5803,6 +5803,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
>  	sh->max_lun = HPSA_MAX_LUN;
>  	sh->max_id = HPSA_MAX_LUN;
>  	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
> +	sh->nr_reserved_cmds = HPSA_NRESERVED_CMDS;

Now .nr_reserved_cmds has been passed to blk-mq, you need to increase
sh->can_queue to h->nr_cmds, because .can_queue is the whole queue depth
(include the part of reserved tags), otherwise, IO tags will be
decreased.

Not look into other drivers, I guess they need such change too.

Thanks,
Ming

