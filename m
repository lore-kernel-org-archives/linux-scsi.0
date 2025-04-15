Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE64014A0B7;
	Tue, 15 Apr 2025 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676896; cv=none; b=pWRqWitqDa8Df/tY0fAgg2nvcKt20swpZv5gIXOKi7UvBCahEaJb2ot26ScOINlFncbkxfg3mjuHQYSQppoahUdTWTqP1Vyl7bxN8ov5ppmKZkrwvRklxT2dHlRT0il8pDAgzHaiWCcjf/z+m55qBlV/RA52QoEEA2o0iI54600=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676896; c=relaxed/simple;
	bh=qwaxSBetUIhRLPxOt/cgCP1NfTtf16xbc2pJqLhbwag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u28s5GorNALZDvoK4chfFnlcNFyhYkmiYWWRNkKuZs/gBVL0RzXhaoo+oDPSzbJsPKKC1+2WazzwuwdCDXKQPorNymlxlYJ/QfZocZu8l9QLCKMVljbyFNg/048gCh949pHiZT85TEeliM2yQtWlUVOU2LNJBw1xLZhGl5QyXSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ZDGRUQv6; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ZDGRUQv6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=YNqTtyjORl/J0JOZ+pr1t42gGSPduiUhfhplrenIS+0=; b=ZDGRUQv6R5/cjhaz
	XA9ji3wVNWtXpnVC1fbePmqpaJr5J87NM4roAKJwzG30NutO9h0RIkJXXBeZs4b4zPuV1tL0imqxb
	lfFuZXMWBMcl8FB+Ay0BAqW84iWU0mfu5T8k9IYSy5dURynjOBubzLu0AZb0cOQbVjbzfDalS4KNN
	9O8NeaprQ9J8g0T6uDNa5MAXyoVKCqpJP7fGdwAh4fhGuTAnsguxV+ACV71O1pcSmpyA/8jH2Fuxg
	hjK4Qdm4ZovwvsdyeS2xL9s7ZRH4I69ravoi21YtAK4mb6XLGo0emJ5r2KG96kEREZkZz0AtKtwsK
	M+53LNNHfq9xcbnPVQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9o-00BSPG-1p;
	Tue, 15 Apr 2025 00:28:08 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 8/8] scsi: qla2xxx: Remove unused module parameters
Date: Tue, 15 Apr 2025 01:28:03 +0100
Message-ID: <20250415002803.135909-9-linux@treblig.org>
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

ql2xetsenable last use was removed in 2020 by
commit 37efd51f75f3 ("scsi: qla2xxx: Use FC generic update firmware options
routine for ISP27xx")

ql2xiidmaenable last use was removed in 2017 by
commit 726b85487067 ("qla2xxx: Add framework for async fabric discovery")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 --
 drivers/scsi/qla2xxx/qla_os.c  | 12 ------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index a8c3a4f7862b..03e50e8fc08d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -164,10 +164,8 @@ extern int ql2xsmartsan;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xextended_error_logging_ktrace;
-extern int ql2xiidmaenable;
 extern int ql2xmqsupport;
 extern int ql2xfwloadbin;
-extern int ql2xetsenable;
 extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
 extern int ql2xasynctmfenable;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b44d134e7105..288ce04fc2b1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -176,12 +176,6 @@ MODULE_PARM_DESC(ql2xenablehba_err_chk,
 		"  1 -- Error isolation enabled only for DIX Type 0\n"
 		"  2 -- Error isolation enabled for all Types\n");
 
-int ql2xiidmaenable = 1;
-module_param(ql2xiidmaenable, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xiidmaenable,
-		"Enables iIDMA settings "
-		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
-
 int ql2xmqsupport = 1;
 module_param(ql2xmqsupport, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xmqsupport,
@@ -199,12 +193,6 @@ MODULE_PARM_DESC(ql2xfwloadbin,
 		" 1 -- load firmware from flash.\n"
 		" 0 -- use default semantics.\n");
 
-int ql2xetsenable;
-module_param(ql2xetsenable, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xetsenable,
-		"Enables firmware ETS burst."
-		"Default is 0 - skip ETS enablement.");
-
 int ql2xdbwr = 1;
 module_param(ql2xdbwr, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdbwr,
-- 
2.49.0

