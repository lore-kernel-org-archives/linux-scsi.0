Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52085C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7B961073
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbhELWnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391831AbhELVc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 17:32:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CLOxZq006023;
        Wed, 12 May 2021 21:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1wX5DnjVAClYn7jFfkqjWxUvrA0cqYQtWAU1cPjjxp8=;
 b=AHzpH72CFqPTDlQX0uLTYK5BgT63UPXfyK0wu9CtELmul8gT1aUxI3U2qCsD+/h5Anod
 z3dvHaAtngmT1gAAa8RiTldrJ1ZdFGNm7+yoah3NKoGHK6IdhKlaY+Ldry+/+yckpk30
 64xPRObuRon+L8ibj/D3NVGKyWhom74bDe2kvcB732GltOMZvIydB+Vui7bZibiIuTuk
 MPovbMFjpxq/3O7XbbEVictmdGOZXQKOC+4qyDXbpbEMbEnGluCpZ/tCjPB1PWHsr/Vb
 90TdY8tlpOofwdrqQFDOj3T2Ud20+fcZl/XvVs0eh3PEpuTb4hzd6mifameLJJ94kyn/ LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38gpnxr1nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 21:31:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CLPrKH076213;
        Wed, 12 May 2021 21:31:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 38gppngh1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 21:31:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOyeBrYjDGQgKeJRs+HoAlh7UYMSaM0btI+Uf8hd/qNIfM3xshz2RfrltHwL6q1Fp/fOW33p7qdZG3SFVVN4oeObK/A/hGVvQ1iIg6VEc+uGCap53406BtIgdRF/iiyLutjEAYELrQDBXNrFAUb98FgSB4fpFoSLnYBDYE3Y5n0eEjaLpP1FKyy9hwFFbw1n2l7EdaRo2eNL6oRMIjfmU95WZzicgrEi7gMJqKRhLzkFF//Q3gQ1OKrWOBtagWM35GQ5NL1koxrojkSFu7spBv4o0e3iDajwW4IzjfPTvOd5KUZ1y8/8RPySBt6m1mxsvwQj6cNX0pF8syXadmqpcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wX5DnjVAClYn7jFfkqjWxUvrA0cqYQtWAU1cPjjxp8=;
 b=eeh3XDxOCi2XO0cu6Nmwu0jsfmvQxvRRAY+PJ7DKk/DDWAHLt+Bjc/PzPP99tn54hsXRQeBYLPLVuugcmsNOWk1X/EDRhIx+sL+0GXDcdvkMSoqMVtGia8iVNQc893g6/cMoDNj2ndlt5ipxgtp1Kkn1Yky4V+yrqf1nJ8uNXurAlhhG0eBkzCzkQrm1wY4t1EBohz7+d/e3Fjta4wAvHroScVVcMEcbk652Y00yWum3hA8HZLgES4A49y/o54ZMygAdqt0MmnylEeLDxHbg4s6OMWure6su200Y0Bt8Ou83b/0a/oZyyPi/6JaiUXgmoXZYwY1hV2lyv8EvFiVQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wX5DnjVAClYn7jFfkqjWxUvrA0cqYQtWAU1cPjjxp8=;
 b=D4vSQRg0LYmizJuRVKS4Y84FCvufxaXAeQuLccei55adtYzmXfNuS3QBk4JTWFxYvtjgMrxPZbAbQiLYD6t7j18XWzQBKSp9bCcCzk5ED54GsmzpvujLBuQO+g0tg3XHHna/UN7wt9K+/aGVRS6WOp7z1Iufyk9umrrF7F87SU4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2622.namprd10.prod.outlook.com (2603:10b6:805:4f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 21:31:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 21:31:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qedf: Added NULL pointer checks in
 qedf_update_link_speed().
Thread-Topic: [PATCH] qedf: Added NULL pointer checks in
 qedf_update_link_speed().
Thread-Index: AQHXRwASPfFioib6lk27IyzkppU9FKrgXjmA
Date:   Wed, 12 May 2021 21:31:05 +0000
Message-ID: <B932C218-C284-438D-9BE3-7FB60501E73C@oracle.com>
References: <20210512072533.23618-1-jhasan@marvell.com>
In-Reply-To: <20210512072533.23618-1-jhasan@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.6)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98dbbb84-1725-4398-714b-08d9158d4028
x-ms-traffictypediagnostic: SN6PR10MB2622:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2622AA8D3F468CCC9C8FDDF1E6529@SN6PR10MB2622.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjEHXRvxpLlf63ZtoVrZgmS22QTUZqCHBIkaRjTkZUvjrhuzxG5sF4NE+5kcKUFY5f7cGT/RlCrcI6+436qCLrEOt/rxSIDnDHcL5opqGqY3JDt6pBKrqQtmHYQA/5nAln9NGG9FWpPK43uxuYc4kNL2Pn7W09FruBtOpCgHBnmMZVpB3ajYZyRuKLXPdR29chpn96Rmn9bVRF5JGiO6+6VQxTvhIKXWzJgNh9qYiVWaPF77nfJrywTanwIXL3NVwzAe2jTVaoe0826+BVJobFUJSzMS8NjNl44SFhjD1R8QTGdC9Jmfuo3AlDdgcjzf1JVIWtgShllz3oVlGC4T4SmGxHjqz/zJ599dtQVfs/UFiNj6+GxcXRBzTtR4tMA0nptNNyPrTgbN2JQ3PdcuzYAKEr1IuZClx05MDYhFm3S0MXfwKxL1GLOiByG6iy8CsEI5Kwoi/wPxxwsAhzFKmqtaCRVkN1tlVWX/O6Usgax9F6KsI7PiWr+/c/5xuapo/hPwZjkYtz0bVh3LMigd6pv9gQsA1YigAPIpmaYfHWzW2wGmJt6ro6qp1q7b7FGc23MxNHn9sUA9DexOm/HKMkPoEfAsa1aA35wuEGev3/4dHNTz79pm81FMAG/vvTmRQA4xSI4JrF/SjCWoTXDQw+Wkq1PDoi5ocZOCngue4a4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(6506007)(54906003)(71200400001)(6916009)(66476007)(83380400001)(64756008)(5660300002)(6486002)(76116006)(36756003)(86362001)(316002)(66446008)(38100700002)(2616005)(44832011)(478600001)(122000001)(6512007)(33656002)(8676002)(2906002)(186003)(26005)(4326008)(66946007)(53546011)(8936002)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YmVWVmZPRGt1VlMxMlByNkFYeFdTVjRaNjREZXlVd055cXBhUU9jemFBS2V5?=
 =?utf-8?B?L0dNbmRqR1hmOWNZT3RJTHZvQ0hQdVlMSlpMR0c1UVZjYjZibW9uZm0ydjRJ?=
 =?utf-8?B?SEZnYlZ5Y1YzL0ljZ2NTK212YitJSURJQzBBNFhzeS9RZGJjUlMvQWtGVHZF?=
 =?utf-8?B?L0x2VUxrZkdiMDBxc3l3L1NJQStKTlNKWlY0dTZOdi9zdWdyOFFFUzVnWk45?=
 =?utf-8?B?dDNHNHZpTmptT05nWldpV0xWOHgvU3BjVGlMcmFNdE9LRzM5ZVNqSElkajBy?=
 =?utf-8?B?L2g1ckhwSkVmYkpYcEdtQjlDSDB3clVOWUF2bVNNdVNEUk9Wa2U1ZlVReE1Q?=
 =?utf-8?B?d1NHTDBabFVsTUQ3cStBQytpSnZhbVVRV29Id0o2UHNDamlCdDZlY3hoQUor?=
 =?utf-8?B?VGRJUTlKUVNRb2FMZVR2c296ZUQvOThyQlRMVUZ6emhybWxEN2FDMVJkSGtR?=
 =?utf-8?B?QUsvSnJYUXZkVFJKUTNXb0FlZDNBUS9UMHBIQ2pyaVNIV0FadExkRG9iR1pC?=
 =?utf-8?B?WjZkaE40VVYySXo4d1E1U1o4bHhFSVJLU0g2Mjd1eHJJYUVtQzVrR2hmWndD?=
 =?utf-8?B?ZDUrTzNYQVFxc2tpS1BxYlpGeE9OWEtWdU52djVrRE1KSkZVZ3NwTERuMFY1?=
 =?utf-8?B?eE1kNmdyVFNyWThpcmFxZ0tCcmZsOUlMeVk1dHNOY3crRDl0V29tdGNKdjZP?=
 =?utf-8?B?eEhlZFc4TXQzTTQ4b01NTzVYbTVtQkxJeFlSYlo4bGFuM3JiSSt2UFR1Vkw5?=
 =?utf-8?B?dHc5d3dXcnlhdGNQZ1lFMWVBVjhQVHR2SHkzYUNYSzlqUE9KaG5TaUVOcHli?=
 =?utf-8?B?TWRmM3hJY3Y5NzZtWEVjNFZXb29sY3NiTzMvUE52MTJZVHl2eGFTOXdILzFz?=
 =?utf-8?B?aWpxZ1ZXYThGMWNUZlBkNS9NQ0VEUVRMMHJ2Vy9DVGFQTDFzWWQ0SnRXaEV6?=
 =?utf-8?B?MWhzMlVCeVVmWXdLV2tsbklza2ttbTA2NmNRWTFaK3BxTEJXN05zVDJnQk9n?=
 =?utf-8?B?RjZUOHhEQ1BhdGE4TkFlUnZybndvVWxlTTNyakZMbG5hODBNZ0N3ZXhQdGZo?=
 =?utf-8?B?d1lRcnNlaUtJMTBMdER0QUtrWHVwc2hLMFJYYjVWNUdPcXV1aHhhcE0rWXZM?=
 =?utf-8?B?M2I1Q2wrdldDa3k2M0JVOGdCb0dvQnhwVkFncG1Lb2FsRVlWblRqSkpteHp6?=
 =?utf-8?B?SDdqQi9QcmtDYkRQcVpYcElsOVFpN0lHakFtZWdKR21EUG9DbnNTSVAxZnpl?=
 =?utf-8?B?K2lIM3JKeXVYemZmbkM5SHdUQ1BwbzE5dHo2QkR6ZC9hTjQrcVFKVTVUYXds?=
 =?utf-8?B?R3o4V0RpODJvTmhyNXUxRk1rTStaZ3U5UDFrNzZTZ1FSN0xUdlNub2FPSDRo?=
 =?utf-8?B?SWFXUURwQW4rYWZvRjRTWjdNd2dXbmlqRi83clYrVjRBNWJqV0tGTFlRNTRI?=
 =?utf-8?B?RGN2b0lwakQvdWE1eVpmOFNpWHFZQ0x2K1JsbVRPRDFteU5na3YzMEIzR1pG?=
 =?utf-8?B?M1BCS05yTldGZi9VVTV4MCsrNGpqQVFZdkd6YjRsN21Lc2RNNWZRWDkxRVFR?=
 =?utf-8?B?Q2hwMGNZZU11OXJUbzNSN1JlQzRuRTkvSTZmdDA2MWo5MWE0RHJ5TnBYWDFa?=
 =?utf-8?B?Wms1ay9SQ3V3N1Q5RkRIUUJkbWNvOUJObmRyNUt6L1lBellMRFMvdTVkU1RQ?=
 =?utf-8?B?SGNZcXFoWUdOSlZjSS84U3dPbkZQS25NbElaYzNPcHAzYXk0NGhnZ1Z4cFFi?=
 =?utf-8?B?cVd6S0VxZysvVE4zMWQ3ak5xd1VwdGVZSmpaNHFhYU5iZnF0R3ZKdFJscC9j?=
 =?utf-8?B?NFhZa1RUU2JsOHREUUY4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7D535387145C44097DEC15C6CAC0399@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98dbbb84-1725-4398-714b-08d9158d4028
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 21:31:05.9120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eqfa2sxwIT8zexsHpzGTmXfZ1p8w3d+p4XZoFCF6d78FBVydlQVi1aPXO2xAx5++RXUSuqFM1akJoEzY3LJwXOiM++JbBRo+M5ERJh/Wykk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2622
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120139
X-Proofpoint-GUID: 87YqXk_oeUYQcFpylb0hvUIMz7_VAvNs
X-Proofpoint-ORIG-GUID: 87YqXk_oeUYQcFpylb0hvUIMz7_VAvNs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gTWF5IDEyLCAyMDIxLCBhdCAyOjI1IEFNLCBKYXZlZCBIYXNhbiA8amhhc2FuQG1h
cnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IElzc3VlIDotIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDAwM2MNCj4gT24g
aW5zdGFsbGF0aW9uIG9mIFJIRUwtOC4zLjAtMjAyMDA4MjAubi4wIGRpc3RybyBiZWxvdyBzdGFj
aw0KPiB3YXMgZ2VuZXJhdGluZyBvbiBlcnJvci4NCj4gDQo+IFsgICAxNC4wNDIwNTldIENhbGwg
VHJhY2U6DQo+IFsgICAxNC4wNDIwNjFdICA8SVJRPg0KPiBbICAgMTQuMDQyMDY4XSAgcWVkZl9s
aW5rX3VwZGF0ZSsweDE0NC8weDFmMCBbcWVkZl0NCj4gWyAgIDE0LjA0MjExN10gIHFlZF9saW5r
X3VwZGF0ZSsweDVjLzB4ODAgW3FlZF0NCj4gWyAgIDE0LjA0MjEzNV0gIHFlZF9tY3BfaGFuZGxl
X2xpbmtfY2hhbmdlKzB4MmQyLzB4NDEwIFtxZWRdDQo+IFsgICAxNC4wNDIxNTVdICA/IHFlZF9z
ZXRfcHR0KzB4NzAvMHg4MCBbcWVkXQ0KPiBbICAgMTQuMDQyMTcwXSAgPyBxZWRfc2V0X3B0dCsw
eDcwLzB4ODAgW3FlZF0NCj4gWyAgIDE0LjA0MjE4Nl0gID8gcWVkX3JkKzB4MTMvMHg0MCBbcWVk
XQ0KPiBbICAgMTQuMDQyMjA1XSAgcWVkX21jcF9oYW5kbGVfZXZlbnRzKzB4NDM3LzB4NjkwIFtx
ZWRdDQo+IFsgICAxNC4wNDIyMjFdICA/IHFlZF9zZXRfcHR0KzB4NzAvMHg4MCBbcWVkXQ0KPiBb
ICAgMTQuMDQyMjM5XSAgcWVkX2ludF9zcF9kcGMrMHgzYTYvMHgzZTAgW3FlZF0NCj4gWyAgIDE0
LjA0MjI0NV0gIHRhc2tsZXRfYWN0aW9uX2NvbW1vbi5pc3JhLjE0KzB4NWEvMHgxMDANCj4gWyAg
IDE0LjA0MjI1MF0gIF9fZG9fc29mdGlycSsweGU0LzB4MmY4DQo+IFsgICAxNC4wNDIyNTNdICBp
cnFfZXhpdCsweGY3LzB4MTAwDQo+IFsgICAxNC4wNDIyNTVdICBkb19JUlErMHg3Zi8weGQwDQo+
IFsgICAxNC4wNDIyNTddICBjb21tb25faW50ZXJydXB0KzB4Zi8weGYNCj4gWyAgIDE0LjA0MjI1
OV0gIDwvSVJRPg0KPiANCj4gUm9vdCBjYXVzZSA6LSBBUEkgcWVkZl9saW5rX3VwZGF0ZSgpIGlz
IGdldHRpbmcgY2FsbGVkIGZyb20gUUVELg0KPiAgYnV0IGJ5IHRoYXQgdGltZSBzaG9zdF9kYXRh
IGlzIG5vdCBpbml0aWFsaXNlZC4gVGhhdCBpcyBsZWFkaW5nIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZQ0KPiAgd2hlbiB3ZSB0cnkgdG8gZGVyZWZmZXJlbmNlIHNob3N0X2RhdGEgd2hpbGUgdXBk
YXRpbmcgc3VwcG9ydGVkX3NwZWVkcy4NCj4gDQo+ICBmY19ob3N0X3N1cHBvcnRlZF9zcGVlZHMo
bHBvcnQtPmhvc3QpID0gbHBvcnQtPmxpbmtfc3VwcG9ydGVkX3NwZWVkczsNCj4gDQo+IEV4cGFu
c2lvbiBvZiBmY19ob3N0X3N1cHBvcnRlZF9zcGVlZHMuDQo+ICNkZWZpbmUgZmNfaG9zdF9zdXBw
b3J0ZWRfc3BlZWRzKHgpCVwNCj4gICgoKHN0cnVjdCBmY19ob3N0X2F0dHJzICopKHgpLT5zaG9z
dF9kYXRhKS0+c3VwcG9ydGVkX3NwZWVkcykNCj4gDQo+IEZpeCA6LSBBZGRlZCBOVUxMIHBvaW50
ZXIgY2hlY2sgZm9yIHNob3N0X2RhdGEuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYXZlZCBIYXNh
biA8amhhc2FuQG1hcnZlbGwuY29tPg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9x
ZWRmL3FlZGZfbWFpbi5jIGIvZHJpdmVycy9zY3NpL3FlZGYvcWVkZl9tYWluLmMNCj4gaW5kZXgg
NjlmNzc4NDIzM2Y5Li43NTYyMzExNTE4ODIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9x
ZWRmL3FlZGZfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xZWRmL3FlZGZfbWFpbi5jDQo+
IEBAIC01MzYsNyArNTM2LDkgQEAgc3RhdGljIHZvaWQgcWVkZl91cGRhdGVfbGlua19zcGVlZChz
dHJ1Y3QgcWVkZl9jdHggKnFlZGYsDQo+IAlpZiAobGlua21vZGVfaW50ZXJzZWN0cyhsaW5rLT5z
dXBwb3J0ZWRfY2Fwcywgc3VwX2NhcHMpKQ0KPiAJCWxwb3J0LT5saW5rX3N1cHBvcnRlZF9zcGVl
ZHMgfD0gRkNfUE9SVFNQRUVEXzIwR0JJVDsNCj4gDQo+IC0JZmNfaG9zdF9zdXBwb3J0ZWRfc3Bl
ZWRzKGxwb3J0LT5ob3N0KSA9IGxwb3J0LT5saW5rX3N1cHBvcnRlZF9zcGVlZHM7DQo+ICsJaWYg
KGxwb3J0LT5ob3N0ICYmIGxwb3J0LT5ob3N0LT5zaG9zdF9kYXRhKQ0KPiArCQlmY19ob3N0X3N1
cHBvcnRlZF9zcGVlZHMobHBvcnQtPmhvc3QpID0NCj4gKwkJCWxwb3J0LT5saW5rX3N1cHBvcnRl
ZF9zcGVlZHM7DQo+IH0NCj4gDQo+IHN0YXRpYyB2b2lkIHFlZGZfYndfdXBkYXRlKHZvaWQgKmRl
dikNCj4gLS0gDQo+IDIuMTguMg0KPiANCg0KVGhpcyBzaG91bGQgYmUgc2VudCB0byBzdGFibGUg
d2l0aCANCg0KRml4ZXM6IDYxZDg2NThiNGE0MzUgKCJzY3NpOiBxZWRmOiBBZGQgUUxvZ2ljIEZh
c3RMaW5RIG9mZmxvYWQgRkNvRSBkcml2ZXIgZnJhbWV3b3JrLuKAnSkNCkNjOiA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4NCg0KV2l0aCBhYm92ZSBhZGRlZCwgTG9va3MgR29vZC4gDQoNClJldmll
d2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoN
Ci0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCg0K
