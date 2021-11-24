Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC0CC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 14:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353694AbhKXOVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 09:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357777AbhKXOUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 09:20:36 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16B8C069D94
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 04:43:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id e3so9867248edu.4
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 04:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfhjsBQJDS60fTCuWCeORMFhLzTPkgD37vMZeWmuP2o=;
        b=NnrCYA483U/KkfVlw8emAPlXXztOwPDbrEnWe4ZucJvZr8OjOOt2fI2K5nFfOPVIvw
         YdUUnq7F8q6l0T0JpHYuj6hAuBegRV8TdLMFWZ1OCMcg+Co8mQa6lM/p+/ggTuXfVne8
         xuN01ZDLIae1o8s0LQtOmTAyBIp6uY2789wPJm6wxVjM0/HnP4BL70MAx8lbYNYu3Ykc
         Kq6FPnxyO9BggSjrfhoJMqjjYcZufTwZcvpOLgo+w4ucjuGTNNWTUK9FhBnBeR0NVii3
         XN22G624uCy3ocH15bTdqEVt3Qa513kMgBB2MzHtJQOIiMczCZ5t3zlAgn17R3a6d74f
         oprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfhjsBQJDS60fTCuWCeORMFhLzTPkgD37vMZeWmuP2o=;
        b=RbmIKJfh9t7JVaGPS/6u3mmp6fj9uTOIJaMddWdhIOkyfNWYKrLr8OAw7WwF72Pwpd
         uEj1G/QsgOoDnLVFD8cjC9CPYFVlEAQtSVmLziuVcQBELzBJ1euvPh8ru5OfWkWLiQDn
         Dm+r5/5twsVgrAd7xjr1JwdcDs3IJOtZCtZUw2a581X7uW/LIoI6oWrQothKG8OOZbMt
         7SKHs148nVFvkW4YJFd2Wa6HxNK+QBtF1G7fJFJb3SAKikjPYxc1mn6WOnsDSkzmiWGO
         MlWyq44KJncSXOWdA9RlbH78apiJQi+n3r8LM75P9lHz5NLbfWgbct0ENIK0TR/bEr0D
         eEaA==
X-Gm-Message-State: AOAM530L8mkJy5YZjkAv1kmGWxtvjuJOc5IXdUaDm6FPsRajszPognBa
        cVX0l5tBESpiigVjEghfMYPg0tH8fDeJ7sU9DClftg==
X-Google-Smtp-Source: ABdhPJxPuhLft566KNSyDKcg47gWyEEUaG5gWFMEc2gPqfh1NzpPGjua+fLvmRBHaTozYwbl9jsr6zAoQqxwTWMRUrM=
X-Received: by 2002:a50:e683:: with SMTP id z3mr24875359edm.206.1637757804495;
 Wed, 24 Nov 2021 04:43:24 -0800 (PST)
MIME-Version: 1.0
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
In-Reply-To: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 24 Nov 2021 13:43:13 +0100
Message-ID: <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
Subject: Re: [issue report] pm8001 driver crashes with IOMMU enabled
To:     John Garry <john.garry@huawei.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     Jinpu Wang <jinpu.wang@ionos.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+cc folks from microchips

On Wed, Nov 24, 2021 at 1:28 PM John Garry <john.garry@huawei.com> wrote:
>
> Hi,
>
> When I enable the IOMMU on my arm64 system, the pm8001 driver crashes as
> follows:
>
> [    8.649365] pm80xx 0000:04:00.0: Adding to iommu group 0
> [    8.655901] pm80xx 0000:04:00.0: pm80xx: driver version 0.1.40
> [    8.661755] pm80xx 0000:04:00.0: enabling device (0140 -> 0142)
> [    8.667864] :: pm8001_pci_alloc  530:Setting link rate to default value
> [    9.716548] scsi host0: pm80xx
> [   10.423522] Freeing initrd memory: 413456K
> [   11.693443] Unable to handle kernel paging request at virtual address
> ffff0000fcebfb00
> [   11.701348] Mem abort info:
> [   11.704129]   ESR = 0x96000005
> [   11.707170]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   11.712468]   SET = 0, FnV = 0
> [   11.715510]   EA = 0, S1PTW = 0
> [   11.718637]   FSC = 0x05: level 1 translation fault
> [   11.723501] Data abort info:
> [   11.726368]   ISV = 0, ISS = 0x00000005
> [   11.730190]   CM = 0, WnR = 0
> [   11.733145] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000013d43000
> [   11.739832] [ffff0000fcebfb00] pgd=18000a4fffff8003,
> p4d=18000a4fffff8003, pud=0000000000000000
> [   11.748521] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [   11.754080] Modules linked in:
> [   11.757122] CPU: 1 PID: 7 Comm: kworker/u192:0 Not tainted
> 5.16.0-rc2-dirty #102
> [   11.764505] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI
> RC0 - V1.16.01 03/15/2019
> [   11.773015] Workqueue: 0000:04:00.0_disco_q sas_discover_domain
> [   11.778926] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS
> BTYPE=--)
> [   11.785874] pc : pm80xx_chip_smp_req+0x2d0/0x3d0
> [   11.790479] lr : pm80xx_chip_smp_req+0xac/0x3d0
> [   11.794996] sp : ffff80001258ba60
> [   11.798297] x29: ffff80001258ba60 x28: ffff0020a2892b50 x27:
> ffff0020a2898000
> [   11.805421] x26: ffff0020a3ee0000 x25: 0000000000000008 x24:
> ffff0000fcebfb00
> [   11.812546] x23: ffff8000113ab6b8 x22: 0000000000000000 x21:
> ffff0020a3ed0038
> [   11.819670] x20: ffff0020a2890000 x19: ffff80001258badc x18:
> 00000000fffffffb
> [   11.826794] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000000000000000
> [   11.833917] x14: 0000000000000000 x13: 0000000000000000 x12:
> 0000000000000002
> [   11.841041] x11: 00000a20098b1000 x10: ffff0020b36515f0 x9 :
> 0000000000001000
> [   11.848165] x8 : 00000a20098b0000 x7 : ffff8000117eb7f0 x6 :
> 0000000000000001
> [   11.855288] x5 : 0000000000000f44 x4 : 0000000000001000 x3 :
> 0000000000000000
> [   11.862412] x2 : ffff8000113ab698 x1 : 0000000000000004 x0 :
> ffff8000117eb000
> [   11.869535] Call trace:
> [   11.871969]  pm80xx_chip_smp_req+0x2d0/0x3d0
> [   11.876226]  pm8001_task_exec.constprop.0+0x368/0x520
> [   11.881266]  pm8001_queue_command+0x1c/0x30
> [   11.885437]  smp_execute_task_sg+0xdc/0x204
> [   11.889607]  sas_discover_expander.part.0+0xac/0x6cc
> [   11.894559]  sas_discover_root_expander+0x8c/0x150
> [   11.899337]  sas_discover_domain+0x3ac/0x6a0
> [   11.903594]  process_one_work+0x1d0/0x354
> [   11.907592]  worker_thread+0x13c/0x470
> [   11.911328]  kthread+0x17c/0x190
> [   11.914545]  ret_from_fork+0x10/0x20
> [   11.918110] Code: 371806e1 910006d6 6b16033f 54000249 (38766b05)
> [   11.924192] ---[ end trace b91d59aaee98ea2d ]---
> [   11.928796] note: kworker/u192:0[7] exited with preempt_count 1
>
>
> I notice that the driver is calling virt_to_phys() on a dma_addr_t,
> which is broken:
phys_to_virt you meant.
>
> static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
> struct pm8001_ccb_info *ccb)
> {
> char *preq_dma_addr = NULL;
> __le64 tmp_addr;
>
> tmp_addr = cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
> preq_dma_addr = (char *)phys_to_virt(tmp_addr);
>
The code was there since the initial support in 2013.
f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware
functionalities and relevant changes in common files")

> How is this supposed to work? I assume that someone has enabled the
> IOMMU on a system with one of these cards before.
I guess it's due to the unaligned access to memory on ARM? AFAIK most
of the user are on x86_64.
>
> I have encountered some other RAID cards which bypasses the IOMMU to
> access host memory - is that the case here potentially?
I don't know, maybe guys from microchip can answer.
>
> Thanks,
> John
Thanks for reporting!
