Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B96C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 20:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA4D216F4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 20:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK2UhF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 15:37:05 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:39161 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbfK2UhF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Nov 2019 15:37:05 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Fri, 29 Nov 2019 20:27:47 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 29 Nov 2019 20:26:37 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 29 Nov 2019 20:26:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkgCJkq1sO6yZfHFXSksuSJXWv2dIHNtHBGU7PgiEwv4a+rec3fjbbZn5qELd0AaH2niEwhC6Oa/W8QzdFE6Gs8ruI2l4u6zJkkLyqyLs534kplEZa98OGnfYmxRjg7UaCqBiTYiKq0iMkTaFyMO7q6CZ+isLdY/P5RgJz4J95YL0tUWRo9g6u3du4lUG8FgIYMQCtq6OdiZbQBmnBJdz2MB1AYYI1udiNcb3Kk17r/+cUnYCGpnI126375v+f12uQiDtx2C3V7q50WB52om8pPf7nIy+4k/8euRyUsV3w76Jwk10sBhlNyzxC3NdTL6gKX7WE+ELF/ECA4h59BOcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L++pxejJfA8ur7whHzu0w3nWaTMqUmlEL96pnkwGTVM=;
 b=apTJyQxN1jh3UcOgfqrhKNquVU7iKQhJKwcDAw5cGmpBX47LnrlKqkxHojtNcfrlCXn2UFX71088PNvK9kAZRfTV+IAROAfAoapMVW0gruQYnk+sk5XeXB8hC/8PUqODoGEm08kreJ122r7CnHeVzh2GBDMpQBGtzQT67ZV/PWx7s6k0kDvzlZJfgn4xIptMQK9v+XvFpmptYbELjcRwnbqs3LFVf4QPiOiafM+8mBT0+3LOpq1g18zQ5RKOWeMjtv+7fKz68Uo/ANNj3UWUeoJ1ALtlc5WpW/tR3/Hj+9R6Igh0gXydcgh3VtWTb9Hcer5v0gmq+DOnnfJ2XLfLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1644.namprd18.prod.outlook.com (10.175.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 29 Nov 2019 20:26:36 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c%12]) with mapi id 15.20.2495.014; Fri, 29 Nov
 2019 20:26:36 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before closing
 sessions
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before
 closing sessions
Thread-Index: AQHVpvNM3hsRz6i1LU6it9oHMBqteA==
Date:   Fri, 29 Nov 2019 20:26:36 +0000
Message-ID: <20191129202627.19624-2-martin.wilck@suse.com>
References: <20191129202627.19624-1-martin.wilck@suse.com>
In-Reply-To: <20191129202627.19624-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::32) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75accaee-9310-4ea8-5c21-08d7750a6e7e
x-ms-traffictypediagnostic: DM5PR18MB1644:|DM5PR18MB1644:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1644A55B94F214CBC4992FB9FC460@DM5PR18MB1644.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(189003)(199004)(6116002)(71190400001)(71200400001)(3846002)(4326008)(6512007)(6506007)(25786009)(64756008)(66446008)(305945005)(44832011)(7736002)(6436002)(6486002)(66556008)(66946007)(66476007)(386003)(8676002)(8936002)(14444005)(316002)(186003)(50226002)(99286004)(36756003)(5660300002)(11346002)(86362001)(81166006)(81156014)(1076003)(52116002)(76176011)(14454004)(102836004)(26005)(66066001)(446003)(110136005)(54906003)(2616005)(478600001)(256004)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1644;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppVzGAA2hfqdOgWlvfGvvrxxhozhRoALEg9Wje6oPMYwGBc5I9D/p/YT0zzVu2YybRt6M+iA9ebmwb9NDfjrLnLfUp+MqWBREUr6DUz0CI5I3d/A+Rvo3TMJJQPTKQu2LVpBcGyhaKZn0D90mgyfE/Vff35NFMdNHl4bAPtTVhoeR+oYpTXgAnbu/8binlfwdpYxlupx6q/rypGMipKoOkrowylmOdtMasp35SITNoINxPDiggTPLlU6NDq+0kWuBnm1KwCCHZ4KYn6QiZ0RL9q409qHjx59XPr0j+oWsHkHaRaUtk1hjHanF7hWRT1Mw/g+x1IT8Fdw2SsLia8C1QK/sfFbdGzm87qwfqcIZLF6eCkRJZQAP21maFfiC939bTyyGM4LTq5gA+Y4CGI8m5f8u8b37VV7anrjoRwIn/tOitDvGi/3r1bYKGj9dn9V
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75accaee-9310-4ea8-5c21-08d7750a6e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 20:26:36.3080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEwSf6ngLm5/QBIYV1n49jqLjNDzURzFhFkwp2DyQGqWms/pjnUxVc1Rihg4vhLqR4rGKWdR9d2fTmeqCynncQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1644
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Since 45235022da99, the firmware is shut down early in the controller
shutdown process. This causes commands sent to the firmware (such as LOGO)
to hang forever. Eventually one or more timeouts will be triggered.
Move the stopping of the firmware until after sessions have terminated.

Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 43d0aa0..0cc127d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3710,6 +3710,16 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	}
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	qla2x00_wait_for_sess_deletion(base_vha);
+
+	/*
+	 * if UNLOAD flag is already set, then continue unload,
+	 * where it was set first.
+	 */
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
+
+	set_bit(UNLOADING, &base_vha->dpc_flags);
 	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
 	    IS_QLA28XX(ha)) {
 		if (ha->flags.fw_started)
@@ -3726,17 +3736,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		qla2x00_try_to_stop_firmware(base_vha);
 	}
 
-	qla2x00_wait_for_sess_deletion(base_vha);
-
-	/*
-	 * if UNLOAD flag is already set, then continue unload,
-	 * where it was set first.
-	 */
-	if (test_bit(UNLOADING, &base_vha->dpc_flags))
-		return;
-
-	set_bit(UNLOADING, &base_vha->dpc_flags);
-
 	qla_nvme_delete(base_vha);
 
 	dma_free_coherent(&ha->pdev->dev,
-- 
2.24.0

