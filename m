Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9096FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 22:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D4160FD9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 22:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhCaWa0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 18:30:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbhCaWaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 18:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617229807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PEADeqCRsJT/wFXk/aCXt5FrBulFfVtUYa0EjeJIAs=;
        b=J5b609XAxXeto5S2pMHlkVdB5ZOwNfZeBneG1iP2fL/5hiLrPVTJj6lkn33pbs874r7jNw
        M6FlbG+zPVxE1CAkFW5ExJHt1DbMhxafmHLvHB4T+xq9/7jZr97p7QgJKGXaE3fEBZ9Qbd
        2w/fB1XSInkOkXoG6U2Lhu901pRR+A0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-KMc6ZUKcN9ezP3kF4wP8Eg-1; Wed, 31 Mar 2021 18:30:04 -0400
X-MC-Unique: KMc6ZUKcN9ezP3kF4wP8Eg-1
Received: by mail-qv1-f69.google.com with SMTP id o14so2180258qvn.18
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 15:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4PEADeqCRsJT/wFXk/aCXt5FrBulFfVtUYa0EjeJIAs=;
        b=t/+gPHVl09FjEc/YxVoGopVSReXW7G00GkFMMQ8qH/oGpsgGxvS+hNA2Wm2+2R6HGY
         eEwX54QnNmGAH0z5nSR1gRxVM8jczEcUTh6Io6VuacbqrmdcF6kCMoByhZWoKG0T2qXt
         /tcXDPIq4dLoHqYB/FZD9grobZXHXe7K1Fubap/9Cd+bN7SiUETwJIPdz60IaN+mCc3D
         ufzL5UpvGI7YnbejHNJo8wTBZP1XOnIuU6PJyslHY4FrfBWtX9cWjHJOKghliK/6vZXS
         SrkrsCQO45QsIH6j/lSjPqGHh0rhNFKabIdQm3p7MHcAHdP+QgxWaD0497Hrz24FHBrT
         RzGQ==
X-Gm-Message-State: AOAM533SHIE09SeGSLEL3UpZCnlzhbytKZHWirwmvKV3PYNlhIK3RKNB
        5eJEV6o55Lbjhvp3Fg+dh+1Q0Wc3fxKcfa9Jjm4jPbOooV0cBMX8d3DTAlbaVq/n3VQKO/L5hC7
        3UjSpRUp1TApOCw0Be39pTA==
X-Received: by 2002:ad4:5c4c:: with SMTP id a12mr5397030qva.11.1617229804046;
        Wed, 31 Mar 2021 15:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/ivlY8XT2cKWD/9pNaOa53BjO0acuP2xYqMkmq+GzLBu8XbKYg/4+Qm4zE+2Bg7ipDLB2yQ==
X-Received: by 2002:ad4:5c4c:: with SMTP id a12mr5397015qva.11.1617229803803;
        Wed, 31 Mar 2021 15:30:03 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id q65sm2531946qkb.51.2021.03.31.15.30.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Mar 2021 15:30:03 -0700 (PDT)
Message-ID: <ae4f3790e24ad686bb19112ab1eff60799c0c71e.camel@redhat.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: prevent duplicate pg info print in
 alua_rtpg()
From:   Laurence Oberman <loberman@redhat.com>
To:     John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, hare@suse.de, emilne@redhat.com,
        djeffery@redhat.com, linux-scsi@vger.kernel.org
Date:   Wed, 31 Mar 2021 18:30:01 -0400
In-Reply-To: <20210331181656.5046-1-jpittman@redhat.com>
References: <20210331181656.5046-1-jpittman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-31 at 14:16 -0400, John Pittman wrote:
> Due to the frequency that alua_rtpg() is called, the path group
> info print within can print the same info multiple times in the
> logs, subsequent prints adding no new information or value.
> 
> To reproduce:
> 
>     # modprobe scsi_debug vpd_use_hostno=0
>     # systemctl start multipathd.service
> 
> To fix, check stored values, only printing at alua attach/activate
> and if any of the values change.
> 
> Signed-off-by: John Pittman <jpittman@redhat.com>
> Reviewed-by: David Jeffery <djeffery@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 30 ++++++++++++++----
> ----
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index ea436a14087f..7438ed491681 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -515,6 +515,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  	struct scsi_sense_hdr sense_hdr;
>  	struct alua_port_group *tmp_pg;
>  	int len, k, off, bufflen = ALUA_RTPG_SIZE;
> +	int group_id_old, state_old, pref_old, valid_states_old;
>  	unsigned char *desc, *buff;
>  	unsigned err, retval;
>  	unsigned int tpg_desc_tbl_off;
> @@ -522,6 +523,11 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  	unsigned long flags;
>  	bool transitioning_sense = false;
>  
> +	group_id_old = pg->group_id;
> +	state_old = pg->state;
> +	pref_old = pg->pref;
> +	valid_states_old = pg->valid_states;
> +
>  	if (!pg->expiry) {
>  		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT *
> HZ;
>  
> @@ -686,17 +692,19 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>  	if (transitioning_sense)
>  		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
>  
> -	sdev_printk(KERN_INFO, sdev,
> -		    "%s: port group %02x state %c %s supports
> %c%c%c%c%c%c%c\n",
> -		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg-
> >state),
> -		    pg->pref ? "preferred" : "non-preferred",
> -		    pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> -		    pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> -		    pg-
> >valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> -		    pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> -		    pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> -		    pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> -		    pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> +	if (group_id_old != pg->group_id || state_old != pg->state ||
> +		pref_old != pg->pref || valid_states_old != pg-
> >valid_states)
> +		sdev_printk(KERN_INFO, sdev,
> +			"%s: port group %02x state %c %s supports
> %c%c%c%c%c%c%c\n",
> +			ALUA_DH_NAME, pg->group_id,
> print_alua_state(pg->state),
> +			pg->pref ? "preferred" : "non-preferred",
> +			pg-
> >valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> +			pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> +			pg-
> >valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> +			pg-
> >valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> +			pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> +			pg-
> >valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> +			pg-
> >valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
>  
>  	switch (pg->state) {
>  	case SCSI_ACCESS_STATE_TRANSITIONING:

Thanks John
I am still trying to find a way to quiet the SCSI discovery in an
acceptable way but every bit helps.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

