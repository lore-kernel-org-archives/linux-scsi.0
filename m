Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCDEC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 05:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A7B610A5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 05:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhFIFfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 01:35:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12572 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231577AbhFIFfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 01:35:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1595UZ62021512;
        Tue, 8 Jun 2021 22:33:16 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 39262bv719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 22:33:16 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1595X5OB024887;
        Tue, 8 Jun 2021 22:33:15 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-0016f401.pphosted.com with ESMTP id 39262bv716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 22:33:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7ChbngRA6+HD3gG/+nTHX+glBpmy92Jxr7Wxjczfrk60FAqjWuN7EIWwu6obxxHXxb3nTBjZ0y+ooAlucs0ez0OHT5NaeMjJgEtDjd9A+ntTKPYLtP/8THxBm0JqdKPGjGEKHY9q/6GSA6bu9fuxjxVmghvpt74nf8mBIcpPe5b9EmEu23qC0/MiMDVX7wnLR/NxBl7BjU4Kffx/T4K+vLNh5adzAdI8FtrKCnkrypcg3Sfopb3QWRXhAiJAeG9L6dzSMvjTHRemPTEyNLh5QJ9vWGPOCEjjfp6zICESqZzH/lN5iunO00D3PXdjjnr2f+QRz/vQDjYxS1QUlP5LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEMu17/zgDg/54EtuPF/JDkmiX6R2A1+3gkS0AESJuo=;
 b=a6LluksFLGncykl4kspF8/d1dzTkQmSXATDbDhadTpD3+J1Lchdwi04XsLr8IPkYJ1ca/ayhumsclqcPQTr6/PWF3dcwFIVhw4QOZGqvJpONWmuNbqtTB1AMDZEWv8Y9K24wm8VfniNFmQw/3isXOs5/y7Lc8vSKMz80Lj12ehDpIRfsHUt5O8fDysHwRlppU4OWdWW1grKU9YRCo/LEM98913Rh9E53rJMhaqO59FDeRmROONNB7jKNneVUV0zVlRAtB5HmRhZ6dYNdKRPrDae54880Y1Hh6NsT+9yiVbKfTLTOOtGjXBZQUyZ29WDPUEVaHOniaLzi+dvNeJrXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEMu17/zgDg/54EtuPF/JDkmiX6R2A1+3gkS0AESJuo=;
 b=TiWPVvBAKZeMmSNUcFWOTtqYg842rqu/JOvZ6iad2PsFCB4drT77TFjqR83b3XpcpA2ECjh+j04kxNAdQoisCQ6bWVf5K7JokKAdIDv1SHUPIMKt6No9FYBl33uLZw87pm+VduMP+25t7IKgo61Hxkr4vRsv3kRSDBGYUSGiRZI=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO1PR18MB4812.namprd18.prod.outlook.com (2603:10b6:303:ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Wed, 9 Jun
 2021 05:33:13 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478%5]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 05:33:12 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: scsi: iscsi: Drop suspend calls from ep_disconnect
Thread-Topic: [EXT] Re: scsi: iscsi: Drop suspend calls from ep_disconnect
Thread-Index: AQHXWMdRIwEjG+/Ba0S1Lc5koOWkbasC7fWAgAAAkACAAXaEAIAD/rpggALKvvA=
Date:   Wed, 9 Jun 2021 05:33:12 +0000
Message-ID: <CO6PR18MB4419B4B56AC4293DF5A86F53D8369@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
 <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
 <f2679a9b-7ccf-b4b8-c028-1c164d532fee@oracle.com>
 <2803b5c0-e774-129c-f168-3d5aabf9a6c1@oracle.com>
 <CO6PR18MB44196A76947072F22AEA6653D8389@CO6PR18MB4419.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB44196A76947072F22AEA6653D8389@CO6PR18MB4419.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.141.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14de7030-7254-4ec7-f7bb-08d92b081305
x-ms-traffictypediagnostic: CO1PR18MB4812:
x-microsoft-antispam-prvs: <CO1PR18MB4812AA2C89DA210E0F4715BCD8369@CO1PR18MB4812.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:115;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: av3OfpiNUPRLlQjRPZwgM9eKcry4MMNgklpRp82m8rdURdMS/9hXoYxa/XoxpvAPuieGmLheIF51ERInimPbHjapbOMPxwT4dU9v+rr5bvL2qUM5uj5lnAHkCce7u1Sh85A2qxPpzSUBpDtDY9eC3dsFxUnUplRXzHgwJm/tPmH68gKq+vE8N5ejPitXRW0xny0palf7Rasocf2PrNIoKVaKi1GTzLzK1PIU8KKdCP9UnG/PA2XOSRXABpiyN0ADZWCiaunxtm5NvNNtBwifg/K5PtBsGyQwaj+WvU0Rv26W2pTe8Tc2ffCf04MEpUNQxbqJGWN85zKDMA5Q7SdsrUJi2ZSLRqt2uIJ+wlycM/QN1q9NRsuKanoDpgoc+/CF3xLN1EtnYTMp3T1iDz5sZVLCo0E1HYFw26YSWnE0Kr1g5WGyrKYQcqSgJ+JHOX9rPFM4Q989+U68dAbeLRZ1cIzJTINGoToAULTe+SDs4KgoGecDRQ7ffxGTlWuerKAqBivd5rI3co4oWwFtyEcvGCvL7ki7pjq4pEtTJ99TeNSPw6HoP7lonCe2Uph9t/5E1om6kafSAAuNvhfLSHvcWhipm1zEx4hbABDtAl6AmyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(396003)(366004)(346002)(83380400001)(7696005)(55016002)(9686003)(8936002)(71200400001)(55236004)(478600001)(26005)(2906002)(4326008)(66476007)(8676002)(54906003)(76116006)(66946007)(86362001)(66446008)(33656002)(6506007)(66556008)(52536014)(316002)(5660300002)(110136005)(122000001)(38100700002)(186003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUdER1QvNG41VVZDd21BRy9BRmt6NCtvY1ZZcGZISTVLbWwyOWdiR1FyTVpn?=
 =?utf-8?B?Z3gvMk5sK20ybWMvS2ExVnhnSGdUckNiRjhTTGZnNDBpNlVjc2k2YTlzemJK?=
 =?utf-8?B?dFN2QkdIaUVDbm5TWVZkSWtVTTY5OExhRys1WHA0ZUlRMFJWaE1KSGNVWGx3?=
 =?utf-8?B?UzgrcDhmU2gzSXR6MzdRVXlPZGF6a3dyWDNPcURzcWZ2T2ozNVVzNEtYQm5W?=
 =?utf-8?B?TDlBM3pJL1dkbGx3QTFaVDF2TnhHbnZMZWhuZ1hHKzE1b1JVVitHQm1tR0pt?=
 =?utf-8?B?MHF0U1BabDZWNFFwNnZJdDZQTkdIQzlvRUxyVlJzaWhRZWVFUmJ1RldxdjR6?=
 =?utf-8?B?aE1aMStLM0MreXFwdFRCSGRpQ1g1d1RyUVV6Zlg0dWxFZjJtMk5lNEYyOWhL?=
 =?utf-8?B?bVA3dFU0M0FpRXFZQVVmN1A2cXdGZ1lBdVRqU2pxRzA2RFdadGFLeFArOVRB?=
 =?utf-8?B?M2lXc3dkUXZqZ0NjampRMStUYzVVYzRWZS80NFZ2bjFBUGpaQlFIbDAzTXY0?=
 =?utf-8?B?U3J3aVFMREJTUHVKakxUWm9FbUI1T0pGajU0UFFMaUNCQWh5YzNFd2ttOW1h?=
 =?utf-8?B?eGIvSEdkUHZneEE5QnVreGV5bWVUVlpqYytaVDZqNFU0LzNaUUJxRFh6WEhJ?=
 =?utf-8?B?YTd6MTNNZnJKZmJCU2U4RkZ4YjQ4QzR2UHpDOWNmOC9Sb3FLZGxtcUZSYmZ3?=
 =?utf-8?B?OWVjQWVwYW5HOG5WbGtSTWppam14RmFJUU9hOHAyV0pPMWQ2ZTlzb2lIeXhy?=
 =?utf-8?B?NmZIVGRZSU5OazllRGVRbVJhQVNwc2d1RHh2ZHpnY1ZJZGVEMGhIYzIxenQz?=
 =?utf-8?B?VjhmVUM2TmY2cGRJQWwxR25FTnFNZ3BIMEo1LzhPZEJMQmRnN1RSK1B4NUd0?=
 =?utf-8?B?Z0tsYU42eGRxU1gwUDVTU3NzbFZsTlBPYWNaMFAxRkNFV3ZZS2t6ZXIxMkQ0?=
 =?utf-8?B?UHQzWEhwVjlTMEpIMmlWNjNrejlaWStWU2RzbUJsaURmYmNvRmN6Q0lWU0x2?=
 =?utf-8?B?WTcyYlkyU214eE9iV1JmQVQzcitmY2VlZFRucjZRRXZVcGEzQkt2TXM1eEpN?=
 =?utf-8?B?RmxEU3dtaWlzNC9TUFJVL0lqODZPejB2RmtXZ1duTWxHME0vdUNEckRUbzRt?=
 =?utf-8?B?TWlpUTFBWTV4eFZkWDNoWDlaWEp5bEZPQWVTcHJ4ZHlFKzhaRVJnRUpYTFZT?=
 =?utf-8?B?NmtrSGZUOWIrZVdmbDRmdlpxUFpLekF4dmtBcnVnVSs0VkFiNDd1U0ljd1hM?=
 =?utf-8?B?UE9GRy9EbUpnMWhCUXZ1UVRreGZWTzcySUthb1k2STljbHJLWDY2bjFQYzJl?=
 =?utf-8?B?ekg1NDVNVmlMQ1FFQ2RMd1hCUXBmZGpVcmE1TzRoRzZ3VldYcERBZmNPNCt5?=
 =?utf-8?B?VkJwYytqenFaa09LMURJM05qYktsZjJiRkdYSlk4Mm9odjNueVEyLzJWNWQ4?=
 =?utf-8?B?TnF5bW5IM2ZiRWxNWUFoSzhmdWtseFpaenRPbmczc3M5NGVlc0pseFJaU2xJ?=
 =?utf-8?B?SVgySDlzOXg5ZVVUMlhCU2ovTXFEUHdVbjRFL3FaMDVkcGhDOG1ObkRQVUlN?=
 =?utf-8?B?dmR1dWtlNzFQSXNNZE1YQUxlakxuZmdFR1RzbzNkWUwwQ3B4d2FOZkRMUFRl?=
 =?utf-8?B?bVFZVnQxY1AzTU5oOTRRWlEyV1NQMHNhN3FKWFRMWjJscVpibUJ0WHp1a0ha?=
 =?utf-8?B?WlhQa0VwaSt2MFRuak9TRU1LWnpjMzRmYlpTV2YyVGdmRXY0bTFhVDF2Njlh?=
 =?utf-8?Q?AUrsK7E/mYMZyaTY54wuJCrBUz5j9a4g6WqqYAH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14de7030-7254-4ec7-f7bb-08d92b081305
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 05:33:12.6824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kGFvy3fSuhxqpr/62WVNxqAHz8Tt5JN8CY54r0VxcksYlnBgahAHPzdVMbuDCtISTg31ZbwH7bqA1ig3ynQF6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4812
X-Proofpoint-ORIG-GUID: pDFrH6z3QrjHP2xU4EG22JIIDMT2l6TW
X-Proofpoint-GUID: d3TsDsXa_UfXCnzZ3G8UBfnu8ZZB55hu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_01:2021-06-04,2021-06-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gPiBIZXkgTWFuaXNoLA0KPiA+DQo+ID4gSGVyZSBpcyBhIGxpZ2h0bHkgdGVzdGVkIHBh
dGNoLg0KPiA+DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9n
YmwuaA0KPiA+IGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9nYmwuaCBpbmRleA0KPiA+IGZiNDRh
MjgyNjEzZS4uOWY4ZThlZjQwNWExIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS9xZWRp
L3FlZGlfZ2JsLmgNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX2dibC5oDQo+ID4g
QEAgLTcyLDYgKzcyLDUgQEAgdm9pZCBxZWRpX3JlbW92ZV9zeXNmc19jdHhfYXR0cihzdHJ1Y3Qg
cWVkaV9jdHgNCj4gPiAqcWVkaSk7IHZvaWQgcWVkaV9jbGVhcnNxKHN0cnVjdCBxZWRpX2N0eCAq
cWVkaSwNCj4gPiAgCQkgIHN0cnVjdCBxZWRpX2Nvbm4gKnFlZGlfY29ubiwNCj4gPiAgCQkgIHN0
cnVjdCBpc2NzaV90YXNrICp0YXNrKTsNCj4gPiAtdm9pZCBxZWRpX2NsZWFyX3Nlc3Npb25fY3R4
KHN0cnVjdCBpc2NzaV9jbHNfc2Vzc2lvbiAqY2xzX3Nlc3MpOw0KPiA+DQo+ID4gICNlbmRpZg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX2lzY3NpLmMNCj4gPiBiL2Ry
aXZlcnMvc2NzaS9xZWRpL3FlZGlfaXNjc2kuYyBpbmRleA0KPiA+IGJmNTgxZWNlYTg5Ny4uOTdm
ODM3NjBkYTg4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS9xZWRpL3FlZGlfaXNjc2ku
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9xZWRpL3FlZGlfaXNjc2kuYw0KPiA+IEBAIC0xNjU5
LDIzICsxNjU5LDYgQEAgdm9pZCBxZWRpX3Byb2Nlc3NfaXNjc2lfZXJyb3Ioc3RydWN0DQo+ID4g
cWVkaV9lbmRwb2ludCAqZXAsDQo+ID4gIAkJcWVkaV9zdGFydF9jb25uX3JlY292ZXJ5KHFlZGlf
Y29ubi0+cWVkaSwgcWVkaV9jb25uKTsgIH0NCj4gPg0KPiA+IC12b2lkIHFlZGlfY2xlYXJfc2Vz
c2lvbl9jdHgoc3RydWN0IGlzY3NpX2Nsc19zZXNzaW9uICpjbHNfc2VzcykgLXsNCj4gPiAtCXN0
cnVjdCBpc2NzaV9zZXNzaW9uICpzZXNzaW9uID0gY2xzX3Nlc3MtPmRkX2RhdGE7DQo+ID4gLQlz
dHJ1Y3QgaXNjc2lfY29ubiAqY29ubiA9IHNlc3Npb24tPmxlYWRjb25uOw0KPiA+IC0Jc3RydWN0
IHFlZGlfY29ubiAqcWVkaV9jb25uID0gY29ubi0+ZGRfZGF0YTsNCj4gPiAtDQo+ID4gLQlpZiAo
aXNjc2lfaXNfc2Vzc2lvbl9vbmxpbmUoY2xzX3Nlc3MpKSB7DQo+ID4gLQkJaWYgKGNvbm4pDQo+
ID4gLQkJCWlzY3NpX3N1c3BlbmRfcXVldWUoY29ubik7DQo+ID4gLQkJcWVkaV9lcF9kaXNjb25u
ZWN0KHFlZGlfY29ubi0+aXNjc2lfZXApOw0KPiA+IC0JfQ0KPiA+IC0NCj4gPiAtCXFlZGlfY29u
bl9kZXN0cm95KHFlZGlfY29ubi0+Y2xzX2Nvbm4pOw0KPiA+IC0NCj4gPiAtCXFlZGlfc2Vzc2lv
bl9kZXN0cm95KGNsc19zZXNzKTsNCj4gPiAtfQ0KPiA+IC0NCj4gPiAgdm9pZCBxZWRpX3Byb2Nl
c3NfdGNwX2Vycm9yKHN0cnVjdCBxZWRpX2VuZHBvaW50ICplcCwNCj4gPiAgCQkJICAgIHN0cnVj
dCBpc2NzaV9lcWVfZGF0YSAqZGF0YSkNCj4gPiAgew0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3Njc2kvcWVkaS9xZWRpX21haW4uYw0KPiA+IGIvZHJpdmVycy9zY3NpL3FlZGkvcWVkaV9tYWlu
LmMgaW5kZXgNCj4gPiBlZGY5MTU0MzI3MDQuLjBiMGFjYjgyNzA3MSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL3Njc2kvcWVkaS9xZWRpX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9x
ZWRpL3FlZGlfbWFpbi5jDQo+ID4gQEAgLTI0MTcsMTEgKzI0MTcsOSBAQCBzdGF0aWMgdm9pZCBf
X3FlZGlfcmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KPiA+IGludA0KPiA+IG1vZGUpDQo+
ID4gIAlpbnQgcnZhbDsNCj4gPiAgCXUxNiByZXRyeSA9IDEwOw0KPiA+DQo+ID4gLQlpZiAobW9k
ZSA9PSBRRURJX01PREVfU0hVVERPV04pDQo+ID4gLQkJaXNjc2lfaG9zdF9mb3JfZWFjaF9zZXNz
aW9uKHFlZGktPnNob3N0LA0KPiA+IC0JCQkJCSAgICBxZWRpX2NsZWFyX3Nlc3Npb25fY3R4KTsN
Cj4gPiAtDQo+ID4gIAlpZiAobW9kZSA9PSBRRURJX01PREVfTk9STUFMIHx8IG1vZGUgPT0NCj4g
PiBRRURJX01PREVfU0hVVERPV04pIHsNCj4gPiArCQlpc2NzaV9ob3N0X3JlbW92ZShxZWRpLT5z
aG9zdCk7DQo+ID4gKw0KPiA+ICAJCWlmIChxZWRpLT50bWZfdGhyZWFkKSB7DQo+ID4gIAkJCWZs
dXNoX3dvcmtxdWV1ZShxZWRpLT50bWZfdGhyZWFkKTsNCj4gPiAgCQkJZGVzdHJveV93b3JrcXVl
dWUocWVkaS0+dG1mX3RocmVhZCk7DQo+ID4gQEAgLTI0ODIsNyArMjQ4MCw2IEBAIHN0YXRpYyB2
b2lkIF9fcWVkaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsDQo+ID4gaW50DQo+ID4gbW9k
ZSkNCj4gPiAgCQlpZiAocWVkaS0+Ym9vdF9rc2V0KQ0KPiA+ICAJCQlpc2NzaV9ib290X2Rlc3Ry
b3lfa3NldChxZWRpLT5ib290X2tzZXQpOw0KPiA+DQo+ID4gLQkJaXNjc2lfaG9zdF9yZW1vdmUo
cWVkaS0+c2hvc3QpOw0KPiA+ICAJCWlzY3NpX2hvc3RfZnJlZShxZWRpLT5zaG9zdCk7DQo+ID4g
IAl9DQo+ID4gIH0NCj4gDQo+IEFncmVlLCB3aXRoIHlvdXIgY29kZSBjaGFuZ2VzLiBJIHdpbGwg
cnVuIEJGUyArIHNodXRkb3duIHRlc3RzIHdpdGggdGhpcyBjaGFuZ2UsDQo+IGFuZCBsZXQgeW91
IGtub3cgaW4gY2FzZSBoaXQgYW55IGlzc3VlLg0KPiANCj4gVGhhbmtzLA0KPiBNYW5pc2gNCg0K
TWlrZSwNCg0KTm8gaXNzdWUgb2JzZXJ2ZWQgaW4gbWVudGlvbmVkIHRlc3RzLg0KDQpUaGFua3Ms
DQpNYW5pc2gNCg==
