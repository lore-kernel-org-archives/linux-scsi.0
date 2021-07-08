Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA78AC07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 20:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE11616EA
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 20:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhGHUXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 16:23:02 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:19466 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 16:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625775619; x=1657311619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WE5Ztcpv+XK3Vv05n3vDaWIh4tPTDIEdTwBkttKUiIw=;
  b=RQSc9d8IQos3g6v9jRl0jc0hlXxGjZFv/sEaYERnZtTiViYWlP1Q2TqP
   fdfbyG+AXfScOJ/+6oULgCJTeWwHCgbnCVwclYrOXd7Vbej5/LuEcrthO
   bTUPjEmW/0wRUNa4GF8Wf6x6I4LsGfBfmPTrSZU+5ImjeiKq6ss5Tkr9X
   /nuF/cdgfM884/ov0igq8ioLVkAxu+VJ97JchORcCGASAIGFGOdbbKH/e
   BZ7h/q/9KFNbUFdf7o3bFmXWg3cEwGoFbUTyhjuFFxdCmwRxIOR4uidy7
   2byOV5xwsPkZ3knoUMgbqd4xUOgWjbAKgxwEQuvv9oZ+yKsajWsRkzB5j
   A==;
IronPort-SDR: GuO5MlSVs7VTnkH+wHwMls1K0svtTYSYL7yn9hkKQt9WGBTfT0AZ//ko87pRx9eVHA4qCJCLC2
 cmJt2dvIA1zLR0orRC/O5+8Ai6oyxZRG9NTKtgP7K9qJzt0WqXycoe6S9/GnqVv0vb8AA3KV5+
 QrtOtCGYDdTGHuFXUo6mCYZNEMLs69KqC58nmp5liFhAbwqjJZf5iYg9q9KGfbfBJkjxm2Hdlv
 MfHrYscedUwQpqD3P0Z5LROM8z0otxtrNM64Ca8H0aY0xvKMtG8LbgnuJnp9a7O7n7mNtt/DuA
 nA8=
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="121424283"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2021 13:20:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 13:20:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 8 Jul 2021 13:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaAOIQRnl8hvnff9tIFZ6QV5CnUhoriML/fPjzNXPhLrJNzfDQVD0TJBkvR3fPi46UIeeWwxh+vpXWT6LGwthse9B/K+LsxbJF/9H9h/kR/ESlRFWbwNzhPF01BbJvXzpJYvUaYNxSaUQ42WuUrxUZCMy7FhTpoKuq2wM2VDqmjevwcgoBPwDR1tTXyZSDwViSFTjZgsNm+sLFkFgfOtQDr+y72gKVPbIf8MEJaDr8cc8j8NH01PAgcR6ftPpP5T1Le6fNqWdeRVgbcaVwPzOn1eyTF1P9L5TTaKg/H5qNBMd0LqNIdQgUv3tindeTsWMQDRI6RmXVgzKm+6XViUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE5Ztcpv+XK3Vv05n3vDaWIh4tPTDIEdTwBkttKUiIw=;
 b=UrMnXfENHvLmEX4ijURCTGr5nocue3enReQZ9ZYYIJzOnQrW6HrRR02XbRP1WnaUhBasMt1jjaV4So5WigO5ZlGQsCpnioCgWGKfreXVVsOmu4JB/+BueNflGXZMvxfRbRtQImK6A/0iDiTixixvTztBnrZaLg/ZMZQblL61yqBTnnzwcbbLJJ6bjDcChkMNjWQZQasyhdgCTL4ej47DK5WDgz5mApew17vIwZgPYkMxIJNaBKrxjuuwePIx7Zd+S9geQB2yRLVD4k4XRRBRaSVMxvD+jCeM90drZfyqWD+4yuHSnC812QQcVF9l4YLRgd9QO2XCywCOk3y/5ZjJdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE5Ztcpv+XK3Vv05n3vDaWIh4tPTDIEdTwBkttKUiIw=;
 b=KA8wIxqVaq4smU+IV8M05PigJ94odHiELR9zT6+PObz0e3Ip6zXW/QfwWylpI3D3yD+ryy8bt87zgxdkn4/LCunCokir9uqifW/8pvXYXS7H+fwr+xoEZXr2oABCiY2p8rzDmbbVDWnetX3Q40TwUe0Ka2nItyw0nvgN2AXPuEQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2976.namprd11.prod.outlook.com (2603:10b6:805:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Thu, 8 Jul
 2021 20:20:11 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 20:20:11 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <Murthy.Bhat@microchip.com>
CC:     <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <Mike.McGowen@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 4/9] smartpqi: add SCSI cmd info for
 resets
Thread-Topic: [smartpqi updates PATCH 4/9] smartpqi: add SCSI cmd info for
 resets
Thread-Index: AQHXcwLoPitfK6zXLUqh+Mq8SmJInas5hzMQ
Date:   Thu, 8 Jul 2021 20:20:11 +0000
Message-ID: <SN6PR11MB28486EDB516440AFB4044932E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-5-don.brace@microchip.com>
 <02a04074-255a-bf7f-0925-7d4be9c7ab8e@molgen.mpg.de>
In-Reply-To: <02a04074-255a-bf7f-0925-7d4be9c7ab8e@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec10c185-e060-4b7c-2e77-08d9424dc9ec
x-ms-traffictypediagnostic: SN6PR11MB2976:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB29769C1F0A6969682BEA72B0E1199@SN6PR11MB2976.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o4sKYpEtGNI4nS0iz4gLkhhhrwSXJA4DDviCMXeqkDB8vEQimeivgfv1M465FU0TDJHvuudwGJdMo4B+5cL+3HwJ32TVPVvxDQyVtgf4ClRUnaGX5rf8nUy3GEs1xNvH5Dq+DbDFe+PJ+sf23jnKDUfGQT/ZpsswXM98T2qeqGaCcI5up1BsI616KSV58FEjGkpWacu+QzZVJ3IYRvjjfhcdkSGbgqs3npYkO2+zwbk+E3ttwwTlph3xfsk5xQsXPxgNCSRBfAQi6500SlF9Z1Shga1DMZTSk+22/F1nKe66+FhsA/iBEBL1NcwdLm2bAYQCwnRaVnTLA0x/Hg2WKpjqzKSwiymw3UdFCzI6+HIsVygdjErQPT0UQ01KwKdwYt0lqoWhCrYfLe739yGFBJtV+7VdKvUMKNJczWsIsNhaR6yZr+UamFveW/yIJzehEjJajBhbIZFqpyWcpTanzzawJQyPUjXDg3DXxU/YhjYcarXcosASx0f22n09xKA1pBMXyhyuV7qZ4lfbO75gh0mZjhe+I3sCrYUxA0SaVQlDccx+o5Oj3MBqcG3llsGwqxPWMztgZwU/H7QU9js/Y6J3jVKQs23v5s9lko4QiERUte4taiEb9ATSw+ElS5FmiN1WrudDH5zpGtIGY8cvHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(39860400002)(376002)(110136005)(122000001)(15650500001)(38100700002)(66556008)(66476007)(54906003)(64756008)(8936002)(76116006)(66446008)(2906002)(7416002)(86362001)(8676002)(478600001)(66946007)(6506007)(33656002)(6636002)(55016002)(71200400001)(26005)(186003)(52536014)(316002)(7696005)(83380400001)(4326008)(5660300002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFl2RUd1b2xPN0NEaHJPUU1Od2NFVzd2TGt4V3V3REVGU2tqTXkzbnV3YkJs?=
 =?utf-8?B?SHgvazVrS0dveFVhWEgxWXJTdW9zNWptMWN1ZTFkYTE3L3YwbmRvcFBuMUxv?=
 =?utf-8?B?SzZuSlhNZlZUcnVRb1FveUFueXZYWG4zeER1T1AzWUxVRGhOelFYUWsrVE9t?=
 =?utf-8?B?MUd6YndTNEJLaUR2eFZEekp3MUo4L0p1dEJVdGxIcDJ1Zitxd2hUWFVqRitL?=
 =?utf-8?B?YzBYbk5NYXpUVEV2K3Zoc3diajZuN3ZDYkludzdmL2Q0dnAvSVE1S29QL01E?=
 =?utf-8?B?K1JjMitabDFTd212K2lMQm52SFVLUVNaWWhHd3NYU1pndGQrZm42RHVjMTZh?=
 =?utf-8?B?TE1oMzZDRHB1d1dDMWNoYWc5cXFDak1VWGtIY0h4NE9yOGROSjdpaExITzg5?=
 =?utf-8?B?dCtjZ1Y4eTRoVVZ2elpZZDdmWlhmaDZ1NDNVL3N2TGVoRU9UUFlmQm1Ueld1?=
 =?utf-8?B?SXVXL1V3ZUg5dmtYM3h2TU5aZkpldDIvUVpJTytXeVZUd1YxV1BUbzljREc1?=
 =?utf-8?B?RVBHY2RheGtuemNWdThlMlpvQS84cG56TXN5a0hXbXBNaGlId0d1RHNBb2xk?=
 =?utf-8?B?WWlNQktLSHpBWi8vLzUyWWN1UjI1MDZNYjVFdHJNdy9yanRvdFNaRFNLL1JJ?=
 =?utf-8?B?Mmk2WDMzbkI5NHhpSHlOZmh2ZDNBVUJnSGJqTGVBMUFMbWlKSXNpUFZnVFhE?=
 =?utf-8?B?eFlEbDE1VmgvaStQcHRCQ1RESkJxY1lLdG9wK2c2eXllUjNGanBUY0VTUkJW?=
 =?utf-8?B?Vmd4S2dVSW9Wb0hDcUtaU3AvdXgwcXdvQkRzc2VBcytrVWhYUTZJVEFUTE83?=
 =?utf-8?B?WFNrT1dZSWFWajBaWUVTejdDK29wTUZ5cVF4dENJOUlsR0lEQzJuMVE0TnJH?=
 =?utf-8?B?TCtvUmJ1QmdQc2NBeTkraGl5VEU3VzBhVDBUWHJkK3cxbFNhU2NiMWU2SUhY?=
 =?utf-8?B?WUllRXR3RTc5a2I4T0RFNExzR1IxWVk1b0Y3NTUrS3BMU2lpNC83TFFBNDFR?=
 =?utf-8?B?bDJGa3Q2K3RmUHlRZ0JYNWdseGFhV2VCN0pPbHRrVHFXaHdvcm53TnQrVEND?=
 =?utf-8?B?R1ZBTitSLy9USms5ZDMwamVqZ3M5WkZYb0N3cS9FUXZmNWx3Wk5iMFVMWUVK?=
 =?utf-8?B?bEFUbkRvMDVUa1pPd0F6a0FmZDR5RGZGWC9wRU5PTStzQUw3VTgyL2dNMXc3?=
 =?utf-8?B?YlZlSEcxeGU2NUxWU2hZZEdHNFFYanJIVGpzcThXU052QzY0bWNTdXMwQm1I?=
 =?utf-8?B?STNNRkU3VDREemZBVzFtTUlBYnphbGhkb252NFdrRWl5SitoMm5OWGtHaXhK?=
 =?utf-8?B?b2VlLzdWSFNpb1paTE01ZEd3RFBuVVZpS2hwN2NKOTViMHNhbWFYazgyeHFl?=
 =?utf-8?B?MTNBdjBtNWNEZC91b2NUamlodGVXMGNzWjZrNW1KcFV0YVAwei9ZQmo1VVlD?=
 =?utf-8?B?NjAxbVFVWGJTZ0dQV0lPWHJLT2paLy9YdHpSU2d4K3hONmVkaUUrWlJrWjA2?=
 =?utf-8?B?c1JuWFFoay9zYkVYS005eFRiMFJDWHpIcVhyYk5CMlMxNVV2bGRnWTUwUi8r?=
 =?utf-8?B?TlovRlEvb1F2V05vWjNBWVF1ZnpEODFDNHo4RjNJWVQyaFJZdStnTWZRc1BJ?=
 =?utf-8?B?dUFwekRBa0F1cU9QQldSWk9KblNKZkdXK0ZMTWxqUGFtRHdMb1g3ck9mbWI5?=
 =?utf-8?B?aThaVjk5aS9ISUN6dmQ0Zi9OYlpxUytEVXdjS1Fnd0dybXJva3YzT0FGU1hn?=
 =?utf-8?Q?HPrRBrT7HabC3oy/d+pVwlYyt13Beiez3saMeAi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec10c185-e060-4b7c-2e77-08d9424dc9ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 20:20:11.5910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3qAToCHqlbORFmWO5VQ6yw89pnz5h5hUJX9xKPfIRPDPzod51/1KT7mrqFs6LVEB78Eo7yPamhHzdWRqjuxsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2976
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogUGF1bCBNZW56ZWwgW21haWx0bzpwbWVuemVsQG1vbGdlbi5tcGcuZGVdIA0KU3ViamVj
dDogUmU6IFtzbWFydHBxaSB1cGRhdGVzIFBBVENIIDQvOV0gc21hcnRwcWk6IGFkZCBTQ1NJIGNt
ZCBpbmZvIGZvciByZXNldHMNCg0KRGVhciBNdXJ0aHksIGRlYXIgRG9uLA0KDQoNCkFtIDA2LjA3
LjIxIHVtIDIwOjE2IHNjaHJpZWIgRG9uIEJyYWNlOg0KPiBGcm9tOiBNdXJ0aHkgQmhhdCA8TXVy
dGh5LkJoYXRAbWljcm9jaGlwLmNvbT4NCj4NCj4gUmVwb3J0IG9uIFNDU0kgY29tbWFuZCB0aGF0
IGhhcyB0cmlnZ2VyZWQgdGhlIHJlc2V0Lg0KPiAgIC0gQWxzbyBhZGQgY2hlY2sgZm9yIDAgbGVu
Z3RoIFNDU0kgY29tbWFuZHMuDQoNCkNhbiB5b3UgcGxlYXNlIGFkZCBhbiBleGFtcGxlIGxvZyBt
ZXNzYWdlIGxpbmUgdG8gdGhlIGdpdCBjb21taXQgbWVzc2FnZSBzdW1tYXJ5Pw0KDQpEb246IFRo
YW5rcyBmb3IgeW91ciByZXZpZXcuIEkgYWRkZWQgYW4gZXhhbXBsZS4NCg0KS2luZCByZWdhcmRz
LA0KDQpQYXVsDQoNCg0KPiBSZXZpZXdlZC1ieTogS2V2aW4gQmFybmV0dCA8a2V2aW4uYmFybmV0
dEBtaWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTogTWlrZSBNY0dvd2VuIDxtaWtlLm1jZ293
ZW5AbWljcm9jaGlwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFNjb3R0IEJlbmVzaCA8c2NvdHQuYmVu
ZXNoQG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBTY290dCBUZWVsIDxzY290dC50ZWVs
QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE11cnRoeSBCaGF0IDxNdXJ0aHkuQmhh
dEBtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEb24gQnJhY2UgPGRvbi5icmFjZUBt
aWNyb2NoaXAuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlf
aW5pdC5jIHwgNiArKysrLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3Nt
YXJ0cHFpX2luaXQuYyANCj4gYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5j
DQo+IGluZGV4IDVjZTFjNDFhNzU4ZC4uYzJkZGI2NmI1YzJkIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9z
bWFydHBxaS9zbWFydHBxaV9pbml0LmMNCj4gQEAgLTYwMzMsOCArNjAzMywxMCBAQCBzdGF0aWMg
aW50IHBxaV9laF9kZXZpY2VfcmVzZXRfaGFuZGxlcihzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQ0K
PiAgICAgICBtdXRleF9sb2NrKCZjdHJsX2luZm8tPmx1bl9yZXNldF9tdXRleCk7DQo+DQo+ICAg
ICAgIGRldl9lcnIoJmN0cmxfaW5mby0+cGNpX2Rldi0+ZGV2LA0KPiAtICAgICAgICAgICAgICJy
ZXNldHRpbmcgc2NzaSAlZDolZDolZDolZFxuIiwNCj4gLSAgICAgICAgICAgICBzaG9zdC0+aG9z
dF9ubywgZGV2aWNlLT5idXMsIGRldmljZS0+dGFyZ2V0LCBkZXZpY2UtPmx1bik7DQo+ICsgICAg
ICAgICAgICAgInJlc2V0dGluZyBzY3NpICVkOiVkOiVkOiVkIGR1ZSB0byBjbWQgMHglMDJ4XG4i
LA0KPiArICAgICAgICAgICAgIHNob3N0LT5ob3N0X25vLA0KPiArICAgICAgICAgICAgIGRldmlj
ZS0+YnVzLCBkZXZpY2UtPnRhcmdldCwgZGV2aWNlLT5sdW4sDQo+ICsgICAgICAgICAgICAgc2Nt
ZC0+Y21kX2xlbiA+IDAgPyBzY21kLT5jbW5kWzBdIDogMHhmZik7DQo+DQo+ICAgICAgIHBxaV9j
aGVja19jdHJsX2hlYWx0aChjdHJsX2luZm8pOw0KPiAgICAgICBpZiAocHFpX2N0cmxfb2ZmbGlu
ZShjdHJsX2luZm8pKQ0KPg0K
