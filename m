Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0284BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC576610C8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbhI1VNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:13:33 -0400
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:26433
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241482AbhI1VNd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 17:13:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa9xR34d9fDMNEna9xk5KUhmtIizy6cJyUjL7mkjrDl5BNAh4LxjqSetUvCcig+p5CFNMMf9Jhn2RVmc5VjsmUXQlFbCH/kl5mK36f6pGHbFZZyHlJyv72697Nu0WI/DCZYcxoiEYaqasqRYUJheXkwfAgwfrKM0+Re9R65H7AfelCumPK2yHXxaajs6nJMqgMr5ZyN7DPr57IF1l+/tmG2behUa3kzn0yKA/8Voa5/81wnRxdkNyKKxlP3l1oKyq6Ix3PObqGvuR5F+fZ++Fc44L9VovDBQg+BBFMF8YB9v2eSpRKS3Urus2Co3Jcbf0jIGUa3tkR7eGHjXrK7KvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=k/L/XrHD+NdJF0cF2Fdxru32kmPTNDVkBph5ZTuPeRM=;
 b=E8nZSrETjV5Tq6ZdfxSvVUuznjP6T/44/wDEbjzfNG27iLlNc9B7IoY7iPoiQW1vWQOFecbDXdcFsPlWvCaG8hT9DczRL53ckxFMS4nkctSo5oJEtMBKtmyl1b1frPb03J9iY+lSDKAeTjOqvo4WqoFa17F+apfjgFs5UnnNp/fwZUKIr39Rcjjc1cPgsEplPP4lT6WF8xp49RS8HgI1C4VISI/b/Lct6oychMkydm6d/E80b9EAL7A3Nvc5wKOU+1HO5Li3WuIr3XefOsENcu2PvPER9ZuvnmKyUF8FxYCQETGaDaZ2M145X7+u0MKmhSwS9CCgNaSxbDAU4s7apA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/L/XrHD+NdJF0cF2Fdxru32kmPTNDVkBph5ZTuPeRM=;
 b=eSYvsmOti+c9D2Z50IKd22pL9U6KLUmcD9uCxLu6LmpKjGzF4baxb9x8Jir0UTvYj7Tas2La2hJSxuEtYzPjBFmtKg9PtphnHA5rdDN+2v7lrmu3OlxUH0pRsI6lti8mk/yNAArUVm3omsM9xjgu2ijEj1OblO2uTjb4K46LYa8+WqmWHfYQrqef5haDC9d9XDOcziVi/bNYGPfdJxG3q3P9V5UE4/gwB5YNIaMJId6o+xa6qUlg01gIUvLhHIh6J68Bg14JUQd/HVSUAnojzQYzYsMB3lJgbo5F3Pg8k+Y5Ptv+ZE6iZIbFgM2lkrO7dyPWrmCbkelL4+jd9E2qjg==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by BL0PR12MB2418.namprd12.prod.outlook.com (2603:10b6:207:4d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 21:11:50 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 21:11:50 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Topic: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Index: AQHXtCkr41vPlTt4RECKC2kVkjtGu6u58pUA
Date:   Tue, 28 Sep 2021 21:11:50 +0000
Message-ID: <e88de776-fae9-7241-b741-9cf467f0965a@nvidia.com>
References: <20210928052211.112801-1-hch@lst.de>
 <20210928052211.112801-4-hch@lst.de>
In-Reply-To: <20210928052211.112801-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7fa7096-e4ab-43c2-f91d-08d982c496dc
x-ms-traffictypediagnostic: BL0PR12MB2418:
x-microsoft-antispam-prvs: <BL0PR12MB241891299982CB7D6C1249F4A3A89@BL0PR12MB2418.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qho/kKl/how5EDvOXmLLc7YAMRQlP9cis1+c8q4eJS+ilPYMJg/Lv9Bjwt0MylImUTw4kBCIs9NgdSeChvfGagLJB6nxLoRud5ThDG+wIWVrLZ51leqoOpe8UdQ3Fk8AeB+Cjj1Uae+a4WVqLvw0/A2tU780IBXfb/47zY07oqe846DYa+pFbfL5qg8eIlVccYenRhUOX+8Gv2j9w5xYiTqi5N39GZ2KVCztWPnWueHgyjHVCvQfqaWH3ZRQkh8rN+FdpAPNsRoo8vzaT0/7D6DOkoSnaki0EYAA7pNLtdmwl6/fXNA35we+9OJxCRsky+Ua0uncwmMj8NkR7NfIkHWgi5nXZTznFYyefNcQpKD1hm0MjVHgdzK6hMVJMHMjXO/HgU3hMYOUCyQD8S7K7sqhwTLeeOHNFz3UZ77n4Aaitm7csQon6MAGQIDa1S3koqIjPOw2VduMsoQDuT/q5gWw4RYPARFhnmbkq5eK9tLt0N9vCqBiCHNJHx2APeH5ZoaRCQfCdArPWpK+DHMyTJYKxJQg2cG4Xmy7WX1WQi78BOg2CVJQl+QIyweWK7+Pkb8mRqcTixkOsR8mlp0U1S0D/54gv/up5IeMUHVlh+Bvg9OjKQ9a2lWszdJl7CJ7M7lBB/g5Te0auAExW0f9w1sSrP/1sTXppCvvPTn5qn+6GWDcOjvbAZ0oLhtwANWwhmJ1SXzvkKwSm3uTdckS4qym5vmT5hPoSgzVoYY7t9qtFJNr8102cUvg8XN+cUSknesnwJ7faq/fOGTQwS03pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(53546011)(2616005)(83380400001)(508600001)(6506007)(122000001)(5660300002)(71200400001)(36756003)(186003)(4326008)(64756008)(66446008)(66476007)(8676002)(6512007)(6486002)(54906003)(110136005)(76116006)(91956017)(31696002)(66946007)(38100700002)(86362001)(2906002)(31686004)(316002)(8936002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2VsMzhHekc1dXlOSVB1V2FIMmRPWFZ0Ukg3TGJXOVhlYTVOV3o4T1JXVXBT?=
 =?utf-8?B?YWFLRlVuR2tKU1V0QUhscWZxaWhvTkZZVGFMdWF5TzZUYjJDRjZzbHlUNDBY?=
 =?utf-8?B?YUw5SWhWSmQ1L1cwVFJPWkJjMnBxRTVsdHg2WFdYeVI1MGNrVzB0YTV5KzNh?=
 =?utf-8?B?bmw1ay9RV3hxVTFGeUJPY3pYc1o5WXBWVTBJNEVtT1o4SnhDdFBDUERWem5q?=
 =?utf-8?B?aWdDMk9LRVloZjdJdE1XMzA1UWpkOERzSG9mUnM1VEVxVDNJQWdZeVA1ampS?=
 =?utf-8?B?cG9xUlFOM3g4dDBSc1o2NWZrOWRXSDNqRjk5Y3hmSnhQd201ZjNDZENTTzhT?=
 =?utf-8?B?MU9ZQnVsSThweFdQSGdRajhIRjU0Wkp0L0lSd0hQa2VkYWI4QjN5S0pQaUJq?=
 =?utf-8?B?UGFBaEZSRFJ6a1ArdWJYZHRJT3UvWVVRUDVzRW9GZWk0TnExbzFrWVBsc25x?=
 =?utf-8?B?d1NHN3ZtQjlmVmtoR3hKcFc0VnZ5ZG8vbVNEc2pTUGZRRDA5dzZDWHNPU2Uw?=
 =?utf-8?B?d2s5eEdNQzFyMW9OaU5iaVZaZzVFeEdGOGJjT08rOXlwMDRJVDd4eURKRkc1?=
 =?utf-8?B?dnhlNmZOR3l2NFR0Rmx1NFJKYzR1S1NFbEhZV0J6UytuVzI1c3ZmZFI4U1Fm?=
 =?utf-8?B?S1hIUDdEN1d2Tk05bGpuRE9WV0F3cmVCZ01CRW8wbTRQZ3BJTmw2S29IcHhK?=
 =?utf-8?B?NlZac1lEYmF2SU5HdC80S1B6MHduRktHWmZTZWsyMmxkUzJZWUw1Sk9VOFpQ?=
 =?utf-8?B?UnQ4MXdkbWovVTRqS2N1KytnbVlVK0tGM1hvZG9OSVpVZGNTak1JSWFMZXVO?=
 =?utf-8?B?Zi8yajZqVEtBd2R3d2VocFBHelJwcEMxVWtPZ3Y2RVlnWURVSExTdW1XN1JP?=
 =?utf-8?B?b1BXZFRyM0JicXFVblZNbWNqRG9qYTloOU1kaUJUb3YzY3l2T3BMTzlHWlVZ?=
 =?utf-8?B?TDRTL0UxbVBjSk1aQUp6TGMrQlpoT256VG1IUjFnczUzS25JaDExUGRqQlY1?=
 =?utf-8?B?a05pSS9sS3VUYmNwazRKT3A0THlZZjU0eGFlNXNIOW9iWCtkOHlrUFhNL0Vy?=
 =?utf-8?B?aitqaHE0RGtaQVFJb1JmZXM2ekZveW9CRlp2dld4TjNWaGJUT0ZjM05IVkp0?=
 =?utf-8?B?NzhEenhLR0VGcnlhQUhkODd5RjVMMmx5bVYzSGNnV3doMW1mMFYzVWI3a0pl?=
 =?utf-8?B?RnJmd0xuUGMySVRsNVI5N2hQVldPRkNobGc5Y0tWS0Erc1Q5elRuMTZvblNO?=
 =?utf-8?B?dUNPSHBHckkvc2Rkc0pRR1lBSE1Ib21teWdPTEQzSDIrNy9JUlM0NVhKTW9P?=
 =?utf-8?B?VTJocCs1YnpMaXhqMEFKaTBYMU1XaFpTZjJOaGlDdHhaTzkxUURyRWE2a2VY?=
 =?utf-8?B?UU91cllrMDRaTGtGRVh2ZE1OT3FGT1BVbHVCMUtFZjRsQStnampRemVVVXBN?=
 =?utf-8?B?Tm9JcXpUWFRmR1E4Ky9pcUhqbUFYQTdtVWxQZGs0bFlpVFl4UkpyUW1sc04r?=
 =?utf-8?B?SzhaemJPc3NRbm5Ta200dE85bk5wQWhMUEZkanRIY1FRcXRCeGZXcGFXNDky?=
 =?utf-8?B?RzR1WnFKTUU2Z2syV1NqOGRwU2EzWHZEdjU1WmsreDl1WTV5aTI3bHRoMjFw?=
 =?utf-8?B?NVpXbU1aUWM1MGt1b2F2eXhleDA0dTVuUkp0N1BzNm5mVDJYeTM1WmdHTFVp?=
 =?utf-8?B?NVEwOEwwNytWcnFuUjZmeERFOGhZNzVpZVJqYzEzYTRhaTcvNERkeTZFUkcv?=
 =?utf-8?B?cGJYSWJVWmhmVGNZdkxrWnY4ZFVTakd5ZlpCOU81TVdjN1RZZ3JUcWJ5clVq?=
 =?utf-8?B?NEZkb2tBQm9QanJzR1plQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CF36C0EF0752F4890AA0F5FA3E8D1A0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fa7096-e4ab-43c2-f91d-08d982c496dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 21:11:50.5051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: byMyQhlnHCWuXuA43hFQepEnZqaAIuTPEPjgWpKn3y1AxGZQoeeCVBMtGBQASWAtrdgOotbhwrEhJ/hbJPbGow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2418
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8yNy8yMSAxMDoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEp1c3QgdXNl
IHRoZSBkaXNrIGF0dGFjaGVkIHRvIHRoZSByZXF1ZXN0X3F1ZXVlIGluc3RlYWQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNClBs
ZWFzZSBjb25zaWRlciBhZGRpbmcgOi0NCg0Kcm9vdEBkZXYgbGludXgtYmxvY2sgKGZvci1uZXh0
KSAjIGdpdCBkaWZmIGRyaXZlcnMvbXRkDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbXRkX2Js
a2RldnMuYyBiL2RyaXZlcnMvbXRkL210ZF9ibGtkZXZzLmMNCmluZGV4IGI4YWUxZWMxNGUxNy4u
ZjA0ODg2OTRhZmRiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tdGQvbXRkX2Jsa2RldnMuYw0KKysr
IGIvZHJpdmVycy9tdGQvbXRkX2Jsa2RldnMuYw0KQEAgLTU5LDcgKzU5LDcgQEAgc3RhdGljIGJs
a19zdGF0dXNfdCBkb19ibGt0cmFuc19yZXF1ZXN0KHN0cnVjdCANCm10ZF9ibGt0cmFuc19vcHMg
KnRyLA0KICAgICAgICAgfQ0KDQogICAgICAgICBpZiAoYmxrX3JxX3BvcyhyZXEpICsgYmxrX3Jx
X2N1cl9zZWN0b3JzKHJlcSkgPg0KLSAgICAgICAgICAgZ2V0X2NhcGFjaXR5KHJlcS0+cnFfZGlz
aykpDQorICAgICAgICAgICBnZXRfY2FwYWNpdHkocmVxLT5xLT5kaXNrKSkNCiAgICAgICAgICAg
ICAgICAgcmV0dXJuIEJMS19TVFNfSU9FUlI7DQoNCiAgICAgICAgIHN3aXRjaCAocmVxX29wKHJl
cSkpIHsNCg0KKiBXaXRob3V0IGFib3ZlIHBhdGNoIDotDQoNCnJvb3RAZGV2IGxpbnV4LWJsb2Nr
IChmb3ItbmV4dCkgIyBtYWtlaiBkcml2ZXJzL210ZC8NCiAgIERFU0NFTkQgb2JqdG9vbA0KICAg
Q0FMTCAgICBzY3JpcHRzL2F0b21pYy9jaGVjay1hdG9taWNzLnNoDQogICBDQUxMICAgIHNjcmlw
dHMvY2hlY2tzeXNjYWxscy5zaA0KICAgQ0MgW01dICBkcml2ZXJzL210ZC9tdGRfYmxrZGV2cy5v
DQogICBDQyBbTV0gIGRyaXZlcnMvbXRkL210ZGJsb2NrLm8NCiAgIExEIFtNXSAgZHJpdmVycy9t
dGQvbXRkLm8NCmRyaXZlcnMvbXRkL210ZF9ibGtkZXZzLmM6IEluIGZ1bmN0aW9uIOKAmGRvX2Js
a3RyYW5zX3JlcXVlc3TigJk6DQpkcml2ZXJzL210ZC9tdGRfYmxrZGV2cy5jOjYyOjI5OiBlcnJv
cjog4oCYc3RydWN0IHJlcXVlc3TigJkgaGFzIG5vIG1lbWJlciANCm5hbWVkIOKAmHJxX2Rpc2vi
gJkNCiAgICA2MiB8ICAgICAgICAgICAgIGdldF9jYXBhY2l0eShyZXEtPnJxX2Rpc2spKQ0KICAg
ICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+DQptYWtlWzJdOiAqKiogW3Njcmlw
dHMvTWFrZWZpbGUuYnVpbGQ6Mjc3OiBkcml2ZXJzL210ZC9tdGRfYmxrZGV2cy5vXSBFcnJvciAx
DQptYWtlWzJdOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KbWFrZVsxXTog
KioqIFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjU0MDogZHJpdmVycy9tdGRdIEVycm9yIDINCm1h
a2U6ICoqKiBbTWFrZWZpbGU6MTg2ODogZHJpdmVyc10gRXJyb3IgMg0Kcm9vdEBkZXYgbGludXgt
YmxvY2sgKGZvci1uZXh0KSAjDQoNCiogV2l0aCBhYm92ZSBwYXRjaCA6LQ0KDQpyb290QGRldiBs
aW51eC1ibG9jayAoZm9yLW5leHQpICMgbWFrZWogZHJpdmVycy9tdGQvDQogICBERVNDRU5EIG9i
anRvb2wNCiAgIENBTEwgICAgc2NyaXB0cy9hdG9taWMvY2hlY2stYXRvbWljcy5zaA0KICAgQ0FM
TCAgICBzY3JpcHRzL2NoZWNrc3lzY2FsbHMuc2gNCiAgIENDIFtNXSAgZHJpdmVycy9tdGQvbXRk
X2Jsa2RldnMubw0KDQotY2sNCg==
