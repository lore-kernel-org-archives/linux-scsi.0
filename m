Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854FAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 05:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA072070A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 05:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XS/TdvxK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j8Fqdnxp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgGQFZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 01:25:03 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:45529 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGQFZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 01:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594963502; x=1626499502;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kMFY+iFINV2UkxWA2naAspyqveyH8Udp/5aG41Wqrj8=;
  b=XS/TdvxKcjGZJtVq6MVEHK0olzjbAIrU9SFQV6i744q1jKvzP5650ylY
   1QM1Vf2vsNhnFWEoOsZHRwjTdIO9eTw/9DTErg0NTTRBJ/qL2l/kltNre
   3jCN06zp6oMxWsNCy7aWliKKOu6bdPSkq9vvgpuy3s+6Rs30/tqkaH4cF
   r5eNtQKhMKd17AEWB1X3KosD4pTkkMcRfYNOkaHfeGXgOgj1mJg4g9hXz
   pMRXa6zvyfDbWiJaqbr8c3Wz8Hi3NZ9F4HbKNaYSg0h8AvA/SetnchPRI
   Srlwhik2qZo9JPyQh+64Mb7Egw623vLwMG5uu4U1dxmtN6WzE/3L3bmwV
   g==;
IronPort-SDR: mPNl/SfSv8NS+fyrIhlYrLq6J0Wq/IjIzWjVO3cLOJVBCBXw2o5jUAeJsL3KGyXBeE+kM2JgdV
 mRJvfucVXk/gN4dTvrXJqqdU4lj/gPRhV+EHDHOS/sIZIgGxHPZtwJg0Jk3BdZJ/icztGjiijH
 cVSJj1RedG92KhvOjcPnhJAVtDuVTnQ032mB26TvWKyBtyTNtPaE0i7HiXCVLexgLdAyxNXZRw
 WmjqUTxWV9ugLCVsFOB+djAHRwv8Y7UIV0jiujPhLFYqBbc035LvGICGDvGvciV4ZXQ+XjcA2u
 MHI=
X-IronPort-AV: E=Sophos;i="5.75,361,1589212800"; 
   d="scan'208";a="143974611"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2020 13:25:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKAbyckqBx9yMxlkZhpfjLZ9d32otWdclvNo8YL7cuUniT9QQgTl7HqAx2zA5lHdo+95iXeMQRNduPavxYBJMEfycErsW7Nel9yz4vdxlJfJY+GPVMidv/f52XLAuK9U6Enyxhx7lftxyUURgXrA/8A7aYxUUSQiZej8wr79yd7jEP0GNKgHUlSTFr1EpsfqtyCLfRb45QlFtbT+lKoXIEncs7tmENXFYSF4YT+GSey3qsM5KKHNkzU493g7lgJfugdSCIETLnDJhFK66vvb7TKUVNxj6YT020uABfk3oNgAWPrLlGOyVx8f56awgdnaIGu1AeJhWsc9J+5pUTowOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMFY+iFINV2UkxWA2naAspyqveyH8Udp/5aG41Wqrj8=;
 b=CEicl4nIwPAbb9oIwXJQ6XfKa93MWxBaXDLFYMNmx6ZTncvrSWpm4MzQ6K4AsrWrfCW1pW2dG7OyF6PsOKugm7b9KA6tIv6Y7XJb+5uizygCME0/dppDsATJuMjnpyXEYkaj9fdmveWeuatY/uKkFp+K+avoUwxHQ6qgxfIxbVp9gEWhAFQ7wsf7Yu06/C56Uo1hRqpQn38f/xSPuclK04T0tT9UQgV7WReF2ky6gHSp8LFcpU+gad9AEUcsvtU92KHjIRWFvD0XBBAVE0foyE7iU0ehQ600ILh4iu49G7IM1CC7d/6feJRuxMZX35RNNFicUPGBMfHVtSoFalMIfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMFY+iFINV2UkxWA2naAspyqveyH8Udp/5aG41Wqrj8=;
 b=j8Fqdnxpqvdb77I/KMK9JGAJapZvNp+KFmftY2r55vQbXFWUEGRCMnt52nNSfqtBWB+m9Irc2mpcT2ZuQ7J2GzgeOksaj2PylTVH0cJuJsBf2uNSh+xj/skGddp8c4C9gwAZ6V5NSRLbFf2Z2pG79qPug5u9raI36pkbw6NwQnc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5358.namprd04.prod.outlook.com (2603:10b6:805:fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 17 Jul
 2020 05:24:56 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Fri, 17 Jul 2020
 05:24:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        'Sang-yoon Oh' <sangyoon.oh@samsung.com>,
        'Sung-Jun Park' <sungjun07.park@samsung.com>,
        'yongmyung lee' <ymhungry.lee@samsung.com>,
        'Jinyoung CHOI' <j-young.choi@samsung.com>,
        'Adel Choi' <adel.choi@samsung.com>,
        'BoRam Shin' <boram.shin@samsung.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQGynHMGu/0fRkiVvG9Dpk1z6KkJaD4AgAHaWnA=
Date:   Fri, 17 Jul 2020 05:24:56 +0000
Message-ID: <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <077301d65b0d$24d79920$6e86cb60$@samsung.com>
In-Reply-To: <077301d65b0d$24d79920$6e86cb60$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d9faf3e-90bc-416d-0b24-08d82a11be1d
x-ms-traffictypediagnostic: SN6PR04MB5358:
x-microsoft-antispam-prvs: <SN6PR04MB535839F10D281EEFD0FFF7FCFC7C0@SN6PR04MB5358.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M2i69ZhrmTpfUenM4CFyUOK71dh/0+VUJfJTGiUd9cOqldWx+MZr5GkNDIFhCXwSdQTcThFDRvhWQkFrYkPqe6zQplsZu9sNq92Hzp52WZuAZxR5eDBaArFdjmkURYy/4MUNMZZp68fWjd+2I8ldnx4DZ/c7sJ2r60mFZivqNvLW3FgkhuAlt0nrhwldzq0f34tt5b0EFpziGEHIgeDQNlE34Dqj6x8DPb+VNv9XtBi/JoSKfTFU7DcHTkGgI2ZdTs8AK0qbhlQHDr3HE825ozPkKChJyOSpRspYPWvFhTNacppQnxzMBt2hX7qwCSFq3oSqg7jHx9XPWh/iIkIFb3tsq874Hy148qqRBnZ2eaDAZJ3aoonxopqAcelOACA7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(83380400001)(478600001)(86362001)(6506007)(5660300002)(52536014)(7416002)(8936002)(33656002)(9686003)(64756008)(316002)(4326008)(186003)(55016002)(26005)(2906002)(4744005)(71200400001)(76116006)(66476007)(66556008)(7696005)(54906003)(66946007)(110136005)(8676002)(66446008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: B0Gxql9yL8UTz5AZWDWNyYRTU/WComcBwXHpuO51WfSs5nOdxY1L2VWGIzXEzLTP71hVIHIgd089qPRT8e31xXEYzMmCPhUBdPfDd1XJtRClhvPSiBfD5DeC0eW6+g9hwu6S1fCIiKWf056LKLqU/gK6kDy+9UgPwyNPO/hm4qV6i81u36zRLdfVqU7+SRaI9J43dMB+j/ZqRcvZM+z1NpiEHtgwzcpWTbqmpAaqFY5tp0Hb6Zwt288yEc125PQ+XpxeGuo4+bMUBREwdiAKG845Zm7sCzg3fgcLSm289X/g9nyAcJfqy43blOOlFL8RhFuxuAzxi+akWWVCxol/FpwwBfIgic/GtX3GoKwKrAxTXQf/25z80SDvdFIUshhFFBdGeLUsr6plu2HAyMJBW9x9BDE709BkzsNNmTo2EmwxpAtjJBmAt3I/TyykUkWYArYXGJbyqMvy0xWvM3C6p2hblbkVjHZH3KJtqti0Kw8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9faf3e-90bc-416d-0b24-08d82a11be1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 05:24:56.3291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MB7tjo8LBWeDgE9HZm71R+MydD91xvDmaGP1Ni2uR6w0P/cXWYyRrey51yN5KXsvuHKDzy9q02uvBM4vkNPFGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5358
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ID4gdjUgLT4gdjYNCj4gPiBDaGFuZ2UgYmFzZSBjb21taXQgdG8gYjUzMjkzZmE2NjJlMjhh
ZTBjZGQ0MDgyOGRjNjQxYzA5ZjEzMzQwNQ0KPiA+DQo+IElmIG5vIGZ1cnRoZXIgY29tbWVudHMs
IGNhbiB0aGlzIHNlcmllcyBoYXZlIHlvdXIgUmV2aWV3ZWQtYnkgb3IgQWNrZWQtYnkNCj4gdGFn
LCBzbyB0aGF0IHRoaXMgY2FuIGJlIHRha2VuIGZvciA1Ljk/DQo+IFRoYW5rcyENCkhleSwgeWVz
LiAgU28gc29ycnkgZm9yIHRoaXMgZGVsYXksIEkgd2FzIGF3YXkgZm9yIGZldyBkYXlzLg0KWWVz
IC0gVGhpcyBzZXJpZXMgbG9va3MgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0K
PiA+IHY0IC0+IHY1DQo+ID4gRGVsZXRlIHVudXNlZCBtYWNybyBkZWZpbmUuDQo+IA0KDQo=
