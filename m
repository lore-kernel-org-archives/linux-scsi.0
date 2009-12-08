From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/5] hpsa: suppress messages due to unsupport SCSI REPORT_LUNS
Date: Tue, 08 Dec 2009 15:38:32 -0600
Message-ID: <20091208213832.23493.17251.stgit@beardog.cce.hp.com>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756105AbZLHVgx@vger.kernel.org>
In-Reply-To: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: suppress messages due to unsupport SCSI REPORT_LUNS

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 380236a..22bca00 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -964,6 +964,13 @@ static void complete_scsi_command(struct CommandList *cp,
 				break;
 			}
 			if (sense_key == ILLEGAL_REQUEST) {
+				/*
+				 * SCSI REPORT_LUNS is commonly unsupported on
+				 * Smart Array.  Suppress noisy complaint.
+				 */
+				if (cp->Request.CDB[0] == REPORT_LUNS)
+					break;
+
 				/* If ASC/ASCQ indicate Logical Unit
 				 * Not Supported condition,
 				 */
