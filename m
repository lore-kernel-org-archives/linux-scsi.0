Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F5CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiBAVsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30982 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiBAVsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752100; x=1675288100;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X4YzdE4/1rrDmkaBXykXhh9Uw+FgtDBcnrsOX8pyx8Y=;
  b=tEVQbdso9aTHlAJxj5QJDfEb8xvBZUKEB4pkjTz+HfbNNy4Os1Tw2S3w
   5bsr7VJSNLj/mzUqMm8QgLzixryOjsk6BChvhDcFOgWLRp2pEHbusedrC
   oZ3hko0Y3WTbr1N5uzHebTkrplZsB+0X9l+ZT+X98WIPYb8R3yRVrvddx
   EXQn3QyoWHuH+3MEhtoQhYB/cGQSIAQNeIZOxBmHHiCvUH5h6ZbEjripk
   2qIhRwDhFhbVwtD8ptAbGL+2/cEGcZrSX6DPDpoT2i/+ecTnzLfLoNpSN
   JfHpsCv5U1/ppf6+V1Mq1ad2PeJ05q3V3Pt0Ht9fAToPLf6Naq1bFJBU3
   g==;
IronPort-SDR: iaFQUVlZ0Fn+YEU9VpVF6hjztFx4DYAZGAgG4F/2Ti8vmZDV1yx+6FDCI0RT9Epmv1ff1jstjU
 LFXkWzmYPpAVDB1ptfdXkCkpx1qotISo8S3OsvotQDeVrTn9nPk5BEPqg8dPGTBpCfbW6CAmAa
 Il5eamG9qY1B+R8uoerMf4X/7BcI1dl5jSPdjcADY40Yw7IG0YTPKB92RNjvzIJ7BDRJhVxnw3
 eG5TbuGVSe2sJQwnsJjkSU6XRIinuzyuyqvY0i4LuxTdhAp4bH+kLfCbs+LkSmR2owmd8F/6Jn
 Ap3Z2Va7TvPiWvSbztnn2kVf
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639069"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:18 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:18 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 3399670236E;
        Tue,  1 Feb 2022 15:48:18 -0600 (CST)
Subject: [PATCH 06/18] smartpqi: fix a name typo and cleanup code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:18 -0600
Message-ID: <164375209818.440833.10908948825731635853.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Rename the function pqi_is_io_high_priority() to
pqi_is_io_high_priority(), removed 2 unnecessary lines from the
function, and adjusted the white space.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9bc2987e280f..8ff38e3ecd09 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5581,18 +5581,19 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	pqi_scsi_done(scmd);
 }
 
-static inline bool pqi_is_io_high_prioity(struct pqi_ctrl_info *ctrl_info,
+static inline bool pqi_is_io_high_priority(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd)
 {
 	bool io_high_prio;
 	int priority_class;
 
 	io_high_prio = false;
+
 	if (device->ncq_prio_enable) {
 		priority_class =
 			IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
 		if (priority_class == IOPRIO_CLASS_RT) {
-			/* set NCQ priority for read/write command */
+			/* Set NCQ priority for read/write commands. */
 			switch (scmd->cmnd[0]) {
 			case WRITE_16:
 			case READ_16:
@@ -5604,8 +5605,6 @@ static inline bool pqi_is_io_high_prioity(struct pqi_ctrl_info *ctrl_info,
 			case READ_6:
 				io_high_prio = true;
 				break;
-			default:
-				break;
 			}
 		}
 	}
@@ -5619,7 +5618,8 @@ static inline int pqi_aio_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 {
 	bool io_high_prio;
 
-	io_high_prio = pqi_is_io_high_prioity(ctrl_info, device, scmd);
+	io_high_prio = pqi_is_io_high_priority(ctrl_info, device, scmd);
+
 	return pqi_aio_submit_io(ctrl_info, scmd, device->aio_handle,
 		scmd->cmnd, scmd->cmd_len, queue_group, NULL,
 		false, io_high_prio);


