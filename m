Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DC2C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 07:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D595206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 07:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ThsSsJ5u";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pNOxsnou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfLQHiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 02:38:12 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32230 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLQHiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 02:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576568292; x=1608104292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=plvsS3EbFtnT2jEj+CKpl0ADN0AY/rYgqgK33djc6Jc=;
  b=ThsSsJ5und/hITRwoVsfTpDLbvdP3KUiOyQ74saiUGNSlmjdnBSiNTbY
   cL+BfTDFNPusQpEvNSWOzn3RD1co5v4MB4bQ059R11yLrg7kz4UWYL4Dj
   JCuY18P4CNK2GwDuV2pMgIh6HlgtQVfEhJ1HrdRGe5roSBDWcLyOdtkiH
   5BFt8U77RPPuZ98qY33W5q/6b5lU+UKZjOtlmlbAkjNPH4uZO366Xa7g6
   BMQWFIcBpmcSOzfGwX1+vhULctbhYqy9afupIHcBV1hSzCRlgWiP1uGeb
   5sIXW+zAtO5v7pg+5PQVTVPpWWb6ko5pJdUtXPqj8iU+UYM2R1CCIzYvA
   g==;
IronPort-SDR: hW5mPVhkRRnuUCvCMhZL/pkSWE9B3p0F9jZF9DArTQFAjqkvOlkIJcFfSEt0CDDiO+7XPhfQ6s
 SETxKEFCzNuZsMw/FaiWhKIV88koHQiYNdasuiLRS7Mhu5UtmH0HjKneVU6I5zpKG0XoGtrePy
 aaO8WcV8MGrz1odPB4HTd5nQ7jlX5ZEWB+/JVMoc3x30HyAcz2kyUA0emeU2U69frZ61yS3yIy
 HErVqu5nMfz0fiJC7m42NDyBOdxixbTvQGwQGpYxv60myGW/qVtlGMZ+tGiVpjl59coyfFx+//
 XEM=
X-IronPort-AV: E=Sophos;i="5.69,324,1571673600"; 
   d="scan'208";a="126294481"
Received: from mail-bn3nam04lp2055.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.55])
  by ob1.hgst.iphmx.com with ESMTP; 17 Dec 2019 15:38:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5cM0ttULvWSEHlr1Xb4SsZ96clZCL1mKfMLunYK1ff6gxqyivvNkT3JF7Yb9PVlcCL+DEa1CXB05JNYQMGrYcjon/EGO54mkfwNnl20wHgFRR3XLbxja0+bsoXX111Gfigs1T7a0w49C9YW04iGjZQSgrQV3sGLeh0diAeVwYsD5uB9c1bZWhjkhZCfCEzjYsz7PDx6pCGRMASAqpwn11j23aW4YS5+LG2vsoAFAdHJIrWaiyT6KnRbYEQwNLYCwz/fE1YblhPBjZ7ijIZdDo6Ak6QND+IIruQ5C94u36knzPSSgyVEbr75gL0T5RFNAFP913skhO1TF3Vqcv+uOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plvsS3EbFtnT2jEj+CKpl0ADN0AY/rYgqgK33djc6Jc=;
 b=C5M2sFfb6KrcgkkZxgNVRmq/mfsNSREATxBK2wfgVEJ+kkLJqOLeZmjCdBlXLIvYfw8mDRoB8X1Zi1039r6C+EG6GVTb6erVXtPcippXL+r4dMmEGyZODOePktcd9XJd5S79V+yROzuZUNcFRGG/TeljyznWBPgIDnj6WOy8DlUwPmh9UgWfLyfgNWzK66jifzqXw48xBHPJXAtU+gaw+xKJ1hD+wDmE+rqiCWmYMQO5xbAbRFMgnGRmxzrGxzCqbR92QKgm2bdA1HeopfQlHrvVysU0qJW1rkHQvGFqTKnHctzFzwxMLStBE/dmoWgFqXBGP6UwxIfyWLKJ+/oC5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plvsS3EbFtnT2jEj+CKpl0ADN0AY/rYgqgK33djc6Jc=;
 b=pNOxsnoucfZuVGYer8avxZbKK3LtETglXa49mUYZhjo3Haumx8gsFpShMp00s/IWs5PF7vwCU+hXQFiG0976qc56HiD54OL06jUPAqo/BgST1tkJ9IAmeiJIHvsV/YwG1H6tnb6QeRtQey++6+/GJEfgAvUYSkQOTerVIC2M3Ts=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7104.namprd04.prod.outlook.com (10.186.147.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 07:38:09 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 07:38:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 0/2] scsi: ufs: fixup active period of ufshcd interrupt
Thread-Topic: [PATCH v1 0/2] scsi: ufs: fixup active period of ufshcd
 interrupt
Thread-Index: AQHVsV/LOTQTZ9v6wk2kTdk6DisVqqe99tMg
Date:   Tue, 17 Dec 2019 07:38:09 +0000
Message-ID: <MN2PR04MB6991F22FCFF3BDEB0EC7713EFC500@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
 <1576205295.12066.5.camel@mtkswgap22>
In-Reply-To: <1576205295.12066.5.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ccca7b09-5bc0-46f4-ef1c-08d782c41040
x-ms-traffictypediagnostic: MN2PR04MB7104:
x-microsoft-antispam-prvs: <MN2PR04MB710445C8B9E42A0CA8B38E98FC500@MN2PR04MB7104.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(8676002)(5660300002)(54906003)(66946007)(186003)(8936002)(81156014)(81166006)(26005)(33656002)(9686003)(66476007)(66556008)(64756008)(55016002)(66446008)(52536014)(7696005)(71200400001)(86362001)(4326008)(110136005)(7416002)(2906002)(316002)(6506007)(478600001)(4744005)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7104;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ihigtQ1DYwDR+CVbkxOumRW1C62PStKncC5mtDeRoTaXBfCXqEx3fwyTBIxRHDXyXOnShO26A76CmaO3deaemoF0hDFZnDtf2Ooe/Ta9xeNUYmFWPA9bbIoCShg03cpffrC7qJM2L73f1/7YjOfHi+48E4QaKji/4i8VDlgMGgVWnngAW7haY0APAcJEWPQ60Dw77PeNM8pUGnZcFjR0GdfYZzqUC7/6K/rV/+3jeeNYvImWnNknhGmEpOFklEyhkMwpUPW+y24yARvd6+hQwPQW5r+AaeIzRq2nlduJY34jROjpqe7FwmeE0lfO2a70Ji8KMS5XgcCyMg+pzVUBvj7fLpP2/103KYSLiSeYxY9no5Pmlz5vfxx0JXiIDqYwJAPbZsyAwLccrZ5OCSpo1qzw2zw1ko1pAMHosvBYc7YZPFSCtBJbS5YY3209sjlP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccca7b09-5bc0-46f4-ef1c-08d782c41040
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 07:38:09.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Q0t5ia0HS0vCL+itKWgQ1qRbyfOzN4kaGkNSi8GwR6rUvjdLPSDjMJ0hITVMdzgk2y6WXcUSdDD7X1JkIl+Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCB0byBtZS4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5A
d2RjLmNvbT4NCg0KPiANCj4gT24gU2F0LCAyMDE5LTEyLTA3IGF0IDIwOjIxICswODAwLCBTdGFu
bGV5IENodSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoc2V0IGZpeGVzIHVwIGFjdGl2ZSBkdXJhdGlv
biBvZiB1ZnNoY2QgaW50ZXJydXB0IHRvIGF2b2lkIHBvdGVudGlhbA0KPiBzeXN0ZW0gaGFuZyBp
c3N1ZXMuDQo+ID4NCj4gPiBTdGFubGV5IENodSAoMik6DQo+ID4gICBzY3NpOiB1ZnM6IGRpc2Fi
bGUgaXJxIGJlZm9yZSBkaXNhYmxpbmcgY2xvY2tzDQo+ID4gICBzY3NpOiB1ZnM6IGRpc2FibGUg
aW50ZXJydXB0IGR1cmluZyBjbG9jay1nYXRpbmcNCj4gPg0KPiA+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jIHwgMTUgKysrKysrKysrKy0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+DQo+IA0KPiBUaGFua3MsDQo+IFN0YW5s
ZXkNCg0K
