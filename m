Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8174C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 02:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357427AbiAaCxX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Jan 2022 21:53:23 -0500
Received: from mail-yb1-f180.google.com ([209.85.219.180]:34648 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357393AbiAaCxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jan 2022 21:53:23 -0500
Received: by mail-yb1-f180.google.com with SMTP id v186so36424045ybg.1
        for <linux-scsi@vger.kernel.org>; Sun, 30 Jan 2022 18:53:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X2ByXqY8SAtMkZW8KqtDJFCkpShtlCSLeaWI7zW6E0I=;
        b=IAPMAsj/g41x4MUluC1LyYoYAr0MJg+trJDjr+9G0t02/GRgATPuAYxtRjBJXsgfzB
         ihN79SZH17VIjt2cIxiuNxYpNOXEuT5sAajOCaSt1lUupXo4/PGlMx/bvw8PWXV9ESg8
         XN2JomOLdKw8aedpadigL3Z5tRJ+5KvIYoF3WVlaEC6jveNoHXD2HleyBugQ3GsIh5z9
         SlWxMH2GiR/G08SmuIrX2l2mSXx1vqDKi8iehZUWR+yjrYtTRfl+gbt+W0n6EpqfwrQF
         W7YtxcnR+qyhG1vE2XFYFlX3JO/xL/ZC7NIm4oE6EWZ30ZVZ8LtZgjhTEaLJSdy0OV3G
         19fg==
X-Gm-Message-State: AOAM533dyBoCeIHXB5Zdps8h53BG/dg193ux8XJsb617r9K6wPn77gui
        y1T8JXnbDRMSNUqjE17SGD3Z7O+QkCM4T2N2iBM=
X-Google-Smtp-Source: ABdhPJzQKiVvGKHHuuKmz5/I9MkPHDFdm8Wd/AWFiALSdRhA/MSHhxy9BRlgZ0CpxQFYFroMldDychSUJaMNlwnC6d4=
X-Received: by 2002:a25:4742:: with SMTP id u63mr25694931yba.523.1643597602102;
 Sun, 30 Jan 2022 18:53:22 -0800 (PST)
MIME-Version: 1.0
References: <20220128221909.8141-1-bvanassche@acm.org> <20220128221909.8141-33-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-33-bvanassche@acm.org>
From:   Masanori Goto <gotom@debian.or.jp>
Date:   Mon, 31 Jan 2022 11:53:11 +0900
Message-ID: <CALZLnaFmbbyPRwFUE_RfpxuxN95dfsaE5EKdTmnnUy-=+8Q9TA@mail.gmail.com>
Subject: Re: [PATCH 32/44] nsp32: Stop using the SCSI pointer
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is my style, but I prefer retaining DID_OK, even though it's 0 -
to make sure we fill the right field.  Could you retain the DID_OK <<
16 part?

2022年1月29日(土) 7:21 Bart Van Assche <bvanassche@acm.org>:
>
> Move the SCSI status field to private data. Stop setting the .ptr,
> .this_residual, .buffer and .buffer_residual SCSI pointer members
> since no code in this driver reads these members.
>
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/nsp32.c | 21 +++++++--------------
>  drivers/scsi/nsp32.h |  9 +++++++++
>  2 files changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index bd3ee3bf08ee..6ae394b39121 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -273,6 +273,7 @@ static struct scsi_host_template nsp32_template = {
>         .eh_abort_handler               = nsp32_eh_abort,
>         .eh_host_reset_handler          = nsp32_eh_host_reset,
>  /*     .highmem_io                     = 1, */
> +       .cmd_size                       = sizeof(struct nsp32_cmd_priv),
>  };
>
>  #include "nsp32_io.h"
> @@ -946,14 +947,9 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt)
>         show_command(SCpnt);
>
>         data->CurrentSC      = SCpnt;
> -       SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
> +       nsp32_priv(SCpnt)->status = SAM_STAT_CHECK_CONDITION;
>         scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
>
> -       SCpnt->SCp.ptr              = (char *)scsi_sglist(SCpnt);
> -       SCpnt->SCp.this_residual    = scsi_bufflen(SCpnt);
> -       SCpnt->SCp.buffer           = NULL;
> -       SCpnt->SCp.buffers_residual = 0;
> -
>         /* initialize data */
>         data->msgout_len        = 0;
>         data->msgin_len         = 0;
> @@ -1376,7 +1372,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
>                 case BUSPHASE_STATUS:
>                         nsp32_dbg(NSP32_DEBUG_INTR, "fifo/status");
>
> -                       SCpnt->SCp.Status = nsp32_read1(base, SCSI_CSB_IN);
> +                       nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
>
>                         break;
>                 default:
> @@ -1687,18 +1683,17 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
>                 /* MsgIn 00: Command Complete */
>                 nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
>
> -               SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
> +               nsp32_priv(SCpnt)->status  = nsp32_read1(base, SCSI_CSB_IN);
>                 nsp32_dbg(NSP32_DEBUG_BUSFREE,
>                           "normal end stat=0x%x resid=0x%x\n",
> -                         SCpnt->SCp.Status, scsi_get_resid(SCpnt));
> -               SCpnt->result = (DID_OK << 16) |
> -                       (SCpnt->SCp.Status << 0);
> +                         nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
> +               SCpnt->result = nsp32_priv(SCpnt)->status;
>                 nsp32_scsi_done(SCpnt);
>                 /* All operation is done */
>                 return TRUE;
>         } else if (execph & MSGIN_04_VALID) {
>                 /* MsgIn 04: Disconnect */
> -               SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
> +               nsp32_priv(SCpnt)->status = nsp32_read1(base, SCSI_CSB_IN);
>
>                 nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
>                 return TRUE;
> @@ -1706,8 +1701,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
>                 /* Unexpected bus free */
>                 nsp32_msg(KERN_WARNING, "unexpected bus free occurred");
>
> -               /* DID_ERROR? */
> -               //SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Status << 0);
>                 SCpnt->result = DID_ERROR << 16;
>                 nsp32_scsi_done(SCpnt);
>                 return TRUE;
> diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> index ab0726c070f7..924889f8bd37 100644
> --- a/drivers/scsi/nsp32.h
> +++ b/drivers/scsi/nsp32.h
> @@ -534,6 +534,15 @@ typedef struct _nsp32_sync_table {
>        ---PERIOD-- ---OFFSET--   */
>  #define TO_SYNCREG(period, offset) (((period) & 0x0f) << 4 | ((offset) & 0x0f))
>
> +struct nsp32_cmd_priv {
> +       enum sam_status status;
> +};
> +
> +static inline struct nsp32_cmd_priv *nsp32_priv(struct scsi_cmnd *cmd)
> +{
> +       return scsi_cmd_priv(cmd);
> +}
> +
>  typedef struct _nsp32_target {
>         unsigned char   syncreg;        /* value for SYNCREG   */
>         unsigned char   ackwidth;       /* value for ACKWIDTH  */
