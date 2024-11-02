Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E252F8614E;
	Sat,  2 Nov 2024 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730585024; cv=none; b=aJYTR7QRj20j44qEIayb5mwPcfQf0sRiqRn6bZz8ACXYHy3Vhvxng8ZT1blVF3zwEFqeHs+BpFwGvqKT6o7AIl/YonGUiO2QATnl/3aZx5iGIFTxJFGSyYRoaZitg/rPKkq0urfQbvehSWE+aL8SM3tOL60+xfFwnDJjZIs21tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730585024; c=relaxed/simple;
	bh=9mfvTzcdKyU6gxQr+IJMM86C51RrQsU0NQyFHgLiCvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IGBqB4X8g3WCzyU19G2seICekFGsNIxv7uyTz9hb9Rq03I1FaTwbjF/AHYbwCqMhb0pwvdxiqXUm9nEP1Bi+LRkoFtSsX7Qa2A71xXXpmiDUsSeoWo6+uxmyiGwVt2LucLqjkpESIx+NELsp7W0JhEWbR2xTQsPi51aEjmDWmzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=oVHePbXe; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="oVHePbXe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=hvnXh5Qln8KkBwWmvdxVN9fl2krKhRgltmW3yYxCOl4=; b=oVHePbXeJJTA8dTA
	fpxBdGwmm7IZGegOjqKVn3GplKTpPPPpX8IH98dJXQoXuS1O5S1CeN5ywg4xdLPiG28ECsc8qtWms
	u4j6qIilj9fM/aITNDbx42HUQ+RH25BRrbY/JHwW34Qaz/B9tFMmi4xCOJKe6zh/lXpiKmFTtYkD6
	WzyItrNHmzNPQ5NyLm0masq+Dghkwt0Xpzyd3lxVJmkmyjcyDKTj83bWgahOv8CisZfR+zePnf1nK
	2hPW6zkcuoGmTRYHxOpkP0+v2ENTEaTPxfz/vL2BDnd7qDF2/I0nJ6XQ78kRSrNZyzxTB/lmmPRcF
	rm93szjrTs2GPW2fRw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1t7MDY-00F7wF-2S;
	Sat, 02 Nov 2024 22:03:36 +0000
From: linux@treblig.org
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: esas2r: Remove unused esas2r_build_cli_req
Date: Sat,  2 Nov 2024 22:03:36 +0000
Message-ID: <20241102220336.80541-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

esas2r_build_cli_req() has been unused since it was added
in 2013 by
commit 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA
RAID Adapter Driver")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/esas2r/esas2r.h     |  4 ----
 drivers/scsi/esas2r/esas2r_vda.c | 17 -----------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 8a133254c4f6..1e2d7c63a8e3 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -1045,10 +1045,6 @@ void esas2r_build_mgt_req(struct esas2r_adapter *a,
 			  u32 length,
 			  void *data);
 void esas2r_build_ae_req(struct esas2r_adapter *a, struct esas2r_request *rq);
-void esas2r_build_cli_req(struct esas2r_adapter *a,
-			  struct esas2r_request *rq,
-			  u32 length,
-			  u32 cmd_rsp_len);
 void esas2r_build_ioctl_req(struct esas2r_adapter *a,
 			    struct esas2r_request *rq,
 			    u32 length,
diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index 30028e56df63..5aa728704dfc 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -444,23 +444,6 @@ void esas2r_build_ae_req(struct esas2r_adapter *a, struct esas2r_request *rq)
 	}
 }
 
-/* Build a VDA CLI request. */
-void esas2r_build_cli_req(struct esas2r_adapter *a,
-			  struct esas2r_request *rq,
-			  u32 length,
-			  u32 cmd_rsp_len)
-{
-	struct atto_vda_cli_req *vrq = &rq->vrq->cli;
-
-	clear_vda_request(rq);
-
-	rq->vrq->scsi.function = VDA_FUNC_CLI;
-
-	vrq->length = cpu_to_le32(length);
-	vrq->cmd_rsp_len = cpu_to_le32(cmd_rsp_len);
-	vrq->sg_list_offset = (u8)offsetof(struct atto_vda_cli_req, sge);
-}
-
 /* Build a VDA IOCTL request. */
 void esas2r_build_ioctl_req(struct esas2r_adapter *a,
 			    struct esas2r_request *rq,
-- 
2.47.0

