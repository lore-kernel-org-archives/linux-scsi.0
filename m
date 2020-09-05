Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35501C433E2
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 08:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0FC208B3
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 08:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aEGaMBlh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Wh69cL0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgIEIDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 04:03:33 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:63643 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgIEID2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 04:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599293007; x=1630829007;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=4lGxGHr+87SgUopnDzTOLi23YuIPUz+wsVZyYQWqHQo=;
  b=aEGaMBlhMXf+PM3u//6a0elzGd2QKo+6AYsDt5CmelYCu9YbIrGDSDHx
   VXHzDJC/CQEWTFq2P2wPaXSNOV3q+WJyAtK6oA148iLjJp4DFScNecMFl
   khaN7nuenYp+WT3EeNYK+cr1sueHZsnLZvc6dha7nHjcMmwc2dIQzwKhK
   hzwjuoqroBklAdS3sqvHH4T7cu98TSOf+NrzVQrZqMstUClhHNq7mqehy
   ruAO85Fism9qbHS5Zz+JnmCBg5Hn/R4zVvqmejw0K1VtUHyxKeMlLTFkY
   HmP+kgs5euf02EKdxi8ixT6UDXRMxDpO0VC45XzQwjSxHCOTzqCJRXP7v
   A==;
IronPort-SDR: Zty6f2sjHHMaMT6bMZXG8zgb+RwahOC3YkIJre2sCh4L/biAbdzKhAH8bf6GbtrRZTXLoBB+Id
 Tnqu6FUvxXrqKQ2w1QJhJ/RR8h300iztXvY5nfWx1kzTFVqVGpQuptlALsM+Hyda3i0CYJ8YeZ
 0Ywa3RfPFxmmC9wmXgZj7rWRwy/iMsQLr0ur8hWmj3gY1IR26r7N7XeT+Eqhubu4hna1SS3JY+
 EnVnd0iZn+nGDo9IxbF/53d5iJJ9n/eGs8jB9PQ2NqCPMME9iKX3UIUHlTGPOroyL/a5e+bJS6
 U2E=
X-IronPort-AV: E=Sophos;i="5.76,393,1592841600"; 
   d="scan'208";a="146556628"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2020 16:03:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxmG/+lOniR+uf17DTjixhZgc4Etl9vJ9VciqU2iTRW5eGH/puvblYJC8nf1LiuSdlU7Kep+NqqeVNSssc1BnEOj96682QbLI5qnMCpuMkMXxvobO8KOXfNt1jyq3yarspm1KGRPr0e9uuTfi1mVSEH0qGJryI1gp/PtxWQi2nUvh7MWNi1wq1LaijIQDcjLDxM6u58RVDT5rB96t1GSVg0p35tyXcK8AfXfEUimRabOr/ivyDeU0zwfu1CvrLCNsMEKiLbVcYNah7JFtJbClcJCUUa/MMRQl7ibjkiTaKt6P3qmb4yoFwy+OT9fMSW59I0Zqr8LjAC3G9pAC3Oa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lGxGHr+87SgUopnDzTOLi23YuIPUz+wsVZyYQWqHQo=;
 b=FZVeuvHMEcOZZqb5IL03sUj6inPYrjxR2avAshdPbYvwYdLGv7/ERyLJLAdbTpy/zWQ7jTIg3B242KLkNGdiTy9xSwuzfIeGIl+0Hyw1O1qenYc3MRaNktZu6U1ZNfdunDjmjFcBz68HR3TtGU+D17BKl7d+c8qq2uM0HV8eWLMrH5uEgwUJ9pqNum1EoOHb7kWasvSP3mf+UDBjiRhw/2dOXreo7MltW8sNo2nIYgxRYE6Mn/DwXfsFsqYdQaYUFD3SQpRvwMpG8/WewaU2S+HKdo/IGxd632smQLZwMIlRsoErw5EQ4Al6byE0KTV23EPX6dvzaU08JoQk4O+e0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lGxGHr+87SgUopnDzTOLi23YuIPUz+wsVZyYQWqHQo=;
 b=Wh69cL0P+V46rMRAOxjXZz5ktNJpbLWrc3TxMUurbPyM0WMrDJ+EMaGKEdkpljjZIwsL/B0STKPFWSLLPAZWOak8V7UxXDdLEnqOKaPUoPRzmsmuc2fNgEL3bkfXPDpYiUl9hD5l1J+iZuJ38c2mv78qM1Ydn0zGS7lsRAmHb5g=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6930.namprd04.prod.outlook.com (2603:10b6:a03:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sat, 5 Sep
 2020 08:03:08 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0%9]) with mapi id 15.20.3348.017; Sat, 5 Sep 2020
 08:03:08 +0000
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
Subject: RE: [PATCH v7 2/2] ufs: exynos: introduce command history
Thread-Topic: [PATCH v7 2/2] ufs: exynos: introduce command history
Thread-Index: AQHWg0lNd/MMA62frEWrScLDr78alqlZpTqg
Date:   Sat, 5 Sep 2020 08:03:07 +0000
Message-ID: <BY5PR04MB6705BAC53F69C879EDF695CAFC2A0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <cover.1599284713.git.kwmad.kim@samsung.com>
        <CGME20200905055618epcas2p3216a11a97948f3605f1f2a0622927850@epcas2p3.samsung.com>
 <369148aae7680f558ab1f603a225e99416340b84.1599284713.git.kwmad.kim@samsung.com>
In-Reply-To: <369148aae7680f558ab1f603a225e99416340b84.1599284713.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21dc6d10-537e-4440-83ec-08d851722022
x-ms-traffictypediagnostic: BY5PR04MB6930:
x-microsoft-antispam-prvs: <BY5PR04MB6930164E0DB7E92667DE73E1FC2A0@BY5PR04MB6930.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zje8iJdWW6qPt6/mZk0qzZ0uwOXYx928dCiHNJnKIA2yNv9qwNWBJeSwwx+jD/FAZhKWqbJ7XI2+jS94Cc24ZzYN3HMnp9uFV4sGzkzZAEVnf03YAdyD/7xySBJH24sKWJpPF5Uj0Fy6acG8o+0YvQ5CxEoSxDyNlSf8uLqQN/k13Qd96FgXVsou6yBm2j2aWQtlp676eFp5ePvkq2suwaFDKjBapLRGgBocXxwek567gSuKYVjf0JDwUMHCdE4nWsjpOTHLeloEaqOZYcF+cBsNwq4C1bai/Ab5CSH99ZoCTgwkFBEPwNRVklXvEGqz2c2xk6uHHwJ2YWc7iXV/WfA46mqWtDXtzwB/NxDGuXbJhwaQQFNvq8swDGVGY2ze
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(110136005)(186003)(83380400001)(33656002)(52536014)(7696005)(316002)(478600001)(8936002)(71200400001)(76116006)(66446008)(9686003)(55016002)(86362001)(6506007)(26005)(66476007)(2906002)(8676002)(5660300002)(7416002)(66946007)(66556008)(64756008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MKYbBx/G6C73F85BnzpZRWLL1YlxpJl5a6ZIsL1uH9ZrCa1sstcrinL/Xpuw3q0rG1Fo8T5odAJocMeS5SnKdKVy3/vT23pP6PZvFbz1xEB/1ID3qOovpc+UxdGswE3G4fdh0AUF9+0g31AxpX7JTUTnknqA4j7pjr8+JoZfqHz7wASZgBgyqqtNOcR7wsngoH1ZPC4qXUhQjxA4lXR0BE32uJ3/PFDjvn83Jhxsdb7LvHYgD+0oP8P4xmOUwNxHP93Y+gJpSNxcohAPkt2hSwXZXnu5CKAmTcYT64OjrRHTrIYXCGsEIvVM4FOVVU5B5Pwrmh+XPQvSHWeC1BDepCHyVTQ5Jry94l3PiM3jZTzs12weSwWBi0wEtU8VpA94KWp/2MJ/cE/hr25E6Sf6omHdgJdB+cvPFjeczo7TY2cSAXEEggj9twooKB2OSm+DFnHAVesCMVVrzYdvOnK4sBY22T9tdAnLyolk3lZHdktpB8ZWLp4y+DxCfPU7VMPWHvpWJQq2qlHPNVB9taTJw3nWg2mi7oMLp7TJ0tpguz6qvdFcET+NLSltLz6V+azklKgsOpKEseBXsCmIUoGmHgsmLgwneP1Jn0TYW2JgotBHzjU93ANGfV6mlihTbkwHv2jjp6CDmJOW4ERKYssOkQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21dc6d10-537e-4440-83ec-08d851722022
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 08:03:07.8546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrdij+VWR6YqfaY7+5Pq9O3LT8XzxJ+lr+prBZnc1FBZrbbVdUlr9vUvzgrV/1wYZTrf7umfECgFSny2cXcsvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6930
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gV2hlbiB5b3UgdHVybiBvbiBDT05GSUdfU0NTSV9VRlNfRVhZTk9TX0NNRF9MT0csDQpJ
IGd1ZXNzIHlvdSBtZWFudCBDT05GSUdfIFNDU0lfVUZTX0VYWU5PU19EQkcNCg0KDQo+ICtzdHJ1
Y3QgdWZzX2NtZF9pbmZvIHsNCj4gKyAgICAgICB1MzIgdG90YWw7DQo+ICsgICAgICAgdTMyIGxh
c3Q7DQo+ICsgICAgICAgc3RydWN0IGNtZF9kYXRhIGRhdGFbTUFYX0NNRF9MT0dTXTsNCj4gKyAg
ICAgICBzdHJ1Y3QgY21kX2RhdGEgKnBkYXRhW01BWF9DTURfTE9HU107DQpXaGF0IGlzIHRoZSB1
c2Ugb2YgcGRhdGE/DQpMb29rcyBsaWtlIGl0IGlzIGp1c3QgYSBjb3B5IG9mIGRhdGEsIGlzIGl0
Pw0KDQo+ICsNCj4gKyNpZmRlZiBDT05GSUdfU0NTSV9VRlNfRVhZTk9TX0RCRw0KTm90IG5lZWRl
ZCBpbnNpZGUgZXh5bm9zLWRiZw0KDQo+ICtzdGF0aWMgdm9pZCB1ZnNfc19wcmludF9jbWRfbG9n
KHN0cnVjdCB1ZnNfc19kYmdfbWdyICptZ3IsIHN0cnVjdCBkZXZpY2UNCj4gKmRldikNCj4gK3sN
Cj4gKyAgICAgICBzdHJ1Y3QgdWZzX2NtZF9pbmZvICpjbWRfaW5mbyA9ICZtZ3ItPmNtZF9pbmZv
Ow0KPiArICAgICAgIHN0cnVjdCBjbWRfZGF0YSAqZGF0YTsNCj4gKyAgICAgICB1MzIgaSwgaWR4
Ow0KPiArICAgICAgIHUzMiBsYXN0Ow0KPiArICAgICAgIHUzMiBtYXggPSBNQVhfQ01EX0xPR1M7
DQo+ICsgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gKyAgICAgICB1MzIgdG90YWw7DQo+
ICsNCj4gKyAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmbWdyLT5jbWRfbG9jaywgZmxhZ3MpOw0K
PiArICAgICAgIHRvdGFsID0gY21kX2luZm8tPnRvdGFsOw0KPiArICAgICAgIGlmIChjbWRfaW5m
by0+dG90YWwgPCBtYXgpDQo+ICsgICAgICAgICAgICAgICBtYXggPSBjbWRfaW5mby0+dG90YWw7
DQo+ICsgICAgICAgbGFzdCA9IChjbWRfaW5mby0+bGFzdCArIE1BWF9DTURfTE9HUyAtIDEpICUg
TUFYX0NNRF9MT0dTOw0KPiArICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1nci0+Y21k
X2xvY2ssIGZsYWdzKTsNCj4gKw0KPiArICAgICAgIGRldl9lcnIoZGV2LCAiOi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxuIik7DQo+ICsgICAgICAg
ZGV2X2VycihkZXYsICI6XHRcdFNDU0kgQ01EKCV1KVxuIiwgdG90YWwgLSAxKTsNCj4gKyAgICAg
ICBkZXZfZXJyKGRldiwgIjotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS1cbiIpOw0KPiArICAgICAgIGRldl9lcnIoZGV2LCAiOk9QLCBUQUcsIExCQSwg
U0NULCBSRVRSSUVTLCBTVElNRSwgRVRJTUUsIFJFUVNcblxuIik7DQo+ICsNCj4gKyAgICAgICBp
ZHggPSAobGFzdCA9PSBtYXggLSAxKSA/IDAgOiBsYXN0ICsgMTsNCmNtZF9pbmZvLT5sYXN0IHBv
aW50cyB0byB0aGUgY3VycmVudCBpbmRleCB3aGljaCBpcyB0aGUgb2xkZXN0IGRhdGEgaW4geW91
ciBjaXJjdWxhciBidWZmZXIuDQpXaHkgbm90IGp1c3QgaWR4ID0gY21kX2luZm8tPmxhc3QgPw0K
QW5kIHRoZW4gYSBiZXR0ZXIgbmFtZSBmb3IgY21kX2luZm8tPmxhc3Qgd291bGQgYmUgY21kX2lu
Zm8tPnBvcyBvciBjbWRfaW5mby0+Y3VycmVudCwNCk9yIGRpZCBJIGdldCBpdCB3cm9uZz8NCiAN
Ckkgd291bGQgYWxzbyBub3Qgd29ycmllZCBhYm91dCBtYXggYW5kIHRvdGFsIC0gDQpzbyB0aGUg
Zmlyc3Qgcm91bmQgYWZ0ZXIgcGxhdGZvcm0gYm9vdCB0aW1lIGl0IG1pZ2h0IHByaW50IHplcm9z
Lg0KUmVhbGx5IGRvbid0IHdvcnRoIHRoZSB1bm5lY2Vzc2FyeSBjb21waWxhdGlvbi4NCg0KPiAr
ICAgICAgIGRhdGEgPSAmY21kX2luZm8tPmRhdGFbaWR4XTsNCj4gKyAgICAgICBmb3IgKGkgPSAw
IDsgaSA8IG1heCA7IGkrKywgZGF0YSA9ICZjbWRfaW5mby0+ZGF0YVtpZHhdKSB7DQo+ICsgICAg
ICAgICAgICAgICBkZXZfZXJyKGRldiwgIjogMHglMDJ4LCAlMDJkLCAweCUwOGxseCwgMHglMDR4
LCAlZCwgJWxsdSwgJWxsdSwNCj4gMHglbGx4IiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ZGF0YS0+b3AsIGRhdGEtPnRhZywgZGF0YS0+bGJhLCBkYXRhLT5zY3QsIGRhdGEtPnJldHJpZXMs
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRhdGEtPnN0YXJ0X3RpbWUsIGRhdGEtPmVuZF90
aW1lLCBkYXRhLT5vdXRzdGFuZGluZ19yZXFzKTsNCj4gKyAgICAgICAgICAgICAgIGlkeCA9IChp
ZHggPT0gbWF4IC0gMSkgPyAwIDogaWR4ICsgMTsNCj4gKyAgICAgICB9DQo+ICt9DQoNCg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLWlmLmggYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1leHlub3MtaWYuaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAw
MDAwMDAwLi5jNzQ2ZjU5DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnMtZXh5bm9zLWlmLmgNCj4gQEAgLTAsMCArMSwxNyBAQA0KPiArLyogU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLw0KPiArLyoNCj4gKyAqIFVGUyBFeHlub3MgZGVi
dWdnaW5nIGZ1bmN0aW9ucw0KU28gdGhpcyBoZWFkZXIgY29udGFpbnMgYSBzaW5nbGUgc3RydWN0
IHdpdGggYW4gb3BhcXVlIHBvaW50ZXIuDQpJZiBpdCBpcyBqdXN0IGZvciBkZWJ1Z2dpbmcsIHdo
eSAgbm90IHVmcy1leHlub3MtZGJnLmg/DQoNCg0KVGhhbmtzLA0KQXZyaQ0K
