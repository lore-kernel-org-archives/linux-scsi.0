Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5388C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 15:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAFE6206B5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 15:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHIP0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 11:26:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37029 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726175AbgHIP0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 11:26:44 -0400
Received: (qmail 277409 invoked by uid 1000); 9 Aug 2020 11:26:43 -0400
Date:   Sun, 9 Aug 2020 11:26:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200809152643.GA277165@rowland.harvard.edu>
References: <20200729182515.GB1580638@rowland.harvard.edu>
 <1596047349.4356.84.camel@HansenPartnership.com>
 <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
 <20200730151030.GB6332@rowland.harvard.edu>
 <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 09, 2020 at 11:20:22AM +0200, Martin Kepplinger wrote:
> Hey Alan, I'm really glad for that, I suspected some of this but I have
> little experience in scsi/block layers, so that is super helpful.
> 
> I'd appreciate an opinion on the below workaround that *seems* to work
> now (let's see, I had thought so before :)
> 
> Whether or not this helps to find a real solution, let's see. But
> integration of such a flag in the error handling paths is what's
> interesting for now:
> 
> 
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -565,6 +565,17 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>  				return NEEDS_RETRY;
>  			}
>  		}
> +		if (scmd->device->expecting_media_change) {
> +			if (sshdr.asc == 0x28 && sshdr.ascq == 0x00) {
> +				/* clear expecting_media_change in
> +				 * scsi_noretry_cmd() because we need
> +				 * to override possible "failfast" overrides
> +				 * that block readahead can cause.
> +				 */
> +				return NEEDS_RETRY;

This is a somewhat fragile approach.  You don't know for certain that 
scsi_noretry_cmd will be called.  Also, scsi_noretry_cmd can be called 
from other places.

It would be better to clear the expecting_media_change flag just before 
returning from scsi_decide_disposition.  That way its use is localized 
to one routine, not spread out between two.

Alan Stern
