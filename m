Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D0BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 13:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiCVNY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiCVNY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 09:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C58855AEE2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647955377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=hrtFoYwM965JL+1NIySpFg42HnshA7NZZNhw6B5RIc0=;
        b=eV/0LigzwwRfvY9S92xwVNJpQFiz6yqUld4rnMidGv/AWpzbG6twIQMQX+mBF9kp81RvsP
        njiUU1SLNxSYlVhM2l+mdOgfamEe/pifPb1hen5jqGqfMDHJEUMfbKTdm2RfDNyaA66U0X
        1ggJ5suQ5bB61f4Cp4NF03Ri3cC5Szc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-adZO6JQLOkiyyu8qNjYfDg-1; Tue, 22 Mar 2022 09:22:56 -0400
X-MC-Unique: adZO6JQLOkiyyu8qNjYfDg-1
Received: by mail-lf1-f71.google.com with SMTP id z39-20020a0565120c2700b0044a219505a4so1703646lfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 06:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hrtFoYwM965JL+1NIySpFg42HnshA7NZZNhw6B5RIc0=;
        b=6WhXCdlqWXxqIx4ByX7V2a2ilEHlewZMrQVWYQjm0R0LvQ9NjH8Zd6sCkEm+DZrvgO
         UUkZNjJGxAwiAvxQeYD4WtY3MKgIq4fHFhKl/SevszMN3BoKe06SKInBJDWMkgl5Ak87
         YnVW8rzKHU9VqiC/GZo+TpbJCHzqsDmNPIqK5ITWenyDWZbV8cZ7kuKx9x5RElHU/frO
         vu+0h6Xd5nfRiuqCSMgq2sUp5g5/CrqEjDUiRkh+PPloskBVNgJjwg9KGINFjsA6SNlk
         F36QwgKamJztuqMpW/pj5iUVICtH1UZAaBtPuQYQVKl+S4kqwNq0pFNhOD73aKNjVp7R
         wniA==
X-Gm-Message-State: AOAM5331ieZPL3JAusSueOaSCGK7VWT/Cz/4Ns76OUKBg9KuLahk2Y9Z
        YMNefPX3xohLfDHi1Z0iuvMldD3ZeCWJYvaIitUAFs60ErI72A7H43gKQxT4lr99HsSq5LLsinP
        oKwDiWKT+zRN3rjJNe4ViwrwStxrnW3dsQ5Es5A==
X-Received: by 2002:a2e:2e0e:0:b0:249:677d:8333 with SMTP id u14-20020a2e2e0e000000b00249677d8333mr16982904lju.37.1647955374658;
        Tue, 22 Mar 2022 06:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaGUJ3IiSfN0eea9UUBW48LiQQa+++GmvQZvFy46rAde/r4xsLy7/vug+W9vcRBpjcCgi8cgGP25Nvoq2+r60=
X-Received: by 2002:a2e:2e0e:0:b0:249:677d:8333 with SMTP id
 u14-20020a2e2e0e000000b00249677d8333mr16982887lju.37.1647955374412; Tue, 22
 Mar 2022 06:22:54 -0700 (PDT)
MIME-Version: 1.0
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Tue, 22 Mar 2022 14:22:43 +0100
Message-ID: <CA+QYu4p=6PwferesmnEEknRjigVw-2Qo6SYHA-tx-+Fevezj4w@mail.gmail.com>
Subject: Panic at pc : _base_readl+0x4/0x20 [mpt3sas] - kernel 5.17.0
To:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

We've observed the panic below when testing a mainline kernel, it is
not 100% reproducible in our machine though.

[  225.507306] mpt3sas_cm0 fault info from func: mpt3sas_base_make_ioc_ready
[  225.514159] mpt3sas_cm0: fault_state(0x5854)!
[  225.518509] mpt3sas_cm0: sending diag reset !!
[  225.916444] Internal error: synchronous external abort: 96000610 [#1] SMP
[  225.923230] Modules linked in: tls rfkill sunrpc joydev i2c_smbus
qede qed vfat fat ipmi_ssif ipmi_devintf ipmi_msghandler thunderx2_pmu
cppc_cpufreq fuse zram xfs ast i2c_algo_bit drm_vram_helper
drm_kms_helper crct10dif_ce ghash_ce syscopyarea sysfillrect sysimgblt
fb_sys_fops cec drm_ttm_helper ttm mpt3sas drm raid_class
scsi_transport_sas gpio_xlp i2c_xlp9xx
[  225.955353] CPU: 0 PID: 7 Comm: kworker/u448:0 Not tainted 5.17.0 #1
[  225.961699] Hardware name: Default string MT91-FS1/MT91-FS1, BIOS
F28 12/27/2019
[  225.969084] Workqueue: poll_mpt3sas0_statu _base_fault_reset_work [mpt3sas]
[  225.976070] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  225.983025] pc : _base_readl+0x4/0x20 [mpt3sas]
[  225.987566] lr : _base_wait_on_iocstate+0x88/0x120 [mpt3sas]
[  225.993233] sp : ffff80000b5ebc20
[  225.996537] x29: ffff80000b5ebc20 x28: 0000000000000000 x27: 0000000000000000
[  226.003668] x26: ffff000814d5a830 x25: 0000000050000000 x24: 0000000040000000
[  226.010798] x23: 0000000010000000 x22: 0000000000004e1f x21: ffff000814d5a810
[  226.017927] x20: 0000000000000004 x19: 0000000000000000 x18: ffffffffffffffff
[  226.025056] x17: 0000000000000000 x16: ffff00080a67bd78 x15: ffff80008b5eb9ef
[  226.032185] x14: ffffffffffffffff x13: 0000000000000000 x12: ffff8000095df498
[  226.039313] x11: ffff800009f8f698 x10: 0000000000001d40 x9 : ffff8000090efb98
[  226.046442] x8 : ffff00080323bf20 x7 : ffff800b62663000 x6 : 0000000e22b02726
[  226.053570] x5 : 00000000430f0af0 x4 : 0000000000f0000f x3 : 00000000000d42a8
[  226.060699] x2 : ffff800001203050 x1 : 0000000000000000 x0 : ffff8000151b0000
[  226.067828] Call trace:
[  226.070263]  _base_readl+0x4/0x20 [mpt3sas]
[  226.074456]  _base_diag_reset+0x2f0/0x378 [mpt3sas]
[  226.079341]  mpt3sas_base_make_ioc_ready.part.0+0xdc/0x1b4 [mpt3sas]
[  226.085703]  mpt3sas_base_hard_reset_handler+0x140/0x424 [mpt3sas]
[  226.091891]  _base_fault_reset_work+0x1cc/0x4a0 [mpt3sas]
[  226.097297]  process_one_work+0x1f0/0x480
[  226.101303]  worker_thread+0x180/0x500
[  226.105045]  kthread+0xd4/0xe0
[  226.108093]  ret_from_fork+0x10/0x20
[  226.111667] Code: d50323bf d65f03c0 d503201f d503233f (b9400000)
[  226.117751] ---[ end trace 0000000000000000 ]---
[  226.122359] Kernel panic - not syncing: synchronous external abort:
Fatal exception
[  226.130004] SMP: stopping secondary CPUs
[  226.133972] Kernel Offset: 0x100000 from 0xffff800008000000
[  226.139534] PHYS_OFFSET: 0x80000000
[  226.143011] CPU features: 0x006,0000450d,19001080
[  226.147705] Memory Limit: none
[  226.150750] ---[ end Kernel panic - not syncing: synchronous
external abort: Fatal exception ]---


Full console.log:
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/03/22/497731769/build_aarch64_redhat:2232309798/tests/11656424_aarch64_5_console.log


Thanks,
Bruno Goncalves

