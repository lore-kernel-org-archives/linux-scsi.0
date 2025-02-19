Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB89B1EF0AC;
	Wed, 19 Feb 2025 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977385; cv=none; b=d++p5MJEeiWiNDwjy9p3x2i6D9muv22PlzNTgA87xq2x2wa/7mRjQSFKOri6lokVZFz97GwisctCD2bH3b7ZifAaK1M2+UVkuHPEnMIdK4lvYi3iYYKF3+3PezdXJ9LJh0tIIlT/CGmiD8xyFuLT9gxktaFbfRw2DLCt3WDLQ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977385; c=relaxed/simple;
	bh=w9DOtnbRLPXb+ydK2GSSgRxzmQ4uz6uSWEfbMeMo018=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sr0moCXjUXxICCJFZ2Fr5S7vtPPnFHEZCMna0cZvjbBZGKu7PZMwBu/8gplO54qaTiS22Wyl2bJHbN83jFUMoBpebJITjJXi6wkC4BC9Lq1JkFkpz5jCsbT09FgvEhf2DlRTN0K9cfRXdq9TqI2DFRDnIt2jLQLhUOkUm2YKefo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=jPUMFM4J; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="jPUMFM4J"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2a9d:0:640:c19b:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id D9CC060C28;
	Wed, 19 Feb 2025 18:01:48 +0300 (MSK)
Received: from den-plotnikov-n.yandex-team.ru (unknown [2a02:6b8:b081:8::1:29])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id h0YOfN0IjOs0-kZWnFubX;
	Wed, 19 Feb 2025 18:01:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1739977308;
	bh=yBGNG4f6oMyYrASU1Bnv5rpTKNYViHEtSHMTDULgYsU=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=jPUMFM4Jvlvw71cI7hXFgGXMZgghJHd/wG5UcZ7d5RbWztPEeS/q3Bc4MlvQhqZWs
	 y7mqoLYcgs5ECqCvYcUwRvkMktSEMBMgdXkysPsa++KlJ9wz0/eoVwMHjyQuDg95RG
	 /vX74l7G05N2eISzadWTNqwaWljGPe5HVUloUW2k=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com,
	mrangankar@marvell.com,
	njavali@marvell.com
Subject: [PATCH] qedi_iscsi: remove dead code from qedi_process_iscsi_error()
Date: Wed, 19 Feb 2025 18:00:43 +0300
Message-Id: <20250219150043.1051211-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes, just dead code removal.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6ed8ef97642c8..1891a55fd83e9 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1649,12 +1649,6 @@ void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 {
 	struct qedi_conn *qedi_conn;
 	struct qedi_ctx *qedi;
-	char warn_notice[] = "iscsi_warning";
-	char error_notice[] = "iscsi_error";
-	char unknown_msg[] = "Unknown error";
-	char *message;
-	int need_recovery = 0;
-	u32 err_mask = 0;
 	char *msg;
 
 	if (!ep)
@@ -1669,25 +1663,14 @@ void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 	QEDI_ERR(&qedi->dbg_ctx, "async event iscsi error:0x%x\n",
 		 data->error_code);
 
-	if (err_mask) {
-		need_recovery = 0;
-		message = warn_notice;
-	} else {
-		need_recovery = 1;
-		message = error_notice;
-	}
-
 	msg = qedi_get_iscsi_error(data->error_code);
-	if (!msg) {
-		need_recovery = 0;
-		msg = unknown_msg;
-	}
 
 	iscsi_conn_printk(KERN_ALERT,
 			  qedi_conn->cls_conn->dd_data,
-			  "qedi: %s - %s\n", message, msg);
+			  "qedi: %s - %s\n", "iscsi_error",
+			  msg ? msg : "Unknown error");
 
-	if (need_recovery)
+	if (msg)
 		qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
 }
 
-- 
2.34.1

