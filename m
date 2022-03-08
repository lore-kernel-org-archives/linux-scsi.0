Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95487C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 15:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiCHP2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 10:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347858AbiCHP2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 10:28:02 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E294F4754D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 07:27:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0YnU5fbsYj7G58OJfgyv7flCBz0aSozey2iNXsJ/XkusT6wga1QhBE+Utspl8hXUOycCGxg4tJKcNA/1zk2jS3NZYtzZr08UiClKvYE9j2EnXg+zn+h+iw5DSG3KjdIomqr50oSENVDUAzkOGDLVoLi+UaA+SZAep9dbWk+TWh/xXJVqLXzJtNUpzgYQ6FjX2WZzS4s2qxoNia4L006gKBusNdGHd/xAgWrKFNAuuiLAjw3H6/XnTAVsNO6dgJx+E+9qrJPjtbp7mNQvy1FFvb1yPW5O6YGZ1Gz9bqUW1FTNqErza2hA8WHvim2cdW1mU9KX5yXVgwmMCRSmQ8gsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2STBTp1GrFuaWbQcbHKvTlxEsgSmlwe8CZyW2br6Rk=;
 b=DOT3tbJHLibumi2rCFIQLncuLnkR3PXphMVsxs0CPIpf/ZTPThn9JdzrQXJt6OBLYhfqNR7fDTpTz+CEapBaTGdKBQf2KKbUrPWMA9QaG+RU1FOwZA/5ZCJGXWNyk5tsoqo5TuUa2F3z8v/5yCptDyAqpE9ZEpnGGB7oqneTP1YgmGCM33MK6sMGN/4doyFRuxTj9i9vcb3HlGy//L+4UfxFGRsRzvrBlaQ9o7sBaP8ItlJbn3bgP1nVofGL+YyfvzcfC0u1vtodT+lE7By97xDDIagcVcppSXeisQMYOsdX597TcCYLTzj1UhLgDq3LDelj10E698vp+ZWRIJKuEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2STBTp1GrFuaWbQcbHKvTlxEsgSmlwe8CZyW2br6Rk=;
 b=fcWrQn6I8yAQhL+ereF6WZqC8i/GrbOCc7O4mV0ogIXy1I6cVD+XiqcX03szhg8ItgECvcfrkrEd8DM3HBHpD36akEZEdDr5HL0e6hEoNMzT0uWhOoJ5jjIHaKyC2xNChwJrpE9BEry85NCoEVeFn+xSKKWokvQ3gy978canmAI=
Received: from DM6PR19MB4166.namprd19.prod.outlook.com (2603:10b6:5:2b7::22)
 by MN2PR19MB2592.namprd19.prod.outlook.com (2603:10b6:208:102::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 15:27:02 +0000
Received: from DM6PR19MB4166.namprd19.prod.outlook.com
 ([fe80::8dad:a6cd:8f1:e776]) by DM6PR19MB4166.namprd19.prod.outlook.com
 ([fe80::8dad:a6cd:8f1:e776%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 15:27:02 +0000
From:   Matt Lupfer <mlupfer@ddn.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: mpt3sas: page fault in reply q processing
Thread-Topic: [PATCH] scsi: mpt3sas: page fault in reply q processing
Thread-Index: AQHYMwD1qp9F4YgwUEm81nxxXuQA9w==
Date:   Tue, 8 Mar 2022 15:27:02 +0000
Message-ID: <d625deae-a958-0ace-2ba3-0888dd0a415b@ddn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b8aec74-8b0c-41a0-9b39-08da01181861
x-ms-traffictypediagnostic: MN2PR19MB2592:EE_
x-microsoft-antispam-prvs: <MN2PR19MB259258BE1BDA27E6E56A09ACAE099@MN2PR19MB2592.namprd19.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jjXljWaOIdlkzFbfZpkv21F7mtaM5e+dlBdSuCXfdnjn3wW8y10LfUxjZk8SYpX70LGCvppEO1CmSedmvkHYbEmJpbDF5gpVTp0QYqaERbUwD+3eBMPUT4gVrTqBVQUCVczhIshTOD4lAw3rE/RL4PGElySEafX+5jOhPHLlTibjGiQFALeGX0LtUxbhU2VwMvD3fnC9WwLylav5+OiTEG2kuuW7T0eXpxMHGqUKWY1CwjO4qoiq6wEIZoLHiIwas/kOI7J1CYt15qrJIFRQYHwBMhj6eeK1Y9vtmcM737KgytLNENFbicwaOgeskQ+4+udCxA5vGBqXxYumo8xAWKYI+snKd7oHSuW+oq66BQwev/k8dISwtnOTPjDwpjVgjEsF90uwI0ZYf5vdFOumF9wZRm0xkMokQ4mFJkOGoNNn5jCE2Indv1/reKiu42T9NDUcWOpY04ksnwvIaRVxkPvf7fech7ROHm2p0Gj828l4SsM5g9cst2ahBUpc51lejquTDPOV0W9mNob/yXysvyOZz106y1IAYYoZUUK3Vkyd47h7jZODCcvIj5coFUrlVzIb6vqlDdpMNh1F7HQFQA0f8eBGx/n+YFR5bAXOaHoXNQP3txC+5F8LU50WxeSNee8HyYXBgQDGHHcWfiYaPa5HVLCWkrAj7erxOZGaO+eyNLavZUC+cpaTpmrtN8acfwvlx460LMfLRXRzqyvSwiTDfmOkNBSJidfT+abOdkyhBbzIyuc63wl/wlgoGsmB8NHblK/LZdIojRjrzLEydQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB4166.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(31696002)(86362001)(38070700005)(122000001)(83380400001)(316002)(91956017)(66446008)(64756008)(31686004)(76116006)(66556008)(66476007)(110136005)(36756003)(8676002)(66946007)(508600001)(2906002)(5660300002)(6486002)(186003)(2616005)(71200400001)(38100700002)(8936002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Um5jRThuNDROZ1dnOGRTZnRxUCtOS1E4SGIwenJ0QmticjhzbkVXYWZuVFpn?=
 =?utf-8?B?SllpQ01wSDQzQjhycU40MExGVm1RUE96SGc1UWpuclNoNGREOE45OGN5TmRV?=
 =?utf-8?B?Q1ZqVW9sb0d2SDUyeWlWRThJMStnbVI3Z3dJVDhLZ3JrVG1tem1NZC9GNXFS?=
 =?utf-8?B?dDRNQVQvQ0MvMi84SHBGNlU2RFNoMkJ6SDBMS3l3a21jYlVmV1dxZ2UreWxl?=
 =?utf-8?B?NEd4bVpyL0txN3pkU0llWkNkamQyaWFqVVRuVmdZZHNXWlRESXg0T0dCR0xt?=
 =?utf-8?B?RUN4NFZBTDRiYXpabUIrUzhQOUg2a1I1OGQzR2dvZnNadE9lZWNNSGFOL09q?=
 =?utf-8?B?TXUyWWVOS2h3MzV4SGNTV0hzc3ZSRmFjWlllSzFzTWlQM1VUcWdNeHlGVDBk?=
 =?utf-8?B?Y1VvMjlkaW5ZQys5emlBNHpJVUtjUzdTTEppSjkyWmZlY1grcXhDcVNxZnJ3?=
 =?utf-8?B?MHBPZlZ2djUrZkcvTU9GV3JwQ3d6dEtSVTNyNVFTYTluWHVObFhkdU5xOEpj?=
 =?utf-8?B?THYrMFZDY1BaUlc3cVlsVXJDcjJYVmlYOU1xdktCdDFEMVYzUkJzekZZekd5?=
 =?utf-8?B?M0kxK25aYVZ3T1dJYmtWRHVyY2M5eTl3cHBrTnFlQ2NNd01ocTlMS0paZXkv?=
 =?utf-8?B?S2dTZW5XL0lyc2RxbG9QOVhrT1RNVHFyMUZwZ1dIWElUM20rSmM3bSt4NW11?=
 =?utf-8?B?KzZMWjBtd21ucFViek9SUVNIcWNReE9EeHBOeXprY0pHUVFMcFVSZ3V3cUZw?=
 =?utf-8?B?MXBCK2tGd05DaDhrL1ExTkIzRjRaYVpJUXllTXVyY1pnRHJLM0NINFBFaWpS?=
 =?utf-8?B?VjQ5MVFlMlN3ZGdKcWdYNSt6S1pRa3JPazBjS3dsZTRHUTBla0pjTHlNbDZD?=
 =?utf-8?B?YkgrM2tQV1BXS25HOEJPMm9aNUhmbnJ6WDNrNTJQaWpiUGQxdDBhaWY3Y25x?=
 =?utf-8?B?b3Q1d3M3UCtpMWxkMzV3dHgvVUJpTEsxaFF4M2U0bVV1elplQ0dQcGgwd2s0?=
 =?utf-8?B?Sk1UcktFQlVrazRPdDhtTFNiZGtxeVcwUTRLaGNJUE9nNGJQUVdOUEh3dFhh?=
 =?utf-8?B?NnlXbDhvZzAwK3N2b3FZRStWeVF3bHJybnIvN3RvTktGK09MME5sRjh5RVow?=
 =?utf-8?B?UzdXQnRGcFhSelJkaXdaSWRnMDZTNm1CSUFtUWJZZ0RiaHRodzM4Q2FlQzlU?=
 =?utf-8?B?R1ErUVhpeW9QNm44Z0ZXcmdCaGtsYVdGSWRzSmdkWFdoL2dVREZYSzl3Rjdp?=
 =?utf-8?B?czlHNTNzTC8wTVpzQmNaVGpEdS82WnJ4NGgvaWxhZGlOS2lGYjZPcGtoTU5v?=
 =?utf-8?B?cEZURTF6YTlhbGxyY1JzNVVYYlRYRTJ5N1UzMVZVbGU0VkV5QTV2TGgzQWFJ?=
 =?utf-8?B?RjFwNjJkNGxYRHZnZXFMTUk5Vk9mUXZNR2VPbHhQVXo1WU42WUNxTlI0cFlh?=
 =?utf-8?B?Mkd1MWtDdkxFOHZadkkxanlmSmdtSS9UUldBVWY1d05JM1phQS9qRFZ3ZXUy?=
 =?utf-8?B?a08rUU5wcEljcVQ3NkVJbWk3NWRmZ0NRY0pQSzJmdGdkSnNQZzAwTXNzZ0hx?=
 =?utf-8?B?ZWtjWlM2VGJIVjl3bXo3ZWM5MFVUWG4weWZwc3lYMDg3ZmlxUXkxQ0J6NFNL?=
 =?utf-8?B?TGJKQm1qU2RjOFdIdHltWDNoMWF0aUduU3d5WmUrWTZLWGozd2ZRSkx1M0JU?=
 =?utf-8?B?UmJhcEV5RVR3M1JuK0lKUHUrYzVIMXBjM3NiSDMzNW4yV0lvTDA4R0o3TEsy?=
 =?utf-8?B?ZDc5YkdIMTREYUxmRnRDWXVCNFhKTHhRbjNqUzVoci9mQ3p3OTJ2b2ZMSjJS?=
 =?utf-8?B?Rzk3TysxdVkxZlRsbHJtRkxIeTdSOC9IU3dBQWRGdzJFa2d1NmxIS01UL2NZ?=
 =?utf-8?B?RTQyOE4xWTF3UEFLMWp4eUVsVDg5ZnNwY09GRURYUVROcThKQmlQMjZYaWw1?=
 =?utf-8?B?eDNVQlNZVVRqVWJWTjZDVHhWYzU3UGY5eVU4eWtUTzQwa2ZKNWhib1F5N2RZ?=
 =?utf-8?B?V0RVa3Y1WEwrK1Y4by9jMm9jSi82TmUzYkgxOEpaOWNSMnQ0akFYeDFCaERT?=
 =?utf-8?B?MFpUU2tmZk9YcTdUZXh6SkRzcHpxKzhLUWo2aCtDa0JxcTMwZFQ5K01LU2FB?=
 =?utf-8?B?dXNEaXMzVVNLOEU3ckovMDNxQTJBLzZxdW45aElKd3ZhekNlZG5QWVJYRVNr?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C80157177D48FD47A360BB7855CA6FFA@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB4166.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8aec74-8b0c-41a0-9b39-08da01181861
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 15:27:02.5145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71MNc7UTaUcCYk3Zfg7TT6Yosm4T3PlPAmp2Fbw23KyEHWTZ/dw1HRP3Rjgovqx1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB2592
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V2UgZW5jb3VudGVyZWQgYSBwYWdlIGZhdWx0IGluIG1wdDNzYXMgb24gYSBMVU4gcmVzZXQgZXJy
b3IgcGF0aDoNCg0KWyAgMTQ1Ljc2MzIxNl0gbXB0M3Nhc19jbTE6IFRhc2sgYWJvcnQgdG0gZmFp
bGVkOiBoYW5kbGUoMHgwMDAyKSx0aW1lb3V0KDMwKSB0cl9tZXRob2QoMHgwKSBzbWlkKDMpIG1z
aXhfaW5kZXgoMCkNClsgIDE0NS43Nzg5MzJdIHNjc2kgMTowOjA6MDogdGFzayBhYm9ydDogRkFJ
TEVEIHNjbWQoMHgwMDAwMDAwMDI0YmEyOWEyKQ0KWyAgMTQ1LjgxNzMwN10gc2NzaSAxOjA6MDow
OiBhdHRlbXB0aW5nIGRldmljZSByZXNldCEgc2NtZCgweDAwMDAwMDAwMjRiYTI5YTIpDQpbICAx
NDUuODI3MjUzXSBzY3NpIDE6MDowOjA6IFtzZzFdIHRhZyMyIENEQjogUmVjZWl2ZSBEaWFnbm9z
dGljIDFjIDAxIDAxIGZmIGZjIDAwDQpbICAxNDUuODM3NjE3XSBzY3NpIHRhcmdldDE6MDowOiBo
YW5kbGUoMHgwMDAyKSwgc2FzX2FkZHJlc3MoMHg1MDA2MDViMDAwMDI3MmI5KSwgcGh5KDApDQpb
ICAxNDUuODQ4NTk4XSBzY3NpIHRhcmdldDE6MDowOiBlbmNsb3N1cmUgbG9naWNhbCBpZCgweDUw
MDYwNWIwMDAwMjcyYjgpLCBzbG90KDApDQpbICAxNDkuODU4Mzc4XSBtcHQzc2FzX2NtMTogUG9s
bCBSZXBseURlc2NyaXB0b3IgcXVldWVzIGZvciBjb21wbGV0aW9uIG9mIHNtaWQoMCksIHRhc2tf
dHlwZSgweDA1KSwgaGFuZGxlKDB4MDAwMikNClsgIDE0OS44NzUyMDJdIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBwYWdlIGZhdWx0IGZvciBhZGRyZXNzOiAwMDAwMDAwN2ZmZmM0NDVkDQpbICAxNDku
ODg1NjE3XSAjUEY6IHN1cGVydmlzb3IgcmVhZCBhY2Nlc3MgaW4ga2VybmVsIG1vZGUNClsgIDE0
OS44OTQzNDZdICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQ0KWyAg
MTQ5LjkwMzEyM10gUEdEIDAgUDREIDANClsgIDE0OS45MDkzODddIE9vcHM6IDAwMDAgWyMxXSBQ
UkVFTVBUIFNNUCBOT1BUSQ0KWyAgMTQ5LjkxNzQxN10gQ1BVOiAyNCBQSUQ6IDM1MTIgQ29tbTog
c2NzaV9laF8xIEtkdW1wOiBsb2FkZWQgVGFpbnRlZDogRyBTICAgICAgICAgTyAgICAgIDUuMTAu
ODktYWx0YXYtMSAjMQ0KWyAgMTQ5LjkzNDMyN10gSGFyZHdhcmUgbmFtZTogREROICAgICAgICAg
ICAyMDBOVlgyICAgICAgICAgICAgIC8yMDBOVlgyLU1CICAgICAgICAgICwgQklPUyBBVEhHMi4y
LjAyLjAxIDA5LzEwLzIwMjENClsgIDE0OS45NTE4NzFdIFJJUDogMDAxMDpfYmFzZV9wcm9jZXNz
X3JlcGx5X3F1ZXVlKzB4NGIvMHg5MDAgW21wdDNzYXNdDQpbICAxNDkuOTYxODg5XSBDb2RlOiAw
ZiA4NCAyMiAwMiAwMCAwMCA4ZCA0OCAwMSA0OSA4OSBmZCA0OCA4ZCA1NyAzOCBmMCAwZiBiMSA0
ZiAzOCAwZiA4NSBkOCAwMSAwMCAwMCA0OSA4YiA0NSAxMCA0NSAzMSBlNCA0MSA4YiA1NSAwYyA0
OCA4ZCAxYyBkMCA8MGY+IGI2IDAzIDgzIGUwIDBmIDNjIDBmIDBmIDg1IGEyIDAwIDAwIDAwIGU5
IGU2IDAxIDAwIDAwIDBmIGI3IGVlDQpbICAxNDkuOTkxOTUyXSBSU1A6IDAwMTg6ZmZmZmM5MDAw
ZjFlYmNiOCBFRkxBR1M6IDAwMDEwMjQ2DQpbICAxNTAuMDAwOTM3XSBSQVg6IDAwMDAwMDAwMDAw
MDAwNTUgUkJYOiAwMDAwMDAwN2ZmZmM0NDVkIFJDWDogMDAwMDAwMDAyNTQ4ZjA3MQ0KWyAgMTUw
LjAxMTg0MV0gUkRYOiAwMDAwMDAwMGZmZmY4ODgxIFJTSTogMDAwMDAwMDAwMDAwMDAwMSBSREk6
IGZmZmY4ODgxMjVlZDUwZDgNClsgIDE1MC4wMjI2NzBdIFJCUDogMDAwMDAwMDAwMDAwMDAwMCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiBjMDAwMDAwMGZmZmY3ZmZmDQpbICAxNTAuMDMzNDQ1
XSBSMTA6IGZmZmZjOTAwMGYxZWJiNjggUjExOiBmZmZmYzkwMDBmMWViYjYwIFIxMjogMDAwMDAw
MDAwMDAwMDAwMA0KWyAgMTUwLjA0NDIwNF0gUjEzOiBmZmZmODg4MTI1ZWQ1MGQ4IFIxNDogMDAw
MDAwMDAwMDAwMDA4MCBSMTU6IDM0Y2RjMDAwMzRjZGVhODANClsgIDE1MC4wNTQ5NjNdIEZTOiAg
MDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODhkZmFmMjAwMDAwKDAwMDApIGtubEdTOjAw
MDAwMDAwMDAwMDAwMDANClsgIDE1MC4wNjY3MTVdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAw
MCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNClsgIDE1MC4wNzYwNzhdIENSMjogMDAwMDAwMDdmZmZj
NDQ1ZCBDUjM6IDAwMDAwMDAxMjQ0OGEwMDYgQ1I0OiAwMDAwMDAwMDAwNzcwZWUwDQpbICAxNTAu
MDg2ODg3XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjog
MDAwMDAwMDAwMDAwMDAwMA0KWyAgMTUwLjA5NzY3MF0gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERS
NjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDANClsgIDE1MC4xMDgzMjNd
IFBLUlU6IDU1NTU1NTU0DQpbICAxNTAuMTE0NjkwXSBDYWxsIFRyYWNlOg0KWyAgMTUwLjEyMDQ5
N10gID8gcHJpbnRrKzB4NDgvMHg0YQ0KWyAgMTUwLjEyNzA0OV0gIG1wdDNzYXNfc2NzaWhfaXNz
dWVfdG0uY29sZC4xMTQrMHgyZS8weDJiMyBbbXB0M3Nhc10NClsgIDE1MC4xMzY0NTNdICBtcHQz
c2FzX3Njc2loX2lzc3VlX2xvY2tlZF90bSsweDg2LzB4YjAgW21wdDNzYXNdDQpbICAxNTAuMTQ1
NzU5XSAgc2NzaWhfZGV2X3Jlc2V0KzB4ZWEvMHgzMDAgW21wdDNzYXNdDQpbICAxNTAuMTUzODkx
XSAgc2NzaV9laF9yZWFkeV9kZXZzKzB4NTQxLzB4OWUwIFtzY3NpX21vZF0NClsgIDE1MC4xNjIy
MDZdICA/IF9fc2NzaV9ob3N0X21hdGNoKzB4MjAvMHgyMCBbc2NzaV9tb2RdDQpbICAxNTAuMTcw
NDA2XSAgPyBzY3NpX3RyeV90YXJnZXRfcmVzZXQrMHg5MC8weDkwIFtzY3NpX21vZF0NClsgIDE1
MC4xNzg5MjVdICA/IGJsa19tcV90YWdzZXRfYnVzeV9pdGVyKzB4NDUvMHg2MA0KWyAgMTUwLjE4
NjYzOF0gID8gc2NzaV90cnlfdGFyZ2V0X3Jlc2V0KzB4OTAvMHg5MCBbc2NzaV9tb2RdDQpbICAx
NTAuMTk1MDg3XSAgc2NzaV9lcnJvcl9oYW5kbGVyKzB4M2E1LzB4NGEwIFtzY3NpX21vZF0NClsg
IDE1MC4yMDMyMDZdICA/IF9fc2NoZWR1bGUrMHgxZTkvMHg2MTANClsgIDE1MC4yMDk3ODNdICA/
IHNjc2lfZWhfZ2V0X3NlbnNlKzB4MjEwLzB4MjEwIFtzY3NpX21vZF0NClsgIDE1MC4yMTc5MjRd
ICBrdGhyZWFkKzB4MTJlLzB4MTUwDQpbICAxNTAuMjI0MDQxXSAgPyBrdGhyZWFkX3dvcmtlcl9m
bisweDEzMC8weDEzMA0KWyAgMTUwLjIzMTIwNl0gIHJldF9mcm9tX2ZvcmsrMHgxZi8weDMwDQoN
ClRoaXMgaXMgY2F1c2VkIGJ5IG1wdDNzYXNfYmFzZV9zeW5jX3JlcGx5X2lycXMoKSB1c2luZyBh
biBpbnZhbGlkIHJlcGx5X3ENCnBvaW50ZXIgb3V0c2lkZSBvZiB0aGUgbGlzdF9mb3JfZWFjaF9l
bnRyeSgpIGxvb3AuIEF0IHRoZSBlbmQgb2YgdGhlDQpmdWxsIGxpc3QgdHJhdmVyc2FsIHRoZSBw
b2ludGVyIGlzIGludmFsaWQuDQoNCk1vdmUgdGhlIF9iYXNlX3Byb2Nlc3NfcmVwbHlfcXVldWUo
KSBjYWxsIGluc2lkZSBvZiB0aGUgbG9vcC4NCg0KU2lnbmVkLW9mZi1ieTogTWF0dCBMdXBmZXIg
PG1sdXBmZXJAZGRuLmNvbT4NCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQpGaXhlczogNzEx
YTkyM2MxNGQ5ICgic2NzaTogbXB0M3NhczogUG9zdHByb2Nlc3Npbmcgb2YgdGFyZ2V0IGFuZCBM
VU4gcmVzZXQiKQ0KLS0tDQogZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19iYXNlLmMgfCA1
ICsrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfYmFzZS5jIGIvZHJp
dmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19iYXNlLmMNCmluZGV4IDUxMTcyNmY5MmQ5YS4uNzYy
MjliODM5NTYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19iYXNl
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfYmFzZS5jDQpAQCAtMjAxMSw5
ICsyMDExLDEwIEBAIG1wdDNzYXNfYmFzZV9zeW5jX3JlcGx5X2lycXMoc3RydWN0IE1QVDNTQVNf
QURBUFRFUiAqaW9jLCB1OCBwb2xsKQ0KIAkJCQllbmFibGVfaXJxKHJlcGx5X3EtPm9zX2lycSk7
DQogCQkJfQ0KIAkJfQ0KKw0KKwkJaWYgKHBvbGwpDQorCQkJX2Jhc2VfcHJvY2Vzc19yZXBseV9x
dWV1ZShyZXBseV9xKTsNCiAJfQ0KLQlpZiAocG9sbCkNCi0JCV9iYXNlX3Byb2Nlc3NfcmVwbHlf
cXVldWUocmVwbHlfcSk7DQogfQ0KIA0KIC8qKg0KLS0gDQoyLjM1LjENCg0K
