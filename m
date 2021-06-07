Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE94AC47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C491060FE4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhFGLFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:05:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40402 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhFGLFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:05:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157B1PwI031558;
        Mon, 7 Jun 2021 04:03:26 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 391ecv0swe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 04:03:26 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 157B3PAo002914;
        Mon, 7 Jun 2021 04:03:25 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by mx0b-0016f401.pphosted.com with ESMTP id 391ecv0swa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 04:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCt7g4ikxLqdMs9iK1CmqNMq1IAmAJByl8IStXaTpls+L2QuOKANUVuA68tM8pFcUimpZe6W19lhTWd83cQad16Et6mFaWzDlXLbMZBwl4wzGZrP1/7o5y6S42r4YRtDy8sKmgAF+6Uf0Hg90coZVZGzeQanjbbLVbzNMcMGxORoEfpOwYhbXqfdsHBGgU5e9fBqzAaiwW8M5um2Mdx7MvIP4C6F/Cgk02MBbV19PhNkqiTSYpW1GuuO0U0oAjDTOAjBI6fO4oQpXVAiBXUyCAJGhggjmE4PcT/frO3a1QDt4ERz1db3WHzgqkuweZhkaotydZksOHQDEGH63jE4Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqL46YS/mGksZ297vTA8E+YQjLiDQifZd6BQgzz5c90=;
 b=dELfRnNtCZ3lxCWB6ew4k+0i4febJeao2dmxuuPAb8PbvXFJMRag+zq1+IL8QyvLFk07WsWV9dnLNWbX4ADpuIZhpFsfm3/LURzrWvRMqkLD+nODeg1EX4QU/HsmLNHGVPMOaWAhfDMBdaP5yqZNX9sT6/zSH7UDVv7iYmuwBg1lApK/RTgGU3cwRtziQEYyE/VncGHQARmF0P7oBnr3DjDH/3tSw0wHP1oqpKwp495slxEy3Tx+VCOQbMCoN47RUyeEFL1sdhoJ0U9c/QpSmcslLAiiw4M3DjTXmwN4R4bVTgh3Hg53E/aeXFnJvxdTA8MRtTRvbOz+j0M9+kDQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqL46YS/mGksZ297vTA8E+YQjLiDQifZd6BQgzz5c90=;
 b=rTYLu9fyKqCVsCJ83zfPixr216GLXxKe6mcRffYpy0VuWlPFr7cGTMc7TLp4HzkgUeg699Fa4aUOZfy5e+skNAnTywFtKKkNInxSwpUUR8qcg3+tsmxrZ9vNQLnGEFGAA/UVecHob/iD3jeHG/mb3J/nxCKq6TibupjrWStfzWs=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO1PR18MB4617.namprd18.prod.outlook.com (2603:10b6:303:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 11:03:24 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478%4]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 11:03:24 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: scsi: iscsi: Drop suspend calls from ep_disconnect
Thread-Topic: [EXT] Re: scsi: iscsi: Drop suspend calls from ep_disconnect
Thread-Index: AQHXWMdRIwEjG+/Ba0S1Lc5koOWkbasC7fWAgAAAkACAAXaEAIAD/rpg
Date:   Mon, 7 Jun 2021 11:03:23 +0000
Message-ID: <CO6PR18MB44196A76947072F22AEA6653D8389@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
 <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
 <f2679a9b-7ccf-b4b8-c028-1c164d532fee@oracle.com>
 <2803b5c0-e774-129c-f168-3d5aabf9a6c1@oracle.com>
In-Reply-To: <2803b5c0-e774-129c-f168-3d5aabf9a6c1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.141.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3a98763-d52b-428e-9f25-08d929a3de9e
x-ms-traffictypediagnostic: CO1PR18MB4617:
x-microsoft-antispam-prvs: <CO1PR18MB46173844982A11D697064D93D8389@CO1PR18MB4617.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h755aBW+6RxpXb0n1RRP5ZJx6YRJN1MsS43ujmN2PW8PyisNnEB5Jl8rW8sRitYCaxd5PPaqSVIgF1R+j0RmG5x0ZhIlcIOdnrGQOrR/1CuYBqx0ZW7o84QN6hxa/K/I0SWxWXeOaScR1nbft3NaGIbLYNAzFQ1Jo9e+kAcr/7uceOAtszxk6NBoSUEamOkNNFu/xlBXriA47Jlo0xQsxzkNixeRK3ib9zp/eVTdzqwZa6XR9OdVfBr7YlH+cPuZSmIBoilEj+H6FIRSy2qSKJ42b+dkyWFcdUBDT6NQU36XumFLBxrF3rmi/qI7ff2HvmH9cMEWEfTc7/Tho5/lhNu9wljtlKoknCuz3kj9llZ+ERIbSW8WLFTIv2sF4sOLdmZidNBcgKvNnaLPv5uNMRICETHjnnD/IXnEiniVm0fuRRjAbjV7wFcg7qQsWPsfSiMY1cOCDEedZLLgEXqaqSdmQ0UigKlsnK65AGCn3W23Ie5X2hh7tGubQ0LkUwoR6WRaRdpp6taVT1zMNF18ibjTn1ub+Orq3+xHi/oRSro/zAIqaK/HIXNYdIMAAdHyqOoJfCSYKNwZnVBwcM56SGuR/xxrDwREQZqJi0fy4dk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(71200400001)(2906002)(5660300002)(33656002)(186003)(26005)(6506007)(9686003)(55016002)(86362001)(110136005)(8676002)(54906003)(83380400001)(316002)(55236004)(7696005)(4326008)(122000001)(66946007)(66556008)(64756008)(76116006)(66476007)(66446008)(38100700002)(478600001)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OUREdWlhUU9PQmd0SnJnWTgxTTBWd1V2TW5JTkk2TDRHMmU2VEhpcWpobHJJ?=
 =?utf-8?B?cWFMcUFTL0E5OFNhcUszbUk3SFhlaC9NTlhlMm9LNitzdk92ZXE4YzFpQ3pz?=
 =?utf-8?B?WExsTGQwdUFhOXRvRG0wNzdiQzBPcTc3bVFsbWh4bFhkTTR3TzFvaDFmUkFH?=
 =?utf-8?B?dm15Smx0M05qdWNSeTlsR0pHQ29wcVZPcGdXYjhFYU4yU0lwT2pXUkp2QWNq?=
 =?utf-8?B?ZVdqRkRaM1licUdzamQrWk01SzQzRWswL2VnQ01IZjlUQVdIVlhzQ29Rc1Jj?=
 =?utf-8?B?ODByRWtMb0hGMWlFWWZDZUpybEdUNDB0bkJEVHpnYVc3NFk4TlZYelI3NVV3?=
 =?utf-8?B?MnVjaGhkbFYzbzRKSDVDTkRjNVRSTmczN3FXbEVXWUxmRXdHMFpIZEJ0NFhC?=
 =?utf-8?B?Wmc4S1hWTUQ2WjlHeDBETERWYjlra3o5UG1oYzFJejd5S1BmN01MNm5KUkZN?=
 =?utf-8?B?SC9uMFMxRTRFSURRdGNWc3poNHpTeXVQNHJDandjZkhwNi9uM0theG5GQnBm?=
 =?utf-8?B?Y2c0VnQ1ZWNHdEoxN3lUbjVtMEFDakFMVGR5L0dnVnI5ZmxWSmtrb2o4RXkw?=
 =?utf-8?B?cTlMNUF4czFzSUo0UWR3OHlyWXJqSFFtZ0Z4MncwTk1mTEVsMS9mM1IrRGto?=
 =?utf-8?B?bmNsLzlrZTl2OHpTYVdESHF2TXVjS29vVm1CZDAwckpsTVRmSjNnU3JtNlEz?=
 =?utf-8?B?R2xDWk56V1E4VmN4MVRJbER5bTBqVFpMYlZwOWdBN0kxemVLNi9GSGFmVG8w?=
 =?utf-8?B?TFZsTWNyTFdIb3J3SURrTkl1eGlRSjE2VGREY3hIMmlnYVNOTE9HQ1lVLzdX?=
 =?utf-8?B?ZVk2QnlyaG0wU2liWUJmUk1pVWhmM3BHdlA4N0lhWUU0dUhZQlhOTmhvQ0du?=
 =?utf-8?B?d2U5N2NpQWZXV0ZVQVBOa2wreUFmT3pVZnFDakRpQjFad0o1VG1IU1k4RGVt?=
 =?utf-8?B?NDJiY2JnOU94THhxbC8vcUYyaXBocnBuWldINWFWaEpBaEN6cTViMkVKUDU0?=
 =?utf-8?B?UFhQNFhTbjhkQTRBQ0p5MHNEOFpqU0tPN3IzYmpKR2FicDBibmoyVk9ZdXo3?=
 =?utf-8?B?TU5GWC9QbDNuSk5KSFhURWE1Y1lvMWxwQ2JMaUtlQlQxS1RBZ0VUZExYNjB0?=
 =?utf-8?B?eGZYQ0tDakpDY0x0Q1ZRQWpOSFJZZFJjb1NyNm9zeU5mUkRzWEpIbWxpZ28w?=
 =?utf-8?B?OFl6TFphRzdYYWZXdm12NXlmNW4vOFdUVlQxTThRRVJyb2NuSWk4QWRoRm9P?=
 =?utf-8?B?N2U1OU1sSEJQVXhialgwSDA5RXh2MytUZUFVeWJTdGJjQXRxbnhyZHBIeFpY?=
 =?utf-8?B?a3czQW9zWEVpbnhVMTY4cE5XNTNZQTFsK1FFY3ZQWFlNZDFPOE9KYnhFRmNS?=
 =?utf-8?B?Zzh3UUpHazhhZ0Zzb3htc2N3VWZpN0w2bmx4OHhGb2k1V1hXSXh3WmZYQWN5?=
 =?utf-8?B?Q2tvaHd5UXM0ZStZdkowQzhqT01ZaUFKSnYrY1FxMVBSVS9NRmdMVzZBcjNJ?=
 =?utf-8?B?M2pCSzNCakFtREtRSnIyNHBoREcvRkFzSGx5UXduZjVPS1BnTi81L2VoWFFp?=
 =?utf-8?B?dFBCRlhwc1pVODVQMDlmMlJTM3g2U0RTQlEybXhTY2NJbldsY1BjU0ptRjly?=
 =?utf-8?B?Qi93eDNPNWhCbVRrcjQ4UEp2UEhTc2Rmc3c5STZGVTJ0RlUrUitabytveHhQ?=
 =?utf-8?B?ekNFRmFyeW0vU3h0M25IWjJXSEhiYVNWM1FOTTQ2YVJ1RmxtL20vNlNURzVu?=
 =?utf-8?Q?U2Y81BEttTiQrZ92I+T/foTRfPqy04MDNBhTpoT?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a98763-d52b-428e-9f25-08d929a3de9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 11:03:23.9019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 60cOp28oRPA5gBSd2QShT+fsDRIQv3DnKIi1rDAtPO9x0HfK/U22FII6JY9se5UgxeRrnj/slTI8GoBvaUC9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4617
X-Proofpoint-GUID: XoBgcNMYibdTmmZAqDqfU7rXPjuvP-Bi
X-Proofpoint-ORIG-GUID: HxnAa33BpaBZXFmhObJdWFG78k5h_Cot
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_07:2021-06-04,2021-06-07 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiBNYW5pc2gsIHdoZW4gdGhpcyBmdW5jdGlvbiBpcyBydW4gaXNjc2lkIG9yIHRoZSBpbi1r
ZXJuZWwgY29ubiBlcnJvcg0KPiA+PiBjbGVhbnVwIGhhbmRsZXIgY2FuIGJlIHJ1bm5pbmcgcmln
aHQ/IFRoZXJlIGlzIG5vdGhpbmcgcHJldmVudGluZw0KPiA+PiB0aG9zZSBmcm9tIHJ1bm5pbmcg
YXQgdGhlIHNhbWUgdGltZT8NCj4gPj4NCg0KWWVzLCB0aGlzIGNvZGUgb25seSBleHBlY3RlZCB0
byBydW4gd2hlbiB3ZSBoYXZlIGJvb3QgZnJvbSBTQU4gbXVsdGlwYXRoIHNldHVwLA0Kd2hlcmUg
b25lIGNvbm5lY3Rpb24gaXMgYWN0aXZlIGFuZCBvdGhlciBpcyBpbiBGQUlMRUQgc3RhdGUgYW5k
IHNodXRkb3duIA0KaGFuZGxlciBnZXRzIGNhbGxlZC4NCg0KPiA+PiBJIHRoaW5rIHlvdSB3YW50
IHRvIGNhbGwgaXNjc2lfaG9zdF9yZW1vdmUgYXQgdGhlIGJlZ2lubmluZyBvZg0KPiBfX3FlZGlf
cmVtb3ZlLg0KPiA+PiBUaGF0IHdpbGwgdGVsbCB1c2VycHNhY2UgdGhhdCB0aGUgaG9zdCBpcyBi
ZWluZyByZW1vdmVkIGFuZCBsaWJpc2NzaQ0KPiA+PiB3aWxsDQo+ID4NCj4gPiBJIG1lYW50IGlz
Y3NpZCBub3QgbGliaXNjc2kuDQo+ID4NCj4gPj4gc3RhcnQgdGhlIHNlc3Npb24gc2h1dGRvd24g
YW5kIHJlbW92YWwgcHJvY2Vzcy4gSXQgdGhlbiB3YWl0cyBmb3IgdGhlDQo+ID4+IHNlc3Npb25z
IHRvIGJlIHJlbW92ZWQuIFdlIGNhbiB0aGVuIHByb2NlZWQgd2l0aCB0aGUgb3RoZXIgaG9zdA0K
PiA+PiByZW1vdmFsIGNsZWFudXAsIGFuZCBhdCB0aGUgZW5kIG9mIF9fcWVkaV9yZW1vdmUgeW91
IGRvIHRoZQ0KPiA+PiBpc2NzaV9ob3N0X2ZyZWUgY2FsbC4NCj4gPj4NCj4gPg0KPiANCj4gSGV5
IE1hbmlzaCwNCj4gDQo+IEhlcmUgaXMgYSBsaWdodGx5IHRlc3RlZCBwYXRjaC4NCj4gDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9nYmwuaCBiL2RyaXZlcnMvc2Nz
aS9xZWRpL3FlZGlfZ2JsLmggaW5kZXgNCj4gZmI0NGEyODI2MTNlLi45ZjhlOGVmNDA1YTEgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xZWRpL3FlZGlfZ2JsLmgNCj4gKysrIGIvZHJpdmVy
cy9zY3NpL3FlZGkvcWVkaV9nYmwuaA0KPiBAQCAtNzIsNiArNzIsNSBAQCB2b2lkIHFlZGlfcmVt
b3ZlX3N5c2ZzX2N0eF9hdHRyKHN0cnVjdCBxZWRpX2N0eCAqcWVkaSk7DQo+IHZvaWQgcWVkaV9j
bGVhcnNxKHN0cnVjdCBxZWRpX2N0eCAqcWVkaSwNCj4gIAkJICBzdHJ1Y3QgcWVkaV9jb25uICpx
ZWRpX2Nvbm4sDQo+ICAJCSAgc3RydWN0IGlzY3NpX3Rhc2sgKnRhc2spOw0KPiAtdm9pZCBxZWRp
X2NsZWFyX3Nlc3Npb25fY3R4KHN0cnVjdCBpc2NzaV9jbHNfc2Vzc2lvbiAqY2xzX3Nlc3MpOw0K
PiANCj4gICNlbmRpZg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9pc2Nz
aS5jIGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9pc2NzaS5jIGluZGV4DQo+IGJmNTgxZWNlYTg5
Ny4uOTdmODM3NjBkYTg4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX2lz
Y3NpLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9pc2NzaS5jDQo+IEBAIC0xNjU5
LDIzICsxNjU5LDYgQEAgdm9pZCBxZWRpX3Byb2Nlc3NfaXNjc2lfZXJyb3Ioc3RydWN0IHFlZGlf
ZW5kcG9pbnQNCj4gKmVwLA0KPiAgCQlxZWRpX3N0YXJ0X2Nvbm5fcmVjb3ZlcnkocWVkaV9jb25u
LT5xZWRpLCBxZWRpX2Nvbm4pOyAgfQ0KPiANCj4gLXZvaWQgcWVkaV9jbGVhcl9zZXNzaW9uX2N0
eChzdHJ1Y3QgaXNjc2lfY2xzX3Nlc3Npb24gKmNsc19zZXNzKSAtew0KPiAtCXN0cnVjdCBpc2Nz
aV9zZXNzaW9uICpzZXNzaW9uID0gY2xzX3Nlc3MtPmRkX2RhdGE7DQo+IC0Jc3RydWN0IGlzY3Np
X2Nvbm4gKmNvbm4gPSBzZXNzaW9uLT5sZWFkY29ubjsNCj4gLQlzdHJ1Y3QgcWVkaV9jb25uICpx
ZWRpX2Nvbm4gPSBjb25uLT5kZF9kYXRhOw0KPiAtDQo+IC0JaWYgKGlzY3NpX2lzX3Nlc3Npb25f
b25saW5lKGNsc19zZXNzKSkgew0KPiAtCQlpZiAoY29ubikNCj4gLQkJCWlzY3NpX3N1c3BlbmRf
cXVldWUoY29ubik7DQo+IC0JCXFlZGlfZXBfZGlzY29ubmVjdChxZWRpX2Nvbm4tPmlzY3NpX2Vw
KTsNCj4gLQl9DQo+IC0NCj4gLQlxZWRpX2Nvbm5fZGVzdHJveShxZWRpX2Nvbm4tPmNsc19jb25u
KTsNCj4gLQ0KPiAtCXFlZGlfc2Vzc2lvbl9kZXN0cm95KGNsc19zZXNzKTsNCj4gLX0NCj4gLQ0K
PiAgdm9pZCBxZWRpX3Byb2Nlc3NfdGNwX2Vycm9yKHN0cnVjdCBxZWRpX2VuZHBvaW50ICplcCwN
Cj4gIAkJCSAgICBzdHJ1Y3QgaXNjc2lfZXFlX2RhdGEgKmRhdGEpDQo+ICB7DQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4uYyBiL2RyaXZlcnMvc2NzaS9xZWRpL3Fl
ZGlfbWFpbi5jIGluZGV4DQo+IGVkZjkxNTQzMjcwNC4uMGIwYWNiODI3MDcxIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4uYw0KPiArKysgYi9kcml2ZXJzL3Njc2kv
cWVkaS9xZWRpX21haW4uYw0KPiBAQCAtMjQxNywxMSArMjQxNyw5IEBAIHN0YXRpYyB2b2lkIF9f
cWVkaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGludA0KPiBtb2RlKQ0KPiAgCWludCBy
dmFsOw0KPiAgCXUxNiByZXRyeSA9IDEwOw0KPiANCj4gLQlpZiAobW9kZSA9PSBRRURJX01PREVf
U0hVVERPV04pDQo+IC0JCWlzY3NpX2hvc3RfZm9yX2VhY2hfc2Vzc2lvbihxZWRpLT5zaG9zdCwN
Cj4gLQkJCQkJICAgIHFlZGlfY2xlYXJfc2Vzc2lvbl9jdHgpOw0KPiAtDQo+ICAJaWYgKG1vZGUg
PT0gUUVESV9NT0RFX05PUk1BTCB8fCBtb2RlID09DQo+IFFFRElfTU9ERV9TSFVURE9XTikgew0K
PiArCQlpc2NzaV9ob3N0X3JlbW92ZShxZWRpLT5zaG9zdCk7DQo+ICsNCj4gIAkJaWYgKHFlZGkt
PnRtZl90aHJlYWQpIHsNCj4gIAkJCWZsdXNoX3dvcmtxdWV1ZShxZWRpLT50bWZfdGhyZWFkKTsN
Cj4gIAkJCWRlc3Ryb3lfd29ya3F1ZXVlKHFlZGktPnRtZl90aHJlYWQpOw0KPiBAQCAtMjQ4Miw3
ICsyNDgwLDYgQEAgc3RhdGljIHZvaWQgX19xZWRpX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRl
diwgaW50DQo+IG1vZGUpDQo+ICAJCWlmIChxZWRpLT5ib290X2tzZXQpDQo+ICAJCQlpc2NzaV9i
b290X2Rlc3Ryb3lfa3NldChxZWRpLT5ib290X2tzZXQpOw0KPiANCj4gLQkJaXNjc2lfaG9zdF9y
ZW1vdmUocWVkaS0+c2hvc3QpOw0KPiAgCQlpc2NzaV9ob3N0X2ZyZWUocWVkaS0+c2hvc3QpOw0K
PiAgCX0NCj4gIH0NCg0KQWdyZWUsIHdpdGggeW91ciBjb2RlIGNoYW5nZXMuIEkgd2lsbCBydW4g
QkZTICsgc2h1dGRvd24gdGVzdHMgd2l0aCB0aGlzIGNoYW5nZSwgYW5kIGxldCB5b3Uga25vdyBp
biBjYXNlIGhpdCBhbnkgaXNzdWUuDQoNClRoYW5rcywNCk1hbmlzaA0K
