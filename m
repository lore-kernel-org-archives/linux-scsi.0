Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A71C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A034E21D81
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HFcEgAQf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KiBrnnT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgF2Sgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:36:42 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31221 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgF2SgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593455766; x=1624991766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bY+SZtczHU3c33F6laQkwuv29tvfwdz3QtC8uJNahfk=;
  b=HFcEgAQf8Usg5ZDq6+ttjHpPZlxQc9PPoNi8CVEiu9GWaRw1Z2zqYfP/
   xCssSR1DlIhoC9Yd30WisTPb5ep7pxKt/UewbRt6CYYShoKcPsGdjN6XS
   8uEEN/uZJHJZGfDwar8kVogljF9bbRsNhUBkPGYl5Img2HsLOZlZ7Nirm
   N81yH2Xy6PPFN6wfRdURB5EAiwbyc4KoF37wR9tlSA8ZfLn59VzzmuryK
   G0pHBcCSAE4cbUxnQHsqfdT5q6qB6S9Hi9fRuoy43W5aeOuUiVpMdVI21
   tyM/o+sejuFvScndmw0yq7iHq4etpMnKn5vPRuPxVXqvMtFz5a8UTbU2d
   A==;
IronPort-SDR: SJZXJZxzanSyf8egSHiHxFZTNAJDIqZAMOIWdeysYyoBEzF/+mHjLqfeNSw680rQb9nnjxTBli
 bBibRcD+IwSk7sAGToo1dbLSNoZR/RNoJIM9BnCdq7saBv/RKtlwFtwM3wFbdUciH9Kzj311uZ
 XZVSxVSzbKqZBSHu/ZPTH1OCB+Tn/9SAdR92gpl532suyecLKGDfBXUXTaemHCRR7CoHD99yYh
 +IKvZEpvB3oUFJ2qFS/z8iJNqUww+xD0SnLb1Y2w5/HA9ceSjHl4FD8vB9orHzul5bIXBGJhNj
 r+w=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="250406275"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 19:06:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRlb6dVmSU5IfVSJD5WYPVciJiTds8rfFbEL5hl0LJ+LSogq2qJ23oSLDnw0LgVkh4Q4NOfQiIcoXOlGmOAsgHLwOO6hzMAo3vH8cH4sI8ydQYWtSsEynA+BYWmld6nK9hxq/Jq0+yLLS+nRS5/JT38bG5/3ABk1lRyXg7pTONJUju45sqO+08K7GnbWdRuJHVMgJD2T5h4CAgWrxq1Iqhe8shQazWzE45vCWNZhAyX/+0+4S58vWxvisCdv3z0wamqyax6EjAPO9+D4exlNUNYHiFErmG/fGSMyDqPLPrfo8BD2UVY1NBGXUM43NTG7XHevHO4e1uCgtnc4eCNuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY+SZtczHU3c33F6laQkwuv29tvfwdz3QtC8uJNahfk=;
 b=NhvorEAWWhqdF8rb1R8OQLEHEilApbHGUxzHRM2fmpC4iYcbz7zMkeg8o66f9dLvkhJf0bylsBKH3yq4q5+8zuq5DT28Y58paksqYclBjbxNAmozRV+JZNttGRMUEpDyYsUx1jzIUKOT454U05MskirVXrfLwg8VAtyUipeLM17PHhvYjWh60k0vQLLAMt7Pnsrh0Db5Oz4uD1VmH56YYHOFbiZQE3cfLqEoohzmLE+CFPW7ezmgzgAg6RlNzEDqhv3f5d4VUGqitlQXFxVfcAXhuElBl0b3C3O/PFWNo1R4BdmApu7i+Qtd8zRk7Ws6cXT/dQj7uhqpZ5gP7yP7bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY+SZtczHU3c33F6laQkwuv29tvfwdz3QtC8uJNahfk=;
 b=KiBrnnT9unPMhQj3/08RhbYz/P47Ap7mYQfXYekHbLiATL0rnPIa1PhrCXisUubaFjDu86niP84ohNYZlXMK3HrTZf/UFW5dsU6x9zdParMLgvjd/3/OR0cPmQfLet4r3zJf4ZS2s18HTnDtkmImKX+gA4yZ7x1bUSL7GoKl+O4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4494.namprd04.prod.outlook.com (2603:10b6:805:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 11:06:30 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 11:06:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: RE: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Topic: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Index: AQHWSQaiS38tkGk5ikmxTYEvPlxKOqjt/IuAgAEaswCAAF3AgP///58g
Date:   Mon, 29 Jun 2020 11:06:29 +0000
Message-ID: <SN6PR04MB46402436A9E1FFE70967C444FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
                 <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <SN6PR04MB464004B3DC7FB046A1E38F43FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <94775ad5c35b68d457fdca5a6c89908e227d14af.camel@gmail.com>
In-Reply-To: <94775ad5c35b68d457fdca5a6c89908e227d14af.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: afe990a0-74ba-4fc9-d519-08d81c1c79bb
x-ms-traffictypediagnostic: SN6PR04MB4494:
x-microsoft-antispam-prvs: <SN6PR04MB4494C62B4564DCC7277EE454FC6E0@SN6PR04MB4494.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /2t1X+ixJqZJ+P8FRns9hmIsjpcM+oEZc58qEqxJFAiL6crmCq3I/gYj5QjW7oItFZogn/IbheTM5eiN9GESzftRSVC+ECldHm18w8ElDgCCzP/DTgdriofFFULi5aUfGJM9haOgGH20Bkb/fPXbGZstpljq1ktfFlfoD3Hz6kjT9VQdIQRKEMAkDfFQhWB8wqkWIlqF68pFIxMvaT/jCDAa+3eA5SZunkSRNfq3waOoWPiRgtdzi8DdyIglZX2UBQ7uN45iU3JXKYkOLHT+d1a/SHIdaSAJ3U6IcK1K023peqsRlhwuge0t1hdYKFEAfhj8GpIWO32zM9H1bP9TLMe5X7kbes8ENm5JlREpDE12CIxv7w7MQ6Uqe74W5vW6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(8936002)(33656002)(8676002)(316002)(52536014)(478600001)(7416002)(5660300002)(110136005)(66946007)(76116006)(4326008)(7696005)(86362001)(186003)(55016002)(9686003)(71200400001)(83380400001)(6506007)(66476007)(66556008)(64756008)(66446008)(26005)(54906003)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kcWNCIpnjVmpMgAimM3qIG/TH8tT0klCaIr1x+JSmuqhRtDWVmXKMiQuECAs3+WSDtlVED4BdJjHlecF5pEtVxMLOO0St/YqroVtYlJkWZ9xdKgWnMfmwntZ/dgUKic5VhhfNc+djZyXGxolTNTZmd46RLZcrK+Fcqnd0CFIrZKwgsHDsaPh5pWi9YTc+vl81u1iM+ztA/nt+ovidFkVAaJwPn8XLvNLNtyDJlyBgjsOMTVLvcc5MmxcpUe4cmM1K/4Bpmc0aJW5Qg+k+uRqmDeOO2sZNkULNHMB5EDCw2Ds2wTTSCgqsq15Yg3Y+bZ/EMJXqC9rlOxtn7QquDWwVNaoTolu3qCyczn0pt4LB/IRUwhnBifg0YCemvZsFT5gQqLwNvlParR67i9YkX5xEELTojH5CYAiIrsnFThldsueMqL8vkec8nCWyFj5VU2popy3lDGznSVs5pYL2eYj4xprnRV/ZYGd5L3wV4O8uFE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe990a0-74ba-4fc9-d519-08d81c1c79bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 11:06:29.8830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yur1rBIKle3dU2Sz643Or3JUG/Zl4YbLhdxSGnzZKlOwESELUYgBzb4UVKiVpFzbiTS2Bdq/c5d0kxv8lWcMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4494
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IEhpIEF2cmkNCj4gDQo+IE9uIE1vbiwgMjAyMC0wNi0yOSBhdCAwNToyNCArMDAw
MCwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gSGkgQmVhbiwNCj4gPiA+DQo+ID4gPiBIaSBEYWVq
dW4NCj4gPiA+DQo+ID4gPiBTZWVtcyB5b3UgaW50ZW50aW9uYWxseSBpZ25vcmVkIHRvIGdpdmUg
eW91IGNvbW1lbnRzIG9uIG15DQo+ID4gPiBzdWdnZXN0aW9uLg0KPiA+ID4gbGV0IG1lIHByb3Zp
ZGUgdGhlIHJlYXNvbi4NCj4gPiA+DQo+ID4gPiBCZWZvcmUgc3VibWl0dGluZyB5b3VyIG5leHQg
dmVyc2lvbiBwYXRjaCwgcGxlYXNlIGNoZWNrIHlvdXIgTDJQDQo+ID4gPiBtYXBwaW5nIEhQQiBy
ZXFldXN0IHN1Ym1pc3Npb24gbG9naWNhbCBhbGdvcml0aGVtLiBJIGhhdmUgZGlkDQo+ID4gPiBw
ZXJmb3JtYW5jZSBjb21wYXJpc29uIHRlc3Rpbmcgb24gNEtCLCB0aGVyZSBhcmUgYWJvdXQgMTMl
DQo+ID4gPiBwZXJmb3JtYW5jZQ0KPiA+ID4gZHJvcC4gQWxzbyB0aGUgaGl0IGNvdW50IGlzIGxv
d2VyLiBJIGRvbid0IGtub3cgaWYgdGhpcyBpcyByZWxhdGVkDQo+ID4gPiB0bw0KPiA+ID4geW91
ciBjdXJyZW50IHdvcmsgcXVldWUgc2NoZWR1bGluZywgc2luY2UgeW91IGRpZG4ndCBhZGQgdGhl
IHRpbWVyDQo+ID4gPiBmb3INCj4gPiA+IGVhY2ggSFBCIHJlcXVlc3QuDQo+ID4NCj4gPiBJbiBk
ZXZpY2UgY29udHJvbCBtb2RlLCB0aGUgdmFyaW91cyBkZWNpc2lvbnMsDQo+ID4gYW5kIHNwZWNp
ZmljYWxseSB0aG9zZSB0aGF0IGFyZSBjYXVzaW5nIHJlcGV0aXRpdmUgZXZpY3Rpb25zLA0KPiA+
IGFyZSBtYWRlIGJ5IHRoZSBkZXZpY2UuDQo+ID4gSXMgdGhpcyB0aGUgaXNzdWUgdGhhdCB5b3Ug
YXJlIHJlZmVycmluZyB0bz8NCj4gPg0KPiANCj4gRm9yIHRoaXMgZGV2aWNlIG1vZGUsIGlmIEhQ
QiBtYXBwaW5nIHRhYmxlIG9mIHRoZSBhY3RpdmUgcmVnaW9uIGJlY29tZXMNCj4gZGlydHkgaW4g
dGhlIFVGUyBkZXZpY2Ugc2lkZSwgdGhlcmUgaXMgcmVwZXRpdGl2ZSBpbmFjdGl2ZSByc3AsIGJ1
dCBpdA0KPiBpcyBub3QgdGhlIHJlYXNvbiBmb3IgdGhlIGNvbmRpdGlvbiBJIG1lbnRpb25lZCBo
ZXJlLg0KPiANCj4gPiBBcyBmb3IgdGhlIGRyaXZlciwgZG8geW91IHNlZSBhbnkgaXNzdWUgdGhh
dCBpcyBjYXVzaW5nIHVubmVjZXNzYXJ5DQo+ID4gbGF0ZW5jeT8NCj4gPg0KPiANCj4gSW4gRGFl
anVuJ3MgcGF0Y2gsIGl0IG5vdyB1c2VzIHdvcmtfcXVldWUsIGFuZCBhcyBsb25nIHRoZXJlIGlz
IG5ldyBSU1Agb2YNCj4gdGhlc3VicmVnaW9uIHRvIGJlIGFjdGl2YXRlZCwgdGhlIGRyaXZlciB3
aWxsIHF1ZXVlICJ3b3JrIiB0byB0aGlzIHdvcmsNCj4gcXVldWUsIGFjdHVhbGx5LCB0aGlzIGlz
IGRlZmVycmVkIHdvcmsuIHdlIGRvbid0IGtub3cgd2hlbiBpdCB3aWxsIGJlDQo+IHNjaGVkdWxl
ZC9maW5pc2hlZC4gd2UgbmVlZCB0byBvcHRpbWl6ZSBpdC4NCkJ1dCB0aG9zZSAidG8tZG8iIGxp
c3RzIGFyZSBjaGVja2VkIG9uIGV2ZXJ5IGNvbXBsZXRpb24gaW50ZXJydXB0IGFuZCBvbiBldmVy
eSByZXN1bWUuDQpEbyB5b3Ugc2VlIGFueSBzY2VuYXJpbyBpbiB3aGljaCB0aGUgInRvLWJlLWFj
dGl2YXRlZCIgb3IgInRvLWJlLWluYWN0aXZhdGUiIHdvcmsgaXMgZ2V0dGluZyBzdGFydmVkPw0K
DQo=
