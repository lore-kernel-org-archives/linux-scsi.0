Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB73486645
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325647; cv=none; b=nahS17yZUfK85QO28pNuQhbR4dWgSA+7cMWDcOVcSW7JpPJPtqoZWdvs7GMJtSPI17phHMIhxWVaXC8pUdvi3jznI7LCwhY/N25TnWimrsPlVPyLZaKhrZQXUxUxwvt8rXVgBr44z+lKzCQMOcIRvzYj+1haNr7413HT66kttz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325647; c=relaxed/simple;
	bh=0ZUoTOrw2sVIIJsHysZ9LrpXCPGOLNSWoimGoqE2U2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jxIOIiyMZuu/3sP9p17pXJGfs6nBv49lt/qkxc5ZIzyyBGjOmvxOv+oytq95+zH6pLx2EtrCxk0X/GzMv9iQCTJKpu6tjeziFvTNwe436hjNQdWQHwUg9XVZ90ly+SUaQNy3pxq2RbpuDlKLrXSLNGSJt51M719Wwa2sIX4qKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpinP1vp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpinP1vp"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e608cd460eso6379855ad.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 05:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792325645; x=1792930445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rTNuU8y07OWc3gpsCtxs9hMoDORTFAVO+j50HlgZwnM=;
        b=hpinP1vpFyJpDdPHICXGzIQIRyImrKMVDhw1wgqsbp/SHHH8D77WA05IczWynz+ZQU
         cE4hrlX3BUbq7wjQ2t4DM6bRSyXh/0EXGO5qZlEud8ZvnbFJGqykMI+TPhQQv0kS7MfQ
         xFQoKTXBNyOirmkztWZlwE/YDM+shn63+be1LPBgy/2eS3R3X2gnx2amqEzRF2LNeQkE
         HZseIBZNuNsA747O7X3E7lW71cbVvbIh/lGQg3N38dnYaB8kNGwKHCz7Ajg0WrVWuWx2
         q2YRb2LbIMcOHjEUexc9g5nVeahpZZ7W33eKZE8hXJROfPktp6fSIBjvD7hMOqBXHKSr
         Cxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792325645; x=1792930445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rTNuU8y07OWc3gpsCtxs9hMoDORTFAVO+j50HlgZwnM=;
        b=i2dRdWABDnQlqq8fM8sSBIAzmzddrVWt9Vv8v4tdhhO4/ot4LvFoENFjmcTKgF4R8G
         LxjWXPHQj0nYWHdShfacQftk5Nhagc9AdXJldF6Xdd/iK3wBOA+oQZnbfG8nRo8iB5Cb
         PnIfmKPPUuX8f77GqOSTRCEpdhXkYoTkLyrI53vAdil00F91SDtFGeoCUN2Md4r+wnpO
         GbZ8XNdg/qUEfu33foLex/kuszGTT6YaWMLPdiw2iBOZ8+/zAtPc8C4BcsfweRtgIBO4
         j1B3n29EhLpcTdVtJMYM4OO5xzxc5WRG9g4VfzslRYYsibvxUbQMZpBQabyhszsXG3Yy
         3SHg==
X-Forwarded-Encrypted: i=1; AKwUvBySdPr3m3TR+xDT3Bedw0lhWoLCtda7+vnP6Wia179vln8dj+8tZ91k8tqG8n1pvwGOFv9qT8A2m2Y3@vger.kernel.org
X-Gm-Message-State: AFq9FYJXjTCpgTGm6ZRTVRA/vcqTZkC0vv/X+lEYFb/I7y++c260ETaD
	QwWBHqjg+PC4GCUOrjEW7QWlyTynKUxbTWMnrHA88+6XHuolx5DAtrsW
X-Gm-Gg: AYBFou0AMAXoACr+jCv20rJ4jEjmiAC14yIN9uK3OR1bIi/BtNKzACaudsrS8TGTUBn
	h4X6vWkv5DqskZK+D8Co+HCWnBs3Vdg6gKo/WnnSXjQM/iSq47SBZaggQsN1fCLJE/+RbsnGL/V
	cvgCJif4KPyItYnKjy+eYamQy/OZKNVsuqDyKJz/2yA4mLeWSBqYXN9sl0/PTGUXZSI+qVhUSRw
	xX/m+Otk/FJS8tT68IRixoGNnx2bz7Qtlz1gV96KnfzcFhaOXW1XVeJHTUfpCA+1eQgj92y0qwy
	ls9tyP9Godua4DzAguxIygOAHsKVaDyPhVzMGb4++S/cxF0MmjUmD9lAAAQxSzg3DwsKM7a3uCY
	hKPEhfrznlwOcPSI5lYhf/xQxEpSHhkAmax0tafXnoRBEAGuJoiYD3fLHDsYTNjVShixKtQBF7Q
	Wr5aDDrECmS/7S3mFa6llUOq/oKu+VWTe1nIxqn0MKqLjwfUTglq/+4VaqJXtuB9XPqg5R7PYPJ
	qSTjKb9JZQztU96P14hnyb/aNDOdB+K2b1TDTK8MY2HyPTNF+uNLXb5pgNoUCxSJw7jw0F5N3QY
	/ST5N8NyEf9VLUEa0BjQK802QFejkHD1pPRSr/3zg6wThs/B
X-Received: by 2002:a17:90b:2c90:b0:3ac:a521:953 with SMTP id 98e67ed59e1d1-3acef0ff0cdmr4044977a91.46.1792325645279;
        Sun, 18 Oct 2026 05:14:05 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48e8646sm11116604a91.10.2026.10.18.05.14.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 05:14:04 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: PR OUT CLEAR registration-list teardown races concurrent PR OUT -> UAF / double list_del
Date: Sun, 18 Oct 2026 22:13:57 +1000
Message-ID: <20261018121357.63980-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

core_scsi3_emulate_pro_clear() tears down the global registration_list holding
only pr_tmpl->registration_lock, and __core_scsi3_free_registration() drops that
lock across its pr_res_holders busy-wait:

	spin_lock(&pr_tmpl->registration_lock);
	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
			&pr_tmpl->registration_list, pr_reg_list) {
		...
		__core_scsi3_free_registration(dev, pr_reg, NULL, calling_it_nexus);
		...
	}
	spin_unlock(&pr_tmpl->registration_lock);

__core_scsi3_free_registration():

	if (!list_empty(&pr_reg->pr_reg_list))
		list_del(&pr_reg->pr_reg_list);
	...
	spin_unlock(&pr_tmpl->registration_lock);
	while (atomic_read(&pr_reg->pr_res_holders) != 0)
		cpu_relax();
	...
	spin_lock(&pr_tmpl->registration_lock);
	...
	kmem_cache_free(t10_pr_reg_cache, pr_reg);

Unlike PR OUT PREEMPT (core_scsi3_pro_preempt), which holds
dev->dev_reservation_lock across its entire registration_list free loop, CLEAR
drops dev_reservation_lock before the loop. The same registration_lock-only
teardown appears in core_scsi3_free_pr_reg_from_nacl() and the PR OUT REGISTER
unregister path. PR OUT has no device-level serialization, so two I_T nexuses
can run teardown loops concurrently.

list_for_each_entry_safe() caches the next entry. While one CLEAR is parked in
__core_scsi3_free_registration()'s registration_lock drop, a second concurrent
CLEAR acquires registration_lock and list_del()s + kmem_cache_free()s exactly
that cached next entry. The first CLEAR then advances onto the freed entry ->
use-after-free read of ->pr_reg_list.next, list_del() on a poisoned node, and a
double kmem_cache_free().

Reproduced on a KASAN kernel with two tcm_loop I_T nexuses mapped to one iblock
LUN, each looping { PR OUT REGISTER own-key ; PR OUT CLEAR own-key } via SG_IO:

	list_del corruption, ffff...->next is LIST_POISON1 (dead000000000100)
	kernel BUG at lib/list_debug.c:56!
	RIP: __list_del_entry_valid_or_report+0xc2/0x140
	Call Trace:
	 __core_scsi3_free_registration+0x12d/0x430
	 target_scsi3_emulate_pr_out+0xac0/0x13f0
	 __target_execute_cmd+0x56/0x140
	 target_execute_cmd+0x1a0/0x5b0
	 tcm_loop_write_pending+0x15/0x20
	 transport_generic_new_cmd+0x40b/0x700
	 __target_submit+0xae/0x1e0
	 target_queued_submit_work+0x64/0x190

Note for a fix: simply taking dev_reservation_lock across the CLEAR teardown
loop (mirroring PREEMPT) is not sufficient -- it deadlocks. A PR OUT command
takes a pr_res_holders reference on its own registration via
core_scsi3_locate_pr_reg() *before* acquiring dev_reservation_lock, so one CLEAR
busy-waiting in __core_scsi3_free_registration() for another nexus's
registration to reach pr_res_holders == 0 waits forever on a nexus whose own PR
OUT is blocked on dev_reservation_lock (observed as an RCU stall). A correct fix
likely needs the registration lifetime reworked (drop the locate reference
before teardown, or defer the free to the last put) rather than only widening
the lock.

Reported-by: Yu Zhang <yuz08559@gmail.com>
