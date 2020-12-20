Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7599C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 14:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B55E227BF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 14:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLTOES (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 09:04:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12322 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLTOER (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 09:04:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608473056; x=1640009056;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=OBqjCgFun5Jkxw10+eU5oC/v4G4Y8M/j1qs1R/GaRI4=;
  b=Z1bG/qI49GGKy09Fbas/0W40HDSkygnof57onShcJPNVDfp4W1XVQrTi
   GCOu2JhGOQ88fFXU8aQzIoY2+Qr0kZZFv/YoE3ywXCFiloqHfsTFkj0su
   eOsqQdDrfbXlJo6S0SZBpEqIoVI9IXEzxnX8YVCbFXCBPs+D5iak9X3A3
   CvL9/nN6htZDBlk3Z44xw/LkY/SFGawmgBH74PIbEDf1POLLgsWKT12yb
   s6rQjrA38Z8wqE/UWrKVSkr151wO3gc7iud+1DXAHGZ35WELMQhowqWjt
   bNNOVwSEkFWnhWee89XNYtbEtGVHDnTgr/eSFgZO3fxx86h4Q+/mtOkf8
   A==;
IronPort-SDR: 8MMG3NerJFkXPlM8OwgwDxkN9PH29M/2iytIxi8L76s7zeP+hq3kHdGGhxgxvT1TM1+8znvSPz
 ejiZATArq7fhda0QAUTW/5jUqLWcNKI1rN/qwDjiKW6wrRQxu0GfC1bxxfBN2ejgp5gvcrY//1
 kNKiwBTLFOM9Tj4P4ur+VZiDYzhR9jdHM4OuHFI8azfhlkdXmc5c6UuhZ6u+PO34kHl1MDQO8S
 id9ar54aFG2ZNtuYucIl4YdiKZ1GJBSd+F4qzLAYmrErbphvIM5ko0pMLEdGdKn5whXAZ9acyf
 Mps=
X-IronPort-AV: E=Sophos;i="5.78,435,1599494400"; 
   d="scan'208";a="155628826"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2020 22:03:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioomz2lRbVxmms9wJSa4tc2xtka1dGIP2ZIBbiS5ZwlQoI3lnFZdLW2sAksbD/K0h2riNOwzVehmYHk3YMWaRPMRvP5rJePuNsfv3ybh+YGJ9DPHBLYn4FDKoIoLzaYH519EZFxrEqdKzsyalpScjDUR8GVRbbgExEyUS3rBR7uo/A78Y4gADXHjhzkrxRRwMGs0Hx/VkVE+wRuQPQGr23/q7VjYMjMclQFxFB3L+bVqlro0HpWk02i9YjUToJGFZ7XdxqJKv0jPI7jFK7/BASreDxBNe5585V5MsRVHRUj1xKSS7rrnICjT3JFN+ZY886NBVsPZo1Cwt0+X5U91pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBqjCgFun5Jkxw10+eU5oC/v4G4Y8M/j1qs1R/GaRI4=;
 b=Lc1hqQtxnpO+1OcL/M+VGF9NE7CD75wAr8G+vc24rMKC/er8VwuEPvbabfsGLOfYHN/698x64PK9E5inRDU+CaBJ5t2tLO5Yd94SEnrwZK2pm9AhfNiVXPSQ62rknWE3vn14DKZrfvMOZVfRkUSMAOA6FLXgW/KkQi6tUX9v4aAgLDB535/yk0jOBsqf3m92nrL3jFQLgD/OUrK2Ctn80jwUqqtYuFFwGVwGkdPvYWsEBNBqrv892HOXwNWmPvDOyok/F76+57yoY1vRMd4hwmoWI7gkU36vcQLDrRUwBVzXf/OPWbQtmEfpfnSO6Kt2aQpE+QwaIRv6iCupAqUB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBqjCgFun5Jkxw10+eU5oC/v4G4Y8M/j1qs1R/GaRI4=;
 b=rfSetcNiyE9XYBJ5HuUFgyuwCjWg525Tl21OarOKPepZTaH8t/gV8riBXMGrVRtgokTvru4OGchpNYvSRWcxKwSNMMsnlSlIyEm9XzeIwwYAgIVcmoNr/+XEl7ivxsMe1z6Vhz2i0DyI/FtO5AXQxGm8aAdZr2slMVdr+1ewFEg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7003.namprd04.prod.outlook.com (2603:10b6:5:1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.31; Sun, 20 Dec 2020 14:03:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.031; Sun, 20 Dec 2020
 14:03:08 +0000
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
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v2 0/2] permit vendor specific values of unipro timeouts
Thread-Topic: [PATCH v2 0/2] permit vendor specific values of unipro timeouts
Thread-Index: AQHW1bQm7D1w3v7Fi0SdC313t0imPKoABg1A
Date:   Sun, 20 Dec 2020 14:03:08 +0000
Message-ID: <DM6PR04MB6575F7B2F1B6EB42C275049CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20201219030743epcas2p39ee0570eea153915ad8e525e8f508e66@epcas2p3.samsung.com>
 <cover.1608346381.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608346381.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44fb2a98-fe39-45b5-d8b4-08d8a4effb15
x-ms-traffictypediagnostic: DM6PR04MB7003:
x-microsoft-antispam-prvs: <DM6PR04MB7003354A91AEE64E5A25C014FCC10@DM6PR04MB7003.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WRKG9y8Hf3UA2y9IhBLcLt48zGydj33KNkt2y5J+35hXmZyO/ttuYJ0HmuiryJz5Fl9yuLr0oIo2AToRqolUoUcBGEJo9clR85Qkk2V8/MbYZhkRBgsPl4WwT/BVIlUihgXAZV2Fcj/edNCRBACJtiys03q5P8vkGZcKcvc9RkM214EgLWa5v5ja6u1xgcSicWfVaq1gen/HY/3OlMDN4isXhu4r1XyHrj6jsIJ015wY8fRhlGsUIxOB2OZ3qzQd9ztXpXKVyZ9r4+PaUj1U1cELaDmvtMRlGdfuT/AeZf/JgrgiZ6DGT70XZv9Kw4x/wjneA9MejJosis+lPa7jzYCJcZNahTqlQMDmlTX2P81jG1mrZK4BOTfPTRkLrW8PhGIuMS6imi4PjOdsYo13S/9gUIf8Lp9WHBadLbHnoID7eX5CyNB8ERblGnzYWU/W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39850400004)(136003)(396003)(7416002)(2906002)(33656002)(71200400001)(186003)(9686003)(316002)(8936002)(110136005)(26005)(478600001)(76116006)(52536014)(66446008)(83380400001)(6506007)(7696005)(66476007)(64756008)(66946007)(5660300002)(86362001)(4744005)(8676002)(55016002)(921005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VU9hMnB0aWZ1RUQwRldmN01tK2RIeHhCNkpwV25ubmxEenllNU1PUWFLLzdI?=
 =?utf-8?B?bHBmVFhmSFVRVDFBNXlYaXNmV1N6ZndTV1ZXQ0RHYUFiYmJQclFOUmw3bmJ0?=
 =?utf-8?B?bUZpZDRHcXlFdy8yS0MxdzhGWkwzN3VHQ3dFdUpTSGE1dERtM0E0ckF0MzdC?=
 =?utf-8?B?U2dSSGxVUE1OQ2oxQjVwaTRJdnZWdXhmdkNjbnlrQ0xhOENPNHlkZ0R3TVBn?=
 =?utf-8?B?QnJCS1F3Mkh5TU1NQ20ydUU0azQ1eDgwaDNvcm1mbFNlUjMvSDMyMUhLcDNa?=
 =?utf-8?B?WXp4Q2FhbU4zOVltR3RNK1E4WDcyUkZJM3dSK2pIZW1yRGhGVXJHdkFOOGlD?=
 =?utf-8?B?TGQzT09qbjJzWXQwTzJzTHVqN2tnSmdnbXV1QWgxQm9IZUFObFBjU0VEUERl?=
 =?utf-8?B?eGJRUEVCTm5tVkZKcEowbzJ4OCtKZHVGS1VJdnR6eGF6a2VKdlRpMVlNN1FO?=
 =?utf-8?B?N2dMUlV4aFJyaUovRWoyY1paN3BONUJLZ3RTc3hKM2tsYjdZNlAvQUFjY0xu?=
 =?utf-8?B?aitHSEhyS0lOMytueEM1RnpUSTZZVjVDVUYwSkpaUUVBVnpZSFFsQ3dzenFp?=
 =?utf-8?B?Z3Z2WEQ0eTQvUktDNUN4V0hTQmNuZDl6NG5tZlZzOG83Wkc0TWltYzJhNStJ?=
 =?utf-8?B?TS8yTm9EcGExTTBqdzNOWXNRNEN2NWhWOXczMGJVaEsyRWdISlg5clBtbUNV?=
 =?utf-8?B?a201cnJzTjNSdUVFYjIwUzllWGhhSjJTMVI2cHVsbmwwdHNtWVlzR1UrWlRr?=
 =?utf-8?B?OEFFMDFvR2w1eDc1eDc3MFBmWk1UR0Z1Mzd6OEN6cm1zMVlPakVrOXY2K2lR?=
 =?utf-8?B?QnVobjFvdmN3VDgxUzhYVnFmbjNQMWlmZU1UOWZuaUtUby9XMEI5Y1B3eTBZ?=
 =?utf-8?B?NGpSM2hKYXdBak8waXNQdUtVNWo3MmkzTVpLdmNmcWpmV1IzWnZvV2RqdjlJ?=
 =?utf-8?B?ZDJsc0NNNThwK1V2a2ErdWZqU2pnZnJ1aGFKL0ZMWkhQdzh1aDJqazlnQ3Rs?=
 =?utf-8?B?WmVleE9LbGhLTENFTHlUbEdkejZGcFIvSmtHQ3ZpaDAwNlhXcWk5MWdKcHBQ?=
 =?utf-8?B?UVp4Q2grc0NEZUpBeXBwUE9qNFpTd3FmVm9PT0c4Tjk0SENkdDAyN1g5bVc5?=
 =?utf-8?B?S1JuMVJYTTFDUWJNNTJPYUZveHAvMXNZTy8yRXpXdU95S1lhRXdHaVFVS2pv?=
 =?utf-8?B?V1JJaVFiWEtKT0ZsZVFhUndKOEZkQmdTQ3R5NlVSdnllbEdsVnAxSjQyVGlS?=
 =?utf-8?B?SkZucXVnYU9Da01iT1grcHFBbTlXR2pyU2U0aDAxY2tSWkxyK0JvdlRiN3pv?=
 =?utf-8?Q?tidZHm2zq7IO4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fb2a98-fe39-45b5-d8b4-08d8a4effb15
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2020 14:03:08.8412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6sCENvzeiiSSnNiCLf0I/dlKM/V5/4MtnuVOXAXeLLFseQnm1u8A4S8yzJMtr2ZgtXA1+ffT/BNDE6SC3uBWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

WW91ciBnZXJyaXQgY2hhbmdlLWlkcyBzdGlsbCBzaG93cywgb3RoZXIgdGhhbiB0aGF0IC0gbG9v
a3MgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gdjEgLT4gdjI6IGNoYW5nZSBz
b21lIGNvbW1lbnRzIGFuZCByZW5hbWUgdGhlIHF1aXJrDQo+IA0KPiBUaGVyZSBhcmUgc29tZSBh
dHRyaWJ1dGUgc2V0dGluZ3MgYmVmb3JlIHBvd2VyIG1vZGUgY2hhbmdlIGluIHVmc2hjZC5jDQo+
IHRoYXQgc2hvdWxkIGhhdmUgYmVlbiB2YXJpYW50IHBlciB2ZW5kb3IuDQo+IA0KPiBLaXdvb25n
IEtpbSAoMik6DQo+ICAgdWZzOiBhZGQgYSBxdWlyayBub3QgdG8gdXNlIGRlZmF1bHQgdW5pcHJv
IHRpbWVvdXQgdmFsdWVzDQo+ICAgdWZzOiB1ZnMtZXh5bm9zOiBhcHBseSB2ZW5kb3Igc3BlY2lm
aWNzIGZvciB0aHJlZSB0aW1lb3V0cw0KPiANCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5v
cy5jIHwgIDggKysrKysrKy0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgIHwgNDAg
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaCAgICAgfCAgNiArKysrKysNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMzQgaW5z
ZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjcuNA0KDQo=
