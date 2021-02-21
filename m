Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FDEC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 11:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3369D64E12
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 11:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBULzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Feb 2021 06:55:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19049 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhBULzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Feb 2021 06:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613908539; x=1645444539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1XYQc6KihsjsJ2MvkgMAMsGAh1jM3rSS9eA9diuT6qY=;
  b=DROdg+r9aUBNVUmyQHsvCFOkqnNZRbrZNmb4f2A5rjU854yXxrxeFQMA
   HB8+D5djHEbOTJnxXmaeJzGhe5ktlC0rAuUtDUGQr84FcwtCHnCDU9gzl
   zuNQaDJQ2CgLsWA3wYTNiDa6BsFPlgg3uS5XAN9J8SXpiNuw5L9377LSg
   0FFRWxg+SJCURMuu/DRVXDD7xWbMq9OQSD/G2ZVvwVOevTaWtDZaxoxbf
   e068XmutkM099XNEu3dNkR2lCVCrRfPWugLYx64N91INdtFLVy62weDmd
   JtrLmmB+HMe6K4xqGib6c74leqXg7sn8JsKzVnvs5yYzObCYY7/q6/lI2
   Q==;
IronPort-SDR: gldC9a5AmmKdzuBZLN/LVtL6461gdLkZOmPdOtTwy813Y4I+FXOXcoK5nAo69F5Ea60FG4pica
 dKPEx/xkdGCYk6M8URJhel8SxeyEw0ZuZ5j9aMgCrbCSTNzm9I/8egucx4r0kJfZDWUPomc3Gu
 f/U3IevHo7BsD2S5Y+aIloa3UJ7NLVhMH9OeVcRN+d5TviOVgHU2PB9IpeHTKjfyKY+X8tNTzb
 PHBXONfz7pbJ9MiOqx9hQorcfvrQi5DGZL1VDaiLgpt0QoDBEtG2sAyEnzrVjROZ07I/+JyNol
 2as=
X-IronPort-AV: E=Sophos;i="5.81,194,1610380800"; 
   d="scan'208";a="164921023"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 19:54:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpQGkzs1dZ7a+cNbHR/B2pFt845Zfjfmvs88aHcsOf+f9MQ8Y9RZlS8H3Rzqu25y3U4jMxMRBZ5cCl0Xw3qijVBxzESHJhSpTv6pQyLQn2uEh8rAAQSCBEGtE+c2dmEMf5JgfXNz9DySdkYLUpBFoOl4Ssw6b++Bf7g67mDi1FJEfuZuzCW7EKELE04yV36PG16gqsJ6d1b/ZJ4751+T+D9lwRhaRliQc6uqWCPQdEuaYeMAhui2fEYmXbfLdSlFihK1Oq8EE/1SRN5C7deRkwRvi6Nd2OSY1uVqmOPEyrNs/46/cbiR3zMKLT0gdWjPfa6LNXIqijqBV1J0hWdW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XYQc6KihsjsJ2MvkgMAMsGAh1jM3rSS9eA9diuT6qY=;
 b=FuKiCwdGooJ7yaSBWxmNaFii+49K3Jt76zl7N1SrZBHtV9C/mw0AQ6+nlB5PRapcmDZJ2CRN/5gRC3nhNVVJX1rQYroL5m+pVnlKA55snfP7+rjASPe6WRfAxsuFh3TxWZB+lLZMJ/T0c3apqn4u/86cKzIyFKorYBNKkKlbewV/4PWt2kp2M8qS51EwXs9fI4Im7M4TVMx9UZ1zf4WSKPgewz/nE9JZS3e9IOXhk0ofYIOO7xydAv0uGZhrTLLtEaL1SaAKTtcrVFm9UwzWA7oQR/DN/9vbOJ1K94pb1SxkRlVWn00ewXrlcbRNjBm6lq93+YIVQ3lG1CFG20PxOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XYQc6KihsjsJ2MvkgMAMsGAh1jM3rSS9eA9diuT6qY=;
 b=I72ZrQsZCI+7TqSHXj96EzSs5PERBjFkry5hd8s5s4xaCiXTFKNRwJmkyEey10FfofUmYKYke1+W108pIuGk/xP16s7n3TO81DoWmEshv5lU1PyIovUxpX/R4jrw7yzJeJlWJzCo60QUtEgCG+fSwrHUQC0IVzb6OTr6/9fxedY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.34; Sun, 21 Feb 2021 11:54:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.032; Sun, 21 Feb 2021
 11:54:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
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
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v21 2/4] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v21 2/4] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHXBdWOT8koNgvd7EKOQ+mE7NwdR6pig0bA
Date:   Sun, 21 Feb 2021 11:54:30 +0000
Message-ID: <DM6PR04MB6575F5244F17B022E6E78DC7FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p8>
 <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
In-Reply-To: <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c183adb0-2a79-4a71-9b69-08d8d65f72f3
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB4028F20F9308B55EF5FC0DB6FC829@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w1/oZgl4ncY8kEAA93sDB5NxyQbju9kEIFrckS2zti7bTNwLViqWYeXbXWHZ5KvDs3cB1tftDFLt5gDfW23R8meddRCceEqZ38gRzi8co4r6uwQggHPyDndWNzHicWrwTRm+VnDIgALTRkfZBY+uPEHfJh31IJI+ynNiBivHZtjAieKYlawOIxK2QfLc5knC87bTbDncZy5F4TaYBHBxsurLW2NlLqluhPL6VciduobXDDiNHPbCQ+B+CdrhSpIKQKMs9ncTuaWCDLhpDbHvCoKsws1pzS+NoaNWZ9iTeCxN22qweEzE6mtGFeHMarDL+OW1DgTlLgjNlcSC8ac9toFnUCwkVY7eO2LO8D0yQxHRgER6dHc01w+YqOqcMh9TrjOMrHTFI+a9yYxZB/xzoPL+ua3byRVdVPl7ucfPITyOhTTR2ozQcsDiIfGnIuxrQpVRS0Z1oCMqagg0CR6YzLDlkN+hJBfWx6/NL9yPmCVBRmuedWO4GbhdWdXfRfQd9gHTD5mKELfKE3JUlIJwv1tKu0IcBMO7sMCst15uZ9WVzpJ+rtFbdLf9sGDfy2rO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(110136005)(33656002)(54906003)(9686003)(86362001)(478600001)(5660300002)(316002)(66476007)(921005)(8936002)(55016002)(83380400001)(8676002)(52536014)(7696005)(66556008)(76116006)(66446008)(64756008)(6506007)(26005)(7416002)(186003)(71200400001)(4326008)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c1FWNFF3TTBjbHkxaW5aWVh3T0k0bU1Cdnd4c3NJM0xGSHVXSE5CVy8xSmpJ?=
 =?utf-8?B?UjZhdC9iNk1KTTlPM0pKNFplV2l1QXhyMGt1cG5qeE1IaVpWRHhzdmJEZUUx?=
 =?utf-8?B?Wk5qU25kN3BjUDNiSGYyZVhNYU5yU2hXRGxKRGNKSkdOd1haWFY5M3ErUG0w?=
 =?utf-8?B?eXBoMDB0Qitsb29JMDNGS2hRWFlhcE8yWXNmZDZ2dlVhR0I0SzMrc25NbFhM?=
 =?utf-8?B?RGloZnlXMzljSCtCdHNpV1lYMk00WmVRMVJtNzFMQW9QS2F2ZVpyemhxNXNL?=
 =?utf-8?B?UUd1QkNZSDFMWDZYajlkVUlRMEkyTGFRNXA3WUtxcmZLVzJIMFA4amQraEtC?=
 =?utf-8?B?a2lKSDF4UTlWNEk1RGdKcXhtbmR2aDAxNEtuekVtN3B4VmJqUXcyb2dNK1JG?=
 =?utf-8?B?eFZIK2NYM3RYMmpwMFpRcTR2SURiR3JQVXF5SUU4NDFUWFNLZ2o1ekZROTZT?=
 =?utf-8?B?dHdObWpmKzRybkFGdVhVeHFvYmFBR0d3RzVEd2tTYzg0STZXTDF2MjNNVis3?=
 =?utf-8?B?QzROQTQ3L05UckQrQ1dzdktJbDAzY0d5RzBuUTVNNE5VUXhFVHVFbUFURFlI?=
 =?utf-8?B?WHZhbFd2U3hRVmVGZjlScjhGTm1lSEovamlGQlZ4K3dZbnBBOXhLUVNtNjly?=
 =?utf-8?B?ZHZDZU9xajY3RTRvakxoVkVUcGhQaXZOaGhMdnJqR0RjQUZDTExQTDFEMExX?=
 =?utf-8?B?SEk5emRlT2hnWHV6OFJUZEJ5N2tHdmRleTd6TU5RaGlsdFdpKzFpRzVnamdo?=
 =?utf-8?B?dzVBcVNYem9XckJhcHpuSVZiS2JFeWRsa09QTnUwMktmYm5UOUxTbWRuUXhJ?=
 =?utf-8?B?ZXNZWkRUOXB3TlRNeVZFUm9Yay9WTXJrSVJaYjNJbE9UR29YSVUwUit1QWFQ?=
 =?utf-8?B?bEREV0ZsbkdnMjhFTTUrZkZtQ1J1UC8wWndkVy8rUDVkYzFPWFMrUVFhZzNu?=
 =?utf-8?B?TFZxMy8xRXVtaE9mQzFaUGNnSWtaMytROUl6UE9XMnEya1RTSU4xSTJUUnRO?=
 =?utf-8?B?aW4wbEpDT0E1TFJKMnZwTlBadWJZZUJIOFZITjU5Z0tsUXRYb3d0a2NYcmk4?=
 =?utf-8?B?cE9weUdVVDcxVEpCank2OEhMZUxMcjNPMjBZZ3VhYlhsdjhjZmRtd0JUY2hI?=
 =?utf-8?B?bWVKVEJXSlVadVkyY2NLNU1ab3U5MVZqenpYY3lxWWpmaGJXQkV3eGMzLzVJ?=
 =?utf-8?B?Y1Q3OHlOc0F0cml3ZHUyZW9hc0NBMWUwUXJycWxWdzc5dHRzYXJwNXAwcWdh?=
 =?utf-8?B?NHVIejBHOXJGZkdSVG11TG9qSGlvVVRLRHlOZ3JrQjRBNDlvRW52TExSb2Jn?=
 =?utf-8?B?NCtvRjMwOWVXa1B1WWZIVUt5bmd2Zi9qL2lYRndhTUpTR0N1blhkV2J5SnpS?=
 =?utf-8?B?dDdtTU83WGpYV1BVMkpvamNZdzJjZ1E0YUdCT2dOWmpkWEpaU0lacnlpaHR0?=
 =?utf-8?B?TE5KOCtHZXVHOFlSc3BDQXVGV0VIRjBKcnN4S2tyb3A1Tmg5VEJSMUtPMDZy?=
 =?utf-8?B?czNXSXJDeXV0MDAyMjlqWG1GRDhuUzA0VE1nQWFzdk9CZExKaWRtd3l4UEFD?=
 =?utf-8?B?b0VpdFo1QkRMUStLbEh0VGpGbEV3TVloTjlyc2dWUDF0NmVRWG9OK2lWNFdh?=
 =?utf-8?B?NnRKckd6THgwVENlSGM0UGNXRGUvaytzeE5ONGhsMDRmMnBIKzlxaDZmSVlB?=
 =?utf-8?B?dmJxcDlvMkgxVUk0SlJpSjFTdmVkdWFKZTJua2NTUitPOWFRTEM3cjFvdUhv?=
 =?utf-8?Q?XJqEO/qPd0hKRGVUHArOrHfjEm6t1HNfZjb8eXj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c183adb0-2a79-4a71-9b69-08d8d65f72f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2021 11:54:31.0366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzPaNXF5WPuKzNHFItzmuqgSvMpKiCYU3H3mSPvhK39y3D5O+ycN9Y8EOOSw3hOHv/OKiFCqj7qvmPd+wwTIQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgYm9vbCB1ZnNocGJfaXNfaHBiX3JzcF92YWxpZChzdHJ1Y3QgdWZzX2hiYSAq
aGJhLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB1
ZnNoY2RfbHJiICpscmJwLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHN0cnVjdCB1dHBfaHBiX3JzcCAqcnNwX2ZpZWxkKQ0KPiArew0KPiArICAgICAgIGlmIChi
ZTE2X3RvX2NwdShyc3BfZmllbGQtPnNlbnNlX2RhdGFfbGVuKSAhPSBERVZfU0VOU0VfU0VHX0xF
TiB8fA0KPiArICAgICAgICAgICByc3BfZmllbGQtPmRlc2NfdHlwZSAhPSBERVZfREVTX1RZUEUg
fHwNCj4gKyAgICAgICAgICAgcnNwX2ZpZWxkLT5hZGRpdGlvbmFsX2xlbiAhPSBERVZfQURESVRJ
T05BTF9MRU4gfHwNCj4gKyAgICAgICAgICAgcnNwX2ZpZWxkLT5hY3RpdmVfcmduX2NudCA+IE1B
WF9BQ1RJVkVfTlVNIHx8DQo+ICsgICAgICAgICAgIHJzcF9maWVsZC0+aW5hY3RpdmVfcmduX2Nu
dCA+IE1BWF9JTkFDVElWRV9OVU0gfHwNCj4gKyAgICAgICAgICAgKHJzcF9maWVsZC0+aHBiX29w
ID09IEhQQl9SU1BfUkVRX1JFR0lPTl9VUERBVEUgJiYNCj4gKyAgICAgICAgICAgICFyc3BfZmll
bGQtPmFjdGl2ZV9yZ25fY250ICYmICFyc3BfZmllbGQtPmluYWN0aXZlX3Jnbl9jbnQpKQ0KPiAr
ICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiArDQo+ICsgICAgICAgLyogd2UgY2Fubm90
IGFjY2VzcyBIUEIgZnJvbSBvdGhlciBMVSAqLw0KPiArICAgICAgIGlmIChscmJwLT5sdW4gIT0g
cnNwX2ZpZWxkLT5sdW4pDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQpXaHkgbm90
Pw0KQ2xlYXJseSB0aGlzIGFnYWluc3QgdGhlIHNwZWMgd2hpY2ggYWxsb3dzIHRvIGF0dGFjaCBo
cGIgc2Vuc2UgY3Jvc3NlZCBsdW5zDQoNCj4gKw0KPiArICAgICAgIGlmICghdWZzaHBiX2lzX2dl
bmVyYWxfbHVuKGxyYnAtPmx1bikpIHsNCj4gKyAgICAgICAgICAgICAgIGRldl93YXJuKGhiYS0+
ZGV2LCAidWZzaHBiOiBsdW4oJWQpIG5vdCBzdXBwb3J0ZWRcbiIsDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICBscmJwLT5sdW4pOw0KPiArICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0K
PiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIHJldHVybiB0cnVlOw0KPiArfQ0KDQoNCg0KDQo+
ICt2b2lkIHVmc2hwYl9yc3BfdXBpdShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzaGNk
X2xyYiAqbHJicCkNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGIgPSB1ZnNo
cGJfZ2V0X2hwYl9kYXRhKGxyYnAtPmNtZC0+ZGV2aWNlKTsNCj4gKyAgICAgICBzdHJ1Y3QgdXRw
X2hwYl9yc3AgKnJzcF9maWVsZDsNCj4gKyAgICAgICBpbnQgZGF0YV9zZWdfbGVuOw0KPiArDQo+
ICsgICAgICAgaWYgKCFocGIpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQpEaXR0bw0K
