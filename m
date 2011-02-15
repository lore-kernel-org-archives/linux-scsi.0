From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 6/6] hpsa: fix bad comparison
Date: Tue, 15 Feb 2011 15:33:13 -0600
Message-ID: <20110215213313.5407.42792.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

'!' has higher precedence than '&'.  CFGTBL_ChangeReq is 0x1 so the
original code is equivelent to if (!doorbell_value) {...

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eb6938f..c30591f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3614,7 +3614,7 @@ static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		spin_lock_irqsave(&h->lock, flags);
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
-		if (!doorbell_value & CFGTBL_ChangeReq)
+		if (!(doorbell_value & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
 		usleep_range(10000, 20000);
