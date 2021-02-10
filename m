Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD48C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 15:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D799B64E65
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 15:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhBJP3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:29:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:30592 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhBJP3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 10:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612970945; x=1644506945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mOULkHLf1LwyVYWNWa31UKG0pM24SccgO8TJ6LKBp6g=;
  b=kCBupRLXdW2XmHqSmRSvTMVqVF9fFMkbZIK6RVkmzA+wUiTFBgal2QQi
   qZc9KJCzwwrjzSxIvSNA0AZiFXhNfa6VvjZHEIBtG+4OT+gFRJJ2+069i
   lLfDYFnkGvDo0JXJ31lrYF8kctj8C/3MuZaIyWg2/wAPCCOThRQyuIM95
   wj8SywvjekDtirmtFx4vn5uYHhbSQ+CknwiIWOdOW8KmFkBNySVLhHyu3
   P5NTWW2q+239GU8rFPs6pdWFQC7kI69JgZgWzu/NridZCXjSnpyyTUEYp
   Kk76wkvVnVkFaOxincP1owJuTzKT8hadL2q4EqCMNggafAAnRxiL4B+5c
   w==;
IronPort-SDR: 7al23jdy8GGM+5o6MqXG0QrYvMY+rg2sjfqBxg0mLZ5+O1Y0N8/im0WPeiA5IEHCpnTzwAIhHI
 ev/mdOMyOEJxoVfWFkQ0387ATt977FctA8C1hAD7trnBcgR3+Rdfa6ZBRd/ei0+OCPKVkWZTxy
 CFKNvlDjFkiAAWxCMExpsRN53gAc9Xr3apU9bKcaIWbCbBQJygXi2frGcdtD5R5ZkA+wounafK
 9ob243H76TCa60rgjXsfRkn32TqboO3n+gn+612eLjaoLqArFk3xZUJaVVZH1O7oiPRm2n50/P
 PDc=
X-IronPort-AV: E=Sophos;i="5.81,168,1610434800"; 
   d="scan'208";a="103310148"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 08:27:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 08:27:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 10 Feb 2021 08:27:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWQpSBh9H6hsdwBVFnjE2DmJ9za3rcWZuQgk1UlR/7rGSwl6G2IwnbxLAd+ZOWKyfDWaEX5LmrlsGVWVCHleQQc/I6MNM4lvNoLjfoFObqTZyrnujmDFDqiOyPo4XwOQ+BajErENFlilUIJ5E4aJopPESwhwLTH+fRfJaHqq3ykxos8V55XazNHc/wDNjQt6uHbUMiNqpOT+K3DtPI/wXoyo3ZlllI97VXqESINrotqYrpfPS87ZwKuK6HCM6HjNBmAzShchFPEreEyAG3Wf8zoZgabKzavvtLX8bVy/N5rBN38WNRqTt0Xt18pfOUBkI0VDEXu+2X7ovKLzLK0SdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOULkHLf1LwyVYWNWa31UKG0pM24SccgO8TJ6LKBp6g=;
 b=Zn2cj6VFNeBGE/Jl/2lX8rla6/4GkeiEDPSziqwI/ToiBLVjzUaOzFdd0WXog+ycrg7Zt6MziXd3VsO6Xa5m1ZT/ep9aCQhB6um9vEzXHPzsjHFDXozXpQCQa6XGN58KaXohgYh/kx/XNbTDfyxVSqg3pcCgMt3b/i+6hmoWBpq6rL/VfJ6W9ehol8YZXXtI2HdjTQwRqpWpDW2sFbYcmngqT/L0DHf4sjaxxNi/dh5UuG80mHayJtMyb24uGy70MC+XcQTz7AeEnUWmW4zOimbzonOYn9oLs+8F395XErh+J9PlAeKIvOJrpY9MAGKMMN6FProz/csCXCUxWap/sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOULkHLf1LwyVYWNWa31UKG0pM24SccgO8TJ6LKBp6g=;
 b=gc7blGhePhIsSPzEqYtU0dA3xEXsnk2rtv1UKr4IqBeYCh0SOj6DeKDpYPYmf1VeUw2FUCYwUnJ0gepRXyo7KYP53BBgPJDmtdK+F21zAGsY2BLX7J9jX0NW0PsXtoox3xXpMp3/yQ1UVwWfNTdRE2Zg3mITZ7vvFwcoej8bS5k=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2798.namprd11.prod.outlook.com (2603:10b6:805:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 15:27:39 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 15:27:39 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <buczek@molgen.mpg.de>, <gregkh@linuxfoundation.org>,
        <ming.lei@redhat.com>
Subject: RE: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Topic: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Index: AQHWzzRlWOT1Tjrni0WYgyG85NUWaqn25dQAgAGyXjCAJGc6AIAMaNYwgAWWawCAIuPh4A==
Date:   Wed, 10 Feb 2021 15:27:39 +0000
Message-ID: <SN6PR11MB2848ECDD666F0BF867AE04DFE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
In-Reply-To: <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b5a1e5a-197b-46f2-a135-08d8cdd866e1
x-ms-traffictypediagnostic: SN6PR11MB2798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB279899A972FC7CD42778B6A4E18D9@SN6PR11MB2798.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HGvwbeZjToEpoxYIdwfWCH+ibNvtLo5iGBecktnRjQ2nhTZAixCLObFfNIytuxa4MhzeEMFmpUITy49acvfSHubipwLvxKoIluAV7a96Th3fPVcGVQCzUWm1tBKU7EeXKycD3CQDe6v1Jf7THm84CFCNqwX3YnBvYTv49tCygCSy3hqZMcPG+J0br+pISt0kqxdcomzybfYm2blb4IpdhQj5uyTCaJ8E1zoKKBTzAEADniNL52pxeTQNbsJA2+jL4LGX257s0Uxb2QxbzZI4TrfOcpMjVRiZm4KWwnYTr+dFpA/ogSFfrsfWchVqQjLPNqnsFyvP9WjK+3g2fT7sLDtaQ18fh0MVtsuuqRjTGDTZ7F9t4qu+Alt5GcaHQ3rmFx5Buk+CAYQv2GeLaMl2BJ740JJRHqUjUMQ2vU+Uz2RZhHi3xcgf+aW5VSupCCt0PABHDzpihsJpdxFrRMRejjbRH+74mVgUw8tun9Jp0OAAIu5Us1IUIAHI7Y3P7QNsiodMn+wEyEHQQ17Cq/enXaaFZkaw54DMZ8pUb3kh2k+ikXh1YG10C97HgxTmMnur
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39860400002)(54906003)(110136005)(8676002)(52536014)(83380400001)(66946007)(26005)(66556008)(7696005)(33656002)(64756008)(66446008)(76116006)(2906002)(5660300002)(66476007)(9686003)(478600001)(186003)(7416002)(86362001)(71200400001)(4744005)(55016002)(6506007)(4326008)(921005)(316002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SmFScUVnSUpNR1NqOFltUFZyb0d1Z0Fpeks1RXloNGErU05QZU12cEVma28r?=
 =?utf-8?B?VSszKytOekw3UnF1azI4dmNoZ2pCQWZJRlk5b1FlL0twb2tNKzM4TGZkUkNl?=
 =?utf-8?B?WVI1Q1lYTVdTS1JNUlowcWhIL3h4a3VXRXZNRUhQLzF5WUxJeFVjQXVkUDNO?=
 =?utf-8?B?RWx5dHVBYUYvbG4wbTlvSEtmYnl5Sm56MmhMMTc4T3NyeE5ySzNxemZlN2ZE?=
 =?utf-8?B?a1BSSnVYcVpLN3Y3SU5BZDhibEJLT3RCNEZTbnVGTVl5aG1IeDhJRFFSaU1O?=
 =?utf-8?B?MDEvY0szaEtxaHk5bVAweVFnd1JOVlQ2d3Z4bTVSRFoycGRKTjhEU0JyaUZq?=
 =?utf-8?B?Z1FrMWVWeDlycXVpM1NzZjJ2T1A4L0p1MXFBQkY2WlhqNWMrN29JWFJEUXRz?=
 =?utf-8?B?c0lYRjBlb1pRYm15d1UvcmlYd2RZeGdSQXFSem1KL2ZMODMyT3VQL0JrcVpJ?=
 =?utf-8?B?d1dSLzAvaERmSkd0NE9weC9BV0xqN0h1RklKOGkvSEtmaEI2N25BMUZCMnRG?=
 =?utf-8?B?aUhSNlNLbVd5ckNTNnVlb3FNU1B5WnN5N0RqSU5Ud3JOczc1djNSYW9JRnBz?=
 =?utf-8?B?YVQ3Yi9wZ1kzWEcxcmR4NVQrZ1J3RkJjTVRGRDBxWG9vR2U0MXVxdnNBZ2I3?=
 =?utf-8?B?NGVZd3JVWStUc3k2WXBQY1BkYXhidXVoTnEzejNXcllJRkF0TGFBSjVqeWlX?=
 =?utf-8?B?c1pvMWc5b0Y3M3FhQzFvYmE0WGt2MEtWUndMZmlNZDN0VEQ5cm5MMUt1elQ3?=
 =?utf-8?B?VFZHYmszQVNxb0tUNDFmcHpPNDRya0FkY3Z2Z3Y3YXAxTFJ1NjNDV0Nzcmw4?=
 =?utf-8?B?R3ZNdUYyTWhQMW8xT1daMFNqVFhNc2JUZnZ3S0xabnlHMVRxd3JUSElmdkdD?=
 =?utf-8?B?alk1eG5mTVhHcFVhZVo3ZnlpNkx0dkVIM1VpRDNsTFZtYWRXNlJYbEp1bUJj?=
 =?utf-8?B?ZmxoZ0svV1F5bzhmQkdmaENWKy9YNnluZGt6QXFrUFJOTEJzZG5Wa3lhQXpW?=
 =?utf-8?B?NW9OM05ZRzh1TFNOWGx2MTRNWmJjWWtpMmx4dEtQczhjK1JmY3kxYTFiV0hL?=
 =?utf-8?B?TmRwcFIxdWhwQ0N0aFZGSVNIZUpXTlY0L2U2b2JRRW5iYW9zaTJJU2xlTmxy?=
 =?utf-8?B?b1hTVzJCUklSVUdyM0RwNUZCazBOdTYyK1BVWGdQU0c1c3dtVWVZT3gySjgx?=
 =?utf-8?B?ZWNWc29EMXZFZ3RYYmpTZU9tYWdHRll3aHh5WXljUDdIMTZLRWx0NW0xRm9P?=
 =?utf-8?B?Y2pndEtqdEViOENFVzdqbUlCVDlhRTZGQXNyRkJ2VEFPSC9pbGJFNnoxRHlL?=
 =?utf-8?B?SUMzeFhtbUdnSmt6SlNoZHFDNzZKQ2VrUnJyRHNTb2hXVEdBMWdvUzNuZTVI?=
 =?utf-8?B?aGZJckJVZnI1YWpqWlRVMGxFYWx6R2Q2d2V6eVRaUmhoMG4xUDBaaXg0clpx?=
 =?utf-8?B?SmZxb1ZLUFRweWZnRUZLSWk4TzhUNFFmSzhBYkFGYkxmRVU4Ukx4aDJVMmVk?=
 =?utf-8?B?ekVoUUs2Y2dXbldiSElWV3FNdm9QUnNwQ0dMV1lQeGtiYlBFeVFVQ2M1TkJr?=
 =?utf-8?B?K0tvOEJTNVlBVmcrTG1nS1kwdE1TYlcwVUdWT3J5TEhERjFxaWthZ2RIaDlu?=
 =?utf-8?B?czN3elU4SEVKR1Npdmh2aDl4UmRyRVBVSUZsc0pabG1xSWtBY0lHWGJNcEQ0?=
 =?utf-8?B?MzJ2Q2ZjYjlORlZHTFh0aENuKzZZN0hvRXNsemRLNmIxWE9Jci84TjNJRlEw?=
 =?utf-8?Q?GtJy4fS/riIss72kOA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5a1e5a-197b-46f2-a135-08d8cdd866e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 15:27:39.4178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EeCoY7zpz8gjHx/8iAaNd3+mraPJ2RM/hvwusDlDMSG9WGHs3Yw3WxWtBHAeOUvXxx1OxTV+K8OcwrB1DWXuHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2798
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KU3ViamVjdDogUmU6IFtQQVRDSCBWMyAxNS8yNV0gc21hcnRw
cWk6IGZpeCBob3N0IHFkZXB0aCBsaW1pdA0KDQoNCkkgdGhpbmsgdGhhdCB0aGlzIGNhbiBhbHRl
cm5hdGl2ZWx5IGJlIHNvbHZlZCBieSBzZXR0aW5nIC5ob3N0X3RhZ3NldCBmbGFnLg0KDQpUaGFu
a3MsDQpKb2huDQoNCkRvbjogSm9obiwgY2FuIEkgYWRkIGEgU3VnZ2VzdGVkLWJ5IHRhZyBmb3Ig
eW91IGZvciBteSBuZXcgcGF0Y2ggc21hcnRwcWktdXNlLWhvc3Qtd2lkZS10YWdzcGFjZT8NCg0K
