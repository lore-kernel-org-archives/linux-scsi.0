Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFD8C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 12:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC6861184
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 12:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbhETMeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 08:34:04 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13349 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhETMdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 08:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621513950; x=1653049950;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dpxiJC1WoREfu1JzogG6CZADldniRXIK8BWBwV4/DGY=;
  b=qek5VO0JpStYou1Ltzr0m3P1YY10LriwYDZKT5PmDpFVGGJ2/jhYIk4h
   90HgnTGBWmsKUZgRvc7Ca7SswceKyBMmURx7Act0qC62szv79izO3OnNU
   aTXtchDQtUJRXelGpGivdOVBhHjU3iVcRO9wreheUD3nEoOgsb+5pxlBT
   6ZMMBdqqqDZYWSk4m5YPdY2WShlyC4y2KOnEflcyhnA5mLg8u/mHcHEI4
   G8FVGfzTWhi4zdteGAC1d9flnYIiurEfMNFXwWerseXW4Ct9nQGeq4s7W
   +sV9Zr7Ps9iNIewIGWP/TPJQGn3cX2Hbd2cVBDv1GJd6lCibu4LRnHy1Z
   Q==;
IronPort-SDR: TcQtb0G1bg/QbBCN8nvhvlZ1jnk3QzMTXUoKhQQw6pYrFVNgwlEIUjLbzHDUBK5bwjM1sJo0x6
 BteMiACDuXWVtvpVrTdW/T1p/vAfjlEnkj3VaoSPzabFB+Z9TkN7jqUnNKnIGSknpt+VEwxj1d
 MIlWBxLKCGoA64QOLhVnTLfTr4NEELgQiU/tJxpQGBhSN1rK2gKqm3Ncc2k81tKtesJe8hwjvH
 6h3gjc0zqIw2G4dJLYRxdSfcRGeQOpsRREmxPojjBkXNx03GseD+If38BzMpRtukLu8g241yih
 wyM=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; 
   d="scan'208";a="173477177"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 20:32:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiu9+feMNvU9A11w0z6pV0ZaLH7bLvquWdOeC7zfMv2+R3OiHnJYkokuP7TXFmBDvZzA26Dy0gwC1LvMzUI4fPeA0ZkT+OW+5+rQe8WidZ77S442TjgBWCytRZrvHzjSKqTxui+dh7ULDyjlToWuuNCxcWqw01istEA9zPwY8q5ZcHTe1f5eQKJT6yTkU4YBuPX2x4rvqpZEXKrc9JHWSPl78ex7jnDAzIKxCO/MBlDzWVOx7UK1ZCTwzUuhiH/l15KmJrgOLsoZgueneYb9xEFCrJ67yqoBCvTVAjNWOtT422QwFa0dKqkND9hIc+P5Sv4eUhMt+qwMYpndaKa/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpxiJC1WoREfu1JzogG6CZADldniRXIK8BWBwV4/DGY=;
 b=VQDCpF4O+ExXjI9AASJlDEmXhWyAVrUzeblSaTUp0P8sWrfaV7rEH8jvcxhtSMDroUKoeciTGTCQqSUkipzFl30GtefCPovYDt8BKso3cxybEwN1rzJFDPa4cyKliDxHvY4yi9nu5+0gc4rZkCuvqXcsd+s0pQvT4faphOv2fZKU20wnlzlFtR4KQVxfDm0iFPjeQjX79OezSEMofPAxzpR0DxgNeQcaWUeFYzDhIi8+ssdyXdUtAv1g1NypB44JHPUz0sJaWpLC+CdKfCsyFH9hn77EToQebmXe17IQ2L4EVvKy0WcxrXXY93o4aaDSAF4ChjhblQBrl9zQgTqX/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpxiJC1WoREfu1JzogG6CZADldniRXIK8BWBwV4/DGY=;
 b=QyS+Xs8svCIiEB0Aplnpbjw0QBeJsgqx/18kz8ySn5M2LQh/HgNkhc/Jw8DI2ghv/ylv/i2SQI3vmrrmNSD0mFHu4fOPWAZ0qdlTYSLBJ125u+ES5ynA+vr/Ggq9ENLupG0aFrZTkwX4k3x59ye471khJER3gk5aPLeqnnu/tUo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4492.namprd04.prod.outlook.com (2603:10b6:5:29::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Thu, 20 May 2021 12:32:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 12:32:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v34 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v34 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXPIXQVicRHIooM0utmYnqKiZsvarsbXQA
Date:   Thu, 20 May 2021 12:32:28 +0000
Message-ID: <DM6PR04MB65755AE3D9217FA3C0C3455AFC2A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
        <CGME20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p4>
 <20210428232534epcms2p4830e22a86cc78c3319075059fa223540@epcms2p4>
In-Reply-To: <20210428232534epcms2p4830e22a86cc78c3319075059fa223540@epcms2p4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc6d6eb5-18b6-4b02-e394-08d91b8b54b9
x-ms-traffictypediagnostic: DM6PR04MB4492:
x-microsoft-antispam-prvs: <DM6PR04MB4492E333CB8C1022BEEB2421FC2A9@DM6PR04MB4492.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eMwGLt+SFkV8cSUnyYrnJCgmDANvpsXNGasFn/SjkNJhHavKHAUwlVMMns8lBC+WUACLxpdLYhU8V5We6U0M8cSlW0e4XaCWOsVRatE4xZ8UAyX3wVhPIOV2YtftRn1amjejkJ3Mg03+GzPPGzXfyJMgKrKUwJbzn7q/GtnjX6HDXAn6HWAh32do5+Gelua1QaZiNkUAD15x4nU5gUA8AZtNAZkYhFD0hjHf9CBmQ+pdEeXHo76Gh1MqA8DU2iD6OqpK4iv5LwPuBsftxfJF8k8/NkhKPbYOpQEzFBMmqj3fr583XJeqp/omQnM8/n8lq98fO9giwOAdDvetVUMdNb03j+JcsLcrqHK+sArBTFYwUUa+N5z/nk1Tboh5DWwphslnj/g39BDDNeMt4aYQfNN2rhoFW3SKRDxNrR0Aq6yYgN7qFBRKmqbzCifWDU4y2gKd9fFvwihZF/eacBXAQbH9jhgc5X5w+l136Yu1fGde66oy90p0LWk2A45qU17c/2WQJhIcdacKdkuzM/mop0MxFAOXHDXmvnRio97j7KJ2C+g6fqg6K026Mysx2vw7JAvdipagowdvonTh37SflNaUYcnRf1/oVGhpzmI0dL95hlYljIQZxmmu9TaS1+cOoeBWTRZEfF9Im4Y4OuCxMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(8936002)(86362001)(66446008)(66476007)(66556008)(64756008)(66946007)(478600001)(6506007)(9686003)(26005)(76116006)(7696005)(4744005)(55016002)(71200400001)(316002)(186003)(122000001)(52536014)(110136005)(8676002)(38100700002)(2906002)(921005)(7416002)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V0x0alhHS1pUVmNDdnNBMUxzZ1F2WmpPZVNkOEUySDdTVE9xZnpDTFovTmln?=
 =?utf-8?B?d0NySlZwd2RMTVREOGh3TlBjeGg4UDZIa05HUWI4SmhlY2pYZ1pVZjNVcDhJ?=
 =?utf-8?B?V1VVNEtab080eVJlSXhCZjU0d0NvNENaRFprUHpLcXlvL05EN1M4ZjZvU3NB?=
 =?utf-8?B?L1VDSnVmbEN2RkJyUWFINW5GYTRqNXQxVHQyTXE1c2psQXVUVnd5S2o0Q3Bm?=
 =?utf-8?B?K2d5aVN0aDRPYlBkaWlPNEl2alpONjc2Z2N1ejFweUI1MURnQStZZXlMcTJZ?=
 =?utf-8?B?K2lIa095U3hXbVZwYnJpUFBQMC8vRlNHWmM1dlhJOGhJaUMrTUNRQVM0V1hB?=
 =?utf-8?B?U1EweC85c3JoOTBlUUlMR0RoZlhqZElNY1NEbVdIMmRXbldUd1B2bHhHUTVP?=
 =?utf-8?B?dGR2emRGQjlZWVBScERCV2NHdEhFR2ZTTW1UbkhtRTBpTjIyUTFHN05vK216?=
 =?utf-8?B?emVIQ0ZZUUNXWmRtYXlVUVdXV2tnT1hJdE1PL1Y0c2FSU0lrYThYNmlyNStF?=
 =?utf-8?B?Q0dwU0p5UHhLUkl1YTc4M1pNS1F2dUF0VXNJN1ZPSmxPelI4Z1dGNXB2SGZ4?=
 =?utf-8?B?U0hXQ05HQ0xPRjFsa2NSblNPMDIydWlsQ1I4dnFaKy9yc1B4enFkLzJZcUVK?=
 =?utf-8?B?TVdNWlhBa0FlbWt6bkgySXIwbWFITXUyYm13WW5qd3BkQlUxdUMxMEkxWldx?=
 =?utf-8?B?Qk9ZcjNwdWd0U3NDaGR0OVVjTDRlSFFTeGFhMnZVM2ZQYnVCenhZdlRwMFQz?=
 =?utf-8?B?UHJIeEpJYVQ3NURsRFB3WDM0UllESzlIUndWWUNselZEVUxSM0tQQWpJNjF1?=
 =?utf-8?B?S3dDQVo2U2xCNVMyUkZCN0NBWkRWNWo1eERQc1p2clVCZ1ZuZjFvTEl5cGRT?=
 =?utf-8?B?MVhzZllGQmpkU2tlZ3RMeEl5Ty9KeVhvWXJ6QTlFcWFiMjlwd0IzRWxPSjNQ?=
 =?utf-8?B?dktkbi9ZaDRPYzRMUldjZHEyTVA0YlplMGo0ejZRYnA3L21BcUVUbzlZV3N6?=
 =?utf-8?B?dzhwWEZuMy9jZFNCcnVhbEFZaElBYTFVSDhFaVZYaHJoNys2d1ViOS9RdjJE?=
 =?utf-8?B?anlQUnBpVnRnM0FhWGFCTHNaSDVOaGhJN1FiVjA1UitneWFCWEE0RVZXMG04?=
 =?utf-8?B?SDEvaEU0UHBxQ2FmNU82bGNueWhrbUJIYUdFa3A5Sy9rVkJnM0hhcWNRaUhv?=
 =?utf-8?B?SlloTzZDOW5saTZKRE1JWlFxOUt1dmdpL3NDeTA2YWFIeW41R0tKY1poWFZS?=
 =?utf-8?B?cURZK2ZNOVlBVS81NnQrKy84OFIwTjZaNEJ3eEpYUWFLZll4NnNBaGFXc1B2?=
 =?utf-8?B?OE5Bb055MDYzelpZbDFFdVlFVzVyRHR1dUQ5VGc5RmgwUnVTY3VRNFFSYmIw?=
 =?utf-8?B?UDVkbjFTWjhNQnlpelp2a25TN1hwZC9qazZzNGZDR3BjaHpabU45Z09WTUN5?=
 =?utf-8?B?UHdackl1OHJ6Mko1cVVDZk5SMWErekR5WDR0OUV6T3A1T3F4VS8yRFNDZnlo?=
 =?utf-8?B?K0VFOWQxZkxhNDRiTzRBR0JTc3Bjemh0Yk9JQTBIZU5adUwrT2JyZFMrSm4z?=
 =?utf-8?B?ckhOeC9acnkwajRvN0hjcjh6U08yQ3F6cGM3V2FwandueU9oVC9wa0ZLdWo0?=
 =?utf-8?B?TnkvZW5LZmcrU1NmV1ZEYmViRGc0a2FDdDQxdnpRaXBvalE2SzBsdk5ScEtl?=
 =?utf-8?B?VnlOQytZNHF4ZUxGandmdTY1bnVSWUFZVUtLWXNocW0rcTk4VWtCeCtNKy82?=
 =?utf-8?Q?RVmGKhelKGa1I3y/PXPFE7EIy63VAlGv+BIZ9Zd?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6d6eb5-18b6-4b02-e394-08d91b8b54b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 12:32:28.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NslCn/U/dSI5zL4kmCFBbFP3oIgCiE9wAmwa4YbawB8CL3yIsgA5WG+5VV8yrcK21YiAraeLnFoCfhPaHEX+9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4492
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArICAgICAgIC8qIGZvciBwcmVfcmVxICovDQo+ICsgICAgICAgaHBiLT5wcmVfcmVxX21pbl90
cl9sZW4gPSBocGJfZGV2X2luZm8tPm1heF9ocGJfc2luZ2xlX2NtZCArIDE7DQo+ICsNCj4gKyAg
ICAgICBpZiAodWZzaHBiX2lzX2xlZ2FjeShoYmEpKQ0KPiArICAgICAgICAgICAgICAgaHBiLT5w
cmVfcmVxX21heF90cl9sZW4gPSBIUEJfTEVHQUNZX0NIVU5LX0hJR0g7DQo+ICsgICAgICAgZWxz
ZQ0KPiArICAgICAgICAgICAgICAgaHBiLT5wcmVfcmVxX21heF90cl9sZW4gPSBtYXgoSFBCX01V
TFRJX0NIVU5LX0hJR0gsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBocGItPnByZV9yZXFfbWluX3RyX2xlbik7DQpJIHRoaW5rIHRoaXMgc2hvdWxkIG9u
bHkgYmUNCmVsc2UNCiAgICAgICAgaHBiLT5wcmVfcmVxX21heF90cl9sZW4gPSBIUEJfTVVMVElf
Q0hVTktfSElHSDsNCg0Kd2hlcmUgSFBCX01VTFRJX0NIVU5LX0hJR0ggc2hvdWxkIGZpdCBpbnRv
IGEgc2luZ2xlIGJ5dGUsDQpyZWdhcmRsZXNzIG9mIGJNQVhfIERBVEFfU0laRV9GT1JfSFBCX1NJ
TkdMRV9DTUQsDQp3aGljaCBiZWluZyBhbiBhdHRyaWJ1dGUgKHUzMikgY2FuIGJlIHNpZ25pZmlj
YW50bHkgbGFyZ2VyLg0KDQpUaGFua3MsDQpBdnJpDQoNCg0K
