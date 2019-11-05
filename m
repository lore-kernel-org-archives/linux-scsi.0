Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C025C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B78321D7C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389062AbfKEQ52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:57:28 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37461 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388836AbfKEQ50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 11:57:26 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so9472826pfn.4
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 08:57:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cPQpCe/hg2ertqhCThiWfX4p9UYhfsrUkQvTp6MEvEw=;
        b=H9dDlmSuY71YRgEsP2Sas6qDe2tEaODaoFZpNIUTjKhvE/h325xuG8OLgB7mt+1qEs
         qdKwoJ1u8+pTjIBfWPWrINHFGffZcgughQG07fagSslNZhR6Rget83ryTajT0OuPmft2
         hGe/Va4n7yVahpZuk32MdBqw4q/7HiDYV8v0+wXJ5boyuDvGOSIA4cc5vTf2QJ4w0u8J
         8pNKylemHHDlpszziQUdp2AiUYdldrGgXv65KaRr4zkwWdKss8V6wyU7UzfVHKQmm1uT
         xUJaPBuo/qWifGCc/3caqXAdK5f21Mw3nLS0dW1sV2T8BaH2VrCaIiF/nbpxG/RcBXTM
         vqCQ==
X-Gm-Message-State: APjAAAXYXepsaNKhdTlCDD2JMknNzj1mrt1Wv2KlYY58afaKtYZ9PPF/
        WDAN9tbepxJtKI/DoRy6+ukKJejU
X-Google-Smtp-Source: APXvYqzYG8M0pdPciThx6WovO3SKtOZeWmJLyXpq+UIrsLASUF7zOVJMPb6ckxXHF158OUM0eHzkdQ==
X-Received: by 2002:a63:6247:: with SMTP id w68mr36413875pgb.283.1572973045322;
        Tue, 05 Nov 2019 08:57:25 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m68sm19619019pfb.122.2019.11.05.08.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 08:57:24 -0800 (PST)
Subject: Re: [PATCH 2/8] qla2xxx: Do command completion on abort timeout
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-3-hmadhani@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <51483fdc-f102-0a08-7c19-d3e9f1792a86@acm.org>
Date:   Tue, 5 Nov 2019 08:57:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105150657.8092-3-hmadhani@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/19 7:06 AM, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> On switch, fabric and mgt command timeout, driver
> send Abort to tell FW to return the original command.
> If abort is timeout, then return both Abort and
> original command for cleanup.
> 
> Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
> Cc: stable@vger.kernel.org # 5.2
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |  1 +
>   drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 721ee7f09b39..ef9bb3c7ad6f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -604,6 +604,7 @@ typedef struct srb {
>   	const char *name;
>   	int iocbs;
>   	struct qla_qpair *qpair;
> +	struct srb *cmd_sp;
>   	struct list_head elem;
>   	u32 gen1;	/* scratch */
>   	u32 gen2;	/* scratch */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 5db8ad832893..7fdbe041cc19 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -101,8 +101,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
>   	u32 handle;
>   	unsigned long flags;
>   
> +	if (sp->cmd_sp)
> +		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
> +		    "Abort timeout - cmd hdl=%x, cmd type=%x hdl=%x, type=%x\n",
> +		    sp->cmd_sp->handle, sp->cmd_sp->type,
> +		    sp->handle, sp->type);
> +	else
> +		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
> +		    "Abort timeout 2 - hdl=%x, type=%x\n",
> +		    sp->handle, sp->type);
> +
>   	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
>   	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
> +		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
> +		    sp->cmd_sp))
> +			qpair->req->outstanding_cmds[handle] = NULL;
> +
>   		/* removing the abort */
>   		if (qpair->req->outstanding_cmds[handle] == sp) {
>   			qpair->req->outstanding_cmds[handle] = NULL;
> @@ -111,6 +125,9 @@ static void qla24xx_abort_iocb_timeout(void *data)
>   	}
>   	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>   
> +	if (sp->cmd_sp)
> +		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
> +
>   	abt->u.abt.comp_status = CS_TIMEOUT;
>   	sp->done(sp, QLA_OS_TIMER_EXPIRED);
>   }
> @@ -142,6 +159,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
>   	sp->type = SRB_ABT_CMD;
>   	sp->name = "abort";
>   	sp->qpair = cmd_sp->qpair;
> +	sp->cmd_sp = cmd_sp;
>   	if (wait)
>   		sp->flags = SRB_WAKEUP_ON_COMP;
>   

After an abort SRB has been submitted it can happen that the command 
that should be aborted (cmd_sp) completes before the abort SRB 
completes. I think in that case sp->cmd_sp should be cleared. However, I 
don't see the code that does that in the above patch.

Since the block layer already keeps track of which commands are 
outstanding, is it really necessary to add the 'cmd_sp' pointer in 
struct srb? Has it been considered to use blk_mq_tagset_busy_iter() 
instead of iterating over qpair->req->num_outstanding_cmds in 
qla24xx_abort_iocb_timeout()?

Thanks,

Bart.


