Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B440C07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 21:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF2061451
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 21:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhGHViP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 17:38:15 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23478 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGHViO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 17:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625780131; x=1657316131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hwG1A4+dOJAHq8MVH5Raebnwn1vIw6oMhnOVpnVMC4Q=;
  b=SygzNJirCdKHsxMdj2zoHEjo39PXEBsCQAXEUgmVEn+6ld0FET4stEoR
   e4FfOXJRmkjnFouPLOvg5lNpxwS+Zk/+eW43KEwKQHQT+ea5oueZiXlcp
   Lt9XjZRQRJG0EyxRsHhQn1OHVizaYA6F1hnkuACDr3J4gIHtBlJz464HF
   GxGE+aT7IEtPXyti++enBkItiH5RxFw1mLDDmr5o1fefhlPP+UOkEda6B
   d34+oariOMGlx293p/sGTV1Dc+Ya3JbxNJ5bTOEA4/F8zsXv3PY+jMpig
   U/w7AUVE1AIo3sLYdFmW/jdYsFP03tDe6uXPgcjIYKxMYWFCEfHYG8HQ/
   g==;
IronPort-SDR: rO6pSLW/ULPcCKnIVKLORQX6ZTXPF7wv9Ug1mQ6L/V3KWjqQRgzrHMuvLBmrHziZnXaO2pOJ/W
 e4RPzJsd6MYRaoRh8vvjaA2YIeYEPmnE5W/HMjwUDBju6yfm1bT/XED903i4Isi0UsW4lWz1Du
 yPk+l932By2NssFeA32zJX76aXCd4UXT0OW50T6Kk+B7boKzh9VNcQONPWTxHZIfy+rRi6DuPj
 rejQdPLsOQ42RtCYrEDYoR9gJ1Vq02KU4cDeSPylcKfMh1oAffr3nqHt7dJ11yTZP41jouZqov
 cI0=
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="135135903"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2021 14:35:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 14:35:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 8 Jul 2021 14:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=km+qOG8ZVgt2HvY58o2gGuBHhbeK89LIpyPMImcpvwSOsjJLuG5tB7CRtiSISg5VnUMCpdH+NZyktb/FLOwhqwuDOrId1FgCCoSkBLdIPOr4pAViPu1hPJzfMmLUMYmHOEjW3iDiQqS4wQMEBoSwbsGasLyFCfj2QqZWa7xMv7gmXPCHZLv8AEva6QAKfmpninghyhqmXLrdQm22BjCpGG3w7l4A9FHlekX+Ldmaag/hLPYNXiEKhOnSXevDDA/2UXbfjcGxt0fvCqDJcfxhLIcwfG9aR164+Gv/gVFfBD/DrdDgrHWr25lxtHVu65TRMZmSo4VG5r1T55sotKUGLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwG1A4+dOJAHq8MVH5Raebnwn1vIw6oMhnOVpnVMC4Q=;
 b=O4QBW/1D7N/d4H+JW7g/FjUm4we0FhOwQhmNcZvWs+sARjRqf2dzO4+4S8mr5OukasQhJUITwKwjn69STC7VPI0zHJsMLBaeTmlx0BneFnWxs9JjAZSGEGXjotyUSp41pgMiFri4b28RWOqHVjt3iyK7gCieCmYLaaG3g1CA+aGeCl8FZVRK7NfNz9rKjgloFrHgNZZO16z+f3A+fBXcAC3tAX9HJwHc4kQBwyp6FEN+1kCf+J3sJhkUCv2Ik1dEQWRsXaK9tGdeAJT2MnSUB7jRFCHNUWTmRDYdCJDpVdiUUvw0lIPDEkND/dg+FJJDc30HFRMxD2vRbzeFpi3VcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwG1A4+dOJAHq8MVH5Raebnwn1vIw6oMhnOVpnVMC4Q=;
 b=iXwWcCJ3kVcUNcXuX42NzXueC1p76lp29MwITpQBHttml/vYNZZh9sZtbiLCwrMjPiyXG45eLK5N73M3VxlUdrcMOpuFMMb4A2WIeYrXvHKnSuqyenkzxQuoDJzLceU81IS8ycFt3QS2dvujDD3yRrrsFAZ++OFEnVqE+5WlKVU=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 21:35:25 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 21:35:25 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <hch@infradead.org>,
        <martin.peterson@oracle.com>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <Mike.McGowen@microchip.com>, <Murthy.Bhat@microchip.com>,
        <Balsundar.P@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 6/9] smartpqi: add PCI-ID for new Norsi
 controller
Thread-Topic: [smartpqi updates PATCH 6/9] smartpqi: add PCI-ID for new Norsi
 controller
Thread-Index: AQHXcwMPNeI6PvhhK0mYVvAoOHttLqs5nBgg
Date:   Thu, 8 Jul 2021 21:35:25 +0000
Message-ID: <SN6PR11MB2848BC648DBC47B6EB4F1085E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-7-don.brace@microchip.com>
 <acaaf271-10dd-6dee-0d47-77d00e794103@molgen.mpg.de>
In-Reply-To: <acaaf271-10dd-6dee-0d47-77d00e794103@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5668d4f4-c2aa-499b-53ff-08d942584c83
x-ms-traffictypediagnostic: SA2PR11MB5068:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB50689C8AF57C4DEBCC82871DE1199@SA2PR11MB5068.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RcfZ5Zzbd+JBbLGt1FUvJbFbIP0P9RQ0G3HWwN1UR5u2/T6/is86ypyYVxzJYOLo0BMc15pCp4QhCwkAEQDRA+YM1LCuEHP7Y63Rx+5nvG/Tks5BIwWl3oHfufwJ0B5f8g0BiVLz3kFEBTYvFr+4rn3tVgvl/h183ZfCDh2McEmtZkBckJzHzFVNr9eXuUNLSBUrnXqURRCEZmQgksiF2yAfb776/NA4rEJ0os9LXSBeeV4XI6Tcj31yrqzyv1rizb9tVHHY9tBlDOsLliChboPSOJhSrzgk411+CDxM4DKHrF/b0zHHYIluw8T9+cQxM8oeHD6NFv4ui16CIZeq5PIaAJSnjhyzp8aQ63Z0jzquTJX35U8Xy1jX0AHK5z3av/JRoo+Ssv/Rw0ETQjI2yJekNzD3MJ+Oj5lPwTxKImxkE21yq9yLu729gyZ0d/asyTAjkjfrMwfNtJB2ecHX5qKN+keSDz3pBDQNSr2TM8IRz4ROrVrH9QmhA8VP2bWZgOh40kK3CVu06GendN1sQoN3GSf6jx/gFui6LASN7wREylF0Jb/lDgNZHqELWM2+ettLQ8TT38rqX/HVdt4bmXXsCRuQQ1XJeAWh8VlSOqALTYyTAXCIHyKNNzfwimO6WQ+CPP8xeZ2hdrIZvolIsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(186003)(8676002)(55016002)(9686003)(54906003)(86362001)(76116006)(7416002)(2906002)(26005)(8936002)(6506007)(110136005)(83380400001)(66446008)(64756008)(15650500001)(66556008)(66946007)(316002)(71200400001)(38100700002)(478600001)(122000001)(5660300002)(52536014)(4326008)(33656002)(7696005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXM3Sy9aRlB4aWVZTFVsS3JrTDhGY2NDcFF6WnM2bHROTlhKaU5mSFozdll5?=
 =?utf-8?B?bldvWlgzbExTdjBWTXkxK3JjdVJiSHVnLzRaRHBYQjA3bnJOVTVkWkFiUjY3?=
 =?utf-8?B?TktGRjRCcmNRTlRIdnRoV0d4dG44Nlg0YmtnajVNWC9GTklJcm9MQy82U3NI?=
 =?utf-8?B?MWxrMENzT05ieGVrYWpPMkp2bUx2c2hEUFp3V3ZpQzV3V1pMSnNrUm9CeHQ2?=
 =?utf-8?B?SlZWOTVDV1NtYXFZbFZzdDUxSFhhTjNZa20rR2Y0d01JRzZoUC9Xdmw5cWtk?=
 =?utf-8?B?RUg2cFN6VE9WQ2ZZV2c3eitwL3R3eXRoRjAzUFFDemhtUFFmWHBqcVpadnVj?=
 =?utf-8?B?dlYzSDhWbGgvV2pFMzU5MURrSjg2M0pGMmMyQXpOV3lBbDFFNXc1bitWY2F3?=
 =?utf-8?B?V1AxVVl6S0pGS3hldjJXRHowRW5jZlA1MmowSSswRHpLVlczTTJxZm9Eaktu?=
 =?utf-8?B?N0pTT21XMEM2cVNHZWFTcE9RZGNFdzJ5dEhibk41UG5MZEVIdlM5L1ZPeExM?=
 =?utf-8?B?VUExbHBmcERjTm5BM09HazV1MFJxRlllc1dLSG8yUkhvNy9wQis1ckxxYURt?=
 =?utf-8?B?QzhsSEpYd1RjQWxhZEtWVnlvOU9uNDlaVFJtNk1nZS9qOGRzTkJPdTdGMk00?=
 =?utf-8?B?bVJ0TkF4UzJtNkY3UWhBaTdJeE5CWmVaWEV6dXRtNW1HQTUwaU53QTNJaWVO?=
 =?utf-8?B?em5uL0xzbFNWVjlYRU1NMjkxc3RuU25oem9WZWs0SWpqTEhjUFg3ZFBFeUlP?=
 =?utf-8?B?V1VzSzRicXNxTFJjSzBpQkRqOWk0dXJQRUlnNk55VXZNeFh4bThIckNFL0Q2?=
 =?utf-8?B?MFlIeWNkampJWXBUbWRsQ1oxb1p2dEJCUHp1Z2lkYUJlMzB6NE00TjZ1WWl2?=
 =?utf-8?B?QzRtSSt0UFI0eEhZMnMxZzVDTnBmRWtsYzB2QXcya29kTVZMUU1qV0hIRkFr?=
 =?utf-8?B?UlBjY2p2eWVTK0FQYnlPeVRpbzdsZ2ZNT1JQOU9ocjF4NmlxR2UzL3VVbjlE?=
 =?utf-8?B?cjdiUFVOY1dCamhjZHFwWEJaTW9lL1VsdHp4S0VNZGlUTEJMdm4xa3huQmJV?=
 =?utf-8?B?cU5DMHlZRS8rbmR5akFraUo1YzMraURIcU5uWWpjSkZrQ0tlRmRCcXdoZG41?=
 =?utf-8?B?MEhXeXlPL2YxT0dBMGMyQWNLSlgrU3ZWak9VWHFINWVYSkJMY3BEQWZCWEZN?=
 =?utf-8?B?SkxwZGhNanpzRWNSOE12T2xKWXNsZDdoNkpmQUhZUzFtL3kzaFYrb2FGeTlL?=
 =?utf-8?B?Y1JwRmJMUEhPa29OKy9JRUcraG5ndnRCMHV4Z29iY1NLS3Q2bzNvTGIycytj?=
 =?utf-8?B?cWM5WjY1TndqTWFGZW50eExlOHNxZVdnMWJ2aGxTQ1g3ME9xT0hsU2tpRVZo?=
 =?utf-8?B?WXYvbXhyd0VENE4veFlVams3VEFwUXlkUXluN3hLa2ljWlRiYXptVzNmVjJu?=
 =?utf-8?B?M1lxU2lEMGRwalovc1IwcEw5ZmpISHE4MzJwRkJRaFRyWTMwajBqOHRvNDcv?=
 =?utf-8?B?N0lpZ2I5M0V3KzRObEdyRkpaWnhxWHVyQW1UU1c0bEVQU1dJOTVzTnMzWWxW?=
 =?utf-8?B?czVFMHRZR2tlSHRXNFl3L1dkbVVndUpySFh3OXNDZEhhdVI3TTBUTTBCbHFD?=
 =?utf-8?B?Sk1yTnBaTGE4WUswSEF6ZU5NNExNbDR4OGtjbWIxT0hlYW52Q2RMSVNKNElB?=
 =?utf-8?B?aE03YnN5bzFvdlB0eTErQXZNTHdFSFF5WUpPZUVVdXFsTGQ5aDhBZmo0V1Jy?=
 =?utf-8?Q?zkF6lKkYoYETB6xgnk7wjdah4cOv/b3IZn0YUYd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5668d4f4-c2aa-499b-53ff-08d942584c83
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 21:35:25.6427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NE8H/F5Ykjaa7pBbYqirmhAOvLdNU3kXH3Za//4GiEz7BjGtQJb6fTw7opM4nG+zkyvEe+li7gXMH0Og2v8ymg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogUGF1bCBNZW56ZWwgW21haWx0bzpwbWVuemVsQG1vbGdlbi5tcGcuZGVdIA0KU3ViamVj
dDogUmU6IFtzbWFydHBxaSB1cGRhdGVzIFBBVENIIDYvOV0gc21hcnRwcWk6IGFkZCBQQ0ktSUQg
Zm9yIG5ldyBOb3JzaSBjb250cm9sbGVyDQoNCkRlYXIgRG9uLCBkZWFyIE1pa2UsDQoNCg0KQW0g
MDYuMDcuMjEgdW0gMjA6MTYgc2NocmllYiBEb24gQnJhY2U6DQo+IEZyb206IE1pa2UgTWNHb3dl
biA8bWlrZS5tY2dvd2VuQG1pY3JvY2hpcC5jb20+DQoNCkNhbiB5b3UgcGxlYXNlIG1lbnRpb24g
dGhlIGRldmljZSBJRCBhbmQgbmFtZSBpbiB0aGUgZ2l0IGNvbW1pdCBtZXNzYWdlLCBzbyBpdCBj
YW4gYmUgY29tcGFyZWQgdG8gdGhlIGNvZGUgY2hhbmdlPyBTZWUgKltzbWFydHBxaSB1cGRhdGVz
IFBBVENIIDEvOV0gc21hcnRwcWk6IGFkZCBwY2kgaWQgZm9yIEgzQyBjb250cm9sbGVyKiBhcyBh
biBleGFtcGxlLg0KDQoNCktpbmQgcmVnYXJkcywNCg0KUGF1bA0KDQpEb246IA0KVXBkYXRlZCBw
YXRjaCB0aXRsZSB0byByZWZsZWN0IHRoZSBjb250cm9sbGVyLg0KQWRkZWQgbW9yZSB0byB0aGUg
cGF0Y2ggZGVzY3JpcHRpb24uDQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCg0KPiBSZXZp
ZXdlZC1ieTogS2V2aW4gQmFybmV0dCA8a2V2aW4uYmFybmV0dEBtaWNyb2NoaXAuY29tPg0KPiBS
ZXZpZXdlZC1ieTogU2NvdHQgQmVuZXNoIDxzY290dC5iZW5lc2hAbWljcm9jaGlwLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IFNjb3R0IFRlZWwgPHNjb3R0LnRlZWxAbWljcm9jaGlwLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogTWlrZSBNY0dvd2VuIDxtaWtlLm1jZ293ZW5AbWljcm9jaGlwLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9jaGlwLmNvbT4NCj4gLS0t
DQo+ICAgZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYyB8IDQgKysrKw0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9pbml0LmMgDQo+IGIvZHJpdmVycy9zY3NpL3NtYXJ0
cHFpL3NtYXJ0cHFpX2luaXQuYw0KPiBpbmRleCAxMTk1ZTcwYjZlYzMuLmE4ZGZiNjEwMTgzMCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYw0KPiAr
KysgYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+IEBAIC05MTc4LDYg
KzkxNzgsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkIHBxaV9wY2lfaWRf
dGFibGVbXSA9IHsNCj4gICAgICAgICAgICAgICBQQ0lfREVWSUNFX1NVQihQQ0lfVkVORE9SX0lE
X0FEQVBURUMyLCAweDAyOGYsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUENJX1ZF
TkRPUl9JRF9HSUdBQllURSwgMHgxMDAwKQ0KPiAgICAgICB9LA0KPiArICAgICB7DQo+ICsgICAg
ICAgICAgICAgUENJX0RFVklDRV9TVUIoUENJX1ZFTkRPUl9JRF9BREFQVEVDMiwgMHgwMjhmLA0K
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MWRmYywgMHgzMTYxKQ0KPiArICAgICB9
LA0KPiAgICAgICB7DQo+ICAgICAgICAgICAgICAgUENJX0RFVklDRV9TVUIoUENJX1ZFTkRPUl9J
RF9BREFQVEVDMiwgMHgwMjhmLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBDSV9B
TllfSUQsIFBDSV9BTllfSUQpDQo+DQo=
