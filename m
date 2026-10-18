Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F653D6487
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792332359; cv=none; b=Zg3nkuJB05up81dS29AL8HD8xixGDKg6XoeSPmmpRHA2aC/BFPfXtBESCJIi/zO86YZCl9O1CCVed7lgPFK3CQosA2INFJ6VuZ75U6XMue2+Gue/TktP2S6mX3sYOqwlknhEZiTgzK+R+avDkB5tBY5Owbfn2tWiAN2gVcSM2No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792332359; c=relaxed/simple;
	bh=f5FX7hFfCqVhSVN2m/Vw4FFE3wckOMml10ljkFzuQ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHbz9tffJ0f88G/apgu2ShcTV24rEV8uzU0WSzf8YwEOopoZFSYvHcgthud5In8IUmRXkmzLDSowKpZ1gyAcUMJvRTcHnCqs+qnMLYIUre7aWY9PAlxJ4zAqxtqZASrHH+1hT11de/fTvothS+DygkuEyj/lDRPZI7oLY8ohHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYftQRc1; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYftQRc1"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9995ce866so9721675ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 07:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792332357; x=1792937157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wpUr77bZYWUJxHRGn89lY5QrpxEuBo3N7WkSWCTOfBs=;
        b=mYftQRc1+OAlsyFlYwS80Hmtf9YBEfD3qfmAUO8nJgJMQPowoXZ2ydJYelgiR+3Yey
         yXcna3f7YfMBceUzWlWXOFbwgIOmv5h0y8U4tdjwVBV7J0IhvvDdnjPI6PNY3yWknkUb
         Bb4Ecs1ialVGiX00bwnfr+/g3I/eTs/UBm5oxmtsGccDpG4S9cZlxHTSJjg3zCbMiwjS
         GXVkXJfO64JCV0IfxMI0qAvz0GFoaDevYtu6dH0XQFnuMUAV1XGw4SYROCdl2z/x/yAM
         ldpr9sXVJrZixlxglHvUng2bX+nnntrpVaj5gxRnMuSEouFiOcKAfBv+af+NhU1YPqU3
         H7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792332357; x=1792937157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wpUr77bZYWUJxHRGn89lY5QrpxEuBo3N7WkSWCTOfBs=;
        b=r1KfRlzfTt8eeorACb3ECTyhxmdEEdakxhd+TqxPmnb1TYaoaKA16eAE/zi5Xs07lq
         Nx84/UutA1fDGZMX4AHbGtr47K+wFnj+Z83iz8MV0YZVpZXym84XoypF0lnGaa+xatYu
         x4pPGcoYf/nLJTsQastNl11tZpLsDY/fV7E9k5cOpWJZeAGKAGb5AnY/f4joNTkVArXC
         6d6MEF9/SKL9Ymr/6TA3jwJsm7+dVUqJv0dLoFYXylhorysgg3PGBmjYMcveZD9XjslQ
         lrk8uEWDmBdtYbxA7mjwxSHIKLlZYht0WTFUMioUyTaRou9OiZQ5/ksZaqNm5qF4Hhrg
         FD8A==
X-Forwarded-Encrypted: i=1; AKwUvBxwDN0O2cz+Ed4eY+5pkp6yg3ELT9pAH9Qu3+sp82iX7Fl1KkZr5fpajdDy35As9fR2yk0x9voBYEQt@vger.kernel.org
X-Gm-Message-State: AFq9FYIjjGUvW+BPmnn1aiLMZg3FVKAR4mu+AaS/1IRaBaFJh5Vua+FW
	Q8GPvY0oeFXSrvhd2zGW+sVK9ukm8CFvPGkuoatxdLhGMXJdaFV4SKtU
X-Gm-Gg: AYBFou2ApIHr5uyq2ecHqhNESNnl3eEP2Tf12GZnD0/10a4nuJJjw7zfdOczjtE7fAN
	q2vtR8ste0SRjlTd/oS7aN/PMrmyCZaEDGnuJF8lu5tk74watskjJTUIDxhxVJZ9SRYGq+C6MWT
	x/lIu499mk7yyDpFFoOM5RXkmTL84edKtCcCComZ/z5FIWpA4/QN3cLiMn1xLyJ1c51jfZh15yX
	pnIgPH+8rxfOAJcVrCCXWBrcAW9Ts/To8XkAKNzqjkIHuUeJYiL5ifkBE43bFsj+mFaPLVHb2sW
	ZabAxBpjBGuEc0ovMs3v28s2qtnkWumy9WyaEUeQ54LMq3dyoCgBCglEhBcLzsFwVEcfqFsythY
	tNuGhScB1qD8lbwqvjHBNDPrA6Sh2goOLe2qtkbONcl/Gd1WGj/khlkJgBVb06PwlVp1AQxvKB+
	fRUvdseNlQ1DcduPRP1t1gqC6Q6+f31Ztx9zllC2+wMeOitRQcavifK2MvmKU47O7nUk4lSJRJ+
	Ktvks5TENaLT5RGyZtrxhxPFDEm5wUx8/xIVA4Urg06uAHPTj6RvqVTjELxBa1+tdqoqM9tKgmR
	uVZTb8lbcWYWmTGHrpE95Sg4cTl+xBkqN7gJ45WXxY2juCHK
X-Received: by 2002:a17:90b:2e46:b0:3ac:9e76:aa9e with SMTP id 98e67ed59e1d1-3acee276f13mr4625395a91.3.1792332357473;
        Sun, 18 Oct 2026 07:05:57 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc980a548sm5988739a91.0.2026.10.18.07.05.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 07:05:56 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: fix se_lun use-after-free in SET TARGET PORT GROUPS secondary path
Date: Mon, 19 Oct 2026 00:05:47 +1000
Message-ID: <20261018140547.67428-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

target_emulate_set_target_port_groups() handles a SECONDARY target-port
asymmetric access state (OFFLINE) by walking dev->dev_sep_list under
dev->se_port_lock to find the se_lun whose relative target port identifier
matches the request, then dropping se_port_lock and calling
core_alua_set_tg_pt_secondary_state() on that lun:

	list_for_each_entry(lun, &dev->dev_sep_list, lun_dev_link) {
		if (lun->lun_tpg->tpg_rtpi != rtpi)
			continue;
		// XXX: racy unlock
		spin_unlock(&dev->se_port_lock);
		if (!core_alua_set_tg_pt_secondary_state(lun, 1, 1))
			found = true;
		spin_lock(&dev->se_port_lock);
		break;
	}

core_alua_set_tg_pt_secondary_state() sleeps while using the lun --
msleep(trans_delay_msecs) and, when alua_write_metadata is set, a
kernel_write() of the ALUA metadata. The matched lun is a different target
port than the one the command arrived on, so it is not pinned by the
command's own lun_ref. A concurrent core_tpg_remove_lun() of that port
(configfs LUN removal) drains its lun_ref, removes it from dev_sep_list and
frees the se_lun via call_rcu(); since the command holds no reference and
is not in an RCU read-side section across the sleep, the grace period can
elapse and the lun is freed under it:

	BUG: KASAN: slab-use-after-free in core_alua_set_tg_pt_secondary_state
	 core_alua_set_tg_pt_secondary_state
	 target_emulate_set_target_port_groups
	 __target_execute_cmd
	Allocated by task 3486:
	 configfs_mkdir
	Freed by task 0:
	 __call_rcu_common

Take the matched lun's lun_ref with percpu_ref_tryget_live() before
dropping se_port_lock and release it after the transition, mirroring
core_alua_queue_state_change_ua(). This pins the se_lun across the sleep,
so a concurrent LUN removal waits in transport_clear_lun_ref() instead of
freeing it.

Reproduced with two tcm_loop target ports (distinct RTPIs) on one
backstore, explicit ALUA, large trans_delay_msecs: a SET TARGET PORT
GROUPS (secondary OFFLINE, targeting the second port's RTPI) on the
first port races a configfs removal of the second port's LUN -> the
KASAN splat above; with this patch the LUN removal blocks until the
transition completes and there is no use-after-free.

Fixes: adf653f92f38e8 ("target: Subsume se_port + t10_alua_tg_pt_gp_member into se_lun")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
---
 drivers/target/target_core_alua.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 1111111..2222222 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -402,13 +402,16 @@
 				if (lun->lun_tpg->tpg_rtpi != rtpi)
 					continue;
 
-				// XXX: racy unlock
+				if (!percpu_ref_tryget_live(&lun->lun_ref))
+					continue;
+
 				spin_unlock(&dev->se_port_lock);
 
 				if (!core_alua_set_tg_pt_secondary_state(
 						lun, 1, 1))
 					found = true;
 
+				percpu_ref_put(&lun->lun_ref);
 				spin_lock(&dev->se_port_lock);
 				break;
 			}
