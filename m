Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D80FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 10:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2719361924
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 10:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3KIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 06:08:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25294 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231532AbhC3KIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 06:08:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UA2oIk004771;
        Tue, 30 Mar 2021 03:08:28 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37kh3n30uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 03:08:28 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UA2m1b004745;
        Tue, 30 Mar 2021 03:08:27 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0b-0016f401.pphosted.com with ESMTP id 37kh3n30uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 03:08:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWLIx5iJRXBkYQRmqeqK5oU11UfPib9cddEE0Wbkw8www36Cz/oh782Vu/mt15OVeRBHR4vWSizEsroKMqVvzSYbu4/XRFKCXTS9niTgoc0th3PFfD0lMvurZJGTdbdwnIWmzxY9kJLp6OT68pxcL4AUDNURTkT2eRbevKCvF1Dcxe6HmxauPCpVjWIj3vDA68U6SDmLuzMjNvkHnayvlLVQuFklUFMUNpUbT5qjWHiluwHZriuFQU5YwJbY/k7Ib8YIc1x6FBPhBxMuAQqH21J8ExpEAhIV83+A45+sB+CUXNZ3fXGH9iT3/dCSCe9tCkNLK0c37hg2BZFY0cYxaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5VXW2PGsZERbmyoCEXwpXDzR6iI4ijet8ljgXUFdpk=;
 b=QkyPcbKVzAKS4TUi7O//7QSCwfI3+OykIJaa/e2uahuoIff6+shuBKEXHPwy7b90r5E/1oE+q7BtwAWmhaPy0r8o3APV7AzJOZXOI2hflUPf1GZ/Ho9SoiVdG4+sXdBTbgyq1qFbEjRhN37eGaFsvgwwyNPuMB91dgDE995cvMJMjtTd4owT5TqL5q/QRF52+PgIUOaRVw1T9T+LqCAHdmUNubhOZMlKDCypq/8r2cRFVDhBKCy0CGlFfkFFMLY7gql0TUuA7DZ1fix5NYcuZs7xLfwnnsPtSxEG21FK9TDOSzM4lfnGRJhNPDvvGgeCum2AMhIG3Ljq8akkcgyTQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5VXW2PGsZERbmyoCEXwpXDzR6iI4ijet8ljgXUFdpk=;
 b=r7JmTgtFwxCLxfsz6WbzR3Go78BkA6LNXIeEPjdlfM5Ewe35urhoKvnyCTjHg+P2wjndU00xTe6xUQODGLeTBnAMJtanqPNtBSp2xgY7BQkjf3yOPK0TP/PPXo34M8wVmfY2dcUvQK2bfP/MBmZOi8SBPGz8+VNQ6cdU02Z5ht0=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB3963.namprd18.prod.outlook.com (2603:10b6:a03:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 10:08:25 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 10:08:24 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedi: emove redundant assignment to variable
 err
Thread-Topic: [EXT] [PATCH] scsi: qedi: emove redundant assignment to variable
 err
Thread-Index: AQHXI13hCZ2/C/NFmkGb52HaklCpmqqcUliw
Date:   Tue, 30 Mar 2021 10:08:24 +0000
Message-ID: <BYAPR18MB29984F8A199AF8581CC88F37D87D9@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210327230650.25803-1-colin.king@canonical.com>
In-Reply-To: <20210327230650.25803-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.74.174.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fa8efb3-a2e9-4484-83e6-08d8f363c172
x-ms-traffictypediagnostic: SJ0PR18MB3963:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB39633C9A911E22455D57E327D87D9@SJ0PR18MB3963.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCoyf7jQf3JruuwexxaX2xC+P+twik23PYRxpXkGi1iKVgcbD5Hod9YdkKK8d+S9beksmrMSAfYWoKW44cAFGFiBzdh24qB9ewceEGMhlkm3j7uiIje5UJOmL2yAz4gDYeURvM0/oxbZrBdanyA1XSImFhbtJpSsx4vgY+ZPBKxWLwWPGnCVh0H6IZFgggNtSi3Sx57hvanbXljz9UMmDJBZ9nFGakleS7WQrLtsRnoRvJ/Vo5cXSVQFTjx6pRpr1/ekXMmySC4LV4cevsHpUVueDMQXzR71cPR7c6ORAzXusxG3NDgAVf+qlgvOxfJaUxub7fHrC9fRYpnfUFMyGE/9oC0ob9zDwk3Gs3VuW0pPEU5CiCkn6s9akqyCGk34lpfrtAxbiQxRNv6LXttfpqWesqNNbH2GHm7wOxT+x63AQk6mSnYFAIRwULkKGgxi55RDqQI3a7BSfuDTmigBxKs8AQVPUFD1fXXRTuIGJPstbuxV8b4Nh+ngg2nTwyJCF4j+If4+I4gfy/D++Ji+NFJZSqMHwm9Q8kvokGpeF0mL3XFH6/7hBxYABdgwrOzfa1JXQjf5IKB855avHTtGAJ3QCpp2Ks7bjtjcSkPG9Q0p6ZziAiJwQm1AtSegcpYBJVWyhN+gcQoX9QdCyCzDI3YghL4CvUUmFUxiCUwY0Vs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(66556008)(53546011)(5660300002)(7696005)(86362001)(71200400001)(2906002)(52536014)(76116006)(6506007)(8936002)(4326008)(110136005)(186003)(54906003)(478600001)(66446008)(83380400001)(66946007)(316002)(64756008)(55016002)(26005)(38100700001)(8676002)(55236004)(66476007)(33656002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bm15dmFDM1NYK1ZOeVdSOWJQZXpicXg5dTRVdDE4ZWMrc1FmejNWZThJNDVU?=
 =?utf-8?B?RC91dFV3L3J4VGVwREZ0cm9KZDdsMlFmaHVucnNXMnYyTnBybTJoZ2tTVzdW?=
 =?utf-8?B?MWlYUWYvNE5KUHNqWGJ2N2h5ekg0cXQ2L3FuMklQMlpKelV6UFk2Z2FFU2ti?=
 =?utf-8?B?bWZGY2FOY2R2QmhIUytJQ0ZkN2N4THRsdTljMVVCVXJ3WXVwUGpBT3R3d2lG?=
 =?utf-8?B?T1BNVndEY21CTExadlZoWVFJT3NOOVhKSUkwUFExZkJIV3ozTVdZRUsvMDN4?=
 =?utf-8?B?M0FuSjhMdk84VHhTL2c0aTEyYVFUbEVVT21rUjkwZGZxeVVpczZ1NjJEdUpn?=
 =?utf-8?B?K2hoWld0MzJjVlZVYzRrM2N2MXdYQWZGa2VaeStTS1dKN0NjeUNGVldIMXFL?=
 =?utf-8?B?TGphU2xLUXRldy9zMVV4TVdIRy9hODhOZXBlMklIZ09DN2pBMnc0R0F4QVA2?=
 =?utf-8?B?OGxZd2habWVEVlRYYzJmRnhzWEJ0RTZKV1FwNHpOcTJ6T0I2R1oxdkVaSHZD?=
 =?utf-8?B?cFoxdWxBWUpsMVZuNFJvblZ5QUVUWXVFbnVDclVsejVzSFhETnJ1bW90UW1u?=
 =?utf-8?B?bk9xTkxxZDVURGFzdTk1NGo2N2w4RnpkSTVKNDZ5Y0NldGQ5K0ZMcGVpUkhw?=
 =?utf-8?B?TFAzM1ZLbmhCK2R2WHAydVMxRjB3SlJlTkhqL0lqbTh2NW56RUxDM0EwdGJB?=
 =?utf-8?B?UEsrR1FvZEoxRmZ1QWNsZzJQbE5QVUwzeFk5TS9oTzRlUDRWL1BXK3FoUHN2?=
 =?utf-8?B?bFM5U1VoaFk4azdUdXVRMjNlQzB6U3gvS3FDNFhlQy9xMDB3cHovVmpnd1ZP?=
 =?utf-8?B?b0l0V1IwOU15WFdRYWZKdFFZd1BLSkZoaDBiT3VIRG1kemRwQnF1UTRrT1Ez?=
 =?utf-8?B?YmlwWTNDNUNtdlNsVE10c0x5QUxHUDhxUGdzVFZMdjJaK1M0RklYditKZ2lH?=
 =?utf-8?B?bXVWZTFmZFJLaHZ6V2tWVEJ3V3hmOEJ3RGQ0bWdEUlNRQitTUmRtL2VLLzRw?=
 =?utf-8?B?WmQrelRkeG1tT2FhK1p3bFpEVUlqVmRlQW81L2tWNm5mSndNMkd0TjI1dU1s?=
 =?utf-8?B?SEQzOThKS2hRcFVBNXlleDJDd0VNSXpnN0VhQXZPUStQT1hpa2FxdTNZc2NP?=
 =?utf-8?B?dElDYWRkSmExbjFHRHJBRkh2RmRsV2wvZmg4OUJtSGdjczRQQzF1ek1EZHVz?=
 =?utf-8?B?bkhONDNZVzJNVzBCLzZ6T0tuUVlIcEpCYmg3WkVzcm42QkZCSHBkbWo0d1Ba?=
 =?utf-8?B?bzN4M016Q0VaWlh1OWJOMjRMQkswVHhobjhRUXlXdktuMFpxa1ZBekhua3Uv?=
 =?utf-8?B?b3ZXejNQYTROM2M4dFFPeS85dW9QTWNGejdrR21rQWduMXFUaG9xZkU1bnlq?=
 =?utf-8?B?Yzh2ZXp5UlJiWWhCc1hoU1Q3NGdndE1YY0tWT1dMeXkvRTlTNmFCRmg1RXA1?=
 =?utf-8?B?ekkyMVVPU25peXpmN1Y5WmJNbW5NMUxlUVJoUDg4L2tKR3pJTHVNc2RlWUQ5?=
 =?utf-8?B?QW9pdjBTMFkwdVUrYkZuRER1amZlcWZzYlNsbkNHbDZWQmVxanJhZGVNTG1Z?=
 =?utf-8?B?Tm8vbFhuTXVpWGV0MDFSc1BjNyt1TzNzNW9xWXdFY3FnTllHVVArTlJ4NVp4?=
 =?utf-8?B?ejdBREhYZ1RUVnR6K3VUako5c2M0TVVSWVF2Nzh2YmV0eTducEUxNlM5ZlRQ?=
 =?utf-8?B?aW85VUpQMVBRMjk1M05WdmdWS1ErSGRubTRXVTU3YVB6L2NoSzhPb3NwMW1N?=
 =?utf-8?Q?RKgvXfn/EzmlOsKrZrN5uxLbuDLSqFSVutZh+pz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa8efb3-a2e9-4484-83e6-08d8f363c172
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 10:08:24.4295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TkRDh1dTh3mXgZ38RAyQx14ZpsdWHW5I4zJZWcArFg1ToMKkSLwvLFJ/2+cbRhPUJRYVxiTDI2kt0WlIEqi+sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3963
X-Proofpoint-ORIG-GUID: r_9Mui9eboiscEM7jvgDBTKvKZ7pmLXP
X-Proofpoint-GUID: sEy4Nx6AYIwu69YwdphrTnerKeiAyaik
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-30,2021-03-30 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIDxjb2xpbi5r
aW5nQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFN1bmRheSwgTWFyY2ggMjgsIDIwMjEgNDozNyBB
TQ0KPiBUbzogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT47IE1hbmlzaCBSYW5n
YW5rYXINCj4gPG1yYW5nYW5rYXJAbWFydmVsbC5jb20+OyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0
cmVhbSA8R1ItUUxvZ2ljLQ0KPiBTdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPjsgSmFtZXMg
RSAuIEogLiBCb3R0b21sZXkNCj4gPGplamJAbGludXguaWJtLmNvbT47IE1hcnRpbiBLIC4gUGV0
ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsNCj4gbGludXgtc2NzaUB2Z2VyLmtl
cm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVF0gW1BBVENIXSBzY3NpOiBxZWRp
OiBlbW92ZSByZWR1bmRhbnQgYXNzaWdubWVudCB0byB2YXJpYWJsZSBlcnINCj4gDQo+IEV4dGVy
bmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxj
b2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiB2YXJpYWJsZSBlcnIgaXMgYXNzaWduZWQg
LUVOT01FTSBmb2xsb3dlZCBieSBhbiBlcnJvciByZXR1cm4gcGF0aCB2aWEgbGFiZWwNCj4gZXJy
X3VkZXYgdGhhdCBkb2VzIG5vdCBhY2Nlc3MgdGhlIHZhcmlhYmxlIGFuZCByZXR1cm5zIHdpdGgg
dGhlIC1FTk9NRU0gZXJyb3INCj4gcmV0dXJuIGNvZGUuIFRoZSBhc3NpZ25tZW50IHRvIGVyciBp
cyByZWR1bmRhbnQgYW5kIGNhbiBiZSByZW1vdmVkLg0KPiANCj4gQWRkcmVzc2VzLUNvdmVyaXR5
OiAoIlVudXNlZCB2YWx1ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xp
bi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9t
YWluLmMgfCA0ICstLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMyBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4u
YyBiL2RyaXZlcnMvc2NzaS9xZWRpL3FlZGlfbWFpbi5jIGluZGV4DQo+IDY5YzViNWVlMjE2OS4u
MjQ1NWQxNDQ4YTdlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4u
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4uYw0KPiBAQCAtMjc2LDEwICsy
NzYsOCBAQCBzdGF0aWMgaW50IHFlZGlfYWxsb2NfdWlvX3JpbmdzKHN0cnVjdCBxZWRpX2N0eCAq
cWVkaSkNCj4gIAl9DQo+IA0KPiAgCXVkZXYgPSBremFsbG9jKHNpemVvZigqdWRldiksIEdGUF9L
RVJORUwpOw0KPiAtCWlmICghdWRldikgew0KPiAtCQlyYyA9IC1FTk9NRU07DQo+ICsJaWYgKCF1
ZGV2KQ0KPiAgCQlnb3RvIGVycl91ZGV2Ow0KPiAtCX0NCj4gDQo+ICAJdWRldi0+dWlvX2RldiA9
IC0xOw0KPiANCj4gLS0NCj4gMi4zMC4yDQoNClRoYW5rcywNCkFja2VkLWJ5OiBNYW5pc2ggUmFu
Z2Fua2FyIDxtcmFuZ2Fua2FyQG1hcnZlbGwuY29tPg0K
