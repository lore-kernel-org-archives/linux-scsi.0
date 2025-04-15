Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5E583CC7;
	Tue, 15 Apr 2025 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676917; cv=none; b=SEsGLXUXSMtdPRnV2aTt9CpwRCKsjZnixp8MPnEWCr3F5Bd9gkrU4fWo3kvTugr34CKBvPOiI1d/JgOfyJ/LnFBR27Vw/f9ujdSD/z9Y3MfppsctruNeaaNjfi7XHfFbDEy8uYgWRB71iXJksV4+Rcf0X+eIAVXf69tSBGSfNmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676917; c=relaxed/simple;
	bh=cUM7w7CMmY2L7uQggLG8LGEM3LoeApasBUuGHN8H67Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj7I4iOSCt4XDYYO6cNzOGPmfZr20HpZz4qHI6aepypJSedtleZa7gh4XzoR1IZwXCVZ5A6N0AL5uYxF7DlvlZVc6fNjhtNdG0FXEYfBCz9eAyDPvD+8QNVPGdUMcjiWdYp/e2ISGZ0yj2CIVf6y4hUiWQ1sKxon8Bx2YMqNzmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QejLMfQZ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QejLMfQZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=OOb3h6FIS4LbALKGJGSOHoeQra9ClF6JGitm4dyi1Gw=; b=QejLMfQZeF/HZZdJ
	PyHlCBwK0mNB9JIERYYlC7O7brtRouuAgWa+Mix0GjtAqHrj+e+uzLf5soyJn7eHTkyBdrwPWX5sL
	ZZ1pl5wtt9H73jgW2HBTASJI6eiQIG6e6kr7aooUA+/q31qKAWlQYCRcxtJf2fjEzh1EOFjcrfGoa
	s1AC6OjslpYXk0rU030gZJyLdAey0JfAww9wBDNwbilZRr3hvrBsYq1Ep0Hy/oBA5i2rfShs28cJI
	C26D6lOcHJmWctgNo8lo777ZpjRMtOiR21gkH1JTq0w++z91hnP8u3kZ6HV4/fUrfIsKiWAUTyQ2n
	TLovSgF68GQsvf/vKA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9m-00BSPG-0t;
	Tue, 15 Apr 2025 00:28:06 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 3/8] scsi: qla2xxx: Remove unused qlt_83xx_iospace_config
Date: Tue, 15 Apr 2025 01:27:58 +0100
Message-ID: <20250415002803.135909-4-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qlt_83xx_iospace_config() has been unused since the last use was removed
by 2017's
commit f54f2cb540b5 ("scsi: qla2xxx: Cleaned up queue configuration code.")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 ----------
 drivers/scsi/qla2xxx/qla_target.h |  1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 15c6d95cc4f2..1e81582085e3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6971,16 +6971,6 @@ qlt_81xx_config_nvram_stage2(struct scsi_qla_host *vha,
 	}
 }
 
-void
-qlt_83xx_iospace_config(struct qla_hw_data *ha)
-{
-	if (!QLA_TGT_MODE_ENABLED())
-		return;
-
-	ha->msix_count += 1; /* For ATIO Q */
-}
-
-
 void
 qlt_modify_vp_config(struct scsi_qla_host *vha,
 	struct vp_config_entry_24xx *vpmod)
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 453eb2f6a7c9..15a59c125c53 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1081,7 +1081,6 @@ extern void qlt_mem_free(struct qla_hw_data *);
 extern int qlt_stop_phase1(struct qla_tgt *);
 extern void qlt_stop_phase2(struct qla_tgt *);
 extern irqreturn_t qla83xx_msix_atio_q(int, void *);
-extern void qlt_83xx_iospace_config(struct qla_hw_data *);
 extern void qlt_logo_completion_handler(fc_port_t *, int);
 extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
-- 
2.49.0

