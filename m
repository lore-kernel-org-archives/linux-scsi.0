Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6E5C6379D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FC62236F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXpgvKpG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgKTHd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 02:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgKTHd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 02:33:27 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6870C0613CF;
        Thu, 19 Nov 2020 23:33:25 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id m9so6589816pgb.4;
        Thu, 19 Nov 2020 23:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=XHWcmf4j6qhvOy7PXXZw5LPjh7hOpfO4ojob44dbhos=;
        b=MXpgvKpGtgLcXZ5j5lzMgiyyuIaGKzfk16uiFw6IMgxcs/0I80FwlHhNF0ubMH4OGC
         0TlGo33N5ICV7+xD4VXAUpdAvE55HTb495HQuFGXKdfBmo5Wo6nXIErtgr4s2en9J5OI
         INeY6ZOGQwXaM/0R+xsh8bifo0vh7ieUfmws04nRb+HwRweVG0zZUIp2trFblenWk61w
         f1Ff2lwavAkUfY/8u2eL7ufVTZHz8PwU2wfvNQvQGGjS5B6oUt43Boqr7KepUZ3Q/Pne
         0BQrHHilDSTPzGvFV4wcFss61seB5THpTaxKgue/1JByVbScTuujNwTUNh5tYSh/DhHp
         XFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=XHWcmf4j6qhvOy7PXXZw5LPjh7hOpfO4ojob44dbhos=;
        b=czo5XwJx326tIdYm9iMt1dUVDAZHnPKC5dwlyW+yBXjNd6sxOoHC2mdgnLzdblDGrV
         /oGmFNrn22T3dabyLfQpg/+/HS3BF9hs0VZ7C8i5Xn4T4dj27Wt+HkoLzmQQV7E2Fz9q
         TaY7BKBVGCgbARbjwsD2qZ003ZkfqS/WLM9346vdMRSE9zQJlH8B7+ZwRy0fdvyGB9Ti
         qm+ZfaA5UeNSJ+meSKTOkUPzFdbSP21n09qeZjJxd4xqDVfUrxYszbEX6WmC0VYDD5bE
         6JFR/MXsPu2hrsq8n4gdJQ5RKqUUq/Bq7MoqwbC48u0NrcdLKzng9i3InOVlV9MAgUUm
         8YXA==
X-Gm-Message-State: AOAM533g0rSaEtOrZcz2fk444N4NCDCbTS46HSonj2Q7tTgIWfYHyrPo
        ONjqYGhhcX3U53+I8prvpTbRVjL4Bbo=
X-Google-Smtp-Source: ABdhPJy4rpj/NUdit36RmlX86JUPODfY3gN2irKzPV+X2QuZO3ooDLX1GLikLz53+SbvxdrSeLAq8A==
X-Received: by 2002:a17:90a:384e:: with SMTP id l14mr8901885pjf.104.1605857605322;
        Thu, 19 Nov 2020 23:33:25 -0800 (PST)
Received: from [192.168.1.101] (122-58-181-142-adsl.sparkbb.co.nz. [122.58.181.142])
        by smtp.gmail.com with ESMTPSA id h3sm2312527pfo.170.2020.11.19.23.33.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2020 23:33:24 -0800 (PST)
Subject: Re: [PATCH] scsi/NCR5380: Reduce NCR5380_maybe_release_dma_irq() call
 sites
To:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <978a807e-0cfa-47f3-cf3c-f262836022d5@gmail.com>
Date:   Fri, 20 Nov 2020 20:33:13 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

thanks for your patch!

Tested on Atari Falcon (with falconide, and pata_falcon modules).

Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

Am 20.11.2020 um 17:39 schrieb Finn Thain:
> Refactor to avoid needless calls to NCR5380_maybe_release_dma_irq().
> This makes the machine code smaller and the source more readable.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
>  drivers/scsi/NCR5380.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index ea4b5749e7da..d597d7493a62 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -725,7 +725,6 @@ static void NCR5380_main(struct work_struct *work)
>
>  			if (!NCR5380_select(instance, cmd)) {
>  				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
> -				maybe_release_dma_irq(instance);
>  			} else {
>  				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
>  				         "main: select failed, returning %p to queue\n", cmd);
> @@ -737,8 +736,10 @@ static void NCR5380_main(struct work_struct *work)
>  			NCR5380_information_transfer(instance);
>  			done = 0;
>  		}
> -		if (!hostdata->connected)
> +		if (!hostdata->connected) {
>  			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> +			maybe_release_dma_irq(instance);
> +		}
>  		spin_unlock_irq(&hostdata->lock);
>  		if (!done)
>  			cond_resched();
> @@ -1844,7 +1845,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					 */
>  					NCR5380_write(TARGET_COMMAND_REG, 0);
>
> -					maybe_release_dma_irq(instance);
>  					return;
>  				case MESSAGE_REJECT:
>  					/* Accept message by clearing ACK */
> @@ -1976,7 +1976,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
>  					cmd->result = DID_ERROR << 16;
>  					complete_cmd(instance, cmd);
> -					maybe_release_dma_irq(instance);
>  					return;
>  				}
>  				msgout = NOP;
> @@ -2312,7 +2311,6 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
>  	}
>
>  	queue_work(hostdata->work_q, &hostdata->main_task);
> -	maybe_release_dma_irq(instance);
>  	spin_unlock_irqrestore(&hostdata->lock, flags);
>
>  	return result;
> @@ -2368,7 +2366,6 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
>  	hostdata->dma_len = 0;
>
>  	queue_work(hostdata->work_q, &hostdata->main_task);
> -	maybe_release_dma_irq(instance);
>  }
>
>  /**
>
