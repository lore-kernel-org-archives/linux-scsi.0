Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC2A399003
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 06:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792131142; cv=none; b=GaN1xkEuU22CeoaBc4K4Z52jwpzWBAMADrR5RdXSWhp4sjYUSiciMFK7vgFgL6o5QuT7E+cHsta2Z3vvrwFVXO9AS+il7H5j+V69cTCeySWjcBIiHwPcDPKdqhRHzrau/9Ekzyl7WpuZ2jONvLbCShqodfO+NfUSbNdI1C51TIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792131142; c=relaxed/simple;
	bh=GiK1rjWkVKYkYUyerIeHUjnzQfFpbLLdF4axllSUko8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nElf5YED84K/X/YntO5EWBc4T/1HT2lOsw4DyFW3a3R7ujxAjCvT/4vMLiAqH36Qrd56njxn9WBbkx4HdLS6YmDIs4Cn7wOvsdllroCNTbUbSqIqU8YDaVWxEzqIQZQLuWC1W4/jboe2reqMWRLjVYoqJVZDwrWSYuU/S157IF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cT9KOWN2; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cT9KOWN2"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so3345241a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 23:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131140; x=1792735940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cECDn9wixA330bGvTffyTHattrcKzY/ix80ysxVbhlI=;
        b=cT9KOWN2ERwzS2XFzWsSwVytrHoIP911OrNYFbosERYwo6FDgwjUiNTI57jAI3WSNz
         3LKijCyMgpUQbfNdQCKgzq/Ox7FLy0scCdzLXEbOArVwnR6XGM/u7ZLrf3v3S1JyhSiD
         lwOV0Id1fiShnsro1j+WJqGEYo+gSYc4wLAGY2KLfHs5IquYACXuE35wYYoYvUmOeCz9
         gBSWOl4LT4776qH6BGhkhT9er5Cc/B8IZKAvwYOL6gnAVkOp9AHQXoWtrxJQFf9NnnsI
         06RcscAltZ1PUwgO7m2mzFKTxSkmMCXavjFDdq34zpOfZOB8R7v9as1Ma1BCEuUunbgh
         eCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131140; x=1792735940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cECDn9wixA330bGvTffyTHattrcKzY/ix80ysxVbhlI=;
        b=E5wCP8w7iJhtEFUsN7OSs8luuxQ1nD53tgkpmP65foaBgtcxWKRy5xgVV1NMPNL36S
         7MdasXlPtoca42QDD8lE36rYJYBIJ1zn0eXOZQuG/OeHmp/MQgqefatlSR6oUVBUxyWj
         poVlnVA6DIF7Ki7fL2c2DmZD7RD6pOkxK9TlHEf1OoLosyqpWo/9UZ5PAqSY2tRqCNnE
         vffuUuV+18In4r8FQPLNio0JQ7WAHsXraFHJ/ei0jvMJPfe1yMKzWnYebR3a7gs6Q131
         veRZoI2ydR/vlM7WMxVzPWNvk9hFcl6Ah9GWE0N6Zx58eDk3xN8oye3/VKn9sYXBVsgX
         FTRw==
X-Gm-Message-State: AFq9FYIKUfbSp6W4lbORRSx0eIP/y1HmFTYYEXGHgEzJe6ezGFnRv4th
	vqzUCuQxEIfGi59dcElLMxGOv/kmY4XkTOFfuSmBR1p3PRmCAZvB3r5I
X-Gm-Gg: AYBFou1fTWHTyVeLXkaBAPJoTRv2Y8J/a6VYYHhlOCNsbVDHNhpY8h+PxlTeKzkumAQ
	9JcCLjn2PQ6i3ajGLopF94h0ta6GeBEBI8Jlz9xXftzjA6YKQd2CNFy3XL8HhqhZQodKFY1DR8h
	O0LAeb7d9wD2uu+tjJ33RSpSPX/tayU4j1I25ngazSKJxH6cVuVeEtJ9euttopmXFmHamoHt881
	oX2MtzDbMfG8x+3cn9oudxEREaBrQysXeVOt+aPmUFJDgDdhvQw+u/kSLuJfKeAVtIqKd9Wi4Nr
	jkqJmKiw8yzlEp3acAMU/BYNd9gygwdcY3T1G8Hrct3SPB1MeprZcVo7UO8yy4M/6j9rEyXutJz
	QSrGB42Xs0+D/1tKzLHtCBOyiKJK/MP0bKWuoRLKlfMATBsZwShlkwaIZq4ojDGtq8dGhKCTnUE
	RYBc7tz9d5i5RZSG+3jbpG1tchkoUXaQfSOx0CdhK8PqsUxQmxmwkvCBrY6YQolMXeCSHT6Jynh
	kp4OHCNMzh17dnMTJ2IECjiaLFsQAj5VShCVd0ixXc6Riinetfi1mbFHss6AhDwoJlqRZRWDXve
	OUV7eEvDHGTkfrY1BTiBaQ4HHrNh9Um0dmw+EeprAAj0iusN
X-Received: by 2002:a17:90b:4acb:b0:3ac:aa8d:19d6 with SMTP id 98e67ed59e1d1-3acaa8d2219mr2736921a91.17.1792131140016;
        Thu, 15 Oct 2026 23:12:20 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947dfa00sm7587036a91.17.2026.10.15.23.12.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 23:12:18 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: use-after-free in PR REGISTER AND MOVE racing PR OUT CLEAR
Date: Fri, 16 Oct 2026 16:11:50 +1000
Message-ID: <20261016061150.90624-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

core_scsi3_emulate_pro_register_and_move() (drivers/target/target_core_pr.c)
drops dev_reservation_lock to allocate the destination registration, then
re-takes the lock and re-locates it:

	spin_unlock(&dev->dev_reservation_lock);
	if (core_scsi3_alloc_registration(... , 2, 1)) {
		ret = TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
		goto out;
	}
	spin_lock(&dev->dev_reservation_lock);
	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl, iport_ptr);
	new_reg = 1;			/* result used unchecked */
	...
	__core_scsi3_complete_pro_release(dev, pr_res_nacl,
					  dev->dev_pr_res_holder, 0, 0);
	dev->dev_pr_res_holder = dest_pr_reg;
	dest_pr_reg->pr_res_holder = 1;

While the lock is dropped, a PR OUT command from another I_T nexus - most
easily CLEAR, which frees all registrations - runs
__core_scsi3_free_registration() and clears dev->dev_pr_res_holder. The move
path then uses the freed / NULL registration.

On a stock tree this is a NULL dereference (dest_pr_reg / dev_pr_res_holder
are NULL):

  BUG: KASAN: null-ptr-deref in __core_scsi3_complete_pro_release+0x9d/0x3b0
  Read of size 1 at addr 0000000000000228
  Call Trace:
   __core_scsi3_complete_pro_release+0x9d/0x3b0
   ? __core_scsi3_locate_pr_reg+0x13f/0x170
   core_scsi3_emulate_pro_register_and_move+0xa95/...
   target_scsi3_emulate_pr_out+0x3a4/...
   __target_execute_cmd+0x56/0x140

A NULL check after the re-locate is not sufficient; a use-after-free of the
destination registration then shows up - allocated by one REGISTER AND MOVE,
freed by the concurrent CLEAR, still used by the move path (three tasks):

  BUG: KASAN: slab-use-after-free in target_scsi3_emulate_pr_out+0xaf5/...
  Read of size 8 at addr ffff8880058db670
  Allocated by task 23:
   __core_scsi3_alloc_registration+0x7c/...
   core_scsi3_emulate_pro_register_and_move+0xed7/...
   target_scsi3_emulate_pr_out+0x3a4/...
  Freed by task 33:
   __core_scsi3_free_registration+0x3d2/...
   target_scsi3_emulate_pr_out+0xac0/...        (PR OUT CLEAR)

Reproducer (KASAN build, panics in ~1 minute)
---------------------------------------------
- Two tcm_loop TPGs (SAS, distinct rtpi), a nexus each, both mapping one
  iblock backstore -> two /dev/sdX = two I_T nexuses to the same LU.
- Thread A on nexus 1: loop { PR OUT REGISTER; RESERVE;
  REGISTER AND MOVE to nexus 2 (unregistered destination) }.
- Thread B: loop { PR OUT CLEAR }.

C reproducer and full dmesg available on request.

Reported-by: Yu Zhang <yuz08559@gmail.com>
