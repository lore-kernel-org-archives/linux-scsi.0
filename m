Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9319FC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9DA2083B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfHNNqM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:46:12 -0400
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:42777 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfHNNqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 09:46:11 -0400
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.190) BY m9a0001g.houston.softwaregrp.com WITH ESMTP;
 Wed, 14 Aug 2019 13:45:41 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 14 Aug 2019 13:28:30 +0000
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 14 Aug 2019 13:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VINxuKmyM95KZesJ+m0kS5SDLJzAinyzHYhjv5Ntpz1rFPNuDEcyBtMBurEfdMrjL9bMy6MYcUs+ud15fiPIO7TLSmbs7otuqWipmstNhXOqxAkiwiMHNDW9Q7FqshzDpllq2mRHXWrI43fzYH1fHyjMAzXcj28McasqscC9lAVuox0q6TI+YGPxr0gDl6hO7sOsAxned4JpGT8swfP+m//m5qLHXrIZYbRH1RCjcrGtD2hfXDJF8ZhdH2O9jRK/3CV4ODHVYKjx9PaU6jeolizA540dnlZGu+gx9DNi4dHARmlg610SH+fT3OUZAF3RgQAy/OyY/UyPEWfbat9tMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m71KdWdzaW2E0tdR+/m5viua0ygyrMJ2S8YJLwkAh48=;
 b=ACuuRHP/qPy5VPrKK4FEIS6EnSYWVtJNnB1qkVAXrgQlQyWB8s08Pcbv5HHsd9w7HfAP5XTTigk2MNiRcti6fm9xH8yZ/izgb0OCL+IeUbKitQDWWF8+HBc5VFFBmm4nNAY5eGRRs4mDHfQ6i9dH/dN+O42OjWuqXT7VZA5LwMih4lhxY9FpJRvmIP9CI8msiVAYc0Ysp0+WnUj3qBe/JYs+YU88fY0N/EQ6VbkmR0zIabrSvaqJ553pCxPgh3bEyeoE4hwbN0AZR5p23MGDMIf5Fkk3QDv87umPDhNUq7BJsGEaYvXplcAzak/mS3Mpc0cNCBQKF7Fnhm2UY16ZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3206.namprd18.prod.outlook.com (52.132.247.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 13:28:27 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 13:28:27 +0000
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
Subject: [PATCH v2 1/2] scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
Thread-Topic: [PATCH v2 1/2] scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
Thread-Index: AQHVUqQodv+8GsapekOlPP/akIT5Gw==
Date:   Wed, 14 Aug 2019 13:28:27 +0000
Message-ID: <20190814132642.5298-2-martin.wilck@suse.com>
References: <20190814132642.5298-1-martin.wilck@suse.com>
In-Reply-To: <20190814132642.5298-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0016.eurprd06.prod.outlook.com
 (2603:10a6:206:2::29) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:2c::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87c2c7cc-5499-4dd7-4d68-08d720bb4a4a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3206;
x-ms-traffictypediagnostic: CH2PR18MB3206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3206C6BF310870FCF7ECD603FCAD0@CH2PR18MB3206.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(6506007)(6116002)(53936002)(81156014)(1076003)(446003)(3846002)(2616005)(54906003)(11346002)(2906002)(8676002)(76176011)(476003)(25786009)(36756003)(186003)(6512007)(102836004)(4326008)(81166006)(99286004)(386003)(86362001)(256004)(52116002)(316002)(66446008)(66556008)(66946007)(6486002)(6436002)(110136005)(66476007)(50226002)(14454004)(5660300002)(8936002)(4744005)(66066001)(71200400001)(7736002)(305945005)(486006)(64756008)(26005)(478600001)(44832011)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3206;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Oggxmhvwh//jfgyqReaYOMyNdaZNdnCiH0WT/LeAROgKJrkWGUuMp+MkUsRhzTH6EueClqTnymDcq8iNLNpEVtkipWeLxC9ZZvs5dYiOuGhz90novWUFwOQkhmIFj6z7EFKbBl6MSmfBW+ZRikY+MI05J0PDPtYIjRUG9NfGGOFBRZfsu4b0OvV1tyO+GerJfEfHB0thtLdts/HnnJ/qopuzFx7aNi0BuNhFiXsGX5wAkcoss0z3Ktb/wm96UL1eAmU6sBO7mtaP/x5RCCI71/Tbyv4bgwFP+QPmygzuBPa7GZPz5ANOFObjK02q94BNivBrqzCPLGj0O+VPsyqWFLrw4iwR7s9bWvAVQWKSBL77BXYhyHJFjgNmZl5YTBu1frISSS+zg6HS7Ka1x69rq7j0dK1llwuXDDZd5WGXItk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c2c7cc-5499-4dd7-4d68-08d720bb4a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 13:28:27.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bg7N2EaGkTak2u0NaGghMXqpjwU6nSU7pICD6mNFvky1Ow1FYRocC+ilu/6Q/u5x7HzneNo/UtOdcrs5XCLGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3206
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

In qla2x00_alloc_fw_dump(), an existing EFT buffer (e.g. from
previous invocation of qla2x00_alloc_offload_mem()) is freed.
The buffer is then re-allocated, but without setting the eft and
eft_dma fields to the new values.

Fixes: a28d9e4ef997 "scsi: qla2xxx: Add support for multiple fwdump
templates/segments"
Cc: Joe Carnuccio <joe.carnuccio@cavium.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 535dc21..6dd68be 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3197,6 +3197,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_init, vha, 0x00c3,
 		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
 		eft_size = EFT_SIZE;
+		ha->eft_dma = tc_dma;
+		ha->eft = tc;
 	}
 
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-- 
2.22.0

