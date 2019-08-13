Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42276C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1574520665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHMUhV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:37:21 -0400
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:50525 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfHMUhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 16:37:21 -0400
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Tue, 13 Aug 2019 20:37:02 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 13 Aug 2019 20:31:12 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 13 Aug 2019 20:31:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdgsFHg9WRHMk+AgkgKpNJcuRF5XPPngxAqoOlXb97mCASA94Tmx4P5xB+54AVz5MjnQqPD+J1gB7rGaQCLQJuWQ8p4MeJm6PGy/vakJ1hBp33mjpwjPWlJKL6on3DmmMPqPprx3NZhOT83ifbM8gv0MqjDw3cTjw3Xn923DsQ3gSX3OAdnqZqzwa8NGznI8gkHIu4GWXYIZF2YSNGfu6om/Wd2ZGuIABnSL1fkNQzXksJ+vX2JuscnhdCEEa/vdTGXyUSgIy7L/tqvgMNmDY0LiBNCZhPf20Xe7ASWJuB2CpXWrdWuEzHjaX/nzOlqj2FE3mhbkzKg+UvJCQ1O8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMHFgC4KW17yYRwGJ640+STAc88qOecdj36EZ26KSi8=;
 b=FPmnrZEnndmETR6tcPC4i/np0mLiwacaEVP8P1u3ESDX9DS7LsfQ+9JLOqMP7NzrR1GBre5p1bqhTgkN2XMbXOTbUJgwkChPkKdvU5hnG/HwbEIraa7K5EqJPl5Vn3VKFQPA1sJsrkLH83HDDytXJt8CdKhGJel90gUWJ4ZJB0oogqN78k74qzr/cdwQel/2E+o5rb1QukjB+wt+IvIh4K7F0rXbqu6RRIrrYkfYQLcnL91uWFOcHmlZVpeP9Dht8HK8pBGLNeOHmyk8oaKUV50viETuEMa1R0/9OHabo8EYNT40rDdi4yp2EMZu0SsxIhLkkIstWi/nhfS4xgPIEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3366.namprd18.prod.outlook.com (52.132.246.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Tue, 13 Aug 2019 20:31:10 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 20:31:10 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Topic: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Index: AQHVUhYKQMcVI/ohF0qhHmiduV8LJg==
Date:   Tue, 13 Aug 2019 20:31:10 +0000
Message-ID: <20190813203034.7354-3-martin.wilck@suse.com>
References: <20190813203034.7354-1-martin.wilck@suse.com>
In-Reply-To: <20190813203034.7354-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0502CA0012.eurprd05.prod.outlook.com
 (2603:10a6:209:1::25) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:2c::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0251b7b9-c137-49aa-e7a9-08d7202d2d22
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3366;
x-ms-traffictypediagnostic: CH2PR18MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3366F53240C7B0C80D89EA19FCD20@CH2PR18MB3366.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(71190400001)(6436002)(8936002)(54906003)(110136005)(76176011)(2906002)(66066001)(52116002)(50226002)(71200400001)(316002)(81156014)(81166006)(4326008)(14444005)(5660300002)(6486002)(256004)(25786009)(3846002)(7736002)(1076003)(26005)(8676002)(6512007)(478600001)(53936002)(6116002)(486006)(2616005)(186003)(11346002)(14454004)(305945005)(446003)(44832011)(36756003)(66556008)(64756008)(386003)(6506007)(66946007)(66446008)(102836004)(66476007)(99286004)(476003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3366;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: heIaxqtK0Wbhqw1bjnwYkOYaoVf+igJy12Ln88DnKuVPUKdJHAkdX9Yakj/TKARVyGl8E+uL/k4kLD4t+o+eV1HuifKnRFIvOQna2HzsMdhkMN5q3MkoDWOe3KH1+FbDJIgXog4oOCzF2SyikLt5oGCGS+SKVuUSscjD/mqV73Z/EPRQ1NqaVUFgHOoz2lmxayAPWr3/MtxqUU0vgnz20oKLTOmwUHRlsJSPcIrMqghchxYd+qARqXpqIiK0qmFRav22TvcIaQAF9GxIKTMXJk6+HCXnAi0WB0YMlC9V7Eovt69aEWDzxRZsaFOO/XlCstwhF8croxqRcGV0sFR2xs+QFA9x9YoIgz74kOxnsjdWf/gjn/FUFdO6hu/jqh4AzHRyHV648gvtg9M3zWF8JUzZvS0mmTN6E/0E0+eHb0I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0251b7b9-c137-49aa-e7a9-08d7202d2d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 20:31:10.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gH3WJjrP3jMeBVMjYDEylxdD7uFEo9aat8Vvx8YiDdN0mZfsoHxFJXCUHz6NmlMLiepA+JCH7se9RzxfqO8YNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3366
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Reset ha->rce, ha->eft and the respective dma fields if
the buffers aren't mapped for some reason. Also, treat
both failure cases (allocation and initialization failure)
equally. The next patch modifies the failure behavior
slightly again.

Fixes: ad0a0b01f088 "scsi: qla2xxx: Fix Firmware dump size for Extended
 login and Exchange Offload"
Fixes: a28d9e4ef997 "scsi: qla2xxx: Add support for multiple fwdump
 templates/segments"
Cc: Joe Carnuccio <joe.carnuccio@cavium.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6dd68be..ca9c3f3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3063,6 +3063,8 @@ qla2x00_alloc_offload_mem(scsi_qla_host_t *vha)
 			ql_log(ql_log_warn, vha, 0x00be,
 			    "Unable to allocate (%d KB) for FCE.\n",
 			    FCE_SIZE / 1024);
+			ha->fce_dma = 0;
+			ha->fce = NULL;
 			goto try_eft;
 		}
 
@@ -3111,9 +3113,12 @@ qla2x00_alloc_offload_mem(scsi_qla_host_t *vha)
 
 		ha->eft_dma = tc_dma;
 		ha->eft = tc;
+		return;
 	}
 
 eft_err:
+	ha->eft = NULL;
+	ha->eft_dma = 0;
 	return;
 }
 
@@ -3184,6 +3189,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			ql_log(ql_log_warn, vha, 0x00c1,
 			    "Unable to allocate (%d KB) for EFT.\n",
 			    EFT_SIZE / 1024);
+			ha->eft = NULL;
+			ha->eft_dma = 0;
 			goto allocate;
 		}
 
@@ -3193,6 +3200,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    "Unable to initialize EFT (%d).\n", rval);
 			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
 			    tc_dma);
+			ha->eft = NULL;
+			ha->eft_dma = 0;
+			goto allocate;
 		}
 		ql_dbg(ql_dbg_init, vha, 0x00c3,
 		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
-- 
2.22.0

