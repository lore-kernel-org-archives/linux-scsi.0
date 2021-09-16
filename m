Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0CBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 23:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDC0611CA
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 23:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhIPXJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 19:09:04 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:19488
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229997AbhIPXJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 19:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfiTWLCOxz+WlB7gNJNaSZ2RrdXAdLYvM2mgtTk2TqcwFvF2b7xY0CWj8B8BPZywqTu1q3iP/0k7RWzeopBzXZLqWnYaHkMQAx93BM9NZc7J0a/aNlPEg9Nt9V5bS8LE9yblg1yjENboFopyzjHi8/49c5GbLkf6W22EQWzVy/MzjpF9QUSDe26RCiBUarCNEAS5FrzZMrga8rvhTLcZpfanXjgsMj4LK5tGwNX35g9L7qCOT/fo4zyLQnrZV4WpW6kzs3Sr3mowrxyV4Nrnxs2LSLVUnkFkmZKEyEzSjEpa+2b5EPDxmVF9PYWOQ46oWHVoVtWB+g4R0QYUp2lVrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ss9d9SgsN3OPaPDK3si1V2kMh8YSw46slL+xi666vXw=;
 b=AMqfNowWAeIZy94KO/QufgDghdJLkyyrypo8h9i1aDlz7Evur2OjS6TQTrZOPNZCnQRTaAx8bRIWUE8IXANX0oBmcYrVWriwgJCypMUtHwVvfHGf7foUm+GhGso2cS1Z5cC14GiBnO00xt7C1F/HEDFlt7rUlq68bxTphmR57+XaXMJO6+ZfK4NTcdFn6gRimUgQ7lkAHFHlTdKvihffRhCbXMBfz4cuNXCpTAxvEg0fa6gkTX5g0HAff8GJVkbwTXR8tQxaHtnqUcg8SFJvZbyBTi+/6HaI8gGA96bZ7NQy3KownMRhgIFZvM/C7vXyhcQO7uGvrEtZ2HOrnq4Xxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ss9d9SgsN3OPaPDK3si1V2kMh8YSw46slL+xi666vXw=;
 b=JY0pfavXuZwPyHBHPkLoz5hfZTlo3gYPwUvaOHTc8VwoXdl0tvtRI5Hpfe1aHU+2gwSkjQCv6kInb/haiVVY+QlJplBwxhUKqWlHMGJERNNaueKF9ccwfCjlliSN8OFybg3bUAHv2ec5R5xZCR0yXslZZ4EqLMtt0DRNjL9vKgM09dFCVxZSgENQW07wAuwpIL8lZSy44ykUS0OVf8ar50l2v7nH9odd1XxOCHUx+ocSmlOe19B0HVywDawWJZiTdNi7qwILj69fXDTLTDjXB93YQKR75I0VRnL1saNB7QwapyBjccM4l2jMiBTVG5pV+YN3mI1i9WiCO93xpe7dCw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1584.namprd12.prod.outlook.com (2603:10b6:301:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 23:07:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 23:07:39 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/4] blk-crypto-fallback: properly prefix function and
 struct names
Thread-Topic: [PATCH v2 1/4] blk-crypto-fallback: properly prefix function and
 struct names
Thread-Index: AQHXqyMBfcBXr1WhvEyyvG966VbbBqunSQSA
Date:   Thu, 16 Sep 2021 23:07:39 +0000
Message-ID: <550c2308-ed18-93a1-9f35-10ef037b25b1@nvidia.com>
References: <20210916172249.45813-1-ebiggers@kernel.org>
 <20210916172249.45813-2-ebiggers@kernel.org>
In-Reply-To: <20210916172249.45813-2-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7a1114b-b1bf-4364-a678-08d97966c7e1
x-ms-traffictypediagnostic: MWHPR12MB1584:
x-microsoft-antispam-prvs: <MWHPR12MB15841CA1DA64D3E27449150CA3DC9@MWHPR12MB1584.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+jqL8+q+aD1OnOGOH5f8nKclo76VxK4tzdk+Z45Um+Tt1uMvh3IRZURnh3R2dkJo5jFfGZT7phH+Ydb/wtWSJMgzS+34r8wyy7Fp6Lv4Egrku+DkT3OzAdr98QUW1LQqyFv5vc6DOo6xRD3ri5a7CRYFPoghGpjgtMsAxOjWICbVwz6sf3sl68IirDsv+yJmqgKckswMq7vvlnM92XHiD4LEObNmRHIT7SVS3lkax27kjO1odwiRv/2YSbD1bkTI3PQifa9ihNIjv9R78v3afLMH3aTfKkbr1dkarQgO+x2ePiniKRRC0FUPDpq9Vn74ivD3PdmnLO3sCnF31otnP9atK1Rl5p+J4kaOc0vozi6Atf9JwtZLQwDc9MbDgRWydNytT52m8zqGL+Z/U985s4Yofr6zHfSxlM1PZQp/y8QwdKJftQ0eopvsXyKW8Jh7KULT7arlmKkBzMKblU80Y8J10ztZZzb3jlVUnQS26k8owqdoSxk4zj+vcV2P2lvUfVlgvXekcDBvJa6ETtBUPiYLkYYKEgMK0QIsw25/1rgHoK6+Z+2nrZ7vgrIdIhwnN6odRopQetvJn397nJDbv10lEKDHOGXx6lDj6EvJ95ey0BxOSoz3MbJRmq1NBND21JjBkOwpCkCYyzMuY7/D2P21FJiCXZJ3+wlkRHjmhmMIRrAOYEwBM8YRkCCn0qCM1Z9envze8vOKAEogwNhmKq5hC2MKtibYr0WnL8ab4g93R1XsAA277zeMpj1uHoTTNhxJnBGm2Anp6oCQPIa/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(5660300002)(53546011)(2906002)(6512007)(38100700002)(122000001)(54906003)(36756003)(2616005)(110136005)(66556008)(64756008)(66476007)(66446008)(76116006)(71200400001)(66946007)(8676002)(4326008)(31696002)(31686004)(186003)(316002)(38070700005)(4744005)(86362001)(6506007)(8936002)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REpYOGJrbHZISm14aVRlU0dkUW9HYVpyaVZZNFFlc2Z5Z0tYeTllNEQ0QU10?=
 =?utf-8?B?SVV0R2gwR2pRLzd1Snh6RWsyRTlxMjFtNnV5OGRRbGY4eW5idFNUY2VQUjE2?=
 =?utf-8?B?MDYvckpzQ0pNSFZFTzF1VWZzRUc5a09TYUpneE0raEwyUythL0FEZTZmdVoy?=
 =?utf-8?B?SE13QTJkTmR4dGhFTTc5QU1nNHNUdWkzaXY2S3Rxd1RCNVVYa1JCc21pVDlU?=
 =?utf-8?B?ekd5bWFBa3ZkcGo0ZW5SMzhwNHdhUDJqWUFHRjVad2swQko3NlFSUzZFdDQr?=
 =?utf-8?B?M1FadHRIaWs5L1pkZGttcG9TVWVJTEgzV21zdTJEb2JOQVFxTVREd1dXTVk4?=
 =?utf-8?B?RlFvNWtXbHBETkk0c3RQOWN5dGdUbEdqeHN0eHRXVmRkR3I2Z2M3NFc5WkIz?=
 =?utf-8?B?T3B1ZnpCOHp6S05HcjArNVhpV0VhRHFIRnNyMlFqUDNUVTVPWmVqbHNOaC8v?=
 =?utf-8?B?TFl2Qm1sSTB5ZDlpTEZtZnBSS0ZjMW9XYVJ0eVhBZisvSmN3Y3NEOGJlanV6?=
 =?utf-8?B?UDZZK3BtQjNIQzVhT29Jd2Q2RlhmYWQrZVZIdnRoZVBzQ0xCa0h0SjQ1NWZ6?=
 =?utf-8?B?Q21sODRmY3BFY1NRaFFadXoyUnRoNHl1QlR6WC9MTk1DbVZ3bzZ4d0VwOXdV?=
 =?utf-8?B?VjFMZGY1ZGE3MDhUMU9FalUyYXUrQ3BNb3NubVZJUUlnZUcyS1R2TnRMV0Jt?=
 =?utf-8?B?dE1oUm1BSGdlc3lNR1NWZXVnNGlzNnFKNjN4MWhUYkRHMmZnV05ndC9uVVdy?=
 =?utf-8?B?WDRlYnEwWU00SVJkTzNFbHFwd1dIMXZuWFlmZ09jTUJqaEFkS3A2QSs4VVNY?=
 =?utf-8?B?bmFHdzh1WHUyWmVXenJuRW5vSnE0WWdoeXRSSC9wTDFtUXYxVzBlc3dORjFR?=
 =?utf-8?B?WHZKU25iNW5aN2c2Tk1XRS82WlNLVXFLcXBROFo5TWxkY0tZNytpZit4VkYy?=
 =?utf-8?B?VzJON2tHS0w0L013bDIvbWwwdTJTNGl4U0JBYTVxbnpoT1FwdFBOUlJpMThW?=
 =?utf-8?B?dGM3eDdNNTVObk1ycEZtWmJxcGFialVndVhIR2ZnbkIveXlpbWZhMTlSVVFj?=
 =?utf-8?B?Q253NmQ2aVZLdjNDcHlGVEJWajJMUlRLekhDa3FCb2hJSnJYTGQzbVFUbHZx?=
 =?utf-8?B?L1ljQ0E0cGxnb25GWWFVeXVZOWp2UXpZeXFMYUZ4TDliREJhQnczUWFJaHc2?=
 =?utf-8?B?NUVHVHJjRGJkbngyVVNPWHJ6SkxnaFUxOXkxWWN1Q0d4VHhjYnBIVnN5TXd2?=
 =?utf-8?B?Sm03WUowYXJJVzBtS0cySit2RUx5SFBqTGpXWlJtUEJpczlwMFJBOVhQRm02?=
 =?utf-8?B?cTJFTWovSE5RSEdjQ0F0RDRRN2c5UFU0NWVjL2NqelRFS2tiS25RcHpwQ0wy?=
 =?utf-8?B?cFYyVjZyVEFUOWw3blk2eDNIVHRhVjZacmhPWExzVlgwMHdLS29NQ2Q0TGpL?=
 =?utf-8?B?ZERsNW02VlpqRExtM0pyczkyM1dCeEtmWDViME5iVHBibUgxTEt3Qk9kY1Yw?=
 =?utf-8?B?cXVQdlp5cWZkMnVFSkFuaXcvUHYwbk5qclpWb1FhZ1pwbHJxTmFhVHBjN3Vx?=
 =?utf-8?B?YjdDZHNsVjZ4SUVVWnA1QXZMdVZUMktVNHpsRUd5YXE1OUtXVFBCWERZSDk3?=
 =?utf-8?B?L0orN0k3bGJiZjQvZlhIaXE2S241YXJFWVhBaHpzcXFyZjZZempDSUJzRFhN?=
 =?utf-8?B?NFQxcG9ESExtM1hmSmZzN25MbHlvaVRXNVkxMHg4RGJ0amJuWkE3Mk9BbmVI?=
 =?utf-8?B?cW9EL090RXdKYk1ZSkE2c3NidXBmOHgyY0tpNUFBeXJWKzUzVlBOeHcvSFh3?=
 =?utf-8?B?SEZmaHgzVVRJT2haUDdZUkxsU2dXWkR3SlVpYjlxSnJON2pQbktVRGpPOGZm?=
 =?utf-8?Q?VLje14OXP6p93?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D55DEBCE0356647B40B714582C6DE63@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a1114b-b1bf-4364-a678-08d97966c7e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 23:07:39.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1dx9tu1cK6vMBX2cDrvHq9QkqaPeUYNzBG4aEULlNEl85T//dNR/XyzDVSI6aXJ+pi/riKe/rrHZKDfuKgt+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1584
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8xNi8yMSAxMDoyMiBBTSwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KPiBFeHRlcm5hbCBlbWFp
bDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IEZy
b206IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT4NCj4gDQo+IEZvciBjbGFyaXR5
LCBhdm9pZCB1c2luZyBqdXN0IHRoZSAiYmxrX2NyeXB0b18iIHByZWZpeCBmb3IgZnVuY3Rpb25z
IGFuZA0KPiBzdHJ1Y3RzIHRoYXQgYXJlIHNwZWNpZmljIHRvIGJsay1jcnlwdG8tZmFsbGJhY2su
ICBJbnN0ZWFkLCB1c2UNCj4gImJsa19jcnlwdG9fZmFsbGJhY2tfIi4gIFNvbWUgcGxhY2VzIGFs
cmVhZHkgZGlkIHRoaXMsIGJ1dCBvdGhlcnMNCj4gZGlkbid0Lg0KPiANCj4gVGhpcyBpcyBhbHNv
IGEgcHJlcmVxdWlzaXRlIGZvciB1c2luZyAic3RydWN0IGJsa19jcnlwdG9fa2V5c2xvdCIgdG8N
Cj4gbWVhbiBhIGdlbmVyaWMgYmxrLWNyeXB0byBrZXlzbG90ICh3aGljaCBpcyB3aGF0IGl0IHNv
dW5kcyBsaWtlKS4NCj4gUmVuYW1lIHRoZSBmYWxsYmFjayBvbmUgdG8gInN0cnVjdCBibGtfY3J5
cHRvX2ZhbGxiYWNrX2tleXNsb3QiLg0KPiANCj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxs
d2lnIDxoY2hAbHN0LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEJpZ2dlcnMgPGViaWdnZXJz
QGdvb2dsZS5jb20+DQoNCkxvb2tzIGdvb2QsIGl0IG1pZ2h0IGJlIHVzZWZ1bCB0byBtZW50aW9u
IHRoaXMgcGF0Y2ggZG9lc24ndCBjaGFuZ2UNCmFueSBmdW5jdGlvbmFsaXR5LCBub3QgYSBoYXJk
IHJlcXVpcmVtZW50IHRob3VnaC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8
a2NoQG52aWRpYS5jb20+DQoNCg0K
