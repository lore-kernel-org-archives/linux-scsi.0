Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551DCC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324376023F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhHQM0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:26:46 -0400
Received: from verein.lst.de ([213.95.11.211]:58323 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236683AbhHQM0p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 08:26:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D8FEB67357; Tue, 17 Aug 2021 14:26:09 +0200 (CEST)
Date:   Tue, 17 Aug 2021 14:26:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 07/51] megaraid: pass in NULL scb for host reset
Message-ID: <20210817122609.GF30436@lst.de>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-8-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-8-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2021 at 11:14:12AM +0200, Hannes Reinecke wrote:
> When calling a host reset we shouldn't rely on the command triggering
> the reset, so allow megaraid_abort_and_reset() to be called with a
> NULL scb.
> And drop the pointless 'bus_reset' and 'target_reset' handlers, which
> just call the same function as host_reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/megaraid.c | 42 ++++++++++++++++-------------------------
>  1 file changed, 16 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 56910e94dbf2..7c53933fb1b4 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1905,7 +1905,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
>  
>  	spin_lock_irq(&adapter->lock);
>  
> -	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
> +	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
>  
>  	/*
>  	 * This is required here to complete any completed requests
> @@ -1944,7 +1944,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
>  
>  		scb = list_entry(pos, scb_t, list);

Ther's a dev_warn before this, which dereferences cmd.

> -		if (scb->cmd == cmd) { /* Found command */
> +		if (!cmd || scb->cmd == cmd) { /* Found command */
>  
>  			scb->state |= aor;

But more importantly, this function doesn't make much sense for the
!cmd case, as it doesn't really do anything when not matched. It
seems like the legacy megaraid driver should just stop calling it
for resets.
