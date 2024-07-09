Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1FB1EB44
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 10:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720522521; cv=none; b=XyqQYwm7DRQYExO4alQNjhrVkIruMxIehPQA6OulopwmohOX2L/n7pNmQSISTXxE432LhUHND3oL9fxhdmPuqDPDz+q+2FyIjNFPRR8i2zJ0TFNQGpLJNZ1nJcI4FMf3iINOcKVNE5amOmu2jP8dcPXrNq0NysQ9FxCeoUsHj8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720522521; c=relaxed/simple;
	bh=r4sAyNn4tv1b9Mqp2flGnonkvoa+ezsmA7FgmpELHk0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jJZXXfjmwhr9XnAD8ORdV11x/hr6sVFrvU7K/uRo1riwsmwH13xmAKpkNeTbjRQeHQ7r9yq+vLLVcsn+1RBBAQuU/qPukrUH2U8DPKyWlYk1WJvBcT4Cx/Xe5gHD1d+rGyWwKIrMF64IpZo8uELXz4lNqUFghN2rhPkjDZ1NQSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLFonmSV; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLFonmSV"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fb457b53c8so31536235ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jul 2024 03:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720522519; x=1721127319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KvbquvDRNPgxNurNYk+KZr33v8PlBjjw1xQFiH47nUY=;
        b=MLFonmSVRN8OH+lYzNHRagiHfCgU9HofBNBTY/IDD5W2jS3cBV2CBk6Tz+IKSKED9D
         sVUpWM49bVTnLwGf5+WbOjrWvIMY67TwbiGvYTsf32EKuGkUnFx0TXvV9uSpHZKbKznI
         wdSq79JWJWUzO/GpT/7Ejc2pH3clkhpiJ2DpkKuMGA++h+nEU/hgY6fZwewC8pwULpho
         B7zZ7R+aT1TO+7W6Dop89nsQmxf6gk2JvF+ZKutSqHDc9C5SyemvbiPfMa4LMZGJpULp
         Ga2BntSX+bhboHgF1BIC6KMa2aQUUjNUj6qVf3u8TYPk2vorCmWihypPS52JkUoZs3iR
         R7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720522519; x=1721127319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KvbquvDRNPgxNurNYk+KZr33v8PlBjjw1xQFiH47nUY=;
        b=BqS/UTMFbKEmI93kgRIZRvDocZo6vI1sb9exbnd7bVfXTj31bH/PxEpgc5rBU3+rvE
         roHsMKD1RHkZxiPK75BJmtMUQNudI/60tw85pLJa5K2FxEUkJ8Ws+ctAtSrEdflYGf/o
         rruHCKWbgXdzbLh53fTKJ23D6VYlVM39BzyGS2Ul7F3501YrAruECmpu1bdH/0UwusPn
         YdHRk/rtbDcptYZ294Y/5TuLtBF1Ax6Qxf6F02lvheUKzBdmc9pjPsC4nhpUEi4cFd6f
         jJ8eFGzIxrbH3BJYSTHZ/+49SvqF4cY0dJnZ0fPndUnJlvBv8w2n3zCVGa2ZBdiV0Oov
         GpDQ==
X-Gm-Message-State: AOJu0Yz0CQ6+dFKReGFFiw4OzcVkUIhqxzLQRYS3IV4SPRl0TzKsInYN
	22QTnFWYEOIz83crn22mSpd32a6Vo4Sy4+PKEEUU/mP0ttDLdFa1
X-Google-Smtp-Source: AGHT+IGFHU1oqmMBYP6680ntb0nqgwz88HYhgbReTGmluJzixAPtdeR18Syn6XgmM4ETxcpNKTo8kg==
X-Received: by 2002:a17:903:120b:b0:1f9:b16d:f94f with SMTP id d9443c01a7336-1fbb6d70175mr17092075ad.39.1720522518572;
        Tue, 09 Jul 2024 03:55:18 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6b34ca2sm13242675ad.53.2024.07.09.03.55.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jul 2024 03:55:18 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: martin.petersen@oracle.com,
	sathya.prakash@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  scsi/mpt3sas: fix a KASAN report
Date: Tue,  9 Jul 2024 18:55:11 +0800
Message-Id: <20240709105511.64266-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

==================================================================
[  103.297144] BUG: KASAN: slab-out-of-bounds in _ctl_do_mpt_command+0xdd9/0x2f30 [mpt3sas]
[  103.306623] Read of size 8 at addr ffff888116747d48 by task sas3ircu/3658

[  103.314781] CPU: 69 PID: 3658 Comm: sas3ircu Not tainted 6.10.0-rc2+ #18
[  103.314787] Hardware name: Inspur SA5212M5/SA5212M5, BIOS 4.3.17 07/09/2021
[  103.314790] Call Trace:
[  103.336743]  <TASK>
[  103.336745]  dump_stack_lvl+0x8d/0x140
[  103.342826]  ? __pfx_dump_stack_lvl+0x10/0x10
[  103.342829]  ? _printk+0xb0/0xf0
[  103.342833]  ? __kasan_check_write+0x18/0x20
[  103.342841]  print_report+0x199/0x570
[  103.342844]  ? _ctl_do_mpt_command+0xdd9/0x2f30 [mpt3sas]
[  103.342875]  ? kasan_complete_mode_report_info+0x45/0x240
[  103.342879]  ? _ctl_do_mpt_command+0xdd9/0x2f30 [mpt3sas]
[  103.342910]  kasan_report+0xd8/0x110
[  103.342913]  ? _ctl_do_mpt_command+0xdd9/0x2f30 [mpt3sas]
[  103.342944]  kasan_check_range+0x262/0x2f0
[  103.342981]  _ctl_do_mpt_command+0xdd9/0x2f30 [mpt3sas]
[  103.343068]  _ctl_ioctl_main+0x732/0x930 [mpt3sas]
[  103.343136]  _ctl_ioctl+0x1a/0x20 [mpt3sas]
[  103.455340]  __se_sys_ioctl+0xd0/0x120
[  103.455345]  __x64_sys_ioctl+0x7f/0x90
[  103.455349]  x64_sys_call+0x1586/0x2d00
[  103.467041]  do_syscall_64+0x60/0x110
[  103.467044]  ? clear_bhb_loop+0x45/0xa0
[  103.474781]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  103.479952] RIP: 0033:0x442829
[  103.483127] Code: ff 85 c0 48 8b 6c 24 10 48 0f 49 d3 48 8b 5c 24 08 48 83 c4 18 48 89 d0 c3 90 90 90 90 90 90 90 90 48 c7 c0 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 4b 31 00 00 c3 90 90 90 90 90 90 90 90 90
[  103.502096] RSP: 002b:00007fff2bbd7e68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  103.502101] RAX: ffffffffffffffda RBX: 000000001ae96c80 RCX: 0000000000442829
[  103.502104] RDX: 000000001ae971e0 RSI: 00000000c0484c14 RDI: 0000000000000006
[  103.502107] RBP: 00007fff2bbd7eb0 R08: 00000000c0484c14 R09: 0000001202000000
[  103.531597] R10: 000000001ae97224 R11: 0000000000000246 R12: 00007fff2bbd8d30
[  103.531600] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[  103.531604]  </TASK>

[  103.531608] Allocated by task 9:
[  103.553368]  kasan_save_track+0x30/0x70
[  103.553373]  kasan_save_alloc_info+0x3c/0x50
[  103.553378]  __kasan_kmalloc+0xa2/0xc0
[  103.553381]  __kmalloc_noprof+0x1bd/0x3f0
[  103.553387]  mpt3sas_base_attach+0x1176/0x20f0 [mpt3sas]
[  103.553418]  _scsih_probe+0x131a/0x23f0 [mpt3sas]
[  103.553449]  local_pci_probe+0xf8/0x160
[  103.553454]  work_for_cpu_fn+0x5b/0x90
[  103.553458]  process_scheduled_works+0x72d/0xdc0
[  103.553462]  worker_thread+0x85b/0xc40
[  103.553466]  kthread+0x2ad/0x340
[  103.553471]  ret_from_fork+0x41/0x70
[  103.553475]  ret_from_fork_asm+0x1a/0x30

[  103.555079] The buggy address belongs to the object at ffff888116747d00
                which belongs to the cache kmalloc-96 of size 96
[  103.567583] The buggy address is located 72 bytes inside of
                allocated 76-byte region [ffff888116747d00, ffff888116747d4c)

[  103.589088] Memory state around the buggy address:
[  103.593999]  ffff888116747c00: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
[  103.601375]  ffff888116747c80: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
[  103.608750] >ffff888116747d00: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
[  103.616125]                                               ^
[  103.621822]  ffff888116747d80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
[  103.629192]  ffff888116747e00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
[  103.636560] ==================================================================
Although it appears to be a KASAN report, it is actually a concurrency issue.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1320e06727df..c738bdd79f94 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8577,7 +8577,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 
 	/* ctl module internal command bits */
 	ioc->ctl_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
-	ioc->ctl_cmds.sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	void *sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	WRITE_ONCE(ioc->ctl_cmds.sense, sense);
 	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
 	mutex_init(&ioc->ctl_cmds.mutex);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 1c9fd26195b8..dec19670cdff 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1096,7 +1096,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		MPI2_FUNCTION_NVME_ENCAPSULATED) ? NVME_ERROR_RESPONSE_SIZE :
 							SCSI_SENSE_BUFFERSIZE;
 		sz = min_t(u32, karg.max_sense_bytes, sz_arg);
-		if (copy_to_user(karg.sense_data_ptr, ioc->ctl_cmds.sense,
+		if (copy_to_user(karg.sense_data_ptr, READ_ONCE(ioc->ctl_cmds.sense),
 		    sz)) {
 			pr_err("failure at %s:%d/%s()!\n", __FILE__,
 				__LINE__, __func__);
-- 
2.27.0

