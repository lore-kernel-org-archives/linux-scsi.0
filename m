Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4665C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 927C564E25
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhAaHet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:34:49 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43726 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaHc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612078348; x=1643614348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qXGFzKwGqPRM3YejkxOdVddD7IxEl7MTdsCKoew4AY8=;
  b=qCAhkgxTG5DosHVJAI24rD7Ixy4NRdiEu4JrXUzgHei0a5dE944JeX2I
   yWZeypnzB4Q6T45INBafCycGP/LT/hQwHv4CHPyDWVeY9rZt5GCvv4cVX
   9RJYkKnwb/vAQh795bz3qyeb2Iw8Xu0MFiILmpUn2rsBoDagxSyfHQfE2
   3cJuwY17MJOrA0HRgTFlE3zHVMTIl6sU8paY6IfH9AzdDOBSF/DJ8DmCg
   jf361Atukyg8PQ7Vdc2wdOzJFIntpykYR7y2wIvHNmT7uSmzA8taHYlFa
   gXyeA1sB5TzTMqGVHnFRJTvftK4LVhjQI4ZsyxPqzBERXJnvzXLFx36Tn
   w==;
IronPort-SDR: G3Y8pqsf4xU1XHDbBmXyW666RO0rFaLSRviVKNR/ay3JlNCzIgCjlevLcXZJ7erbjFzn7UFrwC
 bznoRx6o6c8/rQLy+DqZep/dvZOeJQm/OxPZ+TfoLxEcTuP3Uob1IT9LRFPnDiPF1YztLy9YnV
 KkC9JSLonwRkh8mjtUrqXmcyfWnwbKKVMIXQnM6coEDOpezojaDE1SUgr9b1yjAKRbAwMtLGnv
 IMW5nZA/mY8lQh8u4xmxm6YVPB7DLAJRwjbt75bSHlLeLJbVsu7AWKEoqmXUc0L3ETH+SsOE2b
 zsU=
X-IronPort-AV: E=Sophos;i="5.79,389,1602518400"; 
   d="scan'208";a="159910920"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2021 15:30:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1ls5Op8DYfDSIo8/n+Mpt18cnjAaPNjUvxCZzCaP/WVe2rKDmFUJG6Yy/GBsqSn7EzehgqIuPWiN0QKRad5kgK2EEN1Ab3hK5rNLweyda30G8/531BMYQqNZBD/RkYLrjvdWKC2g711h7vCvQVsXF788g2HkM0lH1H3rXv8koRgAOfe1dE+iDBWMDvF5LCOWT5At4UF76xQhKb2PUW2eGbfz7nJcyhoeEEAvV+pxiHTLm+VrRVGQ3T18vpsOQnT6Y08IM3iES02QCZcOU61x4HTsiMylYjpJQ68nlDwsbERx8cvMJKxrXtIEO1270WHk0SHBDyDb+3q2lKc6kowQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXGFzKwGqPRM3YejkxOdVddD7IxEl7MTdsCKoew4AY8=;
 b=JLArsX60TlVTLftuZYlpWNGkat6gvzwJnFpFUAJt3T5Rpl3R5dmfjloe2Qd0xbWxPzlyTVlJ4I4KuOJ51uUTGT7j/tmMTc2qB9GTltsFiKNe/1pBcaq/qZe2AtRiDZEurIh93puNJkwvtTemPlkEfrDGWtjJDDZjD6jzEsoqtnqFunVixHda1HULbGK/7/Y39/HEOgNPEr09ICvK+sBfEuh0F50vR6XFOsG4Z/Ar5I3W8NyIrHJ8cqpntWfTSutvMFhSvq6xqvE8bK5av5XsKR/6QcHOgtD/tl7zdyh85/5gWrsOfy3syYKWSGkghr2acWQJ9y+7YXXqR6+3fGSipw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXGFzKwGqPRM3YejkxOdVddD7IxEl7MTdsCKoew4AY8=;
 b=OcqWxLmn77WTyZXf8o0vJvZsmmT53+I+iBGK5v+kMQdul+Lcme+zbS7bTls8HSkNZRj1GoJbpfRTKfc2oMcJ3kLKw1+g7G+Dzmg79OUB6Y0uz7W0Em4KUNk4cvkLQaCjm8L/MKq3qQDNG7PSEUc3/j9werSKyHSzXteI03O5Y9A=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BL0PR04MB4882.namprd04.prod.outlook.com (2603:10b6:208:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sun, 31 Jan
 2021 07:30:39 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::59d5:c6a9:57e7:15f7]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::59d5:c6a9:57e7:15f7%7]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 07:30:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 7/8] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH 7/8] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHW9L8BsgyJv4xoNkugfU0cI1Fxmqo7lzQAgAXEoOA=
Date:   Sun, 31 Jan 2021 07:30:39 +0000
Message-ID: <BL0PR04MB65646C5FFAAE64B428937ADEFCB79@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-8-avri.altman@wdc.com> <YBGFamLN83K5AHZe@kroah.com>
In-Reply-To: <YBGFamLN83K5AHZe@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b790c00-1a76-4efb-b213-08d8c5ba1c09
x-ms-traffictypediagnostic: BL0PR04MB4882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB48821AB5DBD8EF5FAA5FF916FCB79@BL0PR04MB4882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oSBkeXuXd7yXmKbn14FJiCYTkl92iaTJv8x3em5mVRHFjIxUATR2hpIebY8ol9tVJYeVy7qmhPXBq7OF+Dkb99JzrvuTWqeNm/Y4qOcvOFbmLGzK5NB21ziWPci3v3HVbZEdvNlgytsvW8WLDcEQ2uEAuWm8HrO9HXhs6RgK2wdholGKdr0kfKEzY2Xofs1PYqNiFSNJqmgr8JEduBwKsFVfzi0EL0RsP9z/0X01zfG1w/Z66/vwEhTmwkEVWmu7f11vfIshfwKgBYJzHjoEnzL3/NSu2bLuNEnDsfcuXlYbLENgc4Zp5cmsm+rDb79zcfcr/AuaKmrtgapEXaIpqJFTiNUr+WJSBOGSDeln5a2HNUbnbDjeyn5dVE7f0zAqU18De+NNUhxJCKj3U3AhaUKhEJp+CVMd3cQfIocd5owUO+EsVaWTfHtpPxYX6F9wELSU18MGtmIUBVK1lduIk7gpe/A9QazHQbkc6cdo+zbxbZBf97xJQhIqC0aCOCKu9RpLzfNFBnFCUBniP8ro6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(366004)(396003)(376002)(9686003)(55016002)(71200400001)(76116006)(478600001)(4326008)(8936002)(5660300002)(4744005)(66476007)(66946007)(26005)(6506007)(66446008)(64756008)(66556008)(52536014)(186003)(2906002)(7696005)(316002)(54906003)(33656002)(6916009)(7416002)(86362001)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S2hEZUU0ZWlkalRZdFI5K1NVdkZ6U3ZVVCtCcXNtZWo5bTdIVy83LzVOaC9a?=
 =?utf-8?B?LzNoSlE0TW5sdDdvalBRU3g0cHVsN0dXd3RlV2tFYXhGcDNKbmg2R2RraHhY?=
 =?utf-8?B?UENJT2hkNUU2N2hTeDlOYUZLQzZGeFBobXZtQXhQMFh1VUJJM3UwamJodlcz?=
 =?utf-8?B?eHBRTWlmeHZBYjlqTEN3VElJYWRzeEtOcEd0Vmh3YmlDSVBIZVJVb0xnMUdk?=
 =?utf-8?B?RlhMeWxmbXdFbFBhekZTQmd6OEZoc00zUVhlQmRwZlAxZG85RlBLNW1YQlZq?=
 =?utf-8?B?UHdyOUV0c3B0Ui9yRDFTbVQvak5yUStjRHIxQTJTbnFiYWpRODBiVFYwNE9G?=
 =?utf-8?B?Nm9qZUhzamNrMHltR2FIRUxjRnNlSjMrV2dRY2JrRG52OXVrR0xZT0pNUWk2?=
 =?utf-8?B?dHdMeEJyZ0E0RG1qWVZ6V1RxeVlVdVBpUTJRZXVDZUNTTVVoWFFSMW1xdVVZ?=
 =?utf-8?B?SldwTFprMGRCaWNadHpOb1g4blN1dnMvd09yYTRGZUUxbG9tZlFIZmYxZWdz?=
 =?utf-8?B?d0ZQZ3VsZ1RUcW5sQ3M0Q3o0aWtPZnFvRWdGL3NKdU5HNVNqeUVIV1phSGMv?=
 =?utf-8?B?Tm1mRHJpTU1BY3hWMndDNWlkL0pQaHBGYXlEaVlMaUJ3dmc2WHFQc0dkdmZ5?=
 =?utf-8?B?VXpUSTF4Ym90OWJFdTd6K0lDZVRLUFJySnI0Q3FYL2F2Wlo0c1dzUkk4Sk5i?=
 =?utf-8?B?MjdlTjlMRzJHaEVPVDllUGdjT0ZBZFM3RVQ2UlNaZkdwdEhnV3BpcldRUnZT?=
 =?utf-8?B?TDBqUGdiaDJKWXdBcG1VcEx5bzZrK2J4NEJVUExZdS9GWW1JVzZHa28wRWVk?=
 =?utf-8?B?RDE4T3ByZnFVd3A1UVdHNGFsNEMzOVQxUkVSMjZJSnJEeHFadytIVW9PQTU2?=
 =?utf-8?B?S1QrVHlvQlNBM1doQ000WktPaDhSS2wvWXRIb2Mxd1NCandiM1FuMk1Vcjg3?=
 =?utf-8?B?RmpEb014ZUI3UmVFTzJVSDREcVdxT2x0a25mdUFZa0w0Y0N1L1JSb3piYmJI?=
 =?utf-8?B?V2pSQXlyN1FjVEZhbTUyR0hybW1aa3BWRDgvWmJWTEFOYlhXeXdJS2dDK3Bx?=
 =?utf-8?B?QjVhT1hVQlZDYndyV0EyOVRTVTZrM3FNcmRmekFpbnpYUC9WY3h6dVQwbFJy?=
 =?utf-8?B?aTZVM0w4NytaNjRGQVIrdXIzYWd0MkpNa21mUWZyV21NZWpzWHIrLzBobGJI?=
 =?utf-8?B?NWxGQ3FmWVNiakhreFNHZStVQUs4S3BrK0pWWlBrM0JVMUlZYS9FQmdjZDJV?=
 =?utf-8?B?Mk9KcXJscXordlFqUG1XNEhBWG1ISkdyUk1kbjB1SnIrbWdyS29FdHMwVjZL?=
 =?utf-8?B?Z1VSR3ZCWE10ekpiZ2ZVczNtRUZXYzFWNC9GN2hRcW5XcjQ1c2IvZjJ5MDhi?=
 =?utf-8?B?ZGdhR0cxSkkwN3dBeDlwMDZObWxuU2tGbHRzN0VlVHFwa2svUXJSVTY1Vllq?=
 =?utf-8?Q?1N31S7hg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b790c00-1a76-4efb-b213-08d8c5ba1c09
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:30:39.6647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kadAK9UnhJkFohai0+JJDj9348qMwemMAmu0C42+y2ENp6xRUnwSyQ7eSHhRx+dp2xn1Cgor774yIrGavYRNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4882
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICsgICAgIC8qIHJlZ2lvbiAiY29sZCIgdGltZXIgLSBmb3IgaG9zdCBtb2RlICovDQo+ID4g
KyAgICAga3RpbWVfdCByZWFkX3RpbWVvdXQ7DQo+ID4gKyAgICAgYXRvbWljX3QgcmVhZF90aW1l
b3V0X2V4cGlyaWVzOw0KPiANCj4gV2h5IGRvZXMgdGhpcyBoYXZlIHRvIGJlIGFuIGF0b21pYyB3
aGVuIHlvdSBoYXZlIGEgbG9jayB0byBwcm90ZWN0IHRoaXMNCj4gc3RydWN0dXJlIGFscmVhZHkg
dGFrZW4/DQpEb25lLg0KDQpZb3UgYXJlIHJpZ2h0LCBpdCBpcyBwcm90ZWN0ZWQgYnkgdGhlIGhw
YiBzdGF0ZSBsb2NrLiAgV2lsbCBmaXggaXQuDQoNClRoYW5rcywNCkF2cmkgDQo=
