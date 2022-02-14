Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97B4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 04:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiBNEDP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 23:03:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiBNEDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 23:03:14 -0500
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B724EA3B
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 20:03:06 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id l125so9250148ybl.4
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 20:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nDtdbXUkP5nVGKTG8jioDGwnNgvUx1LTIm6ju2fwK0o=;
        b=3XWMwGlF9VAt1ZKzmhrmNejVc8YVoGtitajvt/meyJvI/AztTIz3ATNoPczUrSPiXi
         4jdKzpD/FNjJ3Ahy2E6c12jIcdlE4H1boV0uPz28G7rnQZNOnkOUtGo3yRikNm5+JY/j
         6npmRpA1JCYlz1gxRPLFEbDO18A3gpWQrug7abGk+QRXE6UsWVSLgbZafU2u0v+Ft0Sy
         rXcDu5ZLWSTGJMO+603nb0Xs1cE/2R0s9h3pLdwq2XRjPSAij+P0K7Z1dIlbpnnjq1Kz
         Dw/enGgMfQqp5soCX0MObupTxVFH+ze0vmGirB9hDLnYtDlJLGi+6T4GIPj1kO4q8BtL
         5Wnw==
X-Gm-Message-State: AOAM530VIkocp/LAZae/lAoNmESdNZcURqLSfzSOJ/K8yAjkqASTPNFZ
        C2kCb6Nhb6zTKEp1xQsFhCfJ4fx7QgkOtx6pWoQ=
X-Google-Smtp-Source: ABdhPJxPZgxGWZMoFN9iGZQxzemSGHIPO2z6MJyj4UU5MLz+ji+zQKOaccGI3IGY5uXNFB41Jlbgv/8WzzX5ctFCKgk=
X-Received: by 2002:a25:4742:: with SMTP id u63mr10467591yba.523.1644811385369;
 Sun, 13 Feb 2022 20:03:05 -0800 (PST)
MIME-Version: 1.0
References: <20220211223247.14369-1-bvanassche@acm.org> <20220211223247.14369-37-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-37-bvanassche@acm.org>
From:   Masanori Goto <gotom@debian.or.jp>
Date:   Mon, 14 Feb 2022 13:02:39 +0900
Message-ID: <CALZLnaGvDkkUC1RF0E7pfBjFJbz4gtkYhhHSN272kyzYRfF1Pw@mail.gmail.com>
Subject: Re: [PATCH v3 36/48] scsi: nsp32: Stop using the SCSI pointer
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good.

Reviewed-by: Masanori Goto <gotom@debian.or.jp>

2022年2月12日(土) 7:34 Bart Van Assche <bvanassche@acm.org>:
>
> Move the SCSI status field to private data. Stop setting the .ptr,
> .this_residual, .buffer and .buffer_residual SCSI pointer members
> since no code in this driver reads these members.
>
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/nsp32.c | 20 +++++++-------------
>  drivers/scsi/nsp32.h |  9 +++++++++
>  2 files changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index bd3ee3bf08ee..75bb0028ed74 100644
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
> @@ -1687,18 +1683,18 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
>                 /* MsgIn 00: Command Complete */
>                 nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
>
> -               SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
> +               nsp32_priv(SCpnt)->status  = nsp32_read1(base, SCSI_CSB_IN);
>                 nsp32_dbg(NSP32_DEBUG_BUSFREE,
>                           "normal end stat=0x%x resid=0x%x\n",
> -                         SCpnt->SCp.Status, scsi_get_resid(SCpnt));
> +                         nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
>                 SCpnt->result = (DID_OK << 16) |
> -                       (SCpnt->SCp.Status << 0);
> +                       (nsp32_priv(SCpnt)->status << 0);
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
> @@ -1706,8 +1702,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
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
