Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B33FC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C5722CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393280AbfHVUjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:39:15 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2837 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfHVUjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:39:14 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: AAwQHPwXqa5EtvbDX2o/cOF8O+ukugGrXgbZANgK92U3Axnq8Xjnh2yM66/Q8h065lXeE0aatC
 hR0QLint7ZkK3PXuQv7VdAAvV7pW9UeJ6/mTTqde3cT1mylVV7lpBL2wXPC4xH3T20a4HXsJPT
 D8Q/dpm3zooblioD+NP1s58lvU5THFqbBGGrb019briyI9LIOgGje2n6luz2SXgzMXjDgwirrW
 J9EC3cK9s/h+Gd6M3OwjXHxfg2fjMiruveCxQD+3E2F3IEj6xHcptj4Qh/VBcEGSvg/J2G8es/
 WhA=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="44671290"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:39:15 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:13 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:12 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:39:11 -0700
Subject: [PATCH 03/11] smartpqi: add module param to hide vsep
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:39:11 -0500
Message-ID: <156650635154.18562.18077859759860566934.stgit@brunhilda>
In-Reply-To: <156650628375.18562.9889154437665249418.stgit@brunhilda>
References: <156650628375.18562.9889154437665249418.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dave Carroll <david.carroll@microsemi.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 +
 drivers/scsi/smartpqi/smartpqi_init.c |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e8e768849c70..0a629f2f447a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -822,6 +822,7 @@ union pqi_reset_register {
 #define PQI_HBA_BUS			2
 #define PQI_EXTERNAL_RAID_VOLUME_BUS	3
 #define PQI_MAX_BUS			PQI_EXTERNAL_RAID_VOLUME_BUS
+#define PQI_VSEP_CISS_BTL		379
 
 struct report_lun_header {
 	__be32	list_length;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fa6403b2741c..f289fbd4220d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -151,6 +151,12 @@ module_param_named(expose_ld_first,
 MODULE_PARM_DESC(expose_ld_first,
 	"Expose logical drives before physical drives.");
 
+static int pqi_hide_vsep;
+module_param_named(hide_vsep,
+	pqi_hide_vsep, int, 0644);
+MODULE_PARM_DESC(hide_vsep,
+	"Hide the virtual SEP for direct attached drives.");
+
 static char *raid_levels[] = {
 	"RAID-0",
 	"RAID-4",
@@ -1951,6 +1957,11 @@ static inline bool pqi_skip_device(u8 *scsi3addr)
 	return false;
 }
 
+static inline void pqi_mask_device(u8 *scsi3addr)
+{
+	scsi3addr[3] |= 0xc0;
+}
+
 static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 {
 	if (!device->is_physical_device)
@@ -2031,6 +2042,21 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			rc = -ENOMEM;
 			goto out;
 		}
+		if (pqi_hide_vsep) {
+			int i;
+
+			for (i = num_physicals - 1; i >= 0; i--) {
+				phys_lun_ext_entry =
+						&physdev_list->lun_entries[i];
+				if (CISS_GET_DRIVE_NUMBER(
+					phys_lun_ext_entry->lunid) ==
+						PQI_VSEP_CISS_BTL) {
+					pqi_mask_device(
+						phys_lun_ext_entry->lunid);
+					break;
+				}
+			}
+		}
 	}
 
 	num_new_devices = num_physicals + num_logicals;

