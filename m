Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F913C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E093B613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhDTO0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:26:08 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45021 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhDTO0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 10:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618928736; x=1650464736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SmejVUyYEuiMR+tHjtcbZluXxes34b+2R1l8mVbgk2Y=;
  b=NCEBW1ys5aHq65LH53MmXygfCSzMfZAX/G1mJL3UX2JMPxpoSl/jRFV0
   +zMZ73rbqATi5weOUxtJ4gFIkQa9kUHo5dYqM7w99W8+XOGNct+dXuWgw
   4Uo8obYtPDb1A87IN+vLPX7hclp2lyh4Yff61e8O7MMIlbey4mQFrj2wI
   cM3mE3VnqXxiaxsLkVwAbYNR/u5qVLQ83Kvk2H1y0rZiqTercuAekUcGG
   eUnZuUqpWU37i61Q84wgFllgI+qSom3eXLlWwUGkQ9SkXJWM4LQg5OIX9
   WsO4lMiSAMvVJa/WR1OTUYc3J9TRT+DvlVjx0DsvlZfEJ8f4njWyN4Lth
   g==;
IronPort-SDR: ct42CQGmBtw+q6jx/HGVEtw/n1EdJSCQ71LyHIkz77OuemdOUI0N4tNKxibqFNks+z7Gsx3i/s
 RvEUe1XDoIRu2nn7PWAiaLSNZRTtsrXJk0kmB5OHwKcfWT0aYFCHDQT48UGJ7U8aIQp4OOG1eX
 VAxscSBKZ8BJF6Cllc9v1AbzP/9HqXnG0K0UNZRZ9QRJ9xZoKSQd80e88AREXxo9k/CsFYjfH/
 kzN4uIlewtthDP8UFC+moCF+0WHWCHsWGGdZWXgH4yoLkAzDnb5PK0OXT6IjywyDPdrUQNXs1+
 SLo=
X-IronPort-AV: E=Sophos;i="5.82,237,1613404800"; 
   d="scan'208";a="170085210"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2021 22:25:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfdfUDgPUVkAyT1fKeLsOvztjBwN9Qgzh8yWwzkEDRUaVuvNmv64gp/uI15Vyla/1LMCfqDaZy1gTzpumlrrNEQVLPWopXfVAB6kmAir9osiPU9LTEH6XUZWQiDbMuSIt9Q7wiG9DsUjoD7nf8WmkwtsThvBJ+Rq9cPHoDcO+zQk4EY3akVotF2kZkFe0w842SBwlhGSFlp6oCmXXHMlbWZA3TAVCpW3EKxwt+4AK6GppCxkoyNGohLKB0qNNBiBmYsz4I0QnTx0WItBertttSEIwHhhnzepFKu8kO2atPzYBXL7TXz+VPYFgxMqKVIdb1rrnFsmb3n/aP1KeohulA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmejVUyYEuiMR+tHjtcbZluXxes34b+2R1l8mVbgk2Y=;
 b=O7YV5y+XHOvgLu5Nv9/n7RKZYqaHIrJqJ4bZrKdxG4mtJ4jGNJJpg4oM1wy4uN4KsPPhWmdxrcfBJTRXgvKTHjqUH3jxqXDA677fls8Bonlm7HpxVx/dkwDQFVlHCYZKYJjV1+Trwt56gKPM6LARnpbbVS+0BKFmgw1KCfX9o5pUeUcKweGg5Ol/7F3cyTDVlvXpWfNUdLfbnEGDlgdgHWGK98uil3UtngQvHj5mToGpTeZgowv7fiD6yWPbf8A3UvATPyzyAOjC0SmnewrzdPVOFh/d3yw6bX+spgzpzNb9jMeEULuqHYV1AKjVQrPe2sjZ8hLf0DrcvCk0xbHDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmejVUyYEuiMR+tHjtcbZluXxes34b+2R1l8mVbgk2Y=;
 b=TSr8Qkl4p8cb8SO8l3IVVyngxeZOUPd8Gxz3eYmo1a14xFHAe5d/05ewaiZkCrwu7xYFlQ1i8uwM5dAEG6DICndr157S2LN3l2IY7PmBCzz7Px64sChMZjWPgCy+T6GVJCE6l1a7aN1DPuaJhiQYpJVf2uW9XLN6eB2TIRQIKOs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0540.namprd04.prod.outlook.com (2603:10b6:3:a0::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.18; Tue, 20 Apr 2021 14:25:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 14:25:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Subject: RE: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXJcvTbopFT3JB9EekzkyulUARjqq7iaDwgAIJjKA=
Date:   Tue, 20 Apr 2021 14:25:34 +0000
Message-ID: <DM6PR04MB65750818CDEDD4E8B42091E7FC489@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p4>
 <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
 <DM6PR04MB65759A0DFBA1BCFAE97FB134FC499@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB65759A0DFBA1BCFAE97FB134FC499@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de67ed88-3844-4628-7698-08d90408291a
x-ms-traffictypediagnostic: DM5PR04MB0540:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB05406E8A4EB1497656D877ADFC489@DM5PR04MB0540.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1PMq57kNy8C3Fadr+7Acj6VSDWOEksn6t34dQi0U/k1oR66k5O7m60+Ef+leCWrGdl4ZrK93LcOsLECwP7yQt1eIqRPQHs1BYLap91iSt6cmd3y/u0BtYSkhQTEhf1kKTHKPtsdZoVlc5Gb3QWf1VLYeeVvX7YAAjYX77Y90SvfLy1zZCt0iAbhCxb4XIgU11WKVq4YVUPQKsr4HCo2cYw7azPL2zkR/oPn6SZwJpzHKZivyz4jzD/yY+TVBti3KV9091lgQznwfXuUJPsdNzvX4bc0mb4f/kjwxNas6/5pGhNP8UVNlxg4lG8GUB/EJobyQnwxZze0QYUFEjyY1x/KMPtw+WK3pcRyvxbPHp8oxTLfGzjrjejkT2labRbzxi1NVtpUje/JAcoU7WqGeHwRMpFQP1vW7JxC/eeGdsaCC3h/8GEfuQezw49GTk6WvYcgyTgWNlvapR9qtbf+2nrG74DPqbe4NyNKg0ug7ouzM9q0PfKJikNsOoIAk71KVAsVRWD6jPfIbwdxknSLKDdElAyG1ui9MUc3TqdQL9SM60XY5UbbN6z/hMcdDcBQDgaszm0l5YRmW4vZyUJDrMayZOlvADKMLPk2VA184rZYwR2vvAsNGtbINTxxcYiWopV93/gb6rEFUmHtQC3py4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(71200400001)(52536014)(9686003)(8676002)(8936002)(55016002)(66556008)(921005)(64756008)(7416002)(76116006)(110136005)(5660300002)(66476007)(4326008)(122000001)(66946007)(38100700002)(66446008)(2906002)(6506007)(33656002)(186003)(316002)(86362001)(478600001)(26005)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NmJwTkc0ODcyUlV2TGZ4Y09uaGtPUlBsTlN2QmdmVGFVQXNzS2NZTElTRlE2?=
 =?utf-8?B?R2lnYkM2aUtock41MmUranZmdnk5Z2kzSnE3OFJXdUdielBycDRCNSszb0NK?=
 =?utf-8?B?V0Y0azR4UUFsZmtRNEEwQllQY0dPa2xvRS9JRnlnM3BzTFRLOU5UVnVQRytw?=
 =?utf-8?B?bmE1c1dpa2EzNFJqRDJrdWh2Y0VCaURlbzNaYkgzRzlUMmZFeEdHd3VaU2w4?=
 =?utf-8?B?VEdaRE5tRjFNQkpqZ2FMQmppZkdJU3ZLWmlEZmhTMlg1NmRLRmxHb21wZWRK?=
 =?utf-8?B?R0IyNHRnakc3UGZWMmxZd3BMMCtXMWpMVVY3NnovOVpHK0hiY1JhMC95aVVT?=
 =?utf-8?B?RHpNei9XMEt4RklDNUJ6L3NrcnBobTYwN1o0bWk0U29kVGxIWlRtbGhBQUFw?=
 =?utf-8?B?bTg2OHg4MFIwYVZweDJOS29SUE9PazNEc2VUUmZBMkRRRFFLSC95dWIzOENI?=
 =?utf-8?B?TXh3Ny9QVGd6RXVLV0xEYXhRcjMzanlJSzIvYmhmOUYzd2l5QWVtc2tJZndK?=
 =?utf-8?B?TTRJblVJamZPS3B2NTA5S25wR24zSXNkS29nRTBmdzBrU3d4UXpMcE1KUlJN?=
 =?utf-8?B?QllVbjNrWG1Db2RpWWRmV3JsZnJiUHZtaUR3Zng3ejFWcndKRm9qVGFOazNk?=
 =?utf-8?B?NGgvaDJpTTI2bW9TMThYK1ZVYTZvVkFibWljRU1LcGRBbUdOdmRyY3dRWjVC?=
 =?utf-8?B?WXk0L21YMkQ2TDVMcEZSYkg5TXJack9PaEgrbzgxMHdJeDZmR08yZUpUZk8w?=
 =?utf-8?B?YktOUUo1QkcxZGhYK2lYSG1LQ2JmUXdTbWRRTlpWek0ySWtkbWRPVWF2ZFVE?=
 =?utf-8?B?MHhSdFEvK2ZNVGE4YnU0YTZxa3pYR2lhSFJKSkJSSWVJU1VGekg0UnlzeGN1?=
 =?utf-8?B?U2JzeVpYR3lMY2VJTloyTGVpK1pBNWd4cjlpaDIyeWdHemJGWmZRc01qdXN4?=
 =?utf-8?B?ZHNnT3FNQnllNFp3eDNlbHFsTndoRWlPMWlhM09wTnhBRzFoYkxhZ29IRDAx?=
 =?utf-8?B?d3YxVW1JM0RPTzBNa3ljRkU1ZnpqUFI0Z1pnbjQvZ3JQbnlNSG03RVhNZk5s?=
 =?utf-8?B?REthYVZ6L3Voc1JhbVhTdU85dkptem16R1V4QVVMVUg4OVpiR3k4QndLZnBK?=
 =?utf-8?B?L2MzdlhKTVk4SzhsVUZiaUpzb1dRZWdjdnhmOFZBeDNxelJPOVJIUHlEWVZF?=
 =?utf-8?B?Nnl6RTZZUUN3NVVIQ2lkSW1rZHloSjBwQ1FGUnNzQ3k3R0dDd0oyQU5qWml0?=
 =?utf-8?B?clRTTVFQZWszSm5Fc1Yzb2ZVV09CbzE5azZpckRCKzFsclVvTTB5WEhjQWFD?=
 =?utf-8?B?OFBPYzFQZHVwRGNzMVY5L2RISmlaVlk0U2ZJRHRGZVJMOEJxSW5QbUI3VGw2?=
 =?utf-8?B?S3pNQkxSRkRqUXh2eHI5bXBwQzVKODVxWlQrdkhoTjR3ZnhWbGxvU2xKM01D?=
 =?utf-8?B?WXo5clA5UEdZNGJ5ZzY1b3EwVUhtTUxaZi9PN0FNTUR4YW1YVWhnNmVVVW55?=
 =?utf-8?B?YVdoZU04VXJBT2t5d1dSR0hwVjJOMGkrQk54SWV1d25HQ0F4aDBKZWNGR2Jl?=
 =?utf-8?B?QVNHaHFhY3Zhd3R2dzBCNVZKZnV5Y3NHYTFCMWpqTzlzSm51YzFNU2FBdDdq?=
 =?utf-8?B?aG9pZ2k3UElZNjB3YVpqWmFUYVdjNUtaSnp5dGJ5b3VzTEpMcGhKdmFQdjVs?=
 =?utf-8?B?SzNNSTFpMklsUUdKWWRIQXVjc2RUaEFBaEo0TytlRG01dVd5b1NycTFIVjVx?=
 =?utf-8?Q?mlVTnk3DBvTvWZGGkGJb0AzdZy/QsOycTTk4iZu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de67ed88-3844-4628-7698-08d90408291a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 14:25:34.3723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afaaZRQTuC1ffun3SqBxbtddIFqua2CjHvfW4X4iNk3JHdLBiU5CfJ50zIVNWvoET5vebrVqaBFDrFLBzRm6Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0540
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSwNCj4gPiAgICAgICAgIGlmIChkZXZfaW5mby0+d3NwZWN2ZXJzaW9uID49IFVGU19ERVZf
SFBCX1NVUFBPUlRfVkVSU0lPTiAmJg0KPiA+ICAgICAgICAgICAgIChiX3Vmc19mZWF0dXJlX3N1
cCAmIFVGU19ERVZfSFBCX1NVUFBPUlQpKSB7DQo+ID4gLSAgICAgICAgICAgICAgIGRldl9pbmZv
LT5ocGJfZW5hYmxlZCA9IHRydWU7DQo+ID4gKyAgICAgICAgICAgICAgIGJvb2wgaHBiX2VuID0g
ZmFsc2U7DQo+ID4gKw0KPiA+ICAgICAgICAgICAgICAgICB1ZnNocGJfZ2V0X2Rldl9pbmZvKGhi
YSwgZGVzY19idWYpOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCF1ZnNocGJfaXNf
bGVnYWN5KGhiYSkpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX3F1
ZXJ5X2ZsYWdfcmV0cnkoaGJhLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVS
WV9GTEFHX0lETl9IUEJfRU4sIDAsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJmhwYl9lbik7DQo+ID4gKw0KPiA+ICsgICAgICAgICAg
ICAgICBpZiAodWZzaHBiX2lzX2xlZ2FjeShoYmEpIHx8ICghZXJyICYmIGhwYl9lbikpDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2luZm8tPmhwYl9lbmFibGVkID0gdHJ1ZTsNCj4g
PiAgICAgICAgIH0NCj4gSSB0aGluayB0aGVyZSBpcyBhIGNvbmZ1c2lvbiBjb25jZXJuaW5nIGZI
UEJFbiBmbGFnLg0KPiBUaGUgc3BlYyBzYXk6ICJJZiBob3N0IHdhbnRzIHRvIGVuYWJsZSBIUEIs
IGhvc3Qgc2V0IHRoZSBmSFBCRW4gZmxhZyBhcyDigJgx4oCZLiINCj4gQW5kIGl0cyBkZWZhdWx0
IHZhbHVlIGlzICcwJy4NCj4gU28gdXBvbiBzdWNjZXNzZnVsIGluaXQsIHdlIHNob3VsZCBzZXQg
dGhpcyBmbGFnIGFuZCBub3QgcmVhZCBpdC4NCkFmdGVyIHNvbWUgZnVydGhlciB0aGlua2luZywg
SSB3aXNoIHRvIHdpdGhkcmF3IGZyb20gbXkgY29tbWVudCBhYm92ZS4NClRoZSBzcGVjIGRvZXNu
J3QgcmVhbGx5IHNheSBob3cgdGhpcyBmbGFnIHNob3VsZCBiZSB1c2VkLCBidXQgcHJvdmlkZXMg
dGhlICJzeXN0ZW0iDQpXaXRoIGEgbWVhbiB0byBkaXNhYmxlIGhwYi4NCg0KU28gSSB0ZW5kIHRv
IGFncmVlIHdpdGggeW91ciBpbnRlcnByZXRhdGlvbiwgdGhhdCB0aGlzIGZsYWcgc2hvdWxkIGJl
IGNvbmZpZ3VyZWQgYnkgdGhlIE9FTXMsDQpBbG9uZyB3aXRoIGFsbCBvdGhlciBocGIgY29uZmln
dXJhYmxlcywgc2hvdWxkIHRoZXkgY2hvb3NlIHRvIGVuYWJsZSBpdC4NCg0KQXMgaXQgaXMgb2Yg
YSBwZXJzaXN0ZW50IG5hdHVyZSwgd2UgbWlnaHQgZXZlbiBjb25zaWRlciBpbiB0aGUgZnV0dXJl
LA0KdG8gYWRkIHNvbWUgbG9naWMgdGhhdCB3aWxsIGFsbG93IHRvIHVzZSB0aGlzIGZsYWcgdG8g
ZGlzYWJsZSBocGIuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gSSB3b3VsZG4ndCBydXNoIHRv
IGZpeCBpdCBob3dldmVyLCBiZWZvcmUgd2Ugc2VlIHdoYXQgTWFydGluL0dyZWcgYXJlIHBsYW5u
aW5nDQo+IGZvciB0aGlzIGZlYXR1cmUuDQo+IFRoYW5rcywNCj4gQXZyaQ0K
