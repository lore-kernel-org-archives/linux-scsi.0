Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B27C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 02:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4620F2078D
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 02:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVe7GmKW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgIKC0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgIKC0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 22:26:51 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F998C061573
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 19:26:51 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id u20so7690219ilk.6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 19:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0hkBtC1XXR5c2rVgycvrpYUSPHrUWo3fR32rbmRN3HE=;
        b=JVe7GmKWniObu6rYHod1PrP94Bxgbcsym/3d+MErluYXg2AxyvRhe3E0BTK5ZNT6nG
         wKz4I2dKOGrG2Dk5m0t40bYVW9iyh0Rlkr/LGnERen4k5g8zmQH36LGdCVYT5mp861gr
         B3d4EjLt+v+z+eixMUkKuI0Ag53OwLY+M3lxtr7ZWMtPsaEHjC1cni93mpuEHpFwNMME
         aq+XzdNZGKkJQnKC1U2W3CUTusxcyI1zT1BFivPUVRgoFM/sG/3W1mLfExRQg9LhfuDx
         mog8DhFq5U7Ih970c2GD+WsNpbJoOpEEFaEF+sc7rKfM1duutzJwwbCdH/W1jKDiDvLN
         vXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0hkBtC1XXR5c2rVgycvrpYUSPHrUWo3fR32rbmRN3HE=;
        b=fczbe+Gy7/S/uDqpGbz+PtFPBreD2CFG5IRUnkTPy4ASWzkvXfzXhhaWIBKpYy4YN7
         m4guhIIQnMZGRue3s4Q0meu7Y84gLS/2RNwYLDmxr36zAqZSd22gkseET4hJdNpfEkZ3
         u6Fci7zhZYKUxE7iyXJhQv+ziACtqGLUWek1ADINuLKlsKwogM6naodXPq165pGKU2Fg
         BGBRcRyYzF8O4sJcG2GBF74WvWK6Mr0Syql7eJZ5LNJJJxoUXQWoiAl+3IA36AYKP/kZ
         Nh3QSmOsUFaDGWQYPvQsSAXiVZS/uKslo592BpcAdZAIq2D//F939KrUEaB/9762qq07
         nBfg==
X-Gm-Message-State: AOAM532Ax89dVmfv/1V306dKJ1XM7uucw6O+jMtf5ZqNbjFg9IGK8kso
        5Hqg5Rq8a9T5mFFqMihvOC22pnD9vKwgHJPjN8E=
X-Google-Smtp-Source: ABdhPJxioKNUgMH0Ic7NLk9CVWiK4GLNDOMZtSoQX4O96C7Ar5MxmiFBUPd/6/DRitcNbxTJ7Qxo+2Md1JKw34wl6hQ=
X-Received: by 2002:a92:dd88:: with SMTP id g8mr8420299iln.101.1599791209278;
 Thu, 10 Sep 2020 19:26:49 -0700 (PDT)
MIME-Version: 1.0
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Fri, 11 Sep 2020 10:26:38 +0800
Message-ID: <CAOOPZo448A7-qg6gpJqMF6TmnUWVXL3=A4nEo2pKVRt3iEkGrA@mail.gmail.com>
Subject: qla2xxx panic with 4.19-stable
To:     qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        liuzhengyuan@tj.kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

There is a panic of NULL pointer dereference on my arm64 server when
boot  with the fabric line  plugged into the HBA of QLE2692. After
binary-search with git bisect I found this panic is introduced by
commit 4984a06bf094 ("scsi: qla2xxx: Remove all rports if fabric scan
retry fails"). The upstream and 4.19-stable both had the same problem
when reset to this point. but the upstream had fix this
unintentionally after commit da61ef053bcf ("scsi: qla2xxx: Reduce
holding sess_lock to prevent CPU") while the latest 4.19-stable still
has this issue. the panic showed as following:

[   13.380405][  0] Unable to handle kernel NULL pointer dereference
at virtual address 0000000000000000
[   13.390947][  0] Mem abort info:
[   13.395535][  0]   ESR = 0x96000045
[   13.400390][  0]   Exception class = DABT (current EL), IL = 32 bits
[   13.408089][  0]   SET = 0, FnV = 0
.
[   13.412941][  0]   EA = 0, S1PTW = 0
[   13.416747][  0] Data abort info:
[   13.420048][  0]   ISV = 0, ISS = 0x00000045
[   13.424293][  0]   CM = 0, WnR = 1
[   13.427676][  0] user pgtable: 64k pages, 48-bit VAs, pgdp = (____ptrval____)
[   13.434778][  0] [0000000000000000] pgd=0000000000000000,
pud=0000000000000000
[   13.441968][  0] Internal error: Oops: 96000045 [#1] SMP
[   13.447250][  0] Modules linked in: qla2xxx nvme_fc nvme_fabrics
scsi_transport_fc igb megaraid_sas dm_snapshot iscsi_tcp libiscsi_tcp
libs
[   13.472588][  0] Process kworker/0:2 (pid: 343, stack limit =
0x(____ptrval____))
[   13.472675][  5] audit: type=1130 audit(1599118767.260:14): pid=1
uid=0 auid=4294967295 ses=4294967295 msg='unit=initrd-parse-etc
comm="sy'
[   13.480032][  0] CPU: 0 PID: 343 Comm: kworker/0:2 Tainted: G
 W         4.19.90-19.ky10.aarch64 #1
[   13.480033][  5] Hardware name: GreatWall, BIOS 601FBE28 2020/04/20
[   13.480045][  0] Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
[   13.499248][  0] audit: type=1131 audit(1599118767.260:15): pid=1
uid=0 auid=4294967295 ses=4294967295 msg='unit=initrd-parse-etc
comm="sy'
[   13.508759][  0] pstate: 40000005 (nZcv daif -PAN -UAO)
[   13.547687][ 24] pc : __memset+0x16c/0x188
[   13.547697][  0] lr : qla24xx_async_gpnft+0x194/0x950 [qla2xxx]
[   13.547701][  0] sp : ffffb2158236bc60
[   13.561388][  0] x29: ffffb2158236bc60 x28: 0000000000000000
[   13.567104][  0] x27: ffff3be824ac0148 x26: ffff3be824ac00b8
[   13.572820][  0] x25: ffff3be824b031e0 x24: 0000000000000028
[   13.578535][  0] x23: ffffb2158600d188 x22: ffffb21586d3ea38
[   13.584251][  0] x21: 0000000000008010 x20: ffffb21586d3ea08
[   13.589968][  0] x19: ffffb2158600d040 x18: 0000000000000400
[   13.595683][  0] x17: 0000000000000000 x16: ffff3be83f9a9500
[   13.601398][  0] x15: 0000000000000400 x14: 0000000000000400
[   13.607114][  0] x13: 0000000000000189 x12: 0000000000000001
[   13.612829][  0] x11: 0000000000000000 x10: 0000000000000b40
[   13.618544][  0] x9 : 0000000000000000 x8 : 0000000000000000
[   13.624259][  0] x7 : 0000000000000000 x6 : 000000000000003f
[   13.629974][  0] x5 : 0000000000000040 x4 : 0000000000000000
[   13.635689][  0] x3 : 0000000000000004 x2 : 0000000000007fd0
[   13.641404][  0] x1 : 0000000000000000 x0 : 0000000000000000
[   13.647119][  0] Call trace:
[   13.649983][  0]  __memset+0x16c/0x188
[   13.653718][  0]  qla2x00_do_work+0x398/0x440 [qla2xxx]
[   13.658920][  0]  qla2x00_iocb_work_fn+0x50/0xe8 [qla2xxx]
[   13.664378][  0]  process_one_work+0x1f0/0x3c8
[   13.668797][  0]  worker_thread+0x48/0x4d0
[   13.672871][  0]  kthread+0x128/0x130
[   13.676514][  0]  ret_from_fork+0x10/0x18
[   13.680503][  0] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b7428)
[   13.687027][  0] ---[ end trace 258cdcdd74a25238 ]---
[   13.692051][  0] Kernel panic - not syncing: Fatal exception
