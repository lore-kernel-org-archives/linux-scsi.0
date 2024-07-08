Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673CF19470
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720423647; cv=none; b=NUjmQpTOMwrKqsX17SF4DFgCg+lSge8h+XKk35lbSoUitJIn1aK3gQbZhb3v6g+hWINfy6JH28N22oXletfIOxrnu5/Ojd4ZToqlcwpAfQX5CA+2DxNTBIfse/TmJlT4ZYc44UIDmmjbuKCbtptSlNotW0wvzDAMpNI6HAFMtxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720423647; c=relaxed/simple;
	bh=GoP44aPdKfoTyB+JMv9xxdLEs/eSwFghgNBApYFCAIw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=dxwxy3/E78Y/58ShLrt9inhDCiRTOehRdVLKM3RbH7VBtZvmxkm8zaG5UmtKwddri3Y4dIsS/uRlqYLvf7foLEQYKpRozYFgYfV2T1nJnGehoNfw+OOvMwlo+VXQ4vPpEJcUYtmXSFztm5mzDEDroBzj7V63U/j44asQBCN0nNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVBvvPZm; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVBvvPZm"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-64b05fab14eso34543867b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 00:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720423644; x=1721028444; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yeX0L0LRBQKiRHorHHT2/gyOJkBPuY45BcfUPAMMZEA=;
        b=RVBvvPZmLOFceiLTIfo7jy916v7j7YigHqWu8CzaHyih13Ky/2lmL/ze1iatXjgtpn
         3PxJ0CN5q39eeIxWM1OO2poJRDPsDjVmwTZxepAdRA15JKHmwFILcfMnIc7N4vRwH4yg
         zbCZcyFFzcCgSd7XHh2MPZGVUGJvJyn+m72y8Uibe5zFMJI+cqFEx/X0bs8I4Vqr7YQj
         EWPpcxi/RktYrs81jUYgT8BDhQJHg/GCCwwS+LG+pHuaOUGB2Fo52JYbZLNl21shzAJQ
         +nEGyJ3JrxvQMzhIhu4EnK2wrmza0ZLu86IKBthhTjhm6iBE8U++DRH2gvMKBAkRte92
         mIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720423644; x=1721028444;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yeX0L0LRBQKiRHorHHT2/gyOJkBPuY45BcfUPAMMZEA=;
        b=mUDf+qevf1l6K3j/nqW8MXpZTwp/DscVPPjxrHp+Y8upYnPGJqazxrz2bLGZoufgVG
         kANUjVb4SfYYFOP8YY2TKaWImFFHWIKOGHcmkBIH1iDeSxxILsahF5tBRvj+Ayh+gZjg
         ZhC/yBSslwmsZ4Q6hw+qq9QO7HIvtOLjDK7NcG6bOVii61EdDwJHK6SmhkX9z2sHomXZ
         54DALFlhCf28UdmaQ6fEMm7nLzt4QScGHseEkNl4Qtlp+GRY71QsgxQmQNs0a2odF468
         eKtorTuzNjNARVFVWEo7nW3HLDbyW5583deZhRnneRNLBuUQChrvaCJi5VH2MUZ1oRN1
         ju7A==
X-Gm-Message-State: AOJu0YxFvGm6j3r8tyL60SYj1GE97sdWeTeVTJsEDrcpaE5g8yYHgaV9
	K7OFplYo4o6gCBGLJsk74V/nw5vclEJwPX5ersZ5f3ygDQzwmzfiMxkjkJaz4khGZQa5970IZ9y
	5cLVe0p7FwrOTA/tezhQ34FTcfVv+7IVW400Vfw==
X-Google-Smtp-Source: AGHT+IE17RB1S83B67Zbvv521rO/chSeoSZBY8lZp02IBu5+WbAQirdLWQ+boSvx80vxbjfVCxUK6IFpx7rYIT8PgXQ=
X-Received: by 2002:a05:690c:7090:b0:64b:7bf3:cf93 with SMTP id
 00721157ae682-652d7d528bbmr130709097b3.35.1720423644288; Mon, 08 Jul 2024
 00:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiatong Shen <yshxxsjt715@gmail.com>
Date: Mon, 8 Jul 2024 15:27:13 +0800
Message-ID: <CALqm=dfuV5038UezFUHZGXh9Dx9xj24_aucxnqXf6J9jGaPNCg@mail.gmail.com>
Subject: Asking for help to debug a lpfc driver panic
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello community,

    I am sorry in advance if this is not the right place to ask for help.

    We are using Ubuntu 18.04.3 with kernel 4.15.0-72. We saw there
are occasional kernel panics with the following message

[871224.377774] BUG: unable to handle kernel NULL pointer dereference
at 000000000000000c
[871224.386333] IP: lpfc_sli4_cq_get+0x23/0x80 [lpfc]
[871224.391703] PGD 0 P4D 0
[871224.394898] Oops: 0000 [#1] SMP PTI
[871224.398843] Modules linked in: act_police cls_u32 cls_fw sch_sfq
sch_htb xt_CT xt_mac xt_state devlink ebtable_filter ebtables
ip6table_raw ip6table_mangle dummy vhost_net vhost tap xt_set
ipt_rpfilter x
t_multiport iptable_raw ip_set_hash_net ip_set_hash_ip ip_set ipip
tunnel4 ip_tunnel veth ip6table_nat xt_statistic xt_nat xt_recent
ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_addrtype ip_vs_sh ip_vs_wrr
ip_vs_r
r ip_vs iptable_mangle xt_physdev xt_conntrack xt_comment xt_mark
nf_conntrack_netlink xfrm_user xfrm_algo nf_conntrack_ftp udp_diag
tcp_diag inet_diag ip6table_filter ip6_tables iptable_filter aufs
ipt_MASQ
UERADE nf_nat_masquerade_ipv4 iptable_nat rbd libceph overlay
sch_ingress vxlan ip6_udp_tunnel udp_tunnel nfnetlink_cttimeout
nfnetlink openvswitch nsh nf_conntrack_ipv6 nf_nat_ipv6
nf_conntrack_ipv4
[871224.472519]  nf_defrag_ipv4 nf_nat_ipv4 nf_defrag_ipv6 nf_nat
nf_conntrack bonding nls_iso8859_1 dm_round_robin kvm_intel kvm
irqbypass ipmi_ssif joydev input_leds ipmi_si ipmi_devintf
ipmi_msghandler sc
h_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi br_netfilter bridge stp llc ip_tables
x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
 async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
raid0 multipath linear dm_service_time lpfc ast drm_kms_helper
syscopyarea sysfillrect nvmet_fc sysimgblt igb fb_sys_fops nvmet
crct10di
f_pclmul nvme_fc crc32_pclmul ghash_clmulni_intel ttm pcbc dca
hid_generic i40e nvme_fabrics aesni_intel nvme_core aes_x86_64
crypto_simd ptp glue_helper usbhid pps_core i2c_algo_bit drm
megaraid_sas
[871224.547334]  scsi_transport_fc cryptd hid ahci libahci scsi_dh_emc
scsi_dh_rdac scsi_dh_alua dm_multipath
[871224.557960] CPU: 29 PID: 1445795 Comm: kworker/29:1 Not tainted
4.15.0-72-generic #81-Ubuntu
[871224.567145] Hardware name: Inspur NF5280M5/YZMB-00882-104, BIOS
4.0.9 01/05/2019
[871224.575431] Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
[871224.581992] RIP: 0010:lpfc_sli4_cq_get+0x23/0x80 [lpfc]
[871224.587935] RSP: 0018:ffffa3d251493e40 EFLAGS: 00010286
[871224.593878] RAX: 0000000000000d7d RBX: 0000000000000001 RCX:
0000000000000000
[871224.601740] RDX: 0000000000000d7d RSI: 0000000000000282 RDI:
ffff90d7b19e0000
[871224.609612] RBP: ffffa3d251493e78 R08: 0000000000000001 R09:
0000000000000000
[871224.617488] R10: ffffa3d251493de8 R11: 0000000000000394 R12:
0000000000000000
[871224.625364] R13: ffff90d7b19e00e0 R14: ffff90d7b2900000 R15:
ffff90d7b19e0000
[871224.633241] FS:  0000000000000000(0000) GS:ffff90d7c2040000(0000)
knlGS:0000000000000000
[871224.642073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[871224.648556] CR2: 000000000000000c CR3: 000000388000a001 CR4:
00000000007626e0
[871224.656439] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[871224.664333] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[871224.672228] PKRU: 55555554
[871224.675706] Call Trace:
[871224.678932]  ? lpfc_sli4_hba_process_cq+0x63/0x120 [lpfc]
[871224.685116]  process_one_work+0x1de/0x420
[871224.689918]  worker_thread+0x32/0x410
[871224.694378]  kthread+0x121/0x140
[871224.698401]  ? process_one_work+0x420/0x420
[871224.703391]  ? kthread_create_worker_on_cpu+0x70/0x70
[871224.709252]  ret_from_fork+0x35/0x40

We are able to save the vmcore file, and the bt yields,

crash> bt
PID: 1445795  TASK: ffff90d4e8303b80  CPU: 29  COMMAND: "kworker/29:1"
 #0 [ffffa3d251493ac0] machine_kexec at ffffffffa50653e3
 #1 [ffffa3d251493b20] __crash_kexec at ffffffffa512fcc9
 #2 [ffffa3d251493be8] crash_kexec at ffffffffa5130a31
 #3 [ffffa3d251493c08] oops_end at ffffffffa50317c8
 #4 [ffffa3d251493c30] no_context at ffffffffa507641c
 #5 [ffffa3d251493c98] __bad_area_nosemaphore at ffffffffa50767d3
 #6 [ffffa3d251493cd8] bad_area_nosemaphore at ffffffffa50768a4
 #7 [ffffa3d251493ce8] __do_page_fault at ffffffffa507717b
 #8 [ffffa3d251493d60] do_page_fault at ffffffffa507757e
 #9 [ffffa3d251493d90] page_fault at ffffffffa5a01605
    [exception RIP: lpfc_sli4_cq_get+35]
    RIP: ffffffffc068d3f3  RSP: ffffa3d251493e40  RFLAGS: 00010286
    RAX: 0000000000000d7d  RBX: 0000000000000001  RCX:
0000000000000000
    RDX: 0000000000000d7d  RSI: 0000000000000282  RDI:
ffff90d7b19e0000
    RBP: ffffa3d251493e78   R8: 0000000000000001   R9:
0000000000000000
    R10: ffffa3d251493de8  R11: 0000000000000394  R12:
0000000000000000
    R13: ffff90d7b19e00e0  R14: ffff90d7b2900000  R15:
ffff90d7b19e0000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#10 [ffffa3d251493e40] lpfc_sli4_hba_process_cq at ffffffffc06910d3
[lpfc]
#11 [ffffa3d251493e80] process_one_work at ffffffffa50ab9ae
#12 [ffffa3d251493ec8] worker_thread at ffffffffa50abc22
#13 [ffffa3d251493f08] kthread at ffffffffa50b2621
#14 [ffffa3d251493f50] ret_from_fork at ffffffffa5a00205

Is this a known issue? Thank you.
--

Best Regards,

Norman
