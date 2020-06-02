Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23100C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 13:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFAC20663
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 13:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="guXby4Xi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lc5oP3tC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgFBNiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 09:38:55 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26191 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBNiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 09:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591105134; x=1622641134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=69LEKsY40UHXTnPo8p3nTL9Zfs8D44cA1D6hmcsyr0w=;
  b=guXby4XiP37rbjBv5uIlODdsLLZLoaEaSMZ9cF69OB2x8Q9oG7u9+6Zb
   9RsI+COWbG4FehyNn06PbgZMxNeI/nHDFt+4d06kC8N3t/8yOZRWe9uVc
   bpClmWU9WG/wq/UAIpCiyil8ORF5s3rQA9n/EGyF/YVP6E7WBGSCGWnqA
   YnzKKc7tSGvpn9Gkob7fyhg8ZUCOGGDIk+UnuVHb2mDWcpoG2XXt1xIih
   NMfuM3RlHyblj9DTnneskafQMdPF+ZS4taCBB3NSASg+IuRoGPhtPviKs
   GI5GVYkIREu+WSOR2R+UoxE3vtRnZ+DufJO6DVzMU127XJoytEdqXb3WG
   g==;
IronPort-SDR: 6URL9IC4kJJ0EyWuwULBoTP4xryjXweNjDJSkC5EhtPv1Fx6ZFcvucMSRHAO7eLiD5L+h5KLct
 PN08gt5ag02Ax2Ldyn1CDajfdSrgVw9QImsTFxtR/9Fu1JN5Db3tf+yBGUYR1XonPEmB+KzTGa
 w1F0+wBNk8k4jPosBJqp76sumCk3cvJViOawZbsxIODDcLyZeyUF179yXggpLHJ0TMXfDa9U/i
 /I8xOYjQ4qsSW9ykB98U+7MZvupVE0tQXVKljkDw1GeDbFyDG0/pTop32hHnEiazmUWbc5aO/U
 c/A=
X-IronPort-AV: E=Sophos;i="5.73,464,1583164800"; 
   d="scan'208";a="139350235"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2020 21:38:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESE/RKxAPDN+RazBP8l/Gs1eLtO0XuT42LbXai7881LJAjrhxCIPZqxxPfDddxpHbkqogupZnF3l34w9RrPezY0xlXVYzbkdr7Nr8l6AEVfjDe/YO5afvToWhxZeDxPq3hEiQh+tY/D0JfrYYEmKnRaRlUvSjt43QKePY7MeItT9h4fQSj9tKOvQhhXPTakJbuATCM1ljR7bzr9+6VwmmYik5MYeiTvBrtTFm6TJNr5laLro2BGvHPIdIyVqCKa96nV59xJ8SJxxfS0N96aIPKTud8CjnCCqX14OmnYHET+3hw2kvdhrTvj4CWNukaEk8SEuSW1hqykjz+CmKU83Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69LEKsY40UHXTnPo8p3nTL9Zfs8D44cA1D6hmcsyr0w=;
 b=js7XKywpclXcWCtat/vBA06NolAgTubYvTPju0Yv26fpmMSdAT/motFwwY3hM1IpnLDtsNTYDsPTQmkVOC2UoGKAx6AWJRRK4cgUFsVSnJZg60EoPDNSat/vd6KCuoVWV/Ki+XFGv+XQkpY2LTmJguSDrdlIvuETA/ThTQe/GekxgUZANidKrqspvrVQwdbkPe2um4nyRa9lh9W1PTCzEHW7mkEA00WHSgSQKzM97U4/QjDd2xTU0LWOU2ORIXFXnJs25f6gt5Cp3PuUO63cHK0bU5sKwqYquTzw1Fne6MZU1LsQKMX3PA2qqfATvevLH36v+r5e0470ytdFMu5k4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69LEKsY40UHXTnPo8p3nTL9Zfs8D44cA1D6hmcsyr0w=;
 b=lc5oP3tCQ12YvPx8BuQBU0QI0OOcyKnQHOzYLBVVdaKmPqyNCpZ/Yy/SvMaEESqTk4UHXoNsBjE5E/kdNrna4sbjY4YWkYevAIyDJ1LAulT6XB+iToeFSJUNEOafYTpxEljwSnoM0Q2IKJSwlxXuX2xGvtbFqVaC6mhWXcQIXXI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5215.namprd04.prod.outlook.com (2603:10b6:805:fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Tue, 2 Jun
 2020 13:38:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 13:38:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer while
 memcpy
Thread-Topic: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer
 while memcpy
Thread-Index: AQHWN11kesoGcNEhCkK5z/BoKlc8lajDQ7UQgAHxgoCAAA2lsIAAFHwA
Date:   Tue, 2 Jun 2020 13:38:50 +0000
Message-ID: <SN6PR04MB4640B88EB7E2646311276282FC8B0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200531150831.9946-1-huobean@gmail.com>
         <20200531150831.9946-4-huobean@gmail.com>
         <SN6PR04MB4640741E1DC89A927F8A60A5FC8A0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <43a81bce2159ccd290e5dfe4a69199f56c379ef7.camel@gmail.com>
 <SN6PR04MB464036A74AA935BEE35280CEFC8B0@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB464036A74AA935BEE35280CEFC8B0@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15e0c966-e631-477f-d69b-08d806fa48d2
x-ms-traffictypediagnostic: SN6PR04MB5215:
x-microsoft-antispam-prvs: <SN6PR04MB5215B314E95C5286410FFFB6FC8B0@SN6PR04MB5215.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G/hV1xwh2J6wU7LORrokV1MiNb2y0XxqlEQASmryg9q+zwsPO3HYR1JqpRHhPNByT7+diO1OWPCG8+Kzi1VqY2DeH6MPoDuxbDWwPUzZ/bJgoAllp1Ef95/fDvkU28780c0lAvL0/0no1c+97Q0a1ZdYXgJ833FoAqFIxeb8+kk/69ieNOtZwhQe5+DaLO2jsZBubezzwSH+UtKCzt/tCbDZKbwN6sfXlVKtUdC/xFR7yOgmKsjqNbh9dpYFNkVF/7y33t55aEdWoIhK3C7gtVn3JWO4juIqkT2LeQRD4NnxeD2U1QIJ2wfE5MUKAGv81uAqkFLIcJdCmeActDfWFgPT0DT350F2naPaJVvrQt2bs3iCYyC75bdbONm0N3yB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(2940100002)(76116006)(64756008)(52536014)(71200400001)(66556008)(66946007)(66476007)(33656002)(66446008)(8936002)(55016002)(5660300002)(2906002)(4326008)(498600001)(7696005)(26005)(9686003)(7416002)(83380400001)(6506007)(110136005)(8676002)(53546011)(186003)(86362001)(54906003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Sg3CeawwA89WAD1QRD22Y7ETqTpXOkAgYnaFQT+ITMH85Ral30EssKqeeRJRqGrRhvywmawzzbkNmtj1ujfnTmrSftAGEUtCM0MQR2UUMEC5NHLq4OtliwiYGjkIrQ9bPu+5rZFD4RDGh6s27Ad8f13+WhrtffvmMmdGo3cs9EyiFmh7LTpjD+MW4rNOXEpfxRf4lBgT4NN4HBm7ZZtHpFjPqbsZovgCY5eHjaNb5wtGuwFQUqvsT8xDNH6s8EwFqMQXFt6jG0tNCF8coAtzMT1XWnwWXTnMFqE1c8kD1X0+DBseT74g1fk2ytvi+S6GlLidAinmfaiI5FzpH5530RnGDwEC9/sDptQZJGBoR38JZrHWSfhfh6dZEWFOYg4c56gfPjSpRHUbt2pa5hEXWSxpxCEJMBArpnb9qoua8jAMJGRzZGpBDAu0EvgZAU8iu7htKzAol7ZgZpokZOoaIbLoPmvfdmncdxs53NTT680=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e0c966-e631-477f-d69b-08d806fa48d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 13:38:50.4993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0M93gghdCFAmc2Q0W/c9FzmgD25WBc5HHDNo2tNoJ/wFNyarTONq/eCZOWw1jQFJVpCopBgPWJwHiyCdON9RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5215
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QnV0IHRoaXMgaXMganVzdCBhIHN1Z2dlc3Rpb24uDQpZb3VyIHdheSBpcyBmaW5lIHRvby4NCg0K
VGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBIb3cgYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhlIHVudGVz
dGVkIGF0dGFjaGVkPw0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQo+IA0KPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogQmVhbiBIdW8gPGh1b2JlYW5AZ21haWwuY29tPg0K
PiA+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMiwgMjAyMCAyOjM2IFBNDQo+ID4gVG86IEF2cmkgQWx0
bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPjsgYWxpbS5ha2h0YXJAc2Ftc3VuZy5jb207DQo+ID4g
YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc7IGplamJAbGludXguaWJtLmNvbTsNCj4gPiBtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbTsgc3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tOw0KPiA+IGJlYW5o
dW9AbWljcm9uLmNvbTsgYnZhbmFzc2NoZUBhY20ub3JnOyB0b21hcy53aW5rbGVyQGludGVsLmNv
bTsNCj4gPiBjYW5nQGNvZGVhdXJvcmEub3JnDQo+ID4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NCAzLzVdIHNjc2k6IHVmczogZml4IHBvdGVudGlhbCBhY2Nlc3MgTlVMTCBwb2ludGVy
IHdoaWxlDQo+ID4gbWVtY3B5DQo+ID4NCj4gPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0
ZWQgZnJvbSBvdXRzaWRlIG9mIFdlc3Rlcm4gRGlnaXRhbC4gRG8gbm90IGNsaWNrDQo+ID4gb24g
bGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVy
IGFuZCBrbm93DQo+IHRoYXQNCj4gPiB0aGUgY29udGVudCBpcyBzYWZlLg0KPiA+DQo+ID4NCj4g
PiBoaSBBdnJpDQo+ID4gdGhhbmtzIHJldmlldy4NCj4gPg0KPiA+DQo+ID4gT24gTW9uLCAyMDIw
LTA2LTAxIGF0IDA2OjI1ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiA+IEhpLA0KPiA+
ID4NCj4gPiA+ID4gSWYgcGFyYW1fb2Zmc2V0IGlzIG5vdCAwLCB0aGUgbWVtY3B5IGxlbmd0aCBz
aG91bGRuJ3QgYmUgdGhlDQo+ID4gPiA+IHRydWUgZGVzY3JpcHRvciBsZW5ndGguDQo+ID4gPiA+
DQo+ID4gPiA+IEZpeGVzOiBhNGIwZThhNGU5MmIgKCJzY3NpOiB1ZnM6IEZhY3RvciBvdXQNCj4g
PiA+ID4gdWZzaGNkX3JlYWRfZGVzY19wYXJhbSIpDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEJl
YW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDIgKy0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4g
PiA+ID4gaW5kZXggZjdlOGJmZWZlM2Q0Li5iYzUyYTBlODljZDMgMTAwNjQ0DQo+ID4gPiA+IC0t
LSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiA+ID4gPiBAQCAtMzIxMSw3ICszMjExLDcgQEAgaW50IHVmc2hjZF9y
ZWFkX2Rlc2NfcGFyYW0oc3RydWN0IHVmc19oYmENCj4gPiA+ID4gKmhiYSwNCj4gPiA+ID4NCj4g
PiA+ID4gICAgICAgICAvKiBDaGVjayB3aGVyaGVyIHdlIHdpbGwgbm90IGNvcHkgbW9yZSBkYXRh
LCB0aGFuIGF2YWlsYWJsZQ0KPiA+ID4gPiAqLw0KPiA+ID4gPiAgICAgICAgIGlmIChpc19rbWFs
bG9jICYmIHBhcmFtX3NpemUgPiBidWZmX2xlbikNCj4gPiA+ID4gLSAgICAgICAgICAgICAgIHBh
cmFtX3NpemUgPSBidWZmX2xlbjsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHBhcmFtX3NpemUg
PSBidWZmX2xlbiAtIHBhcmFtX29mZnNldDsNCj4gPiA+DQo+ID4gPiBCdXQgSXNfa21hbGxvYyBp
cyB0cnVlIGlmIChwYXJhbV9vZmZzZXQgIT0gMCB8fCBwYXJhbV9zaXplIDwNCj4gPiA+IGJ1ZmZf
bGVuKQ0KPiA+ID4gU28gIGlmIChpc19rbWFsbG9jICYmIHBhcmFtX3NpemUgPiBidWZmX2xlbikg
aW1wbGllcyB0aGF0DQo+ID4gPiBwYXJhbV9vZmZzZXQgaXMgMCwNCj4gPiA+IE9yIGRpZCBJIGdl
dCBpdCB3cm9uZz8NCj4gPg0KPiA+IElmIHBhcmFtX29mZnNldCBpcyAwLCBUaGlzIHdpbGxuJ3Qg
Z2V0IGFueSB3cm9uZywgYWZ0ZXIgdGhpcyBwYXRjaCwgaXQNCj4gPiBpcyB0aGUgc2FtZSBzaW5j
ZSBvZmZzZXQgaXMgMC4gQXMgbWVudGlvbmVkIGluIHRoZSBjb21taXQgbWVzc2FnZSwgdGhpcw0K
PiA+IHBhdGNoIGlzIG9ubHkgZm9yIHRoZSBjYXNlIG9mIHBhcmFtX29mZnNldCBpcyBub3QgMC4N
Cj4gPg0KPiA+ID4NCj4gPiA+IFN0aWxsLCBJIHRoaW5rIHRoYXQgdGhlcmUgaXMgYSBwcm9ibGVt
IGhlcmUgYmVjYXVzZSBub3doZXJlIHdlIGFyZQ0KPiA+ID4gY2hlY2tpbmcgdGhhdA0KPiA+ID4g
cGFyYW1fb2Zmc2V0ICsgcGFyYW1fc2l6ZSA8IGJ1ZmZfbGVuLCB3aGljaCBub3cgY2FuIGhhcHBl
biBiZWNhdXNlIG9mDQo+ID4gPiB1ZnMtYnNnLg0KPiA+ID4gTWF5YmUgeW91IGNhbiBhZGQgaXQg
YW5kIGdldCByaWQgb2YgdGhhdCBpc19rbWFsbG9jIHdoaWNoIGlzIGFuDQo+ID4gPiBhd2t3YXJk
IHdheSB0byB0ZXN0IGZvciB2YWxpZCB2YWx1ZXM/DQo+ID4NCj4gPiBsZXQgbWUgZXhwbGFpbiBm
dXJ0aGVyOg0KPiA+IHdlIGhhdmUgdGhlc2UgY29uZGl0aW5vczoNCj4gPg0KPiA+IDEpIHBhcmFt
X29mZnNldCA9PSAwLCBwYXJhbV9zaXplID49IGJ1ZmZfbGVuOy8vbm8gcHJvYmxlbSwNCj4gPiB1
ZnNoY2RfcXVlcnlfZGVzY3JpcHRvcl9yZXRyeSgpIHdpbGwgcmVhZCBkZXNjcmlwb3Igd2l0aCB0
cnVlDQo+ID4gZGVzY3JpcHRvciBsZW5ndGgsIGFuZCBubyBtZW1jcHkoKSBjYWxsZWQuDQo+ID4N
Cj4gPg0KPiA+IDIpIHBhcmFtX29mZnNldCA9PSAwLCBwYXJhbV9zaXplIDwgYnVmZl9sZW47Ly8g
bm8gcHJvYmxlbSwNCj4gPiB1ZnNoY2RfcXVlcnlfZGVzY3JpcHRvcl9yZXRyeSgpIHdpbGwgcmVh
ZCBkZXNjcmlwb3Igd2l0aCB0cnVlDQo+ID4gZGVzY3JpcHRvciBsZW5ndGggYnVmZl9sZW4sIGFu
ZCBtZW1jcHkoKSB3aXRoIHBhcmFtX3NpemUgbGVuZ3RoLg0KPiA+DQo+ID4NCj4gPiAzKSBwYXJh
bV9vZmZzZXQgIT0gMCwgcGFyYW1fb2Zmc2V0ICsgcGFyYW1fc2l6ZSA8PSBidWZmX2xlbjsvLyBu
bw0KPiA+IHByb2JsZW0sIHVmc2hjZF9xdWVyeV9kZXNjcmlwdG9yX3JldHJ5KCkgd2lsbCByZWFk
IGRlc2NyaXBvciB3aXRoIHRydWUNCj4gPiBkZXNjcmlwdG9yIGxlbmd0aCwgYW5kIG1lbWNweSgp
IHdpdGggcGFyYW1fc2l6ZSBsZW5ndGguDQo+ID4NCj4gPg0KPiA+IDQpIHBhcmFtX29mZnNldCAh
PSAwLCBwYXJhbV9vZmZzZXQgKyBwYXJhbV9zaXplID4gYnVmZl9sZW47Ly8gTlVMTA0KPiA+IHBv
aW50ZXIgcmVmZXJlbmNlIHByb2JsZW0sIHNpbmNlIHVmc2hjZF9xdWVyeV9kZXNjcmlwdG9yX3Jl
dHJ5KCkgd2lsbA0KPiA+IHJlYWQgZGVzY3JpcG9yIHdpdGggdHJ1ZSBkZXNjcmlwdG9yIGxlbmd0
aCwgYW5kIG1lbWNweSgpIHdpdGggYnVmZl9sZW4NCj4gPiBsZW5ndGguIGNvcnJlY3QgbWVtY3B5
IGxlbmd0aCBzaG91bGQgYmUgKGJ1ZmZfbGVuIC0gcGFyYW1fb2Zmc2V0KQ0KPiA+DQo+ID4gcGFy
YW1fb2Zmc2V0ICsgcGFyYW1fc2l6ZSA8IGJ1ZmZfbGVuIGRvZXNuJ3QgbmVlZCB0byBhZGQsIGFu
ZA0KPiA+IGlzX2ttYWxsb2MgaXMgdmVyeSBoYXJkIHRvIGJlIHJlbW92ZWQgYmFzZWQgb24gY3Vy
cmVudCBmbG93Lg0KPiA+DQo+ID4gc28sIHRoZSBjb3JyZWN0IGZpeHVwIHBhdGNoIHNob3VsYmUg
YmUgbGlrZSB0aGlzOg0KPiA+DQo+ID4NCj4gPiAtaWYgKGlzX2ttYWxsb2MgJiYgcGFyYW1fc2l6
ZSA+IGJ1ZmZfbGVuKQ0KPiA+IC0gICAgICAgcGFyYW1fc2l6ZSA9IGJ1ZmZfbGVuDQo+ID4gK2lm
IChpc19rbWFsbG9jICYmIChwYXJhbV9zaXplICsgcGFyYW1fb2Zmc2V0KSA+IGJ1ZmZfbGVuKQ0K
PiA+ICsgICAgICAgcGFyYW1fc2l6ZSA9IGJ1ZmZfbGVuIC0gcGFyYW1fb2Zmc2V0Ow0KPiA+DQo+
ID4NCj4gPiBob3cgZG8geW91IHRoaW5rIGFib3V0IGl0PyBpZiBubyBwcm9ibGVtLCBJIHdpbGwg
dXBkYXRlIGl0IGluIG5leHQNCj4gPiB2ZXJzaW9uIHBhdGNoLg0KPiA+DQo+ID4gdGhhbmtzLA0K
PiA+DQo+ID4gQmVhbg0KDQo=
