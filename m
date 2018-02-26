From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 33/38] cxlflash: Setup LISNs for master contexts
Date: Mon, 26 Feb 2018 16:24:27 -0600
Message-ID: <1519683867-17944-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Similar to user contexts, master contexts also require that the per-context
LISN registers be programmed for certain AFUs. The mapped trigger page is
obtained from underlying transport and registered with AFU for each master
context.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 5d754d1..8c55fcd 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1756,6 +1756,8 @@ static int init_global(struct cxlflash_cfg *cfg)
 	u64 wwpn[MAX_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
 	int rc = 0;
+	int j;
+	void *ctx;
 	u64 reg;
 
 	rc = read_vpd(cfg, &wwpn[0]);
@@ -1816,6 +1818,25 @@ static int init_global(struct cxlflash_cfg *cfg)
 		msleep(100);
 	}
 
+	if (afu_is_ocxl_lisn(afu)) {
+		/* Set up the LISN effective address for each master */
+		for (i = 0; i < afu->num_hwqs; i++) {
+			hwq = get_hwq(afu, i);
+			ctx = hwq->ctx_cookie;
+
+			for (j = 0; j < hwq->num_irqs; j++) {
+				reg = cfg->ops->get_irq_objhndl(ctx, j);
+				writeq_be(reg, &hwq->ctrl_map->lisn_ea[j]);
+			}
+
+			reg = hwq->ctx_hndl;
+			writeq_be(SISL_LISN_PASID(reg, reg),
+				  &hwq->ctrl_map->lisn_pasid[0]);
+			writeq_be(SISL_LISN_PASID(0UL, reg),
+				  &hwq->ctrl_map->lisn_pasid[1]);
+		}
+	}
+
 	/* Set up master's own CTX_CAP to allow real mode, host translation */
 	/* tables, afu cmds and read/write GSCSI cmds. */
 	/* First, unlock ctx_cap write by reading mbox */
-- 
2.1.0
