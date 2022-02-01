Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607C3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 17:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiBARxM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:53:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230439AbiBARxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 12:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=V5NHgeX6svdBwQCb1eVFS9MJBKrQn2fbOOGJZHfo6Es=;
        b=SAiappObODgCwkLV/qwNtFyH1K6sNmWUwWT5OdJRu6UWVNvilVam4LtMCyS9G3qDN6aID9
        TEpcGiGdYM39eQIa4sX0/5qgJU6lkRizE2GgF/QZ3yJlPnL2e6tZV850+RZXKzL/kXtjKH
        vgbMiGq3oNR6rSe3+FwFyOQu4YVb700=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-CjbtAs8KMM2blbJ_wdqYrg-1; Tue, 01 Feb 2022 12:53:10 -0500
X-MC-Unique: CjbtAs8KMM2blbJ_wdqYrg-1
Received: by mail-lf1-f69.google.com with SMTP id z13-20020a056512376d00b0043793efa5f6so6235127lft.18
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2022 09:53:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V5NHgeX6svdBwQCb1eVFS9MJBKrQn2fbOOGJZHfo6Es=;
        b=4UZRf7ytp9NnjFqQwNFXRrBEAfLIAPWACV3fGjpsmRyVRl7kyjjoHkce/ItmgobWcd
         KRomipd24/hGrPTFvCptPUCVSAcrhmnf0Kuu00hrlk94apKJTZelcMBUm8IyVBYiKgGu
         VKjyXx//fWOb4uvuBapk6AwvbbjaaQ3pJSNbDx2vDzrVsgJJGh5EKLZamx0ehlwZNe9J
         qTy3B2ako9aeUVvJo3gg8ytIUA5bHnJNGiaSe+Ud2FDV48p635ZVvyk+jxNHpIw9KOTP
         68i1MNuuWPSnnAB4ttwZ3jC6dobP9U5MKJcTdLFP4XTHfycSeyhky7cK6nmTUMkyX7vc
         tLdQ==
X-Gm-Message-State: AOAM532CQxfy8p46C5MIi8dkBwZg4ud7woKxvH3B3tABkWS1LsRjfCIV
        n2NDCL8frh/Di3GYtorD1OxWxJJuGXT8pZK6Ctyw3HQE0VQDIl8TZQYi4p2Fh1ZknmdemvDYoTr
        QW5lMwY0oOWfgS+b5SNw1rky36oa8aawl772++A==
X-Received: by 2002:a05:6512:33d1:: with SMTP id d17mr12381325lfg.455.1643737988835;
        Tue, 01 Feb 2022 09:53:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2SPx0T8oEVwuxIc+4WVcIa0MnN/RqpYwuQxm4H2vie7ZEKEg1aDBPv+faV036uE+y6cmhTwOnp0W8jjOF7I4=
X-Received: by 2002:a05:6512:33d1:: with SMTP id d17mr12381302lfg.455.1643737988506;
 Tue, 01 Feb 2022 09:53:08 -0800 (PST)
MIME-Version: 1.0
From:   Ewan Milne <emilne@redhat.com>
Date:   Tue, 1 Feb 2022 12:52:57 -0500
Message-ID: <CAGtn9rmosXZtSgn24gFNYTzkFrHgY+pQBNTiP-3N6-a8OX+HzA@mail.gmail.com>
Subject: scsi-staging crashing on boot
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Anybody else hit this?  We are seeing a crash right after boot.
Machine has an Emulex HBA, we don't see this on a similar machine w/Qlogic.

This was detected w/automation, we'll try backing out the last commit (below)

[   29.339684] general protection fault, probably for non-canonical
address 0xdead00000000012a: 0000 [#1] PREEMPT SMP PTI
[   29.340245] CPU: 23 PID: 0 Comm: swapper/23 Tainted: G S
    5.17.0-rc1 #1
[   29.340649] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 07/20/2015
[   29.340975] RIP: 0010:run_timer_softirq+0x137/0x420
[   29.341611] Code: 83 ed 01 4c 8d 64 c4 08 49 8b 04 24 48 85 c0 74
db 4d 8b 3c 24 4d 89 7e 08 66 90 49 8b 07 49 8b 57 08 48 89 02 48 85
c0 74 04 <48> 89 50 08 49 c7 47 08 00 00 00 00 4d 8b 6f 18 4c 89 f7 48
b8 22
[   29.342903] RSP: 0000:ffffb930067c0f08 EFLAGS: 00010086
[   29.343182] RAX: dead000000000122 RBX: 0000000000000000 RCX: 0000000000000200
[   29.343924] RDX: ffffb930067c0f10 RSI: ffff964c9fce0340 RDI: ffff964c9fce0368
[   29.344692] RBP: 00000000fffbde00 R08: 0000000000000000 R09: 0000000000000000
[   29.345446] R10: 0000000000000000 R11: 0000000000000000 R12: ffffb930067c0f10
[   29.346164] R13: ffffffff974060c8 R14: ffff964c9fce0340 R15: ffff9644c8866950
[   29.346918] FS:  0000000000000000(0000) GS:ffff964c9fcc0000(0000)
knlGS:0000000000000000
[   29.347316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.347979] CR2: 00007f763b35e630 CR3: 0000000882010004 CR4: 00000000001706e0
[   29.348697] Call Trace:
[   29.348853]  <IRQ>
[   29.349326]  ? recalibrate_cpu_khz+0x10/0x10
[   29.349928]  ? ktime_get+0x3e/0xa0
[   29.350469]  ? sched_clock_cpu+0xb/0xc0
[   29.350674]  __do_softirq+0xfa/0x2f7
[   29.350904]  irq_exit_rcu+0xc1/0xf0
[   29.351445]  sysvec_apic_timer_interrupt+0x9e/0xc0
[   29.352054]  </IRQ>
[   29.352524]  <TASK>
[   29.353000]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   29.353273] RIP: 0010:cpuidle_enter_state+0xd6/0x380
[   29.353542] Code: 49 89 c4 0f 1f 44 00 00 31 ff e8 45 8a 96 ff 45
84 ff 74 12 9c 58 f6 c4 02 0f 85 64 02 00 00 31 ff e8 9e 63 9d ff fb
45 85 f6 <0f> 88 12 01 00 00 49 63 d6 4c 2b 24 24 48 8d 04 52 48 8d 04
82 49
[   29.354821] RSP: 0000:ffffb930063bbe80 EFLAGS: 00000202
[   29.355084] RAX: ffff964c9fcc0000 RBX: 0000000000000002 RCX: 000000000000001f
[   29.355826] RDX: 00000006d4c7b9d9 RSI: ffffffff97177efb RDI: ffffffff97149f37
[   29.356538] RBP: ffffd92fffcc0000 R08: 0000000000000004 R09: 000000000002f880
[   29.357321] R10: 0000086674b91b40 R11: ffff964c9fceed84 R12: 00000006d4c7b9d9
[   29.358041] R13: ffffffff978d49a0 R14: 0000000000000002 R15: 0000000000000000
[   29.358769]  cpuidle_enter+0x29/0x40
[   29.358979]  do_idle+0x261/0x2b0
[   29.359515]  cpu_startup_entry+0x19/0x20
[   29.359718]  start_secondary+0x114/0x150
[   29.359946]  secondary_startup_64_no_verify+0xd5/0xdb
[   29.360221]  </TASK>
[   29.360352] Modules linke
[   32.033645] R13: ffffffff974060c8 R14: ffff964c9fce0340 R15: ffff9644c8866950
[   32.033645] FS:  0000000000000000(0000) GS:ffff964c9fcc0000(0000)
knlGS:0000000000000000
[   32.033647] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.033648] CR2: 00007f763b35e630 CR3: 0000000882010004 CR4: 00000000001706e0
[   32.033649] Kernel panic - not syncing: Fatal exception in interrupt
[   32.102100] Kernel Offset: 0x14e00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   32.366547] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

I notice the commit at the HEAD affected lpfc:

commit d1d87c33f47dc69f948d51dcfed344e34c75c406 (HEAD -> staging,
origin/staging, origin/for-next, origin/5.18/scsi-staging)
Author: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Date:   Thu Jan 27 01:43:30 2022 +0000

    scsi: lpfc: Remove redundant flush_workqueue() call

    destroy_workqueue() already drains the queue before destroying it, so there
    is no need to flush it explicitly.

    Remove the redundant flush_workqueue() call.

    Link: https://lore.kernel.org/r/20220127014330.1185114-1-chi.minghao@zte.com.cn
    Reported-by: Zeal Robot <zealci@zte.com.cn>
    Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a56f01f659f8..f49ff18cb252 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8546,7 +8546,6 @@ static void
 lpfc_unset_driver_resource_phase2(struct lpfc_hba *phba)
 {
        if (phba->wq) {
-               flush_workqueue(phba->wq);
                destroy_workqueue(phba->wq);
                phba->wq = NULL;
        }

-Ewan

