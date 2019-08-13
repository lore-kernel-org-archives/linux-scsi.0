Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE60C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 501E82070D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfHMVDO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 17:03:14 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:37784 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbfHMVDN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 17:03:13 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Tue, 13 Aug 2019 21:02:42 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 13 Aug 2019 20:31:08 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 13 Aug 2019 20:31:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShX6k/Fuz6I3juxX5mJ+sfR+JlaJ5jvSMOQAzY9EuvuTIXF8FNQbyef3cw2xWlRdSDzuKo0UARZT3qHZzgAunYqWVmF/3yw8U26iqeWmn/NNLRzMappnBCV8FUMANC6NQLmW1YlGDINjxPA/YxpUKqa2jjSmXyLMgS19UnFTNILyhDvJMslh2hfd3JB0TAVrzVaccBNRLBF/InyfG1bdYslAzvBR/a0o73ZkUZuwY6jkZfU2fT/wMP8Xhs9bJGwuWcXO9EnbAvC6uB9yBywfi6PHQgau7wMzIIzzO7QEQbZ4ldAJCWNbqaaggHWSGuWC3LaOoABbA116V7hX8McF/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCqLD57xO0gflcJfrVOgLuxP4FR6U+XweOaYdp1Vn+M=;
 b=DZ0QSLSWcKPWAV8gLudpP96wvaUkGAne9pGUMSXyjuvWRbfMt5YriNgBHW+teGgbzNOUZzrB9R7sISkvnuK6Npp/rRHtjFdBxUyy+5NROHvwXQTlqsm4g+CTni1qNJgWql91GUTdSZo2e3HXFK0FbU7yerx2GWBte3P2s0RfJrwGM0q8WKEg3xq3jEBq7IK/817zqQWWMEXQPTV2/1Do1a42WIy8XYKV2WXbrVhiwQ0DAyHhIxKc4gJthfADA9EXI4PCPQ5c7PgGeOfdL9zCA6/9Xy+/Le3czR0lnG4sn8v8WpxDkHdm8Iu4tp/1stBe6pI2Aie53mDUNbnidSRtKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3430.namprd18.prod.outlook.com (52.132.246.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 13 Aug 2019 20:31:08 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 20:31:07 +0000
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
Subject: [PATCH 1/3] scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
Thread-Topic: [PATCH 1/3] scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
Thread-Index: AQHVUhYJzKIvwNb7KkmQp5i87fb5BQ==
Date:   Tue, 13 Aug 2019 20:31:07 +0000
Message-ID: <20190813203034.7354-2-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: e259d88d-f6f1-4cfd-be0f-08d7202d2b79
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3430;
x-ms-traffictypediagnostic: CH2PR18MB3430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3430E46F3EB53D52AFCC33CAFCD20@CH2PR18MB3430.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(71190400001)(53936002)(478600001)(64756008)(110136005)(71200400001)(66476007)(81156014)(66556008)(6486002)(81166006)(5660300002)(50226002)(54906003)(66446008)(316002)(99286004)(6512007)(6436002)(8936002)(66946007)(2906002)(86362001)(36756003)(4326008)(26005)(102836004)(186003)(4744005)(305945005)(14454004)(7736002)(256004)(25786009)(386003)(8676002)(66066001)(3846002)(6116002)(52116002)(76176011)(11346002)(2616005)(486006)(44832011)(1076003)(476003)(446003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3430;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CMo1Q3/CrRWoaMKg8KFlvyxQvmjlWPavNayjC8tg4OoJMyF70B03elgtFNAlAKjm23WxBaZNhEm6TX9OQe3r2dv8W3r6sq+K125Jh5tdEvyiCfvqLSl/p/aNTsVM9I9EX3VO5tATa2MIjJ1nYZqLD3+nSpOg5x2iBzqWk27De4lFwSuP9yk5LiYnOPsVZ4YCsl5aMwvA1dpqbSUdpBDXJvH/d3rtAHRs/3ePtoJwhYKCiejeU5ZYKCaO/edbyirlxgxSZsjSc2ViEQy5pCqsOVhRSIoJ+XUwAVbUxvWSqXKcGMwt1y8wHz968zOFO8RHE70R7ctGj02QE1/Bw+cPl72YncD9O2pWguZu5tIROSZcVVr5sbBkVXg2JH93XGSx/uPu/md2tb5Xd/CGtlZhn7HLPw5+5ScZy1cMCoGj/nU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e259d88d-f6f1-4cfd-be0f-08d7202d2b79
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 20:31:07.6197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rDHPP97Qc/etlopXTwXpYFR3XidMnsCjfOWTiPCVAJyusmRKSocbIKkyJpNbDXyEGdaWq5ARt2rqpIkO5sdYEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3430
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

