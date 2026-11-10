Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317388;
	b=vh8A8sYUk5x9iVyCFIL3uy5T+27VXicx95gvkVoZxc7r7Ib+M621AVsnvKoenTf678mt
	 yoxdTFsDu/EkZqq8PMHv4ID0a94pwpBHhfFwMTTGWAVWap9OtoFI8o2UJmCh8k8lj0HrQ
	 SRre5PP9+inAiKWqbKfyjqKHLelQ22g8Xk5OM6BjAyeEGd/a7FWsvLp1MXOZJF7b+x68b
	 Flw8CQe0lu5vH0F8DxNTkzU+JwANZs5+R//5XbPYl3jPKsV67lTx9FJpPopUTZ2QVTgxc
	 FkzuYzGJq6im6Hi95m/BtEHcJRLUmMc/rePQhE0ZmlaX9+6AgU7XvkjAAolXbV8uqsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317388;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=BDc1IvI6OsHXdrQ8x74AtWRkft+aXE3pPjEVY606+KI=;
	b=g7a40iBmC5GdEjTWtD/oPsaSDUDMj6GevkcQkfzSarxBP9YMWH52t4qCWBMj6qEfnvsH
	 utJiZesLi8UZawPhd95II32U+a8KjbrobZZpPTmtMc7lI51ZkCcnemDMtwirVpbFxkjCR
	 JpHfstd+H5kRcbnwUhdNFMYDc+2u+f5+6nYsePfXy4dSLNealqAoC16LORqPSWDf8QyXs
	 FoCkuxYDKwIlobnkF2FcXjXUatREBAL0a6LquVEufrE+hSgR43l4lZMIW0zyJWK5qO1dq
	 dgtU6+OWwEMpHwhEXB9vtbL0qo3mmjgV9ODja2uNzG+07JOJMnwKOeulsbIzo0dygqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TuAh6bOa;
	arc=none smtp.remote-ip=95.215.58.123
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740A9606AF21
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740A9606AF21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TuAh6bOa
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=t58bLFbopiLhye+XA8VecW5nbJtFNFWoJdVnDP5nc/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794317385; v=1; x=1794922185;
 b=TuAh6bOaCEJ+qkh32W6hcLuO20vUvAF91Oks8v1acJWAjGdr2C4BnhO8Np4CiVaRofvfposs
 upwDnqSTXrBYcFYcPZqMuz63UQ4snMxiLv7deeLjiPHLPfWHyyouTzygsE7rpia5QQW9tq9fNHh
 MX/gp9GA19pV3zoLK1ZjpTZI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a77828bfa05a4d54;
	Tue, 10 Nov 2026 13:29:45 +0000
X-Mizu-Trace-ID: a77828bfa05a4d54
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Tue, 10 Nov 2026 08:29:34 -0500
Subject: [PATCH 2/2] scsi: target: alua: Drop the grace period wait from
 LUN detach
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-bug-target-alua-lun-gp-v1-2-127a46efdae9@linux.dev>
References: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
In-Reply-To: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

core_tpg_remove_lun() detaches a LUN from its ALUA target port group
once transport_clear_lun_ref() has drained its I/O, and
target_detach_tg_pt_gp() then waits for an RCU grace period.

Nothing that wait could protect is freed here: the group lives on until
core_alua_free_tg_pt_gp(), which waits for a grace period of its own
before freeing it, and the se_lun is freed with call_rcu(). Every LUN
removed through configfs still pays a grace period for it.

Remove the synchronize_rcu() call.

Removing 256 LUNs from an iSCSI TPG through configfs, five rounds
alternating with and without this patch, takes (median, min-max in
parentheses):

  LUNs  before (ms)       after (ms)        change
   256  5222 (5165-5244)  3551 (3436-3810)    -32%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_alua.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 35d36cd36db6c..4e22f988bb83f 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1858,7 +1858,6 @@ void target_detach_tg_pt_gp(struct se_lun *lun)
 		rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
 	}
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	synchronize_rcu();
 }
 
 static void target_swap_tg_pt_gp(struct se_lun *lun,

-- 
2.43.0

