Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B70AC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 07:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiDBHIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 03:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbiDBHIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 03:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDAE2102423
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 00:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648883208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=HyMSiJlOQvjIy8EGlx27j+iS4lIlX1GOMrjnd5IUUSk=;
        b=IF3v1ffIKPK646r1vPGrHQ5GPej+kjFxTQI8sZKyIACpUXQuLY5PE3O9yMa0ynndxItGHr
        robHTjM3vqfEm13vgQtzApNaNl316IEUp2C4S7M+VfN55jcn6bANEIgh/EW1PL7LJNKav2
        bNOv1Jb3g9OY5hk/kX+goJMh8O660g4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-VVcwbCxROB-HfOCDJdb2Hw-1; Sat, 02 Apr 2022 03:06:47 -0400
X-MC-Unique: VVcwbCxROB-HfOCDJdb2Hw-1
Received: by mail-pf1-f198.google.com with SMTP id y189-20020a6264c6000000b004faecedcb81so2797927pfb.7
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 00:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=HyMSiJlOQvjIy8EGlx27j+iS4lIlX1GOMrjnd5IUUSk=;
        b=oMDhiCZclDIqCgSE6kgMdnNbETN7Y8dizDi/CHnYCKrjIY1cjVgZW29CyHP+I1+bQ8
         OUwmWAAkj12XZET40LajvqKtufldF6sQ0ixF4emb0osT21TAFbj/NfbWVwqAGSW7BH3n
         cPq+lWGesHsEvbHt68kwswAhAzH/RpOU5bdFCFYux01VroAKECFPexL+wpoIARzf9d+H
         mrzPbOA9JiEYpsOo1OYJNpSaphr+5YLScZGCSjyQvgoxaL0F1v65oCUZmrrCCNJ52KY2
         nmTj6LbGetFJRQn3kpoPQAaRN/i7ZtKU1d6pF5P28i1Aq9z1pIca7gZTUfha3ZFXF62K
         4fhg==
X-Gm-Message-State: AOAM53389XlOxlek0Dywoye7xKxw0jGwj0xF/NMWkgdMIQ/Bmy+PiF2X
        gcfIq3HnDjX/iTmlk6pQgSFX6s7j2O1GwwhPNPBLIRW0LGdXmWM5ygfjHNHYFC1EvX9kPAHDIWE
        bo4pgM2p/nMG8CJTf4OebOPk1fSOvUUk45S2YMA==
X-Received: by 2002:a17:902:ce8f:b0:154:6031:b53e with SMTP id f15-20020a170902ce8f00b001546031b53emr13551112plg.159.1648883206215;
        Sat, 02 Apr 2022 00:06:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyZf4Lobqcgjo9zG6mfY2sEsOCsigZvVE7GNj0PFthgZr9CyVzKyvMFUQmY8B8MBMZ7a6nW2jFTGZm5x3/8C8=
X-Received: by 2002:a17:902:ce8f:b0:154:6031:b53e with SMTP id
 f15-20020a170902ce8f00b001546031b53emr13551096plg.159.1648883205929; Sat, 02
 Apr 2022 00:06:45 -0700 (PDT)
MIME-Version: 1.0
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Sat, 2 Apr 2022 15:06:34 +0800
Message-ID: <CAHj4cs8F51f_Br7kBPYN0yDo4FqFFbodHAUN6_c=Rd4Bd+Y1sw@mail.gmail.com>
Subject: [bug report][bisected] modprob -r scsi-debug take more than 3mins
 during blktests srp/ tests
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello
I found the scsi-debug module removing [1] takes more than 3mins
during blktests srp/ tests, and bisecting shows it was introduced from
[2],
Pls help check it, let me know if you need more info for it, thanks.

[1]
# time ./check srp/001
srp/001 (Create and remove LUNs)                             [passed]
    runtime    ...  3.194s
real 3m12.119s
user 0m0.859s
sys 0m2.227s

# ps aux | grep modprobe
root      250153  0.0  0.0  10600  2264 pts/0    D+   01:34   0:00
modprobe -r scsi_debug

# cat /proc/250153/stack
[<0>] blk_execute_rq+0x95/0xb0
[<0>] __scsi_execute+0xe2/0x250
[<0>] sd_sync_cache+0xac/0x190
[<0>] sd_shutdown+0x67/0xf0
[<0>] sd_remove+0x39/0x80
[<0>] __device_release_driver+0x234/0x240
[<0>] device_release_driver+0x23/0x30
[<0>] bus_remove_device+0xd8/0x140
[<0>] device_del+0x18b/0x3f0
[<0>] __scsi_remove_device+0x102/0x140
[<0>] scsi_forget_host+0x55/0x60
[<0>] scsi_remove_host+0x72/0x110
[<0>] sdebug_driver_remove+0x22/0xa0 [scsi_debug]
[<0>] __device_release_driver+0x181/0x240
[<0>] device_release_driver+0x23/0x30
[<0>] bus_remove_device+0xd8/0x140
[<0>] device_del+0x18b/0x3f0
[<0>] device_unregister+0x13/0x60
[<0>] sdebug_do_remove_host+0xd1/0xf0 [scsi_debug]
[<0>] scsi_debug_exit+0x58/0xe1e [scsi_debug]
[<0>] __do_sys_delete_module.constprop.0+0x170/0x260
[<0>] do_syscall_64+0x3a/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

# dmesg | tail -10
[  345.863755] ib_srpt:srpt_release_channel_work: ib_srpt 10.16.221.74-32
[  345.863855] ib_srpt:srpt_release_channel_work: ib_srpt 10.16.221.74-34
[  345.863953] ib_srpt:srpt_release_channel_work: ib_srpt 10.16.221.74-36
[  346.373371] sd 15:0:0:0: [sdb] Synchronizing SCSI cache
[  532.864536] sd 15:0:0:0: [sdb] Synchronize Cache(10) failed:
Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
------> seems most of the time were taken here
[  532.929626] eno1np0 speed is unknown, defaulting to 1000
[  532.938524] eno2np1 speed is unknown, defaulting to 1000
[  532.943957] eno4 speed is unknown, defaulting to 1000
[  532.998059] rdma_rxe: rxe-ah pool destroyed with unfree'd elem
[  533.011781] rdma_rxe: unloaded

[2]
commit 2aad3cd8537033cd34f70294a23f54623ffe9c1b (refs/bisect/bad)
Author: Douglas Gilbert <dgilbert@interlog.com>
Date:   Sat Jan 8 20:28:45 2022 -0500

    scsi: scsi_debug: Address races following module load

