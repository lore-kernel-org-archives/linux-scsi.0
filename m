Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999D1C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C922071B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVWX6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:23:58 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:37462 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfKVWX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 17:23:57 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.147) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Fri, 22 Nov 2019 22:22:31 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 22 Nov 2019 22:19:26 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 22 Nov 2019 22:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2YUDBQhfmO8cRyVOeKC3aC9RZpHee04e2hkyOhqRgkIF0YOD2YPx9rXX8X53NnbqQJBtXqRtDvkapPe9SjIwsPGBQW0Ve959PVD6ytIpviha9aEWfOfdL/A+1o/9FpOEi8YiP9B2zfQvVovZDqSx1ySWSUWg2H5oqMSHleSf7HMkNIwjNK71vlNTDBZ2k+DfLDovkNrYOopVzKYPO8VPBGet73tOWoDcLwE9s7BJYwEjemR4LfcRHnfnBHEAPWMSmspVtmZQgf4I7U8rqN0SpmS5eujKoqiDix7IfQX2F6bpA9AmOSWmYO0s4QcLZmsY+dFZLTheA7080/xFJQyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nT0nkjzIxQDzUHqOu6xwV02teZSuVChK9ysAn94P4gI=;
 b=XpVEB7j8vCbBf/npVJe2UsOK3AmjBTHowY2efzQTCF2n8gaczu+cVnJPb9eRn7qzLLjLd6hEbpmOEvGyMSEb8Ti8O41hIjOxfAC/kKIMSlo5Lj85TaqD8MBboS30ucvkr5T3QYNadCGBfdOPgFjlzFvd87ih/NABZwCPs1lBmP4mXY0WUwQBBO48qhdut9auNU9m+Hw/K1ZgSKB6qg6agA9wtihUF2enMuegFteokonxt6NAzlq9SofeFfIoxmN+TxdE2nFISOxQMy2kaX5jfzdVqYgPUHqt3c9ANDxohivD6oaxozpP856VlEt061Nisa8NZmKFRezh45sa8EgF1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB0937.namprd18.prod.outlook.com (10.168.120.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 22:19:25 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c%12]) with mapi id 15.20.2474.021; Fri, 22 Nov
 2019 22:19:25 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "Hannes Reinecke" <hare@suse.de>, Jason Orendorf <orendorf@hpe.com>
Subject: [PATCH 2/2] scsi: qla2xxx: unregister ports after GPN_FT failure
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: unregister ports after GPN_FT failure
Thread-Index: AQHVoYLlB3orcmi/YEuTDAYLzDWODw==
Date:   Fri, 22 Nov 2019 22:19:24 +0000
Message-ID: <20191122221912.20100-3-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: 880202c5-fb3f-43ed-8235-08d76f9a080f
x-ms-traffictypediagnostic: DM5PR18MB0937:|DM5PR18MB0937:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB09375683FA954D422EA8390BFC490@DM5PR18MB0937.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(199004)(189003)(8936002)(186003)(26005)(478600001)(54906003)(386003)(2616005)(36756003)(3846002)(76176011)(6506007)(5660300002)(6116002)(86362001)(305945005)(52116002)(4326008)(14444005)(44832011)(446003)(14454004)(6512007)(66556008)(81156014)(81166006)(66946007)(66066001)(256004)(66446008)(66476007)(2906002)(6486002)(7736002)(71190400001)(11346002)(316002)(99286004)(25786009)(102836004)(71200400001)(1076003)(50226002)(8676002)(110136005)(64756008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB0937;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qFogXKpAQJ4B4Uv3M8p9576hZldHg/9mFXiEoZy0RY4Urmd2DwbLQbwi7UwQD9VmN16STPcie+gRaz0ZGZXFKUwCbZDyGt0+N78YCYqgBK5U6nTpcqecvTEXWj0RrQc/LUpNc5AKGw0NQGIPOv+iujVskZ6PXDCTNKKSVwZCtTqz4nMxYLnzvKdPzPm1kH3rZ+SWTrIW7h1N7HRKYiy8iHZW5/GD1lwwvprYOfaBODzAl7PITkMEBXSFh+QmImVU4AnaJEWiuyXnCyGk6+6nJ37+hS5gJr5UPYG9xnyUXsAwq59ikQHGevJR3igZX08WqxMIKh1rFAks4KmGZJ8LyvqawZGuaXeM9IuhUF168uAD2E32ul5TIlaFieDOgcdOpY5TQxOdn9QCqpQsDX6xmYaSFD2qkeNwx2hfIBYxCzovMO73laei9Ph+WvFd40su
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 880202c5-fb3f-43ed-8235-08d76f9a080f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:19:24.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQXs+s/UUo6wBxGi4XKR91P7FtO1EFBZyNiuMgVtVqhKHIj2u0DlZ3RD+FInLaaL1/jVJHzyYEOnWDfCdwWejQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0937
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

When ports are lost due to unzoning them, and the initiator port
is not part of any more zones, the GPN_FT command used for the
fabric scan may fail. In this case, the current code simply gives
up after a few retries. But if the zone is gone, all rports should
actually be marked as lost.

Fix this by jumping to the code that handles logout after GNN_FT
after scan retries are exhausted.

Fixes: f352eeb75419 ("scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling")
Tested-by: Jason Orendorf <orendorf@hpe.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 6723068..446a9d6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3587,12 +3587,23 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			goto out;
 		} else {
-			ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
 			    "%s: Fabric scan failed for %d retries.\n",
 			    __func__, vha->scan.scan_retry);
+			/*
+			 * Unable to scan any rports. logout loop below
+			 * will unregister all sessions.
+			 */
+			list_for_each_entry(fcport, &vha->vp_fcports, list) {
+				if ((fcport->flags & FCF_FABRIC_DEVICE) != 0) {
+					fcport->scan_state = QLA_FCPORT_SCAN;
+					fcport->logout_on_delete = 0;
+				}
+			}
+			goto login_logout;
 		}
-		goto out;
 	}
 	vha->scan.scan_retry = 0;
 
@@ -3670,6 +3681,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		    dup_cnt);
 	}
 
+login_logout:
 	/*
 	 * Logout all previous fabric dev marked lost, except FCP2 devices.
 	 */
-- 
2.24.0

