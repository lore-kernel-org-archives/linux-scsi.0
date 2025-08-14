Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E34F45948
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192764; cv=none; b=mFKq/CMZovp+VgBYtD9/CH8an7/B6upUuynLab7haxhXECJ+zek94PymRVszx02QX6G/u4wyb+LUC8wd5q2YduroFUd1guVhCZwTGb101usMTXzzBvFtoHnpacg7/V3YTxrrGOlh1dH3/vqwRCU2hIC6hcJAacqlgayKDscppYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192764; c=relaxed/simple;
	bh=WDPT3ZAoI5HBnOLpQXZ5HtUf/u9xJ5g+CoVaYo77s9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGzMYLnVZVR+chhDNJl4ZMCDSHvYTw59IknmeyHEPiZf/eHg4jyhi/vgQFUIrQZjwC/AizaeCXaTYbRD1SDGBCqxFFcZ8t41+CdWucRbBlxCiKX7NMr5zfy9JjJPdQEV1T+qxxfOAQgvKG9Ssk8ntoJa81VQAz4jTcMEXSO8AHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrfVRHYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrfVRHYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1916EC4CEED;
	Thu, 14 Aug 2025 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192763;
	bh=WDPT3ZAoI5HBnOLpQXZ5HtUf/u9xJ5g+CoVaYo77s9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrfVRHYb0mCGSGyzCD+nhmeCsD5V/HucxkAGrqC6QpC1LIFjDeQuv2G5l6LvaML3R
	 prhPG58Gy6fLWLso+FgSOUAvRby6DV+Loxo5cIDeGRgrCs4a065bluETTffUJ95DZp
	 Qf3r5IzLdu20tfLI1tGVnI81Kx/yZ7Q997uFk5PtnixlYdTWao+4slXngS68fP1DzN
	 XV5xitDs+Wm12Ubjh0pJJ8nHPG/C3eTh9lP/ICndr7dq1w9oEIZ4aDIiGPlXv9JP/J
	 lnI0A5HK+iWFsWb1GC/OjyH+oyH911G5abDlC6L0vJPX6w6nqi5VQhMEUwkWm2DMOg
	 PbtsxPdDf4y/w==
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 03/10] scsi: libsas: Add dev_parent_is_expander() helper
Date: Thu, 14 Aug 2025 19:32:18 +0200
Message-ID: <20250814173215.1765055-15-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=cassel@kernel.org; h=from:subject; bh=WDPT3ZAoI5HBnOLpQXZ5HtUf/u9xJ5g+CoVaYo77s9M=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS49WsMU68bOveGbb1FE13SXne/vb3Z79mrH0fcab qX5Ua90OkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRzdMZGU69vnc4+3cCq9vy k0ld8QqH24Ou3eLpeRXqUuQ4LejhPUmGP/wq3Zwcj1MKFcrrV61Z33Vlmnf258hLx5kLzwpJLIv 4zQMA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Many libsas drivers check if the parent of the device is an expander.
Create a helper that the libsas drivers will use in follow up commits.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 5 +----
 include/scsi/libsas.h              | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 869b5d4db44c..d953225f6cc2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1313,10 +1313,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 	int i;
 	int res = 0;
 
-	if (!child->parent)
-		return 0;
-
-	if (!dev_is_expander(child->parent->dev_type))
+	if (!dev_parent_is_expander(child))
 		return 0;
 
 	parent_ex = &child->parent->ex_dev;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ba460b6c0374..8d38565e99fa 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -203,6 +203,14 @@ static inline bool dev_is_expander(enum sas_device_type type)
 	       type == SAS_FANOUT_EXPANDER_DEVICE;
 }
 
+static inline bool dev_parent_is_expander(struct domain_device *dev)
+{
+	if (!dev->parent)
+		return false;
+
+	return dev_is_expander(dev->parent->dev_type);
+}
+
 static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_struct *))
 {
 	INIT_WORK(&sw->work, fn);
-- 
2.50.1

