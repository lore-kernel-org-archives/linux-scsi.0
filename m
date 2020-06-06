Return-Path: <SRS0=2jUW=7T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2F5C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 18:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E1572065C
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 18:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QcVvC5iI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZggIepQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgFFSjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Jun 2020 14:39:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38517 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbgFFSi7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jun 2020 14:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591468740; x=1623004740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wROL7EKRiKfRjiZM4FEiQ3yi6YHnmjAEYOBlo4XMTyE=;
  b=QcVvC5iI2TNjVsRVYjOcM61k8gN0yKUSvfP3YTcDBDW1vmevjiaqAkNg
   zkE2CM+zLfTn4hbvRyK++tqn8kSAUYqrSOpzzO6bojGWstAUWg0L6Nteu
   CITP0Xv2CKl90F91o8UYioWIEXaQ+WJRiQICyIpAl9XL/OJ80BQeHrLL+
   67zyVeEcv1FVbUUnEO/nouY/ckticda5EKe/LjV2YTWm9mfrrOur2/fXa
   cujKf2NdiL9xW8a95PKBSYT1I/gA+wUaEbX8wWijL705QpwYSOWwHukji
   JCgjYzqAJEHa1PYiu3l6TLtXPkLLp/UbWInflfnY7QKIlFY1s4vdddEiA
   g==;
IronPort-SDR: Z8FpKoX65LO8yvFrP8ikVzLC10SY9j2QketJInnGWnPd+QL8DYLtZajWqtc3MSpyB61n0jXOxz
 NGGeJrazcRVYzl+jH6AZ6wzcs4/eXBahEXqMwLEPYLSgc4wqf8kWxGap/aawkEdz8+YyC7lLBx
 QBfgCGEyZxe5PERTSZ1M53p8p5wJcJnETHdcUmV6yrP7FLO88mRkPrt6D3Dq/xD0hb6/+S3zfU
 NQ/VouAAT099KYZS9ObrfLCf99vJXLkhp0dOjtyHypMK3+UIjZA/OBy0ucjXlospjB1BmOuhJU
 rOo=
X-IronPort-AV: E=Sophos;i="5.73,481,1583164800"; 
   d="scan'208";a="140784819"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2020 02:38:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nACKUeJUP27+6s7S+PCUG3o90f2ZLbvZa89Qkn1xf23yAdFaMtwXd3580neKrp3RkyTETS7AzQBhDd1C/SPVsYyIxhnTpj/c/26/VoJCziHu/k5BQzZeWGyYwra4VjwkNN5LUgPGhnXO3PwlkPxlFfXCMKNFfW485PdVCptd5UUIDiaD+Yzm6BnKV09djS+6hBw+Y0i9nqk/O1N5KoNWczvOhUChpwrnpoZTYxe+KvqlS/iGwJAymMrDTQRwJsV/CydrBAVVdSrv/VdNeyKbytJ1m+mXQuvsBOXnkYor0nc5/UQ9amcoZR1mPjB5GTRRdAp9QZFmxWepfLlIw9SBZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wROL7EKRiKfRjiZM4FEiQ3yi6YHnmjAEYOBlo4XMTyE=;
 b=fORuIznTuEDGSsbE/KZbCteAB6x2Urz645tYQV2zh15+7JOGaFTsOykbPXVWf6EkDDYW4pFFqH8pu8N7iKmmu9MgEQAaIeFBrvcXFaayndLBNJiavHxQentMsD3P5Z0DpLFBp1AVmzhofij4yCQDdSOU5D4A+FC0b6H5AOwzbmRgUuaHnAWjSsOz/5Y79FkO2LL4Uhc1tJJySSuecDzUra7n13UvL/JD69gWisUyfbduVkEtzxqkRNFpbsnyszspGPwH9i2Mjit+eFImXn4eBrnRou2q0gqVU0+VKso7NkJDq0Aw7PgWoF/9bQYD+wL+oaPaIiqGJnzEp2HrfsZAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wROL7EKRiKfRjiZM4FEiQ3yi6YHnmjAEYOBlo4XMTyE=;
 b=ZggIepQowwNus8gLHLRRshv0CpFDUnssatGHbslFegMJgnhE/9mpQCUsEBd37DKX8g1/Os1hFtlbYFjwMOcfNfKjCCLppcjOBJO+yLfkbzcTxizlV84o0EiBPOQEtICtWWxuRE2nscw5M5PiVjxSGCCVcc83NpNwtwHNJUjBbKo=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5167.namprd04.prod.outlook.com (2603:10b6:805:90::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Sat, 6 Jun
 2020 18:38:54 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.019; Sat, 6 Jun 2020
 18:38:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHWOt/akL86ZTv+6kyNzf9RcBp44qjL65mg
Date:   Sat, 6 Jun 2020 18:38:54 +0000
Message-ID: <SN6PR04MB4640E4699B88CB43AF62B6DFFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
 <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
In-Reply-To: <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e239297-4ca3-4533-fbf0-08d80a48dda6
x-ms-traffictypediagnostic: SN6PR04MB5167:
x-microsoft-antispam-prvs: <SN6PR04MB516790C1BD010CD5B3D43E25FC870@SN6PR04MB5167.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:205;
x-forefront-prvs: 04267075BD
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kgEC/OXXXe1RxrAFt+FVd90XmrzaqCVXF5iCkxXLakNoZ+CGHQCfuU7vZykUvez8V0F5iuOamhqn8gpe0qJne46GIj0kr3q81vOhM9HTvDIewwNHXM2Po/Ht0CaPn6Fg0Vv3JPLeSkWJ8Pb32IoC593XvbRlAHRyKcbgoBPJkhOgtg+jcPu942HaM83y3BxwOFvh39v15DSr0xCM284NovDGGD7BoDeoA6RePOk+S2D4ZUk2wPMcWX4YiNPbZWznCZBdC1DmHhs2mwsuAx2edgv4aHLccJu50nOMR36ISYPVlAaEOPCyv7rwlo3ULXBxZv88YMTIVSDl7bhPqu/S8r0qvExyuO0mbg88ceZHspK+8iAQmPETdmEsXh8VoLWb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(8936002)(4326008)(66946007)(186003)(7696005)(66476007)(8676002)(66556008)(76116006)(316002)(7416002)(86362001)(64756008)(71200400001)(54906003)(478600001)(52536014)(5660300002)(33656002)(66446008)(110136005)(6506007)(2906002)(4744005)(55016002)(26005)(9686003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LTAcHYAa3r9CzDsHgAt4MjSs5md1qrmQdgc7COPw8aQDEOfq4m7FzF7TWK6yVmx6kWG3ScgO1y1ubBfb9TBBcIkeTPp41h0rV0wNbioxJ9dBJFg0HmtalNNJkWcLaVDgpBORbQNILZAVQEOO16Ho9agmSjijDrMge7stC4TnQWlDkUAXI6E7gKH//4xKohU2OSiANIJhtdKlFeyWOJVCt9c2JMOSaC4jr5SrFb6Q2X+xijV/uSUL+aq1Hwj4YjqbCmtBb7bXrSdserwTWeV0z1eSUwaLGkXAoi3HeOWki0DkDWEa+Sza5fCPJxnTwgyfYh5Yw4/IUkXq8hzI7Y6UMQw4vYKcPOOIMAAWco+TY4erR2JdwitdskGy9NMOt6hwULXHfm3LVaBw/OTX6me478Co3C4sgPY4aNU0QjWiIpm9ySMyMECLhVhuknfSe6QymNlsBSkjZ482dtNPHgIDYTlpslhKU4RRhFj0rdr6QRk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e239297-4ca3-4533-fbf0-08d80a48dda6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2020 18:38:54.3757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvlDm5MN4zFvFKdO52EiF9tV/wwBgp0OsKxwaJG7f2M3zTwl120Wo0/vfWvEPDUBwpGm3CJDP9kGwtdJfqig9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5167
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgYm9vbCB1ZnNocGJfdGVzdF9wcG5fZGlydHkoc3RydWN0IHVmc2hwYl9sdSAq
aHBiLCBpbnQgcmduX2lkeCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBp
bnQgc3Jnbl9pZHgsIGludCBzcmduX29mZnNldCwgaW50IGNudCkNCg0KDQo+ICsNCj4gKyAgICAg
ICBmb3IgKGkgPSAwOyBpIDwgYml0X2xlbjsgaSsrKSB7DQo+ICsgICAgICAgICAgICAgICBpZiAo
dGVzdF9iaXQoc3Jnbl9vZmZzZXQgKyBpLCBzcmduLT5tY3R4LT5wcG5fZGlydHkpKQ0KTWF5YmUg
dXNlIGEgbWFzayBvciBod2VpZ2h0IGluc3RlYWQgb2YgdGVzdGluZyBiaXQgYnkgYml0Pw0KDQo+
ICtzdGF0aWMgdm9pZA0KPiArdWZzaHBiX3NldF9ocGJfcmVhZF90b191cGl1KHN0cnVjdCB1ZnNo
cGJfbHUgKmhwYiwgc3RydWN0IHVmc2hjZF9scmINCj4gKmxyYnAsDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB1MzIgbHBuLCB1NjQgcHBuLCAgdW5zaWduZWQgaW50IHRyYW5z
ZmVyX2xlbikNCj4gK3sNCj4gKyAgICAgICB1bnNpZ25lZCBjaGFyICpjZGIgPSBscmJwLT51Y2Rf
cmVxX3B0ci0+c2MuY2RiOw0KPiArDQo+ICsgICAgICAgY2RiWzBdID0gVUZTSFBCX1JFQUQ7DQo+
ICsNCj4gKyAgICAgICBwdXRfdW5hbGlnbmVkX2JlMzIobHBuLCAmY2RiWzJdKTsNCklzIHRoaXMg
bmVlZGVkPyBUaGUgbGJhIGlzIGFscmVhZHkgb2NjdXB5aW5nIGJ5dGVzIDIuLjUNCg0KPiArICAg
ICAgIHB1dF91bmFsaWduZWRfYmU2NChwcG4sICZjZGJbNl0pOw0KPiArICAgICAgIGNkYlsxNF0g
PSB0cmFuc2Zlcl9sZW47DQo+ICt9DQo+ICsNCg0KVGhhbmtzLA0KQXZyaQ0K
