Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E55AC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134826124B
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhDOKYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:24:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23239 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhDOKYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618482260; x=1650018260;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=YgD2eXucJuPrvV6hqNCwZrD/PTHR8rTsYIEOcavzKQc=;
  b=vF3PnQ5fQ0qrOkjIghwbU+EuhzGZUx2EteX8K78I4vBqWBKr89HwIR+E
   RA2W1UVj7jG1fcg/zwij5Lj+8DpK/UqsZrNX3uH2JSHOJ5HZ8QPjC4daN
   n79dfrotQiRd+5nzDRd+JZ8jvf8Y70DHWB3ol5K/wBG3Eis//KvSm5zGT
   BFKVFaxUtcb6CX/AOl5btBE4lHgns9u6FDg3WCs4sTSgRFmlKTsU80uq+
   kKYGyphU52AmIKaF1HrXoW2+ufvGS6lRVPg/7+zxn+cRY0JhlZWMdQad4
   dbhZFpd9glTe8tp8idqDk6Wf+p6z6JZrJExBwsyoaOtDOnB9aUQnZZRv1
   g==;
IronPort-SDR: n8AgluUDpCrAGFyNodOkrcQnxiZW7U8nO7mrPXc0sNpPCLH74xLl2CWDuIOt30xN/pN1WgSvIx
 j7Cdd6KRXMwIHcUD2CdlcjLRqCm+fL7Amc0eVSIBWSQQTdjvheX+8wglODeuWsVNY2hrF9kXGr
 rYZ2AIoqq9gWHC2qgwUllrJrDviNXcIfpOwSLBkKI4D5n8H1+H2SK3ve+9R0pHVAGxO5l8MEZN
 Iq0UIjKKBThgGWspJJSosYpknRk6oal/8FIwc95zoNs2EBKn6bQBytaTAHhom4/CaWZx9qjD4g
 dXY=
X-IronPort-AV: E=Sophos;i="5.82,223,1613458800"; 
   d="scan'208";a="116548094"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 03:24:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 03:24:18 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 03:24:18 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/8] pm80xx updates
Date:   Thu, 15 Apr 2021 16:03:44 +0530
Message-ID: <20210415103352.3580-1-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set include some bug fixes and enhancements for pm80xx driver.

Changes from v3 to v4:
	- For sysfs attribute patches
		- Removed the unwanted variable 'c'
	- For "Add sysfs attribute to check mpi state" patch
		- split the ctl_mpi_state to two (ctl_mpi_state,
		ctl_hmi_error) as suggested.
		- Changed static char mpiStateText[] to
		static const char *const mpiStateText[]

Changes from v2 to v3:
	- For "Add sysfs attribute to check mpi state" patch
		- Fixed "warn: mask and shift to zero"
		- Made mpiStateText static, as suggested by buildbot

Changes from v1 to v2:
	- For sysfs attribute patches
		- Used sysfs_emit instead of sprintf for sysfs attribute patches.
		- Removed debug message for sysfs attribute patches.
	- For "Reset PI and CI memory during re-initialize" patch
		- Improved commit message.

Ruksar Devadi (1):
  pm80xx: Completing pending IO after fatal error

Vishakha Channapattan (5):
  pm80xx: Add sysfs attribute to check mpi state
  pm80xx: Add sysfs attribute to check controller hmi error
  pm80xx: Add sysfs attribute to track RAAE count
  pm80xx: Add sysfs attribute to track iop0 count
  pm80xx: Add sysfs attribute to track iop1 count

Viswas G (2):
  pm80xx: Reset PI and CI memory during re-initialize
  pm80xx: remove global lock from outbound queue processing

 drivers/scsi/pm8001/pm8001_ctl.c  | 121 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.c  |  68 +++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_hwi.h  |   1 +
 drivers/scsi/pm8001/pm8001_init.c |   9 ++-
 drivers/scsi/pm8001/pm8001_sas.c  |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c  |   7 ++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |   1 +
 8 files changed, 198 insertions(+), 13 deletions(-)

-- 
2.16.3

