From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/11]   qla2xxx: Tx/Rx Sensitivity additions
Date: Wed, 8 Dec 2004 23:33:38 -0800
Message-ID: <20041209073338.GA22071@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:10735 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261472AbULIHdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:33:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2236 04/12/08 13:56:26 andrew.vasquez@qlogic.com +2 -0
  Add support for new transmit/receive sensitivity settings when
  updating an ISPs serial-link options.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h  |   25 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_init.c |   59 ++++++++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 17 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:12:38 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:12:38 -08:00
@@ -1026,9 +1026,27 @@
 	uint8_t	 special_options[2];
 
 	/* Reserved for expanded RISC parameter block */
-	uint8_t reserved_2[24];
+	uint8_t reserved_2[22];
 
 	/*
+	 * LSB BIT 0 = Tx Sensitivity 1G bit 0
+	 * LSB BIT 1 = Tx Sensitivity 1G bit 1
+	 * LSB BIT 2 = Tx Sensitivity 1G bit 2
+	 * LSB BIT 3 = Tx Sensitivity 1G bit 3
+	 * LSB BIT 4 = Rx Sensitivity 1G bit 0
+	 * LSB BIT 5 = Rx Sensitivity 1G bit 1
+	 * LSB BIT 6 = Rx Sensitivity 1G bit 2
+	 * LSB BIT 7 = Rx Sensitivity 1G bit 3
+	 *            
+	 * MSB BIT 0 = Tx Sensitivity 2G bit 0
+	 * MSB BIT 1 = Tx Sensitivity 2G bit 1
+	 * MSB BIT 2 = Tx Sensitivity 2G bit 2
+	 * MSB BIT 3 = Tx Sensitivity 2G bit 3
+	 * MSB BIT 4 = Rx Sensitivity 2G bit 0
+	 * MSB BIT 5 = Rx Sensitivity 2G bit 1
+	 * MSB BIT 6 = Rx Sensitivity 2G bit 2
+	 * MSB BIT 7 = Rx Sensitivity 2G bit 3
+	 *
 	 * LSB BIT 0 = Output Swing 1G bit 0
 	 * LSB BIT 1 = Output Swing 1G bit 1
 	 * LSB BIT 2 = Output Swing 1G bit 2
@@ -1047,7 +1065,7 @@
 	 * MSB BIT 6 =
 	 * MSB BIT 7 =
 	 */
-	uint8_t seriallink_options[2];
+	uint8_t seriallink_options[4];
 
 	/*
 	 * NVRAM host parameter block
@@ -2070,6 +2088,7 @@
 		uint32_t	enable_lip_reset	:1;
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_target_reset	:1;
+		uint32_t	enable_led_scheme	:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -2347,7 +2366,7 @@
 	uint32_t	fw_transfer_size;
 
 	uint16_t	fw_options[16];		/* slots: 1,2,3,10,11 */
-	uint8_t		fw_seriallink_options[2];
+	uint8_t		fw_seriallink_options[4];
 
 	/* Firmware dump information. */
 	void		*fw_dump;
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:12:38 -08:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:12:38 -08:00
@@ -828,7 +828,7 @@
 static void
 qla2x00_update_fw_options(scsi_qla_host_t *ha)
 {
-	uint16_t swing, emphasis;
+	uint16_t swing, emphasis, tx_sens, rx_sens;
 
 	memset(ha->fw_options, 0, sizeof(ha->fw_options));
 	qla2x00_get_fw_options(ha, ha->fw_options);
@@ -843,24 +843,54 @@
 	    sizeof(ha->fw_seriallink_options)));
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
-	if (ha->fw_seriallink_options[1] & BIT_2)
+	if (ha->fw_seriallink_options[3] & BIT_2) {
 		ha->fw_options[1] |= FO1_SET_EMPHASIS_SWING;
 
-	/*  1G settings */
-	swing = ha->fw_seriallink_options[0] & (BIT_2 | BIT_1 | BIT_0);
-	emphasis = ha->fw_seriallink_options[0] & (BIT_4 | BIT_3);
-	emphasis >>= 3;
-	ha->fw_options[10] = (emphasis << 14) | (swing << 8) | 0x3;
-	/*  2G settings */
-	swing = ha->fw_seriallink_options[0] & (BIT_7 | BIT_6 | BIT_5);
-	swing >>= 5;
-	emphasis = ha->fw_seriallink_options[1] & (BIT_1 | BIT_0);
-	ha->fw_options[11] = (emphasis << 14) | (swing << 8) | 0x3;
+		/*  1G settings */
+		swing = ha->fw_seriallink_options[2] & (BIT_2 | BIT_1 | BIT_0);
+		emphasis = (ha->fw_seriallink_options[2] &
+		    (BIT_4 | BIT_3)) >> 3;
+		tx_sens = ha->fw_seriallink_options[0] &
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0); 
+		rx_sens = (ha->fw_seriallink_options[0] &
+		    (BIT_7 | BIT_6 | BIT_5 | BIT_4)) >> 4;
+		ha->fw_options[10] = (emphasis << 14) | (swing << 8);
+		if (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA6312(ha)) {
+			if (rx_sens == 0x0)
+				rx_sens = 0x3;
+			ha->fw_options[10] |= (tx_sens << 4) | rx_sens;
+		} else if (IS_QLA2322(ha) || IS_QLA6322(ha))
+			ha->fw_options[10] |= BIT_5 |
+			    ((rx_sens & (BIT_1 | BIT_0)) << 2) |
+			    (tx_sens & (BIT_1 | BIT_0));
+
+		/*  2G settings */
+		swing = (ha->fw_seriallink_options[2] &
+		    (BIT_7 | BIT_6 | BIT_5)) >> 5;
+		emphasis = ha->fw_seriallink_options[3] & (BIT_1 | BIT_0);
+		tx_sens = ha->fw_seriallink_options[1] &
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0); 
+		rx_sens = (ha->fw_seriallink_options[1] &
+		    (BIT_7 | BIT_6 | BIT_5 | BIT_4)) >> 4;
+		ha->fw_options[11] = (emphasis << 14) | (swing << 8);
+		if (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA6312(ha)) {
+			if (rx_sens == 0x0)
+				rx_sens = 0x3;
+			ha->fw_options[11] |= (tx_sens << 4) | rx_sens;
+		} else if (IS_QLA2322(ha) || IS_QLA6322(ha))
+			ha->fw_options[11] |= BIT_5 |
+			    ((rx_sens & (BIT_1 | BIT_0)) << 2) |
+			    (tx_sens & (BIT_1 | BIT_0));
+	}
 
 	/* FCP2 options. */
 	/*  Return command IOCBs without waiting for an ABTS to complete. */
 	ha->fw_options[3] |= BIT_13;
 
+	/* LED scheme. */
+	if (ha->flags.enable_led_scheme)
+		ha->fw_options[2] |= BIT_12;
+
 	/* Update firmware options. */
 	qla2x00_set_fw_options(ha, ha->fw_options);
 }
@@ -1369,12 +1399,13 @@
 	ha->flags.enable_lip_reset = ((nv->host_p[1] & BIT_1) ? 1 : 0);
 	ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
 	ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);
+	ha->flags.enable_led_scheme = ((nv->efi_parameters & BIT_3) ? 1 : 0);
 
 	ha->operating_mode =
 	    (icb->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) >> 4;
 
-	ha->fw_seriallink_options[0] = nv->seriallink_options[0];
-	ha->fw_seriallink_options[1] = nv->seriallink_options[1];
+	memcpy(ha->fw_seriallink_options, nv->seriallink_options,
+	    sizeof(ha->fw_seriallink_options));
 
 	/* save HBA serial number */
 	ha->serial0 = icb->port_name[5];
