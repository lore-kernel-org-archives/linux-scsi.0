Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD90FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE16601FF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBWI24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:28:56 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29900 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhBWI2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614070135; x=1645606135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eooXjIzkvXvvs+NBvj+kRrzV3Hdrq8AVt1nkRX05T0E=;
  b=V4/HEylS+3GRI0cu9DyyGHyGVDzwmKLUuklMvIBoFCXDZwsV+K49ZYaC
   5GNC+Twu+zT+o6lSZ33+/8f2OQkRKy/4bwabXsqKCN2PMinMwxcJjVO+U
   sOQ/ZayR1S+OBSndMiYNAyqlVX+d2FF/VCUpjn2VwqeSKvnUV9oyJbxGe
   os5ymm/k7CPB5DtgXZgYSfPtfkfiisqWc5LYMgmN57JAdGAH5bi4HC1bu
   uFIKEPnj5yAvSZbXLPNAYcGsEaBxE7vch88ndlLO/dPykVnk+VHHV0SR9
   ZwJcBcqdmfNoz+8NOX1Wujyn87BHBOvJNX1krXjlU5UXwefD4dHaQFJ4m
   w==;
IronPort-SDR: YV2xjGFbzCCRsPQCpbGhU7/80J9Q4hG5QG0we8VCrx1iixdePE/rBPoGpJjbecMAA/vfCVEkE/
 xZpZI7PrN+NADWnYAlHK70U1cTZ4Qgz7jqP4iD9egPWZxFRMte2srOJkwJSPXNCRdMRtcuzMJ9
 HAlLCQsXxZXEgpH20uasY/RZFbqJ/pHt8ZlfM6ssVo365unohPx+igvE3zb++DCDoxuSZo0p7r
 rWTJ7SASFSXWGSIj2gtx9db/1jV2BAYL35LHqKgtH8CatgBsSuzaSkQkYVuQeYS6SkC01g0Y91
 JEs=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="264772034"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 16:47:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+LG9Uk0QSUQhsUeX1Ak0iZlz8wIIzjzYBo3l5IDl3BY92gsMQq24+ETGVxUUE/sNnLQ3jp2WGicgZZ38Y2xRyYrPwezp7mBU8z31a4U1a4NkEk96CKOal+6U8rRboD6qT7MgRJFswcd1olCfOhK5W+6GywYUrPirHOQDPYRYckYiSzC3qT7Kr48ecOX8J1fErAJ7buGwDuj7fvCNFzqAq8ogYw5wT0um8pp8VvQHXLZjQl0m31uHWpbomq/63AWyJ2FxdVWmqYf6N1P6/YkFwyZNYExXnriG3xtrBfFRU9ZkPqSREAzlUh8CobadAJlf0L5liLh54zYJnOGUWy3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eooXjIzkvXvvs+NBvj+kRrzV3Hdrq8AVt1nkRX05T0E=;
 b=lRxKrnLhCbUsP7gi8XccYPk9eZqX+V1k2aMbMnW4RmQWg/sJ1iu0Es4gbzpibVmIzL83Gj/I4ivNbECrYk4l2SyVVIm2mZP5EIYYSlZKqQx8K860uZBZwONKz2WP4VUtG6YxwZePLWqGKCPRUurqEehS3Lfod25FRvqHkPT3rdgku+KPiaCzk1tQRRL6LA6E/qam6dyNjMil4TuiR5Q57qgBVC1xTpWhuXPkYJALgIk16dXW1Q3RHCInhQvFi7a/hQeDHzOOYCwZvRaEY/iDjSVGtgWmZYtcSe+AEUTYF8jBiRwZdinqUPNDjlIMX71K6qYsGFqYYK0y0PwBm2GBKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eooXjIzkvXvvs+NBvj+kRrzV3Hdrq8AVt1nkRX05T0E=;
 b=nRgTQR+a2Tk8N9mlhWK8Y8mj/aiHrYZ9aYSHD94lJxn/ukkEpiQk1L9h4aE/gQe0mFMxP6m+IDw6AsKgdgIePDINLPBJ2solB7aRc9Xog0k7q8FJgjxMHIYz3be1aOgLqKHrV8SOJxu7R1x0vh28kKbwkXCUGEkR99+CvNLfcwc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5626.namprd04.prod.outlook.com (2603:10b6:5:167::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.27; Tue, 23 Feb 2021 08:27:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 08:27:34 +0000
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHXCP2AswDeSMp180uO0U3nTEujWqplaNAQ
Date:   Tue, 23 Feb 2021 08:27:34 +0000
Message-ID: <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
 <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
In-Reply-To: <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f14ba478-674f-4d02-5703-08d8d7d4df0b
x-ms-traffictypediagnostic: DM6PR04MB5626:
x-microsoft-antispam-prvs: <DM6PR04MB5626384B2AA29249604DF99DFC809@DM6PR04MB5626.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FxC83cWtI/ASdI0M8M9fFJ4QrwBLlbzVm4DH8K9QOkVylzTRZBaKKhNWHKGw4S+UPsbUQDti22jjOWfidi4aSBpw2RRNMcclg+7eT+W8wB4lIQqg9A4sgQ3NDo5BJygNOE9jf/Vb/dHT4Bxr45vtcGHhaDHwkhKPAbCwvuVD9RxWkdPrRRqDSGPlEltV9wxD9ZlXShAK5Ej6STnardFCbNeyPt6PXvSHpL3+JH2xCUc72Ay33ufioz0CofwfqaUfBynfADx9kURL6RSCpE1YRbyjTpZmuHLI3ylmLIBdPvB/GSNn9NYm1meux6Sw/bBEel6onF36LBcBRjZj979xJ7Ef3GR5ZQsCsjxEZrJIosKRzd48kJqbktixoWk8apn497HgG/1THGNRAd68Z/QD4zbqeesHhFyzxBL3V4W+KccGC+oJzHNQCK24I50EFejJYyfKJGpf9kdI+zlKVnyAFUw8TY2OuPX9S9njZX2gsaSCKjRqh9HMqxCoX41FlGSF9mm+mNc/RV3hT/D1nSKc6V7d89C6/bWnT8DczqAsKSCHe8Jw+WPAm5VtccwS/nl+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(4744005)(66946007)(86362001)(55016002)(921005)(54906003)(186003)(8936002)(478600001)(6506007)(7696005)(8676002)(83380400001)(26005)(110136005)(4326008)(9686003)(5660300002)(7416002)(52536014)(2906002)(76116006)(66446008)(33656002)(66556008)(316002)(64756008)(71200400001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cklrTmhZMDZ5T0l4RWlmMnYwVXA3NGxIam9McjFzS3BJL2ZReE1tN2N2eVN6?=
 =?utf-8?B?Y2xrdDFoeUIza29xcUNlNnY4YTVLU2U0NzlIcFBHNGdXR01URHNjeE51L216?=
 =?utf-8?B?aWZ5ek1KTEJZSmU2VFR1cXlXQ3hFS3Y2RmtWRVVuL3dtcjNwQnYxNUhMWVo3?=
 =?utf-8?B?M2Z0bnFCM3VmaDJnelJIcVRBaVZkd1lQazkwblplQnRGdlJlMzdtSG1ZY1ZR?=
 =?utf-8?B?YzJ0OXQ3aHBQeGp5V2JLR29teGxzWXk4dnF2LytXcFRnR21DVWw0VmhpMWF5?=
 =?utf-8?B?d1ZLaFF0Z2FHNHFycHppb2hPSFhDSzBXQ3R5SXdnYUVZVUhTZ3ltcnVNSHlq?=
 =?utf-8?B?Q2VtL2NnWHppZXhURlV0Q3pENjN2SkFMNDR6aVd0TUdST3RFcW5BTUtobXZJ?=
 =?utf-8?B?VVgybU1lNHROdUZ6VXFXMlB6elRrTlZJVVJsbmdpdUFJbHdiL0tnNmx6Vkxr?=
 =?utf-8?B?V3pSSWRpaGJJNmZXOWJQU0Y3OWhyL3NXQk9nY29RU29ibnJFZ1RMclpUdm4y?=
 =?utf-8?B?NzNLeEpJM2lXOHJ5N1RxdnVvakVCUWZQTUtrbVJzSDZwbGhDbzZtZWJ1bnJj?=
 =?utf-8?B?RDZxM0FGU0ZBV3pXRVZ3a0xUbkRkREZ4RCsvajZHcmk1bDVvektWVk9raU1o?=
 =?utf-8?B?Zm5SN0Q4WFJxd3p1cUEyUjFhWTdQSkdoaHlMY2loUlRvVDkrUGpDYWRBUXZR?=
 =?utf-8?B?dDNaUnNuMk9BNXcrZlFLNkU5eVBNVjZSSzRSVmlsZzJYZGsvRFlyblRyVTBk?=
 =?utf-8?B?eDhqM0xYa0dWRldBYWtlTGcxOW1rQms5RnVhUXRHYXRpOTl0eDQ1UzRiQnMy?=
 =?utf-8?B?bVhFeTBXbFZycXQ0a0pnM0YySWFCbHluU3FIaVNoMnRLYmlDMWxyZmlRS1VX?=
 =?utf-8?B?Mm9aUS83SnY3SS94eXI3ZFpIMVV4cG5PMVNjWWwrZElQM3N3VDZ4KzRJYnkr?=
 =?utf-8?B?Y0FLR1RLL1g1b1ZaQnRiYmQrSHVOVk1SVnlrL2FTdWU0Q1dua2J2elNqNWZD?=
 =?utf-8?B?b0hKbWpsN0oweXhUb3doOTlmTFVYTXpIU3F5TkdlQ0p0UDFWdUQxb2tjbUh6?=
 =?utf-8?B?dWlla0wwcEtMYVoyU2wyc0JSbzI3R0EzN2Fud01jZEo0M29YUEZGeUs1NEVu?=
 =?utf-8?B?bUZLMmxsT2JiMWNDeGlzcENxblRBQjNlMnJQd0N2UHZ2bkR1V2h5NVk4Y1M4?=
 =?utf-8?B?cGVIcGxYVFFRSFZ6UjZKbEN3eGNaQk5WRGU0SlNDaXdXS2ZSaWdPa3czQnlx?=
 =?utf-8?B?TGZDWFZvR2o1NzVUR2FuSmVpN0R0OWc5eU9NQ213YzRnUEVjMzR0bzdqazBr?=
 =?utf-8?B?UVZMRThyVTRScyt3OG9WQURwRWR0dlp5RjVwN09zTnN0aXRQQ01NZFBMaFhT?=
 =?utf-8?B?aVRVeGhxaVVoekU5UzFyOWRPZ2J4aVZuY0xzNHY4YzZ6VHhPYmRTbmtBdURU?=
 =?utf-8?B?cWpvWUtzUTNSSXVMdi9KQzQ3UlozRll3ZHI2eGkrNlFyRmxnV0dZd1NwWnRG?=
 =?utf-8?B?ZDRaTEhnSlI4dnE5ZDNxcUdDckFhTHVOSHRSR292YzVxS3BicHdScnU0ekg0?=
 =?utf-8?B?bWJsRm1lUFB5MHgyU3N5Z3lyY2ZxWjY0NyttOWpBYlFxTm5KdEg0aWk0WmUy?=
 =?utf-8?B?OGtIWVNRU0pFdVZDbjBlMXhESkI4Q1VOVDVJaHo3U0lRUEhxZ0JoNGpCVlBD?=
 =?utf-8?B?ODEwWjUvWFRxK0NHNXpFT2hpeFgwTU8wL0EzZCtUdkpIamlIS0FaQ2V1azBl?=
 =?utf-8?Q?CEoZ8PzEb6QkqqGQ6QfYaxIXANcK/7BZBBzagMd?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14ba478-674f-4d02-5703-08d8d7d4df0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 08:27:34.6871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/dB8G/yW+eKTRDAkIw62ZBA/XjhayXHUnEEpGLsvGF2fn605sr4X/2am36Pmq6PaeLKJqNIP9vg3czb5MGYKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5626
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICsgICAgICAgZXJyID0gdWZzaHBiX2ZpbGxfcHBuX2Zyb21fcGFnZShocGIsIHNyZ24tPm1j
dHgsIHNyZ25fb2Zmc2V0LCAxLCAmcHBuKTsNCj4gKyAgICAgICBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZocGItPnJnbl9zdGF0ZV9sb2NrLCBmbGFncyk7DQo+ICsgICAgICAgaWYgKHVubGlrZWx5
KGVyciA8IDApKSB7DQo+ICsgICAgICAgICAgICAgICAvKg0KPiArICAgICAgICAgICAgICAgICog
SW4gdGhpcyBjYXNlLCB0aGUgcmVnaW9uIHN0YXRlIGlzIGFjdGl2ZSwNCj4gKyAgICAgICAgICAg
ICAgICAqIGJ1dCB0aGUgcHBuIHRhYmxlIGlzIG5vdCBhbGxvY2F0ZWQuDQo+ICsgICAgICAgICAg
ICAgICAgKiBNYWtlIHN1cmUgdGhhdCBwcG4gdGFibGUgbXVzdCBiZSBhbGxvY2F0ZWQgb24NCj4g
KyAgICAgICAgICAgICAgICAqIGFjdGl2ZSBzdGF0ZS4NCj4gKyAgICAgICAgICAgICAgICAqLw0K
PiArICAgICAgICAgICAgICAgV0FSTl9PTih0cnVlKTsNCj4gKyAgICAgICAgICAgICAgIGRldl9l
cnIoaGJhLT5kZXYsICJnZXQgcHBuIGZhaWxlZC4gZXJyICVkXG4iLCBlcnIpOw0KTWF5YmUganVz
dCBwcl93YXJuIGluc3RlYWQgb2Ygcmlza2luZyBjcmFzaGluZyB0aGUgbWFjaGluZSBvdmVyIHRo
YXQ/DQoNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gKyAgICAgICB9DQo=
