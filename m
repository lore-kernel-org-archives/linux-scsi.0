Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D051EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 14:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B121661214
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 14:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245442AbhI2OJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 10:09:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:5066 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhI2OJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 10:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632924489; x=1664460489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dDhzN8s9eOFAMlImLQJvqpsOFvkiv5Xntfto1RAJXMw=;
  b=NqH0XzxBvUNVfPg3M1W7M+1/+IacyRCrCBf0R8x9s4wY0XagfkQUE6zb
   LKKb+RCKhCAMHLAw+UpOZZ28o+nXAElg8N+CmYCHdNlbhR8pc7YO9oEze
   wYplgW5qDrO27UM//8WsPAd98+0gdUft2JTeXsVK7TJpz28T3uFWRXNyW
   kooFVTL5dKiLNdLL4TXbJSibGaNWbHuBr0i5i2JkXFRAblg7NK2WBFe/2
   K1s7fs2XBaVG+e/J7XHX8Hq4L3Hysrxu8xwna+X7OXQMB5wUgO36Twj0P
   I5SPj0Yt9Gv530BXOjW1VukrOU7BchT+hzlwGuMP+TzIO8OBdSa9+1PR7
   Q==;
IronPort-SDR: LKsLO2nfoP8A+osQcRYRu0eJGCEnanG9lzuDKfI2Qf++ypco7X+sJeWp2Mx0NPYIoR9ttUQD0w
 qUaFwm0/cClH8beO3Rhvr6o0weOK4x47HrefD2j+ymP3l0iKsWM1m/MRTKpIt62iT1gfc2WFd1
 XoGD29z8odD1aT9TiAQRET3WlCdQ/Cn+X1PLoNe4Qb72Cg9g0WPwiGqakXiTDeZVygQCAQIiWF
 +Z5Y5uZ2SJ6GGGrNHvaJSd0duAsNtaME+jDNKRWz8gY1v25nqZ81Ju0FSM+crMxuiPoUundx4J
 KkvZRS4IRuRZ38hXcAxatI5U
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="146102420"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Sep 2021 07:08:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 29 Sep 2021 07:08:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Wed, 29 Sep 2021 07:08:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aq6qxGGusQ4BYB3Bvxs5th38arUNnsvlnbTW7gFwNsps68aEmbKHYHY93paFNsrf972rTVDvPUGvy4Hc3w2WylD2Ad/IBElIt59/2gGJN0tZhhIMxNw9liqKi011OzIv5Q6XS/uaoTp7B955S0tS6BZG8luLS6PEHReuKYJY9kxjfQPRbCwoYUuY5305fAbN5ygZOOnJ1YxFiI2nmrUkaIJeotmvngLGdj4mSxY8JHb2GL+rOHaTUKd5FeRe7krAGJ6INHqxXSK9DTGsV2o0uJpaL87Puje9TPrPGTnvlKsFDejU6xQYwsjhZcXv7zs9cG2d/+yQiM2JYn+wizOaAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dDhzN8s9eOFAMlImLQJvqpsOFvkiv5Xntfto1RAJXMw=;
 b=LgqgqXwHsEP4Xyh093Q2mOsnPmw4IKgUeLykxJzMKiC6qzCxpXqcqgoiuF3z1lkLFtnYxTV1QJaOoBTnOCshJveFDOt+1+y9/GZgp9PL6RgzhfQkbEiuAugV0wTxpFDKQ7Gp9z5H+edg96m87XxRwAFZ4oY1RHuKlKixUTmQIUXfFioDSnRkc7l/+XEVa7/8+/Ihqe7dDxxVYClEz+P8z3o8uPxKzMgnyLMN5TNGmVb8Aji518T02qrtuS3bD7ZLCNc+Dobw7+vvkQ0sb4hd/FR2ZbokXtnFjojZbXE8QD3yk0g0SwBPEFtrIyhYdCO8YLYi1hQejvl/TmF8dEvmXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDhzN8s9eOFAMlImLQJvqpsOFvkiv5Xntfto1RAJXMw=;
 b=tRIxAX9tZnpG5eAFBU/a31WZ4LONKABswOXt0t2//TygD+qGw79D1z78QwWtP4pIH+S8qCaq2NNbFljRIQwrzaqvyz5Ae/123swaDP6W50zuj25/1zdjDewvVWIwyaFqMmL6y3WZAUZT15rD9JH8XcihonFuk32AAFeqeVNEs4o=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3005.namprd11.prod.outlook.com (2603:10b6:805:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Wed, 29 Sep
 2021 14:08:06 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1%7]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 14:08:06 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>
CC:     <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <Mike.McGowen@microchip.com>, <Murthy.Bhat@microchip.com>,
        <Balsundar.P@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH V2 00/11] smartpqi updates
Thread-Topic: [smartpqi updates PATCH V2 00/11] smartpqi updates
Thread-Index: AQHXtMRD9afJNhiKSEGNV5IfqYhgC6u6wP4AgABMDFA=
Date:   Wed, 29 Sep 2021 14:08:06 +0000
Message-ID: <SN6PR11MB2848FE480F24EF105E473F4EE1A99@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
 <dfea334a-5d37-bb14-1959-51bf7287197b@molgen.mpg.de>
In-Reply-To: <dfea334a-5d37-bb14-1959-51bf7287197b@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b6cd8e0-8883-4857-7220-08d983528f8c
x-ms-traffictypediagnostic: SN6PR11MB3005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3005701142F5A642D9F136ACE1A99@SN6PR11MB3005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LTy3GLcicj3ERFtZYYx7DncERBpPirwJD7cd1WzjFPu9EnFDg8r5p/wdqGcGjsVbb2dGAHuAxNCwaVLGCo0fKfWe3GTHuudIqPVuh30P/k1UfzCnwP//T+4RxpsgVkxAk59y+ixi/yoEo+CtOqEnkf268t6RsHD82PLUxVEip8hLfLsXzPRNCVAGJWZ1fKK/sG08lnwI6cG0hi1SfFSPHQFnXso78PwN9Kh4ehmAIa8FfcjrliSp0TrqmHJv62gL6DMjS10SLtrD4QPJSrGLiSsDfdEbQEClBHVC7E0ZQmCjsHyzdouqQ2/hXuEoL5LjpUIWHhlfKyaGWnnpxJkCjRbJh1efFHJHApIXRtG8CvXiSyNDTvwgAU6t5+ZwTWaCDLVL6q7U8AH9rMt0ZgBxLJSgtJdclooF4CuyqumKEGxJd2DxjA98M25Ee0kR5G9GRw9F56fRIqYEiL7TQR67HJHRZVabkZYPTPwCCARjwHgDR5NPDOTgAYJVZ6QiFhXhgHZG5brKoqqr24bfYMeXi10OkUdpCG+5msoqK565iuV0fCTJbiOdn9KR2o4KYU6ZLxIOtvPr37SgTH1v9x94kqsKBlHiKfYmMhdHWfIH1gpqtj905blF8IlFnzN2KivHz9fdbvU/zJCJbE+/N94tPHeKZ/xAX6qpPltMEn2TIhZX/dcQfs5tHpzGwCxw8b3KaqhjvHpliWw763hfS3azJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(6506007)(15650500001)(54906003)(7696005)(4744005)(55016002)(508600001)(316002)(5660300002)(9686003)(2906002)(64756008)(66556008)(66446008)(122000001)(186003)(52536014)(4326008)(8936002)(8676002)(76116006)(66946007)(33656002)(6916009)(7416002)(83380400001)(66476007)(71200400001)(38070700005)(38100700002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1JaVlBuNWxIWWFUalpPd0xyVkFYYXZEanBPRlBCa0VxUVRaNHRhbjVCbmU0?=
 =?utf-8?B?Nmt6RUlINmtxL0djbks5UjJjK2YyanFkNENqenh1N1orM2lnY2hQQUZvbGtm?=
 =?utf-8?B?eHRiMVIwRHRvOUxoSGdjcjZldDhnLzhMakRrSFZ5Y05XdzRBUllXQzI2TGda?=
 =?utf-8?B?RGt1UlR3RkJTekdkcGVnalRjNEwzanpyK09BM0h1NVJlQ3h5ZnpsSWQwdXl6?=
 =?utf-8?B?MzNIODUwanlobXF2aEpSUjdDQ284djl3U3F3L0oxMU9GTTR0cmxZak16a1p3?=
 =?utf-8?B?OUN4bXE1dnFhV0d4NkRXb243NHBNN2puRHQ4a3NSamovSnQvWTQrS2VVVldq?=
 =?utf-8?B?dmxXTnloRFg0bk9rZVRGN2NoMTkrQ3NEL1NaYTdqK1A5TDF2ay9YWEN0MmJ0?=
 =?utf-8?B?Mm1DajV1RXNMZzdyUGFJS2NQZU5lWHRSL1hpRmpSUmI4RmNhNktiZ3NUMW02?=
 =?utf-8?B?M2xuTUprL1JkUG1XZm5FcEZNSGxMb0l2cHoraktxcW1hczUzbktja2t1K2V0?=
 =?utf-8?B?SGUvTU1aRUJRbWQ1RGtPc0pXSzR6dmMxVUEvNG1ZT0hqd2locnZHM2pQYXZn?=
 =?utf-8?B?THEzaTBGRnJjRy9sOHh0NThvVzFGU1VnZTZubFM2RW94U3djczhxa0dTdUJa?=
 =?utf-8?B?MmNqd1k4RlYwRUkzSlpFajd5MCtuMkhRYjAyVzFva3Iwd0grQWZURERmZEZm?=
 =?utf-8?B?cmdFbWFxcFA5SkNqNlQ0RDRMRGFoMnJmanR5MlRmTVVCSExyaHFxMU5RbkdZ?=
 =?utf-8?B?OWlkaVUwenNEUmVWWVZDMTVSb2hKaWxsaGZFWkpjZExFSjhKUmNQYmQ5U2pn?=
 =?utf-8?B?VHllbTA2M0M1UzR0TDJOa2h1cVFoMGlRbjcydG1RZUEyQWhER2lyZnpqVVA5?=
 =?utf-8?B?WWxJaGFDc0t1VDVQWkFXU3ZQK2UzeElmY016dUJtY2JBMDM5RzBMaVhkd1BR?=
 =?utf-8?B?dG8zTUVIOWZicVJydGhPWnJ4QkVtNEhpU3ZISlV5b0VCZ2l6R2IxTEdHQXAz?=
 =?utf-8?B?SWVoTTVaRXI1b0JIYUtQbWtuWHFGNkNxZ2JUSXlCMjFKbWN5L1p0M3k5bGhY?=
 =?utf-8?B?eURVYTd3T2VTS2FsUlhITVU0ZkdrTEdDUUlyNmNyRDV4VDh2UXdXdHNydDFh?=
 =?utf-8?B?ZFBOOTFEWGxqdzVocnlRb3RGbTdPdFdkL2tLbFM5elFsTFZkU3REWmNTTk94?=
 =?utf-8?B?NEZPOG9Zek1XdkxCV01obTBEQTJuN3FrTm4xZXg4MmRJdGhOazVFc1paV1ZU?=
 =?utf-8?B?V1F6cEtQY1J5SnBYa2ZnMEwzOCthc09YRGtUcTVRaUY2TkJvMzU0ZEFmVG1J?=
 =?utf-8?B?WHJzU1RRd1JIdlNGME9SL09WdDNtbTJ4UFpCR0VCUUNxN3gzdCtqRERtMVFO?=
 =?utf-8?B?RDhqMzNIeHIzQk5UOFAxSndoMFJkN2NBZFJ0THRxbVFwQ0d6cTQrN3pDWGxZ?=
 =?utf-8?B?azYrenE0WktNRTlZOGFLWWlFSkU0dDNXY3lWajBRM0Z2VXUwUTlKOWoxT25n?=
 =?utf-8?B?bndYa2lBZmVwaytEY0Z4ZlFjVVFjOFF0UlJXSUVxMHhpb1MvWFJZUlBWcWRN?=
 =?utf-8?B?aEdFUUNtSlNyNU9rcStXRW9IQmhISlF1djFoRStKaGNIOHJvc3dVWjdpL2xJ?=
 =?utf-8?B?L0NEeFZBQVBvSk9Hd2lnNnJpbnA1YU5mMWxWQmJVY090Z3ZweVRORnkxUTdN?=
 =?utf-8?B?R0RxU0JQN1hNV1RCMXdFVzVuNFhZTmFsaDl4WTljMmRtRWxyVEFCRXh2OWxr?=
 =?utf-8?Q?jYgTczJTHAlZqH5yzF1ARNSV25eMSawQdhu2shy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6cd8e0-8883-4857-7220-08d983528f8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 14:08:06.7539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LdGBBB3+NrfcZvZ+YVuu8ZEyjb7KjLKJL6gfSaBTJRzI1P27MaiDiawRCGUVmI2EkTm6JZls5AkpUEBq489DwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdWwgTWVuemVsIFttYWlsdG86cG1l
bnplbEBtb2xnZW4ubXBnLmRlXSANClN1YmplY3Q6IFJlOiBbc21hcnRwcWkgdXBkYXRlcyBQQVRD
SCBWMiAwMC8xMV0gc21hcnRwcWkgdXBkYXRlcw0KDQpEZWFyIERvbiwNCg0KDQpKdXN0IGEgc21h
bGwgbml0IHJlZ2FyZGluZyBtb3N0IHBhdGNoZXMgaW4gdGhlIHBhdGNoIHF1ZXVlLg0KDQpJdOKA
mWQgYmUgZ3JlYXQgaWYgdGhlIGZ1bGwgdGV4dCB3aWR0aCBvZiA3NSBjaGFyYWN0ZXJzIGNvdWxk
IGJlIHVzZWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIGJvZGllcy4gQ3VycmVudGx5IHRoZXkgYXJl
IHdlbGwgYmVsb3cgdGhhdCwgYW5kIHRoZXJlZm9yZSB0YWtlIG1vcmUgbGluZXMgdGhhbiBuZWNl
c3NhcnkgYW5kIGFyZSBoYXJkZXIgdG8gcmVhZCBmb3IgbWUuDQoNCg0KS2luZCByZWdhcmRzLA0K
DQpQYXVsDQotLS0NCkkgY2FuIHJlLXdvcmQgYW5kIHJlLXNlbmQgaWYgeW91IGxpa2UuDQpUaGFu
a3MsDQpEb24gQnJhY2UNCg==
