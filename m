From: madhu.iyengar@qlogic.com
Subject: [PATCH 3/5] qla2xxx: Correct issue where NPIV-config data was not being allocated for 82xx parts.
Date: Tue, 23 Nov 2010 16:52:48 -0800
Message-ID: <1290559970-12123-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59507 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755024Ab0KXBFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:05:48 -0500
In-Reply-To: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

This would cause a panic while reading the NPIV-config data.

Cc: stable@kernel.org
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1644eab..b873156 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2064,6 +2064,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_82XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla82xx_isp_ops;
 		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
-- 
1.6.0.2

