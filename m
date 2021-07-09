Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86057C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 15:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63FAE613C1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 15:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhGIPJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 11:09:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20526 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhGIPJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 11:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625843196; x=1657379196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HsWIOoK+nBQ7ygEyO917JyfxpyIQ8s0sk/LwGOht/nc=;
  b=2JjzQaPl0k5ygDRmDMZigLTRgfW4pUNOlpuYuDChN1pxYo86S/hXm5Dh
   FG09VvRUOWiDSmIElhKeEiI4mx0nMmAyzB9khVO/AcKSRjl6JA2mcdnRW
   dasPtMow2ndJ/mDPMVt6RjGQufp4UG67SXCeksHoGvkD3WO9ZpsIw9vZ6
   9budFQCHD6W2CbbJ8cAU3bowE8rTswZ3M4MQlqKxHPteGuaNSCmXpcmkD
   F8So86Pi/hkLDjwAh30OZzrkYNmXW4nePZjDqQjOYY1apALq+sUDRCY0/
   rNVKLFTFI3vlauj7PZbLME0PtCKiy5wXOZBqr8y/D+YKXuDaCBkRitIer
   A==;
IronPort-SDR: hqCJv02qXuLR/ajcvcmQgUGQf+uvXpRj0NkCaWO//IpzC1a8as8F4raRZJm5h3lkh9c9cM4Emd
 7dg1K3fDMqrtvr46LtNXM0RySWSMeBTYoqAt6t6+s3QwXDPQy5qIL3RFGKY59I3oPwREuc3dlo
 6NakXgxgt+N9D/NH+qtT9qiXK8hXhGDzALAH9HUJJ5NIuWjj5qBRV6M8Pg8elqbYJSoPbxPxMR
 XEiV8U+lGWjFptzrDfADSSGIrtlVx4ravUWwlz/I/Q7594a2NBOx94OlMR0bszZRHoSwoQ23Ux
 dRA=
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="61704979"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jul 2021 08:06:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 9 Jul 2021 08:06:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Fri, 9 Jul 2021 08:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzmcAovIu8pujge5g+mjzQjPjVTKzQ4We35qcW0bKIGGiXe1tHLIoCAo4NrT2Oaact94eDZTjwcW4mSouiIYnpPnMl+rlAACTvousQ91vDO2TYMj7JR41+8rNMMbB10rp4ye7Lnvy7zl0BU3YLEu1XZqxxj9xbEqAtmCGvPxptGnV1COYjcXuh0ruAST5LuAHVkbdSPjXz8/aVpqaBpq7G5WiRLx1NNPGIEip2PrACQE+kQ2JJnBDdo5ZFkeHDAeGl92bWl+IIbadcwgriUjvYC079NuRRCinTvXMkaZEXun4Tx79IgPBg33Q6t0evynrQdC4uVIsHmIXNj6vcRNwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsWIOoK+nBQ7ygEyO917JyfxpyIQ8s0sk/LwGOht/nc=;
 b=D7oSA5vywB9nsj1R5LW2C092CQLywlMGhogFemISgnpUWGGzTcoR13VAsT/X4vyTv5VexXxlpa/IiW81r0YFAIqP7YJV1BiTTl5uR+9MGU7Kyv9Jm5nbsj6Jv5l54+fbjncUjh4Bv3xUFcfnUcLraXg8W8e8QX1pt4sMqKN0Quv3CcYzJyMDfxi2CPPt0bv581TObOj6mG7VVNefpwO7i3LFA3cdJOG8lpN9ShTlpZtbsrr1DRwhkpC0IBgyldo+wzXoDc2FMb+IfLWjflA4763+1IdMUFrp05aiQl92P4BWRqfjIxG1MgEyiXjMATEr0MC9/yF5VCuXIT0+k3zklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsWIOoK+nBQ7ygEyO917JyfxpyIQ8s0sk/LwGOht/nc=;
 b=KNef9vWpBn/HG/OChIiGekC4lv8KeIel9I8AsTbHGGGL/BnPSNLQzZQQhDIZZV8N9hXtNSQLgReLmYvSI+yTsRQUjXsKnqREV1dOEsApd5b6/9JqWB2uE9RGgKlbth10UBVgw7XUKyFiYWxpAef6eRYOxr5qK6CBTV23XQqa930=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3007.namprd11.prod.outlook.com (2603:10b6:805:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 15:06:26 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 15:06:26 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>
CC:     <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
Thread-Topic: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
Thread-Index: AQHXcwHAUDlfVz7mEUGnZ/7ayWT+AKs5cWuwgADPcICAAH9K8A==
Date:   Fri, 9 Jul 2021 15:06:25 +0000
Message-ID: <SN6PR11MB2848C0B43F9AD5319C203FA9E1189@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-3-don.brace@microchip.com>
 <17eeaf22-4625-d733-dcfb-ec2322dd0ca6@molgen.mpg.de>
 <SN6PR11MB284877FDAB929F223AEC14B5E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
 <4b68177b-4c61-74fd-eee7-83b938200278@molgen.mpg.de>
In-Reply-To: <4b68177b-4c61-74fd-eee7-83b938200278@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45fab43a-70f7-45bb-d8d7-08d942eb1f6b
x-ms-traffictypediagnostic: SN6PR11MB3007:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB30071C4FDEA8E95EBC075FE3E1189@SN6PR11MB3007.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cOuUXKu0zl1xENOhOQ4MXjbvy9czchVTQ8ysT1zzMaZeCeDVkkvl3KhNaZs1b7XqP5dyasyBCsY+GNFFhgjccfqHMKbiPc2eE6Pj4e3evW6HkDK0MrmnVBRPF9LWIsOB0dtISaHRDZeslkOAAjSaJSb1/1SUs2ic7DQYjD1e8/ZVB/iz8OdsN1clRw5cMi7C9DwhY5kZJrENaFd8IulOUVpWAe8UiMUEqIByXx5jN7symXccUhuV8x47j0XLXx2VyEM4i6zZe2kQq3HJ8JHC7qs6Yt2erQ5c1y13VP21ZHh+5ta++mU+eO9zcfkFQdv506p5lqtDu0ARhPgChm2Kl6BvNRsR+1+COpXmvRaPCgUlJzcSnsez5KYofoH+y4Plt/8W88tSfp/fJw4yZHgQEcLsSZo7mtJ3pvmlQ+oXvhHZO4V6oLHuY/oAfS2PkNk9SxaL9+MRZhOR3hqBQsd6XQuhXMQUf+p08ElNHEzq2L19PA9n4u0ocxNqUL/HXTjo8liZmP0xmwv0Jz6gvJLXE8GG8ASVot4e+8GxX9i3WYi+li7a/6qatq089Tqkv8HFCfZyFntevKEbsVqFTJBacpqiYUWXFKOrV8I00xAVjSxI3xISf8LXMcws/n3dxVkjvSIcgckQzvEFBYWIG6DLpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(6636002)(7696005)(33656002)(86362001)(66476007)(26005)(66946007)(8676002)(83380400001)(186003)(6506007)(8936002)(53546011)(38100700002)(5660300002)(122000001)(316002)(71200400001)(15650500001)(54906003)(52536014)(9686003)(478600001)(110136005)(55016002)(66446008)(7416002)(4326008)(64756008)(66556008)(76116006)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXgxb3F5bGxpMzM1WUt6cmhLR0drRnJsVlpoWEVBd3NnMTBWR3BpbjFvQnF6?=
 =?utf-8?B?QWNkNjRpMEJRNG9ITWZyV01yS2dGay9lWHRTb0RVd2FkWEtwWkNpVVYyU3RD?=
 =?utf-8?B?eCsyQnZFckpIS29MRlp6SCsxZmVBVUVBTWlOdS9NMmZCaXRmNzdlV2dhOElC?=
 =?utf-8?B?R0xRMDhybG0xZ2t5MHRtZk0zMlRpeS9xUThXdmZNMGcvSDM5S0dGQ01hZlE2?=
 =?utf-8?B?Y1NzQnB2eDY2OUpkczByTUNEWXRtaUJFb2lqMWdSM05NNENzdnV6WlUzcTla?=
 =?utf-8?B?aG1RS0NSTzJnVjZhMVMxaWYwM1hMT0xYZjNTbHdXUGJEc0JUUEJFd0d3bjYv?=
 =?utf-8?B?R3lUUHhlWUpLckRYSE5NUUJRYmJDenRpQnBIUkhYOGZrMzZrWlVFcW5BSjFG?=
 =?utf-8?B?aVQ2L25iTHIwempzNnIrOWVRK2dsZnZIZmNGYi9EVnJXaCtydzI0Z2w0QlRH?=
 =?utf-8?B?T09sa2VVemplM2NMTmNleHNWQjRSYXo0NG96aDhuaUpYNTlwYXJEQ0daZjQ5?=
 =?utf-8?B?M2lYQnd4Mnk4Y0tTK0NBRWJqM05Pc0hLWlkwQU5QRGMwdnBPZFBLZ1MyNzhY?=
 =?utf-8?B?aVRINmlMQUxBQVlSbFUzY2ZyOGhUUTJWLzRiZEF2V05WUWpGdWliRkc1eWtW?=
 =?utf-8?B?ZDJpR1RsN0FwdnZrTGhXclY4d044aG5jSXBncU9PcTREWFREcGFheC9RdG1i?=
 =?utf-8?B?L0pHTFJaUjNCMytiRlU3azZxKytvUTNYbXF3YzR4c0s0VWpBS2tVT0owVjJw?=
 =?utf-8?B?YjdLbG43N2p4MzczVzBOamFuaWpGUW9na0JSL2hwa1ZzRXRqTGtOVjl3TXVV?=
 =?utf-8?B?Ry9ENy82d1liNEJkUE4zbjFyUXg4c2hGbUtQV2c0TkR3VDRMWHlZcTJaWmQ3?=
 =?utf-8?B?WUg0Q21NOW0vRGlCa0RkMUxuODgyQjJWaTZNdDhoRjIrQVViaUlKR3pUVmFM?=
 =?utf-8?B?UUFvMFl1N2k2dDBDTGxEYVBKajRFcmErcnRWbENsbjdQRXdzcWVpcHhXeE45?=
 =?utf-8?B?ZVVZckFyMUlUU281eTB5TzJPZXhWaW00QU1OMFNLNlF3aWVHWnMwM0dBQi9l?=
 =?utf-8?B?WXBZUUd3T1hob0FrM1pGTGF2M0JnWnJFQ3NNaDlSQ0d3VnBvSlRQZjY3N0pE?=
 =?utf-8?B?ang4MW1WcTFCWjJoNGdHTVRkM1N2MitiS3pTWmMrTk84bkRpR0lRQ2srNHU3?=
 =?utf-8?B?N0RQNDkzL1R5MzU0d3JlUVkvWnpDVVZxUWUrd3I4MFo0aGs5TC9ITW5sTjIv?=
 =?utf-8?B?WXlFS2hvRnpHTkUySklvSFQ1L1J2MGEwWHNZTUl0dnNhR0NYWTdFOUNPTk9j?=
 =?utf-8?B?U3ZwU3Z0bkxpaThxLzdIQXcwT3FxVjl0dkJhamkvQ2ZrZnV6OFMwQ2d6ZlM2?=
 =?utf-8?B?cmEzUFRybVY2N1hCRVdxV0lnYVQvcjlobGFxVzRUUThUd2YvUDVUbHVNV3l2?=
 =?utf-8?B?Y0QxQjQzTlh4c0MzMlhjdVVrSXhWM3BTYmRsRExsSU9NelZNaG1OcDYyeDdP?=
 =?utf-8?B?TU9PWEMvbFp1Q2Y5czk5RjVHb3REZTJaYm1VVHUwOEp4RDBIREc0bWtmL04y?=
 =?utf-8?B?U013d1k1eEJzbXdMTy8zWGxPQU52cjVUdDJnYXRGYVhzVHJubnlRY3dFZU1F?=
 =?utf-8?B?eVRBVHl2UEl1aUV5QVBFVmlnTTExWmxXdVB5aUVmVzRjM0wwVW1LWUphandJ?=
 =?utf-8?B?ejZuVFpOaWVzTlZ6T2sxakI0b1Q2czNWSkNBYVdOSHpHRWxrZXpPSVdKWmUy?=
 =?utf-8?Q?FTCYGX8eo8DAnfQTPSdnUC8nVMe6LNmiiyhHzFw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fab43a-70f7-45bb-d8d7-08d942eb1f6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2021 15:06:26.0225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBiJO9dTJQzV0xEd9gG6lbOi5MGq99p4B7wKj7jFQKZYxqMpNt9fotETeeYAv48ZToMWJOMFytjc7EhG/hdRMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdWwgTWVuemVsIFttYWlsdG86cG1l
bnplbEBtb2xnZW4ubXBnLmRlXSANCg0KRGVhciBEb24sDQoNCg0KVGhhbmsgeW91IGZvciB5b3Vy
IHJlcGx5Lg0KDQoNCkFtIDA4LjA3LjIxIHVtIDIxOjA0IHNjaHJpZWIgRG9uLkJyYWNlQG1pY3Jv
Y2hpcC5jb206DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBhdWwgTWVu
emVsIFttYWlsdG86cG1lbnplbEBtb2xnZW4ubXBnLmRlXQ0KPiBTZW50OiBXZWRuZXNkYXksIEp1
bHkgNywgMjAyMSAyOjI5IEFNDQo+IFN1YmplY3Q6IFJlOiBbc21hcnRwcWkgdXBkYXRlcyBQQVRD
SCAyLzldIHNtYXJ0cHFpOiBybSB1bnN1cHBvcnRlZCANCj4gY29udHJvbGxlciBmZWF0dXJlcyBt
c2dzDQoNCj4gQW0gMDYuMDcuMjEgdW0gMjA6MTYgc2NocmllYiBEb24gQnJhY2U6DQo+PiBGcm9t
OiBLZXZpbiBCYXJuZXR0IDxrZXZpbi5iYXJuZXR0QG1pY3JvY2hpcC5jb20+DQo+Pg0KPj4gUmVt
b3ZlICJGZWF0dXJlIFhZWiBub3Qgc3VwcG9ydGVkIGJ5IGNvbnRyb2xsZXIiIG1lc3NhZ2VzLg0K
Pj4NCj4+IER1cmluZyBkcml2ZXIgaW5pdGlhbGl6YXRpb24sIHRoZSBkcml2ZXIgZXhhbWluZXMg
dGhlIFBRSSBUYWJsZSBGZWF0dXJlIGJpdHMuDQo+PiBUaGVzZSBiaXRzIGFyZSB1c2VkIGJ5IHRo
ZSBjb250cm9sbGVyIHRvIGFkdmVydGlzZSBmZWF0dXJlcyBzdXBwb3J0ZWQgDQo+PiBieSB0aGUg
Y29udHJvbGxlci4gRm9yIGFueSBmZWF0dXJlcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBjb250cm9s
bGVyLCANCj4+IHRoZSBkcml2ZXIgd291bGQgZGlzcGxheSBhIG1lc3NhZ2UgaW4gdGhlIGZvcm06
DQo+PiAgICAgICAgICAgIkZlYXR1cmUgWFlaIG5vdCBzdXBwb3J0ZWQgYnkgY29udHJvbGxlciIN
Cj4+IFNvbWUgb2YgdGhlc2UgIm5lZ2F0aXZlIiBtZXNzYWdlcyB3ZXJlIGNhdXNpbmcgY3VzdG9t
ZXIgY29uZnVzaW9uLg0KPg0KPiBBcyBpdOKAmXMgaW5mbyBsb2cgbGV2ZWwgYW5kIG5vdCB3YXJu
aW5nIG9yIG5vdGljZSwgdGhlc2UgbWVzc2FnZSBhcmUgDQo+IHVzZWZ1bCBpbiBteSBvcGluaW9u
LiBZb3UgY291bGQgZG93bmdyYWRlIHRoZW0gdG8gZGVidWcsIGJ1dCBJIGRvIG5vdCANCj4gc2Vl
IHdoeS4gSWYgY3VzdG9tZXJzIGRvIG5vdCB3YW50IHRvIHNlZSB0aGVzZSBpbmZvIG1lc3NhZ2Vz
LCB0aGV5IA0KPiBzaG91bGQgZmlsdGVyIHRoZW0gb3V0Lg0KPg0KPiBGb3IgY29tcGxldGVuZXNz
LCBpcyB0aGVyZSBhbiBhbHRlcm5hdGl2ZSB0byBsaXN0IHRoZSB1bnN1cHBvcnRlZCANCj4gZmVh
dHVyZXMgZnJvbSB0aGUgZmlybXdhcmUgZm9yIGV4YW1wbGUgZnJvbSBzeXNmcz8NCg0KPiBEb24+
IFRoYW5rcyBmb3IgeW91ciBSZXZpZXcuIEF0IHRoaXMgdGltZSB3ZSB3b3VsZCBwcmVmZXIgdG8g
bm90DQo+IHByb3ZpZGUgbWVzc2FnZXMgYWJvdXQgdW5zdXBwb3J0ZWQgZmVhdHVyZXMuDQoNCk9u
bHkgYmVjYXVzZSBhIGN1c3RvbWVyIGNvbXBsYWluZWQ/IFRoYXQgaXMgbm90IGEgZ29vZCBlbm91
Z2ggcmVhc29uIGluIG15IG9waW5pb24uIExvZyBtZXNzYWdlcywgb2Z0ZW4gZ3JlcHBlZCBmb3Is
IGFyZSBhbiBpbnRlcmZhY2Ugd2hpY2ggc2hvdWxkIG9ubHkgYmUgY2hhbmdlZCB3aXRoIGNhdXRp
b24uDQoNCkRvbjogSXQgd2FzIG1hbnkgY3VzdG9tZXJzLiBFbm91Z2ggdG8gaGF2ZSBvdXIgY3Vz
dG9tZXIgc3VwcG9ydCBhc2sgZm9yIHRoZSBtZXNzYWdlcyB0byBiZSByZWRhY3RlZC4gQWxzbywg
c29tZSBvZiB0aGUgbWVzc2FnZXMgd2VyZSBlcnJvbmVvdXMgY2F1c2luZyB5ZXQgbW9yZSBjb25m
dXNpb24uIEknbSBzb3JyeSwgYnV0IHRoZXkgaGF2ZSB0byBiZSByZW1vdmVkLg0KDQoNCklmIHRo
ZXNlIGFic2VudCBmZWF0dXJlIG1lc3NhZ2Ugd2VyZSBwcmVzZW50IGZvciBhIGxvbmcgdGltZSwg
YW5kIHlvdSBzdWRkZW5seSByZW1vdmUgdGhlbSwgcGVvcGxlIGxvb2tpbmcgYSBuZXdlciBMaW51
eCBrZXJuZWwgbWVzc2FnZXMsIHVzZXJzIGNvbmNsdWRlIHRoZSBmZWF0dXJlIGlzIHN1cHBvcnRl
ZCBub3cuIFRoYXQgaXMgcXVpdGUgYSBkb3duc2lkZSBpbiBteSBvcGluaW9uLg0KDQo+IFdlIG1h
eSBhZGQgdGhlbSBiYWNrIGF0IHNvbWUgcG9pbnQgYnV0IHdlIGhhdmUgdGFrZW4gdGhlbSBvdXQg
b2Ygb3VyIA0KPiBvdXQtb2YtYm94IGRyaXZlciBhbHNvIHNvIHdlIGhvcGUgdG8ga2VlcCB0aGUg
ZHJpdmVyIGNvZGUgaW4gc3luYy4NClRoYXTigJlzIHdoeSB5b3Ugc2hvdWxkIGRldmVsb3AgZm9y
IExpbnV4IG1hc3RlciBicmFuY2ggYW5kIHVwc3RyZWFtDQoqZmlyc3QqIHRvIGdldCBleHRlcm5h
bCByZXZpZXdzLiBUaGF0IGFyZ3VtZW50IHNob3VsZCBub3QgY291bnQgZm9yIExpbnV4IHVwc3Ry
ZWFtIHJldmlld3MgaW4gbXkgb3Bpbmlvbi4NCg0KRG9uOiBUaGFua3MgZm9yIHlvdXIgc3VnZ2Vz
dGlvbi4gT3VyIG1vZGVsIGhhcyBhIGxvdCBvZiBpbnRlcm5hbCByZXZpZXdzLCB0aGVuIHNldmVy
YWwgd2Vla3Mgb3IgbW9yZSBvZiB0ZXN0aW5nIGJlZm9yZSB3ZSBhZGQgcGF0Y2hlcyB0byB0aGUg
a2VybmVsLiBNb3JlIGF1dG9tYXRlZCB0ZXN0cyBhcmUgYWRkZWQgZGFpbHkuIEFueSBjaGFuZ2Vz
IGZyb20gdGhlIGtlcm5lbCBjb21tdW5pdHkgYXJlIGluY2x1ZGVkIGluIG91ciBtb2RlbC4NCg0K
DQpLaW5kIHJlZ2FyZHMsDQoNClBhdWwNCg0KDQo+PiBSZXZpZXdlZC1ieTogTWlrZSBNY0dvd2Vu
IDxtaWtlLm1jZ293ZW5AbWljcm9jaGlwLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBTY290dCBCZW5l
c2ggPHNjb3R0LmJlbmVzaEBtaWNyb2NoaXAuY29tPg0KPj4gUmV2aWV3ZWQtYnk6IFNjb3R0IFRl
ZWwgPHNjb3R0LnRlZWxAbWljcm9jaGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEtldmluIEJh
cm5ldHQgPGtldmluLmJhcm5ldHRAbWljcm9jaGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IERv
biBCcmFjZSA8ZG9uLmJyYWNlQG1pY3JvY2hpcC5jb20+DQo+PiAtLS0NCj4+ICAgIGRyaXZlcnMv
c2NzaS9zbWFydHBxaS9zbWFydHBxaV9pbml0LmMgfCA1ICstLS0tDQo+PiAgICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9pbml0LmMNCj4+IGIvZHJpdmVycy9zY3Np
L3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYw0KPj4gaW5kZXggZDk3N2M3YjMwZDVjLi43OTU4MzE2
ODQxYTQgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5p
dC5jDQo+PiArKysgYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+PiBA
QCAtNzI1NSwxMSArNzI1NSw4IEBAIHN0cnVjdCBwcWlfZmlybXdhcmVfZmVhdHVyZSB7DQo+PiAg
ICBzdGF0aWMgdm9pZCBwcWlfZmlybXdhcmVfZmVhdHVyZV9zdGF0dXMoc3RydWN0IHBxaV9jdHJs
X2luZm8gKmN0cmxfaW5mbywNCj4+ICAgICAgICBzdHJ1Y3QgcHFpX2Zpcm13YXJlX2ZlYXR1cmUg
KmZpcm13YXJlX2ZlYXR1cmUpDQo+PiAgICB7DQo+PiAtICAgICBpZiAoIWZpcm13YXJlX2ZlYXR1
cmUtPnN1cHBvcnRlZCkgew0KPj4gLSAgICAgICAgICAgICBkZXZfaW5mbygmY3RybF9pbmZvLT5w
Y2lfZGV2LT5kZXYsICIlcyBub3Qgc3VwcG9ydGVkIGJ5IGNvbnRyb2xsZXJcbiIsDQo+PiAtICAg
ICAgICAgICAgICAgICAgICAgZmlybXdhcmVfZmVhdHVyZS0+ZmVhdHVyZV9uYW1lKTsNCj4+ICsg
ICAgIGlmICghZmlybXdhcmVfZmVhdHVyZS0+c3VwcG9ydGVkKQ0KPj4gICAgICAgICAgICAgICAg
cmV0dXJuOw0KPj4gLSAgICAgfQ0KPj4NCj4+ICAgICAgICBpZiAoZmlybXdhcmVfZmVhdHVyZS0+
ZW5hYmxlZCkgew0KPj4gICAgICAgICAgICAgICAgZGV2X2luZm8oJmN0cmxfaW5mby0+cGNpX2Rl
di0+ZGV2LA0KPj4NCg==
