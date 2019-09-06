Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE1AC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6AC2070C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 20:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391995AbfIFUbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 16:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37653 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389915AbfIFUbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 16:31:47 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11669C04D312
        for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2019 20:31:47 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id z4so7770083qts.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Sep 2019 13:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VlgZ8WsD8SbF6MxYJmL3ya3ZgfPmZqZSeeElj49Q3JY=;
        b=YVpgy7Lb3HrfXpPLY7kMSDiOr08MFXwuTk4Fc5yhJ8NzRCtUZIWYdC3H99lJVid3XH
         IF9WCX7fQfEVrJZA+H3B/3l2pJKq5o+KphGGif+8ShbZbLowCpDAOFy6ZYo4xqRh+7c/
         lTnFMP/XvyFhmnQh7mQVKOI2h/ETXtUYS91FtnZ+Z0rl48AU6gXF8kULn/ipnJXE6WW9
         MHQGW8ptBgBadd++UZiAsub1lv6vd40fkjWUD4wM7y1MZFTVS/tAWHBD/ZgdiuA7E0tI
         PiKgeoO2xAWxBGcUDo/Lc5NUr5xjTxvNpM5N9vSMMspxrHkOoqVJCqdiWp4zz5F2wxxH
         Riag==
X-Gm-Message-State: APjAAAXxX32+GaF4FLAJlWZaGUL0FyHtdGDV+zz96daY0ggJJvI7OpP2
        uju1JYm4jETY35utrAcfaHdhe/uTmuXBwOkNUsUT8Ws5+Lzbz9IfKdvqroIt+sxhHWD1ylgXN7H
        rfhrykg0IcvXY/99qKSoDWw==
X-Received: by 2002:a37:b001:: with SMTP id z1mr10690658qke.383.1567801906177;
        Fri, 06 Sep 2019 13:31:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxazcIreBdwsFMqbdDDEcUkHRqFnzTI+9pVflIZnsEzBEFZ5N3W3BLdoAoQ9r3Pg29zyCOwww==
X-Received: by 2002:a37:b001:: with SMTP id z1mr10690632qke.383.1567801905795;
        Fri, 06 Sep 2019 13:31:45 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id 43sm3275497qts.47.2019.09.06.13.31.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 13:31:45 -0700 (PDT)
Message-ID: <acf4dd808af45d5230dcdbcc5919f8869464625f.camel@redhat.com>
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or
 TASK_SET_FULL
From:   Laurence Oberman <loberman@redhat.com>
To:     QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Date:   Fri, 06 Sep 2019 16:31:44 -0400
In-Reply-To: <1567801579-18674-1-git-send-email-loberman@redhat.com>
References: <1567801579-18674-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-09-06 at 16:26 -0400, Laurence Oberman wrote:
> The qla2xxx driver had this issue as well when the newer array
> firmware returned the retry_delay_timer in the fcp_rsp.
> The bnx2fc is not handling the masking of the scope bits either
> so the retry_delay_timestamp value lands up being a large value
> added to the timer timestamp delaying I/O for up to 27 Minutes.
> This patch adds similar code to handle this to the
> bnx2fc driver to avoid the huge delay.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 9e50e5b..39f4aeb 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1928,6 +1928,7 @@ void bnx2fc_process_scsi_cmd_compl(struct
> bnx2fc_cmd *io_req,
>  	struct bnx2fc_rport *tgt = io_req->tgt;
>  	struct scsi_cmnd *sc_cmd;
>  	struct Scsi_Host *host;
> +	u16 scope, qualifier = 0;
>  
>  
>  	/* scsi_cmd_cmpl is called with tgt lock held */
> @@ -1997,12 +1998,28 @@ void bnx2fc_process_scsi_cmd_compl(struct
> bnx2fc_cmd *io_req,
>  
>  			if (io_req->cdb_status ==
> SAM_STAT_TASK_SET_FULL ||
>  			    io_req->cdb_status == SAM_STAT_BUSY) {
> +				/* Newer array firmware with BUSY or
> +				 * TASK_SET_FULL may return a status
> that needs
> +				 * the scope bits masked.
> +				 * Or a huge delay timestamp up to 27
> minutes
> +				 * can result.
> +				*/
> +				if (fcp_rsp->retry_delay_timer) {
> +					/* Upper 2 bits */
> +					scope = fcp_rsp-
> >retry_delay_timer
> +						& 0xC000;
> +					/* Lower 14 bits */
> +					qualifier = fcp_rsp-
> >retry_delay_timer
> +						& 0x3FFF;
> +				}
> +				if (scope > 0 && qualifier > 0 &&
> +					qualifier <= 0x3FEF) {
>  				/* Set the jiffies + retry_delay_timer
> * 100ms
>  				   for the rport/tgt */
> -				tgt->retry_delay_timestamp = jiffies +
> -					fcp_rsp->retry_delay_timer * HZ
> / 10;
> +					tgt->retry_delay_timestamp =
> jiffies +
> +						(qualifier * HZ / 10);
> +				}
>  			}
> -
>  		}
>  		if (io_req->fcp_resid)
>  			scsi_set_resid(sc_cmd, io_req->fcp_resid);

Hello 
Please add
Reported-by: David Jeffery <djeffery@redhat.com>
Apologies forgot to add that.

