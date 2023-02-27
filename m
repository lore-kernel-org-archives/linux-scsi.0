Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3F8C64ED6
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 15:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjB0PL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0PL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 10:11:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8089422010
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 07:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677510667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93nzI5VnS3FZUGJix7w74et7HW6LaS2A8Nk/xRLCbqc=;
        b=dCpkw4VDkT3pCm+FRm1S2CWNzSZupFT+QgQrgLuP3EuygoCYtPXCG/28tIOuCqVAu87CnQ
        9wP4iWJnhQEoarnDdxKuGbKkbn5GisRNbUT5fpzmKNuFGBnn3NOywVEt7uZsLlPM8ljFTS
        b5M2v+sYlhwmcYtBGQCdOVm+HFHQrzs=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-7-WPBaJJTJOiy0j_66kBAjRQ-1; Mon, 27 Feb 2023 10:11:06 -0500
X-MC-Unique: WPBaJJTJOiy0j_66kBAjRQ-1
Received: by mail-vs1-f71.google.com with SMTP id d40-20020a05610214a800b0041f6fc02a1dso5847692vsv.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 07:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93nzI5VnS3FZUGJix7w74et7HW6LaS2A8Nk/xRLCbqc=;
        b=dZuALgHDt2/SLY7Y5uUAViNbQTQ327Ay/Ni7Ab1jXQbc58Ep4/gYa9Yii99JUzU53e
         DW5r4HcMsjy5HFhB9vLLUrwXYLwAn3ScZUXFQnB7hRLhobm4sixnJ/0CSrQLOZbiB/Ef
         l4czAax4ij5N+azENV9dz1Xq8obZIQv/GNXQBM/nGopRKkUlyu7LkoasVppfX88iwAKp
         +/cmpiqLsCvFQW/wN4FX1eXWu8ceueplYIEts09Pf5c5YN6PzbvyQp0q+2DaOZJRqWvS
         +rrxwuaEdCVH0iUW9qeAlj0KQbjFbyYfZiG1Ospwguw/SYYq1pJGzHCorJomGbRdpPFd
         X+fw==
X-Gm-Message-State: AO0yUKUerWbuwUbUmMpnkdh2ZIBaUeiguqZIXTHZfk+FK1puPWNclsS0
        vxE4IDhRfiB/rnc01ZXl0NvNnLa1yCTi2d1Nng/9egVcy05aa/3279e7WnRGJbtkITauduFqcGf
        D2OK1R/pUg4eb5PzUpEDQS9G3MSDzPN/vD7mTYA==
X-Received: by 2002:a67:d893:0:b0:40d:68b8:6577 with SMTP id f19-20020a67d893000000b0040d68b86577mr7883564vsj.2.1677510665352;
        Mon, 27 Feb 2023 07:11:05 -0800 (PST)
X-Google-Smtp-Source: AK7set9t15+0uCcKFQB4zu0FoKnt6TfqFnOGP539F4N7uLVsP+nAvLZL+XQbB2XMkpt/KpcaUL+MVZ7Z7ppKGdXz+mY=
X-Received: by 2002:a67:d893:0:b0:40d:68b8:6577 with SMTP id
 f19-20020a67d893000000b0040d68b86577mr7883546vsj.2.1677510665023; Mon, 27 Feb
 2023 07:11:05 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-14-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-14-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 27 Feb 2023 16:10:53 +0100
Message-ID: <CAFL455=ys=qFhG5tXV203ah_e+F4=2UK7GPQgsRnqJd1S41sDw@mail.gmail.com>
Subject: Re: [PATCH v3 13/14] IB/isert: Fix use after free during conn cleanup
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> We can end up freeing a command too early during conn cleanup by doing:
>
> 1. Send iserts N 1MB writes.
> 2. Pull cable or down the port isert is using.
> 3. isert_wait_conn's call to isert_put_unsol_pending_cmds races
> with a running isert_send_done -> isert_completion_put -> isert_put_cmd
> where isert_put_unsol_pending_cmds sees the cmd on the conn_cmd_list
> and it does a isert_put_cmd which will free the cmd. Then isert_send_done
> is run and will access the freed command while doing it's normal command
> completion:
> isert_completion_put -> isert_put_cmd -> transport_generic_free_cmd
>
> This patch has us increment write_data_done, so
> isert_put_unsol_pending_cmds can correctly detect commands which will we
> will not be calling isert_send_done for.
>
> Fixes: 38a2d0d429f1 ("IB/isert: convert to the generic RDMA READ/WRITE
> API")
> [code written and suggested by]
> Suggested-by: Sagi Grimberg <sagi@grimberg.me>
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 516fa37494e1..a44da60352f6 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -1636,7 +1636,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc=
 *wc)
>         if (isert_prot_cmd(isert_conn, se_cmd))
>                 ret =3D isert_check_pi_status(se_cmd, isert_cmd->rw.reg->=
mr);
>         isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
> -       cmd->write_data_done =3D 0;
> +       cmd->write_data_done =3D se_cmd->data_length; /* done fetching da=
ta */
>
>         isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_c=
md);
>         spin_lock_bh(&cmd->istate_lock);
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

