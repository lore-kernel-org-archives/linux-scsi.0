Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0628C3ECBC7;
	Wed, 30 Sep 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790761830; cv=none; b=kWWnFBX8yx8nn63UfbZMl+1yV3WDWrAXI57/8QdUbvwGcjP6UhAt7miMIvcGfaWr7TL303q8u4unOYe7qeRkUwE+UZC6pNtP+o1No7KyP8uGrPcoKaUw/e57yImyxTidfK49eftYWaSWmYfXaJAyWzE+IodEGfdk+UjH3ctMw7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790761830; c=relaxed/simple;
	bh=qROqnn6bG2HRLaciAlBzV31dC2TmTgATRSfcEpIDRZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d4vEVxSEyDLUe+XHYVy4Y5bAxa+2h+Rn6vzJEKU+byZXsv1Hul39Bgt9ENkm3KnGNobQ4kN+59v97rJnbvCDng1YmBA9Dr/EptzvBrFsmD1Ix4LVdiNDLSY79WEThsTYLxWkq48rQPeZQWgTQJPSEyLemVzk7Ufyn9ZfwDJ9Pts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=f5U48cze; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="f5U48cze"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4fa1ab678;
	Wed, 30 Sep 2026 17:50:18 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: lpfc: shut down CPU hotplug poll timer during removal
Date: Wed, 30 Sep 2026 17:50:01 +0800
Message-Id: <20260930095001.2493-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0f1b8d83003a1kunm0629d83b27799c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSh1OVk4fSk9LQhpKSk9CTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=f5U48czeR84VWg2kT80pE/nkgz4aFgn/YTcIe9hFI8VNlk9l2/As7ySI2HnssvTQExnUwlCTFzBt2nCL5+aUR+ewjYBqn6D1hmhl+vMG8r+rMgihxyZyQCbqspT8+bZqolUGuFNLyYxHdwzoI0bqEQX3pyAp0qSE9+EUK1v1j1M=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=S8GZmAGNFMPJIOR684uBJaFIOjQB+ziHKOF5C+tsPXg=;
	h=date:mime-version:subject:message-id:from;

The CPU hotplug removal path waits for the poll timer to retire with
timer_delete_sync().  The poll callback can rearm the timer after the
deletion, so the timer can continue to reference the HBA after the
hotplug instance has been removed.

Use timer_shutdown_sync() only for the final HBA teardown.  lpfc_offline()
also removes the CPU hotplug instance during recoverable offline/online
cycles, so it must leave the timer reusable with timer_delete_sync().
When the HBA is finally removed after such an offline transition, shut
down the timer even though the CPU hotplug instance was already removed.

Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_init.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 23355f12fb..1cdd484ad8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -70,7 +70,7 @@ static enum cpuhp_state lpfc_cpuhp_state;
 static uint32_t lpfc_present_cpu;
 static bool lpfc_pldv_detect;
 
-static void __lpfc_cpuhp_remove(struct lpfc_hba *phba);
+static void __lpfc_cpuhp_remove(struct lpfc_hba *phba, bool shutdown);
 static void lpfc_cpuhp_remove(struct lpfc_hba *phba);
 static void lpfc_cpuhp_add(struct lpfc_hba *phba);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
@@ -3936,7 +3936,7 @@ lpfc_offline(struct lpfc_hba *phba)
 	 * in hba_unset
 	 */
 	if (test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag))
-		__lpfc_cpuhp_remove(phba);
+		__lpfc_cpuhp_remove(phba, false);
 
 	if (phba->cfg_xri_rebalancing)
 		lpfc_destroy_multixri_pools(phba);
@@ -12745,7 +12745,7 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
 	return 0;
 }
 
-static void __lpfc_cpuhp_remove(struct lpfc_hba *phba)
+static void __lpfc_cpuhp_remove(struct lpfc_hba *phba, bool shutdown)
 {
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return;
@@ -12757,16 +12757,24 @@ static void __lpfc_cpuhp_remove(struct lpfc_hba *phba)
 	 * timer. Wait for the poll timer to retire.
 	 */
 	synchronize_rcu();
-	timer_delete_sync(&phba->cpuhp_poll_timer);
+	if (shutdown)
+		timer_shutdown_sync(&phba->cpuhp_poll_timer);
+	else
+		timer_delete_sync(&phba->cpuhp_poll_timer);
 }
 
 static void lpfc_cpuhp_remove(struct lpfc_hba *phba)
 {
+	if (phba->sli_rev != LPFC_SLI_REV4)
+		return;
+
 	if (phba->pport &&
-	    test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag))
+	    test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag)) {
+		timer_shutdown_sync(&phba->cpuhp_poll_timer);
 		return;
+	}
 
-	__lpfc_cpuhp_remove(phba);
+	__lpfc_cpuhp_remove(phba, true);
 }
 
 static void lpfc_cpuhp_add(struct lpfc_hba *phba)
