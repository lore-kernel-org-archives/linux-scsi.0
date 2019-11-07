Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCACCC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABBB421D7B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfKGWuz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:50:55 -0500
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:40435 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfKGWuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 17:50:55 -0500
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.147) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 22:49:09 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 22:48:56 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 22:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrkRjSpBEA+foeVxG/7DsIXDyRGzo41b9GMAONoP8lgXPUh2CcfqdeKsf7K4WtukJevzkJnHfggjUPBf0fXgoBqs6xz6ODYwDIvOBP8VSXyEkxnHcASZSo42t8eCqurmBp9avpNIcsWpWtoAyTlPPkaKNjcyDD30Er0EdiFJwX5uAOyyidCsqwrNHem1PflQRpfAtd1bQisSAh4LWPAcv78gel0X33tXI75yRTUESJm2LXAXgQP/91UFUyGXD6KcwoJQg/jqoxTV1eQ2JjNjtBuniELv+NdvgIfSu9SlcounIqJNveFNNdfPuaLtyzT6h1gzOxcmkvr2MKCFYxYaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4TogJAexhu64Nvn3N3GUPKxKoi/TUF0EQsDCs5oxhU=;
 b=m+mPwcp1bxTxnTkdpVjzZ+qSoxeJT8yud6nTF7m4LY1EtANbZpXNIu+7kw/ePZbiy41phP5SZ8zycaA3UXq6XrMYD6gQ9bG8vU3EMN/kzDJYHPY9pWcQDhGM7MW3PlBI5Khn3QsWsiy7zVjnCwDgADHfgjnssG+03bG4n6gQEDdBusrGSja2CdUpF3t6uFl5pxD/svIdkOYAkVQ8f12UcmgvAiM3AQ7KBnZbmVVTO9g2hUxZDQv7ufz1kk77WoA1fgEMLqBX7K6Z62UlBOLKQdqliuYpK/tEwvb9BivwdvnvR8klJsvADP8pXX1FKwzCwKVpuEo1ABbN1cdAxNoq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1116.namprd18.prod.outlook.com (10.168.113.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 22:48:55 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 22:48:55 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Bart Van Assche" <Bart.VanAssche@sandisk.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "David Bond" <DBond@suse.com>, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Topic: [PATCH v2 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Index: AQHVlb2IT0UWn/slXkOlmVuw91WWFg==
Date:   Thu, 7 Nov 2019 22:48:55 +0000
Message-ID: <20191107224839.32417-2-martin.wilck@suse.com>
References: <20191107224839.32417-1-martin.wilck@suse.com>
In-Reply-To: <20191107224839.32417-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:122::23) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 031f5cc3-327a-49b5-a383-08d763d4ab44
x-ms-traffictypediagnostic: DM5PR18MB1116:|DM5PR18MB1116:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1116E9B475D1E5F761AC7CA5FC780@DM5PR18MB1116.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(2906002)(316002)(52116002)(86362001)(8936002)(66066001)(1076003)(486006)(476003)(6512007)(71200400001)(71190400001)(6486002)(36756003)(44832011)(76176011)(386003)(6506007)(186003)(50226002)(1691005)(14454004)(66946007)(256004)(8676002)(478600001)(5660300002)(25786009)(4326008)(6436002)(99286004)(54906003)(7736002)(66476007)(3846002)(66556008)(64756008)(26005)(81156014)(66446008)(6116002)(11346002)(81166006)(102836004)(2616005)(305945005)(446003)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1116;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /jtu9AITLyMkDcnXUZbi9i4KvQEXrU4xEENcPpIEOT3ccJmSLFvYT9EY7CcG8gUanxJr/KRAJmU4a2waVDlaYcIi/HUKktzrbRpvzcgMhqYApJnVax17+aAYm0BYpGYAUYeYWScYo6qx3Eb/lhactBjr2eHUxNS7r3zryHjtTNgL1sZCBGUP0EOHK16FD4JNCwmGFuH+j3GnUTLDsSzpBKMivtXI0mXDGBXBivKmghA0KFWyxdTPTJSjqNxTEirqgwRBeFjX8Lm1m5qpbdFChpTt7NvZUofjr3HDlmFr5KuGeEujLyiPrb+4g2khY79pfqomffZo+QeIoCUc4+mom6ISVLCn+beMgoEWD1+uhCe0R4jF0wAM0PyB38SH6y+h70dwO0cJ7rXNPoNzNTrASHktvliIVNAg+p0itroryOJG6vpS9ezsFqgzw5A1iLc2
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 031f5cc3-327a-49b5-a383-08d763d4ab44
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:48:55.6202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55R/Z5V5TziT137zj7b6aTW4Qk1Xzd899THSoSVVpS+9WGq90R0jVFeASIuz7rqsg/YDPXo6tT5FhDBQJPPrkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1116
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
Tested-by: David Bond <dbond@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

