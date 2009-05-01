From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH] libfc,fcoe,fnic: Separate rport and lport max retry counts
Date: Fri, 01 May 2009 10:01:26 -0700
Message-ID: <20090501165111.16733.31537.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:4955 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752798AbZEARC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2009 13:02:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: abjoglek@cisco.com, robert.w.love@intel.com

James,

This patch is a minor update to the libfc/fcoe/fnic drivers. It adds a
separate knob to libFC to allow the lower-level driver (fnic or fcoe) to
configure the number of retries for lport and rport separately.

Its not a bug fix, so it didnt get submitted along with Robert's previous
set of libFC fixes for -rc4. Since its needed for fnic, maybe, it can go
along with the fnic changes in scsi-misc. Will that work?

abhijeet

This allows fnic to configure number of retries for lport and rport
separately.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |    1 +
 drivers/scsi/fnic/fnic_main.c |    1 +
 drivers/scsi/libfc/fc_rport.c |    2 +-
 include/scsi/libfc.h          |    1 +
 4 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 03e1926..28216c6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -146,6 +146,7 @@ static int fcoe_lport_config(struct fc_lport *lp)
 	lp->link_up = 0;
 	lp->qfull = 0;
 	lp->max_retry_count = 3;
+	lp->max_rport_retry_count = 3;
 	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
 	lp->r_a_tov = 2 * 2 * 1000;
 	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 32ef6b8..a840728 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -680,6 +680,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	}
 
 	lp->max_retry_count = fnic->config.flogi_retries;
+	lp->max_rport_retry_count = fnic->config.plogi_retries;
 	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 			      FCP_SPPF_CONF_COMPL);
 	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 747d73c..1bb0322 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -478,7 +478,7 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
 		return fc_rport_error(rport, fp);
 
-	if (rdata->retries < rdata->local_port->max_retry_count) {
+	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
 		FC_DEBUG_RPORT("Error %ld in state %s, retrying\n",
 			       PTR_ERR(fp), fc_rport_state(rport));
 		rdata->retries++;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 45f9cc6..ebdd9f4 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -679,6 +679,7 @@ struct fc_lport {
 	unsigned int		e_d_tov;
 	unsigned int		r_a_tov;
 	u8			max_retry_count;
+	u8			max_rport_retry_count;
 	u16			link_speed;
 	u16			link_supported_speeds;
 	u16			lro_xid;	/* max xid for fcoe lro */


