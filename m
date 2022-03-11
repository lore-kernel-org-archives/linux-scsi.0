Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B9EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Mar 2022 19:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiCKTNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Mar 2022 14:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiCKTNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2022 14:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8CB145505
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2022 11:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647025960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUJgbPUkn/ugs+oMdDq9n0bZA2pAD5H0fjDb7MwDUKc=;
        b=C/TEakDDpwjWpBm7tP386I+Ijp2AlaWMqmXIHug1VqcPWSCdtpRO6mN7Pi+GW5JHu8RDCj
        md9sqFEXwssvr0vxq/C8JZIs/4RjxqH1if/Xqa9uqhx5Ph4UULFGaUE9g+6otiiB2Zief+
        GQDJAXt5aWxTFVbi0Sf7HQaWrSewgz8=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-VbvjmtSAMEaiSPB2oq0gHA-1; Fri, 11 Mar 2022 14:12:38 -0500
X-MC-Unique: VbvjmtSAMEaiSPB2oq0gHA-1
Received: by mail-oo1-f71.google.com with SMTP id 7-20020a4a0007000000b0031d5b7742c6so7382501ooh.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2022 11:12:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUJgbPUkn/ugs+oMdDq9n0bZA2pAD5H0fjDb7MwDUKc=;
        b=QHU9B95S5lHd9ymuoXGc9xtavm+3e3K5TVDbFAKnmr2OW0Tr3woL1yZNdhfEanKbhp
         IHS+X5scq45+BjhC/9uGGnSXCG9isKIm+Gf846z3qG285mchDKMyn9crV9iUZ0vJm19r
         XiZLsFEkCRTHT5vSwvbT13VQy/I9FzRX0dgLtqyuhp+B9MdNhS/6C1/t3cH4VIJ2etku
         XTvFHEUfzp/chSyihrqhiuFfth7Tq8514fgTXryqRfFOyU/DMXtsb6d6j/00c9Pfp/y1
         KJBCukjgYL3Xww75O0dewMW1pMOcOKOEaAD+LWurSpCRzYD/y+76EJ9cLVm2UI3KErUc
         v2ag==
X-Gm-Message-State: AOAM531ljK2/X5Crgybn7av6f72y3iadKVURPXLNgJWE2YqHSjBnulMB
        I+cjRW5cBm+PSdSfz/zDi4YuqozSGvMSAR9RxyTBgU3UWuVcD1O1O/W22Sx7fY3Ym6hIBR70yhk
        KdbRlCKxB5d9pdXnO5wfZJg==
X-Received: by 2002:a05:6808:11c3:b0:2d9:a01a:4ba4 with SMTP id p3-20020a05680811c300b002d9a01a4ba4mr7951083oiv.203.1647025957916;
        Fri, 11 Mar 2022 11:12:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxb+9C1JLEITbBQHjnnS4+yKuWpFbl6KQCgcW4xJNpUjQbsGJXV+suRGiJ1M7GHYKLsDW2XIA==
X-Received: by 2002:a05:6808:11c3:b0:2d9:a01a:4ba4 with SMTP id p3-20020a05680811c300b002d9a01a4ba4mr7951063oiv.203.1647025957599;
        Fri, 11 Mar 2022 11:12:37 -0800 (PST)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id w1-20020a056808090100b002da82caced5sm1738787oih.3.2022.03.11.11.12.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 11:12:37 -0800 (PST)
Message-ID: <194418c3984fa9b19aae1eff781097e88b003892.camel@redhat.com>
Subject: Re: [PATCH] fnic: finish scsi_cmnd before dropping the spinlock to
 prevent abort race
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, linux-scsi@vger.kernel.org
Cc:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        John Pittman <jpittman@redhat.com>
Date:   Fri, 11 Mar 2022 14:12:35 -0500
In-Reply-To: <20220311184359.2345319-1-djeffery@redhat.com>
References: <20220311184359.2345319-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-03-11 at 13:43 -0500, David Jeffery wrote:
> When aborting a scsi command through fnic, there is a race with the
> fnic
> interrupt handler which can result in the scsi command and its
> request
> being completed twice. If the interrupt handler claims the command by
> setting CMD_SP to NULL first, the abort handler assumes the interrupt
> handler has completed the command and returns SUCCESS, causing the
> request
> for the scsi_cmnd to be re-queued.
> 
> But the interrupt handler may not have finished the command yet.
> After it
> drops the spinlock protecting CMD_SP, it does memory cleanup before
> finally calling scsi_done to complete the scsi_cmnd. If the call to
> scsi_done occurs after the abort handler finishes and re-queues the
> request, the completion of the scsi_cmnd will advance and try to
> double
> complete a request already queued for retry.
> 
> This patch fixes the issue by moving scsi_done and any other use of
> scsi_cmnd to before the spinlock is released by the interrupt
> handler.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c
> b/drivers/scsi/fnic/fnic_scsi.c
> index 88c549f257db..40a52feb315d 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -986,8 +986,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct
> fnic *fnic,
>  	CMD_SP(sc) = NULL;
>  	CMD_FLAGS(sc) |= FNIC_IO_DONE;
>  
> -	spin_unlock_irqrestore(io_lock, flags);
> -
>  	if (hdr_status != FCPIO_SUCCESS) {
>  		atomic64_inc(&fnic_stats->io_stats.io_failures);
>  		shost_printk(KERN_ERR, fnic->lport->host, "hdr status =
> %s\n",
> @@ -996,8 +994,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct
> fnic *fnic,
>  
>  	fnic_release_ioreq_buf(fnic, io_req, sc);
>  
> -	mempool_free(io_req, fnic->io_req_pool);
> -
>  	cmd_trace = ((u64)hdr_status << 56) |
>  		  (u64)icmnd_cmpl->scsi_status << 48 |
>  		  (u64)icmnd_cmpl->flags << 40 | (u64)sc->cmnd[0] << 32
> |
> @@ -1021,6 +1017,12 @@ static void
> fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
>  	} else
>  		fnic->lport->host_stats.fcp_control_requests++;
>  
> +	/* Call SCSI completion function to complete the IO */
> +	scsi_done(sc);
> +	spin_unlock_irqrestore(io_lock, flags);
> +
> +	mempool_free(io_req, fnic->io_req_pool);
> +
>  	atomic64_dec(&fnic_stats->io_stats.active_ios);
>  	if (atomic64_read(&fnic->io_cmpl_skip))
>  		atomic64_dec(&fnic->io_cmpl_skip);
> @@ -1049,9 +1051,6 @@ static void
> fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
>  		if(io_duration_time > atomic64_read(&fnic_stats-
> >io_stats.current_max_io_time))
>  			atomic64_set(&fnic_stats-
> >io_stats.current_max_io_time, io_duration_time);
>  	}
> -
> -	/* Call SCSI completion function to complete the IO */
> -	scsi_done(sc);
>  }
>  
>  /* fnic_fcpio_itmf_cmpl_handler

This patch was also presented to Ming who agreed with David's changes.
Its been sent to a customer for full testing to see if it avoids the
panics.
The trigger is a sequence of these and then we get the double
completion. WHile its not easy to reproduce and not often seen this
customer can make it happen at will it seems.

[1363787.139752] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH
[1363787.139822] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH
[1363787.139870] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH
[1363787.139916] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH
[1363787.139961] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH
[1363787.140006] scsi host7: hdr status = FCPIO_DATA_CNT_MISMATCH

Reviewed-by: Laurence Oberman <loberman@redhat.com>

Thanks very much

