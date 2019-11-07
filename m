Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CD8C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582EC206BA
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKGRJa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:09:30 -0500
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:32888 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfKGRJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 12:09:29 -0500
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2019 12:09:28 EST
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.190) BY m9a0001g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Thu,  7 Nov 2019 17:08:50 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 16:49:21 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.8.12) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 16:49:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8IcIP4V5m0XBQ5llbMb6oxcl2t/eme4Rq1l1apFlGhqvZqzFHBBooDgR79JiSnZHUjGuYKA75YlRIINMI9y23k4jPxBp/oZ8XYAne5Ok8icqu5YwJ0qNJqQOgL8NATYu21eid3BRl70nN7gvTCIXpXb6orYN56HMQd5hqyQ7sAzbqQW790ZKCAC/tpHJmEH9sw6NB/NqdGBb4JkYN7ahKQMy+Z1hR10kaC97/KMdZWEmjfBUb1K+oq5gWEAsvgEaCkoi1eYHPqTW+YvXQPcpSYtalsJzcvLisI75mYjsD4JZsfd/Er9HXKYCeYNqB6DjtdE+Ur8BcWMRuEQTbsf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD4ptdfX0N1zcIEoTspQT3kTHnUMF/hDXdAM6qlsVRw=;
 b=kfdRJ1Sufef8lq7X6uIfytH1v1xhMF50a4pA+gjt4J9f+nOsUz/mwLs5ZY61hMG2Kfy2MC78NEBCmdw8b7ufsPm1iQ5AfvW3Ge9adk0ftes2ljhWNHAHmdvLcmFhVnnhaEcJIJ0qo/EKTI609xkNbhVggHgeOu6caF13w3oWd3Y/dYCdJjqQawjjYUzClfkzI1LwgQ0zI+DqgwsFI6Ux76xKZ6KeyIMzxKlgivhOOORjBNOzx7Dgd1wip+hoe3XtTF5C2KqMxATUih8PvSLBePljsNMeBSsnL+sxinxvCFf6LVjHQq837EZsVvDa+lGQWzLAShJYFhB2NGuXHGBhww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB2168.namprd18.prod.outlook.com (52.132.141.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 16:49:19 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 16:49:19 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Index: AQHVlYtMnCf/6Msk5U+CzMMdXwD3Pw==
Date:   Thu, 7 Nov 2019 16:49:18 +0000
Message-ID: <20191107164848.31837-2-martin.wilck@suse.com>
References: <20191107164848.31837-1-martin.wilck@suse.com>
In-Reply-To: <20191107164848.31837-1-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: 1c4ab4c8-7777-4e5e-b42f-08d763a26e6c
x-ms-traffictypediagnostic: DM5PR18MB2168:|DM5PR18MB2168:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB216845E619C891DC27760E31FC780@DM5PR18MB2168.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:345;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(199004)(189003)(476003)(2616005)(486006)(3846002)(102836004)(256004)(186003)(6512007)(14454004)(6116002)(64756008)(66556008)(6506007)(386003)(66446008)(2906002)(66476007)(86362001)(44832011)(5660300002)(11346002)(1691005)(107886003)(66946007)(4326008)(36756003)(446003)(26005)(71190400001)(52116002)(25786009)(66066001)(316002)(99286004)(7736002)(76176011)(110136005)(54906003)(50226002)(6436002)(71200400001)(6486002)(305945005)(1076003)(478600001)(8676002)(81156014)(81166006)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB2168;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o6Y4oGVlvL3gotzmqw9v09CdDQIgKtbI6i1wDoh9u6yHo/5UzLPHfboR3nG6hN+RdFmq7oi+Wbc246G30FqrbdFrkzFd1RB8Kmy96MpMVBNDJwxZ+rL9zdiL/Ux7frTiQgZyStAOWF/v+ciF1zlR87d8qttBpm4QZ/f6KRzM5PiHOTq890jrVHciT8b2GOy9oOetgsk793QEO8Aa8JA8/j2hipEOuRmlUe8V6uctJJrLHRvfb9RgL1NU0mE9yiYQg53oWNjtU1DhItWLtYZXd3WDlCSRtAPtlBXIt159tHW0qafzB5MC9NJ8Jb5yH35BqImqeFZNb+WbqV4dtRywUfm700s/wkf7puYK7EI00rOH4wtARe0i28GjI+iAKlUsrs4VVWh1TExbpwkb6Wte28C337L0hMalf6bNczvlPxXgYDGfZgAxnDlZg36r9YDx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4ab4c8-7777-4e5e-b42f-08d763a26e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 16:49:18.9222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L5flcWLhrbUrNvc+jYQyhg0bsSgOqYNwpVAsBLO4n1tCvQ4AB08RGmZk9wLFwDfZLfY21eQKBcactfYGMhZu0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2168
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Avoid an uninitialized value being falsely treated as NVMe priority.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 6 ++++--
 drivers/scsi/qla2xxx/qla_inline.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 721ee7f..86c5155 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2476,8 +2476,10 @@ typedef struct fc_port {
 	u16 n2n_chip_reset;
 } fc_port_t;
 
-#define FC4_PRIORITY_NVME	0
-#define FC4_PRIORITY_FCP	1
+enum {
+	FC4_PRIORITY_NVME = 1,
+	FC4_PRIORITY_FCP  = 2,
+};
 
 #define QLA_FCPORT_SCAN		1
 #define QLA_FCPORT_FOUND	2
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d728b17..352aba4 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -317,5 +317,5 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 	    ((uint8_t *)vha->hw->nvram)[NVRAM_DUAL_FCP_NVME_FLAG_OFFSET];
 
 
-	return ((data >> 6) & BIT_0);
+	return (data >> 6) & BIT_0 ? FC4_PRIORITY_FCP : FC4_PRIORITY_NVME;
 }
-- 
2.23.0

