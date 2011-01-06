From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/11] hpsa: fixup DMA address before freeing.
Date: Thu, 06 Jan 2011 14:47:53 -0600
Message-ID: <20110106204753.10753.51529.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <StephenM.Cameron>

Some low bits might have been set by the driver, causing
a message like this to come out:

 [   13.288062] ------------[ cut here ]------------
 [   13.293211] WARNING: at lib/dma-debug.c:803 check_unmap+0x1a1/0x654()
 [   13.300387] Hardware name: ProLiant DL180 G6
 [   13.305335] hpsa 0000:06:00.0: DMA-API: device driver tries to free
 DMA memory it has not allocated [device address=0x000000007f81e001]
 [size=640 bytes]

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    2 +-
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e4b5f3c..e2089a3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2267,7 +2267,7 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
 	pci_free_consistent(h->pdev, sizeof(*c->err_info),
 			    c->err_info, (dma_addr_t) temp64.val);
 	pci_free_consistent(h->pdev, sizeof(*c),
-			    c, (dma_addr_t) c->busaddr);
+			    c, (dma_addr_t) (c->busaddr & DIRECT_LOOKUP_MASK));
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index f5c4c3c..7910c14 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -265,6 +265,7 @@ struct ErrorInfo {
 
 #define DIRECT_LOOKUP_SHIFT 5
 #define DIRECT_LOOKUP_BIT 0x10
+#define DIRECT_LOOKUP_MASK (~((1 << DIRECT_LOOKUP_SHIFT) - 1))
 
 #define HPSA_ERROR_BIT          0x02
 struct ctlr_info; /* defined in hpsa.h */
