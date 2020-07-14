Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA68C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1097722507
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="I0PUQ3An";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ETJmUEU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGNQQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:16:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51448 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgGNQQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 12:16:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id EDFAB8EE2B2;
        Tue, 14 Jul 2020 09:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1594743387;
        bh=zj4zPpnz8gKFgQPcU3+Qo9Rl6yyucZ9c0mmOJtbRMEs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I0PUQ3AnoMDvtTqrRRadZJX4DR2mbkaipasHpp14RwY1g4CXmHSMUSXayLOGPBGvK
         xKM9Md1bpG175XS6BxTVhZGitZF49djqXssNXZev3N6oU8AUs8pIpADiysfXUdCkVm
         smh06sApGkkDNeqTNVDZi9zA+GlkgvG+SIENukIY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 54R1TIPtZajK; Tue, 14 Jul 2020 09:16:26 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DB6938EE272;
        Tue, 14 Jul 2020 09:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1594743386;
        bh=zj4zPpnz8gKFgQPcU3+Qo9Rl6yyucZ9c0mmOJtbRMEs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ETJmUEU39dXmBwJz5QOhySuA34Kuk5Gb+b5mX4f5O+pYi9+ruRJzYMXNn035Dw36j
         to6M5CnlfHteiXPDGDxbbQGX7qFl6GXPKVggqJxrGBZtuGoK4Is8N2vWTV8udjbvjf
         NHNgLpMx0IM6KbE/KE8tvZuHt3UZd+DUFU6niQVk=
Message-ID: <1594743384.4545.25.camel@HansenPartnership.com>
Subject: Re: [PATCH] aic79xx: restore modes when exiting
 ahd_linux_queue_abort_cmd()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Date:   Tue, 14 Jul 2020 09:16:24 -0700
In-Reply-To: <20200714160301.4482-1-hare@suse.de>
References: <20200714160301.4482-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-14 at 18:03 +0200, Hannes Reinecke wrote:
> ahd_linux_queue_abort_cmd() calls ahd_save_modes() without calling
> ahd_restore_modes() before exiting.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/aic7xxx/aic79xx_osm.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index dc4fe334efd0..abb5447f1de4 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -2147,7 +2147,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  	u_int  last_phase;
>  	u_int  saved_scsiid;
>  	u_int  cdb_byte;
> -	int    retval;
> +	int    retval = SUCCESS;
>  	int    was_paused;
>  	int    paused;
>  	int    wait;
> @@ -2185,8 +2185,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  		 * so we must not still own the command.
>  		 */
>  		scmd_printk(KERN_INFO, cmd, "Is not an active
> device\n");
> -		retval = SUCCESS;
> -		goto no_cmd;
> +		goto done;
>  	}
>  
>  	/*
> @@ -2199,7 +2198,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  
>  	if (pending_scb == NULL) {
>  		scmd_printk(KERN_INFO, cmd, "Command not found\n");
> -		goto no_cmd;
> +		goto done;
>  	}
>  
>  	if ((pending_scb->flags & SCB_RECOVERY_SCB) != 0) {
> @@ -2207,7 +2206,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  		 * We can't queue two recovery actions using the
> same SCB
>  		 */
>  		retval = FAILED;
> -		goto  done;
> +		goto done;
>  	}
>  
>  	/*
> @@ -2222,7 +2221,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  
>  	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
>  		scmd_printk(KERN_INFO, cmd, "Command already
> completed\n");
> -		goto no_cmd;
> +		goto done;
>  	}
>  
>  	printk("%s: At time of recovery, card was %spaused\n",
> @@ -2239,7 +2238,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  		printk("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
>  		       ahd_name(ahd), cmd->device->channel, 
>  		       cmd->device->id, (u8)cmd->device->lun);
> -		retval = SUCCESS;
>  		goto done;
>  	}
>  
> @@ -2336,17 +2334,10 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  	} else {
>  		scmd_printk(KERN_INFO, cmd, "Unable to deliver
> message\n");
>  		retval = FAILED;
> -		goto done;
>  	}
>  
> -no_cmd:
> -	/*
> -	 * Our assumption is that if we don't have the command, no
> -	 * recovery action was required, so we return
> success.  Again,
> -	 * the semantics of the mid-layer recovery engine are not
> -	 * well defined, so this may change in time.
> -	 */
> -	retval = SUCCESS;
> +
> +	ahd_restore_modes(ahd, saved_modes);
>  done:
>  	if (paused)
>  		ahd_unpause(ahd);

Yes, that looks correct to me ... is there any way to test it?

James

