Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F37240C5AE
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879433; cv=none; b=p/XVhwl/FPLZ+1w/M7IBELB7AQr8Wan8usNbDiNKm0UGppcvQ3eUD8HeFVnub2vmq/YuoOd7lOOZ0eeqqCs2LzJIti4V83KhRpToj+8a0jr/XX0D2N5wou4EAgy/kKU84fPQrRa9VBQN/OdqwApL7Tg0hUCJaiZMqKAPnnAX5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879433; c=relaxed/simple;
	bh=EojRtJx11W5xlguZUK4s5OiYfzm/jUFXVb7sX9hq9PE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dMpHt5QgDOZMZIxoh2bPeXnZE0JBOb+C/67ca3pE3LNhBreTxtgaTUvpfn7RPv1rDgYys2D47fJXqxlH8yqxCypwPAxDLaEcJgDGEeddhIT6MPgCbIvRcrYTCL/CAy4F05LqnHGpW7pqhJKm3nWINwxLv1ZSOTkR7UJc7ZO75WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rtFC8i+i; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rtFC8i+i"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cace91f112so4394365ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 14:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785879432; x=1786484232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+wiL1g37iz3L+Oh1WFh/qb02WbdA5XTOtdYfs+Nou8=;
        b=rtFC8i+imWIcK/Bf3jTHIti4mE5qdwFjcIgyZaxH2OYWK98I5Mup2NvVA41LNAAYDD
         a2+deYmWeeDDS550BwmcgrZ/s/pLMLyOzoiy4bW+9fH5HGR1rxgsitFAqYx/sE65EZ+3
         y4gBu2fugFC2HxNs2WA4m3m4uIPIwo1DKRbezpUNBaUKpqsd5slGkPYxhemz28cgsZJr
         evN4QRW+lIEfN8KRMy4AeDC69AsaF4BKdqc/7Hy7kXFb4Mlq6Cq8kyyEICyL2BpzF7C0
         5oke3Z4LZxm/Pgzf6xOgipsdZjeGELcE5niCNljwoO3QAEh/rqhNe3pG/Bfq8KdXsgGG
         4M0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879432; x=1786484232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i+wiL1g37iz3L+Oh1WFh/qb02WbdA5XTOtdYfs+Nou8=;
        b=WZk3sTHTnEndDcHFm8JACtb4hHO/aLKGrng9WFwMKq0re7zeeES+EDvCkaLrDGwqbJ
         FCzHVe8g9+2TC7fhWRpoPtfFqxnsBhdd9uDWOofL+pTKLNbjflDF0n9iYpUNsodiPcE1
         DJXj48s+DbGUGcuMu6vHF//nzNjvlyAGu5jRWAi443/pxw6BnAoMUGZ7Q1WTY9fMeaR5
         1rYn7LZPdGN/HLwXfiebA+fCP6rRRPu6315hNw4K4Uq5egA+g5hYFVoz0Z9p4sGieX/Q
         TYqIz3XplOujJXwUKPpkAmkqQdmxSmJl2zhhm1BxnAgBJuv6v/lj2FQ+R/vKqFUsoaia
         OX1A==
X-Forwarded-Encrypted: i=1; AHgh+RqkQxZM2YsNqxphzA4nE9QBBJtpWDpBmI/388e9lnyhSqh+YlJSDp1nsUATtqGlfWBdefUaMiOS5UzV@vger.kernel.org
X-Gm-Message-State: AOJu0YxjLr2OQob2Tq3D1J3kcFxvv7NBJCRrrA6fPB0PPAETcztZu8mn
	VMtIt/Qk1Ys2soGfU49afVVkAwzdSOTySjIWfZOllzfLB+UWn/AfrmcV
X-Gm-Gg: AR+sD10b/hWZUYo/XZ3k4nHI2En6rqXVyF/+BJS4P6foSdISRFEp9KcJW+e7eMPnzkj
	HiVuII50ZR2Gc8Y1P7g8GXZ9PknuoQnWoCtQa30TEYJKDDG233pymDjgh7LyrBuHuVmAPs2ujSc
	cxvMuMRu1q0jQiACwDXI8dX2H0KfEwoZF5SgqtB1C8lvSql4dThsk7K3A8XdAn0W5Sdc1ZHCyQk
	czS8SKCndAy0UoFnHmevL/DRiQQB1vWRq9JWFuDKfDw2iFJIPiw6ZOg++0Q8YB4dLUj/YPvebj/
	qmeI3wzlK121WSA7kZjlU4wo8uAd/G+Q3BbFOkuzBw7QPqd+cotCXBFR/CqFDfLdVARCPEu7LIo
	1BER9I9WUT6lcscWsCFu1lH5FqXBIpUZdHnBDtu8eSOEI0/+aGR1SAZDwx09deZB0RWAWyuwP1F
	X5xyAEIgp9z3ftmJkVp7DTu01nnQA4lqIfudpTCKtO47nePu0Z5Mu3gCDZXom2R/LEbV/ZwGLE4
	n3IS3ibu5cTs2TyEhzgtmadHxBdkuH9eCsp+IDVQR0=
X-Received: by 2002:a05:6a21:329c:b0:3c3:8315:80b7 with SMTP id adf61e73a8af0-3cb85e9757amr1738601637.9.1785879431707;
        Tue, 04 Aug 2026 14:37:11 -0700 (PDT)
Received: from LAPTOP-DPAKMOI4.it.purdue.edu (pal-210-106-74.itap.purdue.edu. [128.210.106.74])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca8df89asm13408224c88.9.2026.08.04.14.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:37:11 -0700 (PDT)
From: Yifei Gao <gyf161023@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-kernel@vger.kernel.org,
	Yifei Gao <gyf161023@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: tcm_fc: use kref_get_unless_zero() in ft_sess_get()
Date: Tue,  4 Aug 2026 21:37:02 +0000
Message-ID: <20260804213703.3411166-1-gyf161023@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ft_sess_get() walks the RCU-protected session hash under rcu_read_lock()
and takes a plain kref_get() on a matching session. Session teardown does
hlist_del_rcu() and then drops ft_lport_lock before the final
ft_sess_put() -> kfree_rcu(). A reader that is preempted between the
port_id comparison and the kref_get() can therefore revive a session whose
refcount has already dropped to zero and is pending free, leading to a
use-after-free and a double target_remove_session().

Use kref_get_unless_zero() and treat a zero refcount as "not found",
matching the standard pattern for RCU lookups that race with kref-based
teardown.

Fixes: 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 797be06ab71b..1bc7d2dcbea3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -172,7 +172,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	head = &tport->hash[ft_sess_hash(port_id)];
 	hlist_for_each_entry_rcu(sess, head, hash) {
 		if (sess->port_id == port_id) {
-			kref_get(&sess->kref);
+			if (!kref_get_unless_zero(&sess->kref))
+				break;
 			rcu_read_unlock();
 			TFC_SESS_DBG(lport, "port_id %x found %p\n",
 				     port_id, sess);
-- 
2.43.0

