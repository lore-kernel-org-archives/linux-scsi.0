Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB03C13FE;
	Wed, 24 Jun 2026 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313130; cv=none; b=dHd8bJuJkugzz1liZnnUVxsbiWHyLU8ksTiLZCmvSxIeqMhOCA2lj91Lx9LHB2IxEmFlPDfsx5oF4z9NPY+gjNzQMg7CjqIsTVKa6hbhSsVSWipiLhRtvFHQBdoiK4Ld5E8XFJzOAe5DFVztyxS1sJajIEH2JBrIs/ExavyUzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313130; c=relaxed/simple;
	bh=8Tc6huJUSCtySfVnNDBygzECJCIFnhSKm6Ch+74QnVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fJixxy+Cas4YrL7ROJQFi3sMzVmntFubh4zKzn20yPTmNxWJjLYyhW6EwIzxuvrJ42vk6dRAhdWbOSq5n3VlaowVfuzACJztppHyEEewQ2vReCNSLqBEHarfouchxMe6HhLjxZd0yWgKmSGL61AfOQbtMWGVGzqPHRkKN8tNTjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=ZqS0GRUL; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="ZqS0GRUL"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 439d317cd;
	Wed, 24 Jun 2026 22:53:33 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: [PATCH] scsi: target: tcm_fc: annotate session hash traversals
Date: Wed, 24 Jun 2026 22:53:20 +0800
Message-Id: <20260624145320.3429431-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9efa1f427a03a1kunmacfe67d13b40d
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTR0YVklCHh8ZSkgaHU8dGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=ZqS0GRULzPIjrlr9kSO7TLkUWNCxrAlOLawPs2c5x4CyGHSCXNysh0ygVOTzZU/qE/PFFvRQQ+XBC7dHtdbmQGj+BSM+OAH7A53bEtWlBoCX4EypP+GDnbbaXJtXsE4jKln2+oId1RyQPkArALqU7B/uJZiNFDyf8w7zpo5Fi6g=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=462cfg789ed4htZjavkN1M7ugdYF5RDMVCcSrltJa1g=;
	h=date:mime-version:subject:message-id:from;

The TCM FC session hash is updated with RCU hlist primitives. Several
writer-side helpers traverse the hash with hlist_for_each_entry_rcu()
while the file-level comments state that the caller holds ft_lport_lock:

ft_sess_create()
ft_sess_delete()
ft_sess_delete_all()

Other tcm_fc paths already use lockdep_is_held(&ft_lport_lock) when
dereferencing RCU-protected local-port state. Pass the same lockdep
condition to these session hash iterators so CONFIG_PROVE_RCU_LIST can
distinguish the ft_lport_lock-protected writer paths from ordinary RCU
readers.

This was found by our static analysis tool and then manually reviewed
against the current tree. In the reviewed CONFIG_PROVE_RCU_LIST triage
runs, the session hash walkers produced the expected "RCU-list traversed
in non-reader section!!" warning with stacks matching ft_sess_create()/
ft_prli_locked(), ft_sess_delete()/ft_prlo(), and ft_sess_delete_all()/
ft_lport_del(). The change is limited to documenting the existing
protection contract.

This is a lockdep annotation cleanup and does not change the session
hash lifetime model.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/target/tcm_fc/tfc_sess.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 797be06ab71b..84a6f29a1b5f 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -215,7 +215,8 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock))
 		if (sess->port_id == port_id)
 			return sess;
 
@@ -264,7 +265,8 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock)) {
 		if (sess->port_id == port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -291,7 +293,8 @@ static void ft_sess_delete_all(struct ft_tport *tport)
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash,
+					 lockdep_is_held(&ft_lport_lock)) {
 			ft_sess_unhash(sess);
 			ft_close_sess(sess);	/* release from table */
 		}
-- 
2.34.1

