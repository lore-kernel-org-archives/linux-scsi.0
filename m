From: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Subject: Re: [PATCH] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
Date: Tue, 16 Dec 2008 18:19:54 +0200
Message-ID: <1229444394-3172-1-git-send-email-Aaro.Koskinen@nokia.com>
References: <49468964.605@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:47159 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYLPQX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 11:23:28 -0500
In-Reply-To: <49468964.605@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx, michaelc@cs.wisc.edu

(Resent with proper formatting)

Fix for the sym53c8xx_2 driver to initialize lun's to_clear flag after
a bus reset (a failed clear can trigger a bus reset and it should not
be attemped again after that).

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 98df165..b126a7a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1897,6 +1897,15 @@ void sym_start_up(struct Scsi_Host *shost, int reason)
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
1.5.4.3

