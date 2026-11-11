Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404847;
	b=zoeH8D6r+BgsN8tWgoORmB4Yse5retu0ns0161ug+k/D13H/2yOW5Q9mfoQ8RF2Qbgg7
	 4Qy2mdVXTd39UVgP0iIk+GGeU8uVP7qIISltrtEG9XWG65OxG2JAzFWqJ9hr+kxlKx+Rn
	 A6FOTThVzXhMNKyjRbiIihxbMB2sXfTA8x32BnfRF65QXZ9563nJ30xrXUnrgNSs09FQO
	 uBe4F188VCrbMw7NTO31MB0XAoKrM7kC2YWRFZBN9Ogs/0FR9gaBpuSYiSXQGld6Ekzay
	 5dtauwGsnpbzsYYQKfg5PMv7N2dJmwXwgv2D+3PzZZLM+4psiCMY624QadRbfSXz2/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404847;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:
	 X-Mailer;
	bh=1BizE5bm2337kNlpzWkzdIe8Co2mGkxHMEG1w5RSHWo=;
	b=Bs3OT47HKGORNXD8iH/sVzrIdMiV5pos7SNlSi26QLK5+qLhHG34Ji+pfaADcWIlktN5
	 9COb9qtnxlS/SvkcU4g/dXQcv60HC9Ex5dLjtBul8s2Cfi+F3EB3LYkDkokDIjYtnEZyB
	 WY4iFuxQg6PzKvqmevrPCMM8Yn8Zv6NdrPcuBaW/qNUdNDr9TKjuBop1St0Mkg9pYRQ7Y
	 qFhkY+8GRHWK16tozQEeXAUYLaiborLNV4p/WVdYTGCROvp9el1/N1ISwX97PDdmp9HX6
	 zQGNJ0KPL3iuh8hyk75ySURLn2FC47SopY708FdXWZHsY+X0qLqaQAwzQaNWYpIsd/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sq9mFaZd;
	arc=none smtp.remote-ip=95.215.58.8
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C4606A32D
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 13:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B54C4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Sq9mFaZd
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VdMYcUi7XPWWy7iGCRQJnDkZk3T3knnACfUGqAi7Z1w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794404844; v=1; x=1795009644;
 b=Sq9mFaZd7V6ryc7f0aRbOR9KaP+B+bn+Ot+Vu67lxIiKn+756DO83Zgt1lSyvJhzuTRuup6T
 eMO0Mpbu7d2EL0rr/jQmZYzZNZ13euWK+1QM4QaHZDGgKIGmkDI7nJDHllijpftJESBf5Mfrrgf
 k64WGpIMEYKUzHDlAsMB1pJQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d625bdf92d81dfe;
	Wed, 11 Nov 2026 13:47:24 +0000
X-Mizu-Trace-ID: 1d625bdf92d81dfe
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Wed, 11 Nov 2026 08:47:18 -0500
Subject: [PATCH] scsi: target: alua: Free target port groups with
 kfree_rcu()
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
Message-Id: <20261111-bug-target-alua-free-gp-v1-1-d1e692ae8694@linux.dev>
X-B4-Tracking: v=1; b=H4sIAOVx9GoC/x3MQQqEMAxA0atI1gZM1YJzlcFF1FgD4khqRRDvP
 sXlW/x/QxRTifApbjA5Nepvy6CygHHhLQjqlA2ucp6IKhxSwIMtyIG8JsbZRDDsSI1v27pj5zu
 GXO8ms17v+ds/zx8vWtVmaQAAAA==
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

core_alua_free_tg_pt_gp() frees a target port group when its configfs
group goes away, including the default group of every device when its
backstore is deleted. Readers of lun->lun_tg_pt_gp may still hold the
group, so it waits for an RCU grace period before freeing it.

The wait is synchronous, so deleting a backstore spends most of its time
in synchronize_rcu(), which adds up when tearing down many of them.

Free the group with kfree_rcu() instead. Nothing else in the function
needs the grace period to have elapsed, and kmem_cache_destroy() waits
for pending kfree_rcu() calls on module unload.

Deleting 256 rd_mcp backstores through configfs, five rounds
alternating with and without this patch, takes (median, min-max in
parentheses):

  backstores  before (ms)       after (ms)     change
         256  2108 (2105-2127)  692 (675-700)    -67%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_alua.c | 3 +--
 include/target/target_core_base.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c430..4ef243ae843bb 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1771,8 +1771,7 @@ void core_alua_free_tg_pt_gp(
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-	synchronize_rcu();
-	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
+	kfree_rcu(tg_pt_gp, rcu_head);
 }
 
 static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 002b0fc575876..cec29cbec1643 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -331,6 +331,7 @@ struct t10_alua_tg_pt_gp {
 	struct list_head tg_pt_gp_lun_list;
 	struct se_lun *tg_pt_gp_alua_lun;
 	struct se_node_acl *tg_pt_gp_alua_nacl;
+	struct rcu_head rcu_head;
 };
 
 struct t10_vpd {

---
base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
change-id: 20261110-bug-target-alua-free-gp-1465539a269a

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>

