From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH RESEND] mpt3sas:Fix missing error checks for calls to
 _transport_phy_reset in mpt3sas_transport.c
Date: Sat,  2 Jul 2016 15:21:59 -0400
Message-ID: <1467487319-30989-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: sathya.prakash@broadcom.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, sbranden@broadcom.com, jonmason@broadcom.com, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com, rjui@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

This adds the missing error checks and paths for functions that
call _transport_phy_reset and do not correctly check that the
call to this particular function has succeeded by returning zero
in the file, mpt3sas_transport.c.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index ca36d7e..bff5a11 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1766,7 +1766,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 
 	/* link reset */
 	if (enable)
-		_transport_phy_reset(phy, 0);
+		rc = _transport_phy_reset(phy, 0);
 
  out:
 	kfree(sas_iounit_pg1);
@@ -1870,7 +1870,9 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	}
 
 	/* link reset */
-	_transport_phy_reset(phy, 0);
+	rc = _transport_phy_reset(phy, 0);
+	if (rc)
+		goto out;
 
 	/* read phy page 0, then update the rates in the sas transport phy */
 	if (!mpt3sas_config_get_phy_pg0(ioc, &mpi_reply, &phy_pg0,
-- 
2.5.0
