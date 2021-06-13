Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D93C48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDF561075
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFMKE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:04:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38959 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhFMKE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623578587; x=1655114587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lsuaJPG1yYzlXLbs6mcil5pkl3KRuhiMGNHacyIDWMw=;
  b=VNAHWZsWv6kLlXrWPaKdHbXgUTPxmLD88jE1yN9gMulNskhW2z0O7wVm
   Z5ujAuNl+p/bWextNE+dyYbWrEHX/e0yp2EvKKYnOubZKCAR9WSpK/d7x
   Hj3PcA02+A7WRB6rGMMBLyqcuBmNpWQJOCzr3wp6xIHjBnHXq8yZ5yCG7
   1wo/bKGDc9qInZBbsV9oQrRzuKxupD79/0eHXuNCOI4kOya0Ndl+EJbVN
   8K9x8DukVDhIMmIxF4zmn/IL8IOqxgVwXrmPRFHdiRo7dasfI8kdEo53E
   ek+YPh6YGLWnE3HKRKa6i52KMfKKpp14ixlpSPc8GYH6LNjPcgF7JJCJq
   w==;
IronPort-SDR: fgyWSY53fTNgXfAu731ubZQgfMk1OZFztHreZALee06rGfd3X5Ev/OnsiVcjVjmj+xc8a/UKsu
 +eqIMtRd56aF/LqW6+gNF24JAFhQaHvvHlzotgfscYMPK7Sa2uEknlD8XZb0KMvvxdTMj8yAOC
 LzwEGk4pPzfYMGHAwcdFawP/0JI0W6lpeMIlwwKMVSr4QJ2zzKBHhPRXOT3jB1llHGA+Ncg1If
 5e0cQwkEaMJuAYzZGTVlDNGMqpEeCxEkOhBbrOEHtmeVqcKLt73babBTyaxx0I90599PNQXPP7
 Dig=
X-IronPort-AV: E=Sophos;i="5.83,271,1616428800"; 
   d="scan'208";a="172307441"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2021 18:03:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7sB20oBsZlF3yC948abqqeFUHN1CEnB1Mwuj8GhnxvYVx4IxEFQ1JUWYEjGAhOmXALlWvT6Ktjc9od6c8bmMtWl91CFPnnUWvo4xCfwimgUcH0b63TDr/wxy5XGQE6qS67+sfZ6rsz6Nw/OnF2Dg/JCf9w+F0g/bcIMQeFODSlLkYEsX9CWDM1O99VyBb5koZMcnfNjsRDq2h5wzCAacb2y6/AqFJ2ZLMM7q9WqRZg0mW9K03RAEUZG1iV0IH0GrrMuPygHdpXD2639zhGViE2leN9NpWuwAsytwSyXPvGO8yjRlE7dMtWKVZDpwc74pO4Cw++t79aSCyyQYXoC0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsuaJPG1yYzlXLbs6mcil5pkl3KRuhiMGNHacyIDWMw=;
 b=eMkR1CBa6wjVFwlOQ64DnsE0cz4/5aUZ6b413mLNxHnd0j5DnUAUnvvW0otzGbjGxQQGnDa09IzdettUW1oGB5XXt5G3qhGJd2ky7Ia3/PepK+ZTeTD7f/JyykdXTZKZCrD7R/+5EK8l7CWkrIOBDOtysqF3WXxKkwFLIxaiJaEGgLcuifT4EOY7hwLk10CjTK2re5DyszO4t8M8a4vS00aD4kXPSAS27uhshPRJJYKrTvFhYyVWaCnTVPE7Egg8pLH/o/9bnQMWzfnpNrIxdxlZ1F67IOFZ4G0kCJ+UvIVfnLCZgDWEEacQdxxWdoVPfJxt5/Xf/oE0WXtEMgba2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsuaJPG1yYzlXLbs6mcil5pkl3KRuhiMGNHacyIDWMw=;
 b=VCJ7qgFdPs6Ys9WbLlVbTOcVfKnpXVqwcQOpHh2BWAZEAl+yFuB6KkTJ5IpUmo/VKzuaOhoBknKapfhP46Ogz7Uf+wZQQDivxywQfMumiAYGscha9EtQ0uOlZ0tGladTGFmcAjCyXCL6qlWbvL6MrLyYIKD40D1HuAyxHrHyPyg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1100.namprd04.prod.outlook.com (2603:10b6:4:46::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.25; Sun, 13 Jun 2021 10:02:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4219.025; Sun, 13 Jun 2021
 10:02:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v37 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v37 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHXXmiMgBdwR3BCxk6/pn4EG9J/oasPUeCAgAJnPRA=
Date:   Sun, 13 Jun 2021 10:02:22 +0000
Message-ID: <DM6PR04MB65755B0B48BDDF4846246DC5FC329@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
 <20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
 <a5b89372-fdb6-efe0-919f-59041d643071@acm.org>
In-Reply-To: <a5b89372-fdb6-efe0-919f-59041d643071@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7891150-447f-4663-a966-08d92e52567b
x-ms-traffictypediagnostic: DM5PR04MB1100:
x-microsoft-antispam-prvs: <DM5PR04MB1100C7422350DFF57C24271CFC329@DM5PR04MB1100.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wjtBsYg6usUJjeFn8kA5QPTm7WOdpa+/YgBT9IQ4lx/b4aJZ7W1m9d3zZRhJ+NL8TTNIBQYClElJNUO8M8vKkmCBvf4Cl9VPXB0nD/3f2Y4bRYegtCCAlv2MLeTex7rb0sv7uzyRhg7j6dVlcAwBO5amJRnuIZTwMiL/XSrE3FGoeLgGWyZR3v89KoxKexX3pO8xh37SAFxTRnYTP4st8Mv26pzMp9Vgy3TvckCRzT/WhileJS9tryjlLKZOSH4ntP4SZ3CUnusIEQIvKE1699oltBAddi3E88J0AMLPDEdpsTR+wW2vbZkIcOGnfF8Pzi6jmE+Zw18MkBLfpQgehizYXyzlO+eSV27oMvs+CoEe2GNDUSQW2VuxdexZBoa2PKI21J+hAFAbOxV15B3+6qbg+ZQJgNKT7IuSXXvam4o5EJF0gt6k4djamDnMqqjrncfaNEGe9uTovokxGU6LuLX2/KfFUI09OSUcYzNqqXPtd1z9nnhso2Ps+g8JsTYM67C5k/gWLslwM6chMKBE0HRx4J/LIYfcBH18aXlFsDj91hAvvOgJDE5zHw/EZtXjKQK09CREyXBIGWf57zfl9k7g9DAsGay0kGmKFracuE/hUeaPWZDUF/twNEkeEcqNweGy9o4+kwkg7FD0K+DC8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(8936002)(110136005)(7416002)(921005)(5660300002)(7696005)(33656002)(86362001)(122000001)(54906003)(38100700002)(83380400001)(2906002)(66476007)(64756008)(478600001)(71200400001)(4326008)(8676002)(4744005)(55016002)(9686003)(66946007)(186003)(6506007)(52536014)(66556008)(66446008)(26005)(76116006)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkNLYWhEdUV3WVFRSGh3WVFabld4UUg1SjRNT1lVQmhNeHpPSVhFaXhFclQ1?=
 =?utf-8?B?L1JSNXhqOTFQZjVPaHZhbStWUFZKYmJnWGRTZE41YVVPeDRTaGhEY0E0cnR1?=
 =?utf-8?B?RFYrb2xPZktBVU1kTGs2a3l0cVR5eXRuTW1Uc0NXQzA0Rks1cytyZktqSXNp?=
 =?utf-8?B?M3pWakt6cUtNN3k3M0NiMyt4NmRUVC8xMldDSzdFYWNGT0pNTXpBckZqeHo0?=
 =?utf-8?B?clA3NEFSMStmYzVvK1Zmb2x1Y2RGaGpOZ2ZDTmxnbGw4dEJzNTQ0a0hHbUs4?=
 =?utf-8?B?ZnhuaDZyK29RS1ROcHhFbklRbnRJT0wyS3UraTlDeHI5N1FOVnpNS08zRzJ0?=
 =?utf-8?B?VGhhVUxuY0k1R2l2NlFqamQxWHZlREFMb1NkRDlCbnRQdEtQS1JqRkVSQ1Zv?=
 =?utf-8?B?dGVMZE41L01YeVRYSWJTajRaWThNeis1clJyWTZ6YVNhWXlnLyt3Zk02VWxI?=
 =?utf-8?B?Y0Ezamx6MEFlMjZvd2V3eDg0Qm16VWdBbjIzVThRZy9RYXhpaWh0dCtFL3hk?=
 =?utf-8?B?bXJwL3diSlNqUENxQ0pjeXBMZTZqd2Y5UklsVjVRZU5ncXNoRU16cGZONm5s?=
 =?utf-8?B?T2ZUU0U5NFNtYUtyRndLYlV4WnEzbUowbi9MTndqcHdWNGlTWjgxeEdqYllm?=
 =?utf-8?B?NDVCMEpydUlUamRZQzl2cmZUMFZhbEM0Nk01RlNZMGxvcmJEZ1R1Rzc2eFQ2?=
 =?utf-8?B?SG9VQ1QwUEk2VGVUeXVrQ0g5UWlhSHNCaGRUTXI4MG45TTc0NUFZY3NQOFYz?=
 =?utf-8?B?VmNZVS9XOStNRXRJV0NYeFcwZVUrbFIyMHFIb1JoVC85QVRvMkh0RnBNeEUv?=
 =?utf-8?B?OHJvWFgvTzV5NkI2ZTUzUE8yZlhRZk5rQzRtaGdWZEJWUE5pbFl0V1JnczFY?=
 =?utf-8?B?KzFiU3AvM0xEUDVxYVQxY3BiN0Nhd0NrcEdxY1h5ODU0bUNKS3lUeUFkamNG?=
 =?utf-8?B?WE1vSm1aalBodk9PSnBldGdGY2xrTU1rZVV4eTlOQUg4QkowdVU2d1F3NjEv?=
 =?utf-8?B?VWlYaTJibmFrcXRjcnlRdk1TanlsYmNTMjgzRXkrbXBkRENLSWN1QzRKOHRH?=
 =?utf-8?B?STBVdkJzUm4xaW1heHFad0lHWndSREFldDFPSExxRVRCRlArS3F1b1ZCOStq?=
 =?utf-8?B?QTdOdzRzdm1JK3cwWU9PQlFKbGdkY0NGRkRRNWdPY0FUQmxMNERsb0REQ3FT?=
 =?utf-8?B?bHg1d2prOGpoeVduVFpsTm9NcUY1WWF5dlo5N1crWDdDSzhlZ1JteGJJcDN4?=
 =?utf-8?B?c0pIaGcyVlhoWEVwQ3JESWJQb2dCUDRtUmJSRWFCclRwYk94eGQycStGMlFV?=
 =?utf-8?B?Si9LSEVvQjNESnVWOXlrZGRlTk9iSUZKMnlpazhNMjZkelY2NXhNZURibUNx?=
 =?utf-8?B?TnRYSzZqazFkYVB0dzdBQ0FOL01OTEhPY2VlME1VbTBNaVEvaFVQbm9Lc29W?=
 =?utf-8?B?VlA4azNOMXIwR2dYUjh5NVVoVGJqd3pTSlFKcUYwcUtjeWZEd1FBYkdjaE9V?=
 =?utf-8?B?RjZNbVk1NWlCRGNnT01lcGdqK1cyZFpSNjJkNEFqQUI5d200ekNpYk5zQnRI?=
 =?utf-8?B?WjdDcHhMUlhxT2tRRkJQMGd2dmQxRTZTZjljaFAwbnRYME5lV2E4V0JrL1Ns?=
 =?utf-8?B?cEtxQnhOTklPQWdvTng4Y1pyOEkxTVA3NzIrd2xRTUVGNVhpUHQ0TXlhNUNL?=
 =?utf-8?B?amx6ZTJEN3JHYXROYnlqdDNVemQwbmZQSlVhaWVObXhPRTVFR1gyTXllZXF4?=
 =?utf-8?Q?zwKiouopSwOj6zREqUXyKFiplR4Gpdr6x0Hm5vD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7891150-447f-4663-a966-08d92e52567b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2021 10:02:22.1233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4UxwVOC0w0Jz05zBqPWGZaQx81Fbeu1grIGVkcro/pHjFGslxcOHy7Mq3mRiBzxvzKX6GNobPeVHyqWvxmDrXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBEb2VzIHRoaXMgcGF0Y2ggc2VyaWVzIHBlcmhhcHMgbmVlZCB0byBiZSByZWJhc2VkPyBU
aGlzIGlzIHdoYXQgZ2l0IGFtDQo+IHJlcG9ydHMgYWdhaW5zdCBNYXJ0aW4ncyA1LjE0L3Njc2kt
c3RhZ2luZyBicmFuY2g6DQo+IA0KPiAkIGdpdCBhbSB+LzIwMjEwNjEwLVxbUEFUQ0hcIHYzN1wg
Kg0KPiBBcHBseWluZzogc2NzaTogdWZzOiBJbnRyb2R1Y2UgSFBCIGZlYXR1cmUNCj4gZXJyb3I6
IHBhdGNoIGZhaWxlZDogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYzoyNA0KPiBlcnJvcjogZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYzogcGF0Y2ggZG9lcyBub3QgYXBwbHkNCj4gUGF0Y2ggZmFp
bGVkIGF0IDAwMDEgc2NzaTogdWZzOiBJbnRyb2R1Y2UgSFBCIGZlYXR1cmUNCj4gaGludDogVXNl
ICdnaXQgYW0gLS1zaG93LWN1cnJlbnQtcGF0Y2g9ZGlmZicgdG8gc2VlIHRoZSBmYWlsZWQgcGF0
Y2gNCj4gV2hlbiB5b3UgaGF2ZSByZXNvbHZlZCB0aGlzIHByb2JsZW0sIHJ1biAiZ2l0IGFtIC0t
Y29udGludWUiLg0KPiBJZiB5b3UgcHJlZmVyIHRvIHNraXAgdGhpcyBwYXRjaCwgcnVuICJnaXQg
YW0gLS1za2lwIiBpbnN0ZWFkLg0KPiBUbyByZXN0b3JlIHRoZSBvcmlnaW5hbCBicmFuY2ggYW5k
IHN0b3AgcGF0Y2hpbmcsIHJ1biAiZ2l0IGFtIC0tYWJvcnQiLg0KZ2l0IGFtIC0zIHNlZW1zIHRv
IHdvcmsuDQoNClRoYW5rcywNCkF2cmkNCg==
