Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B7CC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 07:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1F0206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 07:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A1drjCBM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ixq9ZY7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHIHwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 03:52:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23273 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgHIHwF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 03:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596959526; x=1628495526;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=WzUJzcp51244/gktFqGxdvz7y89813lY6SSLbkgLd98=;
  b=A1drjCBM1dJ2yVDZGUcYhqQjVIDL5G1AGqJtQXvs4WDmNpU0kaX9ZEKf
   VGSnr1B+uWphefJGAJ4xbtEJ/Rqdn4Osr0CIXxu7ydE/9zJnah5BwugIl
   DuwRD7eevzpzy2sEBKcKDzC6YGEsJc9qL8rjfUm1uiDw2vrp12KddG+H3
   JCwrdOCp4YBMogcSyMG/+Kvjosac+/u0TvbAdFntDz8XRFcY2StQXtnBN
   PvLJWhTDmm5Z2ZLOS+0QziBvDaFtreN3jMJS1lbATI680G0BVSzCKJ+Vi
   ijN7+5cILdDz5WXVYWfk/yubgoFDG4GXh45jKAdZbenx6EyteWafu2mZW
   A==;
IronPort-SDR: U8EssqN8RdLCNCICwxRZHQKDo+9aikzZl/GKkZ840yWQMLCNZJtmy8yzL5u2qZjt2OeIE1SbL0
 yTuSew2x+gY89siuBci5C9tY7pztF+0HVf/cc819wgBh7xmfIEtNzRpiUsPygqIADfu9v1gB4p
 fiLSbxF2fao1mzvs56aRSIpvlRbsn9lh8roXAbR7bEs49WehtdckaAIpk/QxCWLJ6R8zJY5xMW
 aRWsx2Be2NXigXlWzQnythHa3UU2D6Bik8KNTbMWZL19xReDHDOGPdZEwxytzZ/sZKk6vAwq1R
 1+k=
X-IronPort-AV: E=Sophos;i="5.75,452,1589212800"; 
   d="scan'208";a="148817517"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2020 15:52:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nl02CGhr2q8iHqg72ijvRi4hhWGmsRXwMaLTz4G2fJ8rw3HKqrSqXtQ0jShZVkhUK2+Dz6JH7ZbEU3pIbK/9/gOzNtwxTAhoFXQ2r+59Io/oNow9qS6RycEHfpB4oF8gGOCShPhdk5UM2cp9H7APl+E8aEdQRju8pYSR5u1VztPHGgxS8xnd7GX2bDu9JbMScx5RhTF+8sRQWsJcW6aZFHy7CZ9WoPDENgfNMhQoiNVSsMx2mkN0n6lfddtXLaDDql3R/eJpEu+tee/VtwFVco3OsUKQTfDc2HiBdI/hTcJ0ohP3PeTH6oYtX6ui6geoFn/4f8M0y24HaEc2fQN5ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzUJzcp51244/gktFqGxdvz7y89813lY6SSLbkgLd98=;
 b=TASk5WOCD7I6x+c9o2UJO+UhaueF+kyllbShLy2Yzqf8EnkrPFmn8+YlOyb/OKOXwNKagrPh7Fmyo3BVZoDgosdkkFvAitSn5VjnEdunuCGsBlUbpz0VhEHSgw8b+xt+GgJXH0MGxJsW2OCxy8gpYFDu85WaG1FPuZrAZ5JenD9+WzykCWouhfmhzelm15OQO+3FCeHfKLppKBPIGv3g3b3S9TqyBuT6lccqOeX/XEQ83K2Z6c+3H1rGmlQCB82Y4Kwilt0a958z/Qq181hLfvpb1aZKhtv91MNAJxiG6jLpbyQfbp9FHqIqbrfUf0kvt7DdAI/usEzzHt+NkB7whw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzUJzcp51244/gktFqGxdvz7y89813lY6SSLbkgLd98=;
 b=Ixq9ZY7mqndOWcjfK3TJYVe/H4pMntkNLpt6Sopc5WwtsCUtL+7V1Rt9u7mylneDKjXznf0KlT6qIDudHzw13OKw8ESEtFqRie6urMEO6BVARseO3DwXba8sfk3vkrnf34idOrjCUNb+Ojq0ACojE6nG9Pk2vyN22IswI8A6wRY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4189.namprd04.prod.outlook.com (2603:10b6:805:30::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Sun, 9 Aug
 2020 07:52:01 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.022; Sun, 9 Aug 2020
 07:52:01 +0000
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
Subject: RE: [PATCH v1] ufs: change the way to complete fDeviceInit
Thread-Topic: [PATCH v1] ufs: change the way to complete fDeviceInit
Thread-Index: AQHWbIiZHP99j6WE0U6Jw6pHGTSjh6kvaG/w
Date:   Sun, 9 Aug 2020 07:52:01 +0000
Message-ID: <SN6PR04MB4640CCC89B4DE5F019145933FC470@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b@epcas2p1.samsung.com>
 <1596783176-183741-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1596783176-183741-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 003027be-84b7-4951-218f-08d83c3919d9
x-ms-traffictypediagnostic: SN6PR04MB4189:
x-microsoft-antispam-prvs: <SN6PR04MB41890922CBD45C4ABEA12696FC470@SN6PR04MB4189.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QpmuAMdAdBnE68s4ygs9A6+2q3+j4uj92db5tqXewaJs+jVE1i0glcaADMC2C36ZF+qIuuCHQ7nI62lKMIBe3pOwAzq+eqkr5KHiFZkolah608/3ehvOCBXUR+VmOwVW4qgOxXbCP6jUu10pLHIvr592NFb+3g7VS9JOUhnEKGDvE1qb8RbrmcezzRs4ZMZs9eJ+rU+T7WlM+iMR6ttrZupBY+orcwB9Jm6/plfeHsWGMDNGgrTcINKFOLpNuPky5mHH44fKUPeqeIL+fuRChSGQxWhYgHeRh3gg0Dl6lYmOro9F+vK4iVwKrnencBZyoxpdH7q4wCWsh27KjE7TYr1oj+ziA6rLhBo4k7aNZ3h4CgWgPeDNE/nlhN3hgM7Zah1rc3UdwX+imKrOjolUuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(366004)(396003)(346002)(376002)(5660300002)(55016002)(9686003)(83380400001)(8936002)(8676002)(2906002)(86362001)(478600001)(7416002)(66556008)(66446008)(6506007)(7696005)(71200400001)(66476007)(64756008)(186003)(76116006)(26005)(66946007)(52536014)(316002)(33656002)(110136005)(921003)(43043002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tEB3Afd+8J0/SrI7JEmLTatDmIcl+2TK7rN7s8kiXoVKNz4mVqhZ3IOxRHufMULVqFOMbXirddCNX9OalGQ4j8v6Z6gB8ltdHZJrX6ssl7JDywbkTTuCiFOWqxfQ1ju7jRuy5i2n2Ta1UbsVSdCpym1xjqzBr6rWS1aridrCwJZJM7P4GGWg0m0Ph8llq8JOqnByyuUkDUSFbtVFejb/XUHqShMpIsQiEhwenwW7pUhk9lktlUqma5B0AbBmKkid+ZQt3F+qHqklWIgbzElghEr6BUWqoC4bO6Z8uB4FCZs+QgiSH7ad4ROzkClG8qkhIm36R1YilrLy7Kl6WY5+27GrvBvrWtnatiors8aS5yNQZmvyLd18vf5j6MQ1XCiGrAmmgY/RMWBrOZQhvYQwrQ96PWU/djmKqDdt2dWUa3UQjGyWCPE/KN5w31bSyruj5T1kZBXUd6cAwnYqE+kuBF1vxzhtip6NvCrOvJG5Rqok0jYZS8naOHTaW5fMpazvFGH/xG1EOuUoTZAhDqHsCcfW087gw/faGjkYsIctW+yICTXN3xrJxNh88AqZnuVri9ly+BLA3Hy71nzktCNRKGAO0JB3Fcl+Nja6pfWKfUYNR9UOXdzdn1npmQDc+Cy70p6I0pku8MeEupXIUeC+lA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003027be-84b7-4951-218f-08d83c3919d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2020 07:52:01.4069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6fEMGPlvKkVJSEyO2lAKStobwdYBplqpS4xHyMu6GVppU4ef1u0IiYKgL+dJThk5wR53xKK3ate9FzrBA8DN4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4189
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
U2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMzEgKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEyIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IDA5MjQ4MGEuLmM1MDg5MzEgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiBAQCAtNDE0OCw3ICs0MTQ4LDggQEAgRVhQT1JUX1NZTUJPTF9HUEwo
dWZzaGNkX2NvbmZpZ19wd3JfbW9kZSk7DQo+ICAgKi8NCj4gIHN0YXRpYyBpbnQgdWZzaGNkX2Nv
bXBsZXRlX2Rldl9pbml0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+IC0gICAgICAgaW50
IGk7DQo+ICsgICAgICAgdTMyIGRldl9pbml0X2NvbXBsX2luX21zID0gMTUwMDsNClBsZWFzZSBt
YWtlIHRoZSB0aHJlc2hvbGQgYSBkZWZpbmUuICBPdGhlcndpc2UsIHlvdXIgY29kZSBsb29rcyBm
aW5lLg0KUmVjZW50bHkgd2Ugc3RhcnRlZCB0byBpbnRyb2R1Y2UgdGhlIHVzZSBvZiBrdGltZSBj
b252ZW50aW9uIGFuZCBvcGVyYXRvcnMgZm9yIHN1Y2ggdXNlIGNhc2VzLg0KV291bGQgeW91IGNv
bnNpZGVyIHVzaW5nIGl0IGFzIHdlbGw/DQoNClRoYW5rcywNCkF2cmkNCg0KPiArICAgICAgIHVu
c2lnbmVkIGxvbmcgdGltZW91dDsNCj4gICAgICAgICBpbnQgZXJyOw0KPiAgICAgICAgIGJvb2wg
ZmxhZ19yZXMgPSB0cnVlOw0KPiANCj4gQEAgLTQxNjEsMjAgKzQxNjIsMjYgQEAgc3RhdGljIGlu
dCB1ZnNoY2RfY29tcGxldGVfZGV2X2luaXQoc3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gICAg
ICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiAgICAgICAgIH0NCj4gDQo+IC0gICAgICAgLyogcG9s
bCBmb3IgbWF4LiAxMDAwIGl0ZXJhdGlvbnMgZm9yIGZEZXZpY2VJbml0IGZsYWcgdG8gY2xlYXIg
Ki8NCj4gLSAgICAgICBmb3IgKGkgPSAwOyBpIDwgMTAwMCAmJiAhZXJyICYmIGZsYWdfcmVzOyBp
KyspDQo+IC0gICAgICAgICAgICAgICBlcnIgPSB1ZnNoY2RfcXVlcnlfZmxhZ19yZXRyeShoYmEs
DQo+IFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywNCj4gLSAgICAgICAgICAgICAgICAgICAg
ICAgUVVFUllfRkxBR19JRE5fRkRFVklDRUlOSVQsIDAsICZmbGFnX3Jlcyk7DQo+ICsgICAgICAg
LyogUG9sbCBmRGV2aWNlSW5pdCBmbGFnIHRvIGJlIGNsZWFyZWQgKi8NCj4gKyAgICAgICB0aW1l
b3V0ID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoZGV2X2luaXRfY29tcGxfaW5fbXMpOw0K
PiArICAgICAgIGRvIHsNCj4gKyAgICAgICAgICAgICAgIGVyciA9IHVmc2hjZF9xdWVyeV9mbGFn
KGhiYSwgVVBJVV9RVUVSWV9PUENPREVfUkVBRF9GTEFHLA0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgUVVFUllfRkxBR19JRE5fRkRFVklDRUlOSVQsIDAsICZmbGFn
X3Jlcyk7DQo+ICsgICAgICAgICAgICAgICBpZiAoIWZsYWdfcmVzKQ0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBicmVhazsNCj4gKyAgICAgICAgICAgICAgIHVzbGVlcF9yYW5nZSg1MDAwLCAx
MDAwMCk7DQo+ICsgICAgICAgfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkp
Ow0KPiANCj4gLSAgICAgICBpZiAoZXJyKQ0KPiArICAgICAgIGlmIChlcnIpIHsNCj4gICAgICAg
ICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICIl
cyByZWFkaW5nIGZEZXZpY2VJbml0IGZsYWcgZmFpbGVkIHdpdGggZXJyb3IgJWRcbiIsDQo+IC0g
ICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCBlcnIpOw0KPiAtICAgICAgIGVsc2UgaWYg
KGZsYWdfcmVzKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIlcyByZWFkaW5n
IGZEZXZpY2VJbml0IGZsYWcgZmFpbGVkIHdpdGggZXJyb3IgJWRcbiIsDQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgX19mdW5jX18sIGVycik7DQo+ICsgICAgICAgfSBlbHNlIGlm
IChmbGFnX3Jlcykgew0KPiAgICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwNCj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgIiVzIGZEZXZpY2VJbml0IHdhcyBub3QgY2xlYXJlZCBieSB0
aGUgZGV2aWNlXG4iLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNfXyk7DQo+IC0N
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiJXMgZkRldmljZUluaXQgd2FzIG5v
dCBjbGVhcmVkIGJ5IHRoZSBkZXZpY2VcbiIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX19mdW5jX18pOw0KPiArICAgICAgICAgICAgICAgZXJyID0gLUVCVVNZOw0KPiArICAg
ICAgIH0NCj4gIG91dDoNCj4gICAgICAgICByZXR1cm4gZXJyOw0KPiAgfQ0KPiAtLQ0KPiAyLjcu
NA0KDQo=
