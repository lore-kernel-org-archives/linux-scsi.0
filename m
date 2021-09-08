Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF91C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4B9A60C3E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351775AbhIHOCf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:02:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351774AbhIHOCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:02:32 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DgDun010790;
        Wed, 8 Sep 2021 14:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MOMOtbUQBwQHCkK9eSK0RFWw6IArpCuuZq+gShdhmJE=;
 b=md8n/z+2VJoF2LAiR0hA/LNuqcorhDSyZid7k/0aZGcCOKUlKVSvfMqgzZBRifbVrARd
 sHXRmR2tL7f24tbd4WArjiBr0kWCflIi6u7VgJsYHfDgX2ahKDZvBSXMbPXquOzxltyi
 P3G/gAcuspuQAUweJUw04nDn0Yg3aTznwBksgMfAu9kMq5bx+wc3AZHmsrPX8d7dXjIA
 ExxFBZN0lS/gDrjxuE3sslas2Z3WwwJu61GHx5twbFVrBJWLR1IM6+j4BQKlvx5zlREt
 2N2eWaVbUACT7wx7n2bKLK0Lx3Zc530nFGXbtMxWb/MCNgpDonUFZRzyd2FaheXBhQx7 cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MOMOtbUQBwQHCkK9eSK0RFWw6IArpCuuZq+gShdhmJE=;
 b=kjADksKwsToyIivLqxSwAxAFbAc0J45kysO+kE6D/TS9lWYL0xkw02RLHD6G7Tjos03V
 sfJ+9t6nhN30pcuPhYFJMDUrbdjgnlFu1xJSraTOkVkyUIvlUWUKmqgJ4nd72I2Pkw53
 olIHdVA2U+dXMFJnKjAiL0seMgd1XjkQsAu6Of9VYtYd2ALStS50B8BS+re0W8DxayaO
 7sN5vFWDAYcA9DOl+AyuNz7vxDRaBkeD3Yvylg/8FwQSqrm6wfS881Bl/OsvSltVqayB
 MCeggGZQ4kjm874iZ+2IS/8Bb14WjcCgSSi6S8VDu1Ovc2811RUjBhfCdlR0EbxoW40K lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcw6atk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:01:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188E0rfU030150;
        Wed, 8 Sep 2021 14:01:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3030.oracle.com with ESMTP id 3axcq1eand-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:01:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQREXw+MBbBcUWXrfAgz67T92g1pqGOwChjxcoCGuMJTH1c09JgcWxB9DGfS7UQroORLIm1ZU0wef6cjbAYSZiDUT61pg4Blm8FYfgNGE4gErj9h4Je9HTFKaykjB4ZREUYZmgGgI3wQSsc/KBsaQ8hZCigs5Ezvcuba7dySahhsfcE4HQR/x+jBFrUvuF2go5k1RU9BpxUKpFtzqy7Uf0UwaQm0I7j9JsSpMpM8NjEBzD7/y9uLXuJKOsQkWIW0JQt9NE42RzqW8krcWh/Jkbpcu3E58RDNzAjbhzHnGG1ogOFKUTiv8MNUkImo61+Tsr/OezWqWVNAE5ZDEu16RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MOMOtbUQBwQHCkK9eSK0RFWw6IArpCuuZq+gShdhmJE=;
 b=ekgJjHQCc4LzG7qOEsc8Fx5ANzSF2fToARY/LixIVbMQnKQR/EROgcdwdTWeF77q5df7x8EU1Nx5UoUrOyjxxGIStNLEpkIDA+x71oLDO9yf39quJ9kUZwrcvHBhOnJULmked70obAPdYvtfZVOfvvyCTMuptDbbUisMrKDUavyrkQKToUNe/kcTilEpXKxiix0Xbi9zWQFfHSWmF1mihb57d4hhkyo+82Duusm40ya2Nya4XGEeGEMeuhxNmUnMBJVTt4EeJ1vum0BcGVSuWjojv1hh3/edr49D8uqNaHeibJtaoeyHwC+sr64mOG72MP+/RhO+iqGs1V62TXjRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOMOtbUQBwQHCkK9eSK0RFWw6IArpCuuZq+gShdhmJE=;
 b=QO5a5v2VZIzyZNObto+7QJjVM3eGSuulRr0FdqHjuSPTNzi0F3kj4B1athm6Po2IfHzFreNcLKVPGdbg8oJ8g3qtuy+fT0YcoT1PAsMDClkOUeWCLNJGzZ8OP153Ine4EC33Yh70Fdb9XnJfF9RvcI7IMW5qrLDiFAQ7XaZ+XfY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2830.namprd10.prod.outlook.com (2603:10b6:805:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.26; Wed, 8 Sep
 2021 14:00:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:00:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 05/10] qla2xxx: edif: Use link event to wake up app
Thread-Topic: [PATCH 05/10] qla2xxx: edif: Use link event to wake up app
Thread-Index: AQHXpINwmXMMrnWb7ESWqQon9eUhjauaKt2A
Date:   Wed, 8 Sep 2021 14:00:58 +0000
Message-ID: <BA9BB96B-F0B1-4FD5-8DE4-6FA3E82C459B@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-6-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 573519b2-5591-4069-15ea-08d972d11573
x-ms-traffictypediagnostic: SN6PR10MB2830:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2830059113DBB6271120D679E6D49@SN6PR10MB2830.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yo9SG7K2MgccQ0T26k4dWXODRIihhWxLYwfLRdHA8Qeha+MVD48GkDJit/hX0j7txwcOWx3pgGh6g6oEOLbSN7KEXXsdhC2N8y1yoIwmtXeyD5VH23jjDU/4LLlK5G54KHXNetQ1/zaVhLuX4qsejZEgXSowM6BSyP3H84NaSPYTHK6/gMSWDXgrmqyvk6fFzzO5yIAuetZ8N+hiosfNqkPpLU11jdbtAgCXUQwb3s5rLGM5+6A0Uwf6PpOp3R2j4JZ7iIiZX4hfrl2sWv71v1z7JqwhyGqtwPtMYxnp0ycVNU6U+MynHk8hnhraOBaHAZ8WNfznxZoNGTK7hcll+tcFRLEjoOww5f5wTdMXqUJn78SnojOTsWfZ4wY1szgSsmtqeC4xEZ/HBrxaJM/Tjzh0GOhgd6ZtjCz4MfkN28dBnXJ20uu/maFIcXonCSnWbXAsxIHnL3c+4lZ8ibnaAnBiljQ71PMg4Q4EvEkv1iS56Na81m7Zavb/48NuzAeRg4ULpWSWAYlTfUasqVWSSWaJbhsOUlqzB+UU8YobJqRDMECMPlXeV3Os7LJ+y5RhWoA5YaOFtj1wLxGivxDdeKiXSeELBBlwHeUyyPlEgli/uCy/IGn3vIJg0/sJNle+PbMppfylDEL33ZnpEXtl85ilNvBREkMzjhhIC74r6JIDcdq2jalkUS1IzQ13AWuVruvzZLNI/tVr4A9bdc/x193CokYF3D+iVTQJ7JLNEGWqumlrQS2QFBl5WrI57Vpz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(71200400001)(86362001)(36756003)(316002)(4326008)(83380400001)(33656002)(2906002)(76116006)(6512007)(6916009)(38100700002)(122000001)(53546011)(54906003)(2616005)(38070700005)(6506007)(66476007)(6486002)(66946007)(64756008)(66446008)(478600001)(66556008)(8676002)(44832011)(5660300002)(186003)(26005)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUxUWkxCNXdFYURoaXlKUTJMY1NnVVhDUTZPSmJBd1FqZDE2MUFaeUtaRDQ3?=
 =?utf-8?B?SWppRmJHdm8zb0wzR2cvMi9PS2VVcTZDaEV4VkpjZDQ3K2JQbFFCSGhWVXNp?=
 =?utf-8?B?Smlxd1JFNzA0UTNuOTVpTmVjUzU1MHZadXNIQnRLcVdYOU1UM2J3NVZTT2ZF?=
 =?utf-8?B?a0VsNW5BVUcyZ3JOY3AwTUdHdDdxblVZOUpza3BxcWl1WWFRMDBHTTBnQUFV?=
 =?utf-8?B?OWJNMktVZnNLZmZHSWt6bXVyMWJCeDFZem4zUWpNeHg0WUZ1NTMwUlhFcFlN?=
 =?utf-8?B?SjN3QS9CZEFkVm1TNTFIbTFqMnRIeER0R09iZnlLb280OGlNbUNFdVFLZjNM?=
 =?utf-8?B?U0Z3NnlJSndYNk5LUy9XNjhVSWFyQVhrM1dGQ2FyL1hZMmFseTAwYnpkbjdC?=
 =?utf-8?B?SExnWTY4bk8rZjlmWWFuNDdDdEZtQ05YdGI3QmtWM1A3RHpsVzlvUFREUXFE?=
 =?utf-8?B?Y0Vid1VQazNhYWFTdUxEOHl3MG0wQnlraHpLUXR0MUpMblVadVRhbmpYMkV2?=
 =?utf-8?B?amhxeThzdUhyVzVXSWdZOVJCTk9CZlFYbDRxVDZLWWpFQ2luVWZLN2dJMWYw?=
 =?utf-8?B?QUhqRm0rOU5XZytyV1ZIYWxOMGs1dkhQWCtualU5azNMY0hxMXNtOC9BcXV6?=
 =?utf-8?B?WmpwdnY3UUFpeGhHMjNtcXlyNHJYK1k0RXY4M00vUHJ3c1cvU0FlM1liVGp0?=
 =?utf-8?B?bzJvdHhib082ZHJhWnZlYk1nV3NTWWdOSCtFYUdpaWNtUVEwaXgrZkk0ZWFR?=
 =?utf-8?B?YXhPUktjenZYaVNRQWU1clc5VnhOS0dQMDdwSmR6endVd3E3U1QvOVZXcjho?=
 =?utf-8?B?dS83c21tZnNtdXVmd2kwMEhJTnVzRCtMbGtLMS9Cd1dlTzViaFNFbnVVVkNY?=
 =?utf-8?B?Q1NRelkwVkF5b2FvRDAraFJQekp4YjJOZTVmWjQrWmNUVzFXSXVZb004WG53?=
 =?utf-8?B?YUN3MkEvUnNxRHdLYUVVd2RCOXBoUW52bW54VjRGMjkzOXIzbnFOcE1Qa2xJ?=
 =?utf-8?B?NmpkL3VYUjlwNE9mbFVMS3Jla1BNbC9mZm1mUzJOSVZjZXR1dUxrR3lzRmE4?=
 =?utf-8?B?bDJ0OEJ6c3p1UGpIc0tWSWhuODJSNGpPS3haNlhCTUZNQ2hYSmdJdDFic0hO?=
 =?utf-8?B?b2ZYK0dPbitzM2xyT0xkRzlXTUVuQ0puRVNWbTNwbDZBdnJFdkxWa1VacTBM?=
 =?utf-8?B?b0NHSGd5cHNYSlIyK1UzdWNHb3pDc3JlYXdFWmJ3b05vcmNsTUlpZXJUMkJl?=
 =?utf-8?B?SE1CMVU0VlBLTnpXREZzbVBPNjJUc2hTNWRnNDBHZCtEU1dxcm83OGVzL2Nm?=
 =?utf-8?B?STVWeWp3U2tBWTh0cmNTUldROGdIcXZ3SGFINkhpQ01FYXBWaDlWWHhBUGdB?=
 =?utf-8?B?ZnRHdmtRLy9ISnR1ZTZURUFHZHFsVURtakNTS2swY2RoRUJsc00vdTVxL1Ur?=
 =?utf-8?B?aVc2aTJUNUxwODc1SVlSOHAzbUdMZzRXZTZBR2hMSHJ6b1dVMitDb0VQUElH?=
 =?utf-8?B?a1VXQnd6MlVlK21PNm5TZ01RVGxBUm8rQ1R1M1o5b1FlekVPMHpKMHlqQU5P?=
 =?utf-8?B?N3RBTmVhWFNZYm9RcDl1REJDajhoblZGZlpUMUJ4VTlhc25YcmhQZVFpN0dS?=
 =?utf-8?B?aGpIS3c2alF4VXBNM0ZxOFZHQ2FMQ0pnenZpV0xIRlJyc1ZvMm5ONG45cVFR?=
 =?utf-8?B?NC9mZFpkN3hEN0s0b2VuaDdoYVdkNzNHNEF5Q1l5ZVhGTFlZa2g4aE0zckRJ?=
 =?utf-8?B?THBneHZuVzd5OFUzSmZPajNWUlkrQmh6Y29PRmJlNCt6SFc2ZkZsNWYwUXRx?=
 =?utf-8?B?UnF0d0wzZWxoaXZJd2gwZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCE0660ECB50D94E8891D98935901B6C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 573519b2-5591-4069-15ea-08d972d11573
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:00:58.2461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pnq2jbHW+5oCJn7otPFMGSmP0mnxgImY6BWPsIW4YBxMzWnLBaB12JKnPZzeyGSHkhdZufa22DrZfI5QCd1UccEEwHP5xjU5e0BjSERWWIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2830
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080090
X-Proofpoint-GUID: OL3_oz2kU2nIg6pO8f4aggM7kEwwUFuW
X-Proofpoint-ORIG-GUID: OL3_oz2kU2nIg6pO8f4aggM7kEwwUFuW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gU2VwIDgsIDIwMjEsIGF0IDI6MjggQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZl
bGwuY29tPg0KPiANCj4gQXV0aGVudGljYXRpb24gYXBwbGljYXRpb24gbWF5IGJlIHJ1bm5pbmcg
YW5kIGluIHRoZSBwYXN0DQo+IHRyaWVkIHRvIHByb2JlIGRyaXZlciAoYXBwX3N0YXJ0KSBidXQg
dW5zdWNjZXNzZnVsLiBUaGlzDQo+IGNvdWxkIGJlIGR1ZSB0byB0aGUgYnNnIGxheWVyIG5vdCBy
ZWFkeSB0byBzZXJ2aWNlIHRoZSByZXF1ZXN0Lg0KPiBPbiBzdWNjZXNzZnVsIGxpbmsgdXAsIGRy
aXZlciB3aWxsIHVzZSB0aGUgbmV0bGluayBMaW5rIFVwDQo+IGV2ZW50IHRvIG5vdGlmeSBhcHAg
dG8gcmV0cnkgdGhlIGFwcF9zdGFydCBjYWxsLg0KPiANCj4gSW4gYW5vdGhlciBjYXNlLCBhcHAg
ZG9lcyBub3QgcG9sbCBmb3IgbmV3IG5waXYgaG9zdC4gVGhpcw0KPiBsaW5rIHVwIGV2ZW50IHdv
dWxkIG5vdGlmeSBhcHAgb2YgdGhlIHByZXNlbmNlIG9mIGEgbmV3IFNDU0kgSG9zdC4NCj4gDQoN
Ck1pc3NpbmcgDQoNCkZpeGVzOiA0ZGUwNjdlNWRmMTJjICgic2NzaTogcWxhMnh4eDogZWRpZjog
QWRkIE4yTiBzdXBwb3J0IGZvciBFRElG4oCdKQ0KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cg0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+IC0tLQ0K
PiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgMTUgKysrKysrKy0tLS0tLS0tDQo+
IDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gaW5kZXggMWU0ZTNlODNiNWM3Li5jNmIzZDBlNzQ4OWUg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gKysrIGIv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBAQCAtNTMzNSwxNSArNTMzNSwxNCBA
QCBxbGEyeDAwX2NvbmZpZ3VyZV9sb29wKHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiAJCQkgICAg
IkxPT1AgUkVBRFkuXG4iKTsNCj4gCQkJaGEtPmZsYWdzLmZ3X2luaXRfZG9uZSA9IDE7DQo+IA0K
PiArCQkJLyoNCj4gKwkJCSAqIHVzZSBsaW5rIHVwIHRvIHdha2UgdXAgYXBwIHRvIGdldCByZWFk
eSBmb3INCj4gKwkJCSAqIGF1dGhlbnRpY2F0aW9uLg0KPiArCQkJICovDQo+IAkJCWlmIChoYS0+
ZmxhZ3MuZWRpZl9lbmFibGVkICYmDQo+IC0JCQkgICAgISh2aGEtPmVfZGJlbGwuZGJfZmxhZ3Mg
JiBFREJfQUNUSVZFKSAmJg0KPiAtCQkJICAgIE4yTl9UT1BPKHZoYS0+aHcpKSB7DQo+IC0JCQkJ
LyoNCj4gLQkJCQkgKiB1c2UgcG9ydCBvbmxpbmUgdG8gd2FrZSB1cCBhcHAgdG8gZ2V0IHJlYWR5
DQo+IC0JCQkJICogZm9yIGF1dGhlbnRpY2F0aW9uDQo+IC0JCQkJICovDQo+IC0JCQkJcWxhMngw
MF9wb3N0X2Flbl93b3JrKHZoYSwgRkNIX0VWVF9QT1JUX09OTElORSwgMCk7DQo+IC0JCQl9DQo+
ICsJCQkgICAgISh2aGEtPmVfZGJlbGwuZGJfZmxhZ3MgJiBFREJfQUNUSVZFKSkNCj4gKwkJCQlx
bGEyeDAwX3Bvc3RfYWVuX3dvcmsodmhhLCBGQ0hfRVZUX0xJTktVUCwNCj4gKwkJCQkJCSAgICAg
IGhhLT5saW5rX2RhdGFfcmF0ZSk7DQo+IA0KPiAJCQkvKg0KPiAJCQkgKiBQcm9jZXNzIGFueSBB
VElPIHF1ZXVlIGVudHJpZXMgdGhhdCBjYW1lIGluDQo+IC0tIA0KPiAyLjE5LjAucmMwDQo+IA0K
DQpPdGhlcndpc2UgDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5t
YWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGludXgg
RW5naW5lZXJpbmcNCg0K
