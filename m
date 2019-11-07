Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A439C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D49AF21D7B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 22:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKGWt1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:49:27 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:43666 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfKGWt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 17:49:27 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 22:48:18 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 22:48:54 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 22:48:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqSE2L9FXR6YJ6QQZuIz6BxjjO18av4UEwLZfu/isIVG41l8axPEgWm5ecUFhl72pYSF6xHXqorjersIjQxjK4QSl7XXPOv7SsJnMNMyWzc5WMAjsRuFMpa0Z2cZqy0cjEuNaOWQ5vEIbYZ8qyP425Xj1B6oWYQQiPsrykjDlneL07F3Wp5VZNB+FRXPWHaTv5AEHABZl0Dv9Paihm6q8nE71ayECjfcnVdK7lMrzrw6o71I3yzWQpgmHrxI7/C3RXTUj4HVIJE3vUrY/e2GZS3Wag48o5zTEv9OWpJbDhnh63vW9i8ulD6pnqc78GQ5vTLJTKy3wnmt5zd1C+/GCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOA/Gcrdaph4dYg2BMok7SJHVpyuAp8E+IburNIcq/I=;
 b=mqr6ViigcxU+GMB8nNw1HMqas7zXh0r/gTGUhyK7ePPxJNcCkoOy1BXFLTc8s4eh9TkZNhxqcHxSV+3WnHYHWL3gTVzvYkXpgTJZUwmKnTwmLnrwYWaOyF9ObQsYV/5vBj8Bm5euqLPELHA6N5eJXHLnyTEN30GFHgb5SokNnXY1rbkExvYiy2oNOi4SaW1r3ioPPPN9Li6yZS+ZUnW3S70FKaIJmc37ypb0hB2I6eVJ/oXJH0iwRp5SGPLb61gAH8CurHMQ9zPMvy0BZtLhH3eWddWPx9lKk0T5n2cppPiJ00pp4+sMwWM2z262KqI2HyKfJRBxF51twWBK0jvUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1116.namprd18.prod.outlook.com (10.168.113.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 22:48:53 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 22:48:53 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Bart Van Assche" <Bart.VanAssche@sandisk.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/2] qla2xxx fc4_type_priority handling
Thread-Topic: [PATCH v2 0/2] qla2xxx fc4_type_priority handling
Thread-Index: AQHVlb2HdH1UI5uRmkC51BH5uXlA3g==
Date:   Thu, 7 Nov 2019 22:48:53 +0000
Message-ID: <20191107224839.32417-1-martin.wilck@suse.com>
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
x-ms-office365-filtering-correlation-id: 69e9f8d6-66dd-41ab-f8dd-08d763d4a9aa
x-ms-traffictypediagnostic: DM5PR18MB1116:|DM5PR18MB1116:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1116377CDA4494D625816868FC780@DM5PR18MB1116.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:260;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(2906002)(316002)(52116002)(86362001)(8936002)(4744005)(66066001)(1076003)(486006)(476003)(6512007)(71200400001)(71190400001)(6486002)(36756003)(44832011)(386003)(6506007)(186003)(50226002)(1691005)(14454004)(66946007)(256004)(8676002)(478600001)(5660300002)(25786009)(4326008)(6436002)(99286004)(54906003)(7736002)(66476007)(3846002)(66556008)(64756008)(26005)(107886003)(81156014)(66446008)(6116002)(81166006)(102836004)(2616005)(305945005)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1116;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xblM8B61kPClr+AXTDDz14wHS4LIDzt8eBEaB5GIlotE9hgH8tz/AsAJdX5Xg4SeX7X8Ejn4HRQvP4P892nkWF0VR3zvQEqYdNDLPYQ6ww+MfjJbH2VeHICspP2dFCUcW91dUL/TiQBFHK1s8c57ZcBv6GvyNuiHkZ5mTY/QO7jir4bZFGDpdOWu3W9P26cr7Ty1Uv07rzNsc4I4CcQEMSRzs6simN5YlzVFUr5As0XVleJpn0x2xvpatLxxbwP/FVeBdo6BYgOt8bxn26KoRgha98g+kj0DRxSIYEaty5zQERPuNTMKAkSjd8c/aiUw15YOClKRpfy0zOCFMRQj8ITNpoQresCLPP/+Gh64hLqXx1UI3YwuiBlFvpl4Nn+vp2y+/KV5543JIY4b/1nmRCoRW625s00JY/AVf8j531tFRYfYIdInszb6t0aXp0G+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e9f8d6-66dd-41ab-f8dd-08d763d4a9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:48:53.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wovr1MGfkGn+FV42BajN22XdieP5mFr+cHl9OWIVlPT/UZ7EN4yVvk3agiOgA5pJis+JQxMM+BWWTgNn9HPDaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1116
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Resending these patches with better commit messages and
"Tested-by:" tags included, as suggested by reviewers.
The patches themselves are unchanged.

Martin Wilck (2):
  scsi: qla2xxx: initialize fc4_type_priority
  scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME

 drivers/scsi/qla2xxx/qla_def.h    |  6 ++++--
 drivers/scsi/qla2xxx/qla_init.c   | 12 ++++++++++--
 drivers/scsi/qla2xxx/qla_inline.h |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.23.0

