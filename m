Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A11C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE9561423
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 20:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhJEUZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 16:25:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28796 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhJEUZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 16:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633465405; x=1665001405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D7AjfFyqoSeuT/ZifX5/okZ1+rjRr7egLR2k8vPp4NI=;
  b=ItyOaepqqx2K7Quoh6an3gfPsLWMRCyK5jD8uTGFrlU4FAYKK8K6dNJ/
   yE1AlZ7LstCvb4pkcBB3yOpuzOD7miCC2GJUyphpycKEXdAIStywThXIo
   LSNU5haFSFbvcJ/5cUucy3Fkr7v6ZWorgshoSUXHxIJNaVpyz3UF0t6K7
   f4wSl2mgy+ufdEZFB/YPVS/cupfhTPjZdxk/ukskkApBSZHWJNUuvHSVI
   PBSS4S30ah9v6UH97YpcZcR1sLAfwImpSLvlg4aaP5PGNN97mwH1KO0jk
   hw4H1Nef1AQ2IZ8MV6v6frgTOWAkUwFDvtX6zzJuBP7AIdYgitK4ag2E7
   Q==;
IronPort-SDR: 51WFveggk/9uJB2IkzwhAHEOBLErOfChzYRrTnyJoNXChqf+eWGKyJJWR9I6w+RsMafr6IqoYN
 0eza0DEdoZU5XXIg41Bq1IjFNMD6YLOTTJZMHFuCAKijjMIsjkOUUqOvTbBf8U5uD79pp5rP8M
 493zdJixS6wn8O5pdx68ZMwGJZI5k429/7BOnQTB/88Mfb+MHmNeqSeBTLKN/FO46D3CjZOwuy
 PvVj2rAvZ7DNK/pvsQBI99ASiI55UD+QK3AtjXMUjiTHhMYWStYpkSUchEbPVFUIfq4bEBMQC4
 PLurSNzeiCtEi/HUCgxVMykB
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="139152943"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Oct 2021 13:23:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 5 Oct 2021 13:23:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Tue, 5 Oct 2021 13:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQJo7xKRi1EVOOi6V+lDpxb4+jKStm12MgBfuHfBXWddWIiiAPiTy/g8ddED5V6Q01NDyvQDcwFKUqfAv9RnfSwZ6edDSVjFa27mb9DBsTc9aWX0545h8IB7ooeLpz5rLbE9JZKiMOxZMMY9VwYbzemCOjHc6zYCEXJxK/45IAlHGozfkPTzpxSqvD116MrP+0iOyGkYSk7HZhK4A3chwRJeDlMxDm5ztQmPRMbYs3mb1x9V4XIFBr8a2CgZWfv8ppZ9WX4a77yVXZzAVZTSXNWpYd34IjVIBoaxup0s/oEI1snAiP3UdUMzexzlX1pofg57ZfYKiQUH+resbilRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7AjfFyqoSeuT/ZifX5/okZ1+rjRr7egLR2k8vPp4NI=;
 b=eweLPige+VICZr9UWDGbMrQDveDX9u61914vuahrqOZxzEQXfwyCh8BUH4p8hAizc+sjHpKL0xj3oCym4rroUZqa+B+1hPBu+CHqzDpt6sr3EIFeGMnbPw8g5yxZOOrgwOZvnJ2iMK4MQEL/E3CL5Fbc41+zG0nFMAnriNwtn35rLVWa8RvD7+dObB9piqRZIgim0IxeSDNPmPVPpB0lYgAlyjITQyU86gaNg2OJ4gxAMLohnY7rFFeyXO7WYQ7wOesO2xtgoguGdmSSAR7bALer6RIcaV1ZOoLdl+A4IgxEeOAiG1O2VJL43IyUeJeRwOWBx1Njol5QcgG/Y70+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7AjfFyqoSeuT/ZifX5/okZ1+rjRr7egLR2k8vPp4NI=;
 b=lvn3PiAJoWOVAOKeRESefyGIfQJ+hmsciUdxr68uhHll8SPzdcWqYyb/MZ1MQUqLbEghyIh1gBvmWP/Yhzrv894BD2fm9/WFKi/9WwW3cBsmR9+q7pFwAztn/Ksu/NruU80QwY96HtW3Tr6O57FHGnKkEqR8eT0krNw/4AY8e64=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 20:23:22 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1%7]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 20:23:22 +0000
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
Subject: RE: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
Thread-Topic: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
Thread-Index: AQHXtMRDyP+n2ZsizkKB3YupoAAg6qu90n0AgAcPpHA=
Date:   Tue, 5 Oct 2021 20:23:22 +0000
Message-ID: <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-10-don.brace@microchip.com>
 <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
In-Reply-To: <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73682721-6c1f-40d5-87e3-08d9883dfa64
x-ms-traffictypediagnostic: SA2PR11MB4796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB47964497A488C81EBDFDCD28E1AF9@SA2PR11MB4796.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgTk6mzHj3hgaGrCtrHnKNsIywBzSDeFMUG+BV+dpXmuxEKdZ1ggi6eTpoK6MZmU1bzdBrUmRx0Qk8L4Ou2YCRiWIGPX6TNDCogVwizUpERK9wSAH397nxOb2e9BcMgTPdsvLEl6ridj95oqRk+OZALYVyurhTD9zPZqznRlotXNzysbufT2OO8KQEAzHnPkgF55gLj2VmYqRv6PMKDmnfJthVDuZnkcbdlNJ/ZV8vWn42/34McfIC4W+cCJ3APZtgB65k7qmtoCMwOc2TnCydlK5H96a7lavfb6Bp9tC6wJJU8eBWclAnFBzIRBRw7aGHpBQDwkkJiymPEozDqLEiGyJS3KVnZCW1SylIdRh25cY3lXbQdoc8vczrNa6e4xVcVX0QE8JGyNtWgko3vAJ6CLjEG0sthZ8uHb32YQW/gWnQO2+SmqMuKhXq5dxfQB4bTcVkEzLtyJcQQXWjRRNW0NwJfHxiqZKFRwxwawFIuDgfX4W0nuVkwVGC0GD145IY5ywLARcbaukB5DDqVDVDQPxupXyB7wlafHssiqz9TAF0vJz6KixkVaGb6XbUYsFecVNkqBFeJXRn3+s9dXY2FjAJ+JVn6fndVxZF0w2R/V3qS3XTLoDFvKS/9eLkoZpLjOaE1TCQhxM8qXMZexFj/ko1I2ZaFh1ffW5YAQkTIXVh4dYvq6pG+qxYaXz8tj8POiVG+j0RS910jYCFPQ3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(52536014)(83380400001)(8676002)(55016002)(33656002)(15650500001)(86362001)(38070700005)(8936002)(5660300002)(9686003)(71200400001)(66946007)(7416002)(66446008)(6916009)(508600001)(64756008)(26005)(316002)(66556008)(38100700002)(66476007)(54906003)(7696005)(2906002)(186003)(122000001)(6506007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cG9qT2JkWGpEQUFFNkRwRnJoTG9RUVBoTE4rMWYwZ3FoWHRENFZ3UmFYUnZK?=
 =?utf-8?B?MytsOFREQndGdGhPL3lXbHBEb21BZDBoMjZyWU5GbGNYWlcwZWt4RkV1NWJH?=
 =?utf-8?B?VjNLd0cyL0did2VkdGpsdEZ0UW9OKzdWbGUwdDlaT1ZFTzNjaVE0MHlUclZq?=
 =?utf-8?B?TVRQeFJYYWl5ditjdXVVNGR4VmRuK0tTM0s2R2xQVFZ3Zm5aY1g0UTIwMFFX?=
 =?utf-8?B?QzdIWmtwVys3YmRTWlRvMkx4VC9LY3l4N2hZeXVlSk03VGdrVkRlamU2TkV2?=
 =?utf-8?B?SEdOeGMycnIyMjRKdkxjTHZFVnZFaXlBTTZFY1dWeExrWjdYTFFtek5qWEU1?=
 =?utf-8?B?QzRwQ0tycnpnV3JhT3laaVNyRkNzWEl3Z3JyUUtXS01kdmZ0RGVGWHVRQWZU?=
 =?utf-8?B?ZHNWZlNDZUVlNXZBejBYS3ZXTmY0ejB2NFY4QVpQK2prOWNaeEVDQWtIQkNN?=
 =?utf-8?B?NEh0dk9tYzhFaDhFNVpTQ1J1Zk1vSDRVR0FzQlRDRFRaTUgzNXRvSy9Ka2Rz?=
 =?utf-8?B?OE0xZkxTeGhqTTErRkliaWtPdmtyYmxsaUlkcnppOHord0gxbWJhVHdmNmpt?=
 =?utf-8?B?VnRsRjc0M1V1T3o4cng1eTVES1FuS1lZcDc4TDJqTmlCTDNZa3V0MDFCdFI2?=
 =?utf-8?B?UmpOdzNkdWZ6ZGsvSVY3c0Z5UUxLSzJCL3FuV1lpZ0tadC85TVFwNk45R3gx?=
 =?utf-8?B?b3BIU3cxYkFZNlVPdEMxRDdzc0ZvSGZiNU1YaW02NVJUUE03OFdUbkNHV2pE?=
 =?utf-8?B?UlZ2dU4vbi9JY0p1Um9VbXlSV2FDMnNubUo4aTR0RithT3k0a25ZeDgvN2FU?=
 =?utf-8?B?VnhrdW5SaENGWXM1Tm93NU1DaDB3dEZTUU1aNjJkNUhTeHRLU0Q2MHlzVnVV?=
 =?utf-8?B?V0srMWVVR0p6NElSTzJKUzk5WTRrRVJ4QU5EclFrdkJuS1JwcDA4cEt1VUlW?=
 =?utf-8?B?N2dsZGhUYms5T0VrMXpxRTc0T1BDRDkza0MyU3R5bWJ5RTRHQ3NYVXlsbXpB?=
 =?utf-8?B?cnFZWGRxeXUrTjJOdG1YbGQ3bEdsSXhZZjArY3NLSGtyZHIvb0hXWEwzeklj?=
 =?utf-8?B?emlucUFWdyszNUdCTmZhaDNyd0FKWS9ieldlNEg3YStDZ3ROa2lGcE9vdXlk?=
 =?utf-8?B?N3pycVZ3RURvSmhwMW1Rc1RtMnI1UGl5UVF6QytiQ0Z4ZXFZb0xXQWJrQisz?=
 =?utf-8?B?aTBKMFM1cCtnaldxTllpNUVDaTluc1J2dDNka1FZeHhxQU5md2lIVXNrUWl3?=
 =?utf-8?B?UW9FQWRna3BhN3VCemZWTXU1c3RSREZnTTAxUUFVVEI5enc1czlLVWFyUFYy?=
 =?utf-8?B?NzlaOFdtSENHU0FrYVZZVFBuQ1ZZeU5WbzJ3TWp0Mm9pVnFVZE5OU3BrU3VW?=
 =?utf-8?B?T3F2cE9MMFA3dHpoczRKTmcrdzFyQ0UrYkZOVlFUY1BGYTREZTJkMVFPVVE5?=
 =?utf-8?B?Y0NDSXVmRjhYS3dNb2VCMnIrUFRUamNWTXVJckFyaHg0Z25iZ0duWlN3SEFR?=
 =?utf-8?B?VStRdjR6NzgyalNWOExTMHNRRjhweFZUSVFUZFR1ZEtvZFBNRDlmdGNEaFVw?=
 =?utf-8?B?TEc1WVlYMG15SysrZFVxdnd3UVl5eG5zU0xoaU5nYnpYbVdETjBvRkJTbFVL?=
 =?utf-8?B?ckJJY1NQZ2JJUjZyU0EyOXEzVFd1L1pVd29oYm5JWU5EVnZZeS9wbWZXZU5w?=
 =?utf-8?B?ejcyTUVQekxQV2hjSTdFVUlNOUNiYWhxZUdtdHM4dytBdWRXSHk1UERyYllB?=
 =?utf-8?Q?usXwT9LII5ttxc5+K/B3VrVHzVl/D0Z/jQ5bgHp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73682721-6c1f-40d5-87e3-08d9883dfa64
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 20:23:22.2642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wcNlUX8QVBVWY4qiIY69HOUZy73pMGcepOgovNB+Uqo9y+2ykSyHSPutuhntpNqS6UHSwWAs8wF2201Qnxctxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogUGF1bCBNZW56ZWwgW21haWx0bzpwbWVuemVsQG1vbGdlbi5tcGcuZGVdIA0KDQpTdWJq
ZWN0OiBSZTogW3NtYXJ0cHFpIHVwZGF0ZXMgUEFUQ0ggVjIgMDkvMTFdIHNtYXJ0cHFpOiBmaXgg
ZHVwbGljYXRlIGRldmljZSBub2RlcyBmb3IgdGFwZSBjaGFuZ2Vycw0KDQpEZWFyIEtldmluLCBk
ZWFyIERvbiwNCj4gT3VyIGNvbnRyb2xsZXIgRlcgbGlzdHMgYm90aCBMVU5zIGluIHRoZSBSUEwg
cmVzdWx0cy4NCg0KUGxlYXNlIGRvY3VtZW50IHRoZSBmaXJtd2FyZSB2ZXJzaW9uIChhbmQgY29u
dHJvbGxlcikgeW91IHRlc3RlZCB3aXRoIGluIHRoZSBjb21taXQgbWVzc2FnZS4NCg0KRE9OOiBE
b25lIGluIFYzLCB0aGFua3MgZm9yIHlvdXIgcmV2aWV3Lg0KDQpTaG9ydGx5IGRlc2NyaWJpbmcg
dGhlIGltcGxlbWVudGF0aW9uIChuZXcgc3RydWN0IG1lbWJlciBpZ25vcmVfZGV2aWNlKSB3b3Vs
ZCBiZSBuaWNlLg0KRE9OOiBEb24gaW4gVjMsIHRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCj4g
ICAgICAgdTggICAgICByZXNjYW4gOiAxOw0KPiArICAgICB1OCAgICAgIGlnbm9yZV9kZXZpY2Ug
OiAxOw0KDQpXaHkgbm90IHR5cGUgYm9vbD8NCkRvbjogVGhleSBib3RoIHRha2UgdGhlIHNhbWUg
YW1vdW50IG9mIG1lbW9yeSBhbmQgc2luY2UgdGhlIG90aGVyIG1lbWJlcnMgYXJlIGFsc28gdTgs
IHRoZSBuZXcgbWVtYmVyIHdhcyBhbHNvIHU4IGZvciBjb25zaXN0ZW5jeS4NCg0KPiAtICAgICAg
ICAgICAgICAgICAgICAgZGV2aWNlLT5sdW4gPSBzZGV2LT5sdW47DQo+IC0gICAgICAgICAgICAg
ICAgICAgICBkZXZpY2UtPnRhcmdldF9sdW5fdmFsaWQgPSB0cnVlOw0KDQpPZmYgdG9waWMsIHdp
dGggYHU4IHRhcmdldF9sdW5fdmFsaWQgOiAxYCwgd2h5IGlzIGB0cnVlYCB1c2VkLg0KRG9uOiBI
YXMgdGhlIHNhbWUgYmVoYXZpb3IsIGFuZCBjYXJyaWVkIGZvcndhcmQgZnJvbSBvdGhlciBtZW1i
ZXIgZmllbGRzLg0KDQo+ICsgICAgICAgICAgICAgICAgICAgICBpZiAoZGV2aWNlLT50YXJnZXRf
bHVuX3ZhbGlkKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldmljZS0+aWdu
b3JlX2RldmljZSA9IHRydWU7DQo+ICsgICAgICAgICAgICAgICAgICAgICB9IGVsc2Ugew0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXZpY2UtPnRhcmdldCA9IHNkZXZfaWQoc2Rl
dik7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldmljZS0+bHVuID0gc2Rldi0+
bHVuOw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXZpY2UtPnRhcmdldF9sdW5f
dmFsaWQgPSB0cnVlOw0KPiArICAgICAgICAgICAgICAgICAgICAgfQ0KDQpJZiB0aGUgTFVOIHNo
b3VsZCBiZSBpZ25vcmVkLCBpcyBpdCBhY3R1YWxseSB2YWxpZD8gV2h5IG5vdCBleHRlbmQgdGFy
Z2V0X2x1bl92YWxpZCBhbmQgYWRkIGEgdGhpcmQgb3B0aW9uIChlbnVtcz8pIHRvIGlnbm9yZSBp
dD8NCg0KRG9uOiBUaGUgcmVhc29uIGlzIHRoYXQgaXQgdGFrZXMgYWR2YW50YWdlIG9mIHRoZSBv
cmRlciB0aGUgZGV2aWNlcyBhcmUgYWRkZWQgYW5kIGhvdyBzbGF2ZV9hbGxvYyBhbmQgc2xhdmVf
Y29uZmlndXJlIGZpdCBpbnRvIHRoaXMgb3JkZXIuDQoNCj4gKyAgICAgcmV0dXJuIGRldmljZS0+
ZGV2dHlwZSA9PSBUWVBFX1RBUEUgfHwgZGV2aWNlLT5kZXZ0eXBlID09IA0KPiArVFlQRV9NRURJ
VU1fQ0hBTkdFUjsNCg0KV2h5IGFsc28gY2hlY2sgZm9yIFRZUEVfVEFQRT8gVGhlIGZ1bmN0aW9u
IG5hbWUgc2hvdWxkIGJlIHVwZGF0ZWQgdGhlbj8NCkRvbjogQmVjYXVzZSBvdXQgdGFwZSBjaGFu
Z2VyIGNvbnNpc3RlZCBvZiB0aGUgY2hhbmdlciBhbmQgb25lIG9yIG1vcmUgdGFwZSB1bml0cyBh
bmQgYm90aCB3ZXJlIGR1cGxpY2F0ZWQuDQoNCj4gICBzdGF0aWMgaW50IHBxaV9zbGF2ZV9jb25m
aWd1cmUoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KQ0KPiArICAgICBpZiAocHFpX2lzX3RhcGVf
Y2hhbmdlcl9kZXZpY2UoZGV2aWNlKSAmJiBkZXZpY2UtPmlnbm9yZV9kZXZpY2UpIHsNCj4gKyAg
ICAgICAgICAgICByYyA9IC1FTlhJTzsNCj4gKyAgICAgICAgICAgICBkZXZpY2UtPmlnbm9yZV9k
ZXZpY2UgPSBmYWxzZTsNCg0KSeKAmWQgYWRkIGEgYHJldHVybiAtRU5YSU9gIGhlcmUsIGFuZCBy
ZW1vdmUgdGhlIHZhcmlhYmxlLg0KRG9uOiBUaGlzIHdvcmtzIGluIGNvbmp1bmN0aW9uIHdpdGgg
c2xhdmVfYWxsb2MgYW5kIGlzIG5lZWRlZC4NCg0KPg0KDQpLaW5kIHJlZ2FyZHMsDQpQYXVsDQoN
ClRoYW5rcyBmb3IgeW91ciByZXZpZXcuIEFwcHJlY2lhdGUgdGhlIGluc3BlY3Rpb24uDQpEb24g
YW5kIEtldmluDQoNCg==
