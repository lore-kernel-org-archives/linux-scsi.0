Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F00C001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 10:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjGSKBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjGSKAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 06:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CCF1FE2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 02:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689760786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNrKXYsgEjY0/J/1wkQSOKUKgfUi70H3dQ+kbUIwfvE=;
        b=HUo7m6goiCITIFX0KiA1b1O5R0p2KHQBIMw5HzzF6s4zKfu96MOlJN2dCcEkLlNbrBKuwF
        +Afb1g5iA1rxRKxP5K6T9sOne85zHY/jTAHIGdMog/HW+1Cutl86/mZxPPCfPwksVVL8PG
        tmm6DW0pDgvZZWWfUFQ8aKwM9NbQ6NA=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-6VXoYjPMNc25nXU2uO7r7w-1; Wed, 19 Jul 2023 05:59:45 -0400
X-MC-Unique: 6VXoYjPMNc25nXU2uO7r7w-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-799728678ecso1417909241.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 02:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689760784; x=1690365584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nNrKXYsgEjY0/J/1wkQSOKUKgfUi70H3dQ+kbUIwfvE=;
        b=HlMojECUTl8bqfc2syqZ+wGTXhEcufZIHEHKUmgl3MCh+C8VhSTTdWkFO31O4A0Q2w
         EvODbDxSIJA4MsvgUfw2Zgw+UL1At94lRLh4nVjDYgpK/gGjfxx9rvqwgWP6y2JiQYIH
         J+6BS1TRfxqsA3mZ0nnf0iOp3waiKUHpNRneB+ljVjB3yXItuAcDiczedZKwsN4pRhtf
         Ux/ZujmvxbczkMu+wNxl76WusO62ctrG6t1o9fqTJhnEUpAkxFaDjHN3NCdTNVFxuAho
         4j++NaExQ0bDw7qoJEB41I1GoMiMhZHkuu+TDmb1pGwoFqY7W6v3dyVX7EsRaYUHkuch
         4//g==
X-Gm-Message-State: ABy/qLayPgejn0VVfSMxiy/aMxBH0pZQeYKniWnvIwdA019CmKC+HHSZ
        czg8DGQSLGhFYwAAIcYIwPAtSAJydOR4cvx8QClIIaxglRZR6DZjsrF5/wuVkaJthaAqbWS1KbQ
        4hxf/bANr4BA3jNkdry/Bwx8twRX5Yz8VaCgmLw==
X-Received: by 2002:a05:6102:3641:b0:443:92a5:f454 with SMTP id s1-20020a056102364100b0044392a5f454mr1173897vsu.26.1689760784173;
        Wed, 19 Jul 2023 02:59:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFwKOu8b4zcqwPRcj2+RXhb5RTGbj+yORZfXXm71333srBj3Ys0/jezl+KtyZ7G+yi4xKL5gMQ73qTHxC5zK3E=
X-Received: by 2002:a05:6102:3641:b0:443:92a5:f454 with SMTP id
 s1-20020a056102364100b0044392a5f454mr1173880vsu.26.1689760783923; Wed, 19 Jul
 2023 02:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <d477d789-3e73-9d00-1daf-ff0ed6f18e6c@easystack.cn>
In-Reply-To: <d477d789-3e73-9d00-1daf-ff0ed6f18e6c@easystack.cn>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 19 Jul 2023 11:59:32 +0200
Message-ID: <CAFL455ni63jgLha_AypB6hW=w2YQjWzbi9CJo9oK8yG1VM-=6A@mail.gmail.com>
Subject: Re: Close connection aborting an out-of-order cmd will hang
To:     Jirong Feng <jirong.feng@easystack.cn>
Cc:     nab@linux-iscsi.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

=C3=BAt 18. 7. 2023 v 8:52 odes=C3=ADlatel Jirong Feng <jirong.feng@easysta=
ck.cn> napsal:
>
> Hi,
>
> I recently encountered a hanging issue as follow:

Can you please provide the kernel version?

Thanks,
Maurizio

> [root@node-6 ~]# ps -aux | grep ' D '
> root      8648  0.4  0.0      0     0 ?        D    Jul12  21:04 [iscsi_n=
p]
> root     17572  0.0  0.0      0     0 ?        D    Jul12   0:09
> [kworker/7:3+events]
> root     56555  0.0  0.0 216576  1536 pts/1    S+   14:57   0:00 grep
> --color=3Dauto  D
> root     59853  0.0  0.0      0     0 ?        D    Jul12   0:04 [iscsi_t=
rx]
>
> the call stack:
> kworker:
> PID: 17572  TASK: ffff862470df0e00  CPU: 7   COMMAND: "kworker/7:3"
>   #0 [ffff0000528afab0] __switch_to at ffff4a49c69e74b8
>   #1 [ffff0000528afad0] __schedule at ffff4a49c72b60f4
>   #2 [ffff0000528afb60] schedule at ffff4a49c72b6754
>   #3 [ffff0000528afb70] schedule_timeout at ffff4a49c72ba980
>   #4 [ffff0000528afc30] wait_for_common at ffff4a49c72b7504
>   #5 [ffff0000528afcb0] wait_for_completion at ffff4a49c72b7594
>   #6 [ffff0000528afcd0] target_put_cmd_and_wait at ffff4a49a3dad38c
> [target_core_mod]
>   #7 [ffff0000528afd30] core_tmr_abort_task at ffff4a49a3da55c8
> [target_core_mod]
>   #8 [ffff0000528afd80] target_tmr_work at ffff4a49a3daa1c8
> [target_core_mod]
>   #9 [ffff0000528afdb0] process_one_work at ffff4a49c6a603c0
> #10 [ffff0000528afe00] worker_thread at ffff4a49c6a60640
> #11 [ffff0000528afe60] kthread at ffff4a49c6a67474
>
> iscsi_trx:
> PID: 59853  TASK: ffff8624fe0b5200  CPU: 7   COMMAND: "iscsi_trx"
>   #0 [ffff000095f6fa50] __switch_to at ffff4a49c69e74b8
>   #1 [ffff000095f6fa70] __schedule at ffff4a49c72b60f4
>   #2 [ffff000095f6fb00] schedule at ffff4a49c72b6754
>   #3 [ffff000095f6fb10] schedule_timeout at ffff4a49c72ba870
>   #4 [ffff000095f6fbd0] wait_for_common at ffff4a49c72b7504
>   #5 [ffff000095f6fc50] wait_for_completion_timeout at ffff4a49c72b75d0
>   #6 [ffff000095f6fc70] __transport_wait_for_tasks at ffff4a49a3da9c28
> [target_core_mod]
>   #7 [ffff000095f6fcb0] transport_generic_free_cmd at ffff4a49a3da9dd0
> [target_core_mod]
>   #8 [ffff000095f6fd20] iscsit_free_cmd at ffff4a49a3fc4464
> [iscsi_target_mod]
>   #9 [ffff000095f6fd50] iscsit_close_connection at ffff4a49a3fccf48
> [iscsi_target_mod]
> #10 [ffff000095f6fdf0] iscsit_take_action_for_connection_exit at
> ffff4a49a3fb7614 [iscsi_target_mod]
> #11 [ffff000095f6fe20] iscsi_target_rx_thread at ffff4a49a3fcc064
> [iscsi_target_mod]
> #12 [ffff000095f6fe60] kthread at ffff4a49c6a67474
>
> inspect the aborting cmd in kworker:
> crash> struct iscsi_cmd FFFFA62592F4B400
> struct iscsi_cmd {
>    dataout_timer_flags =3D (unknown: 0),
>    dataout_timeout_retries =3D 0 '\000',
>    error_recovery_count =3D 0 '\000',
>    deferred_i_state =3D ISTATE_NEW_CMD,
>    i_state =3D ISTATE_DEFERRED_CMD,
>    immediate_cmd =3D 0 '\000',
>    immediate_data =3D 0 '\000',
>    iscsi_opcode =3D 1 '\001',
>    iscsi_response =3D 0 '\000',
>    logout_reason =3D 0 '\000',
>    logout_response =3D 0 '\000',
>    maxcmdsn_inc =3D 0 '\000',
>    unsolicited_data =3D 0 '\000',
>    reject_reason =3D 0 '\000',
>    logout_cid =3D 0,
>    cmd_flags =3D ICF_OOO_CMDSN,
>    init_task_tag =3D 2415919152,
>    targ_xfer_tag =3D 205,
>    cmd_sn =3D 2860352639,
>    exp_stat_sn =3D 2502541166,
>    stat_sn =3D 0,
>    data_sn =3D 0,
> ...
>
> so this is an out-of-order cmd. In my conclusion, trx is waiting for
> kworker to abort the cmd,  while kworker is waiting for someone to
> complete the cmd, and that is never going to happen, hence the hanging.
>
> Could someone please help me to confirm the case?
>
> Regards,
> Jirong Feng
>
>

