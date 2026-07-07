Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134ED348C70
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783437218; cv=none; b=OMjS7iXKkhFtw225OJEoxAg70QSRyXxIYOtA4/AzQ38Sanj6fsSukZFxhbdWQXObqBZpt0RBZJXqYjkiFtJbp5blPCLMd2wiSPGN8fd/4PKUJsS0qow3F1/dqutCHCh2ymYD6iovZPUrZCVEv0QJVv7WTgHNPFhS4PDcypwoHc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783437218; c=relaxed/simple;
	bh=tNyb5KERqmdGvt814UOI5CF6LIvyKei+Q8ac+RDq/KA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fmrYNtkZTGfWpLLGzRMMzI84aspn3UenGQ1UpqZ2r2pMFgOS8pQtjpA+m8JLRzwTvzlqapKmSCQvk6KD5NzuvitlrD6wuSA7M3d6As2wJuctoSNQLUTT+JtuUwneaXuuJq+KCl2g/Qy+C8O/N77Eg6HtLMLmdsiM8aM62uIYFvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esPo86+J; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esPo86+J"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8478cc93299so4815654b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2026 08:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783437216; x=1784042016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KWgWLU531wg7fILloa6RX/bN9zEBjLF+DYHSduibKQw=;
        b=esPo86+JdAUxmjwCXDGZ4O8m8/ybbhYzVUeuBadOFQTxfn0Bj8cAHErCeIrRz0GSeV
         qR4jV6miq/CjJtlOBM6x/wXZ7ec8d4YE8ITCmN0VxG3K7nVrmP/55MoxZyvToj37qbCc
         eMrBwrlu80LOrlXj4/lZ+cuaesdrMvCwjD+j0PWrGZ0lisK5u6mHc2eaiFx6+oqr6mVn
         0d3m6Y7Zljahl9eQKgwE8BjluIqMx+vT0pv+7c+qxgkJ4nczT9lCusUMNuddRZkzB4Pa
         AIySueBgeeFZnlJ+gO7pYGLQRRhSAYkGHpmGuLvC3/Dl0LZBvNH9CRxRGQ/OMBZm6fiC
         qUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783437216; x=1784042016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWgWLU531wg7fILloa6RX/bN9zEBjLF+DYHSduibKQw=;
        b=p2mA+4uXuX30bJynNgGGHesWzkgR9qweKwF0c5n7m2AGUrm+V1jECo+8YJ7ZYMftn+
         8ueQa3Wu4E89wFabFgggUu5jL6YkDOjj+KcsOJmB6Q/evpprk3guEjMiwFTO6wMpiARM
         gCl2xj93HO+zjFTupnr1VPiln7YMiDSs9qMC56rdZqrUnJoo7TM5WA6kO869cIdbC1ur
         ZC4ZXGS79cv1hthOUQdpKqLIMvO0Tp59kbbEQy2aO+laBlMp7G0iBvNjr7dVHEdJHQ0E
         y+QAi0ziZCm2NDbv90CuD9CyI8JcOFe5qvJz3NOyPcHCWtAiVFbvCkQAmNYpxV2WjRcw
         X/eQ==
X-Forwarded-Encrypted: i=1; AHgh+RpERuu9urLmjaEEOpjD4iz1I1jf+VSDxxZU5be7AeEOfOctrclIh3aXlFQ2Pmk1npMzPve9Wsvbnd5a@vger.kernel.org
X-Gm-Message-State: AOJu0YxBxhC8cYvIa36riK3rmtZEZSR2kIqK7fW/hSM8zpcgiDwk8F2e
	nvwTVittbATPzLm17VTjtOBAbCIwN5aphHu81VuQ4leryWAonsgVjluf
X-Gm-Gg: AfdE7cnPrSdXg1dyNM11rZ7X+ZwEpHZHS616PYZyaj9IojxKtSVQX0LgTsb+QYtDO4I
	AyW4v51LFafspMluf1j9UZj+uyHAE4m+z8kRw/HY1q5MSP8hOdD1bUq42s/hCc7IkJfu8MRaaBB
	LlCIto11fYgi86dJqDA0eLhIbvki13Icf6Lv5+np79cPHScKUkuOtuKpbpO1kMjAaV7TdB5iyxF
	Dcg7WFNzRw19QMmRLb0Wr8KGZli20zNtlMyD9KPZte22WOnRsEd/MRopkyY+tR7YO+qnmRMCV/s
	cRmhBCGa5lAW2U/nbLHcV1kABoSNCqz2t/jkfads1VOWLxt/AYwJB4DgJw9CE1lFEak9mxyqiDf
	zmoh7hwGENL1hjm9WWMMht89dQCynDQEQzJo/1B6/j9ltkHLMb2NiSkn5e1/GMxO/SinqlLki6o
	7rlQM6yAkL0nOGI64jQHKTVqHJhJhlAtkoKA5dAe9sOds=
X-Received: by 2002:a05:6a00:908d:b0:847:1d73:f753 with SMTP id d2e1a72fcca58-84826df100cmr5597938b3a.45.1783437216361;
        Tue, 07 Jul 2026 08:13:36 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:239e:a31b:1d0d:374f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6ddc974sm5717672b3a.60.2026.07.07.08.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 08:13:35 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: martin.petersen@oracle.com
Cc: agrover@redhat.com,
	roland@kernel.org,
	nab@linux-iscsi.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] scsi: target: iscsi: Clear sequence list after PDU allocation failure
Date: Tue,  7 Jul 2026 23:13:30 +0800
Message-ID: <20260707151330.2334097-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsit_build_pdu_and_seq_lists() publishes cmd->seq_list after the
sequence-list allocation succeeds. If the later PDU-list allocation
fails, the error path frees the local seq pointer and returns with
cmd->seq_list still pointing at that freed memory.

The same command is then converted into a reject command, and its normal
release path frees cmd->seq_list again. Clear the published sequence-list
state after freeing seq so command release does not see a stale cleanup
pointer.

This issue was found by a static analysis checker and confirmed by
manual source review.
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 75c37c8866c86..2571097436399 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -549,6 +549,8 @@ int iscsit_build_pdu_and_seq_lists(
 		if (!pdu) {
 			pr_err("Unable to allocate struct iscsi_pdu list.\n");
 			kfree(seq);
+			cmd->seq_list = NULL;
+			cmd->seq_count = 0;
 			return -ENOMEM;
 		}
 		cmd->pdu_list = pdu;
-- 
2.51.0

