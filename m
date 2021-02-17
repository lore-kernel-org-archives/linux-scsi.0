Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643C6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 21:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DB6D64E79
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 21:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhBQVGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 16:06:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhBQVGa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 16:06:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HL5BXb172874;
        Wed, 17 Feb 2021 21:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ls+qfGHMTPCTJh9xqdzqZVyuq40gsRfZcA91XsjqRQo=;
 b=X/dEot3dsl7jZR4GmJzXK5Oh3alHEBgO7htZLWPFIgBcRjXC5hWyEFzmInxETxe1eTI1
 eb44JUblokJhwD3vzcGfVknUNXOIi8UQD/oAwZMWxw54FfpeRDfXFVEYpKDQNWTNAFjT
 SvKuwYskg1EpVKWXk1cI+66xpjatUs9TL6IsAHNeDaU3L5fJ0HmtGaOtZ+2+GahqdjQQ
 02NzdMoR7ck/vFKiXCQu3KPXF8u4Dq7gzpshJ/BAJqjDIVzArGxm6JrUTn90AjNOa8p5
 HQJ8SbRJyzv9DrtYPj1uWjgZVRfzU9czOlfaNA68rZQ3SdmhBooIITbXKKgPFWE+jKaY tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r3uym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:05:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HL083P065710;
        Wed, 17 Feb 2021 21:05:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 36prpymjwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyVgRX5zvNWpxMOjZJAeMQXJvVhpZ9HVE6n7qwOxr4VGblaSAbSj8qT354tQxZsv6RggnzJDDyAGASOysN2O8NgwGSPg530idE8TfOA/i1z93V08tvvy8fyw5sIa4ugjRsQ4Gssbw2GudaROmgV5n+xTnbcgKdqiYP25l6fDQgrvw/kk6e+tuAFtr2NLYpwqdgx+b1g941P6CANAT0KUDkRGIi/sfCrOa/e8vbI9lgO2meDLlJfB3UzmIflVAf86AbxX37eWRvhDlHhm7os8g5ij5nkIzA0nR3eK7iHQOnvAItvAfn6S0H8NX37BEsGSD6q6ExeRuh4dVaJ49d5OSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ls+qfGHMTPCTJh9xqdzqZVyuq40gsRfZcA91XsjqRQo=;
 b=SiCn/JFBi7Tz4sfxuV7Xhk+HleICeUMl4JrdRJ9kDkr/Fp+J1Rxa2OEVinllbZdsMi+OTlANB4jw4v0NLw/mH00iqs7cPe2yCPTfnrcQ8J2nWfSKO/GeGAbqN1EiWsYVolJgdTLIvNiZGwghWV+BKI4nK3IiwDP8+urKW642VlxZcZU+iOpY0OMberlrLVQqc2V/qiuQz15X0xDgB3JKkKN7OCZZM1MtKi59+2Na18nilit1BRbv+Uzby0K3GkkRJvjPQcNW7CzQBY7iEhpxf4YumG9RFvF9v3DNu5FO0n/TmZUASW0snQBghqKc94l1hMqRWpbnosyJ23sd6Hyrcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ls+qfGHMTPCTJh9xqdzqZVyuq40gsRfZcA91XsjqRQo=;
 b=T1hwTZhB+y9cILkZ9ojZgajCeEJCx5pqFBMYWXY6Au66QfGVyQ0Y5whyRu7ySQgTM5i3a6RP/OcbVNeVmjhTo1z09TXA5tcaH6xeRuWZPgHiskz3CXWCZzpI8+UIW6uPUjtv32WUTzOSZIYuL8J0lQA9n23X5c3g8BaF/IPHfRo=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4180.namprd10.prod.outlook.com (2603:10b6:a03:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Wed, 17 Feb
 2021 21:05:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 21:05:38 +0000
From:   Michael Christie <michael.christie@oracle.com>
To:     Gulam Mohamed <gulam.mohamed@oracle.com>
CC:     "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V3] iscsi: Do Not set param when sock is NULL
Thread-Topic: [PATCH V3] iscsi: Do Not set param when sock is NULL
Thread-Index: AQHW9T4uLGlYO04Z+UKHSgENrsFNwapFusEAgBbIvACAAHNNgA==
Date:   Wed, 17 Feb 2021 21:05:38 +0000
Message-ID: <433AECBD-4BEF-45E6-A523-311C6E7BA470@oracle.com>
References: <20210128061753.1206620-1-gulam.mohamed@oracle.com>
 <f8141353-7792-59d7-1f36-f338bb25cf7e@oracle.com>
 <CO1PR10MB45639C515F423B5829CD666798869@CO1PR10MB4563.namprd10.prod.outlook.com>
In-Reply-To: <CO1PR10MB45639C515F423B5829CD666798869@CO1PR10MB4563.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [73.88.28.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39857251-ee5d-44f1-70fe-08d8d387c6c8
x-ms-traffictypediagnostic: BY5PR10MB4180:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR10MB41809F0AF0C7DEEF1E745045F1869@BY5PR10MB4180.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c5gfpITcVO2FBE34+YKvYjJRfYrYS+qbT0pGpxgMQUKthjPIgreHye8bRUSCyxG1hcfT4nzBwnrEbNU4ctvwuaq8w4VCO2Do2GEnrgXWXxihNmZyBVZdpiMUh/asYSiWzFB/v6hcCt7ofagH1s9ykKgGUbJiRVIMSV40Rf0uOg4sE0BFZSIk7mLXeunEEtZuOab3MOIR/XGlIw1x7ye27Y6aVGL6ypSr5Xv3IgpT9V7eYVOKoVD+XJI4wzIAIaRCji8BEILYveuoXLc5nS/DhCgeD6cQj3Bx1ptabdgJVOH5qXX4FU8S4jmFktUaSHK4md4jH9ysuYABzcUJNY1DfKHdD6gX8WvWTFYqUl8wAKYr0d3gvThFvkUN/V8tOeZce+BUnJSReA6pwcRrfVE/D6ynAkhko5RznWC1PB/Sv0kv6kUqj6TV0xgDu7Br0UG1UOvcXiwrYlGezpu49uP4GY6GdOt0UtXVybRBIawzdav651qLgvjwMF9wUfthVA39mnKUovTv0ATDea7VE7Xlqrwj/puzI4Fib+nmNJHZpAfWK260v0TWhnKBGyKylmmXLyix+BMFcNnOZyRcLqzAKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(376002)(396003)(83380400001)(44832011)(8936002)(37006003)(26005)(8676002)(54906003)(6506007)(4326008)(316002)(2906002)(478600001)(5660300002)(6486002)(6862004)(66446008)(64756008)(86362001)(33656002)(6512007)(53546011)(71200400001)(76116006)(2616005)(66946007)(66556008)(186003)(91956017)(36756003)(6636002)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L1NhREJsUjJseVJRM2FnWUtBb09GbStVZVQ2Y25acWFDZGl0VWt3dlJpckNs?=
 =?utf-8?B?ZHNzcE5wdDF6SEZkd2xnWW0xMjhxK1lmQ0I0Q1NheUVpZCs1Mm9aNjErakZr?=
 =?utf-8?B?WEcxV3JXNWliOW1OM3VtV2dKQVRaaDlUQVdEUFZaaTVDZVFmb1J3YmYzTktT?=
 =?utf-8?B?ZTdHaDRpV3lSUitwei9iZXFsdUREU0wyYnZQRng1VjJWTHBBUXVPb041aDRX?=
 =?utf-8?B?UFFkL2hmN3hiL3gxR0NaUUp3RStzNVZaWFc2OW5lR2R3VDgvdXlOZ2lBb0RZ?=
 =?utf-8?B?T2E2MnQyVkplcTF0THFtcFRYZ0dYWjcwUGtFaFRYVEorR3YzV2FlWG1zUFAz?=
 =?utf-8?B?czVuNytPemdTM3lkVDl6V2NqYTJQMGRINGFKc1JWVHFmbi9mUjhqYmEzbkVz?=
 =?utf-8?B?RXEyMG1wQTYvU1U0VGJWVEQzL1d1WFFaRVV2NkRFQzFwYlYzQUQ0MzBSSm9j?=
 =?utf-8?B?ZzZ0SUJwR1hjcDV1UFFMaitaSUlqeUROb1VKcG5HdWpWQWNDTUV4Rzh5S1Nj?=
 =?utf-8?B?ZDd5cEl2TkRjK09jZjIzUEhnUU9oQlJEc05VdmdLVzk5bmY3ZlhZdk5xZ1Bl?=
 =?utf-8?B?UTk5R3JOZUhBQmNkOTNaaXA4ZjZZQ3YxR3RhL2gwSXNncllWNGpWVFJLME5N?=
 =?utf-8?B?ZkNCZ05VQXZWNy9GUmZRajdlcjNUQ2ZHdVZhYStvd2FqWi9xTy9LR0tSZkQ3?=
 =?utf-8?B?SXpMKzZHVmRlWXE1TnhDVzdLOFlMSmxHTElrZnhLZkszUlJIQWduYmtiU2Jp?=
 =?utf-8?B?cmRoWU5mL1pRVDRrNUowWlBKTWdiYm9tWDJSbW9ybFBMekw2RlpMV0U0aHBO?=
 =?utf-8?B?aHMzZkpHMFRzVXgxdkdDbytRQzcxMTBBNmFoeXU5eHJpakFPN3luOHlieEtR?=
 =?utf-8?B?RDQxNndRV0VrSmRsS0p2cnZyQ0x1UUNDZ3pwd2JwNkoxMW5MOFc1aUFVZHVk?=
 =?utf-8?B?WjhuR1l2UkJTM0FIT1NZMkpjVGo4Y3RYZmtXV0NTQ3J2Q0hJN2J4Y0Y0Z0V1?=
 =?utf-8?B?VVY3YXR4cUlmQ3gzdzJici9xYjJrdGRNZTBDdmdzUmhQWnFUQzE0SzdlVVNV?=
 =?utf-8?B?dUtsNjBCZkozbm9WbDhjc1RhOVl4Uk9Mb2pOTWpDc2pUb0JiOS9MNjZrSllr?=
 =?utf-8?B?NUEweE1KQVlYUml5NkZVS2ZwTGNhRXpFYm00cytaaHN1U2k1S1VTSFJhZTdo?=
 =?utf-8?B?dGtvdVpnb1pTd0pzWTFxMG1qTVVadXM2OUUydHVjaXV4bjFteit3cHprVDRZ?=
 =?utf-8?B?d3d4dHM3aHpIWGFHVjBrd0JnVmNScHFJVUtVYlhvN1VpZ1p0ZEtLWlpodTVG?=
 =?utf-8?B?V1Y0UGNybTBQenlOZS8wNzhFL2k4VUxSN0Y2QWVpRzdXL3N2M0Rwek5QZnRE?=
 =?utf-8?B?QU9lcm1tV3NoZ3JNbk01RWZHaFEzTDFrejhqWUNXa0k3SnFDTUU3UFovL0J5?=
 =?utf-8?B?N3REUm1rc3RXUTdaa0k3VUl4RDM5VHV0ZG8rZW4xZ1NuQmprRDE2cDdWSkVl?=
 =?utf-8?B?eFRPY21XcU1IajNubWNmaHo4eUN4bE5lY1ZSNW1zMWZsc3d4T2tqMmJKcFFN?=
 =?utf-8?B?K3pITEZ1NFhORkVCTEo3Q04vSjUwYURnd0podG1pcno3cG1Scmw3VTk1UTNh?=
 =?utf-8?B?a2tmQThxWjhUSVMyMkorRFp1LytxMDVwaXZGUXJlblRZdmZSZ2xoakVNY2Q0?=
 =?utf-8?B?dVFISEk0QjNJMXROd0s5aUZEQU92bEUzQitZUXlxbEhTcUdtaitkQVVoTTNl?=
 =?utf-8?Q?crME4fWOhxPgHCd9oW4NMvMzALDaqW/ecp+LK9Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71D52C4FB01B384B904DF0E92DAD04D1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39857251-ee5d-44f1-70fe-08d8d387c6c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 21:05:38.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D45Upk6jLs16pWwu3EeBpRYlUzKNVW7tvR7Qt3m78MlEIojycBVkTwOfZGIjtv71h+SdsObxlD/U/zd8NjMwbGDzr8NvPvbyQYUcvrFbgrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4180
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170158
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gRmViIDE3LCAyMDIxLCBhdCA4OjEyIEFNLCBHdWxhbSBNb2hhbWVkIDxndWxhbS5t
b2hhbWVkQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gSGkgTWljaGFlbCwNCj4gDQo+ICAgICAg
ICBSZWdhcmRpbmcgIiBBbHNvIHRoZXJlIG1pZ2h0IGJlIHRoZSBjYXNlIHdoZXJlIGEgdG9vbCBz
ZXRzIGEgdmFsdWUgdGhlbiBmb3JjZXMgYSByZWxvZ2luIGFuZCB0aGUgbmV3IHZhbHVlIHdvdWxk
IGdldCB1c2VkIGZvciBzb21lIGRyaXZlcnMuIiBpbiB5b3VyIGJlbG93IG1haWwsIEkgd2FzIHRy
eWluZyB0byB1bmRlcnN0YW5kIHRoaXMuIENhbiB5b3UgcGxlYXNlIGdpdmUgbWUgYW4gZXhhbXBs
ZT8gSXQgd2lsbCBoZWxwIG1lIHRvIHVuZGVyc3RhbmQgY2xlYXJseS4NCj4gDQoNCk9wZW4taXNj
c2kgc3RvcmVzIHRoZSBjb25maWcgdmFsdWVzIGluIGEgYnVuY2ggb2YgZmlsZXMgb24gdGhlIHN5
c3RlbSdzIEZTLiBCdXQgb3RoZXIgaW1wbGVtZW50YXRpb25zIGNvdWxkIHVzZSBzeXNmcyBsaWtl
IGEgdG1wIGxvY2FsIEZTLiBGb3IgdGhpcywgaWYgeW91IHdhbnRlZCB0byB1c2UgYSBuZXcgbWF4
IGJ1cnN0IHZhbHVlIHRoZW4geW91IHdvdWxkIGRvIHNldF9wYXJhbSwgYW5kIGR1cmluZyBsb2dp
biB5b3VyIHRvb2xzIGNvdWxkIHJlYWQgc3lzZnMgYW5kIHBpY2sgdXAgdGhhdCB2YWx1ZS4NCg0K
V2UgdXNlZCB0byBkbyBzb21ldGhpbmcgbGlrZSB0aGlzIGZvciBib290LiBXZSB3b3VsZCByZWFk
IHRoZSB2YWx1ZXMgZnJvbSBhIG1peCBvZiBjbWRsaW5lLCBpYmZ0LCBldGMsIHRoZW4gY3JlYXRl
IGEgc2Vzc2lvbi4gV2hlbiBpc2NzaWQgc3RhcnRlZCB1cCBhZ2FpbiBvbiB0aGUgcmVhbCByb290
IGl0IGNvdWxkIHJlYWQgdGhlIHZhbHVlcyB1c2VkIGZyb20gc3lzZnMuIEluIHRoaXMgZXhhbXBs
ZSwgd2UgdXNlZCBzeXNmcyBhcyBhIHRtcCBwbGFjZSB0byBzdG9yZSBvdXIgaW5mbywgYnV0IHBl
b3BsZSB3b3VsZCB3YW50IHRvIGV4dGVuZCB0aGlzIGFuZCBpbnN0ZWFkIG9mIHVzaW5nIHRoYXQg
4oCcYnVuY2ggb2YgZmlsZXPigJ0sIGp1c3QgdXNlIHN5c2ZzL3NldF9wYXJhbSB0byBnZXQvc3Rv
cmUgdGhlIGlzY3NpIGluZm8gZm9yIHRoZSBsaWZlIG9mIHRoZSBib290Lg0KDQoNCg0KPiBSZWdh
cmRzLA0KPiBHdWxhbSBNb2hhbWVkLg0KPiANCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gRnJvbTogTWljaGFlbCBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPiAN
Cj4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAzLCAyMDIxIDc6NDcgQU0NCj4gVG86IEd1bGFt
IE1vaGFtZWQgPGd1bGFtLm1vaGFtZWRAb3JhY2xlLmNvbT47IGxkdW5jYW5Ac3VzZS5jb207IGNs
ZWVjaEByZWRoYXQuY29tOyBNYXJ0aW4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUu
Y29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBW
M10gaXNjc2k6IERvIE5vdCBzZXQgcGFyYW0gd2hlbiBzb2NrIGlzIE5VTEwNCj4gDQo+IE9uIDEv
MjgvMjEgMTI6MTcgQU0sIEd1bGFtIE1vaGFtZWQgd3JvdGU6DQo+PiBEZXNjcmlwdGlvbg0KPj4g
PT09PT09PT09PT0NCj4+IDEuIFRoaXMgS2VybmVsIHBhbmljIGNvdWxkIGJlIGR1ZSB0byBhIHRp
bWluZyBpc3N1ZSB3aGVuIHRoZXJlIGlzIGEgcmFjZQ0KPj4gICBiZXR3ZWVuIHRoZSBzeW5jIHRo
cmVhZCBhbmQgdGhlIGluaXRpYXRvciB3YXMgcHJvY2Vzc2luZyBvZiBhIGxvZ2luIA0KPj4gcg0K
PiANCj4gSGV5LA0KPiANCj4gU29ycnkuIFdoZW4gSSBoYWQgc2FpZCB0aGF0IHdlIHdhbnQgdG8g
bGltaXQgdGhlIHdpZHRoLCBJIGRpZG4ndCBtZWFuIHRoYXQgaXQgc2hvdWxkIHNwbGl0IHdvcmRz
IGxpa2UgYWJvdmUuDQo+IA0KPj4gCWRlZmF1bHQ6DQo+PiArCQlpZiAoY29ubi0+c3RhdGUgIT0g
SVNDU0lfQ09OTl9CT1VORCkNCj4+ICsJCQlyZXR1cm4gLUVOT1RDT05OOw0KPiANCj4gSG93IGFi
b3V0IG1ha2luZyB0aGlzIGEgY2hlY2sgZm9yIEJPVU5EIG9yIFVQPyBTb21lIG9mIHRoZSBzZXR0
aW5ncywgbGlrZSB0aGUgVE1GIHJlbGF0ZWQgb25lcywgY2FuIGJlIHNldCBhZnRlciB0aGUgY29u
biBpcyBjb25uZWN0ZWQuIG9wZW4taXNjc2kgZG9lc24ndCBzdXBwb3J0IGl0LCBidXQgbWF5YmUg
b3RoZXIgdG9vbHMgZG8uIEFsc28gdGhlcmUgbWlnaHQgYmUgdGhlIGNhc2Ugd2hlcmUgYSB0b29s
IHNldHMgYSB2YWx1ZSB0aGVuIGZvcmNlcyBhIHJlbG9naW4gYW5kIHRoZSBuZXcgdmFsdWUgd291
bGQgZ2V0IHVzZWQgZm9yIHNvbWUgZHJpdmVycy4NCg0K
