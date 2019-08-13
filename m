Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FACCC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70EC02070D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfHMVGl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 17:06:41 -0400
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:45388 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbfHMVGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 17:06:40 -0400
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.191) BY m9a0003g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Tue, 13 Aug 2019 21:06:12 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 13 Aug 2019 20:31:13 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 13 Aug 2019 20:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDXEClbP55AAOvw5V2xwNM3axuJqJ1Sys2OagHTHzdJWM7IYvBl7sRnOv+RCaMZ/g0VVE8KhNuunLQ+MrYsn31/kred1ohUchRnx1ebixjCAyNoM/tV6mqLHEefJ9Ipzq938DSgR6snbpQz9JMmG8m69nlKEVbPNXLbLwg6oQ5c7Zj89cy+Mdki6tpWk404JOs9mJCth1jE3WpvLD+6F2xxhlyKQUEmbe9jSIkJJW+GuSO32Y7JbY2+/0KSKeVGiS6tfSMF7NxN4+R77PV2TLCFitbGMoPwRIHUPvdSivCAeJCdsdOP6zGstxvVe/UFJdXrsT0ClFfRpEMJbCYyo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4QaegRr4INuxZtTuEd18U8xeBeNhBcoBh7Rn/BF2nc=;
 b=jMLLBertMXsNA+tHdlQtMXZXjWPx7hUl0iCR9uaeRGUiIDXVOGRGXes4ZfmkpFBom4hLhcUu7kE9votZIT/24g/qJjCwqG6cnD6JOjKCmFw64v5DtEov9Y7Q1LEsQ00gGaEZ7YdY+4K5DVP9UNheJO0doXtkT91t9gccg3PQo9YEQ0dv4HGCN58+sh1Ve1YyunP5lv1BBxfQ/rd0739wokA3eyieXgRCpmrXxJZIEt+sUXhZ6cg5mlQNcIgBuDe7Ua5Td300QJ9LjOHb1VUPNDIdla8nQ38ckRjleACKsYy+LJMGNs1hKOo/s+mLtBe99HiENE756SXtYjDoQaFt8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3366.namprd18.prod.outlook.com (52.132.246.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Tue, 13 Aug 2019 20:31:12 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 20:31:12 +0000
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
Subject: [PATCH 3/3] scsi: qla2xxx: calculate dump size if EFT alloc fails
Thread-Topic: [PATCH 3/3] scsi: qla2xxx: calculate dump size if EFT alloc
 fails
Thread-Index: AQHVUhYLUXzRWI/JRUeS69TkO7HK1g==
Date:   Tue, 13 Aug 2019 20:31:11 +0000
Message-ID: <20190813203034.7354-4-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: 2187d57a-dc59-42f4-0669-08d7202d2e3d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3366;
x-ms-traffictypediagnostic: CH2PR18MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3366C284FF00FE776EB64911FCD20@CH2PR18MB3366.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(71190400001)(6436002)(8936002)(54906003)(110136005)(76176011)(2906002)(66066001)(52116002)(50226002)(71200400001)(316002)(81156014)(81166006)(4326008)(5660300002)(6486002)(256004)(25786009)(3846002)(7736002)(1076003)(26005)(8676002)(6512007)(478600001)(53936002)(6116002)(486006)(2616005)(186003)(11346002)(14454004)(305945005)(446003)(44832011)(36756003)(66556008)(64756008)(386003)(6506007)(66946007)(66446008)(102836004)(66476007)(99286004)(476003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3366;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LKdWYEAbZ8hwDqa4L6g3M7fe7raGSGWRPVjlxiQd2foqj7IPg9WKdy88twbTNox1DP+mNErKakgNRpFg2cSeTYRAGRS8FPykjyTtPaXInXG0Bj0wNDf6pfBduwD5xQf8GEw7DJlK9GMsVKY+QxCIRiCEosv0bQNdrmnfM6KrbaPzDReqDtujuDGmJT/J/HHLbSzlLHS8TBzZQJuzmCu8HiZc535Tte2IE5vtlwSirI2YkJ+aJvZ1QX5QdWxbQe6OEVxkgSs/6kc/FC6djHXWPMXwAN8Oc+EVx4JBrE1KYHn79jZYaYtgZEE6ibbnaMsReOsUYXCA1kiVHV7nWg2qqZiVhnuBncstz1yZDVPJvqzcnjjxoCZiW8WY6hS9jn1wyzReHuUszABSFq1DlJJXzX34w/kNg6MUQcKCWR8PsD8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2187d57a-dc59-42f4-0669-08d7202d2e3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 20:31:11.9271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZnmQMh2lTmTCNUU9DbNz8SiKIWLkKH0Xl5cKf7rvnPSLIXTwVBJ4LWsWZpcT1x/J60NoFQmU6B8/mxqy5yicA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3366
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

It seems right to try and calculate the dump size properly
even in the error case, before allocating the dump buffers.

Cc: Joe Carnuccio <joe.carnuccio@cavium.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ca9c3f3..8427436 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3191,7 +3191,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    EFT_SIZE / 1024);
 			ha->eft = NULL;
 			ha->eft_dma = 0;
-			goto allocate;
+			goto calc_dump_size;
 		}
 
 		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
@@ -3202,7 +3202,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    tc_dma);
 			ha->eft = NULL;
 			ha->eft_dma = 0;
-			goto allocate;
+			goto calc_dump_size;
 		}
 		ql_dbg(ql_dbg_init, vha, 0x00c3,
 		    "Allocated (%d KB) EFT ...\n", EFT_SIZE / 1024);
@@ -3211,6 +3211,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		ha->eft = tc;
 	}
 
+calc_dump_size:
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 		struct fwdt *fwdt = ha->fwdt;
 		uint j;
-- 
2.22.0

