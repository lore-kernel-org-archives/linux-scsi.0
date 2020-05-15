Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DF6C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BE5206D4
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cH0eZ15k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgEONGK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 09:06:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726166AbgEONGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 09:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589547968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=paa0os0A9FnZJ/bL0DHGodbLels2WxldoFg+KPT4YQY=;
        b=cH0eZ15kEPY5JXur043irshxHtXLIasAJMNSNElh54GnBoz/6HMXPPDk4xZM/rVHu/IN29
        Rgp9f7eK8utvkUVWPlg9li8tkG73Sk8d+glouF8amDZoBbqjM4h0kyiSPwo2SqE+Jm9rej
        9Hc6Z63NkJ2Ck4ORH4Rtw8FoYDE9kRk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509--VNF_jTlOmCu5LNXE3WM6A-1; Fri, 15 May 2020 09:06:07 -0400
X-MC-Unique: -VNF_jTlOmCu5LNXE3WM6A-1
Received: by mail-qt1-f197.google.com with SMTP id e43so2385565qtc.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 06:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=paa0os0A9FnZJ/bL0DHGodbLels2WxldoFg+KPT4YQY=;
        b=IKXFIll0qwQKShiLLdR0FZZiAgDbhkyS65q5fF1IEzBfIlbwPNq3N5GdZjAe1AyLN4
         zJoZDyvzlx6DJcNjgIWhhGn4fN4l3EvBrWgI9Er6VK2G/QbFxtq7aNC0AoFs1zZ54eyC
         fVzpS+XjC1bflMPjOzQfJmAWVLb+kig9u3Dr0pHg8u99+xNEmxgkvKHjgF9AZW17xaq4
         +5+S8eIr5nPDb97gXKpOKmexI7pW6rIVTxOIUH1EXKl3XioxCQFqhiYUOzOFwzPU4s0C
         Te1RSAbfMjFYy+5Lsm/wzX4P++1M/TugvksRdTTH5FG3h/OpkNJgi1f46PeSZxuNIxUR
         dClw==
X-Gm-Message-State: AOAM533EfbFVyDKDzUjNpv8wgjPWRAehkuQo7t3hdu7ylZJyYHqDcD1k
        LR4n2mF8jnras8wIBkXe48Oe37waHFsfSLsiOTL16srcILV+GVeVUcMup0pzsswppjoIVoHC93b
        8asGPVmbiOpvDBmIqPMwwIw==
X-Received: by 2002:ac8:341d:: with SMTP id u29mr3334548qtb.282.1589547966585;
        Fri, 15 May 2020 06:06:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4SYo3JN0HVdxNnp5WdHlI0NjfyGfvg0nvlTwdjUTJyiQ2P9x8x+jGS1WHsGJC97wSSs7VEA==
X-Received: by 2002:ac8:341d:: with SMTP id u29mr3334519qtb.282.1589547966281;
        Fri, 15 May 2020 06:06:06 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id n20sm1521511qkk.53.2020.05.15.06.06.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 06:06:05 -0700 (PDT)
Message-ID: <fe3e6ab8cfeb23dc46f0413ddfd47efe5e33df7f.camel@redhat.com>
Subject: Re: [PATCH] fnic: to not call 'scsi_done()' for unhandled commands
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Fri, 15 May 2020 09:06:04 -0400
In-Reply-To: <20200515112647.49260-1-hare@suse.de>
References: <20200515112647.49260-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-05-15 at 13:26 +0200, Hannes Reinecke wrote:
> The fnic drivers assigns an ioreq structure to each command, and
> severs this assignment once scsi_done() has been called and the
> command has been completed.
> So when traversing commands to terminate outstanding I/O we should
> not call scsi_done() on commands which do not have a corresponding
> ioreq structure; these commands have either never entered the driver
> or have already been completed.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c
> b/drivers/scsi/fnic/fnic_scsi.c
> index 27535c90b248..8d2798cbd30f 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1401,7 +1401,7 @@ static void fnic_cleanup_io(struct fnic *fnic,
> int exclude_id)
>  		}
>  		if (!io_req) {
>  			spin_unlock_irqrestore(io_lock, flags);
> -			goto cleanup_scsi_cmd;
> +			continue;
>  		}
>  
>  		CMD_SP(sc) = NULL;

Hi Hannes,
Thanks for this patch, but can you share what the impact was of this
issue.
What diod you see in logs/behavior

Regards
Laurence

