Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACC9C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E8D22CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbfHVUjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:39:02 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33115 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfHVUjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:39:01 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: zhA2hE/1OwBjp3XchqFT5B3w7VxUe0XLNGjdV5423tAfrWXyDRKNU6n4qVC8iGQsYP+nupW5/x
 XdKCMhwlXZNGnD7syJCbEPEHphFw/G9D+SHGU4kXWIpaF+IE7FCYGL/c9BHNI4JC7M0pLIaML7
 F4GMK9QypySl1+LAiMSiibQb8UPAk1599kE8KxBU876w+sFZYi0eNOF5MEYKIbNNaIB6shckhZ
 2CoRCsLnBgWK3BCUC5Xb/utXL7tP/dmxZbd3Zt6r9WaLRtb1boLogQp4OVidAGYSreYtXl/fbW
 Isw=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="43343436"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:39:01 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:00 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:38:59 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:38:58 -0700
Subject: [PATCH 01/11] smartpqi: add module param for exposure order
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:38:58 -0500
Message-ID: <156650633839.18562.15898289347764484542.stgit@brunhilda>
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

From: Gilbert Wu <gilbert.wu@microsemi.com>

- expose physical devices before logical devices

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Gilbert Wu <gilbert.wu@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8fd5ffc55792..4324234aa26c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -145,6 +145,12 @@ MODULE_PARM_DESC(lockup_action, "Action to take when controller locked up.\n"
 	"\t\tSupported: none, reboot, panic\n"
 	"\t\tDefault: none");
 
+static int pqi_expose_ld_first;
+module_param_named(expose_ld_first,
+	pqi_expose_ld_first, int, 0644);
+MODULE_PARM_DESC(expose_ld_first,
+	"Expose logical drives before physical drives.");
+
 static char *raid_levels[] = {
 	"RAID-0",
 	"RAID-4",
@@ -1988,6 +1994,8 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	unsigned int num_valid_devices;
 	bool is_physical_device;
 	u8 *scsi3addr;
+	unsigned int physical_index;
+	unsigned int logical_index;
 	static char *out_of_memory_msg =
 		"failed to allocate memory, device discovery stopped";
 
@@ -2050,19 +2058,23 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 	device = NULL;
 	num_valid_devices = 0;
+	physical_index = 0;
+	logical_index = 0;
 
 	for (i = 0; i < num_new_devices; i++) {
 
-		if (i < num_physicals) {
+		if ((!pqi_expose_ld_first && i < num_physicals) ||
+			(pqi_expose_ld_first && i >= num_logicals)) {
 			is_physical_device = true;
-			phys_lun_ext_entry = &physdev_list->lun_entries[i];
+			phys_lun_ext_entry =
+				&physdev_list->lun_entries[physical_index++];
 			log_lun_ext_entry = NULL;
 			scsi3addr = phys_lun_ext_entry->lunid;
 		} else {
 			is_physical_device = false;
 			phys_lun_ext_entry = NULL;
 			log_lun_ext_entry =
-				&logdev_list->lun_entries[i - num_physicals];
+				&logdev_list->lun_entries[logical_index++];
 			scsi3addr = log_lun_ext_entry->lunid;
 		}
 

