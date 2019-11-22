Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09102C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF87E2071C
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVWTv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:19:51 -0500
Received: from m4a0041g.houston.softwaregrp.com ([15.124.2.87]:40509 "EHLO
        m4a0041g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbfKVWTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 17:19:51 -0500
Received: FROM m4a0041g.houston.softwaregrp.com (15.120.17.147) BY m4a0041g.houston.softwaregrp.com WITH ESMTP;
 Fri, 22 Nov 2019 22:18:47 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 22 Nov 2019 22:19:24 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 22 Nov 2019 22:19:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rve9EpgdURdrNj28v7O5wpetF76B5ZZ3RGXrhfK/HRO9RyhWjSnX7xfti6U0SB3n+gWX7tiXskBURL3F/M15g1LEc1zj1rhjPwB9V6VgoPlRomnFbq401L/MWZaPEnfqwjVMJ4MBWRe/BHWPm4fSUE0iWfnSNC8EKd8xTj81T1eFgDk5k/Gzy2Gc2DhMhlRlUyis4W3vpdVNrUE9vjfIH+nCjhCzNSGD7IoULGcIRlhZdIklFLTRWFCCyCzfgufQVqFm9FBDD/ElF2alfdjmw+72qhn4itSL/tPjzkVUjlRh/L0GQnyGacVapGTmWOgIc14WgIPwE463PLWoMNtSkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/LoNxQs7SE/r6c0JbVef9aL+dWnNh4MSeWqltZb76M=;
 b=Qf9OcbXHZPzqAHM0lyXh/81wGIqTDx1kmhOf5oCPx06KgIrPrkuIwxWUyuFAIeXa8hypdwpIyMgPQU076lL7LvyA1TlTE+W+F/HCOLv2aUGrenLPsNENgQaW5OTQ5DucFvhpzSclBLrlfToc50kmA2e4DoBbFTg9Rw0794/Cy0hWbONKyvwJ9Y+PXpNTksT7RwAHPkv9R5g3hRQvsPqdt/KrY1UUH9Mw4aUD19S9mS8cC8aDE91bE5LowFkyzSWy6/cPW/1opzbQKVYOtBw4V87d5k+kDdkVtgi2TPgnzuUSC6C91/nZwkBp0fJ7+2vuxe/IGFDqg5o2ECNGzim8bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB0937.namprd18.prod.outlook.com (10.168.120.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 22:19:23 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c%12]) with mapi id 15.20.2474.021; Fri, 22 Nov
 2019 22:19:23 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "Hannes Reinecke" <hare@suse.de>, David Bond <DBond@suse.com>
Subject: [PATCH 1/2] scsi: qla2xxx: fix rports not being mark as lost in sync
 fabric scan
Thread-Topic: [PATCH 1/2] scsi: qla2xxx: fix rports not being mark as lost in
 sync fabric scan
Thread-Index: AQHVoYLkwFqoUasa9EiZ/DVZox6sxA==
Date:   Fri, 22 Nov 2019 22:19:22 +0000
Message-ID: <20191122221912.20100-2-martin.wilck@suse.com>
References: <20191122221912.20100-1-martin.wilck@suse.com>
In-Reply-To: <20191122221912.20100-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0038.eurprd05.prod.outlook.com
 (2603:10a6:208:be::15) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce71e0c3-c904-406b-7fc3-08d76f9a068b
x-ms-traffictypediagnostic: DM5PR18MB0937:|DM5PR18MB0937:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB0937CB111A513ACE5895DC39FC490@DM5PR18MB0937.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(199004)(189003)(8936002)(186003)(26005)(478600001)(54906003)(386003)(2616005)(36756003)(3846002)(76176011)(6506007)(5660300002)(6116002)(86362001)(305945005)(52116002)(4326008)(44832011)(446003)(14454004)(6512007)(66556008)(81156014)(81166006)(66946007)(66066001)(256004)(66446008)(66476007)(2906002)(6486002)(7736002)(71190400001)(11346002)(316002)(99286004)(25786009)(102836004)(71200400001)(1076003)(50226002)(8676002)(107886003)(110136005)(64756008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB0937;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQzC63luOzqm6aehiTouvA4iotgIfA1xODxU0xCSf0PMOYz8s8mLoWnRyPGlt75eJ+umSDz3jaDswgFCDR+6dpj5utPiGxHdvhhkfouE3bKJJG9Ue95RC6fMNvaBt0P9626W49ZWDspqLd0NpQPehfyLoEFK4dJ1CfVbhjfr4DGczvyYMLHtl3zkAXdsLCIewtMKYYegULh0Sd0jWToLraaoW5uZ4iSKBPVu0vtcuMtcweahxF1dAan7kHYq1QH+KBvsPkxU8Bb69//1TnO3sOdy0Iau+tCQRZygGXnBlrHNgEdnY/5iJOhIByDnh224TkPDnOMM7tn0DZ2k0hqhs/yrVmsirTDBB6XM0czkliPO5es2l++B3EasytIw5S0VD299Fvw7jgsPgTbOaypbWQh++FxH6Plx9LSXYsP/F64S5IMKYWfFM/Yipr361ZsF
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce71e0c3-c904-406b-7fc3-08d76f9a068b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:19:22.8563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rR0IZ7dapZoryy5KWSvoCQCB/L+dln+Fnm+Tb/HiIPbI29z36Y/WaWPlyarbtG2tzQc8B6PuGaXAsJOl67LdoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0937
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

In qla2x00_find_all_fabric_devs(), fcport->flags & FCF_LOGIN_NEEDED
is a necessary condition for logging into new rports, but not for
dropping lost ones.

Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Tested-by: David Bond <dbond@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1dbee88..6c28f38 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5898,8 +5898,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
 
-		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0 ||
-		    (fcport->flags & FCF_LOGIN_NEEDED) == 0)
+		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 			continue;
 
 		if (fcport->scan_state == QLA_FCPORT_SCAN) {
@@ -5922,7 +5921,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			}
 		}
 
-		if (fcport->scan_state == QLA_FCPORT_FOUND)
+		if (fcport->scan_state == QLA_FCPORT_FOUND &&
+		    (fcport->flags & FCF_LOGIN_NEEDED) != 0)
 			qla24xx_fcport_handle_login(vha, fcport);
 	}
 	return (rval);
-- 
2.24.0

