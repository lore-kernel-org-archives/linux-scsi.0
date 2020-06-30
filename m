Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D3DC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 12:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 720CF20774
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 12:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YGf7s1yy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IziXYQCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387658AbgF3Mie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 08:38:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40010 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732042AbgF3Mid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 08:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593520770; x=1625056770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2PNyVL7gwcOYL9Psk9Qn0UbkT0EA0VEIGeWY7rppOos=;
  b=YGf7s1yyFb3aQNNNBQG02RcaC+kjVfe+YX/nbT/oOSyRJfUn4/K1KJov
   potLvxySwCxOmcZoAuWYzN8Gt9cZy8cUb2tMcQX3YU80bYpQdusOBaWcF
   4+HcJC1dk0gkd3zDmYE99tPUNpcdD3wZalBXLDnN608KbwKvlJyd4UpPj
   cjcPuh9bNwSgn+smzKaFJemJHed0nQgXrSsK+wyblF60RXq1YB9nhGAN9
   UEdinXbso0BgMSb2LPMtcr4kxaGRitZURYZHrRbGnGS9ZVZ5uL081DDeT
   dL4cb+Rekh4ZxEChryPSwnxgjbMeEiL9F195xDiPHO5GzDSqs+g2PjKfo
   g==;
IronPort-SDR: acl/2xYE7j2uKDpZ/Ws7WR4UWwyyqL3YR3Ub6k9fPPafWXFt6w9uk7qOej+UQ4KoQBpjJ1hb3U
 2z2s1RM1wrkLdC30Z90rfNquMWCLXyubeE7MrBDazNiS9vN0tKHMXALzvMDbyDBd0bQKk8IDUm
 sVdt/FphqJeCP0wXO+EQGfGbx6ULhAlbKalsHv13IJB4i984JVU3kKw821B2rOz7nmIWi1E7wE
 X7PZehZhZGtCJRwBqOZRLPzgGRyl8moS3zzj8xuiPE7nJRu+Jj80CSWwn96LgAfMsXllKZGixm
 8fE=
X-IronPort-AV: E=Sophos;i="5.75,297,1589212800"; 
   d="scan'208";a="244296632"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 20:39:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6N3vPRvVH1/EZrj+wECcsDAfiNDBANzzhILgMxqBNnUH/OnUmz2LCJFYgaGeNw2LAtTgXD+Nojn6tHAVY4v3r13iUlyEvaAq0XVdCeFV6hj2dhFcqF/hLv8/voztFpyQjEVWnO09NpHhCvT02Vhpky1zNWg4Z5UpQt54WL+d41lena+IZOPbuyvJdIoSJkhcS4BYuc62lOpnDe3hCIGssM7CUjakDWnoL5lH1kIgQoeLptDB9a9JrMqL6AOiD5CRrhnpjPWoCrqzPkD4tqgZPiJURUI0FE+xY5KqYaRT2ZerLw1XTUu60TPAmnqcKD14tHec7M9oEnYO0AL48wYNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PNyVL7gwcOYL9Psk9Qn0UbkT0EA0VEIGeWY7rppOos=;
 b=nutT3G536WO1Y4zXYKAP2OdkdKUjHf2O+YbWk7VanKA7ArztoRCMK65ngWqzOidvIwhSsD1YJ8eG0zi95AZQbjuwUm2ESw8j1gB5O1Niujebu139HX8OpxSlh7pXxaY79FjF4bZoa+PXysZVPG9w3cnZYa8iVOWXtSJ2zSpoTY+wX0dbTteSz8BlsdTcsjawldLNvQmmxA/UNRX4JJOLXw+wPBt3JwJC0yE+rJGyDy+bcAaiqwTFZUDYXsDIhiSAIq//DeaRRu3ATyIfHDEU9wfp4BhCIKkwMfaZAaj9ZNcIn/GZMAxtS3O+0sRbxXsld1e6p6Fpky4D4pgtNU9HZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PNyVL7gwcOYL9Psk9Qn0UbkT0EA0VEIGeWY7rppOos=;
 b=IziXYQCo5FnKll5zeeNhW80z7lGjbZuB0RDYYk4ycUZv2Sz1tD1Z0JVEgakkePQsxUBQd1xcTRfmBvHRWPbsly5Hv1yIrMoCZ/eTjdM4zByT5D9K77aG823NL+Rt+JvBMC2v5g79oBOFufRiwPkMfWk2Mk8wK3vknZ6p8chFSLU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4431.namprd04.prod.outlook.com (2603:10b6:805:32::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Tue, 30 Jun
 2020 12:38:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 12:38:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v4 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [PATCH v4 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWTeKmjJyOGQn/TEmC8bxO+BaniKjxGeAA
Date:   Tue, 30 Jun 2020 12:38:28 +0000
Message-ID: <SN6PR04MB4640A27B0DCB321B165D59F0FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <963815509.21593413582881.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413402991.JavaMail.epsvc@epcpadp1>
        <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
        <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p4>
 <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
In-Reply-To: <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 809ab6e5-ecef-4ef1-767b-08d81cf27dab
x-ms-traffictypediagnostic: SN6PR04MB4431:
x-microsoft-antispam-prvs: <SN6PR04MB44311C388BF40DEF7A85892FFC6F0@SN6PR04MB4431.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d20c+lzf6DOuwD2zVe09LLWzfonQExaskTZzGGiRo+nrlPwx7JPaxaM4UYxbzCF1jTrDoepaeuxsUxe0yDq/ZoAk9p+kAeyWLba+QdyDHuIoi+LSoIBa6KP2Xz7qHzjAqAuE8IisWGGYGMUvNvzfRrpSIfdK+6f60jxgFri7RI/c+PypjOOwOMrMN4Rc7MPBHTEWzmu3CWJ3uooKw589NOf0uFKfN5a5UCOaEwbLH1qWCuA257aumAHJSK6dgqSHbsv17xMS+frZF6SIwFU7wwjjSvrLPtgNswkbIM/t/Rg/nxr9KoWbcbaob/By5hXFFEDuVCWs+sFUM5tF/sZaGT/zIApK2v23sLlpL9EKalnV7zGP8NWZcZhu2JYi0LQP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(52536014)(186003)(4326008)(6506007)(478600001)(33656002)(4744005)(26005)(7696005)(9686003)(8676002)(55016002)(83380400001)(5660300002)(54906003)(76116006)(316002)(110136005)(86362001)(66946007)(71200400001)(7416002)(66446008)(64756008)(8936002)(2906002)(66556008)(66476007)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zP31iOlf6M54vxp0dCFC7AF64WL5UmOc/H88zd83QZAXNceuJegqM75+9xR2LIE876DMXm7A77EoejVMqv2u/Ztjjw9FkiXVeCjKItlgmkaZEeh01I2/dGeRA+dO0Kg5PtbDqcKFao1gbZQxvgnFRaLdme/+BOyUnUXWeXH+8w0WPJ39hPE1bSbg2sQJmg8zbiTDZy43aGnJkZ1VUPuB1iX2A54S4dYw0966EhWA7/1qjon8IjHYUdDuwMe8Ljo53yRtVCc4SE/Jqyfmb1k58p4PgZzaTHW2Y8vCOseBUxrk5fNGDv8+rkaKGJIrBWoe5X1f9ZJJ1H/0K39DM0K4Zpzmx4iFt0O6Pt4RtR+d3a6lrrxNnki5zRpqWop25tjyQ7tefY+7FqRvYdC0KQjKS8Bp9cAxu81quPsngD/GBFMVcNEucJtubOEgomKGwp+mtEcWH1qJ8XBiH86Fp0qRcz0AeBmYRgguiv2b05Kgg6o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809ab6e5-ecef-4ef1-767b-08d81cf27dab
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 12:38:28.7708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3xpuNJs3TRhV4i+VyyQNPgU/LwB1S5XthNygQLuL1ut9azepfPedp56FPA2tzyhUCH8gJkfX7s9tg8Zb2JMuZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4431
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIGludCB1ZnNocGJfZ2V0X2Rldl9pbmZvKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdWZzaHBiX2Rldl9pbmZvICpo
cGJfZGV2X2luZm8sDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1OCAqZGVzY19i
dWYpDQo+ICt7DQo+ICsgICAgICAgaW50IHJldDsNCj4gKyAgICAgICBpbnQgdmVyc2lvbjsNCj4g
KyAgICAgICB1OCBocGJfbW9kZTsNCk1heWJlIGJlZm9yZSBkb2luZyBhbnl0aGluZywgZmlyc3Qg
dmVyaWZ5IHRoYXQgYWxsIGRlc2NyaXB0b3JzIGFyZSBpbiB0aGUgcHJvcGVyIHNpemU/DQoNCj4g
KyNkZWZpbmUgVUZTSFBCX1dSSVRFX0JVRkZFUl9JRCAgICAgICAgICAgICAgICAgMHgwMg0KU2hv
dWxkIGJlIDB4MDEgZm9yIEhQQjEuMA0KDQpUaGFua3MsDQpBdnJpDQo=
