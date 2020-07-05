Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C79C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 10:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C082920786
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 10:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aWrIIUjC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vyx4U8/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgGEKyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 06:54:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46961 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGEKx7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 06:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593946439; x=1625482439;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=EbmNLr5WCWyxaBnB1i9cYhSkGVBuM+mvzZ7X0kO31jE=;
  b=aWrIIUjCGHP+tcOiEXckMCPg0mw63Gyem1chnsLhGHRtuQ6ZbxQCCmce
   D01nHm+QumQLK3n7CPnhDSMWPjTu9Drhm5qM6OTsDZfLsbCBAig9AnQ7s
   X6xmxvu67wpbtu8Wk42t8sOl7LvG0FCF8lWlk2loiFI3NSFfRLVxH5cYT
   7kVr0bdG0qtMBkgjGeZ0d/CzokHZP7KzNz/bOBqWMZNXAqKHoWlUVHNtn
   dHxtiHcJJDuWEGwng+KYb7Qt7GinoimCGcdnS0QBFNrNHPAZfrSmi1Q44
   p4jC9iUWKqfQvpexRQ+Ar8t35LZKS2rYliEPOorzA7lVcp+BQphE+xPLj
   w==;
IronPort-SDR: v7VpWvE3BLVBvooqaVhEEGNX1iwQFuLuWYx8eWXVYNMNL+AM0EqnGMr/UAkE2yd/3G+kML6zx0
 SW7c0oDoSpJJ6EIJE2sAZabzXZhaUCmVu8uRQU5FtIgo/6c8pRKaeD3utDxbeHF3le4InfIoGK
 biddOvUsPKS/dn05yH3t+UY0dq9bHEH8Mss9ifXYAsEy6Nptsf+r40gxWASfN/fby+FU19jdMK
 JwI10GKh20heYddxoAVFgDbRXmDNHWAFRK/JPD9nHISqsLywI+oOPsgAt3LSZ+kQHpyvkE3cx5
 0Sc=
X-IronPort-AV: E=Sophos;i="5.75,314,1589212800"; 
   d="scan'208";a="250909595"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2020 18:53:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obaSCyawLhsx/zEWVeFVYVX2heNGOr9QL7OXipb7Pr1FDwC8kY+1obVUaPWADgoy+VMQ1+4X8KY+xl6dhzHIgxD3chVP2F9A7UPEOpUuY5QaZnH5pZ2svu79usa+p4NubhoDs0cR6EANxZFlv1V5U326eX0gnqeW/NyuYBPCH7SvK54dio9XkCwsay8SwziOl79grG9AkN/gDN43nj1b0t9wCJHJoY6IhpYzn+HxntXY5Wt7h7KaeUWZ2ri88zBu1UTit5v2uU74ndk2hPkIfdKLakzJg/oKJDkJfK7LTRPkYhTeSVZj80zUmt2TsqCu9/aOh3mU/cbMcVQ+Ep+cwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbmNLr5WCWyxaBnB1i9cYhSkGVBuM+mvzZ7X0kO31jE=;
 b=Qu7GcK/RZuBRj6AQFl0O3pmSxpZSij3vGCSykYGIJ4jDlTzNIZ7DB5bBzFlp7plqXcaPx3qRwqOFYGFgc/NTG7dvC/C3D1sfvzc5o32uneAJ8qPKvrttbs9RTp7mcJxf92Hu9kWYmmro7dAX92siAx7SzM2aQ60mCFIMpBjbayotK7RznEDhhEA1Xo5VhR6CuFIJajIgG5i3WnQwSs1hmQ1yJk7CI62ynn96e2LS+2YQ3WFpQlHzH6v+S80YQWKD2FbzcchRS6AroNUQPPE/EZy6YIE5VyfntjbJiDQkskviRC1siynoIIzcq11j4qbRAGMJxjqkzvBinDpLIGS3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbmNLr5WCWyxaBnB1i9cYhSkGVBuM+mvzZ7X0kO31jE=;
 b=vyx4U8/6Tf6aIcL3rTIf7qhmrb8aPX/VKPVSHTkq+DSSiTL1x/lUKZSGqQumBLN9xGcS/ODMDCJbH3mFQMbTBWo/mMF17zxzzfOVJyLcXAyWqIH1V4IlF7AXEEu8kfIkmUhAit1MsLtbq/hF2GeUbM+CgFyZiBqwj9BqMYKJHKw=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2174.namprd04.prod.outlook.com (2603:10b6:804:10::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sun, 5 Jul
 2020 10:53:56 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 10:53:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Thread-Topic: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Thread-Index: AQHWUPwly5H0uZYgGUG1+rOfEKNiqaj4zySg
Date:   Sun, 5 Jul 2020 10:53:55 +0000
Message-ID: <SN6PR04MB46407E21E411B7E785C3B3C1FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f@epcas2p3.samsung.com>
 <08bc1641fdce941175596fe106fd5c02161683bf.1593753896.git.kwmad.kim@samsung.com>
In-Reply-To: <08bc1641fdce941175596fe106fd5c02161683bf.1593753896.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d4548982-92a9-440a-ca3a-08d820d1b6d2
x-ms-traffictypediagnostic: SN2PR04MB2174:
x-microsoft-antispam-prvs: <SN2PR04MB217456D8E4876484D156A378FC680@SN2PR04MB2174.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 045584D28C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6vPwCYOcPJOWyfXYmukVjBcNRd/YN2/De1CA5f29YdbSll6QKrbHR5H1bLz8URfb+CNsFZ3Ar6yVcMWbF9VU9uD1i6OZWoYXhiMwMDW8pNv88psPPvpqsDW4w8DVs8tqedPE3ikV3XVXW1azFw97QLX/qgazNp/r7kHbqABNbWDlu9o74pnjvB3IzvcfwdBh17rxDkus6sYtWeSG1mtCuw84B9Ag0F1bBQzjXpTsTIQ5fRCawSFwut4YNw/lHwitUffbSAO1/lqVr1T9NwUaCJDWshGODbCoVOW1u3fRei6Th1m/Dy0Y7Jo1I4A65IEDjBOIjZkJ/SHHTCSxzRPcuXVDZ+HqztR7cd81Ap3VC6f/Lz9wVJpT058Jg5KRuKl0GdH2e+/M0sySXb13EQlCpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(39850400004)(396003)(9686003)(86362001)(186003)(478600001)(55016002)(33656002)(7696005)(6506007)(2906002)(71200400001)(66946007)(26005)(76116006)(8936002)(8676002)(66556008)(64756008)(316002)(66476007)(66446008)(7416002)(52536014)(83380400001)(5660300002)(110136005)(43043002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sWMUcGBPjSZQuiUEqJVAXGlzE5MfVl9/j3KrQ3VQTyeJBizSnvHDGJXO+LLuqz6XweQnfj/cN8VgtyzePBl+mjLv9AEv9tu3eJrCZcawgHxL19QIOsZJf+n62vsX62NP2ku+DXXcR0Y1yo2LtLk/EPrDNuA6Up5dp7A5Jg1bOML49TN6o1a9qIu8G4fQWVwDRelp8GkRL16ObhS+/+EckGL97g5xMZ7FHaeYEWPP6bp0OM/qzyGRAJQzrV1afrOiaADEwUHMrb36rsiP7jFoufLU+IvR2jDeck3CWDwW8QFSS1KKtK8TyYGkJ/LQ2xW5KwoWpJKkzcxhReYJSBDyF3BwQCbehdQ78dh4y/9Qi6nH6mxCg/aL5OrHvITrWro91rTTjkMYL+3C8p+JOnqtG7F8KaRWIO+OH3bYaIaeUHGdLm1ne3Tiw1uU+rbhcXZ6EJwbRV28wmSRI19p6IlHWqQb9xCd1Qk+9v9Mv31kmTs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4548982-92a9-440a-ca3a-08d820d1b6d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2020 10:53:55.7378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKjuXNXogZcnExK1ivb4XMlIsU/rGfQgG63IZOU2C2RQdoxhZJ76QarCVFtF422sCiwYRB8gF+tckqv8o5BJAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gQ3VycmVudGx5LCBVRlMgZHJpdmVyIGNoZWNrcyBpZiBmRGV2aWNlSW5pdA0KPiBp
cyBjbGVhcmVkIGF0IHNldmVyYWwgdGltZXMsIG5vdCBwZXJpb2QuIFRoaXMgcGF0Y2gNCj4gaXMg
dG8gd2FpdCBpdHMgY29tcGxldGlvbiB3aXRoIHRoZSBwZXJpb2QsIG5vdCByZXRyeWluZy4NCj4g
TWFueSBkZXZpY2UgdmVuZG9ycyB1c3VhbGx5IHByb3ZpZGVzIHRoZSBzcGVjaWZpY2F0aW9uIG9u
DQo+IGl0IHdpdGgganVzdCBwZXJpb2QsIG5vdCBhIGNvbWJpbmF0aW9uIG9mIGEgbnVtYmVyIG9m
IHJldHJ5aW5nDQo+IGFuZCBwZXJpb2QuIFNvIGl0IGNvdWxkIGJlIHByb3BlciB0byByZWdhcmQg
dG8gdGhlIGluZm9ybWF0aW9uDQo+IGNvbWluZyBmcm9tIGRldmljZSB2ZW5kb3JzLg0KPiANCj4g
SSBmaXJzdCBhZGRlZCBvbmUgZGV2aWNlIHNwZWNpZmljIHZhbHVlIHJlZ2FyZGluZyB0aGUgaW5m
b3JtYXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNh
bXN1bmcuY29tPg0KSSBzdGlsbCB0aGluayB0aGF0IHRoaXMgcGF0Y2ggYWxvbmUgaXMgZmluZSwg
YW5kIHlvdSBkb24ndCBuZWVkIGl0cyBwcmVkZWNlc3Nvci4NClRoZSBzcGVjIHJlcXVpcmVzIHBv
bGxpbmcsIHNvIHRoaXMgaXMgYSBmb3JtIG9mIGEgbW9yZS1lZmZlY3RpdmUtcG9sbGluZzogc28g
YmUgaXQuDQoNCg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCAzNiArKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBp
bnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCBi
MjZmMTgyLi42YzA4ZWQyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
DQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTIwOCw2ICsyMDgsNyBA
QCBzdGF0aWMgc3RydWN0IHVmc19kZXZfZml4IHVmc19maXh1cHNbXSA9IHsNCj4gIH07DQo+IA0K
PiAgc3RhdGljIGNvbnN0IHN0cnVjdCB1ZnNfZGV2X3ZhbHVlIHVmc19kZXZfdmFsdWVzW10gPSB7
DQo+ICsgICAgICAge1VGU19WRU5ET1JfVE9TSElCQSwgVUZTX0FOWV9NT0RFTCwgREVWX1ZBTF9G
REVWSUNFSU5JVCwgMjAwMCwNCj4gZmFsc2V9LA0KPiAgICAgICAgIHswLCAwLCAwLCAwLCBmYWxz
ZX0sDQo+ICB9Ow0KPiANCj4gQEAgLTQxNjIsOSArNDE2MywxMiBAQCBFWFBPUlRfU1lNQk9MX0dQ
TCh1ZnNoY2RfY29uZmlnX3B3cl9tb2RlKTsNCj4gICAqLw0KPiAgc3RhdGljIGludCB1ZnNoY2Rf
Y29tcGxldGVfZGV2X2luaXQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gLSAgICAgICBp
bnQgaTsNCj4gKyAgICAgICB1MzIgZGV2X2luaXRfY29tcGxfaW5fbXMgPSAxMDAwOw0KPiArICAg
ICAgIHVuc2lnbmVkIGxvbmcgdGltZW91dDsNCj4gICAgICAgICBpbnQgZXJyOw0KPiAgICAgICAg
IGJvb2wgZmxhZ19yZXMgPSB0cnVlOw0KPiArICAgICAgIGJvb2wgaXNfZGV2X3ZhbDsNCj4gKyAg
ICAgICB1MzIgdmFsOw0KPiANCj4gICAgICAgICBlcnIgPSB1ZnNoY2RfcXVlcnlfZmxhZ19yZXRy
eShoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1NFVF9GTEFHLA0KPiAgICAgICAgICAgICAgICAgUVVF
UllfRkxBR19JRE5fRkRFVklDRUlOSVQsIDAsIE5VTEwpOw0KPiBAQCAtNDE3NSwyMCArNDE3OSwy
OCBAQCBzdGF0aWMgaW50IHVmc2hjZF9jb21wbGV0ZV9kZXZfaW5pdChzdHJ1Y3QNCj4gdWZzX2hi
YSAqaGJhKQ0KPiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ICAgICAgICAgfQ0KPiANCj4g
LSAgICAgICAvKiBwb2xsIGZvciBtYXguIDEwMDAgaXRlcmF0aW9ucyBmb3IgZkRldmljZUluaXQg
ZmxhZyB0byBjbGVhciAqLw0KPiAtICAgICAgIGZvciAoaSA9IDA7IGkgPCAxMDAwICYmICFlcnIg
JiYgZmxhZ19yZXM7IGkrKykNCj4gLSAgICAgICAgICAgICAgIGVyciA9IHVmc2hjZF9xdWVyeV9m
bGFnX3JldHJ5KGhiYSwNCj4gVVBJVV9RVUVSWV9PUENPREVfUkVBRF9GTEFHLA0KPiAtICAgICAg
ICAgICAgICAgICAgICAgICBRVUVSWV9GTEFHX0lETl9GREVWSUNFSU5JVCwgMCwgJmZsYWdfcmVz
KTsNCj4gKyAgICAgICAvKiBQb2xsIGZEZXZpY2VJbml0IGZsYWcgdG8gYmUgY2xlYXJlZCAqLw0K
PiArICAgICAgIGlzX2Rldl92YWwgPSB1ZnNfZ2V0X2Rldl9zcGVjaWZpY192YWx1ZShoYmEsIERF
Vl9WQUxfRkRFVklDRUlOSVQsDQo+ICZ2YWwpOw0KPiArICAgICAgIGRldl9pbml0X2NvbXBsX2lu
X21zID0gKGlzX2Rldl92YWwpID8gdmFsIDogNTAwOw0KSWYgeW91IHdhbnQgZGV2X2luaXRfY29t
cGxfaW5fbXMgdG8gdGFrZSBpdHMgZGVmYXVsdCAxLDAwMCwgeW91IHNob3VsZDoNCmRldl9pbml0
X2NvbXBsX2luX21zID0gKCFpc19kZXZfdmFsKSA/IDogdmFsOw0KDQo+ICsgICAgICAgdGltZW91
dCA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKGRldl9pbml0X2NvbXBsX2luX21zKTsNCj4g
KyAgICAgICBkbyB7DQo+ICsgICAgICAgICAgICAgICBlcnIgPSB1ZnNoY2RfcXVlcnlfZmxhZyho
YmEsIFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFFVRVJZX0ZMQUdfSUROX0ZERVZJQ0VJTklULCAwLCAmZmxhZ19y
ZXMpOw0KPiArICAgICAgICAgICAgICAgaWYgKCFmbGFnX3JlcykNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgYnJlYWs7DQo+ICsgICAgICAgICAgICAgICB1c2xlZXBfcmFuZ2UoNSwgMTApOw0K
UGVyIEdyYW50J3MgY29tbWVudDoNCnVzbGVlcF9yYW5nZSg1MDAwLCAxMDAwMCk7DQo=
