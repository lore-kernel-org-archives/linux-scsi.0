Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECBBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0745760FE8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhHXDj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:39:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234015AbhHXDj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:39:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NHEv4h021106;
        Mon, 23 Aug 2021 20:38:29 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3amfwj1v4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 20:38:29 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17O3anVS014572;
        Mon, 23 Aug 2021 20:38:28 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-0016f401.pphosted.com with ESMTP id 3amfwj1v4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 20:38:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJEFF81QdWCKRbnwLAR9sM/OI7ofZhqukKMqTlxptHidZomgoP4DTtRgYYcClyTqo0nv24IByOrPOZqhAL/DkSpju1rpqoFC4OGMVF1KHY1KqBaqEjTxybRBJefk2zDLXP5rL3/t3Jfn3bF9y1GYbmDiCSpQSZKyRWjjHlYYCs4UNJXojGXXMiiQvXeWMK5EROoW0iyTO5oWGt4cPHrYN6XpNkXO7KueqfDw2QHgMp0VX+Kix8wqznnxQeVv6h4geZECj4qTLCoIgGne3L0CAKMexR5fFPxjJxTUDryiy6dxHSfKeh76U4PgyhOmKi7+Da7eSPXwVUuDrwZQEe+cpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvWnr7oWyGqi8WTql1HpwkYUQnuVhyierY7n6LUs+70=;
 b=iN7nZN8BSBxjojjVUuKe2SVXp5WrrJcHF3KHWRtycWZrNJSzsGS3EO8EkZQuW8Qd5lDvMpoomr0+4gubH2Su2qCFJ2sy/FWDCaij1vIKlOTmjDuwt5nK5WJOvWy9vUepnQUdgwhS+cT+ceEBX6kumRwqe3MSK1Rxgr8evXfaJ+9rCwz6bj38wnlCpLNnIxCcCqs/NBPeG0sGPCg0MZsszh40al+yjAqz7NYEpOlCNtu7S/gJvW/BGRgmvgW6Oc+TxKp4jsXsmnzB01xwcFHwrwZzNailqM+J3nBQhg0u836Ooq8GmMHTbBvWhTUaYfpSdSNjAIdDyPXdSO8kyeHHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvWnr7oWyGqi8WTql1HpwkYUQnuVhyierY7n6LUs+70=;
 b=iWeA+KTUQaM4U+NjKl4RFjAYQdrCHcIEhvdI0RxBbcIKtNX9j/lzDINXRud3ENHncN33dqQfSqbEKU8ME+haA9nRD+1J/ghzJrMicR61Sa1rRiw3NSDiqZ1mSerM42agTgvG5apqLjPheKJ5JzXAlbtWoKI4WA8NCY5N/yhUS2Y=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB1051.namprd18.prod.outlook.com (2603:10b6:3:27::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:38:24 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::51c2:62c:df04:89db]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::51c2:62c:df04:89db%4]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:38:24 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Ming Lei <ming.lei@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Topic: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsA=
Date:   Tue, 24 Aug 2021 03:38:24 +0000
Message-ID: <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
In-Reply-To: <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: grimberg.me; dkim=none (message not signed)
 header.d=none;grimberg.me; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b689edd-09ed-4a38-0ed1-08d966b0a0c5
x-ms-traffictypediagnostic: DM5PR18MB1051:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB10517726D4E57A7AA3314355D2C59@DM5PR18MB1051.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BYsTspR2K+AEr+K1akIqy1Ced3t9yxpOCMNPogzMFRERVAwG/ZEjCoz9brUPAe+VvaA/QhHIOnv821HxtC4xjt5n2l/4nzEeZHReka7miOV1czXizBJuJ1k4UF5obld1k4HLKnOXdKdhgFUAArIV8E1qLug4mkvDiXOmXFUj846rst1ZtFF+vk4JYLs2L39FCwuZgrroh0CuIHYOi0o5bM0ASZ7kOCqxh35thm49gJ0V2wJI+3a1qHAb40jheicXDZbyBKHmSMOYWKwELiVk1E0/+9EktXsRUuVeF+7BZkh64daHBu31yC0a+Vn1PaygYC8cwRCyNUDDeT/LxSGPdyKORDiwnXfm5sneITe9Os9KVsMDpLa5rB/cyV92/W89XbXpij6AxFqAnsqovyp0v5JagqEMVbFL+1bLwcss3j1P7jdvNLAmDo/T9jRKhts73xeXQrDUO0I6ZzVfyvdndMnGgQpfgv3n/cL2nv+3Dl6j+MV/xDTWanocuvapD/6A3PLgpRakLGX9d+WCSC5S/biSY1GU5R61t8+nyFj29u1VUVQEWafFao9pkyqZJCuOGsZv/qbKvC0mEuk/5+g+GSbNX984x8W/XKOyhrKE5QghTCqFu6jZ+46ligVL3HvbvZONkwAAvOt62l5VtUEaufVFVV05P1pI9yC4cLwmB61Cb7IaoPHS85XFP37cURKZeVE8MQouyd23keBEKk1UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(8936002)(33656002)(53546011)(6506007)(316002)(2906002)(66446008)(38070700005)(110136005)(66946007)(76116006)(66476007)(66556008)(64756008)(4326008)(54906003)(5660300002)(7696005)(55016002)(9686003)(122000001)(478600001)(107886003)(52536014)(38100700002)(86362001)(71200400001)(186003)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVVFTDc3cldXdmc0K09oWkhHbWtvS2RoN2NjbG1lcVVHcDkyNFRaZDJjY0JD?=
 =?utf-8?B?d3lKVjk5dlYwdHpDMFF3ZzBFdWlWK1pWelhjNEF4R2k0TDlheXFPQW5FM0U4?=
 =?utf-8?B?NU1na0Rndi9EM1pqcldsa0FJd1ZmRWFqeDhNbTFsZXZENlFpVisveFlBMmlz?=
 =?utf-8?B?WVFLN1E1UDlobDV2UldXY3gxbDBWZUtLUGliaDJ1U0xUK0VuUFFZRHFmVysx?=
 =?utf-8?B?ak1hbGE2cDRmRlRCS3pKcXhoanMzekpPQ0FWQnpsSnhweEVUbGZlK1FKMStO?=
 =?utf-8?B?cXhxVjhuQzZqTG5ZM3VFL3llSCtZL202SHZjdDRwNnZteTI0VmpFZFhhTnhQ?=
 =?utf-8?B?NCt4d0NiUWYvV2JIenRJa1hQa2RwZGtPWE1JdmkrM0RYVk02S0haOE5LYklK?=
 =?utf-8?B?enFlcUVQQlc1VGJMMWNCNG1DVkxtSVk4cHdjdXZNYWd0ZjJoYm9VZHhneFZj?=
 =?utf-8?B?VEJKZlZGOHFDNVVCd3BBUUlMRVk2ZkVtVThqbmV0S1VKU244T2JrNnlLb1Zh?=
 =?utf-8?B?bWM3L25KNm9NTFhWVUtVSmdVYy9JdFl5VCtkcFNvejBSWmE2K2F1bk9MdDJM?=
 =?utf-8?B?a2NBcmtCdjJsT3ZWTnYwWDdWWGZLd0gwMDVOYkxUSnorVkM3QkVlVzlsUTJ4?=
 =?utf-8?B?V1lFRkphd0ppMnJwUDJkb0lJV2ppaUhpWEF0UlJSQXR3YVN5dnJmVmJLSzBq?=
 =?utf-8?B?Q1FjT2dTYnkzTTErQlFDRVZzTGZYeWlSZ05wNlJ1UUFvdy9kWWNHcXhEdVp0?=
 =?utf-8?B?OG1kdkprd0lJT3FxazFacFl6b05oNEtOd3Uwait4WGc4Wlc3Zi9GSERaK0Ft?=
 =?utf-8?B?TjMyOFJibWhXdGRKNUQ5N0hpaTkxTk1qdGVybFlTUDVZQ2JobTdpN2g0SVcv?=
 =?utf-8?B?ODNITGdLTFBXQ05qVjNjK01BQjM0V0I3ZFRHeXl2blpsUHZhL3FiWjIxS2J1?=
 =?utf-8?B?VTZaWFp4Ui9VbHNHK3FVMTE3UUVCS0ZHRE9hWEFnTEV2eUExQzV3UEh6d3px?=
 =?utf-8?B?Y1NHNDlvb2tQcE8zSHR2bXlTUWlnK2M0WityTythRXEydC84S1hma1owcEtt?=
 =?utf-8?B?ZkliK09jRnlNczhnWFB4YmZPdCtkM1J1bUpEeVRJR1VCWjZ5YWhFTjNLdWlp?=
 =?utf-8?B?aXg1bTAzWVVhZmRFcHRXQW5Rd2NGcExRVHNhZUhnUDNISlZGUXJLVkkyTjU2?=
 =?utf-8?B?UnVLNjF5SElkRmM4RG5ua0lwUmhpUlNHMzRDd01UUUZKUmRFcUovRnh3Vk9Z?=
 =?utf-8?B?TXprSENWcENtUm1mKytjRkJGU21mYVBYL2FqeXlucUk4WEVUbzdyRTQ1MXl1?=
 =?utf-8?B?WGpuNW44aE84T2tqRURvVDF3cFZjWGY5WFQxSUFQU0VhckxpYW9GWkRkeUhN?=
 =?utf-8?B?dDZKdVhXcnhqSjQ1SHBWbE9waGRuZFlOdmhOc3lWU2ZGeTAvZHhwekczSFRs?=
 =?utf-8?B?N2ZOOUpNelZkbWJxUTJOMklYclJLME0xOEpuVVhEQlVRUkJtRlJTM2hXcWNp?=
 =?utf-8?B?QmNMbHpBQUIvdzBQamN2bDFUd3ZiS0xpdXpBUElZaW96SnZib1BpV2ZqN3J4?=
 =?utf-8?B?NmRXZ2NXZnp1NHg2WEFEcWY3aTNEMVJyZzdBOE1uVjNkYUJLU2RhRWphb0Zq?=
 =?utf-8?B?ZDVoZXFPYkhTT0JZamZ4T3FVQTU3QW1ZT24yeU5kTGc1OWNNOFRsV3ZxWWFq?=
 =?utf-8?B?U0g2bVZveHZuTXpNYzFaS0ZZNlBKbStQL2paMlRCUk5jeTdPLytCb21rd1Nu?=
 =?utf-8?B?ZDdubUpHdVRTUWY4ak9HMzZtQWlXdmlybmh3QTZwZkFUZi9vN1EvdXdhbWxB?=
 =?utf-8?B?MGIvaEk4VEpHcnh6QVZGb2Rwbmt6YWFDUFlnbW1QRzljOFdZcEFvbFJaQ2F2?=
 =?utf-8?Q?OYTIPjQzIbNKE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b689edd-09ed-4a38-0ed1-08d966b0a0c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 03:38:24.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIGdAGNzOnn4S9q10UeSU9jGxxRtLvy/fWxg1GOFwOUGlUahloS5MsijTTXyd1uLKR2XTiv6L2LrZRMnEH/9jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1051
X-Proofpoint-ORIG-GUID: 38nw4olZrP5HQ-cSf-CFBccQqLR8vsy9
X-Proofpoint-GUID: wT3yVGTIQg7RLCOuxvjsvjddbeQPxr3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_01,2021-08-23_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgU2FnaSwNCkNvbW1lbnRzIGlubGluZQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+IEZyb206IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo+IFNlbnQ6IE1vbmRh
eSwgQXVndXN0IDIzLCAyMDIxIDEwOjUxIFBNDQo+IFRvOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPjsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb207IGxpbnV4LQ0KPiBudm1l
QGxpc3RzLmluZnJhZGVhZC5vcmc7IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPg0KPiBD
YzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFt
IDxHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggMC8yXSBxbGEyeHh4IC0gYWRkIG52bWUgbWFwX3F1ZXVlcyBzdXBwb3J0DQo+
IA0KPiANCj4gT24gOC8yMy8yMSA1OjU2IEFNLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0KPiA+IEN1
cnJlbnRseSBudm1lIGZjIGRvZXNuJ3Qgc3VwcG9ydCBtYXAgcXVldWUgZnVuY3Rpb25hbGl0eS4g
VGhpcyBwYXRjaA0KPiA+IHNldCBhZGRzIG1hcF9xdWV1ZSBmdW5jdGlvbmFsaXR5IHRvIG52bWVf
ZmNfbXFfb3BzIGFuZA0KPiA+IG52bWVfZmNfcG9ydF90ZW1wbGF0ZSwgcHJvdmlkaW5nIGFuIG9w
dGlvbiB0byBMTERzIHRvIG1hcCBxdWV1ZXMNCj4gPiBzaW1pbGFyIHRvIFNDU0kuIEZvciBxbGEy
eHh4LCBtaW5pbXVtIDEwJSBpbXByb3ZlbWVudCBpcyBub3RpY2VkDQo+ID4gd2l0aCB0aGlzIGNo
YW5nZSBhcyBpdCBoZWxwcyBpbiByZWR1Y2luZyBjcHUgdGhyYXNoaW5nLg0KPiANCj4gRG9lcyB0
aGlzIG1ha2UgbnZtZS1mYyB1c2UgbWFuYWdlZCBpcnE/DQoNCnFsYTJ4eHggZHJpdmVyIHVzZXMg
cGNpX2FsbG9jX2lycV92ZWN0b3JzX2FmZmluaXR5IHRvIGhhdmUgYWZmaW5pdHkgd2l0aCBlYWNo
IE1TSS1YIHZlY3Rvci4gQ3VycmVudGx5IG52bWUgcXVldWUgYXJlIG5vdCBtYXBwZWQgYmFzZWQg
b24gYWZmaW5pdHkgYW5kIGlycSBvZmZzZXQuIFRoZSBjaGFuZ2UgaXMgdG8gdXNlIGJsa19tcV9w
Y2lfbWFwX3F1ZXVlcyBmb3IgbWFwcGluZywgdGhpcyBmdW5jdGlvbiBjb25zaWRlciBpcnEgYWZm
aW5pdHkgYXMgd2VsbCBhcyBpcnEgb2Zmc2V0Lg0KDQpUaGFua3MsDQp+U2F1cmF2DQo+IA0KPiBD
Q2luZyBNaW5nIHRvIHNlZSBpZiB0aGlzIGFmZmVjdHMgaGlzIHBhdGNoc2V0Lg0K
