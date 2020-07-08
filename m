Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DC8C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5DED20656
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EmTcMM/9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Agdd9gub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgGHHod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 03:44:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4305 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHHod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 03:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594194273; x=1625730273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eKKE01ogBFT6sTtm0lxtksTtkrzJ9Uv9W81tbjwnIJA=;
  b=EmTcMM/9OwMTlbrQ9JwxyE2/HeHHV2OflCywedDM+yAnotXEzb9BrdN1
   +VtOgP+R4I1SJNeC+LWy91i/PM4ldxOO2gV7VV7vFKYDHrRO1Mxk3V3Nt
   /8QpOTEks2XoUNbUWE5AKehp7QRyMrbtJEs+kzZssV+q8bKWzcmK27WxF
   eN6/8voEE1hfwQvIy+K7qbutLuevm5pn+Hwr/PI1aGCQ+ugtuAWQR5Dqz
   GgF1rFuwfrV2Ox1fxT5p5ndAHtBOXwexkjD4FbAlBs+CRqWvkLW/oVfrd
   IcEYUYt6phtt9rhdxBe864sInX1Rmh2fiUgtqlFSSW5nwZfVeZJ+tn28r
   Q==;
IronPort-SDR: xojyc2B9puJRzFzmLf+HJJeNEroA86brNMOwYbHaS3bH6RYSGSkP581ETyT7gtBz5MV81kAgq8
 TK+7Vd3jl/5Ukp2fPXSoVKj348tTsmxp7CgaL0UFCh9axH/YaBYOarGjj2iUmuuaH6B+TVvVs+
 D0daOkLsXnmr6A6NbQJmkkKr0R3PhlrKY46wYfojKX+Z8GRXp33PD432qFBOnmQzx5rCzOUSJq
 9irLIRElsGGm0V1f1krRjmCbSFbPtnaAwji7rfFQsyNRqjzHDiFmCJSBdB4cFMqIzUHa4nWdHU
 Pxw=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="143229738"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 15:44:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbNsjr8/B5saZiaoTs4Zw25AZW2rDQE36BPy3dm4eYs8ChMEUQeudExo9ckKWdzL9Tr1o9TSmb427fwmOwo+g3CQvkGa5WlAKfeRseXfdVsScEVCwiF73fIetfnEULinoKG9/2qbsGZdb5i7tztjfoyDKJPAfMpZGgmX9edWjkHinGUfIZNfBsitcT8Zs6wRvg9m4TA62//3dncRkNCKMX+XhenN+b7m56HQ1LWJlQGBvYQ4rQtyKx+h6oUHwNyqsOPEEVrj8kCKfbhXhV8z60EE6Z4f6k9kzu9MNvhcAjPms6ZIc4KHEWC4wdZDHGcpD8DFJOj5fSHMwSQQt7wutw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKKE01ogBFT6sTtm0lxtksTtkrzJ9Uv9W81tbjwnIJA=;
 b=mIEWx2dUcdvvYhhgl/dfs4NDs9nX4oWeVevzefA5Iz2/teba3hNN0KhTAKqs1ilVjdvKAgWrsOwg0Ak8uSIFvwIdm/lkWMHxpnKqw1wkwJGmLh4/AHnTk85J3cIqsEYfLw164X2kB4cIvpdwzAuAk320ZUbfZ8rgfNYMeiqLBxuEyCEuAfaNsM4alh95KeoXtse8pzT8emMe41/nHA6o/L4KIChjJNzAZzdv24wxNdvGDMSffLzL9Rj1+AWtWTe0/kYPaKaL8nEf4afTXXWSuwSAXUvNdj4PcuSUkk5+Ik7xMc8zQmBQ5JJD5n9l20Ah+ufdTSMpGzf/z8r/qok3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKKE01ogBFT6sTtm0lxtksTtkrzJ9Uv9W81tbjwnIJA=;
 b=Agdd9gubRtx/DIGvhzp9/gv44HD8SkEIEZQc4yTigOeY0MNKgyBbGoMxSkn9GBVQDK2z3KiskbrPCTZoruKAUIXpNWsxgIN5RfsIcTl1vYUlX88bWqnLW5oSdGjPYT9MWP4vf7o0iSYcHISs5mJLEu5Fl3/aK2RTD2xrinD2w+I=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4576.namprd04.prod.outlook.com (2603:10b6:805:ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 07:44:28 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 07:44:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Satya Tangirala <satyat@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
CC:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v4 2/3] scsi: ufs: UFS crypto API
Thread-Topic: [PATCH v4 2/3] scsi: ufs: UFS crypto API
Thread-Index: AQHWU9CtW7JqpEm0eEqAtqn0oJ9GSqj9P+KA
Date:   Wed, 8 Jul 2020 07:44:28 +0000
Message-ID: <SN6PR04MB4640E8B9BB10FD5A5C2740D1FC670@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706200414.2027450-1-satyat@google.com>
 <20200706200414.2027450-3-satyat@google.com>
In-Reply-To: <20200706200414.2027450-3-satyat@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 222b63b7-f66c-4284-3229-08d82312bea6
x-ms-traffictypediagnostic: SN6PR04MB4576:
x-microsoft-antispam-prvs: <SN6PR04MB45763778D5FA714681E5DFFCFC670@SN6PR04MB4576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNIxJPXQNDkMmTsb65+qIXgTuXGA9aIDgEsc9AuIy2MVBktMrJK+1VBUnbEBCMtW1Pv7xSlvK/VsmH+F08xjs2ZF5cZnwVavilXA0qkb6PZlnMfSY5QFXw8flOq88Ilwwv+dWvHvjDSQRogjQkqEUck/19ZubHDe4T96ahNOjdzHSpT7sBhaU7adIpKG+YBKQ2LQP9MQlVTUB9LB3Qn2/9k202/lo/JHWliKqN+v5p5kqhogtoasUZHC0sITWg7rxMK1itwWC/q6Q58OxEC6b/OtnD2mXli54+aP8/QRvZ8C/CfuzMecjaEgzUxlCM95wgww8Z//WKlVjtZN0p3t+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(66476007)(66556008)(8676002)(76116006)(64756008)(66446008)(71200400001)(66946007)(9686003)(55016002)(33656002)(8936002)(6506007)(26005)(186003)(7696005)(498600001)(110136005)(2906002)(54906003)(4326008)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GKgTnAAMtbl24B+p3iqb/Fxh/D7tdlr9k2QAlOof9QAxKnTT89wZD/0otrAMAz3EVH9chI8Hdqs1OEwSCT40qxT7uCSi5RG1Ef7+cPWPi8hs6dnvXQ9/Mp4++gQU/YMOaZezD3avJJHj5YB7JRsu3zrhEfzPx4/AZ4SQtZyaNbB+NrWHBSy8ZwdsKaC9tU4DzMNrSK4VXnlVTlSUtkr308Z1zVKcLfADynvUZclwKTb1eE33x6kAqp42eego67qSsp0fh9pzMg0BjdBQiTYjB8Kxw6lD9wO8I9UwtSDyf9FaS2RdRjWMk6TT1EB6FQkUIqqQ97iFPD+zko3T+J2Kt7lKiBZZOVFgSfN33Z6mElQqLttw5GN8tr4spHOI5VmUGUzBlmWNx4XAT1mTTDsq7mt6tdc40+1ScrUYDQM816QbPWmuuPKZ6TqQNvbFmCgceTdtyLif+p5XP7OkZkOVNY3jA59Cb4b+8Ycmt7zuYHc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222b63b7-f66c-4284-3229-08d82312bea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 07:44:28.6402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CrcKpHezjztd7uo/jbYLY2H0Rizf/raT3/B5DLCR/X78U7N3QKAMXbpLkA7aDlSDaqFvthVo0gRNj10h4NyNKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4576
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArDQo+ICtzdGF0aWMgZW51bSBibGtfY3J5cHRvX21vZGVfbnVtDQo+ICt1ZnNoY2RfZmluZF9i
bGtfY3J5cHRvX21vZGUodW5pb24gdWZzX2NyeXB0b19jYXBfZW50cnkgY2FwKQ0KPiArew0KPiAr
ICAgICAgIGludCBpOw0KPiArDQo+ICsgICAgICAgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUo
dWZzX2NyeXB0b19hbGdzKTsgaSsrKSB7DQo+ICsgICAgICAgICAgICAgICBCVUlMRF9CVUdfT04o
VUZTX0NSWVBUT19LRVlfU0laRV9JTlZBTElEICE9IDApOw0KPiArICAgICAgICAgICAgICAgaWYg
KHVmc19jcnlwdG9fYWxnc1tpXS51ZnNfYWxnID09IGNhcC5hbGdvcml0aG1faWQgJiYNCj4gKyAg
ICAgICAgICAgICAgICAgICB1ZnNfY3J5cHRvX2FsZ3NbaV0udWZzX2tleV9zaXplID09IGNhcC5r
ZXlfc2l6ZSkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gaTsNCj4gKyAgICAg
ICAgICAgICAgIH0NCj4gKyAgICAgICB9DQo+ICsgICAgICAgcmV0dXJuIEJMS19FTkNSWVBUSU9O
X01PREVfSU5WQUxJRDsNCkJMS19FTkNSWVBUSU9OX01PREVfSU5WQUxJRCBpcyAwLCBidXQgMCBp
cyBhIHZhbGlkIG1vZGUgbnVtPw0KDQo+ICt9DQo+ICsNCj4gKy8qKg0KPiArICogdWZzaGNkX2hi
YV9pbml0X2NyeXB0b19jYXBhYmlsaXRpZXMgLSBSZWFkIGNyeXB0byBjYXBhYmlsaXRpZXMsIGlu
aXQgY3J5cHRvDQo+ICsgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZmll
bGRzIGluIGhiYQ0KPiArICogQGhiYTogUGVyIGFkYXB0ZXIgaW5zdGFuY2UNCj4gKyAqDQo+ICsg
KiBSZXR1cm46IDAgaWYgY3J5cHRvIHdhcyBpbml0aWFsaXplZCBvciBpcyBub3Qgc3VwcG9ydGVk
LCBlbHNlIGEgLWVycm5vIHZhbHVlLg0KPiArICovDQo+ICtpbnQgdWZzaGNkX2hiYV9pbml0X2Ny
eXB0b19jYXBhYmlsaXRpZXMoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3sNCj4gKyAgICAgICBp
bnQgY2FwX2lkeDsNCj4gKyAgICAgICBpbnQgZXJyID0gMDsNCj4gKyAgICAgICBlbnVtIGJsa19j
cnlwdG9fbW9kZV9udW0gYmxrX21vZGVfbnVtOw0KPiArDQo+ICsgICAgICAgLyoNCj4gKyAgICAg
ICAgKiBEb24ndCB1c2UgY3J5cHRvIGlmIGVpdGhlciB0aGUgaGFyZHdhcmUgZG9lc24ndCBhZHZl
cnRpc2UgdGhlDQo+ICsgICAgICAgICogc3RhbmRhcmQgY3J5cHRvIGNhcGFiaWxpdHkgYml0ICpv
ciogaWYgdGhlIHZlbmRvciBzcGVjaWZpYyBkcml2ZXINCj4gKyAgICAgICAgKiBoYXNuJ3QgYWR2
ZXJ0aXNlZCB0aGF0IGNyeXB0byBpcyBzdXBwb3J0ZWQuDQo+ICsgICAgICAgICovDQo+ICsgICAg
ICAgaWYgKCEoaGJhLT5jYXBhYmlsaXRpZXMgJiBNQVNLX0NSWVBUT19TVVBQT1JUKSB8fA0KPiAr
ICAgICAgICAgICAhKGhiYS0+Y2FwcyAmIFVGU0hDRF9DQVBfQ1JZUFRPKSkNCj4gKyAgICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KPiArDQo+ICsgICAgICAgaGJhLT5jcnlwdG9fY2FwYWJpbGl0aWVz
LnJlZ192YWwgPQ0KPiArICAgICAgICAgICAgICAgICAgICAgICBjcHVfdG9fbGUzMih1ZnNoY2Rf
cmVhZGwoaGJhLCBSRUdfVUZTX0NDQVApKTsNCj4gKyAgICAgICBoYmEtPmNyeXB0b19jZmdfcmVn
aXN0ZXIgPQ0KPiArICAgICAgICAgICAgICAgKHUzMiloYmEtPmNyeXB0b19jYXBhYmlsaXRpZXMu
Y29uZmlnX2FycmF5X3B0ciAqIDB4MTAwOw0KVGhpcyBkZXNlcnZlIGEgY29tbWVudCwgZS5nLiAN
ClVGU0hDSSBzYXlzOg0KVGhlIGFkZHJlc3MgZm9yIGVudHJ5IHggb2YgdGhlIHgtQ1JZUFRPQ0ZH
IGFycmF5IGlzIGNhbGN1bGF0ZWQgYXMgZm9sbG93czoNCkFERFIgKHgtQ1JZUFRPQ0ZHKSA9IFVG
U19IQ0lfQkFTRSArIENGR1BUUioxMDBoICsgeCo4MGgNCg0K
