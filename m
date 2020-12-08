Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6522BC35273
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F652388C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgLHUQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:16:42 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32392 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731413AbgLHUQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:16:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607458589; x=1638994589;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dXQ8pYLRO1zyvD6RqhWtKHHe6lZS5qU79pEoWv94rHI=;
  b=uQiIVFgVcUG5i2TRiqvOJ/uENCubhCcB7qeCjJDQXAD3jdw/zaeLfada
   de7FPktQLcBw0Sehtpb2i+Wga4TVNQvwrOnNxWvFVUm4Jt416Y+x4T3Sl
   uJnOFAeWvdyxB3ogNBScxNkrkHKm3S8EDmmsNcwORtznYW+IEKzJCXEOV
   9acUYi2kY/hZUc8M8sr7Q9VQH0oNbhy4cuHCtEAsE4XnFdBnH3+A1/mtM
   q/DOpkiWNMpylIY6mk/6w8KlrtI7tdhtsWnlO+qnYWennRCAztXIHhJaO
   E4w/hDFcNCR8Nf8dfE0xeI9YZXUslzHHcsmDFz3VCXzGshnHXpX7KNvuX
   g==;
IronPort-SDR: 5LBSJ8R4CK9aF0so9QrUxckBINFpSQOxi6i0bAX9wJSCVjnVN4SJrCAgHcuYWjXiAMv+RDFXdo
 Vp71XOVbwFSz1eoMOcQ3VtzSxitDfFWTQGjiEealukRLf4HNQMWhtR0Rag8ht7Y/LoZSPo3k90
 QqxhdUbdKP8jX5optCIci85ksoR/7xETsk1jm7seEj/KG3pZCgfuDop1W5j+wgGSkpc01d6o+I
 cq5DVhzBJ5luLi9COt0egEPcaBNibgzwzynZJrkeyrgyPpOA+QQvIC3Yv9SdKKDGaF6DjbyMlH
 dzc=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="101443255"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:37:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:37:51 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:37:50 -0700
Subject: [PATCH V2 13/25] smartpqi: disable write_same for nvme hba disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:37:50 -0600
Message-ID: <160745627072.13450.16070643484029851704.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Controller do not support SCSI WRITE SAME
  for NVMe drives in HBA mode

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b30067e79ce..767eb4882b13 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6274,10 +6274,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 			scsi_change_queue_depth(sdev,
 				device->advertised_queue_depth);
 		}
-		if (pqi_is_logical_device(device))
+		if (pqi_is_logical_device(device)) {
 			pqi_disable_write_same(sdev);
-		else
+		} else {
 			sdev->allow_restart = 1;
+			if (device->device_type == SA_DEVICE_TYPE_NVME)
+				pqi_disable_write_same(sdev);
+		}
 	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);

