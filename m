Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5500CC77B7A
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 13:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjFFNDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 09:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjFFNDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 09:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A81F4
        for <linux-scsi@vger.kernel.org>; Tue,  6 Jun 2023 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686056560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JRcRRTG+mqlO4mJEu7HX8NmYwUMGAhmL5rrRoJ2JEDQ=;
        b=DPUa1HwB9AkMCMZfkgK2sX6M7aqmMcQ/zlozUxvQEw+jQLqLyxHa8sLEurIWi6VJpZvU8w
        I+7pwrkUPWvLA/E1Ys2Y/TuT9VOclPcrp7oVQd7pfeiyi9kFJy96FzodOBiUJjt8mKZo0V
        nUku9fup1G8UY3r2Zw3Tid/9N/0Mv40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-yEd6r6VfORGUXlT2TpcTCw-1; Tue, 06 Jun 2023 09:02:37 -0400
X-MC-Unique: yEd6r6VfORGUXlT2TpcTCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53C0C8032F5;
        Tue,  6 Jun 2023 13:02:36 +0000 (UTC)
Received: from [10.22.16.51] (unknown [10.22.16.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2A554087C62;
        Tue,  6 Jun 2023 13:02:35 +0000 (UTC)
Message-ID: <3ef3bb51-ed26-9f52-84cf-93dc3f365ccb@redhat.com>
Date:   Tue, 6 Jun 2023 09:02:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [bug report] WARNING: CPU: 23 PID: 35995 at lib/refcount.c:28
 refcount_warn_saturate+0xba/0x110
Content-Language: en-US
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
References: <CAGS2=YoMsjT19mVP9Te_Mx1yKpgLDbZuDQnUV_VLCjhJ=F8D8w@mail.gmail.com>
Cc:     Guangwu Zhang <guazhang@redhat.com>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <CAGS2=YoMsjT19mVP9Te_Mx1yKpgLDbZuDQnUV_VLCjhJ=F8D8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Saurav, Nilesh,

Can you please look into this?  It seems we have a major regression in the 6.5 QEDF driver.

/John

On 6/5/23 23:17, Guangwu Zhang wrote:
> Hi,
> qedf IO testing found the error with latest linux-block/for-next,
> please have a look.
> 
> kernel repo : https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> commit: Merge branch 'for-6.5/block' into for-next
> 
> 
> [ 7305.031233] ------------[ cut here ]------------
> [ 7305.033749] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
> tx_buff_off=00000000, rx_buff_off=00000000, rx_id=073f
> [ 7305.038904] refcount_t: underflow; use-after-free.
> [ 7305.038918] WARNING: CPU: 23 PID: 35995 at lib/refcount.c:28
> refcount_warn_saturate+0xba/0x110
> [ 7305.065853] Modules linked in: nfsv3 nfs_acl bnx2fc cnic uio
> rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
> netfs sunrpc vfat fat dm_service_time dm_multipath intel_rapl_msr
> intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm mgag200 i2c_algo_bit drm_shmem_helper
> dell_wmi_descriptor drm_kms_helper ipmi_ssif ledtrig_audio
> sparse_keymap irqbypass rfkill rapl video syscopyarea intel_cstate
> mei_me ipmi_si sysfillrect mei intel_uncore iTCO_wdt sysimgblt pcspkr
> iTCO_vendor_support dcdbas mxm_wmi ipmi_devintf lpc_ich
> ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sr_mod sd_mod
> cdrom t10_pi sg qede qedf crct10dif_pclmul crc32_pclmul crc32c_intel
> qed ahci libahci ghash_clmulni_intel libata libfcoe libfc tg3
> megaraid_sas scsi_transport_fc crc8 wmi dm_mirror dm_region_hash
> dm_log dm_mod [last unloaded: tls]
> [ 7305.151246] CPU: 23 PID: 35995 Comm: kworker/23:0 Kdump: loaded Not
> tainted 6.4.0-rc3+ #1
> [ 7305.160379] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS
> 2.16.0 07/20/2022
> [ 7305.168832] Workqueue: qedf_io_wq qedf_fp_io_handler [qedf]
> [ 7305.175069] RIP: 0010:refcount_warn_saturate+0xba/0x110
> [ 7305.180911] Code: 01 01 e8 c9 4d ae ff 0f 0b c3 cc cc cc cc 80 3d
> 1a ae 6f 01 00 75 85 48 c7 c7 d8 e3 bb ac c6 05 0a ae 6f 01 01 e8 a6
> 4d ae ff <0f> 0b c3 cc cc cc cc 80 3d f5 ad 6f 01 00 0f 85 5e ff ff ff
> 48 c7
> [ 7305.201873] RSP: 0018:ffff9cc488507e80 EFLAGS: 00010282
> [ 7305.207708] RAX: 0000000000000000 RBX: ffff904a44ac7410 RCX: 0000000000000027
> [ 7305.215685] RDX: ffff904e2fcdf848 RSI: 0000000000000001 RDI: ffff904e2fcdf840
> [ 7305.223654] RBP: ffff9046cc488040 R08: 80000000ffff9b21 R09: 657466612d657375
> [ 7305.231623] R10: 203b776f6c667265 R11: 646e75203a745f74 R12: ffff904e2fcf1880
> [ 7305.239591] R13: ffffbcc47fcc7500 R14: 0000000000000000 R15: ffffbcc47fcc7505
> [ 7305.247559] FS:  0000000000000000(0000) GS:ffff904e2fcc0000(0000)
> knlGS:0000000000000000
> [ 7305.256595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7305.263011] CR2: 0000563088c3b008 CR3: 0000000102bfc006 CR4: 00000000001706e0
> [ 7305.267445] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
> Error detection CQE, xid=0x743
> [ 7305.270983] Call Trace:
> [ 7305.280598] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
> err_warn_bitmap=00000040:00000000
> [ 7305.283328]  <TASK>
> [ 7305.283330]  qedf_fp_io_handler+0x40/0x50 [qedf]
> [ 7305.293237] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
> tx_buff_off=00000000, rx_buff_off=00000000, rx_id=04ec
> [ 7305.295574]  process_one_work+0x1e5/0x3f0
> [ 7305.296755] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
> Error detection CQE, xid=0x194
> [ 7305.296761] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
> err_warn_bitmap=00000040:00000000
> [ 7305.296764] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
> tx_buff_off=00000000, rx_buff_off=00000000, rx_id=013d
> [ 7305.324202] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
> Error detection CQE, xid=0x37c
> [ 7305.326752]  ? __pfx_worker_thread+0x10/0x10
> [ 7305.336659] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
> err_warn_bitmap=00000040:00000000
> [ 7305.337543] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
> Error detection CQE, xid=0x47b
> [ 7305.337549] [0000:04:00.2]:[qedf_process_error_detect:1521]:11:
> err_warn_bitmap=00000000:00004000
> [ 7305.337552] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
> tx_buff_off=00000000, rx_buff_off=00000000, rx_id=06ed
> [ 7305.348603]  worker_thread+0x50/0x3a0
> [ 7305.358219] [0000:04:00.2]:[qedf_process_error_detect:1525]:11:
> tx_buff_off=00000000, rx_buff_off=00000000, rx_id=04ed
> [ 7305.362987]  ? __pfx_worker_thread+0x10/0x10
> [ 7305.373920] [0000:04:00.2]:[qedf_process_error_detect:1519]:11:
> Error detection CQE, xid=0x731
> [ 7305.382497]  kthread+0xe2/0x110
> [ 7305.382502]  ? __pfx_kthread+0x10/0x10
> [ 7305.382505]  ret_from_fork+0x2c/0x50
> [ 7305.382511]  </TASK>
> [ 7305.382512] ---[ end trace 0000000000000000 ]---
> 

