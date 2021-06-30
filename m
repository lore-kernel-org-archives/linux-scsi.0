Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01BFC11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 20:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8440461462
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 20:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhF3U7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 16:59:30 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41024 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhF3U73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2021 16:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625086620; x=1656622620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQA990GWg1QxjIarB+EzNUYSYcbkgZJP4A25FU73+dI=;
  b=QSnjTy4sVqiaoQ0bE7YaR4ip40U3jOAwHb9IQOJSQ3FN1nZoNXWfk4Qw
   5gLwGgxXTwZTmmiQE9Y5F/9hHmsgs2vt2mNYFhwv3cJ/JJ/+H+7IDlk8C
   mure9EbP6YGaQRQWfDt2AqA32tymlb0x9QFZLRQFy7nzse8hFu1SvENhA
   DuNaA9yn1SQQdjCYSJTYh2suXVW8wH1WqYcYlCxXERRQf2yx7AapjL9AV
   ILyeptHaZbWwN31Q2UE3c7rfkm3Mj0aSrgymqcjPkk+U1SG5rt48J55YM
   /K6x+pnfroGJDb0wG2+5WCpnI+Y4IJ0Uoou9g8RhyzZjFnuYGhLjb72hn
   Q==;
IronPort-SDR: kEEKw9PDaEhFfKU7QrDWhYrEN+oULtX4Ji1Rcdanqou4V+R/vTsuedSxg7VEuJDmg2rknIQk+S
 yH23o4aNdnyT7CSxLPakMa7W2w8D85lqZrxCYbxePhaxiIpfhIGhIodafXY+2mwILX0Z4P2b/a
 LIQr/WjRrEBVy6sSA/7kpuz/UVfIyC3HjPpGz/E/qtVGyRWXONlw/REprRkMTGYDk52/s7EsTk
 xC641nhTTKmsO5eXSz6u6u4Ei9VLDoTBchq9Jc6/0GRm8Rz3RgL7DFDyM47NjigT7m3ojdL3ca
 TSk=
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="134145774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2021 13:56:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 13:56:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Wed, 30 Jun 2021 13:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+BySwnR3dpRu0Gv/4vscIN3P6L/58+dcDp3aax6yWN8NxB6moV1uqmU4MtY20+2DSDA/Rz2YMHamgdFriZzfM5fk5bXLqIIaQiCb9JM47AYnX+NyH776YaR6JLZ7ALej5pgw4XBI7z8sMwpjBiMP6H5AG2CWoY8DAPNf2XPdfi7G8vw3Era67a6FQCazznMPt5+eRNXUf1ETeBD0CN6NOqnVnle8ztTzqf9+Axsv/y2EqPlRj62z/nzgBDke1tRGp6ZFyzqxZXkgdygBjLeJEUg2W7AdxycaoANXbtP+0MTb+wCTkgOUacYGG7702RWvyhRZql0jUrgnDsgQdgWYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQA990GWg1QxjIarB+EzNUYSYcbkgZJP4A25FU73+dI=;
 b=WReHun+7eVF9A3xS8F4IoLEDlSo6BT8vs4uexF/oi/IafUwQlYkUwGyR53WhZ3CFNuwlO/DEonp6oHWOXA0MY5U5O+8g+4WMUP2jan+eGw8/nZuVM2XnngeEtDHEa7mbM6FQyuYy9Vk1CHzgsFe8JG1sRWJCLt5ici0UPHZK0l8Cd1hHC+vj+VO00c+8ybg4k3/GA3M+sRjUFcGsr3i9T8RQO6x6u7zp0zuTA6smJYuygOBXXxteaOYNRFObgraLpdp6Nf3saqa4ouz+X6zANABwCchkkRO58n0//V1+EFdh/HCByV12mLE4S1Wa8g6gtE3At/hpFcC3S3vAi9T2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQA990GWg1QxjIarB+EzNUYSYcbkgZJP4A25FU73+dI=;
 b=vK1ImolGxuFCRy7V4EOqV8IbWx6a0SfUB21gBIBtjPMVZjM3WCG1Fu8M5nqfwuyqBXIqJyRhu2ErozidXyfhOM6/awGiRiTgYeqgrSxYf3Je+d24AITW5PVX3TIC1M2J+MdMGRQ1rMVpKKvlStdxrsp0ck9309a4K/YIGlg1mYQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 30 Jun
 2021 20:56:55 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4264.026; Wed, 30 Jun 2021
 20:56:55 +0000
From:   <Don.Brace@microchip.com>
To:     <jbrouer@redhat.com>, <hch@infradead.org>
CC:     <don.brace@microsemi.com>, <linux-scsi@vger.kernel.org>
Subject: RE: smartpqi cannot change IRQ smp_affinity
Thread-Topic: smartpqi cannot change IRQ smp_affinity
Thread-Index: AQHXbez1FS3gD68z6EOH3LwgLrV5wastCAEQ
Date:   Wed, 30 Jun 2021 20:56:55 +0000
Message-ID: <SN6PR11MB284870DAB389F96D45B51F05E1019@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <c8ed244c-61d0-eead-8ec3-fe8f2e239d71@redhat.com>
In-Reply-To: <c8ed244c-61d0-eead-8ec3-fe8f2e239d71@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a4cbf73-41c9-4160-5770-08d93c099860
x-ms-traffictypediagnostic: SA0PR11MB4557:
x-microsoft-antispam-prvs: <SA0PR11MB4557E5D515337440AADA1BC3E1019@SA0PR11MB4557.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ninL6RNdX+2d3+yG3scTw+pqn8jF8USAmXuAyGNrL18qkpLIkLdiX+BUVfwfzPWfGr+eUhMG/3SPnkUb3fPrcXUrRoEhPfh8jBgM+bEO+i4OfZ9qKyd/MYFeA3OwNR/VjTWIAnqBr7hdC+L8vhTHp5na++zKVQZh/uwJc7fC5WoTkuG302Eg8fyoIY8nEZspD1Qw64QvjuNJZFdpDMiy1TiFEsQIZ23YhFZ+u4ZlI7S39wISO2Jsv9FwSeUYlv1ue89plVlodyudOYIg/oyRdToUTFr63RaN9gkfdUZSkZajr+M4wQffxyorHIoTA6v8ToquChjthvfOKKsqeFosOItJIxNG/+pXr8HmDiNxAaM9Ke5KHaVGtcSm3v/kn8EF2nLjTe3Nv3klPLDjdTPwmjJ7Kz39hYjH0pF1fR9pj9jC22OfL7to5ynNe86kfk8i5N2s0gTgaDK4IMwhdr7NvegkY3OZfucpqUJkmPVrvspzL1vURrRTHAVrLe/t2TIttoqQ82/xLDvzTOL7pQGtC9bsGsSoHDPM3z0GR/KjRzkWNZI6VxB8Q4Mq83lTqwWpL37tuijGZkmtvgXomJMVseRB6sN9xlLd5GTuCPMem8+2cPU0jeX+9KW8teh0jQwmwnZ8iqpfNijt+9gDAU+MqeUDbcnw8kqW56ijwe1/9djMddy0F+bo+AlC605tfVuTYDg9f3ajOTFtvzos8ObArvg/OJ/V4k8+fbmjVaeyVfSFxuUMqOv1Scn1PzaXDmk9weVRgHWeoZFVmuXR5QFd7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(38100700002)(4326008)(71200400001)(6506007)(53546011)(122000001)(7696005)(5660300002)(66556008)(64756008)(66446008)(66476007)(478600001)(52536014)(86362001)(2906002)(9686003)(110136005)(54906003)(8676002)(55016002)(8936002)(83380400001)(316002)(76116006)(66946007)(966005)(186003)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXV5eU9CbTdVN0szTG1BUjdOUDBxQ3lUVHE4dEpHRjlYMjEvN2pvbVpGekhz?=
 =?utf-8?B?QmZKRlY2cFZTbTBNNmtCM1Zybzg2RDJBYzUvQTRoZStRTE9RK24vWS9oUUFo?=
 =?utf-8?B?S1NxSk01ckJvR2VZUWRGWFhFU2Q2S1VSZ284ZHFpOVp2Q0pyWjZnbDRaM25q?=
 =?utf-8?B?VXBmc0hjdm9zeldXMm9ZbWNrSXBucWdiOGZQNTlUK0xkMjV4cEpUeVFldnBS?=
 =?utf-8?B?OTZXQnJFVkxvSVBsblJ1SkNJV1RNYXNGRlJ6SWYwZkh4V0ltR25hNUM0eDJt?=
 =?utf-8?B?VnovTENXazRoQjdYdDAvVGM5ZjdwMTNnUmFBVE1KYk1VaHE2eC92UzJjWHg3?=
 =?utf-8?B?YUZXL013SkZ2MkpFRkpMa2NmdW1NMjZodUlndTc5TGpjalIrNmdlRHNmRGJ0?=
 =?utf-8?B?OG1UK0NYU2ZZTjNrSUtYT2xyTXZzbUhiUG9UVGptRVVzT29mbFRxbE45bE1Z?=
 =?utf-8?B?cWw0azloelVTQTl0R3BMY2xSWUhFSy94QXRsMDdJTlVndDgwODQvSmxzTHlN?=
 =?utf-8?B?eXNYaXBubHFQUzloeCtONGJwWFBvNmxMMjhyclNSK3gvTURhd1hPYXRNSDdT?=
 =?utf-8?B?VlNkWVh1K3ptMFdPc21qWEQvcjVSY21DbjN6ZWhvQXlwMEdSUnVQMDhhc2J3?=
 =?utf-8?B?WWJvTGp4bEc0TVRpZjc4cWlDbm1rN1JsejVNUEN6K0VqRG9vWlVqTUwraDhP?=
 =?utf-8?B?SzV5U210d3lmNzE1UmlaWVNsUC92b0Q1THBSTXNuVjR3QnhJdnlZQTEwYWtT?=
 =?utf-8?B?dG1SQU5FVVo1ZkY1VFFieERpWDg1alE4ZXJnS3p5YjlCVndubktXSHIzSTM0?=
 =?utf-8?B?YjFILzZKUzdHa1kxcVFWSVBPVmgzcXhwN053UkRvdkFtQXdsSkVVVmpUVkht?=
 =?utf-8?B?RGFuem96U2grV09vaU9hNCtsRi9zaUVjYjRrckFvZE9XOFpDVGdqLzlZdVdo?=
 =?utf-8?B?blRuYTNPRDhnUXB2YStpY1NhblNiU0FzZlpkSUFlNERKV1R5eTFVRVMxMXZL?=
 =?utf-8?B?R2xyMTZjS1Z4UG8xUGFDTU9wZnlHS3p3cDFEdkdYY1I3VFRGN3VONjVXSTdN?=
 =?utf-8?B?RXAyUGMrN1NZTEpSaGM1TDhCd2dmWlZGVjBoQUY1SDVuUFJqU0ZKS0oraklu?=
 =?utf-8?B?VDRYSXZvaXVMNGVRTVhIZnpJcDZOakN2bXVjaTByVTA4VENSSU9FU0RRN0NY?=
 =?utf-8?B?Qk9jcndJb2hMMEVMcUdGRHdaZEp3dVVvdXpBajcvbTJsVXdNaVk5dGlIVlEv?=
 =?utf-8?B?aFpHa3h6MXRUSERwSWV6VmEwa3R3ZzVDQzVvUDl3bThZZUtKRW9KY24yaW9r?=
 =?utf-8?B?NnY5MXJ2NW1WRm94KzkybHBMeU1qRWpSY1Fpc0s1VnNQaEw3UFBEMUFxR3ph?=
 =?utf-8?B?aVk5VTNRaERJUUhZZmQ4NWNyZmU3YTcxd3ZWcDlsVVhGQTN1ZVdMYllSMmt0?=
 =?utf-8?B?d0plK1MwUXNDUHpZTC95MitQRk1tOG5tenFOS05DSCtucFBQQk9acWhDenVa?=
 =?utf-8?B?NzdBQmREWWxaWmJnRUx0c2tZNnJNYXRWb2lQZ1I3MENNOWExM3VlcTlVSUZC?=
 =?utf-8?B?VDBWSmJWVDlsNUdmQkdYaytkL3BGbmc5bFBqWi9zUnlpQnNqTjFFUStpNXpi?=
 =?utf-8?B?RTVaZDhqSURCWG9MQVpnbEQ1djMyTGY4aWY3NkdPenZZTGJBQW9lRzc3VnVp?=
 =?utf-8?B?V29HY0wvQXpsU3VOT0UycURUSk5iR0FzTk5PZmV3Qi9mMjRvaFRtbkE0MU5D?=
 =?utf-8?Q?sfhe/R/0se0493ILmA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4cbf73-41c9-4160-5770-08d93c099860
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 20:56:55.6969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bMjo/4nNJlHgW5YmU6gEwvR3OtrSFuOhDXMyYBYnLRHymSfkrdMsmlPeXAQ5tYEcGm1wyL1YFrdQ8pYCPxWl+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEplc3BlciBEYW5nYWFyZCBCcm91ZXIg
W21haWx0bzpqYnJvdWVyQHJlZGhhdC5jb21dIA0KU2VudDogV2VkbmVzZGF5LCBKdW5lIDMwLCAy
MDIxIDM6MTcgUE0NClRvOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+DQpD
YzogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9zZW1pLmNvbT47IGxpbnV4LXNjc2lAdmdlci5r
ZXJuZWwub3JnDQpTdWJqZWN0OiBzbWFydHBxaSBjYW5ub3QgY2hhbmdlIElSUSBzbXBfYWZmaW5p
dHkNCg0KSGkgSGVsbHdpZyBhbmQgRG9uLA0KDQoNCk9uIGRyaXZlciBzbWFydHBxaSBJIGNhbm5v
dCBjaGFuZ2Ugc21wX2FmZmluaXR5IGFuZCBzbXBfYWZmaW5pdHlfbGlzdCBlbnRyaWVzLg0KDQpJ
dCB3YXMgc3VwcG9zZSB0byBiZSBmaXhlZCBieSB0aGlzIHBhdGNoOg0KaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXNjc2kvcGF0Y2gvMTU0NDIyMTc5ODUxLjEyMTgu
MTAzNDkyMDcyNDc4NDkyNzcwMzYuc3RnaXRAYnJ1bmhpbGRhLw0KDQpJIGNhbiBzZWUgdGhhdCBI
ZWxsd2lnIGFkZGVkIGJhY2sgUENJX0lSUV9BRkZJTklUWSBmbGFnIGluIGNvbW1pdCA1MjE5ODIy
Njg3YmUgKCJzY3NpOiBzbWFydHBxaTogc3dpdGNoIHRvIHBjaV9hbGxvY19pcnFfdmVjdG9ycyIp
Lg0KDQoNCklzIHRoZXJlIGFub3RoZXIgd2F5IEkgY2FuIGNvbnRyb2wgd2hpY2ggQ1BVIHRoYXQg
cHJvY2VzcyBJUlFzIGZyb20gdGhlIGRpc2sgY29udHJvbGxlcj8NCg0KLS1KZXNwZXINCg0KKGxz
cGNpIG91dHB1dCBiZWxvdykNCg0KYjI6MDAuMCBTZXJpYWwgQXR0YWNoZWQgU0NTSSBjb250cm9s
bGVyOiBBZGFwdGVjIFNtYXJ0IFN0b3JhZ2UgUFFJIFNBUyAocmV2IDAxKQ0KDQogICAgICAgICBL
ZXJuZWwgZHJpdmVyIGluIHVzZTogc21hcnRwcWkNCiAgICAgICAgIEtlcm5lbCBtb2R1bGVzOiBz
bWFydHBxaQ0KDQpEb246DQpDYW4geW91IHRlbGwgdXMgd2hhdCBPUyB5b3UgYXJlIHJ1bm5pbmcg
YW5kIHRoZSBkcml2ZXIgdmVyc2lvbj8NCk91dHB1dCBmcm9tIHVuYW1lIC1yIGFuZCAvc3lzL2Ns
YXNzL3Njc2lfaG9zdC9ob3N0NC9kcml2ZXJfdmVyc2lvbg0KTXkgc3lzdGVtIGlzIHVzaW5nIGhv
c3Q0LCBpdCBtYXkgYmUgZGlmZmVyZW50IG9uIHlvdXIgc3lzdGVtLg0KDQoNCg==
