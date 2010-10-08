From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/13] cciss: use usleep_range not msleep for small sleeps
Date: Fri, 08 Oct 2010 15:06:47 -0500
Message-ID: <20101008200647.24279.76464.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 08cbee8..7d2959c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3769,7 +3769,7 @@ static void __devinit cciss_wait_for_mode_change_ack(ctlr_info_t *h)
 	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 }
 
