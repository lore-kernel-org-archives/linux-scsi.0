Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAABFC77B73
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 03:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbjFFDRb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 23:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjFFDRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 23:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6FF127
        for <linux-scsi@vger.kernel.org>; Mon,  5 Jun 2023 20:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686021405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=q0RfyB+wRaMVmrfPDcEL7PT0iuGuLLwJieOrWccLQLM=;
        b=Wd0yf2B6aDCUkQyMSkU/kvSjdhmg42LY1Dxz5aA503Bdmf4BKiKRH8nRqBwtTAfSDWOkqn
        UvaqsPouyb7Be4Y1uDK/KCooPVRk53oK3D0ZTccoMVhKw9x668Rjjpswwn687vq8E5+9Ja
        s+bFEPxBgrewhZ1PhonTTPpAaR0UusU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-CGrCBQZXNfW0HC_sDIS4uw-1; Mon, 05 Jun 2023 23:16:43 -0400
X-MC-Unique: CGrCBQZXNfW0HC_sDIS4uw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514b8a3c0d3so3411798a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jun 2023 20:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686021402; x=1688613402;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q0RfyB+wRaMVmrfPDcEL7PT0iuGuLLwJieOrWccLQLM=;
        b=PHAr04JNAEt+1UAgBBKLFPa+GE85IOLHKGiIdE8cpdyZnghYZcLb+YpWY6l12HgNWE
         9awdxMr4SIJXyeewCX73WL9CdBbOzHSeg4DJfC8V4z+D+uwiPZE4S1mFPEGa7hZRqU2f
         GelW97XFpzn9og8w4D3FY2HCOioD1fHLhkda4e0nznisKScCz6KOtuX3dZPHmcZr2376
         ubV4lSjk4uKPGFQi5KcJJ1PL1dlAIWgzsC/1LbXncxfe5QUINC6zF8hIsnWut/vr1KZ8
         gASKUgpGNmiVquyiiy6DnfjnJVPcOzzj+uAhLdWWsWX++MmezFEW15ZhkGRk/VI1uBCw
         wFlw==
X-Gm-Message-State: AC+VfDwDdTTI7UF/U/wdEZAJH5Pp3ROZlLoHJ6l4qeQEW+CIvDLbm0Hx
        1bhe8fyoyxHbXfsNtGaPwtZL6La9FZnABC5SFm+EemA0xJ30yxhTXNk6BML+S/mw3wAI6U7i2Tb
        R685eH/3AnIfvDRg9vdcytxpIS2Qbv3gbqZZVUCmwJuY3VJgN1I4=
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id s7-20020a056402014700b005149c05819emr722352edu.0.1686021402202;
        Mon, 05 Jun 2023 20:16:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ49ClK6v/MPZZe0RrYXrXTEPlGTRu6WG4TG9CSzTJco6j3U5HVw5N2YpRVvwayoK9AhU+2cAvois/dl22431JQ=
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id
 s7-20020a056402014700b005149c05819emr722343edu.0.1686021401877; Mon, 05 Jun
 2023 20:16:41 -0700 (PDT)
MIME-Version: 1.0
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Tue, 6 Jun 2023 11:17:47 +0800
Message-ID: <CAGS2=YoMsjT19mVP9Te_Mx1yKpgLDbZuDQnUV_VLCjhJ=F8D8w@mail.gmail.com>
Subject: [bug report] WARNING: CPU: 23 PID: 35995 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        John Meneghini <jmeneghi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
qedf IO testing found the error with latest linux-block/for-next,
please have a look.

kernel repo : https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
commit: Merge branch 'for-6.5/block' into for-next


[ 7305.031233] ------------[ cut here ]------------
[ 7305.033749] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
tx_buff_off=00000000, rx_buff_off=00000000, rx_id=073f
[ 7305.038904] refcount_t: underflow; use-after-free.
[ 7305.038918] WARNING: CPU: 23 PID: 35995 at lib/refcount.c:28
refcount_warn_saturate+0xba/0x110
[ 7305.065853] Modules linked in: nfsv3 nfs_acl bnx2fc cnic uio
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
netfs sunrpc vfat fat dm_service_time dm_multipath intel_rapl_msr
intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm mgag200 i2c_algo_bit drm_shmem_helper
dell_wmi_descriptor drm_kms_helper ipmi_ssif ledtrig_audio
sparse_keymap irqbypass rfkill rapl video syscopyarea intel_cstate
mei_me ipmi_si sysfillrect mei intel_uncore iTCO_wdt sysimgblt pcspkr
iTCO_vendor_support dcdbas mxm_wmi ipmi_devintf lpc_ich
ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sr_mod sd_mod
cdrom t10_pi sg qede qedf crct10dif_pclmul crc32_pclmul crc32c_intel
qed ahci libahci ghash_clmulni_intel libata libfcoe libfc tg3
megaraid_sas scsi_transport_fc crc8 wmi dm_mirror dm_region_hash
dm_log dm_mod [last unloaded: tls]
[ 7305.151246] CPU: 23 PID: 35995 Comm: kworker/23:0 Kdump: loaded Not
tainted 6.4.0-rc3+ #1
[ 7305.160379] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS
2.16.0 07/20/2022
[ 7305.168832] Workqueue: qedf_io_wq qedf_fp_io_handler [qedf]
[ 7305.175069] RIP: 0010:refcount_warn_saturate+0xba/0x110
[ 7305.180911] Code: 01 01 e8 c9 4d ae ff 0f 0b c3 cc cc cc cc 80 3d
1a ae 6f 01 00 75 85 48 c7 c7 d8 e3 bb ac c6 05 0a ae 6f 01 01 e8 a6
4d ae ff <0f> 0b c3 cc cc cc cc 80 3d f5 ad 6f 01 00 0f 85 5e ff ff ff
48 c7
[ 7305.201873] RSP: 0018:ffff9cc488507e80 EFLAGS: 00010282
[ 7305.207708] RAX: 0000000000000000 RBX: ffff904a44ac7410 RCX: 0000000000000027
[ 7305.215685] RDX: ffff904e2fcdf848 RSI: 0000000000000001 RDI: ffff904e2fcdf840
[ 7305.223654] RBP: ffff9046cc488040 R08: 80000000ffff9b21 R09: 657466612d657375
[ 7305.231623] R10: 203b776f6c667265 R11: 646e75203a745f74 R12: ffff904e2fcf1880
[ 7305.239591] R13: ffffbcc47fcc7500 R14: 0000000000000000 R15: ffffbcc47fcc7505
[ 7305.247559] FS:  0000000000000000(0000) GS:ffff904e2fcc0000(0000)
knlGS:0000000000000000
[ 7305.256595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7305.263011] CR2: 0000563088c3b008 CR3: 0000000102bfc006 CR4: 00000000001706e0
[ 7305.267445] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
Error detection CQE, xid=0x743
[ 7305.270983] Call Trace:
[ 7305.280598] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
err_warn_bitmap=00000040:00000000
[ 7305.283328]  <TASK>
[ 7305.283330]  qedf_fp_io_handler+0x40/0x50 [qedf]
[ 7305.293237] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
tx_buff_off=00000000, rx_buff_off=00000000, rx_id=04ec
[ 7305.295574]  process_one_work+0x1e5/0x3f0
[ 7305.296755] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
Error detection CQE, xid=0x194
[ 7305.296761] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
err_warn_bitmap=00000040:00000000
[ 7305.296764] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
tx_buff_off=00000000, rx_buff_off=00000000, rx_id=013d
[ 7305.324202] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
Error detection CQE, xid=0x37c
[ 7305.326752]  ? __pfx_worker_thread+0x10/0x10
[ 7305.336659] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
err_warn_bitmap=00000040:00000000
[ 7305.337543] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
Error detection CQE, xid=0x47b
[ 7305.337549] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
err_warn_bitmap=00000000:00004000
[ 7305.337552] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
tx_buff_off=00000000, rx_buff_off=00000000, rx_id=06ed
[ 7305.348603]  worker_thread+0x50/0x3a0
[ 7305.358219] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
tx_buff_off=00000000, rx_buff_off=00000000, rx_id=04ed
[ 7305.362987]  ? __pfx_worker_thread+0x10/0x10
[ 7305.373920] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
Error detection CQE, xid=0x731
[ 7305.382497]  kthread+0xe2/0x110
[ 7305.382502]  ? __pfx_kthread+0x10/0x10
[ 7305.382505]  ret_from_fork+0x2c/0x50
[ 7305.382511]  </TASK>
[ 7305.382512] ---[ end trace 0000000000000000 ]---

