Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A77BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 106476113E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349456AbhIHOFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:05:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34952 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235455AbhIHOFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:05:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DskmK032515;
        Wed, 8 Sep 2021 14:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zly83zPGc7OES85+Y0dJVekrsrVq4s7UDJwusoSkwqw=;
 b=K++kYmxRSjAvly2zDdZNWD1piIh6IJlb8nDQwZLuyeilgQhgbrohC8ter9J5I64/Rjp3
 gMkscw6UeZSGk44qLu+ACCVdUPduOfkk+z3PpQdOfbtKSGmHpx2bXeOeY3tjH6V+RuBV
 sAg5cedTF6rHcX9nNlI4xr7LwspIufpM7ZbeXSOjRmq7rTLjTfAUErQnAkiNZKk/d6km
 wvIuYD5nAez5WK4OhelFLaY8shiqnTUhaXNlbgY7779K5MmVrFQJ7BDNtTqUDWvmzgMP
 XeeOo3Ssu9dUju6cYaCu5ZZTDvXidKS/RVoPqAJmWjZ3XL4AWuOYJvXbH3OD6vVtaCK1 FQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zly83zPGc7OES85+Y0dJVekrsrVq4s7UDJwusoSkwqw=;
 b=mfWaqVCD1oYqqD6+NhSsoRwzNbxMRsdC7S5KB0gp66kkQ/+JV15NFrINYRcGyv4J5+Ar
 AuryEiVx/Klklef2b7oGo4TViSAZgPSQXLEK9JLjgiQlS1+qdC9oE5CyQlDRp454Fxb4
 j54BKNNn7cX1adc1V+ygCTgG140dhOtm8U0WO5XBrQ8BTQr2E5wIS1F9GqN0ksC/65rj
 PDq7fwirm0XtCoto8McGOBqAmTAxsO8E+SFFpD3AO0wldzATtrdipdylBnXQHL7w3SIZ
 uNE+RqkLMbOk4BbMmN46Tbxke9cJdMPLpJ6McfX9Fk3qav3sQKug0He72OetdUwN6etw 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcuqarr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:04:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188E24Cu038848;
        Wed, 8 Sep 2021 14:04:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3axcpm9mnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PymZdXXnHYG5vHuOldtk6reX+kyjUlOPu10sTjPJIKJhvBeWD4mxRYqPjs+9CsXupClXnjDrp0Upyl6OQ6Z6cYTaKOkfJbsE7/z3/NnftAnmJFUVJAYtqaTucdC/K7CSIRjQaOFRwErJEcAHtESQZu9+KTScWiNh54KzkvWZBGapFQ9XLgZCVZyP3HTH9n+DMoTnA3KJLsilvE4Nh3ClGqhMmyXzvn/Zb/8+L5NKYwVySdWkfAbPi2mxUYRU8I1yszF47kSedOGXqjvjbJMlt6EpJqRzXORYCN1ZSJtMwRSUI1hLquvI/Lx3UNtNanWTQzHfeactPIXRgqjnVI5BKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zly83zPGc7OES85+Y0dJVekrsrVq4s7UDJwusoSkwqw=;
 b=MTp5yB1Ikzp9Q8kWK/b4dNsgmRteyBCdxkLkb6rYUwJYOqkWM3aR++j4djw1XFu3cV7S/FIAV8HuC5k33gu8zoMHeSz6nBsIVKmfWlY7NRFtl6+uMPwhlvIV6Z1nvcFT1+Why4svbgueiWBKVKWHoTyEnozx87D8TIaH1gHMseL8oqk0/ZLKqPPNSEtu6GWaDxIHncG+tG8e9JPV5b9lnjiFCBhnU35fCJG78itfs52FHDwnlrDUIERHrSd6I7tAGTKou78S4ICqjHYc8heb9a3QJO58tXJSvwAz/+0LSYA2PJJhnf1DrMU9JDR0MgYvfgC1blRKR8K1IPq00UwIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zly83zPGc7OES85+Y0dJVekrsrVq4s7UDJwusoSkwqw=;
 b=UdprwEM5O/3f9jYf8jas2TIhHruvqtZ40vKpGr+k3cVPIeTxQIxLDpuds6HaAYqU/US+Ai86nPhBHfN2+/pkZZ8byTNxX/rnt7yiQmZ40LBJ9USv/gCOB/zc35KWqDr2Bmb9RkCe6B5+oLmaPeDsT/MAa5dx7GFvbuuldr5XsCI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2941.namprd10.prod.outlook.com (2603:10b6:805:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 14:04:24 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:04:24 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 06/10] qla2xxx: Fix kernel crash when accessing port_speed
 sysfs file
Thread-Topic: [PATCH 06/10] qla2xxx: Fix kernel crash when accessing
 port_speed sysfs file
Thread-Index: AQHXpINzD2FITddAdk6x5LUOKWytGKuaK9OA
Date:   Wed, 8 Sep 2021 14:04:24 +0000
Message-ID: <00561A63-5D11-419A-A5B6-4CEE8B524D6B@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-7-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b653fd6b-322f-4f36-b061-08d972d1908d
x-ms-traffictypediagnostic: SN6PR10MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB294119AFCC34BB7F815B47B4E6D49@SN6PR10MB2941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:403;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hLDR63LaJappN58SPkytAIBkOj+OQ0BxSnY7RnCZoiPo1cLn3JptPgSeVcV7yHKPD/gUkP3zTOP2bt/+fOmL65Hxs/nt4gAtjHpEBFm03SpjFBIr2p0Sfz/ki3Ikq/ob9iF/Wdw0GMfKLX0ShpFqQ+8OmTr7IXH2TBhDHmXpe6hjAnFbp1MPm+ThocfiRByQrxIqkUuckHhfxbQt4rSOtjepby+5ga/V+gEkRlk5TUUTbhOLXZtq8XQXCYqQI4fUKgGCxipcwbTQt2nEDKNBzyXOxZaJdfeaMQyR4ugzv4D8HQ/bp2/NzzfemvULdNmp3ZkGBQx0fnR7bgDathgHQ+vSjl1H3jVPFE5olv6mbXjZQKQfbZUgDvjbXBPOZn89TGhe0iTLdZ1VEt4dVQ+yTwMul2XCZNdF7jCzDeXtCei8zGU5Ncz0wrcbuNnwaCeMlwjRIF1EcAFB68/yj6eNWcgGrMjGJbcQwu9wWgLd4NMKCWWfHdly1w74/J8hcCK35naS0LRSTh1ffy3fEZCyw2SQpJBhPBN4kw4PsKQ24nlrqmi5VVNruhxQxJUrQNgtsAAtTnTNu/1U+t+kBkyERNdGsz/kSUCxq5hDG/1Y8SvpFFdx6PmCEeiQEc2WRTy5pR5ncFN72jBywkGGi2bad3pvc9o7ffXQEIhUenHT9bvCQ3kYF6izE5f5MsTtjPzDFf8tMa0w9d/IuyPcnLQ2rEZ7jyUBN/tmw4So5D4LiyE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(6506007)(122000001)(53546011)(478600001)(86362001)(38070700005)(44832011)(8676002)(36756003)(2616005)(33656002)(64756008)(26005)(66446008)(66946007)(8936002)(66476007)(2906002)(186003)(54906003)(4326008)(66556008)(316002)(38100700002)(71200400001)(6512007)(6916009)(5660300002)(6486002)(83380400001)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDBhbVlaZFJJZ3dJQTRXTkMvVm9MNU1SYVFlQlNMMmJoSVNFdGRoT3hiQ1Mx?=
 =?utf-8?B?QW1RckhoT241UExSb1pqMUdndWRhcVY2NlBuQlZWSnNWR1FiWTEzK0F5d0du?=
 =?utf-8?B?K2VxcVBlKzVaaWUwSG1KS0VEeXNUdURvQ2Q1Y0laL3pNV1NOSVhyMjFGcHFC?=
 =?utf-8?B?angycjBzUEVrUDcvSlRhWVZOUElrRWtVNTkxaUgyaC9lb1ZlRTE3YkRQQUNk?=
 =?utf-8?B?TEpJNmx3eHV3SVE2SWtEd0N0dVlvdGI2WkFyVThZcTJJanBiQTF1RkpIckNY?=
 =?utf-8?B?dUNYc0h4UXZVVHYwVm5SWXQyemNiZWNva3BhT3psT2ZNQ3k5cGNUekliM085?=
 =?utf-8?B?UERobVR0S1NhOHhDVitaeGF4T25nY3ljWHo2ZzFVTHFRNGwwMk9wVGROUzhi?=
 =?utf-8?B?M1duVnp5TjZiOFhnNGxtNUY0cUpSVUMxelBrNTc1aWN6Q0lQRmJiWjJ3UWlx?=
 =?utf-8?B?aCtvVEpRbGVhN0NZZWIyZzA5RzdORGdxbkRIVkhJT0Q5WXZuS2Vkd0VJeFVo?=
 =?utf-8?B?OWYrMUx1NjZsM1FjU3lJS0FvTGpkNzVJUmxWTThkUTlycmFkc09ONGFSOUh2?=
 =?utf-8?B?QWk4NlgvWjRjYVB2eGc2MTYzbzRvT2Q2WTUzanlUSVAxZXBFSEVxWWpjT1c4?=
 =?utf-8?B?MHpLL2hPMkpJUDVGVUZyVkhIZndCa3NCZm10U0FvQ3ZneE56SGo5RjR3MDVn?=
 =?utf-8?B?ck9EeHY1cnNMVUhTMFZJQW9iOHh5dHlEYk1HT0FaSHJzWTZDNU9mOWNZeE9a?=
 =?utf-8?B?MUpMNy9EWTNRaDJVRGVWUURZQWI5K3ZuaGFCZEd0NlgyVDdxUWN1RFFvUkpG?=
 =?utf-8?B?MnZ4QW5pNlRCd2VhMk0vUURGT21tdGVIWmhUN1dJVG1WWHNyZkIxWnEzMlRx?=
 =?utf-8?B?N1RZUlYyWmhtL1JPdTdpSXpwTk53UG1yaEdBeFc1dEtMOEJ5d3FTYUxUVjJ4?=
 =?utf-8?B?U1FzY0taYk1FdnR6OC9qa21RYlBodVFkc2lxQkRDSzZ5c09qRXhhWThFNlc4?=
 =?utf-8?B?ell6SjBLMWgzdDcyTmc4QU56c2pVMkh6QWlvYldYeTNoSXYxZmwyV2ZkK2xq?=
 =?utf-8?B?dzEyNndKTmsrdG41bVJpQjRxQXl6ZCtIQWwzQ0dGNUFzN2YvQXFUbGVLS1Iw?=
 =?utf-8?B?Mk9XVzE0MG1WTTBMUXdidmdlc3hwQVRMd1MyK0ExQS8wdWxpNlQzZCtvQWlY?=
 =?utf-8?B?ZlVyUDkybC9KWmZTbkpzOUsyNVJIc01YU09UZWxESU5Ccm5ZNmFVV1N1ajk1?=
 =?utf-8?B?eHR4M1VhR0xzVXo1S3VmejAya2Jza0t0NGxzV2E4WDdjclNDRU96Z2dVNCtH?=
 =?utf-8?B?Sm9wZEhnRk9ad0dveXM1Mll3SUx1Q0QrU1pEM09vRC80K0lLa3YybGc1T1Zw?=
 =?utf-8?B?NUx5c2t5eFhVdFZZQ0pyTkJSWXhiaHJjREhnOENmZGhML2xFUERDdWpDajBi?=
 =?utf-8?B?dzUvQ3FEWnFmdGJDaW5vYitSbnlGSHd0T1FRSkRpWGhoaGdOQzJ1UjVpRFZa?=
 =?utf-8?B?ZGdIUE5kMko1NzMrSHNIdGtDYXRJOERKYXpXaktjTmIxd1prdzZHY0xDUlRy?=
 =?utf-8?B?Y3JDVlluVWdVUWR5MEQ5bXNMeGM3UERMQ1ZyZkd1aUVjdGtWY0NlOTVuZ1pn?=
 =?utf-8?B?OU1VQnJSQ2IzbTdjUHlSTE1SMlh4VitCRXRlSVREd202ZkppYVRESlhuUTJW?=
 =?utf-8?B?V3MzOUZUTjZtNkU1VlF3MmFPM0xsOXlSejlCYnRqZkhDZVV2OXpCajJBMEI1?=
 =?utf-8?B?VER0RVk0OGdDTzJrVk9wSWo1MjZ4UE1MY1BwQ2NiZWsyUXJERGY1RElYeEVi?=
 =?utf-8?B?a2ttTERqVkk1cUlwWEJoUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21B6394DCC57F84793B3E79D7270B8AB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b653fd6b-322f-4f36-b061-08d972d1908d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:04:24.7212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mK4N6GbGnRglpCxc3AsSoBLTsQnBm8Ucuh7ZkIS/MoOkyX1DjINmZFe9C4B3S8BFLp3S1He8spS/fz/rGcn5lRloP06ZHLOHdq/Au7VNo4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2941
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080090
X-Proofpoint-ORIG-GUID: qwPjYuUk16spvQiAmlVOUivYgU7zJEfA
X-Proofpoint-GUID: qwPjYuUk16spvQiAmlVOUivYgU7zJEfA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gU2VwIDgsIDIwMjEsIGF0IDI6MjggQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogQXJ1biBFYXNpIDxhZWFzaUBtYXJ2ZWxs
LmNvbT4NCj4gDQo+IEtlcm5lbCBjcmFzaGVzIHdoZW4gYWNjZXNzaW5nIHBvcnRfc3BlZWQgc3lz
ZnMgZmlsZS4NCj4gVGhlIGlzc3VlIGhhcHBlbnMgb24gYSBDTkEgd2hlbiB0aGUgbG9jYWwgYXJy
YXkgd2FzDQo+IGFjY2Vzc2VkIGJleW9uZCBib3VuZHMuIEZpeCB0aGlzIGJ5IGNoYW5naW5nIHRo
ZSBsb29rdXAuDQo+IA0KPiBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1
ZXN0IGF0IDAwMDAwMDAwMDAwMDQwMDANCj4gUEdEIDAgUDREIDANCj4gT29wczogMDAwMCBbIzFd
IFNNUCBQVEkNCj4gQ1BVOiAxNSBQSUQ6IDQ1NTIxMyBDb21tOiBzb3NyZXBvcnQgS2R1bXA6IGxv
YWRlZCBOb3QgdGFpbnRlZA0KPiA0LjE4LjAtMzA1LjcuMS5lbDhfNC54ODZfNjQgIzENCj4gUklQ
OiAwMDEwOnN0cmluZ19ub2NoZWNrKzB4MTIvMHg3MA0KPiBDb2RlOiAwMCAwMCA0YyA4OSBlMiBi
ZSAyMCAwMCAwMCAwMCA0OCA4OSBlZiBlOCA4NiA5YSAwMCAwMCA0YyAwMQ0KPiBlMyBlYiA4MSA5
MCA0OSA4OSBmMiA0OCA4OSBjZSA0OCA4OSBmOCA0OCBjMSBmZSAzMCA2NiA4NSBmNiA3NCA0ZiA8
NDQ+IDBmIGI2IDBhDQo+IDQ1IDg0IGM5IDc0IDQ2IDgzIGVlIDAxIDQxIGI4IDAxIDAwIDAwIDAw
IDQ4IDhkIDdjIDM3DQo+IFJTUDogMDAxODpmZmZmYjUxNDFjMWFmY2YwIEVGTEFHUzogMDAwMTAy
ODYNCj4gUkFYOiBmZmZmOGJmNDAwOWY4MDAwIFJCWDogZmZmZjhiZjQwMDlmOTAwMCBSQ1g6IGZm
ZmYwYTAwZmZmZmZmMDQNCj4gUkRYOiAwMDAwMDAwMDAwMDA0MDAwIFJTSTogZmZmZmZmZmZmZmZm
ZmZmZiBSREk6IGZmZmY4YmY0MDA5ZjgwMDANCj4gUkJQOiAwMDAwMDAwMDAwMDA0MDAwIFIwODog
MDAwMDAwMDAwMDAwMDAwMSBSMDk6IGZmZmZiNTE0MWMxYWZiODQNCj4gUjEwOiBmZmZmOGJmNDAw
OWY5MDAwIFIxMTogZmZmZmI1MTQxYzFhZmNlNiBSMTI6IGZmZmYwYTAwZmZmZmZmMDQNCj4gUjEz
OiBmZmZmZmZmZmMwOGUyMWFhIFIxNDogMDAwMDAwMDAwMDAwMTAwMCBSMTU6IGZmZmZmZmZmYzA4
ZTIxYWENCj4gRlM6ICAwMDAwN2ZjNGViZmZmNzAwKDAwMDApIEdTOmZmZmY4YzcxN2Y3YzAwMDAo
MDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPiBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQo+IENSMjogMDAwMDAwMDAwMDAwNDAwMCBDUjM6IDAw
MDAwMGVkZmRlZTYwMDYgQ1I0OiAwMDAwMDAwMDAwMTcwNmUwDQo+IERSMDogMDAwMDAwMDAwMDAw
MDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwDQo+IERSMzog
MDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAw
NDAwDQo+IENhbGwgVHJhY2U6DQo+ICBzdHJpbmcrMHg0MC8weDUwDQo+ICB2c25wcmludGYrMHgz
M2MvMHg1MjANCj4gIHNjbnByaW50ZisweDRkLzB4OTANCj4gIHFsYTJ4MDBfcG9ydF9zcGVlZF9z
aG93KzB4YjUvMHgxMDAgW3FsYTJ4eHhdDQo+ICBkZXZfYXR0cl9zaG93KzB4MWMvMHg0MA0KPiAg
c3lzZnNfa2Zfc2VxX3Nob3crMHg5Yi8weDEwMA0KPiAgc2VxX3JlYWQrMHgxNTMvMHg0MTANCj4g
IHZmc19yZWFkKzB4OTEvMHgxNDANCj4gIGtzeXNfcmVhZCsweDRmLzB4YjANCj4gIGRvX3N5c2Nh
bGxfNjQrMHg1Yi8weDFhMA0KPiAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NjUv
MHhjYQ0KPiANCg0KTWlzc2luZyB5ZXQgYW5vdGhlciANCg0KRml4ZXM6IDQ5MTBiNTI0YWM5ZTYg
KCJzY3NpOiBxbGEyeHh4OiBBZGQgc3VwcG9ydCBmb3Igc2V0dGluZyBwb3J0IHNwZWVk4oCdKQ0K
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCg0KPiBTaWduZWQtb2ZmLWJ5OiBBcnVuIEVhc2kg
PGFlYXNpQG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2
YWxpQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIu
YyB8IDI0ICsrKysrKysrKysrKysrKysrKysrKystLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfYXR0ci5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYw0K
PiBpbmRleCBkMDk3NzZiNzdhZjIuLmNiNWYyZWNiNjUyZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfYXR0ci5jDQo+IEBAIC0xODY4LDYgKzE4NjgsMTggQEAgcWxhMngwMF9wb3J0X3NwZWVkX3N0
b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQo+
IAlyZXR1cm4gc3RybGVuKGJ1Zik7DQo+IH0NCj4gDQo+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHsN
Cj4gKwl1MTYgcmF0ZTsNCj4gKwljaGFyICpzdHI7DQo+ICt9IHBvcnRfc3BlZWRfc3RyW10gPSB7
DQo+ICsJeyBQT1JUX1NQRUVEXzRHQiwgIjQiIH0sDQo+ICsJeyBQT1JUX1NQRUVEXzhHQiwgIjgi
IH0sDQo+ICsJeyBQT1JUX1NQRUVEXzE2R0IsICIxNiIgfSwNCj4gKwl7IFBPUlRfU1BFRURfMzJH
QiwgIjMyIiB9LA0KPiArCXsgUE9SVF9TUEVFRF82NEdCLCAiNjQiIH0sDQo+ICsJeyBQT1JUX1NQ
RUVEXzEwR0IsICIxMCIgfSwNCj4gK307DQo+ICsNCj4gc3RhdGljIHNzaXplX3QNCj4gcWxhMngw
MF9wb3J0X3NwZWVkX3Nob3coc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJp
YnV0ZSAqYXR0ciwNCj4gICAgIGNoYXIgKmJ1ZikNCj4gQEAgLTE4NzUsNyArMTg4Nyw4IEBAIHFs
YTJ4MDBfcG9ydF9zcGVlZF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9h
dHRyaWJ1dGUgKmF0dHIsDQo+IAlzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhID0gc2hvc3RfcHJp
dihkZXZfdG9fc2hvc3QoZGV2KSk7DQo+IAlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhhID0gdmhhLT5o
dzsNCj4gCXNzaXplX3QgcnZhbDsNCj4gLQljaGFyICpzcGRbN10gPSB7IjAiLCAiMCIsICIwIiwg
IjQiLCAiOCIsICIxNiIsICIzMiJ9Ow0KPiArCXUxNiBpOw0KPiArCWNoYXIgKnNwZWVkID0gIlVu
a25vd24iOw0KPiANCj4gCXJ2YWwgPSBxbGEyeDAwX2dldF9kYXRhX3JhdGUodmhhKTsNCj4gCWlm
IChydmFsICE9IFFMQV9TVUNDRVNTKSB7DQo+IEBAIC0xODg0LDcgKzE4OTcsMTQgQEAgcWxhMngw
MF9wb3J0X3NwZWVkX3Nob3coc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJp
YnV0ZSAqYXR0ciwNCj4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gCX0NCj4gDQo+IC0JcmV0dXJuIHNj
bnByaW50ZihidWYsIFBBR0VfU0laRSwgIiVzXG4iLCBzcGRbaGEtPmxpbmtfZGF0YV9yYXRlXSk7
DQo+ICsJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUocG9ydF9zcGVlZF9zdHIpOyBpKyspIHsN
Cj4gKwkJaWYgKHBvcnRfc3BlZWRfc3RyW2ldLnJhdGUgIT0gaGEtPmxpbmtfZGF0YV9yYXRlKQ0K
PiArCQkJY29udGludWU7DQo+ICsJCXNwZWVkID0gcG9ydF9zcGVlZF9zdHJbaV0uc3RyOw0KPiAr
CQlicmVhazsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gc2NucHJpbnRmKGJ1ZiwgUEFHRV9TSVpF
LCAiJXNcbiIsIHNwZWVkKTsNCj4gfQ0KPiANCj4gc3RhdGljIHNzaXplX3QNCj4gLS0gDQo+IDIu
MTkuMC5yYzANCj4gDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5t
YWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGludXgg
RW5naW5lZXJpbmcNCg0K
