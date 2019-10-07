Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7B4C47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDFA52084D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfJGUpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbfJGUpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Oct 2019 16:45:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE1DC10C094A;
        Mon,  7 Oct 2019 20:45:45 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D051F5C219;
        Mon,  7 Oct 2019 20:45:44 +0000 (UTC)
Message-ID: <4ff5beeae5092d313d0e90a83f04a222400180f1.camel@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during
 state transitions
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Mon, 07 Oct 2019 16:45:44 -0400
In-Reply-To: <20191007135701.32389-1-hare@suse.de>
References: <20191007135701.32389-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 07 Oct 2019 20:45:45 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

See below.

On Mon, 2019-10-07 at 15:57 +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Some arrays are not capable of returning RTPG data during state
> transitioning, but rather return an 'LUN not accessible, asymmetric
> access state transition' sense code. In these cases we
> can set the state to 'transitioning' directly and don't need to
> evaluate the RTPG data (which we won't have anyway).
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 4971104b1817..f32da0ca529e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -512,6 +512,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
>  	unsigned long flags;
> +	bool transitioning_sense = false;
>  
>  	if (!pg->expiry) {
>  		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> @@ -572,13 +573,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			goto retry;
>  		}
>  		/*
> -		 * Retry on ALUA state transition or if any
> -		 * UNIT ATTENTION occurred.
> +		 * If the array returns with 'ALUA state transition'
> +		 * sense code here it cannot return RTPG data during
> +		 * transition. So set the state to 'transitioning' directly.
>  		 */
>  		if (sense_hdr.sense_key == NOT_READY &&
> -		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
> -			err = SCSI_DH_RETRY;
> -		else if (sense_hdr.sense_key == UNIT_ATTENTION)
> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
> +			transitioning_sense = true;
> +			goto skip_rtpg;
> +		}
> +		/*
> +		 * Retry on any other UNIT ATTENTION occurred.
> +		 */
> +		if (sense_hdr.sense_key == UNIT_ATTENTION)
>  			err = SCSI_DH_RETRY;
>  		if (err == SCSI_DH_RETRY &&
>  		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
> @@ -666,7 +673,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		off = 8 + (desc[7] * 4);
>  	}
>  
> + skip_rtpg:
>  	spin_lock_irqsave(&pg->lock, flags);
> +	if (transitioning_sense)
> +		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +
>  	sdev_printk(KERN_INFO, sdev,
>  		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
>  		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),

The patch itself looks OK, but I was wondering about a couple of things:

  - There are other places in scsi_dh_alua where the ASC/ASCQ 04 0A is checked
    and we retry, I understand that this is a particular case you are solving
    but is the changing of the state to -> transitioning (because that's what
    the device said the state was) applicable in those other cases?
  - The code originally seems to have been under the assumption that the
    transitioning state was a transient event, so the retry would pick up
    the eventual state.  Now, some storage arrays spend a long time in the
    transitioning state, but if we don't send another command are we going to
    get the sense (or the UA) that triggers entry to the eventual ALUA state?

-Ewan

