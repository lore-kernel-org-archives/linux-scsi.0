From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/5] hpsa: fix flush cache transfer length
Date: Wed, 26 Oct 2011 16:21:17 -0500
Message-ID: <20111026212117.15570.3563.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We weren't filling in the transfer length of the
flush cache command (it transfers 4 bytes of zeroes).
Firmware didn't seem to be bothered by this, but it
should be fixed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 646516f..45477b0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2876,6 +2876,8 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
+			c->Request.CDB[7] = (size >> 8) & 0xFF;
+			c->Request.CDB[8] = size & 0xFF;
 			break;
 		case TEST_UNIT_READY:
 			c->Request.CDBLen = 6;
