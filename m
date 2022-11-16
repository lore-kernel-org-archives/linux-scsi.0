Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DC7C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiKPBJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiKPBJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:09:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EF130F4A;
        Tue, 15 Nov 2022 17:09:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJilaok91A/FF1Cdhf5oPbiOM05UOe3KIWXj/TPXkbR0DgD5p/AQHoy9246TIdFzdBH0zlBSfN6vkEqyn5yA1dVcr7XbnZMtV5u7NLBIb8OimnOYcTPg/J0+DoagAU7MZXqWVmo0xoOjuo9e0R9ZXFDqJ/qAnBaAMyt7kC3KPt8cBYeqcYEvVOnn5cZnEuSavAj70kcrR2buH1laKNlQp4EVb8A2N96wBHAQS3sb8jhjTZMuDl1V09C4g7HIVJEmYrne05vEzC7rzp3IxhSJcWDcbZ6yLTskwAnvVu5nNiaAZcuoc44RqyH6EY+5NM2Dqf18xtyhoqCynpamZCYNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvzQYh0l+k41HhCT5jzsVbGtQkQNk/qfGrph7TdUyRw=;
 b=JdAQj45C77v+D0KwPV/5cV+8R9TkZ63hwPbviS1YXHbt3XjVsUeKEMfxmGik/sLnM89F7mFodQ19OAzlt4EQ12afoTNOPBBzUqMvePO/ZScNklhwKN1725fww4EUjJKZDukqXXVzTcqX1OudWJrxTAAa0+FRysijvKiquzlM4rl4UzgO/+gpfIlWs5birjsLOV1g2+PiUzh+hL/IVU6DcvtwUOKgp2IKEEebXcfjfdy7uLq8k/BHqCCHs2ltmUenF+Cg/y2OWl1hJj1li3POQxo7DiRloGr/CZJsfJohtXvIrd6fjoNmNfEo8zA1trO9Vlrs11oad4G9jkbHN3DmpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvzQYh0l+k41HhCT5jzsVbGtQkQNk/qfGrph7TdUyRw=;
 b=SCbjfiyk/ia9TTEa5A+aEI3UW+cKZEsgQb21FxihMsyl3KA3cQfgLQGlO4o5JlwWmnempQasU+AanyEyhKcYwVVYaoLby0XJltgMiAwzhqeAVhFSYmASmetMo965kFkALCBHy5+tEViROytfiu942WZxh3WPekCUF3dxEXuyYf/BrJ1ocsfghOvuFdfO+JHpNWtloxQicAFQrE/HXG7XlPrL0To+PLPtixNvTdXOYOX/vVK6FiNo2+PE8fN+UsrWFnHCgpwu4PkDmYpwnicJhgMc3l1x+rFn9oxnNgbg/SBezpEN0TpEttNCcyWMxQKi3pyyrgX7UA0mTG/zV02nTg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 01:09:28 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 01:09:28 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] nvme: Convert NVMe errors to PR errors
Thread-Topic: [PATCH v2 4/4] nvme: Convert NVMe errors to PR errors
Thread-Index: AQHY+TldezKj9DwdK0OZ+K+iCM22bq5AvbMA
Date:   Wed, 16 Nov 2022 01:09:28 +0000
Message-ID: <522549b8-d2b5-e056-fc42-e2c6e1f2afb4@nvidia.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
 <20221115212825.7945-5-michael.christie@oracle.com>
In-Reply-To: <20221115212825.7945-5-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4114:EE_
x-ms-office365-filtering-correlation-id: 36525046-3ac2-402c-d0cb-08dac76f35f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +e4BPV28aPIVIG8ylx1bukNFke0IWnwT9G4jubGse+H2TWpN/ve2B5t0RgdmLGedjvxWka3RTndJTkf8TEp9sGmnqEuDikM2SuA9mI29XjXC55PR9VDnVhq7TkTUglSUD50OvdYpBfmJGHRAwr0vxox51vVc38oHjqYeHABNo4iHH4FGEXUMjZ/l11Yztc4GFrN0iZ8shXB+ktGRuMPXADSK4IqiD2CONP7NII8JJv8+hEIViS0GMUTO9zIZ8QOIDP52KwRPgC5jW3AAPRJuNg01VeSeKT/elSBDvzc98RH2n+qKBQO4ujJJZXcz7YCaRicjk0fNBz9qdjG9g9daDiQcAtDKPXkuGR5RB+Ovdx/pMPeuwYIhXnMbFNOkoa195lt/36Ksocqcu7scOSU3/iV9lQjeyHLawDWjnGVZsLVRTlBSN1AfzKD4M0FfF/EAAdBemxXQLp7zko1CeWRUj4baq5W8pv/LchvT4IobNKvinUL1jWjkdPm0Z9PwiLcaRPnMLxtWGTt1yKudqjTUx6JlK+8ll6HLiouQDKXDDQJS+5PRtgfsDptHCsX8DLShSwe/QBN2VpBQk++//XMXKJ3b5ABg2q+EAaFgD80YuwVhL8sDNg97TE7BEuzD5Z56z3yyvl/5aIdiCRw2Mg60ySoD/UWFiASHI+ZJ+AjXZ+OPSUgp5pBhZ2raKhAaY5TWN/Go3GywpfoQV4YYkA75ken+oQLqSDoohCayVZgDqsKQiNrOXkb4mg5rDdZFl1jfRDOk+g1c/dFmHZxGg+rG9j7wgFNvvJZfxzC7uQekwCRz85AlGVhMr8Wlay692lptUUaWPpV1WkbkCn4VURdCkmheTVC2V8fSzZg5jgaj/60=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199015)(186003)(2616005)(6512007)(71200400001)(6486002)(478600001)(53546011)(36756003)(110136005)(6506007)(316002)(38070700005)(83380400001)(86362001)(31696002)(38100700002)(122000001)(921005)(66556008)(31686004)(2906002)(66899015)(66446008)(8676002)(41300700001)(91956017)(76116006)(64756008)(66946007)(7416002)(66476007)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVVUcjFqRWtSM1VyL0dqZXluMk1pbWVZUGlOWUlRaElkT0FJSVp6Z3JWeGJ1?=
 =?utf-8?B?UHIzVTFLU1pNbDlNVDFJV2tnSk9ZWHhlK29CS2U4d2F1ckp0cnRBT05WcHlG?=
 =?utf-8?B?TGM0Zkk5dDVqNlQrNWtDdjZialphdVRGbisyTTM4Rm1Ga3o0OXJkQ0RVM2pG?=
 =?utf-8?B?d2JUVWNCNmkxcFhEWjJZRjZ6Tk9HWHNmeGFiZ2FYRExhbDBxMjVIWkRBU0RF?=
 =?utf-8?B?RzZHazlPcmI1akVmVDVGaXE4NS93UkdOZEZVRDArZ0U0RHdYWHE3NGVoNmhL?=
 =?utf-8?B?blJJR0VwdW5qQm9uMy9ZcU0wa0VCQkJoWmxyTlJlV0N0eUxyOGtjaGhEenhl?=
 =?utf-8?B?Sm1ObUdYbUJIVzhZUkYvUXU2L2l3SnNMV0lBdTRQbFlVMmtlSlBpQ3FRc3lH?=
 =?utf-8?B?STM1eFBtM0U5dGdDSmNxK2hBb3FMbDRlVDNsb2d3Uzl1bzFsR0o5NUNTUmxR?=
 =?utf-8?B?NFgxclJaMHRNR0NGNWFtMTFidzdiWVdpS2QrelV4ZjJEUUtteERDVi9od3Bo?=
 =?utf-8?B?Z3VUUmx5cndXbWdlT3dBS3dWWURMR01RdGErVUsyaTlGM0NEdTJqWi91bTJI?=
 =?utf-8?B?YWovRE1qUXpIT211VWwrb2FhRHZyOG1YQzNOUlRVYnVPK1crQTE2eklxYllR?=
 =?utf-8?B?ajk3SHExUHpYWUs4eEhKbUlsTTliQ2tFM2l1c0pudDArQUt6LzkxeVFnNVps?=
 =?utf-8?B?cFNuaHFvMDZ5cUhXN3lYNnFCcG5TMW9IUlRwdUFLRmlrMkxXYmV5THE4aHhv?=
 =?utf-8?B?WDRRa2VodkVMRlNINGtOeVRsNnZZMXNjc09iQ09UVlpvK21zbTJ2QWVmVWF0?=
 =?utf-8?B?WWVLbEhvcFZQbE44Um9GNEJhK1BLZFpNclBsS2hpSDlYT0tHRHhPL28wZzR2?=
 =?utf-8?B?emdwUEM2bFpYczZZYnRzWCtwa3JkZlBhUE43YWVnblZYdUl4OWI2OGt4cXpO?=
 =?utf-8?B?T2tzeUdpaGhnaWRpUWNsR0VRbm1DcG5ISWFCMm1iQnR3S1BSaTAvS2tadE80?=
 =?utf-8?B?eGl2ZDNQWUo5KzlvLzJYbHNGTlB3SEMxVDNEWVN3bmU1OWhvdVdNL2R6bDk5?=
 =?utf-8?B?V29iNlU1WjViUHVQRXZkS0t3WUNzTE9mY2dkK3hYWk43dXZzanN5UzdkYkVz?=
 =?utf-8?B?Y1lYQUk1N3kwSUs3bjU1MDgyNWcvMGVFM2QwUGZobTJobkxvYzVqeTZ4ZUtD?=
 =?utf-8?B?azJPRVQwM0k4U3g3eUlvUzhpa0FSOURucEtPMS8xcUhaeXA5OWZXYmo5TmNS?=
 =?utf-8?B?ejBxTkhtbGl4SXZicGtybm85QmdYUlJZUnBTUDJTQW9MMnBXSmtaQ2VwYXYz?=
 =?utf-8?B?bnJvcnJXUzFxcXQvVHJzQzJUNnlGak9nN1BLRGJDaFJLSUU2OXQ5YnNQblR6?=
 =?utf-8?B?RkFCc3VwSG9QRzNlWmd2ckxXL3lXQzRtNXpTVG00cUx5RCt1cTdGN0pNQVNm?=
 =?utf-8?B?bjdmMkc2MHE4TGlPVmNhb1ZNMVNFbmhveXFvV0VkNjV0V25jWGtsMkM2TXV0?=
 =?utf-8?B?T0VlbU8wbUFxdnBlbnpnSHpJa3pKQXNpOXJoMWZIZ2hWcDh3UnBKbENQeVFG?=
 =?utf-8?B?UkI3SjVyZG9pbGE0ZVc5S2xVb2ZETnoxOWxlZ0ZrYTV0b2gvc3cxc0U5emlz?=
 =?utf-8?B?TkdjWk9wS1dmbFpGbEZjTXNEb0R0TS90RWhLVm96VHc0SGl1T3hTRG1YVEtJ?=
 =?utf-8?B?QmJVTzl0UWhBdzBrVGN3anU1KzdtK2ZvTTdIc0l4cGp2Y2Q0dkhaNTZoYlJm?=
 =?utf-8?B?eEc5RmFhRHNMMnFjUDdhQTJjSmQxWndvcHZRWGtwT0ExNWFLMWtuVU1xbkFp?=
 =?utf-8?B?ZTFwcHloSnNBcGc0T0p3MThWOEhGY084QjNEb21WWE5JNDlYdW9BTWdzSzNO?=
 =?utf-8?B?cndBa0tidVRhdEtPaFIxSldxMVZ6cy91Mng2SGN4bkZYUjlLZGNNZDk1Z0wx?=
 =?utf-8?B?STlYbXp0c2R4T0FRc3lUWklDMGZnSzNLVlQyREp6T2diS0M5YXVldWhMUDFN?=
 =?utf-8?B?citrQ2dPZDRXbmx6S2kvZERDd1RWZTJManZNalRTallWeUFDS3pGQU11M1da?=
 =?utf-8?B?U1piVGRQeXgzNjloVFZleWVKUncyZDlkcE5sL2ZGSHZzb2s0Mk5JKytRU1lO?=
 =?utf-8?B?eGZMOWFZSUpUaHVsbHpxU3lXMmhZNi9OTlZRWVRoOE9uY3Y4UTdXYzJxaTJO?=
 =?utf-8?Q?pz3ayUn0DUW0NwSzf7xM4GwwBVYWoSbsn8mriVsHK3xf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <367C26E303B4DF4AA10403F4F6159ECA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36525046-3ac2-402c-d0cb-08dac76f35f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 01:09:28.6124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RvxYMM6e7wd7AsLjc+Zm1ULXH5LL/izABELTKfARtd71OqdKd4h9YHnGzIRRaCpIvSb30yarL1CXjuwmOAQ6WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTUvMjIgMTM6MjgsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgY29udmVydHMg
dGhlIE5WTWUgZXJyb3JzIHdlIGNvbW1vbmx5IHNlZSBkdXJpbmcgUFIgaGFuZGxpbmcgdG8gUFJf
U1RTDQo+IGVycm9ycyBvciAtRXh5eiBlcnJvcnMuIHByX29wcyBjYWxsZXJzIGNhbiB0aGVuIGhh
bmRsZSBzY3NpIGFuZCBudm1lIGVycm9ycw0KPiB3aXRob3V0IGtub3dpbmcgdGhlIGRldmljZSB0
eXBlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0
aWVAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIHwgNDIg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCA0MCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYw0KPiBp
bmRleCBkYzQyMjA2MDA1ODUuLjgxMWRlMTQxYTdlZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
dm1lL2hvc3QvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYw0KPiBAQCAt
MjEwNCwxMSArMjEwNCw0MyBAQCBzdGF0aWMgaW50IG52bWVfc2VuZF9uc19wcl9jb21tYW5kKHN0
cnVjdCBudm1lX25zICpucywgc3RydWN0IG52bWVfY29tbWFuZCAqYywNCj4gICAJcmV0dXJuIG52
bWVfc3VibWl0X3N5bmNfY21kKG5zLT5xdWV1ZSwgYywgZGF0YSwgMTYpOw0KPiAgIH0NCj4gICAN
Cj4gK3N0YXRpYyBpbnQgbnZtZV9zY190b19wcl9lcnIoaW50IG52bWVfc2MpDQo+ICt7DQo+ICsJ
aW50IGVycjsNCj4gKw0KPiArCWlmIChudm1lX2lzX3BhdGhfZXJyb3IobnZtZV9zYykpDQo+ICsJ
CXJldHVybiBQUl9TVFNfUEFUSF9GQUlMRUQ7DQo+ICsNCj4gKwlzd2l0Y2ggKG52bWVfc2MpIHsN
Cj4gKwljYXNlIE5WTUVfU0NfU1VDQ0VTUzoNCj4gKwkJZXJyID0gUFJfU1RTX1NVQ0NFU1M7DQo+
ICsJCWJyZWFrOw0KPiArCWNhc2UgTlZNRV9TQ19SRVNFUlZBVElPTl9DT05GTElDVDoNCj4gKwkJ
ZXJyID0gUFJfU1RTX1JFU0VSVkFUSU9OX0NPTkZMSUNUOw0KPiArCQlicmVhazsNCj4gKwljYXNl
IE5WTUVfU0NfT05DU19OT1RfU1VQUE9SVEVEOg0KPiArCQllcnIgPSAtRU9QTk9UU1VQUDsNCj4g
KwkJYnJlYWs7DQo+ICsJY2FzZSBOVk1FX1NDX0JBRF9BVFRSSUJVVEVTOg0KPiArCWNhc2UgTlZN
RV9TQ19JTlZBTElEX09QQ09ERToNCj4gKwljYXNlIE5WTUVfU0NfSU5WQUxJRF9GSUVMRDoNCj4g
KwljYXNlIE5WTUVfU0NfSU5WQUxJRF9OUzoNCj4gKwkJZXJyID0gLUVJTlZBTDsNCj4gKwkJYnJl
YWs7DQo+ICsJZGVmYXVsdDoNCj4gKwkJZXJyID0gUFJfU1RTX0lPRVJSOw0KPiArCQlicmVhazsN
Cj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gZXJyOw0KPiArfQ0KPiArDQo+ICAgDQoNCkxpa2UgbnZt
ZXRfYmRldl9wYXJzZV9pb19jbWQoKSBpZiB3ZSByZXR1cm4gZGlyZWN0bHkgd2UgY2FuIHJlbW92
ZQ0KdGhlIGxvY2FsIHZhcmlhYmxlIGFuZCBicmVhayBmb3IgZWFjaCBjYXNlIFsxXSwgbm8gYmln
IGRlYWwgZmVlbCBmcmVlDQp0byBpZ25vcmUgdGhpcyBjb21tZW50Lg0KDQpMb29rcyBnb29kLg0K
DQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNr
DQoNClsxXQ0Kc3RhdGljIGludCBudm1lX3NjX3RvX3ByX2VycihpbnQgbnZtZV9zYykNCnsNCglp
ZiAobnZtZV9pc19wYXRoX2Vycm9yKG52bWVfc2MpKQ0KCQlyZXR1cm4gUFJfU1RTX1BBVEhfRkFJ
TEVEOw0KDQoJc3dpdGNoIChudm1lX3NjKSB7DQoJY2FzZSBOVk1FX1NDX1NVQ0NFU1M6DQoJCXJl
dHVybiBQUl9TVFNfU1VDQ0VTUzsNCgljYXNlIE5WTUVfU0NfUkVTRVJWQVRJT05fQ09ORkxJQ1Q6
DQoJCXJldHVybiBQUl9TVFNfUkVTRVJWQVRJT05fQ09ORkxJQ1Q7DQoJY2FzZSBOVk1FX1NDX09O
Q1NfTk9UX1NVUFBPUlRFRDoNCgkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KCWNhc2UgTlZNRV9TQ19C
QURfQVRUUklCVVRFUzoNCgljYXNlIE5WTUVfU0NfSU5WQUxJRF9PUENPREU6DQoJY2FzZSBOVk1F
X1NDX0lOVkFMSURfRklFTEQ6DQoJY2FzZSBOVk1FX1NDX0lOVkFMSURfTlM6DQoJCXJldHVybiAt
RUlOVkFMOw0KCWRlZmF1bHQ6DQoJCXJldHVybiBQUl9TVFNfSU9FUlI7DQoJfQ0KfQ0KDQo=
