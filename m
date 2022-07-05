Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC33C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 09:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiGEJeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 05:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGEJeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 05:34:23 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DACC58
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657013662; x=1688549662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O8ibS0YKP3zTc9BXyDVqWZaE1HX2C6XMbfhN5LOHob4=;
  b=SwuAR5JI1jhniIauodF8qc3vPQ/5ksADlhS4j9KYy67eaxgPl9/xK8pL
   Sr5uXFGRJ2zbTu/r93JPzatMJ6xhCCBfNI0oLkRmPXl5dZDYn7D3davxp
   Zy4FK+3xzpUjjtrcmlgzaaMzb/7jlKIT4HcBMXVRiU2XqO3QUSJdwQol+
   BgcSPs/vaOAiX1uUiHlAlQro64a8Xf7xlUOPFtPnzDPMBDqvYRyQ4jldk
   YPpgVT0v+THtHmUAKuD+Sh0/VAviHQqOqaPnxflmx6TeOoGANFnMi8NEc
   ZK5X2RmgDoIVVDnZPO8q4/I1Kh926Lqhkf7sEVvkspmvb/tK7d+CZ1fE6
   w==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="209731821"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 17:34:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/4trV2cnSYwU/XOnmkMoVaC9co0sb+ck1ZfcheWPAtEW0lkn4687eJDLAuo/TOFtOk6S3NpDUTMKcfq8prfNR7xzjOaAOqgxQCpgk2teCNRaQePdnqlGKcyDQx709PYsWkKJQXScoywQFSfzcpQ6mqKTDH1/YcyZqV1KPciY5r3PynG38pwSX2CN7J7V0KWf1xn84zqHBjhz8jzuIsPjjr5NDlS2tqP1hyo7Zjzi5xqMwY9G8sCo7ZdiHa0UKL8oiN2NcYXilzC4V0am5b79RpC+sJCmBQxm/t37mk3RZSIVG9msp8x3DCi/VgTFD9oA1BkzPCfi7uLM7rqWkTwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8ibS0YKP3zTc9BXyDVqWZaE1HX2C6XMbfhN5LOHob4=;
 b=eC2TCVwfCCG4kgX/IO2d0ue2X5+zWJm6KurbC6H9C3YCvC4j8jkgxv74DuGvuVdHqvicncpetRQbBjYOWNVZ6VX6x58XBhAZHuuHMQdxx4IzzOuoGdZ+FmfV3/shOrHfrX5JHfGJKGA8oyfSHN0L5H1EgFZPHegolhP6hp1ywBy0eFiisohAlMSmm9qSWfGAsie8Ok2zy/AZMxSc0Jf4Q3VKdjMte2vI9ST3UW+mX8mUzog2oqrYbnJ5pqfON0FJLxnaOetICHQNhTt+E5rxMoFjGuXwZnsRopYfXoiDJ10HQMyk8uh0AdCtHLlKiUB5fpqBuC4ucwMoi0bfz9hxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8ibS0YKP3zTc9BXyDVqWZaE1HX2C6XMbfhN5LOHob4=;
 b=kcgNvBfKhmz3AJF2AkkIanxHZqpV+Rc72jH5PdtgYwFu5hjw5Lcc23F7IP1fZhHlNRxVOskhQUInn7Um8DRHRCiAXMDP2fPZ+xWjF/C4G5WZfuU8W2dOkVXEmVNnqSs7W6TDnbyTyb2cfADYVsijX2/vzA4UGKBMFtVkjySgPGU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MW4PR04MB7235.namprd04.prod.outlook.com (2603:10b6:303:74::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.18; Tue, 5 Jul 2022 09:34:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 09:34:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Seunghui Lee <sh043.lee@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Junwoo Lee <junwoo80.lee@samsung.com>
Subject: RE: [PATCH v2] scsi: ufs: skip last hci reset to get valid register
 values
Thread-Topic: [PATCH v2] scsi: ufs: skip last hci reset to get valid register
 values
Thread-Index: AQHYkEW1nhb/81M5sEGUM7AqzTYHG61vhAlQ
Date:   Tue, 5 Jul 2022 09:34:20 +0000
Message-ID: <DM6PR04MB657566F35E88C96D2656A290FC819@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86@epcas1p1.samsung.com>
 <20220705083538.15143-1-sh043.lee@samsung.com>
In-Reply-To: <20220705083538.15143-1-sh043.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7965069b-7acc-489e-aa18-08da5e6989e4
x-ms-traffictypediagnostic: MW4PR04MB7235:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmznxsSf4LlIcZwP3bmQKiT7YWMwnpMA7E77wVNyu/z6p53EVWzt6Nxokw04YPt858LY9+u4WpNktvB/6qA9npP/7syxaE0yvBj/U3fi2TKO0E67+mje7cjvP2glTs8HjWOE9V3sW3hc+WLcGdGAYz37+ZVAXKp+VLif/RthODR0tMq4KFmiSuTUMyypOS3l8HMqcflfvAAb0k87vrAMoIfeGKAeNgTY1myMeLw9Vxz2I4LK58t8zZ2a53r+Pa9tnhN0KGBKoxqGW/aGWIS8w0BuoGTRU5wqsY3PAV3mX5zm1YKGcYDiBjLpX3Nfs9O1r8uZrpWxpz5X0pPGNN3rHY+IsiscsI63disrbC0GHMKRLuIvZ5C2ef8KsMh7ozjcZWb+q7IFzYGNj0wqwBRXwevyFu/boJuM5Bo1WXwPhdiUTGbC+5sR8NfgOa2VP0cFJwSaoAg2d9hz7IOkInN5wqcZ3QAx040ftgEu1OX+A+waHscNHwRAIP5E/6VIDVysD5hHkSAjf8pF0Mwlq4E8r0c+BJL5+56EI8C0JsjqyTSuWn84tbkcdB+Fw5/v/IRNZKwAaeeD9uidWJ/htWSoAA/qhLrzJBKuN2SzBaPuM6QTzpvBf/+XJJ0Jij9vgxCTmo9A6GiCmwnVgrQbPMpj9GLb6Rk9kW8lwtpjAhuUIUh3QEyKRysv8cTQooie+nSDkB+wV9y4JRba4fa6Zxff7qKz7MKP8pDSYbvpVD6YufftsWmtI+rO/h+eGXLosf0ucTaxZe0tNu97K+asb4QT94ccA8+h+S4IPWjRQPlc4AGdZJmig6HR+7OqIAfHs5dM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(52536014)(8936002)(5660300002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(86362001)(41300700001)(110136005)(316002)(71200400001)(186003)(38070700005)(26005)(9686003)(7696005)(6506007)(82960400001)(2906002)(122000001)(38100700002)(55016003)(33656002)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1hJS01ldUVYWGhDRFNNRDQxQ1ZCMU1IWVBpY0JtYi93UVVlV3NCT3FqaEJw?=
 =?utf-8?B?ZHcyVEhaeVU3Tkg2K0RHMk1BVjRUU0FxMnJqKzEvYkV2TU1VQlNOYnZtMnEy?=
 =?utf-8?B?QjRLSXljcDNrZ3lBQjR5bmZ0cWl6T3pqUWlVSm1IS3MyeDFvcDJzdmRFZER0?=
 =?utf-8?B?VGd2SEhJRGxYY1dyU2tZK2pEU00rMDVSanNZYmlSTUpzTlFtZXpQRzlxaUhx?=
 =?utf-8?B?MjNGUlpwUnc2clA4eEY3WlU4WmpJZzdpZ1h3RThJMUNBUmUza3RMVmR5R2VJ?=
 =?utf-8?B?dG1wMkdocVR2M3VxWFV5c0RhbnFRTnpINXE5aDdDSXlZUUdMTHVPcldLRUtK?=
 =?utf-8?B?Wi9Pdk5pdXl0U21TRG9ZdFlrdDBRc1NXWW5RODhRU1dFVElCc0lWWUprVmdv?=
 =?utf-8?B?ZHBlcENBU05NbVhjQ0IraS9hTVBhaGlZOWR4ZFBuamJTcGQ4d0JVaElyWXVE?=
 =?utf-8?B?Qy9MejJOR0VUK1pyU0Z6ODNydXFDWWduNlZEajZ1MlVBaFNjQjhPWm5sZ1dK?=
 =?utf-8?B?YnhGRk5MY1BUWTFIMkdHQWtpdW4zN0RwN1Nrd1o4bTVzTG9WbUIzYnBMSGtx?=
 =?utf-8?B?Yi9MQ1U2TVZWNFhiL1dsMWdsMHBqdVBubVNGQVpkVkJsOGZqRVFJWjVGUFND?=
 =?utf-8?B?T1JyNTgrQTZjL3pEeUVrWmJiWlFwRXNaM1QzRzdPczhGUG4yelJid0UyYXBQ?=
 =?utf-8?B?M3NvOWpVcFJJZ3hDaGtNQk90RjFvUVhBN3BnL0hzREcyK0l6UCsyaytFdEU1?=
 =?utf-8?B?bW5Wc2NRc1dxdUpaa3YvVHc5M0V5SDVzcjlmNDZUNVVWV3NocE95L2paa0dq?=
 =?utf-8?B?REgybWVOc1RoQVZGYldoZG1Jc2EwakhWd1UyVWpIWSt4ZFZOZEtlMy9DZGpO?=
 =?utf-8?B?cVBMOHQ3UURGMmVYTTlvb1AxdG02Y2c5UXhFeGVsNTIrNVo2bzY5MWt6ZS9u?=
 =?utf-8?B?dDJuNU5MNFk2OTlFOFg1VlpjQ3ZrMmdrUENPTGtBL041RkxOclY5K1M4VWJz?=
 =?utf-8?B?QVhrUFpHanJVVTFXeWRQb090TGN6OXJkM1ZnclY3MEdRNTBuS3BhTkFuQ3FR?=
 =?utf-8?B?RndLajVVL3BTbjJSUVkySzQ1TXBucVlFYlBSY1NIbExsZmg1R2hXcnZFUGUz?=
 =?utf-8?B?czZIcEM4Ky84UEdrQ1JRNTFNdWNYYVYwR2k3UDVLNUlNcUcrNzBPeis4RmtG?=
 =?utf-8?B?d1hzRWpwVVlpWDlaWkEvWnRCb3BNQm95Zjk0Vk5oVlJjM0V4bERQelhQc2tB?=
 =?utf-8?B?MzJuKzdGazFqR0FwaHdNYmJST1E5V2FLQTFVcWprUGJXbTBWS3AySm0xRTc2?=
 =?utf-8?B?NkhIYUhQaGhiS1EyNU9CK213YTdZZXRCK2k0M3ZmREhlNUNpY0tCRXZ2ZEdY?=
 =?utf-8?B?OXZLdlk0Z0N2Ty95akp4NkUwS252K2V3V3BUNnRIc3J6eU5vRGlMMzh5YXE3?=
 =?utf-8?B?VzVIbjh2TzN2czcxNjZlbmNiSU15UEFZTkhFS3ZscmpET3FYK1ZQUVdNRHBY?=
 =?utf-8?B?TG4wODlJNGVsQkg5Vk0xLytpWXladk8zdFErdjJkQ1lDV1dwWGNqbzlIM04z?=
 =?utf-8?B?cForTUt5OEtMZmswL0ZSWisvcERzS3RiQ1JWdlRBZzI5SkdQTGRmVXVnWk5p?=
 =?utf-8?B?YXNZdTkrRllDYXgvYUczVjQrU2c4OWxCZElUOGV5dTk4Q3B6S1UrNDdEOUxt?=
 =?utf-8?B?ZHdCMjhzdmxPdlpUYm9jZmloWnI5RmNRRUhnNFZBWWJuNWpEWDE5Z2ZLYWc1?=
 =?utf-8?B?WUJLRWtzazhjalVEQ2s2K3U5dDU4VDZ4dmtCOW43dERMMHhKb1ZOZkJRSk5X?=
 =?utf-8?B?TElHZVZ2bG9BcWpEVnFJNVArY3FlNytUbzZHY2M2bER4dFJTY2c3ZVZ2aU1j?=
 =?utf-8?B?TnZNTVF1d1dEeTBMNHl2L3FCZDB1V21kRHdaSFY0UHpscmRoNm1xNDJkUVUr?=
 =?utf-8?B?Z0RHNjZsQkpoNFlack9OekZlSk83d2JhczV1NytPbjUwdHRCQmlaY3VneHZa?=
 =?utf-8?B?YnAxcVBBVkNzSTZwWUNGSlJIdERCSWp2ekVxWmJOdkQ1MEtyZkNHbW5BOE9Z?=
 =?utf-8?B?REJUNTNaSGUrcXBxQTkxOE5sUWE0OEQxNTFrVWdQYVBjcll6d2JnVzdmdHl2?=
 =?utf-8?Q?AiCgtsJKsO9zZfPnQuaF0aKbA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7965069b-7acc-489e-aa18-08da5e6989e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 09:34:20.4075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hERFOJ37ZBDJFx1I4+IN2ihJ35LrIHfTFpTUmeUuFk3opX3hGTM5+no8tQGJ4IC2PsEjjVzO3nuV81IvlcG22A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7235
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbmNlIHRoZSBob3N0IGZhaWxzIHRvIGxpbmsgc3RhcnR1cCAzIHRpbWVzLCBhbGwgaG9zdCBy
ZWdpc3RlcnMgYXJlIHJlc2V0IHZhbHVlDQo+IGV4Y2VwdCB1ZnNoY2RfaGJhX2VuYWJsZSBhZnRl
ciBsaW5rc3RhcnR1cCBmYWlsdXJlLg0KPiANCj4gVGhlIHVmcyBob3N0IGNvbnRyb2xsZXIgaXMg
ZGlzYWJsZWQgYW5kIGVuYWJsZWQgaW4gdGhlIHVmc2hjZF9oYmFfZW5hYmxlKCkuDQo+IFRoYXQn
cyB3aHkgd2UgbmVlZCB0byBza2lwIGxhc3QgaGNpIHJlc2V0IHRvIGdldCB2YWxpZCBob3N0IHJl
Z2lzdGVyIHZhbHVlcy4NCj4gDQo+IGUuZy4NCj4gWyAgICAxLjg5ODAyNl0gWzI6ICBrd29ya2Vy
L3UxNjoyOiAgMjExXSB1ZnM6IGxpbmsgc3RhcnR1cCBmYWlsZWQgMQ0KPiBbICAgIDEuODk4MTMz
XSBbMjogIGt3b3JrZXIvdTE2OjI6ICAyMTFdIGhvc3RfcmVnczogMDAwMDAwMDA6IDEzODNmZjFm
IDAwMDAwMDAwDQo+IDAwMDAwMzAwIDAwMDAwMDAwDQo+IFsgICAgMS44OTgxNDFdIFsyOiAga3dv
cmtlci91MTY6MjogIDIxMV0gaG9zdF9yZWdzOiAwMDAwMDAxMDogMDAwMDAxMDYNCj4gMDAwMDAx
Y2UgMDAwMDAwMDAgMDAwMDAwMDANCj4gWyAgICAxLjg5ODE0OF0gWzI6ICBrd29ya2VyL3UxNjoy
OiAgMjExXSBob3N0X3JlZ3M6IDAwMDAwMDIwOiAwMDAwMDAwMA0KPiAwMDAwMDQ3MCAwMDAwMDAw
MCAwMDAwMDAwMA0KPiBbICAgIDEuODk4MTU1XSBbMjogIGt3b3JrZXIvdTE2OjI6ICAyMTFdIGhv
c3RfcmVnczogMDAwMDAwMzA6IDAwMDAwMDA4DQo+IDAwMDAwMDAzIDAwMDAwMDAwIDAwMDAwMDAw
DQo+IFsgICAgMS44OTgxNjNdIFsyOiAga3dvcmtlci91MTY6MjogIDIxMV0gaG9zdF9yZWdzOiAw
MDAwMDA0MDogMDAwMDAwMDANCj4gMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDANCj4gWyAgICAx
Ljg5ODE3MV0gWzI6ICBrd29ya2VyL3UxNjoyOiAgMjExXSBob3N0X3JlZ3M6IDAwMDAwMDUwOiAw
MDAwMDAwMA0KPiAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMA0KPiBbICAgIDEuODk4MTc3XSBb
MjogIGt3b3JrZXIvdTE2OjI6ICAyMTFdIGhvc3RfcmVnczogMDAwMDAwNjA6IDAwMDAwMDAwDQo+
IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwDQo+IFsgICAgMS44OTgxODZdIFsyOiAga3dvcmtl
ci91MTY6MjogIDIxMV0gaG9zdF9yZWdzOiAwMDAwMDA3MDogMDAwMDAwMDANCj4gMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDANCj4gWyAgICAxLjg5ODE5NF0gWzI6ICBrd29ya2VyL3UxNjoyOiAg
MjExXSBob3N0X3JlZ3M6IDAwMDAwMDgwOiAwMDAwMDAwMA0KPiAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDAwMA0KPiBbICAgIDEuODk4MjAxXSBbMjogIGt3b3JrZXIvdTE2OjI6ICAyMTFdIGhvc3Rf
cmVnczogMDAwMDAwOTA6IDAwMDAwMDAwDQo+IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwDQo+
IEFsbCBob3N0IHJlZ2lzdGVycyhzdGFuZGFyZCBzcGVjaWFsIGZ1bmN0aW9uIHJlZ2lzdGVyKSBh
cmUgcmVzZXQgdmFsdWUgZXhjZXB0DQo+IHVmc2hjZF9oYmFfZW5hYmxlIGFmdGVyIGxpbmtzdGFy
dHVwIGZhaWx1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKdW53b28gTGVlIDxqdW53b284MC5s
ZWVAc2Ftc3VuZy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNldW5naHVpIExlZSA8c2gwNDMubGVl
QHNhbXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMu
Y29tPg0KDQo+IA0KPiAtLS0NCj4gdjEtPnYyOg0KPiAqIG1vZGlmeSB0aGUgY29tbWl0IGxvZyBh
bmQgYWRkIHByb2JsZW1hdGljIGxvZw0KPiAtLS0NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3Jl
L3Vmc2hjZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgaW5kZXgNCj4gN2MxZDdiYjljNTc5Li4yY2RjMTQ2
NzU0NDMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNDc1Myw3ICs0NzUzLDcgQEAgc3RhdGlj
IGludCB1ZnNoY2RfbGlua19zdGFydHVwKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICAgICAgICAg
ICAgICAgICAgKiBidXQgd2UgY2FuJ3QgYmUgc3VyZSBpZiB0aGUgbGluayBpcyB1cCB1bnRpbCBs
aW5rIHN0YXJ0dXANCj4gICAgICAgICAgICAgICAgICAqIHN1Y2NlZWRzLiBTbyByZXNldCB0aGUg
bG9jYWwgVW5pLVBybyBhbmQgdHJ5IGFnYWluLg0KPiAgICAgICAgICAgICAgICAgICovDQo+IC0g
ICAgICAgICAgICAgICBpZiAocmV0ICYmIHVmc2hjZF9oYmFfZW5hYmxlKGhiYSkpIHsNCj4gKyAg
ICAgICAgICAgICAgIGlmIChyZXQgJiYgcmV0cmllcyAmJiB1ZnNoY2RfaGJhX2VuYWJsZShoYmEp
KSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHVmc2hjZF91cGRhdGVfZXZ0X2hpc3QoaGJh
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFVGU19F
VlRfTElOS19TVEFSVFVQX0ZBSUwsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKHUzMilyZXQpOw0KPiAtLQ0KPiAyLjI5LjANCg0K
