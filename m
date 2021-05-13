Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4185EC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109FF61355
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhEMIQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:16:48 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25865 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhEMIQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620893739; x=1652429739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DGPJ93kDIHLhjWucP3+G8UtO0PUw2gKYkg8J3hFNsDQ=;
  b=BTzKvVdjLvHp6WIIq/6jdtK5Rak1Dn6KwpMhLIoPQA2DF6lD6+5d+7/R
   2bJr8trqDwcG0VmDY6fStN0y0e8QYa1iBVvy6sF7NvzN6ZQoFWEIwf5RQ
   eFjMl0vWyuJ+VX82wX70frFw3rXsASbaSUTrkkmMw64LOyBMM1zz08CGW
   yXt1kLeeuK5DNZrlb6n6Xp/7GIdnys26yHjiLbzEebb1OhrjHU7HCsnyB
   pbD6B6xuYRzbgbt++JfM2r5BZI15jGEukgqgcEkSdy4akVfOT9Vd1EIrP
   MZ+sa+XkqQaJ17m8n2BacTAQLbrC+sN+E7Wx/W3RHIu7jE/cvu/8ToXuw
   g==;
IronPort-SDR: nlvDVqacBmoT1t0FMTmNtgsNl8JFSydZZH/fJScXk+NhoF28dhkFuMJddYApo5Y5Qyl83hNkcD
 gjEvZyM0JcSPMiQ3CgMy2+gydPwbx9SM9bBLfnuR4YZEVmvxzY5RRCEz2+iA5IHRhXsEPjyIXd
 2P1Xj7pcjLwWEdZP3SjoLX07A0undY+yLLabdyV8aviO5Vp5+NxMWZ7i+vNIcV3lS8yO/ZReyJ
 G+xJXymQFgaItZW+tuMkKC1t+TSTIx43XcqE7y2ytn5+QJAjgEt3bWOngw1OFYvVZrJ36iv1Bu
 aso=
X-IronPort-AV: E=Sophos;i="5.82,296,1613404800"; 
   d="scan'208";a="271989316"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 16:15:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzAUwpyMJiTTo42Qr7rhyl6mjoSyJzCuosYPc5UUuxTz6pdGdAULREDsxaSnt5C1lEtA1Du8b2BcwoFU4pwaduubTC80wrGyGkdHmDRm6K43NF6zDlJllqZzymdPVeTrjHWxlZl6OuH3CdhSpNTqLHjXBER9Dj58nJCo2+mFRSodZulUjhL/dcpQvr9kvq03ZxSDsDKhAs1pjJsFctcjcm2fJQCdLCUCl25ULJSNG4AM+Cyxjq5QSpv6nTijG0BU2YL+xfeTZjWcz5LY3a+rvYjAOfdW6R//iFkXgzeFrANj6dw33mW+N0VS60QdD51vY791INkRps+Hztm7UZDeCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGPJ93kDIHLhjWucP3+G8UtO0PUw2gKYkg8J3hFNsDQ=;
 b=UzVoNXiibZ1CXunWvjXGmnK6Z6ZTOL+9OyUoYFR7TDv3EMwmP61VkvTTSZND5lTNND/gkE6VuwPC2+uQhrjg18RHyBDztt22J/hhSUTkvQGFvE29b9i+LYkXpLFQkrak66kw57uRoMJc+yQqaBPWh+GaDD8ZfFmm4C9wtctMqW0yYCHdfL5O4QVPCaKkIo1oZPng/BUVxTGwJx7ALgoQggAOV3A6xmCidsvwsv66Bnr2E8e9WkmnRkFsoyKbNZDQmx41eq+anYpSvFJJEMnXmRA961S/JektdgktlmWhbi/1jUpZzs9xfxyypHc6thIZL+K11X78t7XS1IabV3mFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGPJ93kDIHLhjWucP3+G8UtO0PUw2gKYkg8J3hFNsDQ=;
 b=u63tL8eVl7YloqWsOlVVXtU0dq6iTEDLs3RxTHSyMyH/rbOasg5f6f08PpDTRIOcDtcIJugmMKtwL9aJ9nmWoVNgWVLQsGPsNDexH9XXS0Fwel9hACnsKI223epPb7CXCqEzDvT7gbsB59wlrfMUnkykC2xOic+oAI8HXuKGiPM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0973.namprd04.prod.outlook.com (2603:10b6:4:41::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 13 May 2021 08:15:27 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%7]) with mapi id 15.20.4108.031; Thu, 13 May 2021
 08:15:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Peter Wang <peter.wang@mediatek.com>
CC:     "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>
Subject: RE: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs violation
Thread-Topic: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs
 violation
Thread-Index: AQHXRxX/qO2IQ7o8EEGQnGwyYbUniKrg9p3AgAAW0ACAAAPdMA==
Date:   Thu, 13 May 2021 08:15:26 +0000
Message-ID: <DM6PR04MB65755B434F899F5F05E8F957FC519@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
         <DM6PR04MB6575083B2B58587AC14B6F9FFC519@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1620892726.21658.3.camel@mtkswgap22>
In-Reply-To: <1620892726.21658.3.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f0ecfcf-db61-4a7f-190a-08d915e743f0
x-ms-traffictypediagnostic: DM5PR04MB0973:
x-microsoft-antispam-prvs: <DM5PR04MB09730B4F69D86D7F5C4C86FCFC519@DM5PR04MB0973.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:324;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +MJ3xgDcsi2pOt923ZSG5dEpDvclu/AP+Erv4vtCee11WBtWmN3CH1BoOlT56opyOj56KNj/UjqX5kpMAoqig7Tz3z/PnpXCm7TnIZUp2DqXFNFH1xQ3EKHOTdmbchfKkvCo1aA34uKnQN5jK8Ax1rvAZQobtILo10Zdfmzd65nQlTnq6JkOEKbfinBjb2mfHApVIdjtMBMXfzO96WaQLaGJIlo6rLRtRHCoPESdGDktAjvm6OwOdlP7NDFZbrLs0TTr/YxFS/ZdYgLMj/FQEkOvUbeaPDZoXM5XfsjB3zfzLgjYy70M8PnJQ1pIG3JJvwep5BXGyszM/elrfgn6b3YTfdxKVRZdEiZXSboUg+K5kcOU1ea5s3PFZXQvFNbDwXfoJxOYgQJMbpNjEr7Usz+IwA6xjP6CL9LRD8p4G09PuEjcZeiRtfznC6p3gN5uK4nYfKYt/oQekLxaj8GzOaEAPhjLgNz+ODoV9CxN4zWJdHc43mDpU7DloAz8RWK6C1AjjJQMr9Xw+YUOiiT1F50HKvn2A9RSPfMdqPGndAcFYyvkBOETee6RRdUiJ1SWDBnIwSZ83qc4ibyNJRGLxdkvHuWOL6Sf89rIjW25DAk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(71200400001)(7696005)(86362001)(54906003)(6506007)(26005)(66946007)(66476007)(122000001)(4744005)(6916009)(9686003)(4326008)(55016002)(478600001)(33656002)(8936002)(8676002)(52536014)(5660300002)(66446008)(64756008)(2906002)(7416002)(66556008)(316002)(186003)(76116006)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZHhLWFB2a0NmR2Q3cVVQYjNTcG5yU1NUUkI2REdORzNsVk9aL3dqbXpzODZD?=
 =?utf-8?B?VTFxaEx4VnQ0Kzc5R1FYd0ppV1k2NE9pb0twWkxaOEd1MVB4NUxIaDRwUGFz?=
 =?utf-8?B?bEk2UFI4ekdtM0J2UkcwS3NMdXNrcEdTS2hNNVU0dFlsNlgxVmNvTC9qZHJL?=
 =?utf-8?B?SDE3TlJBdTFHc3A5QVgyVWRzdGhMdDZpNlAyWXZFOVFVTjF0YW5vNDVYOTR6?=
 =?utf-8?B?cGFJYk9oTG1rSFF6enNadG9MU0YyRWQ5dnY4RU5GVlF0YjlNdXZkSmt0SFRS?=
 =?utf-8?B?YnJ5bERHeUxsbEdqMmZNZDZBL3RsYmsrelY5ZmtQS0krOTRmeTg0c1daZFAr?=
 =?utf-8?B?YnNxeHhoN0xnZ3l4OGloaThlUmRuejE4RWlQUjBrNXZqbWdMOHdvWHRoTG1P?=
 =?utf-8?B?bENmZ1hiV0hqa3dDK1RLVzIrZDluNkFvU2pkRW5BZUJ5R1dOeFpLTzc5dFNt?=
 =?utf-8?B?OXlyZUVZdnBwdjBvaFRqWkJGUnlFM2xmYktxazJNU1Z1aUU3Z0N3a0NXZERx?=
 =?utf-8?B?RjZmMGtRdGlFVGFMaFpRVXU4YUlhWHNUK0NZbDlMYWhkYmlwdEYyYlBiNXRP?=
 =?utf-8?B?aHRLMFhHRU1SOTN4cXpLeGRHdCs5eVV5T04ybkpDV0hOY2ZGbTRWQkE3MVF1?=
 =?utf-8?B?Mk41eitQVXlqOGdsRkJWTFh3ZEQ5OThsQWppUkdkOE5ZeDdyeWl6eFNxelQx?=
 =?utf-8?B?aDhUNkMxRjVoY2F6ZEM4WkhVUy9kUW1rTFA3elFUbml3dW9SWXNRQndORnZB?=
 =?utf-8?B?VVR5cW9NNDIwYkNnM1hMeEIxbDYzdGNsMi9SY2U1c0JydlhQbmJ6MmJBcERV?=
 =?utf-8?B?S3V0bmZWa0VnTkZ2bGVPMFRRaVMyM3RMSGFmZDQ4QzlLTzVxRlhxSFVNVkR1?=
 =?utf-8?B?MW9ILzdxWG5qL3dpcUN5cTMvM3dWSXd0eEhJOWhiUkpEWVZJdG8zT0JIUUNW?=
 =?utf-8?B?bm1MSHp4bURJK3kzQXJRM1IwR2lCUm12cyt1RTZCck1LS1VyMTBGc203SnI2?=
 =?utf-8?B?czRhd3ZYV1FZSzNWTFVWdGhKdlNhNFJ2Z0ZWalZqRThmQjU1YUdnc1JsUEd4?=
 =?utf-8?B?OVFvcWF2MjV2eDY2UlprbzRDZ3BTV0FzdjZlY3QveWozZytWNHBqMDc5ZlVN?=
 =?utf-8?B?bXNJL2IxVmNFMjljd3R4bTRIczVvVHp4QThCMlFueFlHeDRlT2lIZytyTEFH?=
 =?utf-8?B?NEw5UncyUjcyN1JGcXUvUUNta0ozK3NMQTFMTm9yM1RwYnhDSmM4NWl0WUls?=
 =?utf-8?B?eUhCZWlValMzY0k0eXlNVk8rVEpWb0NlaG9mNUdpUkt6YUgrUlBWeDBaWTUr?=
 =?utf-8?B?b1dnQnUxOEZMSE95YlZiejJ5UWZPbXNGeDR4OUg3TkJObU55ZmJORW5POFFm?=
 =?utf-8?B?cVFWalZEelVIQ1JybEk2ZVBJcTcrT0ZpSmhTQkYwVXMrSGttREN0b0grZGhl?=
 =?utf-8?B?Z2s5dXFRYjc4R0ZxSDc2NmtUcC9MRUc2ZjFxbU1EUkE4NGhZVXUzU1FDOGtN?=
 =?utf-8?B?ZnZrTCtGOGFLTkZzOFEwaVBva3hNTUZkdWdVT3dNekJ0R3dQSXh3bENESTlF?=
 =?utf-8?B?U3U1WG5NSDB5SUVxb1FibEZ1MWdwb29BSDFnSFEzenJ1TGIvR2RJOUZHRWpy?=
 =?utf-8?B?MlFZSXBoUUoxZ2NJWlFXSG0vOXA5cENIZDhRRG5MMEMxWXJhNTBUYXJ6U2Vr?=
 =?utf-8?B?dWtDWkg1WER0K0kwVS9UUUt0L2pSTEhPcDBIeGNSKzJGajd1YWRzc3p6K0JQ?=
 =?utf-8?Q?D6jQMzYM1mj+caPRVg/NCvhcwEaNpQLbAYTtuwC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0ecfcf-db61-4a7f-190a-08d915e743f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 08:15:26.9609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5z7+EGAofwMAhXYbkcDqAScmdQ2vjXXlWoMDepTK8YDERlYd/maopDf6DhxWxcSuQ5+r2Vf57hp/cbJxj2pjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0973
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gKyAgICAgICBpZiAodWZzaGNkX2lzX2xpbmtfb2ZmKGhiYSkpDQo+ID4gPiArICAgICAg
ICAgICAgICAgdWZzX210a19kZXZpY2VfcmVzZXRfY3RybCgwLCByZXMpOw0KPiA+IEFjY29yZGlu
ZyB0byB5b3VyIGNvbW1pdCBsb2csIHlvdSBzaG91bGQgY2FsbCByZXNldCBqdXN0IGJlZm9yZQ0K
PiA+IHVmc19tdGtfdnJlZ19zZXRfbHBtLCBvciB0dXJuIHBoeSBvZmYsIHdoaWNoZXZlciB0dXJu
IG9mZiB2Y2MgLQ0KPiA+IEZldyBsaW5lcyBhYm92ZS4NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBB
dnJpDQo+IA0KPiB1ZnNfbXRrX3ZyZWdfc2V0X2xwbSBvbmx5IHNldCB2Y2NxMiBwb3dlciBtb2Rl
IHRvIGxwbSwgZG9zZSd0IHRydW4gb2ZmDQo+IHZjY3EyLkFuZCB0dXJuIHBoeSBvZmYgaXMgYWxz
byB0dXJuIG9mZiB2Y2MsIGRvc2UndCB0dXJuIG9mZiB2Y2NxMi4NCj4gUlNUX04ga2VlcCBoaWdo
IGlzIG5vIHByb2JsZW0gd2hlbiB3ZSB0cnVuIG9mZiB2Y2MgYW5kIHZjY3EyIGtlZXAgb24uDQo+
IEJ1dCBSU1RfTiB3aWxsIGdvdCBwcm9ibGVtIGlmIHdlIHRydW4gb2ZmIHZjY3EyLg0KPiAoUlNU
X04gc2lnbmFsIHNob3VsZCBiZSBiZXR3ZWVuIFZTUyhHcm91bmQpIGFuZCBWQ0NRL1ZDQ1EyKQ0K
PiBIZXJlIHNldCBSU1RfTiB0byBsb3cgaXMgYWZ0ZXIgc2h1dCBkb3duIHBtIHNldCBsaW5rIG9m
ZiwgYW5kIGJlZm9yZQ0KPiBzaHV0ZG93biBwbSB0dXJuIG9mZiB2Y2NxMi4NCk9LLiBUaGFua3Mg
Zm9yIGNsYXJpZnlpbmcgdGhpcy4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MNCj4g
UGV0ZXINCj4gDQo+ID4NCj4gPiA+ICsNCj4gPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gPiAg
ZmFpbDoNCj4gPiA+ICAgICAgICAgLyoNCj4gPiA+IC0tDQo+ID4gPiAxLjcuOS41DQo+ID4NCg0K
