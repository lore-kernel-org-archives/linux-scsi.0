Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE66C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912E264D9E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhBAHOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 02:14:50 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24438 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhBAHOq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 02:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612163685; x=1643699685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Orj5BJTm8B131uIIZn7vjMj6TXoyxCVpWhwHMp0Dgs=;
  b=OjDt6c8LxWVgChPNq229q0Q39Gq54CJ1trbcVHRDk8/wukxH9N+iTXS5
   FeoF+hKDm4f3YTPbXvYkdz+FfhPJzxE1o+qIiMeKFFwgcG4zNr2srj5vK
   ll3CgVVmbdgh4zncNVh/B0TQ/s7/OuWBj1HFT8wEYtUPMwc1LN7BsONuo
   7t8Vu3EkpR37D8ZUwfZEYNxWVJs0cLqIWF9efoC05fokacfl8yQqrnse1
   3jEvuSL5ugkYbgTN5RDbgvwVtgeS/2rZ/PAFnj9Z2MlsnJw9WF5Ic8DaM
   3gL2zySH0nfgDztJg16w4qSRPQJWfg5iMX+EKlKJYRbrUtKM5CMV7iHnN
   Q==;
IronPort-SDR: 0Z9g27OysinFSlPA6Y6S4AFDFLUgJC1cwJK0xQHFCpQ/ctLNH3TuHXeKCfB6weRnSnRKxJYJ2t
 4PYsjoYg622JvpXl5Y/vTjNAK/lFAIIUS1FrrNEt/Sw7MR6RokHFru9uoTJIe9cunKVESzBY/t
 98ppZNHp86BI2kQWuEG4i8QXhhSf8Go/16PhSHRiAGW8oL6sMH2K/vfib6M+IxH3p/VmhtP7D9
 or4IaeA1E/k16czlP0/15QO2rEldBnq7p/XKtf5PKVcjkP6yOKPyZmGLwwivAmb1cQF6F1/tQs
 iOc=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="163236870"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 15:14:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lT0CbNZExTSUh9KKc9u/fO4UfNsFavcAGImOb6L+kQ6XXdTjHbzn0rh89SFd+xHuQusXx4N8ruCMSlsiRkKCSR6wsncZRNeGmanD7jx0n6oYs6WJ05UX5rOsvQWD4flTiJzrcYVJsPkpohHnNCqzrOopIgALyEhyPPkkQ6BZsfHVrz2AgXmZiuXyxsDZD5dN+jor3H/GwlnUombBY4iPf+giWWZd5ycU8g1OzaFcrN/D0z1S1wqlN+UhvZYo2l5DIX1vt3BIyDUxbqoxXOYOQSjbNo5MSfCibesRtiGGY+KVzeEgJjwxlanDuwNwecnfvYozvZxpkUyLhc9ihrJCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Orj5BJTm8B131uIIZn7vjMj6TXoyxCVpWhwHMp0Dgs=;
 b=CJp0bdpnkMX5Bk5/VM77bBDAb6RBISr0f86PjcLYZ0GMkLfNz+6snSEFvunJVRwP56u5A/8sYo+HlcEgmSw5D+QGTsns7xfv49jgOAx7koWQyqv84enDZK0dMdcDN8Qrsm9yFiBt8kn9UVMSQSeHwXRbdGGrIOghuN0sBFNoZcWIx04WdHa4kDjPZwdSxvhTMIQlCkgPsIrIgOLMUnwknPDAWwtaJfRlcy7AoUtu7WhQYN3hGgt/UEEMSL9fcOaiJJYSQGieTqCzpYc7ex3/8cxWzGLM7eTeU/TcXImLuUGu2FR9Sy+RT/bWBLOBV55fjTu2fn2IcVMRyswwlTmUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Orj5BJTm8B131uIIZn7vjMj6TXoyxCVpWhwHMp0Dgs=;
 b=iiRURbb9RR3Oyq86858AJoiugK/vjuwMO/5R/1lhFURtsuNmQpGwTghuvpgGAylov6oseG01iDv3pGDFN/B8/axfQg7++rt9LGBI7mZKkhsyXbwkLp/u+zmxhxSkJN1mUPM6sYUpqX7dr6lnM3op2jMf8B/l6HBbGurh9Vdf8Mw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3656.namprd04.prod.outlook.com (2603:10b6:4:7a::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Mon, 1 Feb 2021 07:14:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 07:14:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 4/8] scsi: ufshpb: Make eviction depends on region's reads
Thread-Topic: [PATCH 4/8] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Index: AQHW9L7yrHMqiEZHnE2uItUkffUluqpCs86AgAA2EaA=
Date:   Mon, 1 Feb 2021 07:14:02 +0000
Message-ID: <DM6PR04MB6575D4DFF9B319F0A55B2F7FFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-5-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151318epcas2p1cdad0118807907e55b8d8277daec6f1a@epcms2p4>
 <1891546521.01612153681714.JavaMail.epsvc@epcpadp4>
In-Reply-To: <1891546521.01612153681714.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b8b78b4-2ebc-4ecb-9b24-08d8c680f460
x-ms-traffictypediagnostic: DM5PR0401MB3656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0401MB3656B15C34E3B42DCEC429CAFCB69@DM5PR0401MB3656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wP1nfB/CmZF6MAFx/hGZif4ZF7qn1je21qWbxDs82mKUJTANop32AIcOPE3OlSNTdr43nGbLq9PZbZfuzJoOj2YiNFqOLSpJ9k3TWP3hTOq6Qy1APuyU7J/fw+eZFReugbW3JViZfpt/F9zGbVPZKgkve3hwEqV9ogriL3cnhLvHfr9h5dT2Ebp9wGTfxh2SSWTo5vYiWznPZY6mB0OOC9YV0rkpj40Z7I6Hxgo+RCcn8mNj0KvUcvuYILOR1MpY7qd60fdYb/VgVM4iuRa5gS4LICSJ8fHAQd3+8dYAaFpKziP58vs3Sk9EVrmRWDW8oVjvb4Bdmr5tN6IwTOs8nqanKmtJ2P4I/0XcSybVIkyJ3D0OEYQJ7Q7QnyLSWbMd8xea9ZafsMpVXBLWcgRcx5TCSqeZZxmKpX0CC+av6j9WXkN7nSLE1n3XQFaLe/p7iEMiEV7l9ma9qpJ1Y7qwW18Y0YIZURC85kH1AfdPJKo3TloIosE467UuW/3TdHMAQhsHFVHBtyzN1d+rwjEvWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(71200400001)(8676002)(8936002)(7696005)(4744005)(66446008)(478600001)(66556008)(66476007)(83380400001)(55016002)(64756008)(186003)(26005)(33656002)(66946007)(6506007)(86362001)(9686003)(4326008)(316002)(52536014)(110136005)(54906003)(76116006)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UmNVNXFVNXF3a1JmOS8xdUJvVHlocm9nelk5dDByQjRwTzBGVUV4VXBVOHg1?=
 =?utf-8?B?Wk5QUExVKzJaaHZOcE9sdE1ldWFTUDd0NUcvNnZwZldCWEppM3VhQ2RUZ2ow?=
 =?utf-8?B?K2FRTTNML1U2Q3RjdlFwSEwrSHY3WkFGVjVWaitFSjA0OGFkRk9CUTdSb3Uy?=
 =?utf-8?B?THVqNVpnZWpEc0l1UlI4aFRBZ3lmbVU0V3kzQWtjays5QW1BYkM4TkVSeDNi?=
 =?utf-8?B?cE9CS1ZQUmc0OGpVSVVRSzA0MUphc3g4Z1NhM3Q1TnMyYWtaTTJ5aC9xclVH?=
 =?utf-8?B?ZUU2UGxRN2Y2SU5zZXVkY2txcE0rYkJTVlVZRiswaVNnSmdRdXpVemg4WUx5?=
 =?utf-8?B?T2x3cCtEaWZRMEVIbjNoWm91OFdWdXNyLy94TkpDRTRwNnREbG9KcmFJSGNX?=
 =?utf-8?B?SHZraW9rUkh3ak1BL3VoKzRMalZpL3M0dCtZRnh4bDdPTnhPLy9sRiswa3Aw?=
 =?utf-8?B?OVJwb0w3ZTQ4RTEzVVQrZ2pCbGV3amxjdXpxTGZoU1poVVR3aG9wNS9LQmZN?=
 =?utf-8?B?dVoveURHRzFYQjFVdUVzc2xyYnFYUktpY3orQVdPRzJ2Mlp1TWxHWkNtT0dm?=
 =?utf-8?B?bkRNTlRtZnk0WkVYcDJLRGpIZlFQeHBHTHJoQi9NNzFmU29NWlVtTjJ6ZUNO?=
 =?utf-8?B?SlMvUUovMzZQVW5Cb1ZGSFRZVmRQT0RWK3BUQVBPb3EreThPcUxER0ZWanA1?=
 =?utf-8?B?L0xsMHpPK2FyMHpxMVBjd2hERkVOMkE1R29OMDFwZUhXWkRnY0d1SXh3YjNP?=
 =?utf-8?B?OXdYZk0rRkFZeXhMVHYwWlloWVFoSkdrYnFibVlUUHZCdHFGU1g0L1Y4ajUv?=
 =?utf-8?B?TFlLVnFPNlFPamdKOUpnTk82anZ6UUM2MHBtcCtjaXNSMGdaUDI1eVFUSjJv?=
 =?utf-8?B?czhya2FzbmNnL0p2a0RVU3hvbmJTNlRnVUNzdDRpclhuQy92Nk40RndoSnNX?=
 =?utf-8?B?UGpiSnBSNXVJeEkvd3ArNVAvdjQ2UWFQUTM1cWZ2MGNnOUhmeEVVMEZFNGx5?=
 =?utf-8?B?RkM2UU9uVlpwWmRyaDlyTGswU2RiYWwvdDFnQ1JMZmxxNEd6RzNYQ0Mrd2Rr?=
 =?utf-8?B?K2M0QUhtMHdneFFQMjAvcWd1K3o3Y01ZTmtnUzYvTlJpdjlISlhVOHo5cVUr?=
 =?utf-8?B?R2lmRHFMZmRWQkp2ZGFxdmNWckdqSUpmL1EvYjB2MmdIejlCZTZoSHM1bTdE?=
 =?utf-8?B?NUZ5VmFYbTh2Z2pBZHNLWmF4SHM3bHo2TThlUmxhbkJkMTErN0pGVGFKdUVP?=
 =?utf-8?B?anVIZTZXT3UvUzRTNmtUS0hUdE92QmJUZVlaS0pUQ3R2QnRzdEJPcVJldW9y?=
 =?utf-8?B?Y3dNTWVnV0ZGYXVSbVcxY1NjTEZzeUFDUERrRXk4eFV1bVRhSnh6aW5pNTFC?=
 =?utf-8?B?eDFYVStPV3ZobzZPZE5sZk9DMnFvdHAxRk1LeUFPZUZ5dkxtN2RIMm5tZ05Y?=
 =?utf-8?Q?WGldHVxH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b78b4-2ebc-4ecb-9b24-08d8c680f460
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 07:14:02.9975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: icYWQmmbE0Uo5oND5Wd/hGUltY+67WGfsR7JCtERH6tbxR6dFaEPG+rFhfLIA0kJ44/bovumV0YnC9RGrfRw5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3656
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IEhpIEF2cmksDQo+IA0KPiA+ICsgICAgICAgICAgICAgLyoNCj4gPiArICAgICAg
ICAgICAgICAqIGluIGhvc3QgY29udHJvbCBtb2RlLCB2ZXJpZnkgdGhhdCB0aGUgZXhpdGluZyBy
ZWdpb24NCj4gPiArICAgICAgICAgICAgICAqIGhhcyBsZXNzIHJlYWRzDQo+ID4gKyAgICAgICAg
ICAgICAgKi8NCj4gPiArICAgICAgICAgICAgIGlmICh1ZnNocGJfbW9kZSA9PSBIUEJfSE9TVF9D
T05UUk9MICYmDQo+ID4gKyAgICAgICAgICAgICAgICAgYXRvbWljNjRfcmVhZCgmcmduLT5yZWFk
cykgPiAoRVZJQ1RJT05fVEhSU0hMRCA+PiAxKSkNCj4gV2h5IHdlIHVzZSBzaGlmdGVkIHZhbHVl
IHRvIHZlcmlmeSBsZXNzIHJlYWQ/IEkgdGhpbmsgd2Ugc2hvdWxkIHVzZSBhbm90aGVyDQo+IHZh
bHVlIHRvIHZlcmlmeS4NClllcy4NCldpbGwgbWFrZSBldmVyeSBsb2dpYyBwYXJhbWV0ZXJzIGNv
bmZpZ3VyYWJsZS4NCg0K
