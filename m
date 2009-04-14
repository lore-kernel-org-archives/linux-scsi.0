From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
Date: Tue, 14 Apr 2009 15:46:59 -0500
Message-ID: <1239742020-11429-2-git-send-email-michaelc@cs.wisc.edu>
References: <1239742020-11429-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42280 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbZDNUrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 16:47:10 -0400
In-Reply-To: <1239742020-11429-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Aaro Koskinen <Aaro.Koskinen@nokia.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Aaro Koskinen <Aaro.Koskinen@nokia.com>

(Resent with proper formatting)

Fix for the sym53c8xx_2 driver to initialize lun's to_clear flag after
a bus reset (a failed clear can trigger a bus reset and it should not
be attemped again after that).

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index ffa70d1..60d6a6d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1896,6 +1896,15 @@ void sym_start_up(struct Scsi_Host *shost, int reason)
 		tp->head.sval = 0;
 		tp->head.wval = np->rv_scntl3;
 		tp->head.uval = 0;
+		if (tp->lun0p)
+			tp->lun0p->to_clear = 0;
+		if (tp->lunmp) {
+			int ln;
+
+			for (ln = 1; ln < SYM_CONF_MAX_LUN; ln++)
+				if (tp->lunmp[ln])
+					tp->lunmp[ln]->to_clear = 0;
+		}
 	}
 
 	/*
-- 
1.6.0.6

