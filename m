Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B249DC61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 12:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjBVM2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 07:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjBVM2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 07:28:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEA9CA21
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 04:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677068817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3+b32Zwyck+O2hOVDbOuGlpbjKcgDMwwVIuGClGtEw=;
        b=a4oqhi2hpxSq7Py3UnWOqHjM5gGl/D56t8lVViUhMjZzqmgjbo71B+H6i3W23AonA/Q4ww
        dfwD4sGbIaHrzV21HRYqnPg8K0pqOXecIh0pk2g7hB0r+7mvNb5xUlc3dMY97QCRupPlt3
        Emr23WF1DUfpXPZltzf0Ej/3XeudHHs=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-gi82R8g2N7y04NP1TA70Kw-1; Wed, 22 Feb 2023 07:26:55 -0500
X-MC-Unique: gi82R8g2N7y04NP1TA70Kw-1
Received: by mail-vs1-f72.google.com with SMTP id x16-20020a0561020c1000b00411ab049675so2602449vss.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 04:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3+b32Zwyck+O2hOVDbOuGlpbjKcgDMwwVIuGClGtEw=;
        b=Mk4Pj+Xsgw8i9h69fa0DSXGnsf9+YYf4WLnGQzat5rNGJp0eFa7+gAZELq5noA3MHr
         OM3hD8NM5LJ268wj+VRrRON+z++9UduZR7Tvzwy/G//YmpI8ZrCF5VVIaa0C54Yy1NcH
         gZi0+gWY6OAX4IrSdLgtF/CGpA9qU43WVn3GA+w3cO+P2gBNj8gO74kRptw4EHn10o/3
         3iAN2LeWnukjD51p+8MzYLY1QDTfqtfXDQOCIhLaLyLdtpEmNy6HQD7+zXgy+7Qth58P
         VRaRDk9yxajS7ZiRdVvK3JVwbfSOkg93YrDzjYchVhUsoNKngXE4JeXxva9afAWzHqGu
         TT0Q==
X-Gm-Message-State: AO0yUKWQXMZtjvPoGg5l/qdR1h7pYOhAXkqxqjyimqhBp4zpFvCRErzU
        RXeXUO5SZdRhurT61lbawceNU3V4cww3bzPF9F+ubhbC1fBImD+QN+5EkEfzt4yZ6KTe/7kLoan
        E+xworuBqd/VriYi7k7tSlJ063maQabsAytXa5g==
X-Received: by 2002:a1f:284d:0:b0:410:fa68:81b4 with SMTP id o74-20020a1f284d000000b00410fa6881b4mr167926vko.33.1677068815339;
        Wed, 22 Feb 2023 04:26:55 -0800 (PST)
X-Google-Smtp-Source: AK7set+VJjCwS9be834owcZ1zfxIWnEwTOeI7vlCCuPEhRZ3Q6wxDGCrlJPR7WWl+RjiDq8PJlo268vqQ7SbE2uyY8U=
X-Received: by 2002:a1f:284d:0:b0:410:fa68:81b4 with SMTP id
 o74-20020a1f284d000000b00410fa6881b4mr167922vko.33.1677068815083; Wed, 22 Feb
 2023 04:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-15-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-15-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 22 Feb 2023 13:26:43 +0100
Message-ID: <CAFL455=RB8PojgQuGotX=UQ4-ffvk4eQWN9BoTjf7eHEG_xGZQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] scsi: target: iscsit: free cmds before session free
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com, sagi@grimberg.me,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Forza <forza@tnonline.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> From: Dmitry Bogdanov <d.bogdanov@yadro.com>
>
> Commands from recovery entries are freed after its session has been
> closed. That leads to use-after-free at command free or NPE with such
> call trace:
>
> Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
> BUG: kernel NULL pointer dereference, address: 0000000000000140
> RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
> Call Trace:
>  target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
>  transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
>  iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
>  iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
>  iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
>  iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
>  call_timer_fn+0x24/0x140
>
> Move cleanup of recovery enrties to before session freeing.
>
> Reported-by: Forza <forza@tnonline.net>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index a57527beb340..eac5af87ccd8 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4547,6 +4547,9 @@ int iscsit_close_session(struct iscsit_session *ses=
s, bool can_sleep)
>         iscsit_stop_time2retain_timer(sess);
>         spin_unlock_bh(&se_tpg->session_lock);
>
> +       if (sess->sess_ops->ErrorRecoveryLevel =3D=3D 2)
> +               iscsit_free_connection_recovery_entries(sess);
> +
>         /*
>          * transport_deregister_session_configfs() will clear the
>          * struct se_node_acl->nacl_sess pointer now as a iscsi_np proces=
s context
> @@ -4570,9 +4573,6 @@ int iscsit_close_session(struct iscsit_session *ses=
s, bool can_sleep)
>
>         transport_deregister_session(sess->se_sess);
>
> -       if (sess->sess_ops->ErrorRecoveryLevel =3D=3D 2)
> -               iscsit_free_connection_recovery_entries(sess);
> -
>         iscsit_free_all_ooo_cmdsns(sess);
>
>         spin_lock_bh(&se_tpg->session_lock);
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

