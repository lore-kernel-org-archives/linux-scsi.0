Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB22C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 21:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 260252070A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 21:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="U4k7tWsb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCYVef (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 17:34:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbgCYVef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 17:34:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PLKvaY002972;
        Wed, 25 Mar 2020 14:34:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=bwMyfCcgAdZO0JgUtzsgaFfRBLN5gxgWu3nwI0u2H18=;
 b=U4k7tWsbK1mVYJONDBDukWNvahG9j8VPcHYLo3RngI11zXpUfl24WGGGscFfTnLiohEp
 hd3Ly9Ut71LOP7EpkokdpLCFMZvA2sfcVKfgIAxWcEA+I1zad8sb55UGZy7uFR0GqLOH
 czCvtwpF1ZrTpLQWFVnNwXgllgVkvq6iDcS2jvI/7uYW3gxPt+RuhtM/k3HUdyT9rxyC
 F3EIdjgFwE81whZI+4oiap4OB4kH66XKf7Y57mZmEQtu+Lvn1RyVj5+wUTYWi33bnX4M
 +e82kyQoIIEcs1USkw9s/7JitEowyocPCRPFiCDCvHPVtLP6xaXuoR4Mdzc8ZvZcuNqq 0A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpcrwq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 14:34:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 14:34:32 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 14:34:31 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 14:34:31 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 8E1BD3F703F;
        Wed, 25 Mar 2020 14:34:31 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02PLYU42019099;
        Wed, 25 Mar 2020 14:34:31 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 25 Mar 2020 14:34:30 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Ondrej Zary <linux@zary.sk>
CC:     <linux-scsi@vger.kernel.org>
Subject: Re: NULL pointer dereference in qla24xx_abort_command
In-Reply-To: <202003251906.40982.linux@zary.sk>
Message-ID: <alpine.LRH.2.21.9999.2003251431090.28238@irv1user01.caveonetworks.com>
References: <202003251906.40982.linux@zary.sk>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_11:2020-03-24,2020-03-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 25 Mar 2020, 11:06am, Ondrej Zary wrote:

> Hi Himanshu,
> could you please look into this bug?
> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_linux-2Dscsi_msg138637.html&d=DwICAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=XB49zT5-k3oWvfMuBJCeRK5Sk6o3bkGM6ewB3QuTOME&m=ezZ2dt9wVYnM-c6jJKx9bPQ0-7vbSf5HQ0bGqri_iNE&s=wriOIaA9pVuKVrGPMvcZstNdYbzcZgFVw_OKiM0idIg&e= 
> 
> [2076301.849762] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> [2076301.850021] PGD 0 P4D 0
> [2076301.850109] Oops: 0002 [#1] SMP PTI
> [2076301.850219] CPU: 4 PID: 18992 Comm: kworker/u16:1 Not tainted 4.19.0-8-amd64 #1 Debian 4.19.98-1
> [2076301.850478] Hardware name: Dell Inc. PowerEdge 2950/0JR815, BIOS 2.7.0 10/30/2010
> [2076301.850720] Workqueue: scsi_tmf_4 scmd_eh_abort_handler [scsi_mod]
> [2076301.850936] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
> [2076301.851130] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f a
> e f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
> [2076301.851663] RSP: 0018:ffffa10f8bbe7da8 EFLAGS: 00010293
> [2076301.851820] RAX: 0000000000000800 RBX: ffff8ab8ddd197a8 RCX: 0000000000000070
> [2076301.852036] RDX: ffff8ab8de4a8388 RSI: 0000000000000001 RDI: ffff8ab8799b8c40
> [2076301.852253] RBP: ffff8ab8dc96c480 R08: ffffffffc03b7860 R09: 0000000000000000
> [2076301.852469] R10: 8080808080808080 R11: 0000000000000010 R12: ffff8ab8dea00000
> [2076301.852686] R13: ffff8ab8ddd197a8 R14: 0000000000000000 R15: ffff8ab8dd632000
> [2076301.852902] FS:  0000000000000000(0000) GS:ffff8ab8e7b00000(0000) knlGS:0000000000000000
> [2076301.853142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [2076301.853320] CR2: 0000000000000004 CR3: 00000002203dc000 CR4: 00000000000006e0
> [2076301.853536] Call Trace:
> [2076301.853632]  qla24xx_abort_command+0x218/0x2d0 [qla2xxx]
> [2076301.853799]  ? __switch_to_asm+0x41/0x70
> [2076301.853924]  ? __switch_to_asm+0x35/0x70
> [2076301.854056]  qla2xxx_eh_abort+0x117/0x310 [qla2xxx]
> [2076301.854209]  scmd_eh_abort_handler+0x85/0x220 [scsi_mod]
> [2076301.854375]  process_one_work+0x1a7/0x3a0
> [2076301.854506]  worker_thread+0x30/0x390
> [2076301.854628]  ? create_worker+0x1a0/0x1a0
> [2076301.854753]  kthread+0x112/0x130
> [2076301.854859]  ? kthread_bind+0x30/0x30
> [2076301.854980]  ret_from_fork+0x35/0x40
> [2076301.855095] Modules linked in: loop ipmi_ssif radeon coretemp ttm drm_kms_helper drm kvm i2c_algo_bit i5000_edac iTCO_wdt sg iTCO_vendor_support irqbypass evdev i5k_
> amb serio_raw joydev ipmi_si rng_core pcc_cpufreq dcdbas pcspkr ipmi_devintf acpi_cpufreq ipmi_msghandler button ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb crypt
> o_simd cryptd glue_helper aes_x86_64 dm_service_time dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua uas usb_storage hid_generic usbhid hid sr_mod cdrom ses enc
> losure sd_mod scsi_transport_sas ata_generic qla2xxx ata_piix nvme_fc ehci_pci nvme_fabrics libata uhci_hcd psmouse ehci_hcd nvme_core megaraid_sas usbcore scsi_transport
> _fc lpc_ich mfd_core scsi_mod usb_common bnx2
> [2076301.856887] CR2: 0000000000000004
> [2076301.856999] ---[ end trace e9083db8fb76e126 ]---
> [2076301.857151] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
> [2076301.857345] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f a
> e f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
> [2076301.857878] RSP: 0018:ffffa10f8bbe7da8 EFLAGS: 00010293
> [2076301.858035] RAX: 0000000000000800 RBX: ffff8ab8ddd197a8 RCX: 0000000000000070
> [2076301.858251] RDX: ffff8ab8de4a8388 RSI: 0000000000000001 RDI: ffff8ab8799b8c40
> [2076301.858467] RBP: ffff8ab8dc96c480 R08: ffffffffc03b7860 R09: 0000000000000000
> [2076301.869384] R10: 8080808080808080 R11: 0000000000000010 R12: ffff8ab8dea00000
> [2076301.880412] R13: ffff8ab8ddd197a8 R14: 0000000000000000 R15: ffff8ab8dd632000
> [2076301.891483] FS:  0000000000000000(0000) GS:ffff8ab8e7b00000(0000) knlGS:0000000000000000
> [2076301.902490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [2076301.913344] CR2: 0000000000000004 CR3: 00000002203dc000 CR4: 00000000000006e0
> [2077225.259348] mysqld[2155]: segfault at 0 ip 000056409366ad93 sp 00007fa049514450 error 6 in mysqld[564092eb2000+805000]
> [2077225.270564] Code: c7 45 00 00 00 00 00 8b 7d cc 4c 89 e2 4c 89 f6 e8 62 81 84 ff 49 89 c7 49 39 c4 0f 84 f6 00 00 00 e8 e1 1c 00 00 41 8b 4d 00 <89> 08 85 c9 74 37 4
> 9 83 ff ff 0f 84 9d 00 00 00 f6 c3 06 75 28 4d
> 
> 
> 

Ondrej,

Could you pick up the latest upstream kernel and retry your test (even if 
it takes longer to reproduce)? That way we do not need to spend time on an 
issue that may have already been fixed.

Regards,
-Arun
