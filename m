Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299F0C64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjB0PM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjB0PM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 10:12:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24F120D13
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 07:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677510737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9qv+JhA2zzNcT7PAHlrVh4sWMSRH69WkPb3X/t6I04=;
        b=PLWZErcz5AnW1a+nM+cHjqQExKtfOBaaSaf4EHKrTlw4wT6/GHgvdQRnc2GEYly55Sascn
        Czf7hLP7mp4Z8S9omYFLRw2Dx/zauogwDDWz3DBZyRIcyh0v7JvRW+49xx5WFH9Lr9tJ9t
        EOH7YMOVYmrfL4t18V8tKESWBP0KngY=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-311-eQG4h7CGNO29BUSt6MRklQ-1; Mon, 27 Feb 2023 10:12:16 -0500
X-MC-Unique: eQG4h7CGNO29BUSt6MRklQ-1
Received: by mail-vs1-f70.google.com with SMTP id w1-20020a67b101000000b004144e5628c1so5863077vsl.18
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 07:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9qv+JhA2zzNcT7PAHlrVh4sWMSRH69WkPb3X/t6I04=;
        b=q+2pgzhdJL1Tch9zgtUPLKEELWishnubv/vGsZYejQmUEI4nuv+8qnE6+VreQtbGFf
         1AHErI9oA3+mr1Rz3PsAnmTeo7ZcVlqp6vXimxxrT06Ec2qxy7xlPNoNWt+GIlkUK3b2
         V1msf/AdvgkXphzIGMfCbyzVR+gZ/9Sy44X3Z8LCUZLbOhh2tGq4lIStQf2KNbykJbA3
         Eqd6Xtx+OXnaf75vMx2090ffilcxqQmM1X2G6lL6vE6Hv7krsfbefh0Md/fUBsyXgbRa
         jgjgtFhd/6cTIca+UkVMEZq0i63vNj+3CxlrcZ7owpLZBxqtv/1zR33dD7/ugnjC2d5l
         rQKw==
X-Gm-Message-State: AO0yUKXdNfTnO/bVZz56qD8srxYxLp/QhJK+i/QFZchRFo6pLenL7XBn
        tz/8dH8dqX74+bP1O5eV/8sfQMDyjJZfi5i6/QdTTjKPSahGXfWKYd/bo9WfajWbJ3JaN7tPSNW
        WlvQvPBcz0cH9JYBjGFion7bWr5yZlp/btqEsj9mYyzM=
X-Received: by 2002:a67:ffd3:0:b0:402:9b84:1be0 with SMTP id w19-20020a67ffd3000000b004029b841be0mr7851098vsq.2.1677510735517;
        Mon, 27 Feb 2023 07:12:15 -0800 (PST)
X-Google-Smtp-Source: AK7set+xNvSGwZiDGOA9jlrRw1H9i7EW6u2e0rwLKzk/7Vof4bGSJXm6asRX2l0+pZ+tgytSJcTi7jZvwBqyTV2TNV4=
X-Received: by 2002:a67:ffd3:0:b0:402:9b84:1be0 with SMTP id
 w19-20020a67ffd3000000b004029b841be0mr7851079vsq.2.1677510735160; Mon, 27 Feb
 2023 07:12:15 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-11-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-11-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 27 Feb 2023 16:12:03 +0100
Message-ID: <CAFL455mTGgDg=dm8c2gTqDL5VPQAgLob=eo66v5eaVZ2rY7VSQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] scsi: target: iscsit: Add helper to check when
 cmd has failed
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com, sagi@grimberg.me,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> This moves the check in lio_queue_status to new helper so other code can
> use it to check for commands that were failed by lio core or iscsit.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target_configfs.c | 3 +--
>  include/target/iscsi/iscsi_target_core.h     | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/targe=
t/iscsi/iscsi_target_configfs.c
> index 5d0f51822414..82c1d335c369 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1411,9 +1411,8 @@ static int lio_queue_status(struct se_cmd *se_cmd)
>
>         cmd->i_state =3D ISTATE_SEND_STATUS;
>
> -       if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
> +       if (iscsit_cmd_failed(cmd))
>                 return iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i=
_state);
> -       }
>         return conn->conn_transport->iscsit_queue_status(conn, cmd);
>  }
>
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/is=
csi/iscsi_target_core.h
> index 229118156a1f..938dee8b7a51 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -913,6 +913,11 @@ static inline u32 session_get_next_ttt(struct iscsit=
_session *session)
>         return ttt;
>  }
>
> +static inline bool iscsit_cmd_failed(struct iscsit_cmd *cmd)
> +{
> +       return cmd->se_cmd.scsi_status || cmd->sense_reason;
> +}
> +
>  extern struct iscsit_cmd *iscsit_find_cmd_from_itt(struct iscsit_conn *,=
 itt_t);
>
>  extern void iscsit_thread_check_cpumask(struct iscsit_conn *conn,
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

