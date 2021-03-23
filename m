Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7B4C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 18:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979A2619B9
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 18:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCWSb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 14:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbhCWSb0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 14:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616524283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xn4UgpP+FvcJjEuobQEYzp1fw7++buI2wZ97m40oBEI=;
        b=NB+SbffsDCql7xhspivMJLURl06+DsNJrpFI135XrzggOC61RN5KnaUsINK+Vhsi+7igKT
        KKOYRLbIGcLJ+0vf25H4y02QTaS45YzxCwQ/nhWMx/KHfRxyQDElK01nfJX7VMTPNy6pbN
        VOchArjO9E8dh+dW5KQbeOoNYUaqJ7g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-fVIT5KvtMqmtTbNrFn5S_g-1; Tue, 23 Mar 2021 14:31:21 -0400
X-MC-Unique: fVIT5KvtMqmtTbNrFn5S_g-1
Received: by mail-qt1-f197.google.com with SMTP id f8so1744274qtv.22
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 11:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xn4UgpP+FvcJjEuobQEYzp1fw7++buI2wZ97m40oBEI=;
        b=ctJYZqVdehtWFJB3gKa4ol28TAZmu9HzeU56IKdVNHuIXHS9XZi+4oqIpEpgy+MIZl
         LB3/SscoiZJD3Ui4MlJAMaCMtAqWZVu1uwrdPPWzWpvM5W4DmwDiuyUup32lu7gNbMN4
         1OBAGC1YgvkeMW4AOQOIzA9OjxZS2NJgHVE1MFnnfJoAqpe75Fy2cMDvVmH0NAWtXLCx
         0Nh8sx0r3hPineVgh3hosqOMaK3QM/9nBZiRz/A0uvefxugZaXOJhcCMevlxAUarp/2G
         y2kcRkZ0TL85teEuxkUM1xqAqXNlM0fmnOJucATz0agE1VbYPI2lEVhK1TfmLDJRz/Li
         zAkw==
X-Gm-Message-State: AOAM531Gmr3y0Kx10eU43ED460ZALFqcHlnU1RHUuK0TPv5A/QYGIeg0
        C1xSY18hc27QGoysapAd5vQy5D42rKEqNti6SwduVCU0YS+4qfiLtEPwN3drbxkSzGc76UP8y+Q
        KA82dD5t+lSnwMNwo78jELA==
X-Received: by 2002:a05:620a:553:: with SMTP id o19mr6862882qko.491.1616524280814;
        Tue, 23 Mar 2021 11:31:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykxAOl9MYg9YcBSkMc95TO31RASKOqkjMasP70iV2fLleH1vl2V3ze/R2yMEbLbRVQtZx30Q==
X-Received: by 2002:a05:620a:553:: with SMTP id o19mr6862861qko.491.1616524280591;
        Tue, 23 Mar 2021 11:31:20 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id 1sm11109638qtw.3.2021.03.23.11.31.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 11:31:20 -0700 (PDT)
Message-ID: <60b33e8926d188498fba980115cb3c681a18b8b1.camel@redhat.com>
Subject: Re: [PATCH] Fix fnic driver to remove bogus ratelimit messages.
From:   Laurence Oberman <loberman@redhat.com>
To:     lduncan@suse.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 23 Mar 2021 14:31:19 -0400
In-Reply-To: <20210323172756.5743-1-lduncan@suse.com>
References: <20210323172756.5743-1-lduncan@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-23 at 10:27 -0700, lduncan@suse.com wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> Commit b43abcbbd5b1 ("scsi: fnic: Ratelimit printks to avoid
> looding when vlan is not set by the switch.i") added
> printk_ratelimit() in front of a couple of debug-mode
> messages, to reduce logging overrun when debugging the
> driver. The code:
> 
> >           if (printk_ratelimit())
> >                   FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> >                             "Start VLAN Discovery\n");
> 
> ends up calling printk_ratelimit() quite often, triggering
> many kernel messages about callbacks being surpressed.
> 
> The fix is to decompose FNIC_FCS_DBG(), then change the order
> of checks so that printk_ratelimit() is only called if
> driver debugging is enabled.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/fnic/fnic_fcs.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_fcs.c
> b/drivers/scsi/fnic/fnic_fcs.c
> index e0cee4dcb439..332b31493e79 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -1343,9 +1343,10 @@ void fnic_handle_fip_timer(struct fnic *fnic)
>  	if (list_empty(&fnic->vlans)) {
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		/* no vlans available, try again */
> -		if (printk_ratelimit())
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Start VLAN Discovery\n");
> +		if (unlikely(fnic_log_level & FNIC_FCS_LOGGING))
> +			if (printk_ratelimit())
> +				shost_printk(KERN_DEBUG, fnic->lport-
> >host,
> +						"Start VLAN
> Discovery\n");
>  		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
>  		return;
>  	}
> @@ -1363,9 +1364,10 @@ void fnic_handle_fip_timer(struct fnic *fnic)
>  	case FIP_VLAN_FAILED:
>  		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
>  		/* if all vlans are in failed state, restart vlan disc
> */
> -		if (printk_ratelimit())
> -			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> -				  "Start VLAN Discovery\n");
> +		if (unlikely(fnic_log_level & FNIC_FCS_LOGGING))
> +			if (printk_ratelimit())
> +				shost_printk(KERN_DEBUG, fnic->lport-
> >host,
> +					  "Start VLAN Discovery\n");
>  		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
>  		break;
>  	case FIP_VLAN_SENT:

This looks good to me.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

