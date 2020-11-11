Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F8CC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D0D2208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="leJ1ABuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgKKUYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 15:24:47 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2494 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 15:24:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605126286; x=1636662286;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JZmFey4VTyrg425p+Yq/NOszyFTMm1vadxAGXKIOoI4=;
  b=leJ1ABuzRA0BFjLcjnmEmwlix6ymmusVIwy5YQHbrDIfR+OQ4toGST8J
   w3Ou9oypS6oPm+yQM6btxvNIhM45Tm7iccLhyTJSML6lYHBDJ1WVhQjN2
   /VozQicUmi3oFX8c1vE/irNR+slQzWx0Cpq7LUW0VuaKjtVue8wob46NJ
   XX0PRo+WAk6Cdf3ssemeq4dj2fNYnZ28n5xBVOXXDtqGpKWGngR4RIUt1
   x28Dw3SLQrsNNY+jb1aSFkQQIQUhX3HfTxDJT0vsx89+xifmgcB2Ls/s0
   zPuBLFkDduPD9blNjNydN+eLVyKv4rB9JGF448B6sYQUURGCeJR2Nt18x
   Q==;
IronPort-SDR: +euQhbRwSTCxZT5gc90qPevjFpf+7AsRyQZ/WPGgmB6PGHtqXQodqSyhDqUsfP3/YRRKb0MoJL
 laHkME3Qtb7WVEERkQUAO1YXMuPbKYIJ6e3QR9b+hlnjeo6pg98dqh/YxoopBF7dhpEHf54I1T
 IMyqJxWRzAxs6An7vgKuDpfV9WRN/7aNN0r3OXO93+4ZBU7QlLq96a6QOlBBq/nQp4fD2ILw68
 ra76dMyYkgcqOVZqr6h+nukpXdDbCEErDpRIl+bY0fSGndSyEBWNfEGlPJL5QFf8Y8AHPrY8j1
 ZoI=
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="95973091"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 13:24:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 13:24:45 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 11 Nov 2020 13:24:45 -0700
Subject: [PATCH 2/3] smartpqi: correct pqi_sas_smp_handler busy condition
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 11 Nov 2020 14:24:45 -0600
Message-ID: <160512628513.2359.17193493825283879603.stgit@brunhilda>
In-Reply-To: <160512621964.2359.14416010917893813538.stgit@brunhilda>
References: <160512621964.2359.14416010917893813538.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Remove unbalanced call to pqi_ctrl_unbusy.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 999870eb9ed8..c9b00b3368d7 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -549,7 +549,6 @@ void pqi_sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	reslen = pqi_build_sas_smp_handler_reply(smp_buf, job, &error_info);
 out:
 	bsg_job_done(job, rc, reslen);
-	pqi_ctrl_unbusy(ctrl_info);
 }
 struct sas_function_template pqi_sas_transport_functions = {
 	.get_linkerrors = pqi_sas_get_linkerrors,

