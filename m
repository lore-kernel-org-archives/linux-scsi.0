Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7079CC6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 14:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjBNOS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 09:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjBNOSg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 09:18:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3F1526A
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676384222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7N44JLJ7XEtVeo5qSIwMY7zH3NAHVSZwtfpm4QfM50w=;
        b=g7dhTtm9w1X/zXqfoH//qOTUP8VnBxe31BhZunetnyhgI30PANWbzqNwsMe9a2vyZadSMI
        2ebLlUktclDr6/1F7A0bvKkMgCgfNeLQsrm/+ypwxGcZoQnez0ldwa77/wLgjJ0jDHo/1z
        SB6fZ1uwEiH0mxyGqk3HVt4yPRtAnVE=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-352-BchMGfpYMc609p4T81kP-Q-1; Tue, 14 Feb 2023 09:13:10 -0500
X-MC-Unique: BchMGfpYMc609p4T81kP-Q-1
Received: by mail-vs1-f70.google.com with SMTP id y10-20020a67dd0a000000b004122a486f82so1681155vsj.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 06:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7N44JLJ7XEtVeo5qSIwMY7zH3NAHVSZwtfpm4QfM50w=;
        b=0XXtvRMP197QVEX3zbjfrOTEX/Mz13Ysee42in++32EMijyFDNV1XSJ/l8I0Hu5gVk
         SoJ8flLD0tvBltcCq7Vh2bKPRPgslsYjBKiBL37dmW731UFq89pEQi0JUu5BllX8Mw2U
         Kml1HOgxPpyubR07EhpEPW49qH84VwQXOcBIudYfbyp4HhVmiOABMrPmz74iBjtgj6y5
         k2ObeYUvCgQqUzVScM583pstxIM0W8QCMuD59e5CG7MqJEdMIQnJG9P3HIqsVtA7icnh
         j7jkU23dYdHf7yrrmzcjwRDU+aY8MjEWLUfHny7oddVlAmZr1FkT07tPYLuVCtBiiANu
         1HMg==
X-Gm-Message-State: AO0yUKVQCqKufy4tzVyvLGz5bK9pe4wiGQ3up0sXr+jBR7AvsLfOLrzU
        06srZGzufSm7AnG4ciPzAt5J+AvjX3JH9BQ49hldLFTRAzi3BKmWIb36GJciLA+eyfKfGqSSUrR
        lws49Pnzi847HBEcqW4teRAtN/nDYNVynXAbddQ==
X-Received: by 2002:a67:f041:0:b0:3d0:ea5f:2ebe with SMTP id q1-20020a67f041000000b003d0ea5f2ebemr372804vsm.24.1676383989522;
        Tue, 14 Feb 2023 06:13:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8ILiEnGlv5ZuJO0ChYIMtg9QWP50qmRJ7YQj61dDD6f94LA8JGnnpX4OUnpNtqWXQzhBR1pE6CLrjg8QUPvRI=
X-Received: by 2002:a67:f041:0:b0:3d0:ea5f:2ebe with SMTP id
 q1-20020a67f041000000b003d0ea5f2ebemr372792vsm.24.1676383989174; Tue, 14 Feb
 2023 06:13:09 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-7-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-7-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 14 Feb 2023 15:12:57 +0100
Message-ID: <CAFL455=Gp=vKpYwg3CNiuMVkfG96rgfuxpD_sGrSny4cyW+26g@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] scsi: target: iscsit: Fix TAS handling during
 conn cleanup
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
> This fixes a bug added in:
>
> commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
> race")
>
> If CMD_T_TAS is set on the se_cmd we must call iscsit_free_cmd to do the
> last put on the cmd and free it, because the connection is down and we
> will not up sending the response and doing the put from the normal IO
> path. This patch adds a check for CMD_T_TAS in
> iscsit_release_commands_from_conn so we now detect this case.
>
> Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race=
")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 83b007141229..2a011afa6dff 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4222,7 +4222,8 @@ static void iscsit_release_commands_from_conn(struc=
t iscsit_conn *conn)
>
>                 if (se_cmd->se_tfo !=3D NULL) {
>                         spin_lock_irq(&se_cmd->t_state_lock);
> -                       if (se_cmd->transport_state & CMD_T_ABORTED) {
> +                       if (se_cmd->transport_state & CMD_T_ABORTED &&
> +                           !(se_cmd->transport_state & CMD_T_TAS)) {
>                                 /*
>                                  * LIO's abort path owns the cleanup for =
this,
>                                  * so put it back on the list and let
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

