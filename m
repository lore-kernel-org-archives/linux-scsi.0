From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/3] hpsa: fix incorrect abort diagnostic message
Date: Thu, 26 Jul 2012 11:34:17 -0500
Message-ID: <20120726163417.25864.82410.stgit@beardog.cce.hp.com>
References: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In the abort handler, when asked to abort a command which
is not known to the driver, SUCCESS is returned, but the
diagnostic message incorrectly indicates the abort failed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 015a6c8..415db96 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2609,7 +2609,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	/* not in reqQ, if also not in cmpQ, must have already completed */
 	found = hpsa_find_cmd_in_queue(h, sc, &h->cmpQ);
 	if (!found)  {
-		dev_dbg(&h->pdev->dev, "%s Request FAILED (not known to driver).\n",
+		dev_dbg(&h->pdev->dev, "%s Request SUCCEEDED (not known to driver).\n",
 				msg);
 		return SUCCESS;
 	}
