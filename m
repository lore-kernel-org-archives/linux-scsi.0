Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD46C64ED6
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 11:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCAL6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 06:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCAL6Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 06:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168A72CC46
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 03:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677671855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mHl5KQjEc4/d6SgEY0TdUVaYr+bU97RLVBw2BBUuA38=;
        b=IzK5Tj+b9zVUvuXav6xbVx3HcaHafSD8i/DCv+uVd1UyPER/PlKnjHST2RupKkXCh4lPrq
        Igimw2KVaWUlXsV8DC/cLGO3WdRsR79iWomj6BcTFctoSRZWDtoF+Qkoqzi6beDOR3rhKU
        nHp7xkoaplu2eLPpW/bKvPGj6Zk1ncM=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-keaQrbNgPrSbxi7MCl2eoQ-1; Wed, 01 Mar 2023 06:57:33 -0500
X-MC-Unique: keaQrbNgPrSbxi7MCl2eoQ-1
Received: by mail-vs1-f72.google.com with SMTP id t24-20020a67f158000000b0041eb81820fbso9125252vsm.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 03:57:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677671853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mHl5KQjEc4/d6SgEY0TdUVaYr+bU97RLVBw2BBUuA38=;
        b=t68tzROUg4IongkAIFRep/ewy45SA21At5hiUFbk+gPc8x8sxigoR0k6K8IvDDZgwr
         fwMMRvl64BHmj3J5hOOB+RNXZhRyzZcWn2KO4sx9v5gIM0WfzXKP3JDE9FwhtFTJRcrY
         9a5tHpQ05/0W6ZvFIk18EiKKXBCQeeCnqD55s4hzTIfhkdUcyHPOhGPNZCsxTQ/5LuqW
         Usit0KY7gwhfh5dcZxoI6xbM2orbSYFgOCt21W9WqWUOh9hGbkF8F64V74aL2SYwtgpc
         O2ZVRQ12glwS5rKRDaSs66pLJX/1wnnVk2N4W2AiCkhoGsOqrf8NHPIeuwpyBRpu8Eg2
         va/w==
X-Gm-Message-State: AO0yUKX99X9sKwOwnP2fgUCgYg0AvjdhoHuxassBdnDnRlmDQuBCIpgz
        DLnb2p9TjVO9h9sE8PPIYQFgdBBlFASmJWFWlTNQx5felhOaiMF0O/8mzDerE1lw5lamwHm0/jA
        xc7lf5V7Pfxo86DjYTYrrk3BYbmy7QwVpYILXiA==
X-Received: by 2002:a05:6122:656:b0:401:8898:ea44 with SMTP id h22-20020a056122065600b004018898ea44mr3351177vkp.3.1677671853358;
        Wed, 01 Mar 2023 03:57:33 -0800 (PST)
X-Google-Smtp-Source: AK7set9l846Pjlw2nULxarUi1PRFBt3nBG6v0YrgnYC4ddQ7sWQ5MmNP5msaiDYvAL+l07xHgrEbEXqOCSsuiMJsbhs=
X-Received: by 2002:a05:6122:656:b0:401:8898:ea44 with SMTP id
 h22-20020a056122065600b004018898ea44mr3351172vkp.3.1677671853105; Wed, 01 Mar
 2023 03:57:33 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-6-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-6-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 1 Mar 2023 12:57:21 +0100
Message-ID: <CAFL455=QjP9TutSh0e5KS0R07PK3Pvcv+6xNkP6i6ExGv+gCpg@mail.gmail.com>
Subject: Re: [PATCH v3 05/14] scsi: target: iscsit: stop/wait on cmds during
 conn close
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
> If we have multiple sessions to the same se_device we can hit a race wher=
e
> a LUN_RESET on one session cleans up the se_cmds from under another
> session which is being closed. This results in the closing session freein=
g
> its conn/session structs while they are still in use.
>
> The bug is:
>
> 1. Session1 has IO se_cmd1.
> 2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
> but then gets a LUN_RESET.
> 3. The LUN_RESET on session2 sees the se_cmds on session1 and during
> the drain stages marks them all with CMD_T_ABORTED.
> 4. session1 is now closed so iscsit_release_commands_from_conn only sees
> se_cmds with the CMD_T_ABORTED bit set and returns immediately even
> though we have outstanding commands.
> 5. session1's connection and session are freed.
> 6. The backend request for se_cmd1 completes and it accesses the freed
> connection/session.
>
> This hooks the iscsit layer into the cmd counter code, so we can wait for
> all outstanding se_cmds before freeing the connection.
>
> Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race=
")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 11115c207844..83b007141229 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4245,6 +4245,16 @@ static void iscsit_release_commands_from_conn(stru=
ct iscsit_conn *conn)
>                 iscsit_free_cmd(cmd, true);
>
>         }
> +
> +       /*
> +        * Wait on commands that were cleaned up via the aborted_task pat=
h.
> +        * LLDs that implement iscsit_wait_conn will already have waited =
for
> +        * commands.
> +        */
> +       if (!conn->conn_transport->iscsit_wait_conn) {
> +               target_stop_cmd_counter(conn->cmd_cnt);
> +               target_wait_for_cmds(conn->cmd_cnt);
> +       }
>  }
>
>  static void iscsit_stop_timers_for_cmds(
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

