Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F15C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644D261131
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhDOQmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 12:42:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35185 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhDOQme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 12:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618504931; x=1650040931;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GTfYrhKWL41NMQiEJF1rW9zEeEgg35gHt7dayYoGId0=;
  b=uXZLZvXqAUiPIK/k6SumBlWczwVEhHy9D0fFhOZcaNJbp0WNNUukhlCf
   pru/WRi5GX43eaLxpH80gBy4N9K6tqlgWRtSGgRQrAs5BI5gCboavsC1o
   9CF0cEaF0xkWD6ST6mWQkdg+ZMt8oqya41KUxoyb/N6nyMEMfIjO4G28h
   cI9B2qP027TFtI1MGsrdrYbEq9eZaiFIUddiAlcy/YFmIDP8DyONXTp7r
   xUCxQhkehWKqRitSqLzJepwu4L7TPTxyZ+55lLATEa/nmq5+61GMW84bw
   hckecyuPx8ylDBpFARzlvEK+z37V9RTUYVHiANGLtP0q6HF0vKcPjxLse
   g==;
IronPort-SDR: Cj1PA4e/1Ruzw8sqyKiTJQ9lxBbBCK/1hrPVY8TMsiJaKCGONchWK6a20AHXOfjUiz4n7tpBj3
 Uvm2DibrYVp5/XCP54HDdDAk9sCjvOvhHM8tACM6B3FLJxtxXTFXilP88ukotfzSP5TAOjJlP1
 AX6GA3g5M86ZzsuWz9fImlyIg2kOeZ6G3Kiwf6zKJt/kA2tGqHia83pqHehVBQnEvAKIfxc6pA
 fltI13JfZsl81vc8Tae+/8fSNehmbIslSbWua5UdxhogsygoZhjtylQXuT0+BTglRmqbnY01YP
 QAE=
X-IronPort-AV: E=Sophos;i="5.82,225,1613458800"; 
   d="scan'208";a="117169999"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 09:42:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 09:42:10 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 09:42:10 -0700
Subject: [PATCH 2/2] smartpqi: fix device pointer variable reference static
 checker issue
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 15 Apr 2021 11:42:10 -0500
Message-ID: <161850493026.7302.10032784239320437353.stgit@brunhilda>
In-Reply-To: <161850488487.7302.7018870513204678832.stgit@brunhilda>
References: <161850488487.7302.7018870513204678832.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dan Carpenter found a possible NULL pointer dereference issue
in function pqi_sas_port_add_rphy.

Link: ("https://www.mail-archive.com/kbuild@lists.01.org/msg06329.html")
Fixes: ec504b23df9d ("[304/324] scsi: smartpqi: Add phy ID support for the physical drives")
   drivers/scsi/smartpqi/smartpqi_sas_transport.c:97
   pqi_sas_port_add_rphy() warn: variable dereferenced before
   check 'pqi_sas_port->device' (see line 95)

Correct issue by moving reference of pqi_sas_port->device after
the check for the device pointer being non-NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

