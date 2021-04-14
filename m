Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7482C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 14:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EAEC610FC
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 14:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349887AbhDNOns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 10:43:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:33133 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349135AbhDNOns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 10:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618411406; x=1649947406;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CyAMtsY14RDxjiBN/4UAwxKDcM1wlX74W6P4/dmHl+U=;
  b=xF0kRHI8Vg90QhbAayVpg67FDIV6P/hsn1Bu2S6LnaYU6IMD+8qAS4FJ
   S61nGJm4j5YgO79asoZOsFFpsl4suLxCpvDQcPGcOAMI3mngUc+KU5Qln
   yMc2KTsh2yznGWY4QL3hjxAwdoL95Wuv1JqHL29Y5vod/CnFKfqGcWHmp
   hM8pBPIu7BgR6Bi6Hf3Jx5ahuBbmedv0joRBIiKDZPFiezUpmLDsvX6jk
   CJQSTgHkTXsR38XHqcBKqZKF60CQ0V8/z1SxUrlUW4ELd3diXB1kc0YdP
   irks2v+0lwG/0uInJ0vvzP1g8XNCEwO+0olAoXF//oFLP3TvgAgPc0Ucc
   g==;
IronPort-SDR: RIvXc5cYnFMHYqtnquk/97tHGqi9kl16j7Z71SrHLVvSFUOLFppxzaeUla8nmpLuZGy4BF5VlK
 GXCxt0Yhk1LGJM5ExgqKL45iMYvEMWRBcd+R1oHQb02hmp4u5IipGadJFiCFvcR3LUqlCxONDj
 DWjkCdW/J8mFujrJhy04cfwseeERaMc9UqEcjWtjR7lHMIQL8qAhnQu6O9u6hHkxVIrD2dM4xv
 aM9XvtcnDMkPdzOiuE9NsSfM/Zzys/TYgcEQ3FQSJ8jHT59N4dozgfSB2OOy7JUECBZ7pdN3GP
 1Rs=
X-IronPort-AV: E=Sophos;i="5.82,222,1613458800"; 
   d="scan'208";a="110787398"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2021 07:43:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 07:43:25 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Apr 2021 07:43:25 -0700
Subject: [PATCH] smartpqi: fix static checker warnings
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 14 Apr 2021 09:43:25 -0500
Message-ID: <161841140519.32218.437758761700546945.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dan Carpenter found two static checker issues in Martin Peterson's
git repo:
tree: ("https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git")
      5.13/scsi-queue

This patch fixes the two reported static checker warnings.

First Warning:
6702d2c40f31: ("scsi: smartpqi: Add support for RAID5 and
              RAID6 writes")
Using rmd->blocks_per_row as a divisor without checking
it for 0 first.
("https://marc.info/?l=linux-scsi&m=161795114128376&w=2")


Second Warning:
ec504b23df9d: ("[304/324] scsi: smartpqi: Add phy ID support
              for the physical drives")
drivers/scsi/smartpqi/smartpqi_sas_transport.c:97
pqi_sas_port_add_rphy() warn: variable dereferenced before
check 'pqi_sas_port->device' (see line 95)
("https://www.mail-archive.com/kbuild@lists.01.org/msg06329.html")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c          |    8 ++++++--
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b0f281daa2b..797ac699b7ff 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2510,6 +2510,8 @@ static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
 
 	/* Calculate stripe information for the request. */
 	rmd->blocks_per_row = rmd->data_disks_per_row * rmd->strip_size;
+	if (rmd->blocks_per_row == 0) /* Used as a divisor in many calculations */
+		return PQI_RAID_BYPASS_INELIGIBLE;
 #if BITS_PER_LONG == 32
 	tmpdiv = rmd->first_block;
 	do_div(tmpdiv, rmd->blocks_per_row);
@@ -2559,6 +2561,10 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 #if BITS_PER_LONG == 32
 	u64 tmpdiv;
 #endif
+
+	if (rmd->blocks_per_row == 0) /* Used as a divisor in many calculations */
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
 	/* RAID 50/60 */
 	/* Verify first and last block are in same RAID group. */
 	rmd->stripesize = rmd->blocks_per_row * rmd->layout_map_count;
@@ -2662,8 +2668,6 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 			rmd->q_parity_it_nexus = raid_map->disk_data[index + 1].aio_handle;
 			rmd->xor_mult = raid_map->disk_data[rmd->map_index].xor_mult[1];
 		}
-		if (rmd->blocks_per_row == 0)
-			return PQI_RAID_BYPASS_INELIGIBLE;
 #if BITS_PER_LONG == 32
 		tmpdiv = rmd->first_block;
 		do_div(tmpdiv, rmd->blocks_per_row);
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index dd9b784792ef..dd628cc87f78 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -92,12 +92,12 @@ static int pqi_sas_port_add_rphy(struct pqi_sas_port *pqi_sas_port,
 
 	identify = &rphy->identify;
 	identify->sas_address = pqi_sas_port->sas_address;
-	identify->phy_identifier = pqi_sas_port->device->phy_id;
 
 	identify->initiator_port_protocols = SAS_PROTOCOL_ALL;
 	identify->target_port_protocols = SAS_PROTOCOL_STP;
 
 	if (pqi_sas_port->device) {
+		identify->phy_identifier = pqi_sas_port->device->phy_id;
 		switch (pqi_sas_port->device->device_type) {
 		case SA_DEVICE_TYPE_SAS:
 		case SA_DEVICE_TYPE_SES:

