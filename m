Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04860C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D374F60E54
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 10:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJNKvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 06:51:36 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49640 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhJNKve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 06:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634208571; x=1665744571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RfE/3w2Q2lWsxdZq/gaJUG/6ZhDrHwrOoptUTSS2auI=;
  b=Oy5pF+CfC7q0bRtfO7q9UlmMr2nb8+HOaMbAfQBEiP6N/+jGC6lls7pZ
   NLiHMKeWjYavFbWJppKkCYPIbv4yFCQ3/q6MXY4vOFD90QW8IgNgclH7I
   Byo0ADTM1DIKM1tOAAkRuM5z13GflhXJJR/o+43UHDOrZAeXFJoYQ8O9B
   +xjiXcNk7OsiM0yCzw4vSTtZU0c3nKmCYDpUCjpQmdd9uNi5CMZx6q1G7
   ZOE9jpWZzDiz9SUynoAAH96s90+0gK+x8tJdZPuA928PmQOa0zQZOEFdO
   6g6jVzfyAu/t9TvYgZl4MxCXJVLUUUvFsIwsYLmzSQxRWAX7TOx0T//yG
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624291200"; 
   d="scan'208";a="183777554"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 18:49:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwyslLz1OPKn0NZgbo2tKNbaNjVDfn8xgMaSscF605TdcyuxXzZdmRVXUo+S4w1q6S86iezG7PAc1QLWND3DakCNR8J110ygoDGZeNF/ya62ne0MjeEYyFuAwldwVpus9xZkPxfZOVSjYxUKGyTTg791EX5rwD3RyboyqhaKjEcFJNgR8Mjj780QNOrCq1EXthrU17oP9cUCjSB3B7uy3rx5x0vPFZzRhq6zQR4i+AktiTrS9AyxO4/WuY77GKuiwLYCF2BBydUSEqDHnbeccxtZF7xyNh0XYyvy0wI7RMQx8hAy7AlMVf4dK03MO36GPiPmxKmPp9Oo6AW91dyYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfE/3w2Q2lWsxdZq/gaJUG/6ZhDrHwrOoptUTSS2auI=;
 b=Miscu9mAm4Ddb1YzhgoQsB/5aiyHwEdMO4bs2g+Weq02LjO/k+dmJK6l81aCe2NpG1e2GxxY5yf0tFSAUh4lOKBeZ0uwwYcRmpCmMejeQ/W0tbQJ9nuxWu0GZK9H9pU7CQSe5dg7QXekOdNkax5PviR8m1AaXo7OJMXlTa/7eVdzaYQLJdpibq54i+g9WnncFOLjGtiJkpFeItI8GlDEekHSwYZl0ZshhGyA1ghtStjm+MHsftEIKk/AFSmxyIS+LRJ1+HjVJ3FQuwDKf+Zw0wuTpQk3YvXOTSjods5tx4GRaq1BThHjEu+c0raz+aWy+zgSbxN0EEgmAoZGFf0WsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfE/3w2Q2lWsxdZq/gaJUG/6ZhDrHwrOoptUTSS2auI=;
 b=TRLTmw8d1CpX2RO9OdJC2sPhucUqRj1iCbB+5wJ90jHgF2Wp1iIvZ9DxaoTQ0FSF7FIbw+hQNv55Fu286OtL8JZlhFwx8EIpywYKiGblPk/RN9JThWvIfcccgHIZXb3T5Qn0BCszCYqyEf9xL2ydO5nzUOa6NkVw0S+PY4JeSH4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Thu, 14 Oct 2021 10:49:26 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 10:49:26 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        jongmin jeong <jjmin.jeong@samsung.com>
Subject: RE: [PATCH v4 02/16] scsi: ufs: add quirk to enable host controller
 without ph configuration
Thread-Topic: [PATCH v4 02/16] scsi: ufs: add quirk to enable host controller
 without ph configuration
Thread-Index: AQHXu1MR4E8rP9LBXkGk/mZ1ZjuN46vSW4eQ
Date:   Thu, 14 Oct 2021 10:49:26 +0000
Message-ID: <DM6PR04MB657553407FF6E126E439E15DFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p4b6c0673d5b47cd04d9aefcd3d07c75cc@epcas2p4.samsung.com>
 <20211007080934.108804-3-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-3-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a38a165-7575-4dca-5b93-08d98f004aab
x-ms-traffictypediagnostic: DM6PR04MB6575:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB6575774EF2FAF7D901866AFDFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C6poShIZASZbP+myhJKkhacVyNHeVKINUS1mtR+swkFECRtjcs7zhEPSMHDV5o4SMwdm5LVomYfdtS9ec5LA+BHc9h0VLqLVgMYuBMgBPxFDrtaIQFRqbEXgmzdIsa812iiCDYgK863Xapj0nmREF1A2wJMoxSLf8EoY8Qel+RhQf2KFfRo0jjzb8M3LTiNHFRL66RnAWtp7aJKWhNwSVekMJ7JMTmPSnKGinvcJEP7UgOCF8MQZSSzQQxDLTpVp1bFjf4LJPpzxg8jxlcoc/5HCvI5QVW4w42uIKDkcVdR/uuCZdlV8i3QUaMwTLdB06KQmCpIuXKJjB2S0G196TFk2eusMe2mw5WxAW8/hyrds1BHivB8Xf9fBRZqTpPfv5qgh9CFn6wAGWDEq9jSNx9wHQ84Bemo4L5jJnaUD2LX6hCI9Kni9fiedvo+qfYhhfBFxM4mzElCysWCQdlqjtmMDviU3AhRlKSyujPfYjgi6Y8IsyS69ScgbhdjqQl1tsu5Oi9Qa+CBMSe44n0H+9FnAZS0kDl3OgpSBz+clepDqR1oxNcuy6hcGe2QMSf7yzUGfKaQDXx42bUL7xUmDe9HWQMwlJ27GVaRwxxtHZdii299U4YIhzYq3DG1ACpDV5406p1dCOKVzskCyS7MNtRUVrBOrkbKLrKFN5Gf3qGZzL6IXGblqdkwtaXt6H9E7YOF42/woK6S9AmdPB6B0Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(8936002)(316002)(7416002)(8676002)(55016002)(9686003)(7696005)(2906002)(86362001)(5660300002)(71200400001)(26005)(33656002)(6506007)(52536014)(508600001)(82960400001)(66946007)(38070700005)(38100700002)(54906003)(122000001)(66476007)(66446008)(64756008)(76116006)(4326008)(66556008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnlOTHJ6cUw4d0pIL1JUbC9vbDJOek9yODZSRnY2aDF6anY2c1ZyUWh3UUM4?=
 =?utf-8?B?cDZTVmlpZ2E3RUl5RVV3MlZmYUhxaGxKeS8wbmxSWGllQ0s4NWszNEVyVkJM?=
 =?utf-8?B?V2pXMFpwWTRTVDRpNm1vN2pKQnhjYkpKcUxvYy9uWFArUEYrNTl4VHc3NG1C?=
 =?utf-8?B?Tm1BYVJrKytVRFkwNkdqTTAwYjc4L2FJYWJubERqWGVGK0l6eDhPcmNFMkpB?=
 =?utf-8?B?TkZNbFRVLzFGemxoc2hSbWJVc0puY0NSYkVtZmkzR3N1M1R0SnNOV0lQTlBO?=
 =?utf-8?B?NlhDb3d4L0EyN3RITFA3TEk3QU9oaURReEFBWk1LMjRyanBFRG93V0dpK09w?=
 =?utf-8?B?V1ltcWdlbU52UTUrYmVka0pjanJWUHpycWRjVFNhUmwvUHZMZlZQSFZabHFH?=
 =?utf-8?B?ejRjbytkM3lxcDMwVlBlc01GeTRCVFk2UjVrZ2M5d2tlR3VLR1Znb3pBYkl1?=
 =?utf-8?B?UlVONzYweTJkQXcreWhESm5MVnB3emo2M3lVNlhQa29pbTBodEx1ZlBhQVd2?=
 =?utf-8?B?YjkzQXc0QWxLVEVsTUhnUzA3ZE9Nb1BLRFYzL2JxU0s4ZlZZSWpDY0Jlc1J6?=
 =?utf-8?B?UVVJa0VXc2FEUFhoMEk2OGdVT21HTXIxNEhNTXNuOVNjZHlFV1RZNHBlZXJo?=
 =?utf-8?B?RzJlb01lZEtIdDZBaDJOTndhdDN6cmNPeTZtaXZkTnhyTlBxSHhDUFJmemdv?=
 =?utf-8?B?bk1CUU15RWlJY1RaaEZiUzJvQXFlTGdjdnlySlRObHYrcmN3Zy9nRlg1eDFX?=
 =?utf-8?B?aGUvUldOMUxWZ2Qwb3ZFQUdod3k5cFo4Q1luNjJGTEcva1crOCs1U1pUZVBl?=
 =?utf-8?B?bG5QbjdMdjlzenp5TktJUUZha3lNK0VVRmxlTHl3Y3REZ0haWFU3aFJHQVJC?=
 =?utf-8?B?Um5jSkR5NXdlZTY0c2VJVDYrYVpKYlVIckM4akJiSEtTMnh5OTZjQUxlNkw3?=
 =?utf-8?B?NkpGNlFyd1JVVDhkaTNMM3FxOENzdFdOSXB1OFZSbFBSVjJtZVJWczVVUWdD?=
 =?utf-8?B?ZTBoN0t0WEhQdWU2dVhMNUNYbHZnRU41ZFNIbVYxd3JyenJTa2p4VFNjaUVp?=
 =?utf-8?B?MmRTY3VoNERCN3lleGlrajRpbGxEZ01ERld2YU5nWVl4OHhUaXNHSURrR2xj?=
 =?utf-8?B?Zi9Ndy9iUDFkRE0waHU1S0J0RDljNjZCQlhZVkVCOGhQckRHa2FxcG1GU0VY?=
 =?utf-8?B?MVBaSUJPZVNtYjdwMVh2R0RSMUtKTTd2UGxjbXUrRjlsczkwdkt2cFhJQVJS?=
 =?utf-8?B?TFYxd3lzckRXVG9ZMHByOTFzWDRjWXpDcjhoeUxTVlNrNnplU1JDUkVNOEY1?=
 =?utf-8?B?cXFVT3NvOGh0bWxpSnBwTUY4N1JCcVRpOTVpWEpDdFVLajg2UHB2Mk5oQXR0?=
 =?utf-8?B?MVdzTkJ3YUNJaW5tN29OOTUxY2dSSUE5WUhYVWRnQ2NwQUx4M0NpQ2ZlaFlS?=
 =?utf-8?B?T2ZQamxIVDBzejZ3UDZNS0pTMUpqbkZrRXJqa3FSM0hEVEE2TUQybGhqd2pE?=
 =?utf-8?B?TUhhR2paNFZvekdGY2NsTURyd3JJSC8rQ1RCbXhkSVlEUGRsUDJjNXpZU0F2?=
 =?utf-8?B?QkpXT1JtKzJsY05NaTBBNjRYSGV2SWZzcE9yWlQ5VDV4aDVRMUlMRmY3Rjg3?=
 =?utf-8?B?aDJXSHJEeDBhTGd4QWR1OG82dWY1NWdWRnFxVDZ3SGlmVnpRbUtaOXF1eVF6?=
 =?utf-8?B?S0tqRnFnbCtjbFB5RFh4Y2ZIN0x1N3VuWWJZNHpLNTBNTjEvVjl2NG8rRWZt?=
 =?utf-8?Q?h/0YWuj/97xAVUc4+jJWyQp5TU3xSH1pZNWfo0m?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a38a165-7575-4dca-5b93-08d98f004aab
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 10:49:26.3598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7lyBk1SawwCt1sMarMo4JDBHa+5s7JDinDTQ1dHDe/02j8iPPKiWbcxq8vRE1NhzoG6kRG22Ha4o17SAr6WWuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6575
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gRnJvbTogam9uZ21pbiBqZW9uZyA8amptaW4uamVvbmdAc2Ftc3VuZy5jb20+DQo+IA0K
PiBzYW1zdW5nIEV4eW5vc0F1dG8gU29DIGhhcyB0d28gdHlwZXMgb2YgaG9zdCBjb250cm9sbGVy
IGludGVyZmFjZSB0byBzdXBwb3J0DQo+IHRoZSB2aXJ0dWFsaXphdGlvbiBvZiBVRlMgRGV2aWNl
Lg0KPiBPbmUgaXMgdGhlIHBoeXNpY2FsIGhvc3QoUEgpIHRoYXQgdGhlIHNhbWUgYXMgY29udmVu
dGFpb25hbCBVRlNIQ0ksIGFuZCB0aGUNCj4gb3RoZXIgaXMgdGhlIHZpcnR1YWwgaG9zdChWSCkg
dGhhdCBzdXBwb3J0IGRhdGEgdHJhbnNmZXIgZnVuY3Rpb24gb25seS4NCj4gDQo+IEluIHRoaXMg
c3RydWN0dXJlLCB0aGUgdmlydHVhbCBob3N0IGRvZXMgbm90IHN1cHBvcnQgbGlrZSBkZXZpY2Ug
bWFuYWdlbWVudC4NCj4gVGhpcyBwYXRjaCBza2lwcyB0aGUgcGh5c2ljYWwgaG9zdCBpbnRlcmZh
Y2UgY29uZmlndXJhdGlvbiBwYXJ0IHRoYXQgY2Fubm90IGJlDQo+IHBlcmZvcm1lZCBpbiB0aGUg
dmlydHVhbCBob3N0Lg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBBbGltIEFraHRhciA8YWxpbS5ha2h0
YXJAc2Ftc3VuZy5jb20+DQo+IENjOiBKYW1lcyBFLkouIEJvdHRvbWxleSA8amVqYkBsaW51eC5p
Ym0uY29tPg0KPiBDYzogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbT4NCj4gQ2M6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBSZXZp
ZXdlZC1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBqb25nbWluIGplb25nIDxqam1pbi5qZW9uZ0BzYW1zdW5nLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogQ2hhbmhvIFBhcmsgPGNoYW5obzYxLnBhcmtAc2Ftc3VuZy5jb20+DQpZb3UgZm9y
Z290IHRvIHNldCB0aGlzIHF1aXJrIC8gb3B0IGZvciB1ZnMtc2Ftc3VuZy4NCg0KVGhhbmtzLA0K
QXZyaQ0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMyArKysNCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA2ICsrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBpbmRleA0KPiA3Y2Y4ZTY4OGFlYzgu
LmFlYzE4Y2UyMDNiOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
PiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC04MDUzLDYgKzgwNTMsOSBA
QCBzdGF0aWMgaW50IHVmc2hjZF9wcm9iZV9oYmEoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gYm9v
bCBpbml0X2Rldl9wYXJhbXMpDQo+ICAgICAgICAgaWYgKHJldCkNCj4gICAgICAgICAgICAgICAg
IGdvdG8gb3V0Ow0KPiANCj4gKyAgICAgICBpZiAoaGJhLT5xdWlya3MgJiBVRlNIQ0RfUVVJUktf
U0tJUF9QSF9DT05GSUdVUkFUSU9OKQ0KPiArICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ICsN
Cj4gICAgICAgICAvKiBEZWJ1ZyBjb3VudGVycyBpbml0aWFsaXphdGlvbiAqLw0KPiAgICAgICAg
IHVmc2hjZF9jbGVhcl9kYmdfdWZzX3N0YXRzKGhiYSk7DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggaW5kZXgN
Cj4gNWQ0ODVkNjU1OTFmLi5hY2VhZWRjYzE1NTggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAt
NTk0LDYgKzU5NCwxMiBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KPiAgICAgICAgICAqIHN1cHBv
cnQgVUlDIGNvbW1hbmQNCj4gICAgICAgICAgKi8NCj4gICAgICAgICBVRlNIQ0RfUVVJUktfQlJP
S0VOX1VJQ19DTUQgICAgICAgICAgICAgICAgICAgICA9IDEgPDwgMTUsDQo+ICsNCj4gKyAgICAg
ICAvKg0KPiArICAgICAgICAqIFRoaXMgcXVpcmsgbmVlZHMgdG8gYmUgZW5hYmxlZCBpZiB0aGUg
aG9zdCBjb250cm9sbGVyIGNhbm5vdA0KPiArICAgICAgICAqIHN1cHBvcnQgcGh5c2ljYWwgaG9z
dCBjb25maWd1cmF0aW9uLg0KPiArICAgICAgICAqLw0KPiArICAgICAgIFVGU0hDRF9RVUlSS19T
S0lQX1BIX0NPTkZJR1VSQVRJT04gICAgICAgICAgICAgID0gMSA8PCAxNiwNCj4gIH07DQo+IA0K
PiAgZW51bSB1ZnNoY2RfY2FwcyB7DQo+IC0tDQo+IDIuMzMuMA0KDQo=
