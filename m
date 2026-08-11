Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FC36EA98
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 12:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786452547; cv=none; b=aUoXQXOwYoYX9F7CYYA+aS8mvByv/fjxRI8dlAbhnebBxhMjaPWTAqtfaL/1S6sEMuwktuc0C6e9XsqFpBQqDAMSE2Q5jKlC5lB35d+ni8G+AlNI9/EbEyocB9uW4QLF5lOrvzKIWQ6wVprT8LipCgZrkK1qJkWrCcXt2k40BAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786452547; c=relaxed/simple;
	bh=/SemkPU4Bff8YXOGYAJT+Ed/9wgjOBUmHVCHVQzN2W8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YenaWg53lsdgv1juLRv2B6xFz8/ZMhp6hnFLzqizH4R3F6QGzLDx7i2qXHT9Peh00UAP1WSzdlaENQaUfe82hF2snYz+26ningYzuhc+z8j3Ix/2X04IkmHgAtB0Njp0cOndzFW3VcfSOSLwnb/5xSdB6GiuWA/2F+uMAS9wD9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pEPd2KUW; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pEPd2KUW"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dcbade417so781426a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 05:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786452545; x=1787057345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T0kV3tTim4vynviOZcIlYMP2pHOTcpC0ofsMpZhrjB8=;
        b=pEPd2KUWZp22QxP05Y1lClVRGbFBjsbfEVRGrFZMFrI7pMu65iH5kvMKyHKYQ3e5Nz
         +5BDG70x9PYPz/TX4f7S0RABqTZU3beufjzqR+HtxujRywFwp3zBeYBAAppVbCze9JbO
         o9weV8Qwdruj6mkT0yNRZFbAPQnmOiF+IzwA9iJIkwdbYQ3Bz30cwW4l0yJmW09r29/i
         VCvbKkfioWXTotHIvDlavvefvtLwDQhe/zEuETQ5LfRisJIJz5qE2Loi3nc0fMGTZma2
         nWKIkHy+cXlQhStf49jrBXyZNudad69cchETUfNY3pV0vKJUnnjMcN5MeYs3xigifXzh
         H52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786452545; x=1787057345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0kV3tTim4vynviOZcIlYMP2pHOTcpC0ofsMpZhrjB8=;
        b=hDlmVuGasE2kNxRTlACwdx2YJ5fXGZEvtlu2VFExRYO7HQ9I3R57SfObaDddPXgHiz
         w/q2IAIuq2kG78wDHdSR3/43npXaI561rGgCslgJh4efFTYjXMS0FAqiuvkVeDGWcW3D
         /Fxsp67gHs2yRsehjCC7e3WD7ZEoaKjsQCnkIjs6OBCPBiTDr1QLwLxxFNshvzzWBjla
         /UXtK5BIZyy9VvssqplPRJ520WJp735uuZiyvRo2rE5YSPozTGSdMA7fDCCXcOwutPsv
         Cq2wAnedk5mtpoPx4pjjO0e8dBsoqtEjUkt6p1VKEMlpsBsBntwbErIm0NbJi8XmiYQV
         0LMQ==
X-Gm-Message-State: AOJu0YyAFdIgHBKsbZdyzaFjuH+mVA6xh0C4l3RvV7C6tDQIk+kr786D
	4nFl2cCj2paBkLrWrBvPWrBFKwtMFfv0qEGjJ8j4riRecHUqQKSSVXKg
X-Gm-Gg: AR+sD11w1Wuyi+bh2wOfTmdEeW06W0/O68TqEjOKnDhNz4dr8AOC/YQ/MAcy1x+lcTI
	Phy+AsR4igEswMrxxYRjtXEUunjPe7x3uSucPSoD7tLZFUkgJ4MCXva6K/UvTLA38C1HqkPheSd
	/ijmpE8dkuZdyRdBoCJStinpgx30k/JP4rwJ/feNvUnwwiKvDNoAgZkvKT+M/h766kLsOmf/ati
	jH3Pz65d0IqMY6uexLwClKnhSDPZ0f7y/rL0fPu5vFGlfZLNyNHpI49uFXIFfO32bkcoOAGIpwW
	MHN/LzRpMy24ZwZKMiR548TZWe3gP6N8/0juCsFPBg+qxNFzo4gfZNVj3VcRXD2MkO3sw2GE2LW
	nfwc05Ju21Y+rSunaQReTdl19iHiT9sgLz+tJynGHC/zxyBtURQaZV0Ner36extfITdKWxoG72K
	AxOiR/XX/MpAnlaxmwlC/DoGjTTfMoDtesEqYsVi3SwqneOau3bruaRNK+2IIX4YRLT66fm/CfK
	DFnqsvhfO7FLAWPFGfxUTvYt4A=
X-Received: by 2002:a17:90b:33c4:b0:392:c80b:8ef7 with SMTP id 98e67ed59e1d1-392ec6d3407mr2980329a91.18.1786452544594;
        Tue, 11 Aug 2026 05:49:04 -0700 (PDT)
Received: from fedora (103-127-218-229.dynamic-ip.pni.tw. [103.127.218.229])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d534bfe7sm3887009a91.9.2026.08.11.05.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 05:49:03 -0700 (PDT)
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linfeng Sun <linfeng.sun.dev@gmail.com>
Subject: [PATCH] scsi: target: iscsi: Fix race in discovery auth updates
Date: Tue, 11 Aug 2026 20:48:43 +0800
Message-ID: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Separate configfs opens can concurrently update the discovery AuthMethod
parameter. Both callers may free the same value in
iscsi_update_param_value(), causing a double-free.

Protect the lookup and replacement with the discovery TPG access lock, as
used by the other TPG configfs parameter updates.

I dont consider this a high-severity security bug, but for safety as a
precaution, I can provide the reproducer PoC privately to the maintainers
if needed.

[   53.935693] ==================================================================
[   53.936125] BUG: KASAN: double-free in iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.936725] Free of addr ffff888012e355b0 by task a.out/319
[   53.937027]
[   53.937120] CPU: 6 UID: 0 PID: 319 Comm: a.out Not tainted 7.2.0-rc7+ #3 PREEMPT(full)
[   53.937130] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   53.937136] Call Trace:
[   53.937139]  <TASK>
[   53.937142]  dump_stack_lvl+0xd0/0x110
[   53.937151]  print_report+0xd1/0x630
[   53.937161]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   53.937173]  ? kasan_complete_mode_report_info+0x6a/0x210
[   53.937182]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.937327]  kasan_report_invalid_free+0xa0/0xd0
[   53.937337]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.937484]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.937632]  check_slab_allocation+0xee/0x120
[   53.937641]  __kasan_slab_pre_free+0x24/0x50
[   53.937650]  kfree+0x170/0x480
[   53.937657]  ? __pfx_kstrtouint+0x10/0x10
[   53.937665]  ? iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.937813]  iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.937959]  iscsi_disc_enforce_discovery_auth_store+0x18f/0x450 [iscsi_target_mod]
[   53.938111]  ? __pfx_iscsi_disc_enforce_discovery_auth_store+0x10/0x10 [iscsi_target_mod]
[   53.938263]  ? __kmalloc_cache_noprof+0x1be/0x460
[   53.938272]  ? configfs_write_iter+0x3fe/0x560
[   53.938284]  ? __pfx_iscsi_disc_enforce_discovery_auth_store+0x10/0x10 [iscsi_target_mod]
[   53.938435]  configfs_write_iter+0x312/0x560
[   53.938447]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x30
[   53.938458]  vfs_write+0x71c/0xe60
[   53.938464]  ? __pfx_configfs_write_iter+0x10/0x10
[   53.938477]  ? __pfx_vfs_write+0x10/0x10
[   53.938484]  ? __pfx_mutex_lock+0x10/0x10
[   53.938493]  ? fdget_pos+0x213/0x5d0
[   53.938505]  ksys_write+0x154/0x290
[   53.938512]  ? __pfx_ksys_write+0x10/0x10
[   53.938519]  ? fpregs_assert_state_consistent+0xe1/0x160
[   53.938532]  ? do_syscall_64+0x13f/0x640
[   53.938539]  ? __sanitizer_cov_trace_cmp4+0x16/0x30
[   53.938549]  __x64_sys_write+0x77/0xc0
[   53.938555]  ? prandom_u32_state+0x13/0x180
[   53.938567]  x64_sys_call+0x259/0x26e0
[   53.938579]  do_syscall_64+0xf3/0x640
[   53.938585]  ? do_syscall_64+0xa8/0x640
[   53.938592]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   53.938601] RIP: 0033:0x7e9dc22449ee
[   53.938607] Code: 08 0f 85 f5 4b ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
[   53.938615] RSP: 002b:00007e9dc19a4e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   53.938623] RAX: ffffffffffffffda RBX: 00007e9dc19a56c0 RCX: 00007e9dc22449ee
[   53.938628] RDX: 0000000000000002 RSI: 00005a09e22de04e RDI: 0000000000000004
[   53.938633] RBP: 00007e9dc19a4e90 R08: 0000000000000000 R09: 0000000000000000
[   53.938638] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000021
[   53.938642] R13: 0000000000000000 R14: 00007ffcf2f464d0 R15: 00007e9dc11a5000
[   53.938649]  </TASK>
[   53.938652]
[   53.953000] Allocated by task 308:
[   53.953189]  kasan_save_stack+0x39/0x70
[   53.953404]  kasan_save_track+0x14/0x40
[   53.953617]  kasan_save_alloc_info+0x37/0x60
[   53.953858]  __kasan_kmalloc+0xc3/0xd0
[   53.954073]  __kmalloc_node_track_caller_noprof+0x24b/0x630
[   53.954385]  kstrdup+0x62/0x110
[   53.954567]  iscsi_update_param_value+0x4e/0x140 [iscsi_target_mod]
[   53.955055]  iscsit_load_discovery_tpg+0x3fc/0x6e0 [iscsi_target_mod]
[   53.955545]  0xffffffffa0479430
[   53.955724]  do_one_initcall+0xd7/0x660
[   53.955943]  do_init_module+0x306/0x940
[   53.956165]  load_module+0x66c2/0x90f0
[   53.956378]  init_module_from_file+0x192/0x1c0
[   53.956626]  idempotent_init_module+0x274/0x8c0
[   53.956883]  __x64_sys_finit_module+0xd3/0x170
[   53.957134]  x64_sys_call+0x106d/0x26e0
[   53.957354]  do_syscall_64+0xf3/0x640
[   53.957562]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   53.957851]
[   53.957946] Freed by task 318:
[   53.958122]  kasan_save_stack+0x39/0x70
[   53.958342]  kasan_save_track+0x14/0x40
[   53.958562]  kasan_save_free_info+0x3b/0x60
[   53.958802]  __kasan_slab_free+0x6f/0xa0
[   53.959034]  kfree+0x23c/0x480
[   53.959210]  iscsi_update_param_value+0x41/0x140 [iscsi_target_mod]
[   53.959678]  iscsi_disc_enforce_discovery_auth_store+0x18f/0x450 [iscsi_target_mod]
[   53.960236]  configfs_write_iter+0x312/0x560
[   53.960478]  vfs_write+0x71c/0xe60
[   53.960669]  ksys_write+0x154/0x290
[   53.960865]  __x64_sys_write+0x77/0xc0
[   53.961075]  x64_sys_call+0x259/0x26e0
[   53.961287]  do_syscall_64+0xf3/0x640
[   53.961490]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 26 ++++++++++++++------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 704ec94383c3..e1aa0af52c65 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1306,17 +1306,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 		return -EINVAL;
 	}
 
+	if (iscsit_get_tpg(discovery_tpg) < 0)
+		return -EINVAL;
+
 	param = iscsi_find_param_from_key(AUTHMETHOD,
 				discovery_tpg->param_list);
-	if (!param)
-		return -EINVAL;
+	if (!param) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	if (op) {
 		/*
 		 * Reset the AuthMethod key to CHAP.
 		 */
-		if (iscsi_update_param_value(param, CHAP) < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, CHAP) < 0) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
@@ -1327,8 +1334,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 		/*
 		 * Reset the AuthMethod key to CHAP,None
 		 */
-		if (iscsi_update_param_value(param, "CHAP,None") < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, "CHAP,None") < 0) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
@@ -1337,7 +1346,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 			" Discovery TPG\n");
 	}
 
-	return count;
+	err = count;
+out:
+	iscsit_put_tpg(discovery_tpg);
+	return err;
 }
 
 CONFIGFS_ATTR(iscsi_disc_, enforce_discovery_auth);
-- 
2.55.0

