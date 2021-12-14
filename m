Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAF4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 20:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhLNUm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 15:42:29 -0500
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com ([104.47.57.172]:10525
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231263AbhLNUm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Dec 2021 15:42:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nkzl1oty2Wrl2l94GQ89vhhnPiu3I3Kbg6eWwM3NaCAJbzVii825CETCOC//UpNkeFa/5EYWY4I+0cVgaeGDBbx7wl6z4w7/YrEuRUw/AVFa1LJvrFTAtKIeqM4ZtM7Qznt4vkY4/zV2RfpczI22ddnmvcTxqenhf9tSZ0dTVtp0sX3B6QVleLM/tn+kAX1XlkfihJDbvQFjwJCiYl9yeqqPUe08nTg4CMeN7CFWEMKyPVjtxf3RZiueFrg0CS57YmzVEKNwr35ylVRmfpS2ZDAXRD9KYigdrEr0VXbBUzQ514ESKD+HkiBMfrlRLa4DJVo7VENiaNm0FodjUed0kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBkqYbjgd/xJ5MrFm29+bMqkpwwi4MTtwD75NwsbRtg=;
 b=KYVqyb8muQpgHvkmtJNth82JBhbasQtLEOJ0xHDMALgERgfy1d+xohKDXEWp+hG9NE+kRU0b2BQPBCw9ACxNxLWpxWnbvSKyQPj2WQ93Q1qajTXq+aKHy3Z3fM5SZlPQ1IgI/0INZxVJMKSrU8yOHM36eqOVr9bgJvRcHo3rUQQndIVOQCR9T/iqoOx/AYI034tPgbAFGgfHhEIo1s7q8c5eUfWcFbGTplS3o78nzlRcBMqxoM+tGBh7FDnKnGqPuTBaRWKYHkpxiTGuQddbDfMa1nDXHl0v7vsgi5i066FTiIMr/+akvX3+Shq0mDK6Rl08IVLNNHDunsWzlc1ezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBkqYbjgd/xJ5MrFm29+bMqkpwwi4MTtwD75NwsbRtg=;
 b=P4IroITAiMCDNKJnVdR5dre8Hi/WHuXYWtnyx1bWm8d7YvpfqnG2WUo+gwPIkPL9us4xpgkc2Vp8MIzaLF7MaY77rrkSY1RU2RFoM32Mgx1xKO1Q/zyjy2pVdb6nTr8uRLHJ4coMfcacaKcLgK6BBdAQuo1PQfC2PjqaYlX5Dz4=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1622.namprd21.prod.outlook.com (2603:10b6:a02:be::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.6; Tue, 14 Dec
 2021 20:42:24 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9904:180b:e610:fd83]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9904:180b:e610:fd83%4]) with mapi id 15.20.4755.004; Tue, 14 Dec 2021
 20:42:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: RE: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
Thread-Topic: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
Thread-Index: AQHX8PpoClsRLVsDi0+ESXf/1aMhqqwyFd2AgAAPdoCAAE5oEA==
Date:   Tue, 14 Dec 2021 20:42:24 +0000
Message-ID: <BYAPR21MB12705A88AA7BDAEF9A2D953EBF759@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
 <YbiyhcbZmnNbed3O@infradead.org>
 <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
In-Reply-To: <53b6fac0-10cb-80ab-16e7-ee851b720d5e@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1002b50f-d9b7-4bab-926b-42560e253a88;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-14T20:40:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f94de41-51e7-4e0f-acdc-08d9bf423bcf
x-ms-traffictypediagnostic: BYAPR21MB1622:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB1622CFD55D30A451742C966BBF759@BYAPR21MB1622.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ATw1F+7FTGSe8sXyCUDkYn7IPb/eldeB6njt/IrEJHFaKHlUk1GI8fDPlVTJ9Z4OOK+wBO0zd577sOBVrggfb1Iy1xgKwyfW94AXUbdqYIK1xYbQsBQTNAh+U6j7cxWauy5VEkpvyxZBMaBgGakqNtvOVq3H8e9Q2Y3Y+03+S37Ml6ULMVwgSudSVKdZroM/SZQC5O7HnxbvIBefhfokaHVQ5bbhAL52sdLSynv8pGyr5GB4siG6NJo9eFlBZ8JujoFPTH6EOh4fjXicwPMex0TnvoSCQRZ5cxgDOzb1rL8UNJF+XeRuL7xajRvyiE6MzszqLaPrVIfY7d00gqnakrG30LGedcpG4pv9ZKvPLYMNSYKBv5R6bGyEazkhQlccevMyY5IV+OCTV/CW72H18iel1tL68tKou2MXlVhZ4cLbUV7EPE2fl85cuNPIzp8cHpiq2FYU5scB3wGdkMNmw7lzQ9SgSUfw/qRtPl5FO0MIpVkBu+HW7hAc+6Cqfg2R7Vvoa8cnVY5I6DpLTZI9PTK+9pcWrR2BNQQQzkLGCwiCdQsAzOFP5pzq0E+B5686HirT4SGgn2gDg1XihEcqKcLAeEDz3whCMZ5pMqzvZbQ+zgqszPnBBsWKj9udmwH9r45JInNmauay68BB3jm5doO+9z17b7IwQNaczVZBmW/00/jnm6WKuV/NF1+MJuveNbSZOcT06cFgZFTA1eofuf/fSM689MhrG7i/oyeD1Lk2UNfxtB9LYC95d1oz9xh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(7696005)(71200400001)(26005)(10290500003)(508600001)(38070700005)(8990500004)(4744005)(55016003)(83380400001)(122000001)(186003)(66946007)(76116006)(64756008)(66556008)(8936002)(52536014)(316002)(4326008)(66446008)(66476007)(110136005)(54906003)(86362001)(82960400001)(82950400001)(6506007)(8676002)(9686003)(2906002)(33656002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnpxN2ZhRjRRSW04MGtMRXh2Um5TN3RmSkV3ek1aeEpYTkJSd1hBd3FGSWUz?=
 =?utf-8?B?d3A5c0F1YUdzdXhWdXFOZ05TL3M5cVJSYmk3TkNGd2F2QWFEYUV3ZENwMHdZ?=
 =?utf-8?B?dFFPQ3MyUE5HR1FlNjZqbTdqaHZpVFY3YmxHaW9GbjBySWhocTJ5TDZRaEJR?=
 =?utf-8?B?M2Y1TS9tWkZBMXYvK3I5QWYrR0pVQmRvMFhxZU5rUXFETmNUY09ueVJWdy9B?=
 =?utf-8?B?OFVQa1ovTnR4WW4vL2lFVXoxdytRSGZYZGxqcU41aWk3V3Q1YncvU1NwNlox?=
 =?utf-8?B?dzNway91L1pLVTQzSHR0Q2hFME9RbmJJaStXQWVDdmhqMDBGOUg3anh2SGRR?=
 =?utf-8?B?QzB2dmxnQ3NuTTNQSWplUjBqTXIwSUlvbk9MNlkzT0kwRVNzU2xkaE4xSi80?=
 =?utf-8?B?UlY3c25RMnVKVmQzYktmMzdJbUhhS08zKzRHbWlLTmllM21zSXJTaktkV0s0?=
 =?utf-8?B?ZWhWZU52ZFpqNHoySFU4bC9aU2l5a0Fuak1IVk1qTEJqUG9OalVFN1ZJQnF4?=
 =?utf-8?B?bjAzWWw3YlR5T3BnMGhDNEoyZlN3VmF3VllXM1VHM1lXQjl5MFJ4SCtQYk0v?=
 =?utf-8?B?RlQyMi9oZlRLcUVFY0ZmTEJGbDJJNDVFTVAzc0pSWis3WFZMcWk2enVkSXJ5?=
 =?utf-8?B?OThJaER3d29yR08yTzJVMUt6OWZLY0dnSGFWMG9sRDYxWFBzME1iNXRhd0FZ?=
 =?utf-8?B?cldFazFMSG81ek5lK2txcHNRZDNZRHJ5d3hNQXFYNmtsSHdEcjlBQXhMSHQ1?=
 =?utf-8?B?WlhNMEwvbk5nSnBDVDdKSUNDTmJpMHBMcDF1STdBYlRiL2tvalUwSlgrMjN0?=
 =?utf-8?B?TWZReDNQMUJ1ZWVNcEdneUxQK1Vna281Zzk5ZTFLRnpLcUlqUG9PMlV4eFRM?=
 =?utf-8?B?UXIxczFscXlzdUFrcmhaMlVqMytneVJMUjVpM2tLbzI5V1pGNGtXTDV3Unl4?=
 =?utf-8?B?dklxNHFLNlU4VDlJRWovNTVGUWlyeEdCaVYyOUQraXdOa3dKcWlWbnBmOHdO?=
 =?utf-8?B?dVdFdFF5VWJ6SEloZEJwZzNBeWkwcGozSENMVmxxOGxzNmhOY3kwbEF4Zkcz?=
 =?utf-8?B?WGVkc0VGS0lnS1BpYWpjM3pLSi9hUEcrR0p6UUFGZk0reUZFS0UvL0FNRzhO?=
 =?utf-8?B?R1RwRHhubGxvSnNzZllqSjZmT0gvNXllT0ZPMjBndThsZFBtbW9md05Uckl3?=
 =?utf-8?B?c1NGS0QwRDBaWEFDTkRZSk04RU4rQTZjMXduM3JOSUJDTjFaUVlqMXZsUHRX?=
 =?utf-8?B?U0JlUjMxU1ZQRnFzV2doUWlOOVpMcU0waDd3OW9iMk9hTGErRGZOcjRxbklu?=
 =?utf-8?B?ajhZK2l6YU40UUI3WkxJd2JNeU0zYnFLM01jL1p1TGVDL2tNTFBZTUptVGJx?=
 =?utf-8?B?WFZmeXRoNE9la29pbDZjZytkajRrLzR6eWkvaUJRTFFiVGg2dCtSRDl2T0FI?=
 =?utf-8?B?TUZjTWxTdmd6eHBSbFVXQkhjVm1uWkJPc0ZoTDN5dExldWEvclU2WVcrVlhD?=
 =?utf-8?B?eVF4OVU1eDZlSWUraENsR2c0eVBHaU04K2tLcXZWQVdkUW9TZXZLRWQ1ajlC?=
 =?utf-8?B?YlB4SHAwdjVsS2tkWWpPQ3V0Q05xZHBZNXUyZUp5UjNKK2l0cWVmdUFhZUdt?=
 =?utf-8?B?c1VvNldmb1JYczZFdXoxazVoeVY3OHBBYTdWL2xwR0RaMWFManpMcDJPSmc3?=
 =?utf-8?B?N21CWWd3a1RHWVl2YXhoQ1NOR1craVQvbXM5U3B5WXVaWFIwb3owVDBTdlNq?=
 =?utf-8?B?VG1GWjlOMzdDN0pQWHVyUFRVbEk0b3JTbWhpdHRwdXlNK1h4aFcvaFpRTm4y?=
 =?utf-8?B?SHVYbWZQZCs5RzhsR0I3dnRLMXlrZlV6T1kvV1BJK0UxMU1PRzJnc2tOdmNQ?=
 =?utf-8?B?a1pHV2MrRW8xNlorR2E4cDJzOUdPS3FOQmFsQmRuQjZoS1dNTXhFN2pScXlO?=
 =?utf-8?B?Y0phM0RPR0ZyaDlBb2gzM09ZSU1YL1l3WnFVZnd5RTRCT29NNUsxZGc5cDA4?=
 =?utf-8?B?TEMwU1o2YmlJYWJrLytlRVBkaFVKcXVvZWlhV3NWcXJmT3M3RXgzL0cvcFdq?=
 =?utf-8?B?cnhISWZyS2ROL2dMZElQQU9KcEtPb3puSm55MHA2MmFrSnlKUDlNMWY2MUcx?=
 =?utf-8?B?RTNjMFVsWjlUZHRyZUdkNURoSFdDd2JwUHN2UFFjNHVqcHB4UmIzeDNiN0Rs?=
 =?utf-8?Q?bsl2JIyWcldgnnKrbDWZcEM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f94de41-51e7-4e0f-acdc-08d9bf423bcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 20:42:24.0648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BsIGjUxfTj0aD/oDQWPaZurTmewmTuWizlCU0bFXqGjPU+JH8X8Z7x2Yep+m3Wk8oA8H75rc6p6o4Wu/SprSiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1622
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IFNlbnQ6IFR1ZXNkYXksIERl
Y2VtYmVyIDE0LCAyMDIxIDg6MDAgQU0NCj4gIC4uLg0KPiBXZSBjYW4gcHJvYmFibHkgZ2V0IGJ5
IHdpdGggZG9pbmcganVzdCB0aGF0LCBhbmQganVzdCBpZ25vcmUgaWYgYSBkZWxheWVkDQo+IHdv
cmsgdGltZXIgaXMgYWxyZWFkeSBydW5uaW5nLg0KPiANCj4gRGV4dWFuLCBjYW4geW91IHRyeSB0
aGlzIG9uZT8NCj4gDQo+IGRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5jIGIvYmxvY2svYmxr
LWNvcmUuYw0KPiBpbmRleCAxMzc4ZDA4NGM3NzAuLmMxODMzZjk1Y2I5NyAxMDA2NDQNCj4gLS0t
IGEvYmxvY2svYmxrLWNvcmUuYw0KPiArKysgYi9ibG9jay9ibGstY29yZS5jDQo+IEBAIC0xNDg0
LDYgKzE0ODQsOCBAQCBFWFBPUlRfU1lNQk9MKGtibG9ja2Rfc2NoZWR1bGVfd29yayk7DQo+ICBp
bnQga2Jsb2NrZF9tb2RfZGVsYXllZF93b3JrX29uKGludCBjcHUsIHN0cnVjdCBkZWxheWVkX3dv
cmsgKmR3b3JrLA0KPiAgCQkJCXVuc2lnbmVkIGxvbmcgZGVsYXkpDQo+ICB7DQo+ICsJaWYgKCFk
ZWxheSkNCj4gKwkJcmV0dXJuIHF1ZXVlX3dvcmtfb24oY3B1LCBrYmxvY2tkX3dvcmtxdWV1ZSwg
JmR3b3JrLT53b3JrKTsNCj4gIAlyZXR1cm4gbW9kX2RlbGF5ZWRfd29ya19vbihjcHUsIGtibG9j
a2Rfd29ya3F1ZXVlLCBkd29yaywgZGVsYXkpOw0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTChrYmxv
Y2tkX21vZF9kZWxheWVkX3dvcmtfb24pOw0KPiANCj4gLS0NCj4gSmVucyBBeGJvZQ0KDQpBY2Nv
cmRpbmcgdG8gbXkgdGVzdCwgdGhpcyBwYXRjaCB3b3JrcyBhcyBlZmZpY2llbnRseSBhcyB0aGUg
djEuICBUaGFua3MgSmVucyENCg0KVGhhbmtzLA0KLS0gRGV4dWFuDQo=
