From: giridhar.malavali@qlogic.com
Subject: [PATCH 11/16] qla2xxx: Silence bogus warning by gcc for wrap and did.
Date: Tue,  4 May 2010 15:01:31 -0700
Message-ID: <1273010496-43045-12-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47177 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760235Ab0EDWBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:40 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Mike Waychison <mikew@google.com>

From: Mike Waychison <mikew@google.com>

The qla2xxx driver uses a port_id_t to mark the start of its enumerations.  gcc
is complaining that wrap.b24 may be used uninitialized, but this doesn't look
to be possible.  Silence it.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e78089d..7fd1344 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3150,7 +3150,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	sw_info_t	*swl;
 	int		swl_idx;
 	int		first_dev, last_dev;
-	port_id_t	wrap, nxt_d_id;
+	port_id_t	wrap = {}, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
 	struct scsi_qla_host *tvp;
@@ -3453,7 +3453,7 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
 	uint32_t rscn_entry;
 	uint8_t rscn_out_iter;
 	uint8_t format;
-	port_id_t d_id;
+	port_id_t d_id = {};
 
 	rval = QLA_RSCNS_HANDLED;
 
-- 
1.6.2.rc1.30.gd43c

