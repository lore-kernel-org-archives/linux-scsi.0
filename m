Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7600DC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C9A21D7F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfKGWuS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:50:18 -0500
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:40588 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728051AbfKGWuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 17:50:17 -0500
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.191) BY m9a0001g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 22:49:37 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 22:48:58 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 22:48:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzpzBivzlzeaxzQWXQ7EiTrXGo5UnM7wnu4DqZ5+q6RMVSPOmNC433l5Lo7S6nKi25kFi5qPAJw7BWeIRWZ54pSt44Td9DVBcn/AZoo7G6Mg6N0FzZEBiu3dZL/l8tTijpiPgD+xUdW2oIQPJLMTRMMETUjG3jlxPrQIFx+P6islIa41CEPZzzV17q27zD5HZ4Vx55RL8f7nXb8pdHxcrxcJwKvJQ/zS//sZ2fT+DzU/Hmq2lpL4jlP3P2tooI3q2b5RSwIhuY+kzDraKSSt+gsYMfyIoslft91y0X7SGp2OGzegZlGAP6NR9N4Qc3ae8YYHbk+ByfU6R7byaev9fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv0W1mXVHH4U7RpmDMygWa4QOaVqxqTc/EwgEqYUMJ0=;
 b=iWXRabtRAFgzRip+x5O7JLiBMG2Q9JqqhVMYptaj23HTsf4mB4mRf26rstj8kDdU9pYtOgqyZU7XKUCMHqaSYhae0cBHorILC+b6+1VxzXghcFNTbJe9S+KGPLXpeQwgy7lgMCPswb61+JeUxIqBoPmkYfnbq0QQB/7UnLxP+SFMns6ZVd4HRDczISDtdVXc2c89dYrWoEJiuQpYvMGUAOU0L5EJ6yH0y5wcJvFN9UaqFrZwL9N70G6NxXAMyugSul38UfehmpEz0UEdcSDEW2zO64qa1MLauBnqyLvL5cQr6H3Fkz2GL7fGMfqHXvwqDLwk6jkkn37nsMVyadQkng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1116.namprd18.prod.outlook.com (10.168.113.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 22:48:57 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 22:48:57 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Bart Van Assche" <Bart.VanAssche@sandisk.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "David Bond" <DBond@suse.com>
Subject: [PATCH v2 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Topic: [PATCH v2 2/2] scsi: qla2xxx: don't use zero for
 FC4_PRIORITY_NVME
Thread-Index: AQHVlb2KYQOt5Eqg+E6o7XqGYh0Xow==
Date:   Thu, 7 Nov 2019 22:48:57 +0000
Message-ID: <20191107224839.32417-3-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: 1d928693-85fc-4317-b723-08d763d4ac5f
x-ms-traffictypediagnostic: DM5PR18MB1116:|DM5PR18MB1116:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB111648AE65233D70AEE38A26FC780@DM5PR18MB1116.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(2906002)(316002)(52116002)(86362001)(8936002)(66066001)(1076003)(486006)(476003)(6512007)(71200400001)(71190400001)(6486002)(36756003)(44832011)(76176011)(386003)(6506007)(186003)(50226002)(1691005)(14454004)(66946007)(256004)(8676002)(478600001)(5660300002)(25786009)(4326008)(6436002)(99286004)(54906003)(7736002)(66476007)(3846002)(66556008)(64756008)(26005)(107886003)(81156014)(66446008)(6116002)(11346002)(81166006)(102836004)(2616005)(305945005)(446003)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1116;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NlnhfPmVrPavc1USJLAfsTDRm6HkKa0CeSlp0/pNVaMSAYEsxMNgrF7s37qLryZN3zAg0t6gQww0Xshcc6Gguiv09rG8Sf3f7p6w1XDNBpGjoLI/5GBRceai3AJY3lLIIYIQuNbog/L8Fnlx+LLUQAaViVPbdRnijpQUAXR0TseZeoQoath0iI/U/EqQCagkh5WDs1LikpmBk35DQ6y7d3HfmBv03Gyg68zEnc2jlX3fh8VVBZpS0WGcA9NsmzawP35xgZpIyEebrQ3Jbsky6aZmJqBdjjlPREnJICjx2xbTGW5WsVDmuy4U879lFL82VBttlPF+2KlyDYlswpFIr2foJnH3h/HW+scqNNOnvnXYnVdRgAlr7diwYjbzllW7Whda6kSzAxJYo5IpUvYGnZOkiRsSC2Cj1epVPqKMYN4eY6JZkl/6zS30ycsIwB6+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d928693-85fc-4317-b723-08d763d4ac5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:48:57.4414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OIWEGRMqcD7VPat+TwNLHxPtC/mNZm23qYf3mIlEVovRWo69/BOBxySeHezRJxf/FbdmddvB7aLGc/ylzvBpxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1116
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Avoid an uninitialized value (0) for ha->fc4_type_priority being falsely
interpreted as NVMe priority. Not strictly needed any more after the
previous patch, but makes the fc4_type_priority handling more explicit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Tested-by: David Bond <dbond@suse.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
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

