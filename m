Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD67C49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 12:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC40121670
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 12:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="hB4C0X6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfIPMdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:33:08 -0400
Received: from mail-eopbgr750077.outbound.protection.outlook.com ([40.107.75.77]:40654
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbfIPMdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Sep 2019 08:33:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtnY2kiQ0cxqKkVBSVaCE8OKB+G3x6M1mKRqXkid+YgJ3SYRZmdLCdHs7wDhF+nD5wYB3r7g6HqsLtpFzUJ1Y4qS4ZyT4xPdYvllLthosTdjdm0bdbgpMOBZWyob/8hHgjls0tn2NZOBG/2E495yproRuTNSEUWNERyGS12eRFMNz3an7Cj9UbfROt10FTpRCOGSc5CkfuCTw61eWPSaG0jiaig5GXtViDLDbt2Ck5h/bJbRmwKcgrWkIgZ8u3MqEJMn1ilqu06ASmK4GLpnCArTlPwFDJen5LuHUvKgVy/6E91MIlau00fZNH5S1hGjMviGCE3taCqQ4N6gieHdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJIQD4Fu92aqPD9b2OwvruL9ykrqcq+nJAPtGlDGvUs=;
 b=DopK3xL8ZIOfbEyhpcFa+Cn5ZXfSGxgmsJT03so3iDkNAbmEJ6A6PSSII08GaXoFOFIee2aWofROokaiVHJ7pX7HMH0GtbTQCvuM9ZpZis+4hHcMfWcnhjgVx9FVgqlqFOWsiSM4STWETwYebIb82kA50VoaMe3KTlk0p5ZsI7tq9d4SYzHadNw3RDVX1rD4MOC3QLMsfRoRQjfi0K9J3g6TtBD/w0zUZY1zmazUk433im4EXR8Hc3ZVHhgvFNhqy0+xOpObZcLGxHX8hYnCaxOw2SLgSi+XrophikgSqZ0p7QAQN41JFSO6cQSlotFG7LWcCD0ohi88mwWyWhrz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJIQD4Fu92aqPD9b2OwvruL9ykrqcq+nJAPtGlDGvUs=;
 b=hB4C0X6gn8TKBDCTj3MYkShQwkxtOG3ci6Wz/jqnnsUXIvGi/OjCN2QaW/ba0oC8z0uCOAHRsl0ukLPxy/vAT5QRu0NaLQiSxYNXKhRGQMcRslzAQGo18rUJH6+HgnF0qiPs5e63Zc4247LIMg+ERJznaJ/1Bv6tJOxRXmRcn0w=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4482.namprd08.prod.outlook.com (52.135.248.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Mon, 16 Sep 2019 12:33:05 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::1c5f:b47c:d1c3:c30c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::1c5f:b47c:d1c3:c30c%7]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 12:33:05 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "sthumma@codeaurora.org" <sthumma@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v3 2/3] scsi: ufs: override auto suspend tunables
 for ufs
Thread-Topic: [EXT] [PATCH v3 2/3] scsi: ufs: override auto suspend tunables
 for ufs
Thread-Index: AQHVbFqa8oaq4Yk69ky4RtSVevqDnacuPMkg
Date:   Mon, 16 Sep 2019 12:33:04 +0000
Message-ID: <BN7PR08MB56847455A8B0C7D89FF8C6A1DB8C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1568616437-16271-1-git-send-email-stanley.chu@mediatek.com>
 <1568616437-16271-3-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1568616437-16271-3-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85d4f1a9-90c5-4fbc-6f4e-08d73aa205a9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN7PR08MB4482;
x-ms-traffictypediagnostic: BN7PR08MB4482:|BN7PR08MB4482:|BN7PR08MB4482:
x-microsoft-antispam-prvs: <BN7PR08MB4482369422C121B851BE1710DB8C0@BN7PR08MB4482.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(199004)(189003)(9686003)(66066001)(55016002)(446003)(99286004)(558084003)(110136005)(86362001)(316002)(7416002)(2906002)(6506007)(6246003)(476003)(102836004)(55236004)(186003)(11346002)(26005)(76176011)(7736002)(305945005)(74316002)(52536014)(76116006)(54906003)(66446008)(64756008)(66556008)(66476007)(66946007)(53936002)(7696005)(5660300002)(3846002)(6116002)(8676002)(486006)(81166006)(71190400001)(2501003)(81156014)(229853002)(256004)(6436002)(71200400001)(8936002)(2201001)(14454004)(33656002)(478600001)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4482;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Hj1J/rjTnkIy0MkU5zEAZUgTPhcCdA53nu0OzgFGIA3dNrBcvSf6H+qprJ8gB5jPq1UkM//bF8bSkH30fFta4i7NbksqcHEyDQs+W0SZtYVSkHOzXvMzUnZuM3hVKmZGlYKSmLqJZptQlhcDu4VovjKOrpmUyeQBtI1hGrcCB6yvulrqkQ7y9GAxnmDWB/zsNZvJCpwCdnogS9BHrQ1Fi/WAsB+uDkvW8Eiu98WGr7SmWPp9Bei+xgaJ7GddbBS186hyLRPzSq5Bc0ZrQfKapI3vUBLCUd1AOKUBAm1U9GKGLsVlML7l4CIegK7xMg0nKTUnsEJaSRJI54aCkZoiBYqge5E6gsZsSqIvbMKWh1AD4vpz9ZmAjAWkeHloeC7Aosu4GVUNR9dtKJmSY+o3xeaT+mo8f4A3AZIrITxXnsA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d4f1a9-90c5-4fbc-6f4e-08d73aa205a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 12:33:04.9048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LL98TBqr1xooJLv8PIjqlouIOEHaYN8Xta2UM46oNiyYc5LDVyLlwCy/zIcyfNmfPlJBeSizqhAK5/NgHpOlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4482
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
>Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

