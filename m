Return-Path: <SRS0=Kiby=XD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F363DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Sep 2019 01:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB91321744
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Sep 2019 01:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X2VBoUAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfIHBeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 21:34:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34696 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfIHBeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2019 21:34:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id q203so9496373qke.1
        for <linux-scsi@vger.kernel.org>; Sat, 07 Sep 2019 18:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=t2tCXr+rQW3G+6RNjEpmmij3AcIWG4tEbrIEiAA3Oz0=;
        b=X2VBoUAR71RSX4ccusG2JIsilqLDbZp2VlyX3n5YMJjmsI7TgkfiWYbsb3DnVSfyRD
         Menk6IEI9e2gfdfS6urBBGeVAshvcb0w6hCcOa2MsjUNsuyLCvPnHT7CQupDT/DSuk1u
         7q3PLrJat9SGRel0+hWUl3GgpY6caZDCFE8nu6J8eF/oZ96sLdzWdtmaLPS1RUoYKUQ4
         QqM9lDUsBj5Wsv0uII2y3zsWaNaT7DpU8qNTU84GV72/WRowM8RA+UzZ+Cycin2d4WRt
         Jzwc7yk0iTK1wquZT1w+mcIeGwd+RbovYm9LfH5cilaXYHYGuN2xLn2KMAeq4F+F0GGu
         kL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=t2tCXr+rQW3G+6RNjEpmmij3AcIWG4tEbrIEiAA3Oz0=;
        b=AyMjIwvZ/82J8cMG8I5QTehgT0sXAXMYR+cofDa193ElKryPtahLJLVIG7ZjdCt5My
         hfur9sWXfImsqhCR2JE4RZ8DrdPtVgtGTDcR7HE9Xj9T0oh6yAmebOkR1ZiROkibq98B
         Ikgqgo/8d6YTK8WXD+JcjJDyH2dHPQFC3MgEOx9w+BLVQiA8FWmEJ1m/m5SY1SXnE0gE
         gyWCXLYwQTpzI7U+WmNFI33AkOcWRNEN7zgFbTsmMSClShAUmloReAJS21bBYf+Qwv62
         AsDj8aeGgm7fU2zxdx4QDxPig4xbVX4nnlH+xAo55+uNwO5eA0PPwAoxvc/tvKQ/exxi
         zD/A==
X-Gm-Message-State: APjAAAXMub12sAsNREUB2gyK2Nt9EIlwz0CReK6ys35sH5jpovodsAvK
        x3n7SZYhMuU0pKyJvl740AU=
X-Google-Smtp-Source: APXvYqyOEjVOA1/dLIM6uJIUJ4FG5u5ymHSpPpQu4c6YoXV8+opCiPl3avoFyofAV5O68V6nzupo3w==
X-Received: by 2002:a37:49d6:: with SMTP id w205mr16590396qka.191.1567906445860;
        Sat, 07 Sep 2019 18:34:05 -0700 (PDT)
Received: from localhost.localdomain (pool-96-230-166-208.prvdri.fios.verizon.net. [96.230.166.208])
        by smtp.gmail.com with ESMTPSA id g194sm5054342qke.46.2019.09.07.18.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 18:34:05 -0700 (PDT)
Message-ID: <99d3265e65c6ca84e06a631caa276710ae9d27e2.camel@gmail.com>
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or
 TASK_SET_FULL
From:   cdupuis1@gmail.com
To:     Laurence Oberman <loberman@redhat.com>,
        QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Date:   Sat, 07 Sep 2019 21:34:04 -0400
In-Reply-To: <1567801579-18674-1-git-send-email-loberman@redhat.com>
References: <1567801579-18674-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
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

What better thing to be doing than reviewing patches on a Saturday
evening.  Looks good though I might suggest moving the indent of the
comment in the new if statement.

Reviewed-by: Chad Dupuis <cdupuis1@gmail.com>

