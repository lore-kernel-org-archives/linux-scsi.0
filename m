Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C5CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 08:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiBQIQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 03:16:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbiBQIQN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 03:16:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39FF028421D
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 00:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645085758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=hJtP7jEv4ikV9cp5j+C2g+EBq5xxWYO9LVDtgaoCRQo=;
        b=DdFoe+3sTKH4U9DoCb7ir4k3ngsyZVoh+gJ4Li9dJshQ23DDgrVXcfb3zXlfiahA766/Mh
        /Qo65Z1VBNS0wIDjSrovnh/HMqgszrJ/wg1HVB08ERY9zF3mpRfp0A7V2u+4NVgB81oIXo
        Wzvlm1WPXUcZ0hQ1CpFKTrYZiAcFV2A=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-B_BW9PSdOkaxqeUqx8N8_w-1; Thu, 17 Feb 2022 03:15:56 -0500
X-MC-Unique: B_BW9PSdOkaxqeUqx8N8_w-1
Received: by mail-pf1-f199.google.com with SMTP id d16-20020a056a0010d000b004e0204c9753so2838528pfu.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 00:15:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hJtP7jEv4ikV9cp5j+C2g+EBq5xxWYO9LVDtgaoCRQo=;
        b=7Xdp7IgxSX7MXKbzb64RHy4eRSuUtELhUPVHfqWdTcNGR3e9e2w1Ki6M6Ywt5ZzrHo
         pQ/5AWMhNoXks4Rby/Gbzo5mhrIdyzTAMFHBgil6C9qkNBNbl5olsdJT/qSmBdSl6VIJ
         UM1htso+JzWutmEZPO1cGgR0ts1DTrZ/mlIcUCFiYR/nmmxDhsn4l95baUHQGCSPxEmc
         itYfZU1zRVPoJyoAZv4aJ0ftHqUDagKaxmDLXVWPD/aXCkpwaWz3BnVOmf5a0FqhpKnN
         Ryl9GWO4t2uo2F96slG8662KBD2plZekQvx3KF4pGEKWdrm7Z7ubbkmDm0uiELUEBs+f
         jw8A==
X-Gm-Message-State: AOAM5301701Qt6zkhWRhkohpiyQxL2VvnQtzNomf+D3DBFajo4CrIicQ
        qhLUpjwpm0oGwxPeVzgzeV50Trgd7JbFLLIADH54paNB9C+qHpoToFhUOSqUv0wzEDcDSsQT0eG
        Ho5uvxgs8EqeItURJgaPJkAhKXm42+0hggHxvyw==
X-Received: by 2002:a05:6a00:21c6:b0:49f:dcb7:2bf2 with SMTP id t6-20020a056a0021c600b0049fdcb72bf2mr1799051pfj.19.1645085755145;
        Thu, 17 Feb 2022 00:15:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXtEHGVJshiObUq+pvWFWxLIbPaFex/gDrZcjaB5URECbgGJUUi/yDNlI25Ym/NSwi9Wa0l0rKRpbSaJ8avFM=
X-Received: by 2002:a05:6a00:21c6:b0:49f:dcb7:2bf2 with SMTP id
 t6-20020a056a0021c600b0049fdcb72bf2mr1799030pfj.19.1645085754808; Thu, 17 Feb
 2022 00:15:54 -0800 (PST)
MIME-Version: 1.0
From:   Changhui Zhong <czhong@redhat.com>
Date:   Thu, 17 Feb 2022 16:15:43 +0800
Message-ID: <CAGVVp+Ue7DLe17a26Q2WG6bQaaCdRdRjmev6G96K3p4oRccgUg@mail.gmail.com>
Subject: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000078 on kernel 5.17.0-rc4
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, kashyap.desai@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello

Pls help check below BUG which was observed with command "sg_reset -v
-b /dev/sdb" on upstream kernel-5.17.0-rc4.

thanks

[1]

kernel repo:https://github.com/torvalds/linux.git

[2]

[81753.794722] BUG: kernel NULL pointer dereference, address: 0000000000000078
[81753.804034] #PF: supervisor read access in kernel mode
[81753.809765] #PF: error_code(0x0000) - not-present page
[81753.815496] PGD 0 P4D 0
[81753.818319] Oops: 0000 [#1] PREEMPT SMP PTI
[81753.824329] CPU: 0 PID: 34840 Comm: sg_reset Kdump: loaded Not
tainted 5.17.0-rc4 #1
[81753.832970] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS
2.4.3 01/17/2017
[81753.841319] RIP: 0010:scmd_printk+0x98/0x100
[81753.846084] Code: 65 48 2b 04 25 28 00 00 00 75 0d 48 83 c4 50 5b
41 5c 41 5d 41 5e 5d c3 e8 e5 ad 39 00 48 8b 83 f8 fe ff ff 8b 8b 18
ff ff ff <48> 8b 50 78 48 85 d2 74 04 48 83 c2 0c be 80 00 00 00 4c 89
e7 e8
[81753.867041] RSP: 0018:ffffc0d4025cfdc0 EFLAGS: 00010286
[81753.872869] RAX: 0000000000000000 RBX: ffff9bb911569d08 RCX: 00000000ffffffff
[81753.880831] RDX: 0000000480998000 RSI: ffffffff9110b161 RDI: 00000000000350e0
[81753.888792] RBP: ffffc0d4025cfe30 R08: 0000000000000080 R09: ffff9bb911569d40
[81753.896754] R10: 0000000000000022 R11: 0000000000000000 R12: ffff9bb904701000
[81753.904715] R13: ffffffffc03654be R14: ffffffffc03636f0 R15: ffff9bb911569d08
[81753.912676] FS:  00007ff22a98e600(0000) GS:ffff9bbc6fc00000(0000)
knlGS:0000000000000000
[81753.921704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[81753.928113] CR2: 0000000000000078 CR3: 0000000103ac0002 CR4: 00000000001706f0
[81753.936075] Call Trace:
[81753.938802]  <TASK>
[81753.941141]  ? cred_has_capability.isra.0+0x78/0x120
[81753.946687]  megasas_reset_bus_host+0x2d/0xf0 [megaraid_sas]
[81753.953008]  ? scsi_init_command+0x102/0x1a0
[81753.957771]  scsi_try_host_reset+0x3a/0xd0
[81753.962344]  scsi_ioctl_reset+0x220/0x290
[81753.966817]  blkdev_ioctl+0x13e/0x280
[81753.970903]  __x64_sys_ioctl+0x82/0xb0
[81753.975084]  do_syscall_64+0x3b/0x90
[81753.979073]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[81753.984708] RIP: 0033:0x7ff22a7c6c0b
[81753.988698] Code: 73 01 c3 48 8b 0d 1d 62 1b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed 61 1b 00 f7 d8 64 89
01 48
[81754.009652] RSP: 002b:00007ffc40e3e7d8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[81754.018099] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007ff22a7c6c0b
[81754.026060] RDX: 00007ffc40e3e804 RSI: 0000000000002284 RDI: 0000000000000003
[81754.034022] RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000077
[81754.041983] R10: 0000000000000063 R11: 0000000000000246 R12: 00007ffc40e3e804
[81754.049944] R13: 00007ffc40e4081f R14: 000055711a8e290d R15: 000055711a8e4020
[81754.057906]  </TASK>
[81754.060339] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
dns_resolver nfs lockd grace fscache netfs sunrpc dm_multipath
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm mgag200 i2c_algo_bit
drm_shmem_helper drm_kms_helper dell_wmi_descriptor syscopyarea rfkill
sysfillrect video sysimgblt fb_sys_fops ipmi_ssif cec irqbypass rapl
intel_cstate dcdbas intel_uncore iTCO_wdt mei_me ipmi_si mxm_wmi mei
iTCO_vendor_support ses pcspkr enclosure scsi_transport_sas lpc_ich
ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c
sd_mod t10_pi sg ahci libahci crct10dif_pclmul crc32_pclmul
crc32c_intel megaraid_sas libata ghash_clmulni_intel tg3 wmi dm_mirror
dm_region_hash dm_log dm_mod
[81754.134169] CR2: 0000000000000078

-- 
Best Regards,
  Changhui Zhong

