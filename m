Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B11CD3C
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 07:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712216088; cv=none; b=HOJLOcmpC5v/syG8JUb+u79VsUfBzAYGIXoSI+bzNTUOoZbVsBoibAXPisVR8e/LnJYBA8F4RdiEklokhPy2za5gogL9PnYv6Ru4wB2ha0b1XXCwcXgYM50hgl0DKTJpgZeUGjDpIvs9u5i0PEQJpFk1Hr9y7Fq4fHvaXoHLCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712216088; c=relaxed/simple;
	bh=8WfBK30QMyJqRd+PWpMJ2bOeUvVvuqs8OBfC6Lb3PJ4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bVhgo7xBPosZpi7/N/ol9MXroZnm5OHLEtJJhDMogM1X084NG8uFcsFhIUKvv/K7uae7MW+jKBxA1nGYu2H+OIj7SJAVdR+u0rcNdh8Sw2lvINPD3eSuZ05Obx6L87gbQ25wJWlp6p9ehn/hQmV2DTpZJCUr9t+pVRrW1yik4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B06Olgje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B06Olgje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712216085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b2hmV0IXl6+Bq3arhTeC6VlYWKGzuRqNaqOjCHLyins=;
	b=B06Olgje87zvItC8HJ3Xe+hHelcG1jTxIv1YVGeT8fZ9fWWkW7GxzweclR2eyonr2IbSZP
	T9qdwkzyoHfYSO/qAv51SW31Ug8QYdQVerq0OH1ljoPfVpI2S5bJHc7REnZ3RelZbtFVcX
	1UH4FVpTuSp6JskDDbayfvv0jdNYuRI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-tvdrIh_3PjWyQWU0ud_Q6w-1; Thu, 04 Apr 2024 03:34:43 -0400
X-MC-Unique: tvdrIh_3PjWyQWU0ud_Q6w-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5d8dc8f906aso400795a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 00:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712216082; x=1712820882;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b2hmV0IXl6+Bq3arhTeC6VlYWKGzuRqNaqOjCHLyins=;
        b=sTqb2HkZoD5NT7/GuQgI1uww0adf1DUsGCpAOdQ9Ioxrxgrkw1Qjz1WKq0LvazrnjM
         jGnbZF9tJagVCzM7BnsYCy2L7pyIu7Vv09aiX9xs27lwx2yYR/CpBE1W7iq+o4tmVXOR
         I00+8R6GFEYVF3BthspRV0txoQNUBrRZ3ioUWU0MZB2k4fGeWi4nZ6QokuPFrkun3WSl
         59WWprTH0sMMc7URtVTttOF31Bk3DSQkNNUuju/D7qNfCxwDvCs+/jtXwKhJMs6aPyda
         r21BGr2+ad2+bcw5TS3Z/lATbll8lC8C6F6abK3Irwv3LQikmWP/wIF7VCIGqfz+m/fy
         Vmdw==
X-Gm-Message-State: AOJu0Yxr8ifRbe/tW2I65wXeC7Uv0j8IZvMbwYWF3A7piRtAYn1SGUm8
	qS8R09ocfymeJNubsosAWbe2uJsQnNG1mMwzRuml2DbJA3d6kuVaoBBmYskOGLvyGECoAzJJ3WM
	G6viwwOUi+noSsiWisgYYknibdkUTNJJSREyTQFypoOivU29wrUYXXIBCY8wtiFmcaFZIismBaD
	DDvQZTgkRtDdzlZOOCPn9wl4YcqnFQfJuXbvvOX5DE2P6DXac=
X-Received: by 2002:a05:6a20:12c3:b0:1a3:c43b:2c2c with SMTP id v3-20020a056a2012c300b001a3c43b2c2cmr2106266pzg.47.1712216082689;
        Thu, 04 Apr 2024 00:34:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFh7A4hMiJS+mrRvWEgyyeMT2FxoI4K61YnIDN3dG+ByH7KQNKFgugEe9HKDExjrzgamrg3uo3BkCnmjA/17Y=
X-Received: by 2002:a05:6a20:12c3:b0:1a3:c43b:2c2c with SMTP id
 v3-20020a056a2012c300b001a3c43b2c2cmr2106251pzg.47.1712216082280; Thu, 04 Apr
 2024 00:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Changhui Zhong <czhong@redhat.com>
Date: Thu, 4 Apr 2024 15:34:30 +0800
Message-ID: <CAGVVp+VPe31d8=Uf=6TwY2v_P-d33kJKxHJPd-zcwq2hz0-3WA@mail.gmail.com>
Subject: [bug report] WARNING: CPU: 2 PID: 987 at drivers/scsi/sg.c:2236
 sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
branch: for-next
commit HEAD: c0055efa0a19a9f8c10140bf8ecf5829e4d5f903

hit this issue on recent upstream=EF=BC=8Creproduced with blktests  scsi/00=
2=EF=BC=8C
dmesg log=EF=BC=9A

[ 1738.624635] run blktests scsi/002 at 2024-04-03 14:26:14
[ 1738.648699] ------------[ cut here ]------------
[ 1738.653352] WARNING: CPU: 2 PID: 987 at drivers/scsi/sg.c:2236
sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
[ 1738.662954] Modules linked in: ext4 mbcache jbd2 tls
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace netfs
rfkill sunrpc vfat fat dm_multipath ipmi_ssif intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm mgag200 rapl i2c_algo_bit
intel_cstate drm_shmem_helper iTCO_wdt acpi_ipmi iTCO_vendor_support
ipmi_si drm_kms_helper mei_me dcdbas dell_smbios intel_uncore i2c_i801
ipmi_devintf mei dell_wmi_descriptor wmi_bmof lpc_ich i2c_smbus
intel_pch_thermal pcspkr ipmi_msghandler acpi_power_meter drm fuse xfs
libcrc32c sd_mod sg ahci crct10dif_pclmul nvme libahci crc32_pclmul
bnxt_en crc32c_intel nvme_core libata ghash_clmulni_intel megaraid_sas
tg3 t10_pi wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
null_blk]
[ 1738.739233] CPU: 2 PID: 987 Comm: kworker/2:3 Not tainted 6.9.0-rc2+ #1
[ 1738.745863] Hardware name: Dell Inc. PowerEdge R640/0X45NX, BIOS
2.19.1 06/04/2023
[ 1738.753439] Workqueue: events sg_remove_sfp_usercontext [sg]
[ 1738.759122] RIP: 0010:sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
[ 1738.765155] Code: 5a e8 30 fd eb a1 4c 8b 04 24 49 8b 75 00 49 8d
55 6d 48 c7 c1 63 e5 60 c0 48 c7 c7 0b e2 60 c0 e8 69 83 56 fd e9 46
ff ff ff <0f> 0b e9 58 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
90 90
[ 1738.783907] RSP: 0018:ffffab0f054bfe18 EFLAGS: 00010202
[ 1738.789145] RAX: 0000000000000002 RBX: ffff8a9b43796080 RCX: 00000000001=
86002
[ 1738.796287] RDX: 0000000000184002 RSI: 000000000003a1c0 RDI: 007079439b8=
affff
[ 1738.803431] RBP: dead000000000122 R08: 0000000000000000 R09: ffffdcc7049=
d5b08
[ 1738.810576] R10: 0000000000000001 R11: 0000000000000007 R12: dead0000000=
00100
[ 1738.817719] R13: ffff8a9ec1e32d80 R14: ffff8a9b43796098 R15: ffff8a9b437=
97328
[ 1738.824860] FS:  0000000000000000(0000) GS:ffff8a9eafa80000(0000)
knlGS:0000000000000000
[ 1738.832953] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1738.838709] CR2: 00007f5f4fcd9200 CR3: 0000000650c20002 CR4: 00000000007=
706f0
[ 1738.845851] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1738.852990] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1738.860132] PKRU: 55555554
[ 1738.862856] Call Trace:
[ 1738.865319]  <TASK>
[ 1738.867436]  ? __warn+0x7f/0x130
[ 1738.870690]  ? sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
[ 1738.876115]  ? report_bug+0x18a/0x1a0
[ 1738.879800]  ? handle_bug+0x3c/0x70
[ 1738.883307]  ? exc_invalid_op+0x14/0x70
[ 1738.887156]  ? asm_exc_invalid_op+0x16/0x20
[ 1738.891362]  ? sg_remove_sfp_usercontext+0x1bc/0x1d0 [sg]
[ 1738.896785]  ? sg_remove_sfp_usercontext+0x10b/0x1d0 [sg]
[ 1738.902212]  process_one_work+0x193/0x3d0
[ 1738.906241]  worker_thread+0x2fc/0x410
[ 1738.910012]  ? __pfx_worker_thread+0x10/0x10
[ 1738.914300]  kthread+0xdc/0x110
[ 1738.917464]  ? __pfx_kthread+0x10/0x10
[ 1738.921225]  ret_from_fork+0x2d/0x50
[ 1738.924823]  ? __pfx_kthread+0x10/0x10
[ 1738.928581]  ret_from_fork_asm+0x1a/0x30
[ 1738.932524]  </TASK>
[ 1738.934725] ---[ end trace 0000000000000000 ]---

Thanks=EF=BC=8C

