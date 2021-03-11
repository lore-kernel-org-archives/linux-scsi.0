Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A5BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 14:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4EA64FE5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 14:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhCKO2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:28:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26027 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhCKO2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 09:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615472921; x=1647008921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UsiOL35zkNV/4EcurQEIryKtiYydKBctEAvpsulJkiY=;
  b=CmUzASvzyYVMb3HLOlo1AzXIX7kaQvVc9LltTEObELtTuo+lBxCuFZ5C
   nVxfRllkUTW5wbxJDyPX8vvrVzT2f8O3jV+69Zj0gdIdt7Rs6rHIoXxY4
   nqWfw+y6b8XVKlHq0pMeih/hXcyxU1VDdRdXo5+Mdx10pvoP2aAc2G0b/
   o/Tm+mMtw+vYFrHeCG6aRs0KMrgpH/lXWk4X4NSCOTreU/gqahsB48q1u
   DOc0TBcFi+WdPEIG4x7Jkuo3mmZ+XKxejXCEvANAozPM4IFiP9C1OLDYq
   x5AvIS/SQCMWCqE7jlfLva52YdgiLwv2aMQC+d8Wkrb1Z8GsQXrBNVlS9
   w==;
IronPort-SDR: Ga0e22KNCLsil98/4VHKp8w2yWt94xI7sEnDA4fJPiv/uAP4RMnqNDk3fHG3QiSlM4RnorDdfD
 IH57tnYkEAQH04HCGCOQ1K6YlIkutHOZYlDrslwq3bX06qWCWkw5q4oed5t2mXXYVjZQP8bfxU
 SoCZvUWJJGYC7AY2g0nunytS07Js5K6mWp8nCwYtbWu0ID29j9NqSUqwIBsBSRfVjQ90DskARI
 yfGd5+Ol9x/w/7BCkBDW8+MF/JEXnnbO5SaMYl8BP/5OEKeSQJ7jgOjozWGxJSLXrfF3F4eCe1
 z2Q=
X-IronPort-AV: E=Sophos;i="5.81,240,1610434800"; 
   d="scan'208";a="118498892"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 07:28:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 07:28:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:28:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hmdx4sSGFZrVKMxDfzThSXgK1CiU1PoWohUeZdej+aDyZjvRpabsscb3xB8EUDr/uPM7MFR/OzE2oU+2+qljyFxbOBnLW8qOgl/1KJwezYia4qbAVtaq9ILjs+K30wFU+DnUpdYVLekIehAYQhprjLYV4FB4uW/CEkWdpWxts0yiSeSwd0MluRdBq+0qJChgD2oxnj/BXFe72t9mVIsU2nT4KohxbU2VEsVNYsimwEnP2Ua7lZPrbA9H8n3oVjzIA0ZTjfvp2PAFtWMG68RHdvg5FQp4EZjk0YTWuK86ZMz+G1qL5FvcviZ7qN2MBL3d8j/kRp+QQwvhCmEKSTyeJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsiOL35zkNV/4EcurQEIryKtiYydKBctEAvpsulJkiY=;
 b=UQrKPSN/sFOVzKhl9BBXFI3P53UB5NWvdhyvf39NgYi4hJTpsOarhtVIGiDnAe0nNqDnbks76j5ERfz5oTt57rF7BRIJrSSXnynJxRk9pdYkHrxIFyN7wYjbwc0Z2fOJreq709zzV8Xr9d7cNdreu0y6OXbpXiIc2ynHXopbwPwMos9S5hg9G1jx1rqMUotTpwEuj4JsgOV1GKu07KJNfoThyO7xLtuJU7lSrmTaPilYBKm12TACROsNBo3KQ5y2bT66yI0tKdl42RYFgF2t786HzeKGv5h4TyCWDXvEMq2kavgrTuiOv+6LvvDq3sIdJkuJTyKjg+KdRDAHcwjyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsiOL35zkNV/4EcurQEIryKtiYydKBctEAvpsulJkiY=;
 b=Z8GXf+NchcL4y+W+kK7oVRcmkVpeOcyVViHwlAwCeF9wOLL9jS2UPjZHkEZx41P57Yw8ZPZK8Z6BuBvAQVrfbrrJE1b9HoCLfqH/WJVtmarCW98B0ZD99APIYAms5uDKN7oG7dEOve112jDyJQwjTIBhoDh4SIuYnpxwJ71C+Ho=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3007.namprd11.prod.outlook.com (2603:10b6:805:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 14:28:37 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 14:28:37 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V4 01/31] smartpqi: use host wide tagspace
Thread-Topic: [PATCH V4 01/31] smartpqi: use host wide tagspace
Thread-Index: AQHXFeg5+qRnMjbQo0qiqYl7ZIzZZ6p91j6AgAEDUFA=
Date:   Thu, 11 Mar 2021 14:28:37 +0000
Message-ID: <SN6PR11MB284814DF9440B8E35E6A73D8E1909@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
 <161540645071.19430.854884194228600277.stgit@brunhilda>
 <df5ccaba-fb70-e2f8-2cd1-8e3b4e299aa5@huawei.com>
In-Reply-To: <df5ccaba-fb70-e2f8-2cd1-8e3b4e299aa5@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10c62636-19c1-4c81-4475-08d8e499f5bf
x-ms-traffictypediagnostic: SN6PR11MB3007:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB300788360CA4CA84D33AB790E1909@SN6PR11MB3007.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WMJeOAb4qoLdRBqyXX3LJWfgaYI36nnkPq2aa16qWXI/SMSgriTVDus8Z9RWCQfIiL/nXvTX7lYFYU8/SpgQEaVP0HAsF8Um4wDfaZqUnbfbvWD33Iib9DMYVNz/UQ5bmOrg6Z3Yg3NnW/huUQhcyrqlhsGuI/hksHXfI/xoAsKuGRLu9+YiSupMB7C1nwU1ms1VD9rGP+sw/E+F4uQ7Q9aGkypPnWJFJoZuJXke2puhJk+Ah4RKUgKpAEPLzyx436KMZqOZca8rXkL9DNB9swnwMn2UpK2tzxbdk0D0d+jEfs0oQJofKL4S7UlkdlFny9jLm+RcSSpM+HVo1y6yFS7QodNn1j26J0WxlAx3vsCAOxzf9almMqoPHM7KeIdzVi3DF49bJUstt0LH06DG7VJQHN2vHvAoskq6Q0PY/7C1MxLO8h2DMHyxa5aEUuceBnu4xIZZRDTm9wLXm3EsQ9IJdvaOSM3NAGCQ1C/zxVJYfdEIEg0qjXg86E/uMDTMPC+OoK6JG1Hg2xwUOK6B7osalQXNnWo/18v1a/yL6eWOnSyMJirTTKrxvfMTlJsFjx7xQ/f0lyvy0McjkAv8wpEuNl4628iKMohjIwTtlSZCR1QaoO6GrrQ6V3rJS4iWbj+mWWbyauRlWh8ql+GmCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(83380400001)(66476007)(5660300002)(66446008)(55016002)(110136005)(64756008)(186003)(52536014)(2906002)(8676002)(86362001)(921005)(66556008)(66946007)(966005)(76116006)(478600001)(6506007)(7696005)(53546011)(8936002)(33656002)(26005)(4326008)(9686003)(71200400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cEpSbDhhU2w2S2t4TjE3NGl3UUVSd1lJMWduV2l1MjBFb0Q0SXB0am1lT2NU?=
 =?utf-8?B?MGFNSjRDZ1VVMXFQeHF0MFJnQ0VGZ3R2Y1NBOWhaNVVIMkpMaU5ranpDVEJK?=
 =?utf-8?B?WXZLTjkxZGYyYlNFK252WVJwVWQ3YVVVYlFkNDh0OVg3ZjcwbE1lNWFBT1RM?=
 =?utf-8?B?YlZGbTNjYkxjS25YREtDRmdRd1RvZHhKc2RsVnRPTWN5dUloM2VmVmU0V1Js?=
 =?utf-8?B?SFlrRXExYVMyaXc5TzBxdFVHS0IyM1c0bGE0K1l0dUFNNGZRYTVlZCtpOWoz?=
 =?utf-8?B?ZGtXRjJkOHAxSVh0a0JqTHNsUllwNGZxelZ5OTRiU1NFSlRXbXV0MHBzbE1X?=
 =?utf-8?B?dGw2emNOU1ZiczBUbDRBa2p5SFFHOUxGTGtkWVZNeVU1Uys0dVhkVHk4aEE4?=
 =?utf-8?B?L3B0N1NxQ1N1bmpwWlpDMnliRTJnbjRUWlExVXdLcFNzTDdjN1BBZCs1U2g5?=
 =?utf-8?B?U0EyV2JGK0NMK1Z0dEtydHV0NWpsdUxCa1pPZ3l2b3JCY3FTS2tHYk9ZclFI?=
 =?utf-8?B?TStTYi9ENEJPQjZNSFhYeWZndkt2U0kyVVkyenBRd2RiNkIwOEI3MWRZR2Vj?=
 =?utf-8?B?MXd3aUoxWHRxT0VYZXVEYlR6TFlNMzhCbEZpYUxYTEhyWUF5cnc4cWlyT0ZH?=
 =?utf-8?B?MlU1OWJzc0ZCZ1hERE1iQURrWiswc2pWYmtuM1prMEpiM0xuUEZQM2RGS081?=
 =?utf-8?B?QXZmSkNkaHdpV1VxenN5QzFZcXBlVnBmV00xQktucmZieUF0WXhsZENKLzNa?=
 =?utf-8?B?VXNJRlZJQ081eEtPclRDZ1VSUElER0ttdEVBdVNxaVpjRWtJRW5qejA0YytB?=
 =?utf-8?B?MEN0aWFRNGJvRGN6NFRLbDVtUTBjY2VOSElEVGVUNUVzY0R6c3R3ekxnQ1Jw?=
 =?utf-8?B?d21ETEE3bURDcG1YTHVMb2p1bE5PdkRLNHhBbW4raGtMUXByWmM2eHM4blA2?=
 =?utf-8?B?R2VsRVdLdnV1bXZVVW55dDNVWHZUT21COHVDaXk5SVZqUExHVWQwaTZjY0Jp?=
 =?utf-8?B?Z0N2SXhpQXcvTUJKdnltZGtiQXFad0k2WjRyK3RnTkVzL0RzamtmdXB4cmxP?=
 =?utf-8?B?MmE5UTE0bE5OV3NpTVJmUlFWTW0wQWJLaEFLMm5RMkpUMERnNVYvcHppRWky?=
 =?utf-8?B?NFpiRVh4SHRTOGh5aks4REhpVlplSFlwRk1WNGQwYmltWUJ1VGtMeXRjQ3dL?=
 =?utf-8?B?enZsUWJ4bisxREJaOHVWZGtWQjdMaXVlVng0WTJzQ0MzSW1RZEgyZ0JUSURz?=
 =?utf-8?B?MUV0SGtpTjJxenBjWDBEN1RhMWlzZ1lIRkFqcUFYR2xHdktZQWJicHBLNjFm?=
 =?utf-8?B?NWkxNHhhcVgvSTRla0F3N09jMXZCNDFKK212TzYwSUhvejVvYzg5Y0xCSnhK?=
 =?utf-8?B?ZjhvTUF5MzdvOWUwbW1CUWdsZEtOWWZzTExYSnhGUlViYTlKOGYvMlIrd1Rq?=
 =?utf-8?B?R2g2ZUxNVE1mY3R0aGhSRHhJTWhQejFGa0xaM0YwaUNiUk0yVWF1QzBwQTJi?=
 =?utf-8?B?Rk5DN09GVlZTbndld1krRnVTS09UU0NXYlZCUnRUNUthcC9PY0kwQjF6U0Za?=
 =?utf-8?B?QjFWcTNyRnF1VFVSd3RKd0E3aUJ3WElSM3owL0NKWno2OUNCK0VVLzZJQjk4?=
 =?utf-8?B?djYycDAwNzJRS3NQUXdmeDRXRC9rRXYwRmFsQmNtL1RWSUVobG9FeG43NVZx?=
 =?utf-8?B?bWVXSUhjVVlhQmJIU2hiQk9KUzRkSnNxalZlMFlSUi94aTNuSVVUTDJZUjZJ?=
 =?utf-8?Q?hEVzuRCRqIWytcdbAg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c62636-19c1-4c81-4475-08d8e499f5bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 14:28:37.5618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByCsLKNZ+Ob/bKzSVDsHotCJFl6X5xP2aCD9ubJELE88ebkOuX3hn9kBM+mBdkNx4GGgIKZzDFhLNyWmX1P/1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KU3ViamVjdDogUmU6IFtQQVRDSCBWNCAwMS8zMV0gc21hcnRw
cWk6IHVzZSBob3N0IHdpZGUgdGFnc3BhY2UNCg0KT24gMTAvMDMvMjAyMSAyMDowMCwgRG9uIEJy
YWNlIHdyb3RlOg0KPiBDb3JyZWN0IHNjc2ktbWlkLWxheWVyIHNlbmRpbmcgbW9yZSByZXF1ZXN0
cyB0aGFuIGV4cG9zZWQgaG9zdCBRIGRlcHRoIA0KPiBjYXVzaW5nIGZpcm13YXJlIEFTU0VSVCBh
bmQgbG9ja3VwIGlzc3VlIGJ5IGVuYWJsaW5nIGhvc3Qgd2lkZSB0YWdzIA0KPiBhbmQgc2V0dGlu
ZyBucl9od19xdWV1ZXMgdG8gMS4NCj4NCj4gTm90ZTogdGhpcyBhbHNvIHJlc3VsdHMgaW4gYmV0
dGVyIHBlcmZvcm1hbmNlLg0KPg0KPiBTdWdnZXN0ZWQtYnk6IE1pbmcgTGVpIDxtaW5nLmxlaUBy
ZWRoYXQuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IEpvaG4gR2FyeSA8am9obi5nYXJ5QGh1YXdlaS5j
b20+DQoNCm1pc3NwZWxsZWQgbmFtZQ0KRG9uOiBTb3JyeSBKb2huLCBjb3JyZWN0ZWQgaW4gVjUN
Cg0KPiBSZXZpZXdlZC1ieTogU2NvdHQgQmVuZXNoIDxzY290dC5iZW5lc2hAbWljcm9jaGlwLmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IFNjb3R0IFRlZWwgPHNjb3R0LnRlZWxAbWljcm9jaGlwLmNvbT4N
Cj4gUmV2aWV3ZWQtYnk6IEtldmluIEJhcm5ldHQgPGtldmluLmJhcm5ldHRAbWljcm9jaGlwLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9jaGlwLmNvbT4N
Cj4gLS0tDQo+ICAgZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYyB8ICAgIDMg
KystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
Pg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYyAN
Cj4gYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+IGluZGV4IGM1M2Y0
NTZmYmQwOS4uYzE1NGU0NTc4ZTU1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc21hcnRw
cWkvc21hcnRwcWlfaW5pdC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBx
aV9pbml0LmMNCj4gQEAgLTY1OTgsNyArNjU5OCw4IEBAIHN0YXRpYyBpbnQgcHFpX3JlZ2lzdGVy
X3Njc2koc3RydWN0IHBxaV9jdHJsX2luZm8gKmN0cmxfaW5mbykNCj4gICAgICAgc2hvc3QtPnRy
YW5zcG9ydHQgPSBwcWlfc2FzX3RyYW5zcG9ydF90ZW1wbGF0ZTsNCj4gICAgICAgc2hvc3QtPmly
cSA9IHBjaV9pcnFfdmVjdG9yKGN0cmxfaW5mby0+cGNpX2RldiwgMCk7DQo+ICAgICAgIHNob3N0
LT51bmlxdWVfaWQgPSBzaG9zdC0+aXJxOw0KPiAtICAgICBzaG9zdC0+bnJfaHdfcXVldWVzID0g
Y3RybF9pbmZvLT5udW1fcXVldWVfZ3JvdXBzOw0KPiArICAgICBzaG9zdC0+bnJfaHdfcXVldWVz
ID0gMTsNCj4gKyAgICAgc2hvc3QtPmhvc3RfdGFnc2V0ID0gMTsNCg0KSWYgbnJfaHdfcXVldWVz
ID0gMSwgdGhlbiB0aGVyZSBpcyBubyBwb2ludCBpbiBzZXR0aW5nIGhvc3RfdGFnc2V0Lg0KDQpB
cGFydCBmcm9tIHRoYXQsIEknbSBjb25jZXJuZWQgd2l0aCB0aGUgaXNzdWUgbWVudGlvbmVkIGhl
cmU6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNjc2kvNGJmZjYyMzItNmFiZC1k
YWU4LWMyNDAtMDdhMWE0MDE3OGJmQGh1YXdlaS5jb20vDQoNClRoYW5rcywNCkpvaG4NCg0KRG9u
OiBUaGFua3MgSm9obiwgYWRkcmVzc2VkIGluIFY1Lg0KDQoNCj4gICAgICAgc2hvc3QtPmhvc3Rk
YXRhWzBdID0gKHVuc2lnbmVkIGxvbmcpY3RybF9pbmZvOw0KPg0KPiAgICAgICByYyA9IHNjc2lf
YWRkX2hvc3Qoc2hvc3QsICZjdHJsX2luZm8tPnBjaV9kZXYtPmRldik7DQo+DQo+IC4NCj4NCg0K
