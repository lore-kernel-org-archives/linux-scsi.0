Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944D5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jan 2022 12:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbiANMZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jan 2022 07:25:35 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:50222 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241006AbiANMZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jan 2022 07:25:34 -0500
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20EB225C030603;
        Fri, 14 Jan 2022 12:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pps0720;
 bh=5Ok6r7sWEPHUSgc0E2ZQY3UE23UHLMe4GOzvathj0J4=;
 b=Uo1adbEMWk1TIR7/sNW+yQl5aTbSh7exAsriq5n0H7eDY0nKliaNxoQ8H5Q2e8Jf2irB
 sFfJvI4i84jQKKhgMFdJ9q2xKza/IBzuCJw7ECFbNBe/6zLPdUETLvYB2wSI659xTExh
 HDvPmeASrcIWE5Ev8QHX58QmJtIQkzqA0e00rs2LcO3Ns5xPqULkh8r2M4aaHLpj6DFQ
 TU9cC/qF7cKG78t500JVoHl+6wyIksj9okTqPm5PJmmrNQQhZ3hU7GEt64bAcfQQqu0P
 iMApfd3LWafOE60aqTrcknIYg5xLE3tEy5BQ/BfNRDmNkPrwjYZhBCM1Hg1VlIqKWJBB mA== 
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3dk25uaw7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:25:20 +0000
Received: from G9W8454.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.216.161.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id B7B6959;
        Fri, 14 Jan 2022 12:25:19 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
 G9W8454.americas.hpqcorp.net (2002:10d8:a104::10d8:a104) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 14 Jan 2022 12:25:19 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.241.52.13) by
 G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Fri, 14 Jan 2022 12:25:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgELr2JHr3r/lwC4EdhD3+3hlwMHgtpL9Ya+xh8cxb+sbJsGuQEHSdCpoM+IAPckhP/9ssSIelQkJ0+VLGnFzAlTKbjufsfjpjdMcRi5egizM3xJYYX2pPJ3oafdssBsf4KTOPEvox7C0uJBJlqUnoDZg2/oCh3Urz1ZSFM2jxD75c2RImgvoo/pq1lfusicU2NN5COzAC51NL2qxcTymnMQFzYOPK6RaoYuTN5pq5ilE3kZXxXVVXlL/MO3UsKZLgJ7H2Yl/TDkk4c6KZWsJetHSJYJV7Ntv4pY/bpBu7YB6qzdacZbKyTMhcilFliyTU071bjyq2xWoWUUISeBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ok6r7sWEPHUSgc0E2ZQY3UE23UHLMe4GOzvathj0J4=;
 b=XsCegXRde2ZlqIXFw9qRKnw7GUtn8O4V/30pUYMK53VqGI1vqQsNkD+sR+JEiykihcl/qRYwsPi2+xgQSGyOPlWe2WGAL6QucLqB5FK079eIWkr79oZpYNJhoi2x7wiIeTSvDIzqztyJ6vWy0n2iJFFaQKxUhBCjLjDsYgy2XOsBdinGYqdCESurgoekR/DM+iorPVZuVtt1dPGcVwCmihVRKWK36dtfEhIreJdulck1/KAvkOAGNDTHdvIFu2JdDDC3ePbMe+ppfBYYGpekxLnsGal1zibliUEH83gJlkSc2PLF3zAmgkv5yz1ZFrZOkPbX6oOgILCb93sOffdmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by DM4PR84MB1687.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Fri, 14 Jan
 2022 12:25:18 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%5]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 12:25:18 +0000
From:   "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHX9ae9F1LvItF/X0quij8FY4R836w7kj8egAY1AgCACJX2AIAWxvkAgABgx9yAAUWXgA==
Date:   Fri, 14 Jan 2022 12:25:17 +0000
Message-ID: <1B10E639-BD16-4B3B-B6BA-9F5F8DE73982@hpe.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
 <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
 <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
 <b16b20d3-fd5e-ce5c-f744-be5022b4156f@opensource.wdc.com>
 <71B870D7-16B9-4299-ACB0-F4B6D5188C70@hpe.com>
 <yq1k0f3pg4y.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1k0f3pg4y.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e40e6edb-d393-4465-d59b-08d9d758ece6
x-ms-traffictypediagnostic: DM4PR84MB1687:EE_
x-microsoft-antispam-prvs: <DM4PR84MB1687953D8DCE842EA80F8BBEF7549@DM4PR84MB1687.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/lNyIpgqJW9YdRRjV9cXxAqMokeIn15p0OgGRfK2ARjS5voKIqTpejxbzlSPFLHA9Tat7gFj5HcSF0QZPzltqInKEkk6oaduhOb9BPOXypxFjZZdsMcoL7zNMrn4xhlcQBbrJiDVpnZ7ZYnsJE7YKsJ+tpQNil9Kv8gLJinqcrbh2tS6onc5ht/jFU6F5LY7+Qvv4T4kKZPIME5t8u0I8PZxzev9TGmodHsUHot6x/zV1obekvgawCrQBgP+c+DofpRi6fdcyQkfG29kwAGT+smOAHYO8WH6S114JjoO7xamINU4FZUtI+9ZiiF9eVms3nv35CrENw7eb5j/4DWhA7OwLHf/WZCZqDtjijH4zU9xuaoKpLDerMHSoAaX5sRrJxV3YBgu7EJ0LTuk5ErKAXQURgSP4AapbAqQRJyTKH/I6YvCRsNtunN55sHdCX+8F1MfNSKs+FOGo+HxdYmkLd4aB1cHUyZLSu+6HVyktwuetoSVatW7t9hK89ZAU6qxVjIkhm+mQNIEcwblM4ZS263DzQ3KjM6Z4gYimx8+tg+DemUKlupy52EEfj/2COy8Qc4wvWy6mmgTx56uRasaRv47DtBUx5uKfs98m41DYzquJfQnipLbL3owmcW5XWU0izU0DMk58SnGbnYxHwmovS+v3DG1K2kI6SnLs1VIIeYN9sNVHibkJuzxsX2446Kd42/HWtsYXe3um1DKYklgfaMOUXE2qhaxCYtrVRm8s8LHwavQVZ9UlhbYbR1JhRd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(26005)(71200400001)(82960400001)(8676002)(2906002)(6512007)(186003)(122000001)(83380400001)(8936002)(6506007)(33656002)(38100700002)(66946007)(5660300002)(54906003)(6486002)(316002)(2616005)(86362001)(66556008)(66446008)(64756008)(38070700005)(91956017)(76116006)(4326008)(66476007)(6916009)(4744005)(36756003)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjdyRXRETHJMZUV1ZlcvUitiMnpuR3dxZEJ6amN4R3dINnNXakU0T2FaRkw5?=
 =?utf-8?B?SDJRNjAzL1Z5cnh6OFBKOC9KbXF1UllwZkg5d0kzMFd6UGNZeHBhQms5ZlhD?=
 =?utf-8?B?RlhUMHc0SE9zWTBPTlVxNEJDa2p3SXUrbHkvM2tpazZQcG0vT0dydFBBSkV0?=
 =?utf-8?B?OHpGQUJwNG5WeFR3RTZWSWtkM3l6SnRES1RiUk9vaFQyVys0V01xWjNhTDNW?=
 =?utf-8?B?Szc5bFBHaS9SeVhRb29RT3RjNFdSWk5mb2NLSWFpVGUvTGVvZTAyemhKYXdw?=
 =?utf-8?B?TUJuWnJGUWVVNS9ndnU5WFRmM1gxbUNYazdkYWl2c0MrNU14QXN3SnBJa2ZJ?=
 =?utf-8?B?R0hSbDVNcUZVaDdzQXRnTTlCZjJhV3FIYzdRNnZPTi9mZmd0QTRRL3FDMGJQ?=
 =?utf-8?B?aXpsTnN0RlZ2WXB3WWFjc1d6emJkMzBnd0lBY0psaXU4OGhtZlJ1b0l3eGg3?=
 =?utf-8?B?SG5iOHBCdyt0bjZaeUh4RStqMFUyMzhuY3F3TjhHSjQ3UHFBeEozSDZnbHcy?=
 =?utf-8?B?RGJlRGdpTkh4Vk1mMUdGVGNvdGsrT1oySkM0bW5uSkI2MkVhTmNhbFAydXZH?=
 =?utf-8?B?YVFiT3VxVmUyTE83cU9jSW5aOGpCTlJMK1p3WkYwOVRFb2pQQTZ5dk55eWtx?=
 =?utf-8?B?dWNHWGtNbkZNbHFZclVOYUMxVFJEUWtlY0FUT3YzcHpQdDRZRmxrd1Q1VGJl?=
 =?utf-8?B?UGs2MHpXL2dnRXdXcDQvQWI5eEw0SjZPYmIraFJYWFk5WmQvc3dyVkJ6ZWxE?=
 =?utf-8?B?YXhCTHNwL0htdVp6OFZPUkwySitUdHVLcUI0T2xnOVplT0FnMDF6Q1VvNE5Z?=
 =?utf-8?B?bEg4SVB1V1RNZ0lTQklQWm1oZVNDblh5WnU5cC9Qc1NyRS9UZTV4VmtRL2Vh?=
 =?utf-8?B?K0Q2R2N6MURZVTBtUWdXeHgzZnMyNEUrY0hBV1owUjdJaUV5YWVVb2VKR2FP?=
 =?utf-8?B?RDJmb1pVYlhvUll4TnRMNHJKdEZQN2Y3Y0xGK0tzSkR2V1JwbENReTBQdS84?=
 =?utf-8?B?UzA3VHRXYU51bzBNb2NHcVo1ajUvQ2duNjRqbWhVZDQ5SXpUVEI1NFkreEg5?=
 =?utf-8?B?VWtVYVl6b1VxOG5ZVWRmNFFEVjh4TUZBUUQzVW5xRUxOMmVtYkhjT2lyd2hy?=
 =?utf-8?B?cTVyaUlHMXp1bmRnWURnNFU0Q2c5N0hFMGZrSFo2YkgrMzZRcFVTcHlHeGk0?=
 =?utf-8?B?ODExY0gweUZiZGtsYUVoNllXSC8zQ0EzUmtZbEhGV01ueWlMaGJEVHlWSEx1?=
 =?utf-8?B?N1dmVzRiK0lUS1ZOd1FKd2pDdnV1dmNZWnllUnFWQWNtS0tSMW1rNWtrWDd6?=
 =?utf-8?B?WGdFVngrTkRqRGJTQXMyN2JsVGRiM0VjTkRUNTkydjlkL2tLOTVveVRVUWhD?=
 =?utf-8?B?UzhINGNKWWVTSnFUYThSV3BsU3NxV0gzTGwvTURRUitkUVRiVkdnSkVkWDQ0?=
 =?utf-8?B?UkV2SC93UGZ3ZVZJdUgwMVJXb1htelRrN3pRd2UwY0VsWWFzaVZJczlDYUox?=
 =?utf-8?B?QTFuWEhjWGxPenp6OUFNYklPcDNuVjM3Q3VpUHF5cXRVOVY4M1l1bEZRVEph?=
 =?utf-8?B?Nk9Cclp2YlZ0SkF0V2NMdkZyNFA4Wkx5eGF4bVVKVysxZG13V2UwTEE3emJx?=
 =?utf-8?B?Rno3L2xiOUdFQjVWdXVxOU1Kb1p3NWFmVUE3djNuc0FMOHB3YlN6UEtvOXZJ?=
 =?utf-8?B?bytwVk96b09SU3ZZRk9DSjZiNndteWw5dzhPRHcxSzM1U1MrcE02SDA5cEVR?=
 =?utf-8?B?RHlHWDI2NEhjMEpHbGdlNFFTRm04dVJwd3VWTUNWUUNEZ1dsOVpFdloxMWMr?=
 =?utf-8?B?TlZ2T0ZNb2gvczRPVWJaL2JRVHAxOFloRzBLM2lyMm5wTUxTSlMvTzI2ZUc5?=
 =?utf-8?B?QVpWWFAwbjgwSnJjY2xWQTNFMU9Ka20vSkg1MVY0YTI3cHQzNnA2MDhjY0dJ?=
 =?utf-8?B?YW1QVFV0RkhlUjhVT01jT0lpMTRrUHdtamVjZWxzQXBNajJIcUxYRWJhOTdT?=
 =?utf-8?B?N3Rma29NYldGdlBjb1BSS2R4WExWSHR4RW1vZGh1QVVJU093NmJVNEVhT3ho?=
 =?utf-8?B?N00xSlZSbnRDVUhld1cxMHIxUEtrbWRhNGdhdlNlQVB6S0hLV0NUWnY3M3JK?=
 =?utf-8?B?cGszblIxdElNcTBaQWFCWk5HRXF2UnRjSGtMVlErc2JSZDdQTEJ1L1BwdENk?=
 =?utf-8?Q?26HcqvYFd2NbyEjrXMxO67Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95C6740F75218E4FB28CF3A1302F6883@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e40e6edb-d393-4465-d59b-08d9d758ece6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 12:25:17.9562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVsGysCZkSf3hZdJIFUtzbYmDI+daPQ6sXUAJwVgQ1jh4L1wg3kJteHPmuCIiJtyyg9HB2b0UhbPLUBKifmhVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1687
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 2aCC_xika5GPj-pQ05iGp297fPPUkkEQ
X-Proofpoint-ORIG-GUID: 2aCC_xika5GPj-pQ05iGp297fPPUkkEQ
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFydGluLA0KDQpJIHdpbGwgdGVzdCBzaG9ydGx5LiBCdXQgaXQgbWVhbiBiaV9zZWN0b3Igd2ls
bCBiZSBpbiB0aGUgaW50ZWdyaXR5IGludGVydmFsIHVuaXRzIHdoaWxlIA0KYW55IHNlY3RvcnMg
ZXhwZWN0ZWQgdG8gYmUgaW4gdGhlIFNFQ1RPUl9TSVpFIHVuaXRzIGFuZCBpdCBjb25mdXNlIHdo
aWxlIGRlYnVnLg0KDQpBbGV4DQoNCu+7v09uIDEzLzAxLzIwMjIsIDIyOjU5LCAiTWFydGluIEsu
IFBldGVyc2VuIiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+IHdyb3RlOg0KDQoNCiAgICBB
bGV4ZXksDQoNCiAgICA+IFBpbmcgZm9yIHJldmlldy4NCg0KICAgIENhbiB5b3UgcGxlYXNlIHRy
eSB0aGUgZm9sbG93aW5nIHBhdGNoPw0KDQogICAgLS0gDQogICAgTWFydGluIEsuIFBldGVyc2Vu
CU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0KDQogICAgZGlmZiAtLWdpdCBhL2Jsb2NrL2Jpby1p
bnRlZ3JpdHkuYyBiL2Jsb2NrL2Jpby1pbnRlZ3JpdHkuYw0KICAgIGluZGV4IGMwZWI5MDEzMTVm
OS4uZmE1YmM1YjEzYzZhIDEwMDY0NA0KICAgIC0tLSBhL2Jsb2NrL2Jpby1pbnRlZ3JpdHkuYw0K
ICAgICsrKyBiL2Jsb2NrL2Jpby1pbnRlZ3JpdHkuYw0KICAgIEBAIC0zODcsNyArMzg3LDcgQEAg
dm9pZCBiaW9faW50ZWdyaXR5X2FkdmFuY2Uoc3RydWN0IGJpbyAqYmlvLCB1bnNpZ25lZCBpbnQg
Ynl0ZXNfZG9uZSkNCiAgICAgCXN0cnVjdCBibGtfaW50ZWdyaXR5ICpiaSA9IGJsa19nZXRfaW50
ZWdyaXR5KGJpby0+YmlfZGlzayk7DQogICAgIAl1bnNpZ25lZCBieXRlcyA9IGJpb19pbnRlZ3Jp
dHlfYnl0ZXMoYmksIGJ5dGVzX2RvbmUgPj4gOSk7DQoNCiAgICAtCWJpcC0+YmlwX2l0ZXIuYmlf
c2VjdG9yICs9IGJ5dGVzX2RvbmUgPj4gOTsNCiAgICArCWJpcC0+YmlwX2l0ZXIuYmlfc2VjdG9y
ICs9IGJpb19pbnRlZ3JpdHlfaW50ZXJ2YWxzKGJpLCBieXRlc19kb25lID4+IDkpOw0KICAgICAJ
YnZlY19pdGVyX2FkdmFuY2UoYmlwLT5iaXBfdmVjLCAmYmlwLT5iaXBfaXRlciwgYnl0ZXMpOw0K
ICAgICB9DQoNCg0K
