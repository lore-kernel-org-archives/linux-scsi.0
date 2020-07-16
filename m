Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78164C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5203B207F9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 10:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kQ1IzA2S";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jMuQZlm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgGPKBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:01:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12696 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgGPKBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 06:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594893661; x=1626429661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eZ8ds6lG5VRkL0q+wQ2bpGiiR+v551ktiz0tCfq3O6Q=;
  b=kQ1IzA2SaiFsFtIShMvz9HRFPvLEC+GIPNzmnt/mT4jwNerGhYwtxXxd
   xmJ1c2epkBR4Otce7Be52m/CqFYaNfv29MXkWr3mpk26pDqisAWHbo+vf
   Qtsf9FEyMxMxg75rZtgvmtk94tIam8kqC4YuHoNflXZD2KkyxNluaBAUx
   ZraZ0ZX/MroYzg1SB2igS959JM/AQZsPp0EzVc2MigO4XkXaNbL+Zj1ZU
   wCteYfhVFl9gYf5p2iIn2/SjWuifABYC3FuvqFfEfmHi8Atr9ZKKuqnqM
   r7+thWR38g82cW92bW/07Mk5NtenVzZ1FFpTg2EUs8EqkmNCSEXcMSZba
   w==;
IronPort-SDR: 6vIaleg2eysP3nk0nC7hleas6iQM4iq7hYXM26VhYnMsTQswi0bhCiZ30Xnh+hJJMENV2inQ10
 I7CoCXkCqYldOG+W4tFjjTCshDOCop/XCVpJEQVIsfiTyoNTT7cQnAuA4Qm57DLw7MPesnGwLx
 FLkC2AbEATe44sx2CPJgEYlT/enkI8wo6Li99qsNGRqTQkek9eUhuu9MCs6F7rykx+VMfMsIHN
 Gu8fKnwd1DjBGL6OMtcWgzMx8wZkZTQHYuYJHOohqnbpuJpdaiuSjAsPMJlFyj6aC3wHtx1SiQ
 R/E=
X-IronPort-AV: E=Sophos;i="5.75,358,1589212800"; 
   d="scan'208";a="251862776"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2020 18:00:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3zDbsnYE92Ga739Yscqguu6P/1/w0OCw6DilaGcWfrZvWGo54gMpyspbQiI4GFDtLYfw5NpetnSS7v1K1v0yl597eE4DXIANx0PhuePKRsEZYuzZUQW9g9aZh0ju6wi/4gve+qWGRRPSWtDJrHlCDWe89kfI5DcWgxXEu/LqLKOBOgj98U2AbQn+6/Gw9bpoFpSR2WjfUk88i54i+dEIJdapXYuED5GrXClgitYBAMzQYnZVdIek2S8MeCeHrMHJZr2qZnVbEf/iWiPm9axzVTW6t/va6TmxnMQ3o7cFUaZR+X1vZD5nW3J5va6efY4KFZHN8+mQcUa1ud9pOUrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ8ds6lG5VRkL0q+wQ2bpGiiR+v551ktiz0tCfq3O6Q=;
 b=NiSH/hn7lKO5RtkeVEnyOqeFnXlNah6ul492s+ChyC7ufJrZBKlu4pRGBqPVBQWM5Q1klBiMlJ9TqIsamg3CHIlymbeq0PBesMuyExrgjybXdaQqRbEgY4VB/TCJ2TWFhxsq2viI+IsKD+il/15UkK+Eqfq24hbJ9EunbEFRYvkK8OByNLijlW/rq26LeKL0r8tih0R1kzdm03Y2YJQXvLVIyMEJ2lxNEziPI8rUf9wG/5e6DoTgLbG1GY+E24cdlDhorSk2fJU5gcpXP+7yhbyD8UoCdZu13S97HEXTqp15Zv5zgOHfRxr8BUNya5A4qy6fjp13IBxo3rru/OkP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ8ds6lG5VRkL0q+wQ2bpGiiR+v551ktiz0tCfq3O6Q=;
 b=jMuQZlm06eSiR2hrPkNK30unZGguPGJTmcD9iLSuz3lrYE0CWmjsltir4QXhd+cUik5k9Dn3lQYG+9FEF/2jaBLACzQtKxJ10kxh6+vImq+kBtHYvrHEdgHs9pG3gy4lSU+T0nw+HS+YrsaPTCbXcuyGiYAdHNL66FvkAp9OQ1w=
Received: from SN6PR04MB3872.namprd04.prod.outlook.com (2603:10b6:805:50::31)
 by SN6PR04MB4767.namprd04.prod.outlook.com (2603:10b6:805:a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 16 Jul
 2020 10:00:57 +0000
Received: from SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b]) by SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b%6]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 10:00:57 +0000
From:   Avi Shchislowski <Avi.Shchislowski@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQG2N4YY5117HE6tFmBTUW/alKkI+uYQgAB3mwCAAItIQA==
Date:   Thu, 16 Jul 2020 10:00:57 +0000
Message-ID: <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
 <4174fcf4-73ec-8e3f-90a5-1e7584e3e2d0@acm.org>
In-Reply-To: <4174fcf4-73ec-8e3f-90a5-1e7584e3e2d0@acm.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [37.142.4.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fef6e2ed-db1c-4e4d-6d9a-08d8296f22e0
x-ms-traffictypediagnostic: SN6PR04MB4767:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4767C4F632CCEE365B3D9CDA9A7F0@SN6PR04MB4767.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ez8VCACSZ+3tGCQJyko2oDRMea3Zvqi+xbYuEkU5FYTytOe7XjYgC8DrO5mQzIDyHn0SaYQ9d4MLaOk3zpLits5jtQ3kiXH2+woCyNaIuVZhAtsnabaNqdZth0xM/uFHCT0FqNzv4JGqA31lQY84Whp7eHJBf8KAW0/lSyVbAdh2tznIBP2jRIoIAyM0cfb6L+XQ72B80wG871TcTtZ+FXAPouy3kwgkPhE5Vsg8YlAbrwee1bTtZNhuKrk6f3uGszE145GflZPg5t4qhoulKxQRg7Aux9n3ERHWkb6Dyo9u5CYc41Z6E+u/0OG3nCmdscojeLxl1dJb6V+XlMOMhruLb3OwZTQefHaBUOVm55Iw6AePASW1jeI5NMsIwZKN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB3872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(86362001)(478600001)(54906003)(5660300002)(71200400001)(4326008)(66556008)(66946007)(64756008)(110136005)(316002)(8936002)(66446008)(76116006)(7696005)(52536014)(66476007)(33656002)(7416002)(83380400001)(53546011)(2906002)(6506007)(186003)(55016002)(26005)(9686003)(8676002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 97ucSiaM6QOdSXSzv1xYCoAhJFfnLv13WI2dAIv+T9G8dEE0kgGR7Qf+M16vJKytvN8ko+9jYgvCoHQ/P3+AZSFkzorKR9PNKDIYxAmNW5SJxI2RjRU2hV35OTkGRAW9kWZhl1cibCChzOJEdFqyaaPIG2wEp/68RPN/0W1+hkK4cI6IrN7WmbUGK/3Zr6jyCZrLANdrR+Hxb7OH3rJWUPTjXfaHd34HkbXkYuU8Cy1K62NOxFEBfXsY6TopzOJtmh2fasFMOK2HkYGPTCN9ZysffU3sf/Eq0hyVhxXoNWcUwYdS1mmqqglDzJ8MMe97kmJqx4KTNh1eGnIfvo6GAd3GX9Arv0epxSA/Ra2RWi1C8Vz6ZsO0ikmUo8PgBGOSbC0E5ZsWy3vMLpG/2MTKgRfnCtbN3YB3Bwh7jUf+APZMhcnBwIUX5sz0TERnP2kJCSENe2kqkrqQsUXmSQUX8towj+5KQ2tJMBDRT0IL2ts=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB3872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef6e2ed-db1c-4e4d-6d9a-08d8296f22e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 10:00:57.4278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FE2L8BXaDOx/xzWeV/wToulgqBTmfZrDTmvhH9k1+J0sxPh/tR6KlnWQfdQr5QMEUfgGgFODy9DWIU4uEc/LWkwzKo3gWJVej+27FO0CNxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4767
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDE2LCAyMDIwIDQ6
NDIgQU0NCj4gVG86IEF2aSBTaGNoaXNsb3dza2kgPEF2aS5TaGNoaXNsb3dza2lAd2RjLmNvbT47
DQo+IGRhZWp1bjcucGFya0BzYW1zdW5nLmNvbTsgQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdk
Yy5jb20+Ow0KPiBqZWpiQGxpbnV4LmlibS5jb207IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29t
OyBhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZzsNCj4gYmVhbmh1b0BtaWNyb24uY29tOyBzdGFubGV5
LmNodUBtZWRpYXRlay5jb207IGNhbmdAY29kZWF1cm9yYS5vcmc7DQo+IHRvbWFzLndpbmtsZXJA
aW50ZWwuY29tOyBBTElNIEFLSFRBUiA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+DQo+IENjOiBs
aW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
U2FuZy15b29uIE9oDQo+IDxzYW5neW9vbi5vaEBzYW1zdW5nLmNvbT47IFN1bmctSnVuIFBhcmsN
Cj4gPHN1bmdqdW4wNy5wYXJrQHNhbXN1bmcuY29tPjsgeW9uZ215dW5nIGxlZQ0KPiA8eW1odW5n
cnkubGVlQHNhbXN1bmcuY29tPjsgSmlueW91bmcgQ0hPSSA8ai0NCj4geW91bmcuY2hvaUBzYW1z
dW5nLmNvbT47IEFkZWwgQ2hvaSA8YWRlbC5jaG9pQHNhbXN1bmcuY29tPjsgQm9SYW0NCj4gU2hp
biA8Ym9yYW0uc2hpbkBzYW1zdW5nLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NiAwLzVd
IHNjc2k6IHVmczogQWRkIEhvc3QgUGVyZm9ybWFuY2UgQm9vc3RlciBTdXBwb3J0DQo+IA0KPiBD
QVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFdlc3Rlcm4gRGln
aXRhbC4gRG8gbm90IGNsaWNrIG9uDQo+IGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGF0IHRoZQ0KPiBjb250ZW50IGlz
IHNhZmUuDQo+IA0KPiANCj4gT24gMjAyMC0wNy0xNSAxMTozNCwgQXZpIFNoY2hpc2xvd3NraSB3
cm90ZToNCj4gPiBNeSBuYW1lIGlzIEF2aSBTaGNoaXNsb3dza2ksIEkgYW0gbWFuYWdpbmcgdGhl
IFdEQydzIExpbnV4IEhvc3QgUiZEIHRlYW0NCj4gaW4gd2hpY2ggQXZyaSBpcyBhIG1lbWJlciBv
Zi4NCj4gPiBBcyB0aGUgcmV2aWV3IHByb2Nlc3Mgb2YgSFBCIGlzIHByb2dyZXNzaW5nIHZlcnkg
Y29uc3RydWN0aXZlbHksIHdlIGFyZSBnZXR0aW5nDQo+IG1vcmUgYW5kIG1vcmUgcmVxdWVzdHMg
ZnJvbSBPRU1zLCBJbnF1aXJpbmcgYWJvdXQgSFBCIGluIGdlbmVyYWwsIGFuZCBob3N0DQo+IGNv
bnRyb2wgbW9kZSBpbiBwYXJ0aWN1bGFyLg0KPiA+DQo+ID4gVGhlaXIgbWFpbiBjb25jZXJuIGlz
IHRoYXQgSFBCIHdpbGwgbWFrZSBpdCB0byA1LjkgbWVyZ2Ugd2luZG93LCBidXQgdGhlIGhvc3QN
Cj4gY29udHJvbCBtb2RlIHBhdGNoZXMgd2lsbCBub3QuDQo+ID4gVGh1cywgYmVjYXVzZSBvZiBy
ZWNlbnQgR29vZ2xlJ3MgR0tJLCB0aGUgbmV4dCBBbmRyb2lkIExUUyBtaWdodCBub3QgaW5jbHVk
ZQ0KPiBIUEIgd2l0aCBob3N0IGNvbnRyb2wgbW9kZS4NCj4gPg0KPiA+IEFzaWRlIG9mIHRob3Nl
IHJlcXVlc3RzLCBpbml0aWFsIGhvc3QgY29udHJvbCBtb2RlIHRlc3RpbmcgYXJlIHNob3dpbmcN
Cj4gcHJvbWlzaW5nIHByb3NwZWN0aXZlIHdpdGggcmVzcGVjdCBvZiBwZXJmb3JtYW5jZSBnYWlu
Lg0KPiA+DQo+ID4gV2hhdCB3b3VsZCBiZSwgaW4geW91ciBvcGluaW9uLCB0aGUgYmVzdCBwb2xp
Y3kgdGhhdCBob3N0IGNvbnRyb2wgbW9kZSBpcw0KPiBpbmNsdWRlZCBpbiBuZXh0IEFuZHJvaWQg
TFRTPw0KPiANCj4gSGkgQXZpLA0KPiANCj4gQXJlIHlvdSBwZXJoYXBzIHJlZmVycmluZyB0byB0
aGUgSFBCIHBhdGNoIHNlcmllcyB0aGF0IGhhcyBhbHJlYWR5IGJlZW4gcG9zdGVkPw0KPiBBbHRo
b3VnaCBJJ20gbm90IHN1cmUgb2YgdGhpcywgSSB0aGluayB0aGF0IHRoZSBTQ1NJIG1haW50YWlu
ZXIgZXhwZWN0cyBtb3JlDQo+IFJldmlld2VkLWJ5OiBhbmQgVGVzdGVkLWJ5OiB0YWdzLiBIYXMg
YW55b25lIGZyb20gV0RDIGFscmVhZHkgdGFrZW4gdGhlDQo+IHRpbWUgdG8gcmV2aWV3IGFuZC9v
ciB0ZXN0IHRoaXMgcGF0Y2ggc2VyaWVzPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
WWVzLCBJIGFtIHJlZmVycmluZyB0byB0aGUgY3VycmVudCBwcm9wb3NhbCB3aGljaCBJIGFtIHJl
cGx5aW5nIHRvOg0KW1BBVENIIHY2IDAvNV0gc2NzaTogdWZzOiBBZGQgSG9zdCBQZXJmb3JtYW5j
ZSBCb29zdGVyIFN1cHBvcnQgVGhpcyBwcm9wb3NhbCBkb2VzIG5vdCBjb250YWlucyBob3N0IG1v
ZGUsIGhlbmNlIG91ciBjdXN0b21lcnMgY29uY2Vybi4NCldoYXQgd291bGQgYmUsIGluIHlvdXIg
b3BpbmlvbiwgdGhlIGJlc3QgcG9saWN5IHRoYXQgaG9zdCBjb250cm9sIG1vZGUgaXMgaW5jbHVk
ZWQgaW4gbmV4dCBBbmRyb2lkIExUUyAgYXNzdW1pbmcgaXQgd2lsbCBiZSBiYXNlZCBvbiBrZXJu
ZWwgdjUuOSA/DQoNClRoYW5rcywNCkF2aQ0K
