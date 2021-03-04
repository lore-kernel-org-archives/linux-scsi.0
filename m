Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CADC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 16:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7851664F43
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 16:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhCDQtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 11:49:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:1253 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238327AbhCDQtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 11:49:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614876550; x=1646412550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f9UnBEmJW0vfbaFX6Cok5lcRh4cR78O5M+j6MXns9MM=;
  b=X+GrNkwyLSYeJmTR12gMsDGG2+oo8FWXVsZrJoqrYt4zcMJR2cdtr1Ca
   En3WHaIGWC8B5DBt9/cZZisTjBMGnP9Hz08HcfR+azIA33MU90Jh51D7s
   s4bTCLJjbOFyT1d17GkA0Z/vb16E6wNhfkAnEejNkyuj47T/cctP5j5d4
   JZZV1acIEFTY566ab/Lh3EsLsq3yMiOdR6mTegSkjhH6tnoePbqry0kUg
   Z+NfwIrVSkTnDjUojuEhXejqCTTHFm0oQ6pgyupKKVoY23G0U8NIUtcHj
   vV4OD1TnnUKCJYyBx1W7Bh/emdbUiX1C4qqlEJkc9vAX/RiPl+JqbK3EL
   A==;
IronPort-SDR: FTlP2IE7lnjWwmX5N0hNcNZTaFs+LbNoj+kgX2Zk1wnUZnQtqd150BTLDuTiiS0d7Qjf7fjKPu
 UKtjjZVtmMdrO5cGnXie3w4DmS6+FYQLwb2HhZJH7psCNBIVHsuIdbkTJGqHXWiOIPUrihsU5U
 JxuQoVWdZ8QeonXooDVVHZ6G2sqd6ieN6YkpM1y2JpH1IlV5Zm6BXmquLFnbyRY6vGe5I/Hjcv
 CgdcnvoTE3CqEJ+Qp66tt+FpVla7VtiJCjrYTOzQtz6Gy0bWMHu5kNDwRP3GjDv4M8TH62zhJC
 tGY=
X-IronPort-AV: E=Sophos;i="5.81,222,1610434800"; 
   d="scan'208";a="111493812"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2021 09:47:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 4 Mar 2021 09:47:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 4 Mar 2021 09:45:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSs5MwIa/281niGtBgtXSUEskrrQAgyo/YSgqrPG5iqpqcWwfsi7bGqX+aws5qhWlPdVMbQ4Z4PucZoI95nme692f1S0IyjqtQSmp86hyi1OTRSPC01bd+MzgX87vLiFSnW1I+KEjEoQBD5NO/AectJgRcYf1CLqHneY3QAC5db8hxfNMsCXE4Scc8DlOKY34YMDHBi3UVlx/R0NHGTda1hqJWLXochaPvBUkT1pc8jsyTZDy8RfqIkXrNTvX03yzSXnWRteoUJI4SzjlLtbnLGRsBMGqGBYX/vLxo7NFZPjZnfoOYVzDRGZB/jGNT1CBDZpNL4tF9NUwDz0CVGc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9UnBEmJW0vfbaFX6Cok5lcRh4cR78O5M+j6MXns9MM=;
 b=Xkb8pX3Hck+HJTDs3lev0F5ZJKmOIsPiJ0uz0+ZyNM9UiyqDNhegYtLHOsPnNiX+Qjq3uwXLhrtQvRV02PKC0PNbvx4Ej9rxjSFjiL9hfBLrvFe/3icetIMQVPDrarzVSXDg9suNfKN8a2om60yl+wUhZdVNAAYt9tejY/nH45zpnxsAz4fgg36kKelQhoH2pX+HoslQNQ+UWsy2p5M7wQ66XUoTXrVL+awAQp/pP4RLRdAfPSCf3Sr2+as+F4q9gbc581NDOtytLaex97qCLRY8k6K8rriGQPKAFKS1qfwUirTE3B8357yds3xScL3sZzU2AgT9omTic2IxaTcbxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9UnBEmJW0vfbaFX6Cok5lcRh4cR78O5M+j6MXns9MM=;
 b=qoJ0WzofQ+wqtz2cwkLnPdZAwRMBLKnH87zP+bM0IWt5dh8qBSQelTh7RohO72BZp/EcuIWJF8DTLFqX9oEyr5uxi8zMV1mcqXEUV/pvkVaSWM0tLAMM11oNYQbyj9lcvKdr/vgiNbWZ23THkBP14ccvk5M0I8i7BoxMOeZBEnA=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 16:40:56 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::d909:f55f:7b75:8b77]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::d909:f55f:7b75:8b77%7]) with mapi id 15.20.3912.019; Thu, 4 Mar 2021
 16:40:56 +0000
From:   <Viswas.G@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <vishakhavc@google.com>,
        <radha@google.com>
Subject: RE: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
Thread-Topic: [PATCH 6/7] pm80xx: Reset PI and CI memory during re-initialize
Thread-Index: AQHXCsSH9xq3C+rq1kyJPRPhNdHaKqpznloAgABzoSA=
Date:   Thu, 4 Mar 2021 16:40:56 +0000
Message-ID: <SN6PR11MB3488054ABDA164ADF9E36EAC9D979@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
 <20210224155802.13292-7-Viswas.G@microchip.com>
 <CAMGffEnmGcP9C3swBDugRAchzwdhrEt0QUz9m96d3SkVLQXR6g@mail.gmail.com>
In-Reply-To: <CAMGffEnmGcP9C3swBDugRAchzwdhrEt0QUz9m96d3SkVLQXR6g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [103.153.105.102]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31e6778b-b4b9-4ecb-9fda-08d8df2c48a6
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB34887160842D2A430A8DA27E9D979@SN6PR11MB3488.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRQv75evzGsWqtlkdoS2nj23Q/rqmhuT+th40nNrFoCEFT/ZAnoLY/p8maaiWvXawCapYHVQu2Z5aF+D5YrACTSW0zaY3xFfeS3FB01JHcYiI2YmLiO/AomMwtYdioUmBzHbdUgNzRIr9n6uFJlFcOnDqSAq8MBVG7cjXm8pflcY9FLszofLzS6IL94hGcLFeIzF8XjoJ2wq0XeBcOtjYrOt7xx92TD+OnfstTNcbuuk5pmSx0FW8YdnxR2vGfaYUjtk/PLXrrma9/+qOansW8wZGAckqL4Jlx7dWi3aHj6heq77LMkAWhqGGgtzT0scHam75HuzjCrGggQ1gaJ7gKlCygvxtNDf8KVWg7sqaJPNYMma2apPcBTz2mlbA8bsX6ptF+m16IPjOjVEcX9ai8rt5Oxl4QUTflVxEboMA0Sw2Phrl9HFqv+YcG8fVV/8SiKmb34UaBuaD4ZlsBr6SdwS1z2LYsV5EtHLpc5JfwCFzcZhJJ+o7cGmhat+txkwAZ45MNm8ENwdIJ03e0t9Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(346002)(376002)(7696005)(8936002)(5660300002)(71200400001)(52536014)(64756008)(53546011)(66446008)(66556008)(6506007)(186003)(55016002)(83380400001)(478600001)(8676002)(66476007)(26005)(6916009)(9686003)(86362001)(33656002)(54906003)(76116006)(2906002)(316002)(66946007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T0RiNUdjWUErd0xpSmcwempRTk9aSXJUQXRxMmZjekcvNjkyUkhHR05QNVBM?=
 =?utf-8?B?dm1maStxMWhUdVpkQmU2bkhGV2xWUXQwWTBiSzJHTXA5bllmaTFPcmVsSGlM?=
 =?utf-8?B?ckNuMHZSMjhMZytESUZxNkFodUpHT3NMRFFuZjhGVjdTNFJZVmFZY0JzUjh4?=
 =?utf-8?B?UktRVkcrblUrejZkM1QvT3ZNMWVUVUF5SWdnSDd6QXllcWZrMndwdG5Jd2JV?=
 =?utf-8?B?QWlpSGpqWXc0TUdCVzVzeWh4UVZvNmdnYTA4b3NkZURmVnU0Rk1sKzlFa3Js?=
 =?utf-8?B?RTU1OXVFbUNZRkhwVDlMYmJ5bGcyZFhpeERHWjVtTmRVdUlsUzd0QUJML1pr?=
 =?utf-8?B?R2hQbWVkdnptbmJsSmJGd1lXb0tWeW1sejAyRWVXMXU4c2FGWkR0MndOZUhJ?=
 =?utf-8?B?bkllZlpLVDdycU8yVHBBNXpaV0l2bk0wcHhFdEwrSVB2MXkrek8zUll0cG9x?=
 =?utf-8?B?M2lFUjFSOTZaczM1SUZ4QU4zaEJCZFpXcDlLSU43WlZXcnVRLzVTcGNQQ0RQ?=
 =?utf-8?B?MXdtcmZuL0JRWlB0QzNJNHpVNlREc0Yvd1MyOTEvY0NUWnVjaHFNQWtIc1l5?=
 =?utf-8?B?c0o4elB0eGRKOUhxTzI2WWJzZTI1TmlSeGV0cTNKc1QvWk1TbE9hT2FxYzZi?=
 =?utf-8?B?elNPTUJ3THJJQ0RoK1dRTmx4ZE51MThsbEVEZ0VuM04zT1BIN0ZwVzU5NllY?=
 =?utf-8?B?TjBGd3dqSldWL21RRzJ5MGtnZlNRVlA5cXI3TWxNcEZ3ck5ZbDlGbUduYS80?=
 =?utf-8?B?ZmVabjNGL1pmQlgxcTA4YUtTbU9DTTBDN0tFNUtWSTdGcEp0RUljV0RvNFB5?=
 =?utf-8?B?U0w1WS9oWHJ5QURyN25rOUEyQTZPTFAxRllkSE00aUV1K0N6Y0s1UmZQUkRU?=
 =?utf-8?B?RUtjejJpMjJUQ1o4Nkp1QWtUVTVXVTlrVnF0ZTVPeHFqVnpBUFZ0SHhUbkpG?=
 =?utf-8?B?L2xvUEs3d29IR2hqZ2RHM1J2NURJSGdnTmR1UjByOGpCazZFdEFyYkppdzQr?=
 =?utf-8?B?cGJoYWpvZmd3L1VBUFpCQ21OUEJROVE1ekZFNFcyV0tsSjgrSXkwSFFCQ0ZH?=
 =?utf-8?B?cUFyVmQwK1VzRHpqUTVNL0hHZHFzeWhSYmdacnZGakNxQy82TXBac2ZFelVI?=
 =?utf-8?B?UmlsVklDTk9UdlR4Vll2cnRwd2FwMVovN01BNWNvbG5JNmNqVnlIK0JqZkZl?=
 =?utf-8?B?MitDcnZaRmhOWXZRcFZsSVVScXE4dFFHWUliZ0VWbm5tTERub3JINEhia3pG?=
 =?utf-8?B?WnFRZTlScitjQUVWRmJiSVF3Z0k3R0V6U1FXWmdnTklSZU1HNG5tL1F4VVBh?=
 =?utf-8?B?YUZic2xmOCtneDBaUWwvNUNFemdSWERPaDhrQnU4MUMwQWd5SWhjY2NJVnIv?=
 =?utf-8?B?dEY0OG15VWZ3RkdKYjBRblM2UWFGQkRWT0c3ZGRGOThOelJ6QXk4a1BlU2dh?=
 =?utf-8?B?UXBvZUNMaHdFc1IrajUzM0swY3BqOHlWMmY3VGpqeDAzbUxjYmFzWEtqSlFK?=
 =?utf-8?B?WlB2OWNwUDMxdjM4QXVQbWJ2TkFqVjdld2JQMGl2ZURXU1ptdXFFTVlON2pZ?=
 =?utf-8?B?S1dUUXExZVN4Q0pQdGZ0V2h2dFlYRnNoUDNIQllxMk5Wd293Ky8ySnFzMmVM?=
 =?utf-8?B?ZzRTSmM3WXMvYjAyNG51dW1sS3BtQnB2VWFLUnRNS1pNZDNDMWNhNEwyY0RO?=
 =?utf-8?B?Q2FPMWdLRWFBbWhvZXU2YnVTK2RRNktrUVZHTitpR245bEErZDZnZGc3Kytt?=
 =?utf-8?Q?JwOzkABIsY8G/j45dYLbU87jLKd8haKvPDkYZcD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e6778b-b4b9-4ecb-9fda-08d8df2c48a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 16:40:56.2470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l832kfe/+MYhNG5MeUinP5tdf2MLOVXMFbW+gWxMEEymIrXUV1B8cTXYds0AWUPXBm4oUv2qwcjakiFvBjjheQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppbnB1IFdhbmcgPGppbnB1
LndhbmdAY2xvdWQuaW9ub3MuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggNCwgMjAyMSAz
OjA3IFBNDQo+IFRvOiBWaXN3YXMgRyAtIEkzMDY2NyA8Vmlzd2FzLkdAbWljcm9jaGlwLmNvbT4N
Cj4gQ2M6IExpbnV4IFNDU0kgTWFpbGluZ2xpc3QgPGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3Jn
PjsgVmFzYW50aGFsYWtzaG1pDQo+IFRoYXJtYXJhamFuIC0gSTMwNjY0IDxWYXNhbnRoYWxha3No
bWkuVGhhcm1hcmFqYW5AbWljcm9jaGlwLmNvbT47DQo+IFJ1a3NhciBEZXZhZGkgLSBJNTIzMjcg
PFJ1a3Nhci5kZXZhZGlAbWljcm9jaGlwLmNvbT47IFZpc2hha2hhDQo+IENoYW5uYXBhdHRhbiA8
dmlzaGFraGF2Y0Bnb29nbGUuY29tPjsgUmFkaGEgUmFtYWNoYW5kcmFuDQo+IDxyYWRoYUBnb29n
bGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDYvN10gcG04MHh4OiBSZXNldCBQSSBhbmQg
Q0kgbWVtb3J5IGR1cmluZyByZS1pbml0aWFsaXplDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8g
bm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQ0K
PiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFdlZCwgRmViIDI0LCAyMDIxIGF0IDQ6NDggUE0g
Vmlzd2FzIEcgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gUHJv
ZHVjZXIgaW5kZXgoUEkpIG91dGJvdW5kIHF1ZXVlIGFuZCBjb25zdW1lciBpbmRleChDSSkgZm9y
IE91dGJvdW5kDQo+ID4gcXVldWUgYXJlIGluIERNQSBtZW1vcnkuIFRoZXNlIHZhbHVlcyBzaG91
bGQgYmUgcmVzZXQgdG8gMCBkdXJpbmcNCj4gPiBkcml2ZXIgcmVpbml0aWFsaXphdGlvbi4NCj4g
DQo+IFdoeSAicmVpbml0aWFsaXphdGlvbiIsIHRoZSBmdW5jdGlvbiAgaW5pdF9kZWZhdWx0X3Rh
YmxlX3ZhbHVlcyBpcyBjYWxsZWQgZnJvbQ0KPiBjaGlwIGluaXQ/DQoNClllcy4gVGhpcyBjYWxs
ZWQgZnJvbSBib3RoIHByb2JlKCkgYW5kIHJlc3VtZSgpLiBEdXJpbmcgcmVzdW1lKCksIHRoZSBz
dGFsZSBQSSBhbmQgQ0kgDQpWYWx1ZXMgd2lsbCBsZWFkcyB0byB1bmV4cGVjdGVkIGJlaGF2aW9y
Lg0KDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXN3YXMgRyA8Vmlzd2FzLkdAbWljcm9jaGlw
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSdWtzYXIgRGV2YWRpIDxSdWtzYXIuZGV2YWRpQG1p
Y3JvY2hpcC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQXNob2trdW1hciBOIDxBc2hva2t1bWFy
Lk5AbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgw
MDFfaHdpLmMgfCAyICsrDQo+ID4gZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMgfCAy
ICsrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfaHdpLmMNCj4gPiBiL2RyaXZlcnMv
c2NzaS9wbTgwMDEvcG04MDAxX2h3aS5jDQo+ID4gaW5kZXggNGUwY2UwNDRhYzY5Li43ODMxNDli
OGIxMjcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfaHdpLmMN
Cj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9od2kuYw0KPiA+IEBAIC0yNDAs
NiArMjQwLDcgQEAgc3RhdGljIHZvaWQgaW5pdF9kZWZhdWx0X3RhYmxlX3ZhbHVlcyhzdHJ1Y3QN
Cj4gcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEpDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgcG04MDAxX2hhLT5tZW1vcnlNYXAucmVnaW9uW2NpX29mZnNldCArIGldLnBoeXNfYWRkcl9s
bzsNCj4gPiAgICAgICAgICAgICAgICAgcG04MDAxX2hhLT5pbmJuZF9xX3RibFtpXS5jaV92aXJ0
ICAgICAgICAgICAgICAgPQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHBtODAwMV9oYS0+
bWVtb3J5TWFwLnJlZ2lvbltjaV9vZmZzZXQgKw0KPiA+IGldLnZpcnRfcHRyOw0KPiA+ICsgICAg
ICAgICAgICAgICBwbTgwMDFfd3JpdGVfMzIocG04MDAxX2hhLT5pbmJuZF9xX3RibFtpXS5jaV92
aXJ0LCAwLA0KPiA+ICsgMCk7DQo+ID4gICAgICAgICAgICAgICAgIG9mZnNldGliID0gaSAqIDB4
MjA7DQo+ID4gICAgICAgICAgICAgICAgIHBtODAwMV9oYS0+aW5ibmRfcV90YmxbaV0ucGlfcGNp
X2JhciAgICAgICAgICAgID0NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBnZXRfcGNpX2Jh
cl9pbmRleChwbTgwMDFfbXIzMihhZGRyZXNzaWIsDQo+ID4gQEAgLTI2OCw2ICsyNjksNyBAQCBz
dGF0aWMgdm9pZCBpbml0X2RlZmF1bHRfdGFibGVfdmFsdWVzKHN0cnVjdA0KPiBwbTgwMDFfaGJh
X2luZm8gKnBtODAwMV9oYSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAwIHwgKDEwIDw8
IDE2KSB8IChpIDw8IDI0KTsNCj4gPiAgICAgICAgICAgICAgICAgcG04MDAxX2hhLT5vdXRibmRf
cV90YmxbaV0ucGlfdmlydCAgICAgICAgICAgICAgPQ0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgIHBtODAwMV9oYS0+bWVtb3J5TWFwLnJlZ2lvbltwaV9vZmZzZXQgKw0KPiA+IGldLnZpcnRf
cHRyOw0KPiA+ICsgICAgICAgICAgICAgICBwbTgwMDFfd3JpdGVfMzIocG04MDAxX2hhLT5vdXRi
bmRfcV90YmxbaV0ucGlfdmlydCwgMCwNCj4gPiArIDApOw0KPiA+ICAgICAgICAgICAgICAgICBv
ZmZzZXRvYiA9IGkgKiAweDI0Ow0KPiA+ICAgICAgICAgICAgICAgICBwbTgwMDFfaGEtPm91dGJu
ZF9xX3RibFtpXS5jaV9wY2lfYmFyICAgICAgICAgICA9DQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgZ2V0X3BjaV9iYXJfaW5kZXgocG04MDAxX21yMzIoYWRkcmVzc29iLA0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+IGIvZHJpdmVycy9z
Y3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiBpbmRleCAxYWEzYTQ5OWM4NWEuLjBmMmM1N2Uw
NTRhYyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4gQEAgLTc4Nyw2
ICs3ODcsNyBAQCBzdGF0aWMgdm9pZCBpbml0X2RlZmF1bHRfdGFibGVfdmFsdWVzKHN0cnVjdA0K
PiBwbTgwMDFfaGJhX2luZm8gKnBtODAwMV9oYSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICBwbTgwMDFfaGEtPm1lbW9yeU1hcC5yZWdpb25bY2lfb2Zmc2V0ICsgaV0ucGh5c19hZGRyX2xv
Ow0KPiA+ICAgICAgICAgICAgICAgICBwbTgwMDFfaGEtPmluYm5kX3FfdGJsW2ldLmNpX3ZpcnQg
ICAgICAgICAgICAgICA9DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcG04MDAxX2hhLT5t
ZW1vcnlNYXAucmVnaW9uW2NpX29mZnNldCArDQo+ID4gaV0udmlydF9wdHI7DQo+ID4gKyAgICAg
ICAgICAgICAgIHBtODAwMV93cml0ZV8zMihwbTgwMDFfaGEtPmluYm5kX3FfdGJsW2ldLmNpX3Zp
cnQsIDAsDQo+ID4gKyAwKTsNCj4gPiAgICAgICAgICAgICAgICAgb2Zmc2V0aWIgPSBpICogMHgy
MDsNCj4gPiAgICAgICAgICAgICAgICAgcG04MDAxX2hhLT5pbmJuZF9xX3RibFtpXS5waV9wY2lf
YmFyICAgICAgICAgICAgPQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdldF9wY2lfYmFy
X2luZGV4KHBtODAwMV9tcjMyKGFkZHJlc3NpYiwNCj4gPiBAQCAtODIwLDYgKzgyMSw3IEBAIHN0
YXRpYyB2b2lkIGluaXRfZGVmYXVsdF90YWJsZV92YWx1ZXMoc3RydWN0DQo+IHBtODAwMV9oYmFf
aW5mbyAqcG04MDAxX2hhKQ0KPiA+ICAgICAgICAgICAgICAgICBwbTgwMDFfaGEtPm91dGJuZF9x
X3RibFtpXS5pbnRlcnJ1cF92ZWNfY250X2RlbGF5ID0gKGkgPDwgMjQpOw0KPiA+ICAgICAgICAg
ICAgICAgICBwbTgwMDFfaGEtPm91dGJuZF9xX3RibFtpXS5waV92aXJ0ICAgICAgICAgICAgICA9
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcG04MDAxX2hhLT5tZW1vcnlNYXAucmVnaW9u
W3BpX29mZnNldCArDQo+ID4gaV0udmlydF9wdHI7DQo+ID4gKyAgICAgICAgICAgICAgIHBtODAw
MV93cml0ZV8zMihwbTgwMDFfaGEtPm91dGJuZF9xX3RibFtpXS5waV92aXJ0LCAwLA0KPiA+ICsg
MCk7DQo+ID4gICAgICAgICAgICAgICAgIG9mZnNldG9iID0gaSAqIDB4MjQ7DQo+ID4gICAgICAg
ICAgICAgICAgIHBtODAwMV9oYS0+b3V0Ym5kX3FfdGJsW2ldLmNpX3BjaV9iYXIgICAgICAgICAg
ID0NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBnZXRfcGNpX2Jhcl9pbmRleChwbTgwMDFf
bXIzMihhZGRyZXNzb2IsDQo+ID4gLS0NCj4gPiAyLjE2LjMNCj4gPg0K
