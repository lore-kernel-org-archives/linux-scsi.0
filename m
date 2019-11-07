Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BFDC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB6882085B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbfKGQvS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 11:51:18 -0500
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:49222 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbfKGQvS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 11:51:18 -0500
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 16:50:38 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 16:49:19 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 16:49:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk+5Nt+mIpsH27p2y3BRUFq5FoJ4WvX9BPzCOsFI5rZmsIB3VdfEwkdj8HH9T+I8BRZcuVQAAWYH6FtheBK4dM/Wfjbh33YgomytOU+0uCTB36+TPiH7QCCAK8dWUWk99JgZQmvOBRwkFksA0y4BCcPSxHmZpmPvUfTUMZsnz5F+ivTy3J8TGRihRyes+RZVlFON8QrikPfMkq/JrUzfEXO98nHwJV9V/rhIQCh3hADPDydA6YIfUJIv+j6HbUrGyodyWU0vwDM7pD5pmExWTnihP3VUKeN8EYKyqA1R9lQPWXvar0/cM+Y+VHwADks2+PGH+RE6MCGzXZeqlm1aWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+kxqJKQqSUYRRsMJc+O/U9pXSeiNW02hlMSSF1xABM=;
 b=D6oeBUIlAzxUNPw9V1x11jTPuTvBO6tUp63DpWqvYUiq+GLWs5o1FHob9B2lYM1koWrvpjuBFip8nSQFKd/ReIcbAxhtxadGnfArW9EN/tibixvgkWU7RSf2V0hMhakHc7GkJx52R8mXC4d9PO/iPQPYYqdb7qctXTXr7E0YXLOd6PrRI19hf7LwF3ZeJJalIMrOMdWXnTXLl8zOPWTA2Bj2RykFoc4h9VXQhx4xd/5T/gsTdj8bvXekB62QZb5E02+xnc3I5Z3zPYXB+FozLn1YNSXiF/mU2teRBgD+mpSoZ5zd6zLPZuvZx2SOigR0btXzJIMcJzqY0qXHT8l/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB2168.namprd18.prod.outlook.com (52.132.141.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 16:49:17 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 16:49:17 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Topic: [PATCH 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Index: AQHVlYtKGAtbuPovK0S3qRD6fzlmPw==
Date:   Thu, 7 Nov 2019 16:49:16 +0000
Message-ID: <20191107164848.31837-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0098.eurprd05.prod.outlook.com
 (2603:10a6:207:1::24) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13ce3ce7-5682-4fbd-ab68-08d763a26d17
x-ms-traffictypediagnostic: DM5PR18MB2168:|DM5PR18MB2168:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB216898DA30AC21B7E613DE2CFC780@DM5PR18MB2168.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(199004)(189003)(476003)(2616005)(486006)(3846002)(102836004)(256004)(186003)(6512007)(14454004)(6116002)(64756008)(66556008)(6506007)(386003)(66446008)(2906002)(66476007)(86362001)(44832011)(5660300002)(1691005)(107886003)(66946007)(4326008)(36756003)(26005)(71190400001)(52116002)(25786009)(66066001)(316002)(99286004)(7736002)(110136005)(54906003)(50226002)(6436002)(71200400001)(6486002)(305945005)(1076003)(478600001)(8676002)(81156014)(81166006)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB2168;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bhMPqaIo35FUiplM5MC/y/Ja/rZXDyPYQ+vsZtPKeftUnw9Rd2EJTVHwT0bgKRRGNWwSbtR8b5JIQOnqoNyRxIH0JEd8+SAcgUeqI/Iazu3GF3MbxpPsGxWKn+qGyNrrhdijit6uIBRfuKbKoaUJyZ4megZp4qsjNTIqPcZIu5ejr9VHGzmikZUVoQzQeu62nLX/EJS+wyu/tedRQRzTVdJfWUs0ow6Y9DDo6a9KvLlVznuLN4wQmv63k7G/ULiQCzV0CbCDmpafQc+MbtyTfXaxBweqgvyKrXrqXdo5vOZcCM+XxmTcj8hO6jwlYoW2mXfLIYPTq4FOCfbeMC6vfMy+u1NTOlKnZrXngOtzX3g89nL9s5PugIR48xN30O8SZ8dLqul0eA+N7yHtGTxK69vTwdRXltRgWyvRSIfewXfvRRIh284XJUHsFVRJdpkC
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ce3ce7-5682-4fbd-ab68-08d763a26d17
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 16:49:16.8921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mltlmxOIhUSvwNVIQ4bGLksS+4I+QlK+SZ1WOzke8SNKVwmUQMDe1nrmExkNgj7Ij1GJKW/HtWvWZs33TqSSQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2168
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

ha->fc4_type_priority is currently initialized only in
qla81xx_nvram_config(). That makes it default to NVMe for other adapters.
Fix it.

Fixes: 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port support")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7cb7545..2a016a8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2214,8 +2214,18 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_init, vha, 0x0061,
 	    "Configure NVRAM parameters...\n");
 
+	/* Let priority default to FCP, can be overridden by nvram_config */
+	ha->fc4_type_priority = FC4_PRIORITY_FCP;
+
 	ha->isp_ops->nvram_config(vha);
 
+	if (ha->fc4_type_priority != FC4_PRIORITY_FCP &&
+	    ha->fc4_type_priority != FC4_PRIORITY_NVME)
+		ha->fc4_type_priority = FC4_PRIORITY_FCP;
+
+	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
+	       ha->fc4_type_priority == FC4_PRIORITY_FCP ? "FCP" : "NVMe");
+
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
 		ql_log(ql_log_info, vha, 0x0077,
@@ -8521,8 +8531,6 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 
 	/* Determine NVMe/FCP priority for target ports */
 	ha->fc4_type_priority = qla2xxx_get_fc4_priority(vha);
-	ql_log(ql_log_info, vha, 0xffff, "FC4 priority set to %s\n",
-	    ha->fc4_type_priority & BIT_0 ? "FCP" : "NVMe");
 
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0076,
-- 
2.23.0

