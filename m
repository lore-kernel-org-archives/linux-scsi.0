Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D20BC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0076420737
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 08:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SSIg5TPQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AlJE8AQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgD1IO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:14:28 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:61947 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgD1IO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 04:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588061666; x=1619597666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QkRGHYrsz/7oBthCYDBDsCHu/K48SPkAyi4xGrHJuQU=;
  b=SSIg5TPQ/FothCxv8Les6JMvL2Z15sxImpnzARtZ0i50VYvgSMSLdEhY
   P8SNmwiM0mHwyUZMmvh8Azoc95gIewsm9/mcZMmP6d0Qt1VeNypKAm9XA
   /i1D5AoSjlXON0eA1ahIkVRPMldkwQALejmOxgz/p5564UgSdE0eP5+Hy
   3omnknYaDHGdN9H5ow4mQrzHUMiRi484YEGPpbdRhcTQ1wx4it30yGWKO
   3uYilZoekpPfaTPdsGpjPz3xQssthmTROgSefWnZGiXauYjA6sdiXJmTM
   J0a7wh71ihdbt7aLe4N/xvmudxzpLwfFZZmFaKaJYayFrbItoqEN5McVq
   Q==;
IronPort-SDR: 7pWPIUkvfBD5e3qPjlTfiL91RJ9F03JYyoHitm8YzaQM9PB4NqqJxuOd7c6/5Xvb25BpUaYqSu
 h9EzbqX5rp+xEC4dvHTimii3Rw4bhK90cfApz3w9+ano6NYzgZXwOrhPDifgkHuEEFSD61m7P/
 Sw4/FtQKfBhecit5IJcU6wg2bhqZqBqUy9vuzUGMP9jGYhEoJpzD2nxJ54+VEnLR4IX23FpFLa
 307tPqzKvhoFkoE1skCkFGuim+lm6L+ngyV6xqbTtKwJpEwgWHHxNn4AkIU4PA1JEuJ45F5ikH
 D+A=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="137758765"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 16:14:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9YDUmWk2NH9adU5nxrIgTGpImOUtof3XJGz56ImuZGSMe5czz9VZP5EmU+uX6zN4CCDYYQzzVKvWr49uYMZg/D7PGFzutktMAjOJ/QSF1/8u2iMXGMW8lpTY18NNmV9kOkrqrOpzNnzaHkolQv72ksMOgTTc9pRl5dE7eBWikbYGQ7CUnkOveRDwPUcntvMHB82ui8cQRvVw2Ia9rb6V5rAQ8JjpBP45Q+nPUXQVEX9Bz6bmfezsEDTkZAovtV/dU4V7xuYeQ1gFOA1wApEL5shOPIzUhKAKfgXTd4gs/GMYEFKJRKe1ohe/PWO9QALJzVoNqRROtPy6nf4hfqrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkRGHYrsz/7oBthCYDBDsCHu/K48SPkAyi4xGrHJuQU=;
 b=MdnJCQiAkCEibDChLXZnhL0kHum4shfGEWE+tuqXlU6NLKPl1o4FnTW+DCc5GN+x9n7+rX2FIiQmNy2aG5jl/ESJL361yMP7Mc87QC5qUWtxSo6rcVMrnub0bDs40feIwLOVHgbjdIb+CI36Vm+w9Jq0sPeGcCcis1vnDwRnyydqQkGnAy0Fpefl6drohLvfO4QMpu0frNOSkXR+HHwuaWsJz7OaExeTNjU1XMNqLdVD/RKp98RX5fUoXunlPoR8urJZv5jq1iQn4DQnK51ZJ0yYlHaCx8gJuq07k7ZHvAk0VBr/3ExzxMeFn2FORyOgaSKeye8dufOSZ/xS3P3+8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkRGHYrsz/7oBthCYDBDsCHu/K48SPkAyi4xGrHJuQU=;
 b=AlJE8AQA9zxFACJQ3G8H0OC3lZD4HM4CbHZqALdpkJ3Fr+MlLtvjdHkHJnUrYj2X2dy7qWZIC6cNqjKKZmIhdHdDuR2veSKpOQAoHaRMFoJRLfrM1adcBgxoqzJP8rq8dOapmlSJcDhYjT+yC6MhK9c85Tn3ty3CUejBycc36hg=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5117.namprd04.prod.outlook.com (2603:10b6:805:93::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 08:14:22 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 08:14:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnCAAPi+kIAAmSYAgAJemjCAAWl4gIAASG8Q
Date:   Tue, 28 Apr 2020 08:14:22 +0000
Message-ID: <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
 <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
 <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
 <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
In-Reply-To: <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b74d88a5-4d37-41fe-72d8-08d7eb4c2890
x-ms-traffictypediagnostic: SN6PR04MB5117:
x-microsoft-antispam-prvs: <SN6PR04MB511791F899CFC0BEB8675983FCAC0@SN6PR04MB5117.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(55016002)(53546011)(6506007)(7416002)(26005)(33656002)(316002)(71200400001)(186003)(54906003)(7696005)(9686003)(110136005)(4326008)(8936002)(66446008)(66556008)(2906002)(8676002)(76116006)(66946007)(64756008)(52536014)(81156014)(66476007)(478600001)(86362001)(5660300002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t4jXtaknJhJ3IQU2dLHTqid3TQaLMFpFaP+5AoLTyyuh6d/UfjUHnhLOKF0glsHnaIRbYskgsbs7IJhSpJU7YWbAwD/X4QTwxiJdc2bHnpL0ikZ8Nsuk7wKmX0uGxgBf5bQCzVHZ2JydwBbL2ME1T3ecZuUnniNy10SVFjHlaZsBmdz7aa1f5UTct41DpzewRl5EwqSy3h0QDZwnj/s7UQfx6CIJozejrXKOBPu6//7S9Xt+/+YLNiKZNROZLUIIOOFF/Bzn617r4ePZKuDOxKk9LvG6xf2CuHbbaJ5+aAXr3Rk0CCzK6JebX+1yf8Oz/MVmSbdoc+W0fKMRSzruArKC2v7kc06iFYauJvYQNwVew553x56K/tK1uXSU0jFkeUAmvRD8ztffgzMvynzyh9j+14S6go8fAyHnkRUD/Vsf01LckAPIP48geC/Cldmy/QXHk6vuE3sO+wlXHcTjoleGkWa/JfpH6B0Pp0+yJyQ=
x-ms-exchange-antispam-messagedata: hrhCdiyLAn/uvY34O+qHhpC5GdhISjYQYx0W0ij3zq+7aGfartVmmYT6FdAK+seh2oSnl9Vi8ngtqXe/AadCPBWdlpWLQq3ugR7y5EP4Mz7UV8WEzXnYvE6yuM6FfSh0+CC/CkawmWyiVTb3W3CGqRrexZBPNcACqZ3Q1QfU/mcIuVz4pqqKk9d9k5WlhgbPYodxPxld4Sf1B/VvA/m52wI7fQnAV1zIQJc/xCFCmojlFe0cwufsgGOeJRm/41yXFHo7el0Tj5ki8bVfPnRZdat/Mp3VffcaO3CGKZNc4xU7ypr8Mfs3NLFD8kRtfoS3eD2L4zyCZ4Pcfo1ShBft8obsW3ghF/9TflQD8EdAm48bANnbu0Jd+8n0jAACWvvEiF5d5kY4qbdnMr1eACN17L1s136Qte9Ee7NqELcnkm1z0dhCdJYqnBQe2wN+jgSdfoV4oQ6dGzSl1y4Z/LxwEjIzrfSzpCyJ1OoIGKS4JMOgKy/24wnUKLAlDhCeIWgYxOc/QSCHWPYN0W//NSlY1XTRHrTVJf3Ez2V7tr0UusMD8D6b6ILXNE4Qqe54Ou42dGbeyeEnzFANExmEnfzF4af4PwTMsSt/2MSpVnscc/wI5aXtRC+6dUsnDqk6ahTRoWjAum6K5tWU+PPfgYkSWsEDCQy+6E6ASOQyyrOxMHPkCbWRVJcw5B2R6Qn5EmxbGn3n0MU8vTrgLSP0+M3yX+waXoftWIGGv5jREt528X1hNWwChuDdLXuSCJnLspmbxgjv4QpMgAUH5pEcQaG1AbJTyitDtig/UwJx8muCqXQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74d88a5-4d37-41fe-72d8-08d7eb4c2890
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 08:14:22.5412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQY7GKxHCOaMTz3P26BwimxamvDoCh8rry5+kyzYWofenP5rtj1EtHBo+zwR2q5j0onCkkQ8QRpr2KT1XVUQ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5117
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IE9uIDIwMjAtMDQtMjYgMjM6MTMsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+PiBP
biAyMDIwLTA0LTI1IDAxOjU5LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBIUEIgc3VwcG9ydCBp
cyBjb21wcmlzZWQgb2YgNCBtYWluIGR1dGllczoNCj4gPiAxKSBSZWFkIHRoZSBkZXZpY2UgSFBC
IGNvbmZpZ3VyYXRpb24NCj4gPiAyKSBBdHRlbmQgdGhlIGRldmljZSdzIHJlY29tbWVuZGF0aW9u
cyB0aGF0IGFyZSBlbWJlZGRlZCBpbiB0aGUgc2Vuc2UNCj4gYnVmZmVyDQo+ID4gMykgTDJQIGNh
Y2hlIG1hbmFnZW1lbnQgLSBUaGlzIGVudGFpbHMgc2VuZGluZyAyIG5ldyBzY3NpIGNvbW1hbmRz
DQo+IChvcGNvZGVzIHdlcmUgdGFrZW4gZnJvbSB0aGUgdmVuZG9yIHBvb2wpOg0KPiA+ICAgICAg
IGEuIEhQQi1SRUFELUJVRkZFUiAtIHJlYWQgTDJQIHBoeXNpY2FsIGFkZHJlc3NlcyBmb3IgYSBz
dWJyZWdpb24NCj4gPiAgICAgICBiLiBIUEItV1JJVEUtQlVGRkVSIC0gbm90aWZ5IHRoZSBkZXZp
Y2UgdGhhdCBhIHJlZ2lvbiBpcyBpbmFjdGl2ZSAoaW4NCj4gaG9zdC1tYW5hZ2VkIG1vZGUpDQo+
ID4gNCkgVXNlIEhQQi1SRUFEOiBhIDNyZCBuZXcgc2NzaSBjb21tYW5kIChhZ2FpbiAtIHVzZXMg
dGhlIHZlbmRvciBwb29sKQ0KPiB0byBwZXJmb3JtIHJlYWQgb3BlcmF0aW9uIGluc3RlYWQgb2Yg
UkVBRDEwLiAgSFBCLVJFQUQgY2FycmllcyBib3RoIHRoZQ0KPiBsb2dpY2FsIGFuZCB0aGUgcGh5
c2ljYWwgYWRkcmVzc2VzLg0KPiA+DQo+ID4gSSB3aWxsIGxldCBCZWFuIGRlZmVuZCB0aGUgU2Ft
c3VuZyBhcHByb2FjaCBvZiB1c2luZyBhIHNpbmdsZSBMTEQgdG8gYXR0ZW5kDQo+IGFsbCA0IGR1
dGllcy4NCj4gPg0KPiA+IEFub3RoZXIgYXBwcm9hY2ggbWlnaHQgYmUgdG8gc3BsaXQgdGhvc2Ug
ZHV0aWVzIGJldHdlZW4gMiBtb2R1bGVzOg0KPiA+ICAtIEEgTExEIHRoYXQgd2lsbCBwZXJmb3Jt
IHRoZSBmaXJzdCAyIC0gdGhvc2UgY2FuIGJlIGRvbmUgb25seSB1c2luZyB1ZnMNCj4gcHJpdmV0
IHN0dWZmLCBhbmQNCj4gPiAgLSBhbm90aGVyIG1vZHVsZSBpbiBzY3NpIG1pZC1sYXllciB0aGF0
IHdpbGwgYmUgcmVzcG9uc2libGUgb2YgTDJQIGNhY2hlDQo+IG1hbmFnZW1lbnQsDQo+ID4gICBh
bmQgSFBCLVJFQUQgY29tbWFuZCBzZXR1cC4NCj4gPiBBIGZyYW1ld29yayB0byBob3N0IHRoZSBz
Y3NpIG1pZC1sYXllciBtb2R1bGUgY2FuIGJlIHRoZSBzY3NpIGRldmljZQ0KPiBoYW5kbGVyLg0K
PiA+DQo+ID4gVGhlIHNjc2ktZGV2aWNlLWhhbmRsZXIgaW5mcmFzdHJ1Y3R1cmUgd2FzIGFkZGVk
IHRvIHRoZSBrZXJuZWwgbWFpbmx5IHRvDQo+IGZhY2lsaXRhdGUgbXVsdGlwbGUgcGF0aHMgZm9y
IHN0b3JhZ2UgZGV2aWNlcy4NCj4gPiBUaGUgSFBCIGZyYW1ld29yaywgYWx0aG91Z2ggZmFyIGZy
b20gdGhlIG9yaWdpbmFsIGludGVudGlvbiBvZiB0aGUNCj4gYXV0aG9ycywgbWlnaHQgYXMgd2Vs
bCBmaXQgaW4uDQo+ID4gSW4gdGhhdCBzZW5zZSwgdXNpbmcgUkVBRHMgYW5kIEhQQl9SRUFEcyBp
bnRlcm1pdHRlbnRseSwgY2FuIGJlIHBlcmNlaXZlZA0KPiBhcyBhIG11bHRpLXBhdGguDQo+ID4N
Cj4gPiBTY3NpIGRldmljZSBoYW5kbGVycyBhcmUgYWxzbyBhdHRhY2hlZCB0byBhIHNwZWNpZmlj
IHNjc2lfZGV2aWNlIChsdW4pLg0KPiA+IFRoaXMgY2FuIHNlcnZlIGFzIHRoZSBnbHVlIGxpbmtp
bmcgYmV0d2VlbiB0aGUgdWZzIExMRCBhbmQgdGhlIGRldmljZQ0KPiBoYW5kbGVyIHdoaWNoIHJl
c2lkZXMgaW4gdGhlIHNjc2kgbGV2ZWwuDQo+ID4NCj4gPiBEZXZpY2UgaGFuZGxlcnMgY29tZXMg
d2l0aCBhIHJpY2ggYW5kIGhhbmR5IHNldCBvZiBBUElzICYgb3BzLCB3aGljaCB3ZQ0KPiBjYW4g
dXNlIHRvIHN1cHBvcnQgSFBCLg0KPiA+IFNwZWNpZmljYWxseSB3ZSBjYW4gdXNlIGl0IHRvIGF0
dGFjaCAmIGFjdGl2YXRlIHRoZSBkZXZpY2UgaGFuZGxlciwNCj4gPiBvbmx5IGFmdGVyIHRoZSB1
ZnMgZHJpdmVyIHZlcmlmaWVkIHRoYXQgSFBCIGlzIHN1cHBvcnRlZCBieSBib3RoIHRoZSBwbGF0
Zm9ybQ0KPiBhbmQgdGhlIGRldmljZS4NCj4gPg0KPiA+IFRoZSAyIG1vZHVsZXMgY2FuIGNvbW11
bmljYXRlIHVzaW5nIHRoZSBoYW5kbGVyX2RhdGEgb3BhcXVlIHBvaW50ZXIsDQo+ID4gYW5kIHRo
ZSBoYW5kbGVy4oCZcyBzZXRfcGFyYW1zIG9wLW1vZGU6IHdoaWNoIGlzIGFuIG9wZW4gcHJvdG9j
b2wNCj4gZXNzZW50aWFsbHksDQo+ID4gYW5kIHdlIGNhbiB1c2UgaXQgdG8gcGFzcyB0aGUgc2Vu
c2UgYnVmZmVyIGluIGl0cyBmdWxsIG9yIGp1c3QgYSBwYXJzZWQgdmVyc2lvbi4NCj4gPg0KPiA+
IEJlaW5nIGEgc2NzaSBtaWQtbGF5ZXIgbW9kdWxlLCBpdCB3aWxsIG5vdCBicmVhayBhbnl0aGlu
ZyB3aGlsZSBzZW5kaW5nDQo+ID4gSFBCLVJFQUQtQlVGRkVSIGFuZCBIUEItV1JJVEUtQlVGRkVS
IGFzIHBhcnQgb2YgdGhlIEwyUCBjYWNoZQ0KPiBtYW5hZ2VtZW50IGR1dGllcy4NCj4gPg0KPiA+
IExhc3QgYnV0IG5vdCBsZWFzdCwgdGhlIGRldmljZSBoYW5kbGVyIGlzIGFscmVhZHkgaG9va2Vk
IGluIHRoZSBzY3NpDQo+IGNvbW1hbmQgc2V0dXAgZmxvdyAtIHNjc2lfc2V0dXBfZnNfY21uZCgp
LA0KPiA+IFNvIHdlIGdldCB0aGUgaG9vayBpbnRvIEhQQi1SRUFEIHByZXBfZm4gZm9yIGZyZWUu
DQo+ID4NCj4gPiBMYXRlciBvbiwgd2UgbWlnaHQgd2FudCB0byBleHBvcnQgdGhlIEwyUCBjYWNo
ZSBtYW5hZ2VtZW50IGxvZ2ljIHRvDQo+IHVzZXItc3BhY2UuDQo+ID4gTG9jYXRpbmcgdGhlIEwy
UCBjYWNoZSBtYW5hZ2VtZW50IGluIHNjc2kgbWlkLWxheWVyIHdpbGwgZW5hYmxlIHVzIHRvIGRv
DQo+IHNvLCB1c2luZyB0aGUgc2NzaS1uZXRsaW5rIG9yIHNvbWUgb3RoZXIgbWVhbnMuDQo+IA0K
PiBIaSBBdnJpLA0KPiANCj4gSSdtIG5vdCBzdXJlIHRoYXQgSSBhZ3JlZSB0aGF0IEhQQiBjYW4g
YmUgcGVyY2VpdmVkIGFzIG11bHRpLXBhdGguDQo+IEFueXdheSwgdGhlIGFib3ZlIGFwcHJvYWNo
IHNvdW5kcyBpbnRlcmVzdGluZyB0byBtZS4gQSBmZXcgcXVlc3Rpb25zDQo+IHRob3VnaDoNCj4g
LSBUaGUgb25seSBpbi10cmVlIGNhbGxlciBvZiBzY3NpX2RoX2F0dGFjaCgpIEkgYW0gYXdhcmUg
b2YgZXhpc3RzIGluDQo+ICAgdGhlIGRtLW1wYXRoIGRyaXZlci4gSSB0aGluayB0aGF0IGNhbGwg
aXMgdHJpZ2dlcmVkIGJ5IG11bHRpcGF0aGQuDQo+ICAgSSBkb24ndCB0aGluayB0aGF0IGl0IGlz
IGFjY2VwdGFibGUgdG8gcmVxdWlyZSB0aGF0IG11bHRpcGF0aGQgaXMNCj4gICBydW5uaW5nIHRv
IHVzZSB0aGUgVUZTIEhQQiBmdW5jdGlvbmFsaXR5LiBXaGF0IGlzIHRoZSBwbGFuIGZvcg0KPiAg
IGF0dGFjaGluZyB0aGUgVUZTIGRldmljZSBoYW5kbGVyIHRvIFVGUyBkZXZpY2VzPw0KUmlnaHQu
DQpEZXZpY2UgaGFuZGxlcnMgYXJlIG1lYW50IHRvIGJlIGNhbGxlZCBhcyBwYXJ0IG9mIHRoZSBk
ZXZpY2UgbWFwcGVyDQptdWx0aS1wYXRoIGNvZGUuICBXZSBjYW7igJl0IGRvIHRoYXQg4oCTIHdl
IG5lZWQgdG8gYXR0YWNoICYgYWN0aXZhdGUgdGhlDQpkZXZpY2UgaGFuZGxlciBtYW51YWxseSwg
b25seSBhZnRlciB0aGUgdWZzIGRyaXZlciB2ZXJpZmllZCB0aGF0IEhQQiBpcw0Kc3VwcG9ydGVk
IGJ5IGJvdGggdGhlIHBsYXRmb3JtIGFuZCB0aGUgZGV2aWNlLg0KDQpJIHdhcyB0aGlua2luZyB0
byByZWx5IG9uIHRoZSB1ZnMncyAyLXBoYXNlIGJvb3Q6DQpUaGUgdWZzIGJvb3QgcHJvY2VzcyBp
cyBlc3NlbnRpYWxseSBjb21wcmlzZWQgb2YgMiBwYXJ0czogZmlyc3QgYSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICANCmhhbmRzaGFrZSB3aXRoIHRoZSBkZXZpY2UsIGFuZCB0aGVuLCBz
Y3NpIHNjYW5zIGFuZCBhc3NpZ24gYSBzY3NpIGRldmljZSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KdG8gZWFjaCBsdW4uICBUaGUgbGF0dGVyLCBhbHRob3VnaCBydW5uaW5nIGEtc3luY2hyb25p
Y2FsbHksIGlzICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQpoYXBwZW5pbmcgcmln
aHQgYWZ0ZXIgcmVhZGluZyB0aGUgZGV2aWNlIGNvbmZpZ3VyYXRpb24gLSBsdW4gYnkgbHVuLiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KQnkgbm93IHdlJ3ZlIHJlYWQgdGhlIGRldmljZSBIUEIgY29uZmlndXJh
dGlvbiwgYW5kIHdlIGFyZSByZWFkeSAgdG8NCmF0dGFjaCBhIHNjc2kgZGV2aWNlIHRvIG91ciBI
UEIgbHVucy4gIEEgcGVyZmVjdCB0aW1pbmcgbWlnaHQgYmUgd2hpbGUNCnNjc2kgaXMgcGVyZm9y
bWluZyBpdHMgLnNsYXZlX2FsbG9jKCkgb3IgLnNsYXZlX2NvbmZpZ3VyZSgpLg0KDQpJdCB3aWxs
IHJlcXVpcmUgaG93ZXZlciwgdG8gaW5jbHVkZSA8c2NzaS9zY3NpX2RoLmg+IGFuZCAiLi4vc2Nz
aV9wcml2LmgiIGluIHVmc2hwYi5jLA0KTm90IHN1cmUgaWYgdGhpcyBpcyBhY2NlcHRhYmxlLg0K
DQo+IC0gV2lsbCBwcmVwYXJpbmcgYSBTQ1NJIGNvbW1hbmQgaW52b2x2ZSBleGVjdXRpbmcgYSBT
Q1NJIGNvbW1hbmQ/IElmIHNvLA0KPiAgIGhvdyB3aWxsIGl0IGJlIHByZXZlbnRlZCB0aGF0IGV4
ZWN1dGlvbiBvZiB0aGF0IGludGVybmFsbHkgc3VibWl0dGVkDQo+ICAgU0NTSSBjb21tYW5kIHRy
aWdnZXJzIGEgZGVhZGxvY2sgZHVlIHRvIHRhZyBleGhhdXN0aW9uPw0KTm90IHN1cmUgd2hhdCBk
ZWFkbG9jayBhcmUgeW91IHJlZmVycmluZyB0by4NCkV4ZWN1dGluZyBIUEItUkVBRC1CVUZGRVIg
aXMgbm90IHBhcnQgb2YgdGhlIGRhdGEgcGF0aCwNCkFuZCBzaG91bGQgbm90IGhhcHBlbiB0b28g
b2Z0ZW4uDQpBbnl3YXkgaXQgY2FuIHdhaXQgZm9yIGEgdGFnIHRvIGJlY29tZSBmcmVlLg0KU2Ft
ZSBnb2VzIHRvIEhQQi1XUklURS1CVUZGRVIuDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQo=
