Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD86C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05DB3619CD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhCXQYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:24:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhCXQXz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:23:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGFcTt036682;
        Wed, 24 Mar 2021 16:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LXs7z+0eluo49KPgpCKhRtdav0QO26+dTHQLqvRaNrQ=;
 b=MC7nwsCceDsbhR5a1G1zzORLXO0cKQha3Wtm6x3wJ59kqyvc43lfcQARaMiH5YTVVsCI
 dVxD0arog5bfu2u4qgcwZUP5+iGETwmYGr8pGLg/X2vcb8aHGnM6Fbg5lWcEXYJiZ3c9
 QiGXWWYY3FmyZh3w6HH/KxtFRO6I8tFHsUqwPh4pHQT1EBLW3SjjCc7PGJstVr7A9BV4
 dBs8xX89oqTswJMZYhI2+0VU3uywFopOx3TNbUe20uUIM21OxC/bM4gkdGesvuCAWdL7
 dfSTsj+jzHzoVoqG1diX9AIez4ICBjaXIKQfm8Q+L4twP1vSCR+LHiI6e73ZKEZ+JFB6 yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mkbv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:23:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGGQDE195456;
        Wed, 24 Mar 2021 16:23:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3020.oracle.com with ESMTP id 37dttth20y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:23:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=az6xenFK47KYqHWcM6Tyvk/IX+cpC3IyWsoLEJ/oYWWvLe1UF53rBamk/VAB2ZJNuLDcHU+rpsNXUx232b4ux/TsnDuiU6ze6ZSV+efTsJkzNfiiIdPWh7/xEoWTPuYnlVFoBqMi8HuDMXCXGlx5dtikwKwKEZTkoYjMcwBzQWI2sXePrBfppg1VonY0bKUmM6mqLw2MLSz4geIiMJGUEwJWhtZQe0hOZ+t+Ynaskz58nACkFjouLEjHc2dfnm1il0QJzbhIXlyhYMCseBPUfoir5WChgQWcp70qM1nyrJSU+htjgJi+QC38JGSkJV9Pbkl9Y/j74NS9UiB1LsCh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXs7z+0eluo49KPgpCKhRtdav0QO26+dTHQLqvRaNrQ=;
 b=TcedgobuP3my4qyW2UMJs5M/P1SQtCd4ToCJUcTfL0LMV7cJCD4kRtXnzRYsJNKFWtNCFGNndH7bxDWkU2U453RPzIKYuq2tCEDXX960l7/Uy4pORu9iexl1bqBH8bTlRWnXaVpJOTcENr60u9ibkqm3ND/AxKtrcv7zYBatYOOeF4Pg/luW1URMOhylb40X5Xpa7qIle/rDqW8GEatFFIb8GMFn755WCufCHlW9gROW8xuMYvQziHwmhkQhirad9UHIHD+mfcz7ILmUBNzoCiE00dLHaJgGJxx9WolzXCy9tlhBQh5MwgISjYCNcB80kL5o6KuRLM1heTGBDrRJQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXs7z+0eluo49KPgpCKhRtdav0QO26+dTHQLqvRaNrQ=;
 b=mzQkK6UCNGjoDxvjTargFFX0AhnLXEHrxpcP6VHit+x5wtiRDKu+ur4uWXejCt4u80TdaLXI2M8AaJEGwuC5ffZn1pphnAIiAgpgrCyPT5G37gjQMwPv9ta7UDamBlHQ08ab6RHdeC9gnIj7G4ZdngBb7/LvbPoFN1jcHH9mXDQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:23:50 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 16:23:50 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 09/11] qla2xxx: fix mailbox recovery during PCIe error
Thread-Topic: [PATCH 09/11] qla2xxx: fix mailbox recovery during PCIe error
Thread-Index: AQHXH5+tJvQBeg38sEmZeZMKKQSZxKqTVOSA
Date:   Wed, 24 Mar 2021 16:23:50 +0000
Message-ID: <7E8E63CF-388A-4413-8AB6-7C540BDD9435@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-10-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e76be42-b041-46a7-22f1-08d8eee1354a
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2464E7DAB43E99107C2FCB59E6639@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8mrqx8ozjRLbDX6gWwSxvpvYN3JOoAtLfOAC1wN5euFCjaejrt/xdDemTMwv9h5XREAVs26P/xtDU+JC73oZkbOp+HU3EA8FFbD2pwqlSkmJHHWpMjHHJCRMhS9GY0r7fCM0Ue7sJ54zkdL0kV3Kg4vCisa3nvPn6JcOPkODbv7bYOENsKc02KIxzLlwmIyNA3sQ60Oo1CM5bMQEGiTNNbFneF9CRA3kLB3jc3WOt2fsc9J1g/thQUl6Wqa6XWFDzgCGhHgU9RHE2dc4k8ttY6E+6hwPx64aKCkuKZDwfkcjLRt2Y3ysJYw6x7rH2+e08BI90OXkdgujBf3d6ceeAgTyaLcUWOX1wdz/WsDs04kon3LIV+k4fGBODOiSZF0xhuM8PQCuBxFwHCnySExUjeneBl6DlKLuOCeMKbM73nutxlfE8J3Kr2xcCMCSrjQfKYPo3Xan+4+YbAGZE6BNmnBqnbih3hKBBUQhjKzaK6q+NwkGCqP9fZp92ok0EL4MfH966lY9NYE+DNa6RQh4e6O/2/VhU3DC+hT2plsbDw/G7ajsCRCSdzZZCGVnhx46Om3HjFRxzdn1HrHDDN47sfTjElLfXB3PNXlkn4SOqpvS1n/0+ZSKsIYOyjZYh+/uJ7ZJ2AmGt0Z8E/beu/gEvG7sxzdZQE9WDm7ZwHogXm6Fcu0kbHfJwiZFXPtTWGAf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(33656002)(66446008)(4326008)(2616005)(66946007)(8936002)(6486002)(66476007)(38100700001)(66556008)(86362001)(15650500001)(44832011)(83380400001)(64756008)(71200400001)(2906002)(36756003)(54906003)(316002)(6506007)(76116006)(186003)(8676002)(6916009)(478600001)(5660300002)(6512007)(26005)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aTNqSkVuWWkrUHRDQWNHUFVDQndNVXRDTjdaSk82U2pvMEQ4bDY0cWxsYy9q?=
 =?utf-8?B?MFhXbG1vWE9IbTZ2bDVoeGRlcmxQUjFTZWhDWGRvaTIzMVF2YmEyM2RXbG9D?=
 =?utf-8?B?WkxUZVVVT1N6SlIzVnUyWUNOYWlXbWVCb1ZOUmR1YS9YKzc3WmdONFdXZnFo?=
 =?utf-8?B?aDlIK2RUV0Y2R2RIY3JxeGs1bDA4cCtmTFBKMGFPM0NQZTJTWVdqR1JoNEMw?=
 =?utf-8?B?TlJYTlNpQldTOGFHcmJoU3QzZTVrYVlzTXFHUnRlSTRzRC9WSndQWjBxSjhk?=
 =?utf-8?B?b054b0ZROU8zM3VFQy9PY1BkRGROMVlGTCszSW96T0crOWt3OVZnT1hNSmxC?=
 =?utf-8?B?TENQdDNVTlZ0YnlMdVFVTi9vSU5wVXVwR3NFa2VFZW4xMTY1TU40TnpRbFpR?=
 =?utf-8?B?YnFETWhNOVRDZFB4NjdaSno1Nkk5VHc1RmhNTTlRSXZKMEZFeXozUWVFQVJU?=
 =?utf-8?B?Uk9ieDZoN3IxNCt6UTNYU0tQREN1cjIramFISzRtS0RtaVR6bCtKV1dIb1F4?=
 =?utf-8?B?THFhOHZ4MCszSGU1dThDWUpZNFV1bUJIcmdGTXpGdGJ1blJRcE1PcDhBQnR3?=
 =?utf-8?B?b1RHL2h6dVhUZlZsVlpZcG8rQkVEZUNlSHAybllzN1BEdEVTdUZWN3E1K3JQ?=
 =?utf-8?B?WG5MSGJjZCtsT3hFVmVzRHUweTVoZ2NIQ00vai9ETGtsb1R0Slpna1ZRMHFD?=
 =?utf-8?B?RjVTT0gvQkZ1UzBGRyt4ZDVaalNzelFTaUVxZnBjOUROTlFIRlFrU0FaZHdX?=
 =?utf-8?B?aUl4S1k0NWJwNHBBSFl5ek9VdjdmMWRvVE1MSjNmaGs2S2FwTE1OTjR4RjVM?=
 =?utf-8?B?azlPZ2VsZU1WK3RibXlKMCtuc0RFY2hqMkhmYUJwSkwrdjBPUGt4RVFWZVZy?=
 =?utf-8?B?VG11ajdaR29wTlVWcXZtME04VWhHNElod001RGt1Y0Znd2RoTUJaS1pvZkdo?=
 =?utf-8?B?OFljalJQRW9iUzNEaldkWTJibXQxajMxNGMwdkd3Z0tYNXVOczRDMzBoYXlN?=
 =?utf-8?B?V244ZHVOVG8rU1J1N09iOG0wbUY3V2NOY1FiV0o4ODVMckxycVdnUVM0VHB1?=
 =?utf-8?B?S3c5Unc4ZDd1ekt4SU5vNlVqbFJJN2kwZ0wyZVZ5dDB5bmdFSmZncUJWZmJX?=
 =?utf-8?B?ZnI3RVVQWDJScVRiYVQ4NTFPYS9Fc043ZGNSa1FDNGduMU5JenVPZEtrYzdU?=
 =?utf-8?B?MC94Q1dZUU5teVllQjBBT24rRThrTG5CTEJZRXJFdnZSOXUxb0VjQS90aXBn?=
 =?utf-8?B?d2E0aWIzVlJNQUllNlhWYXhtTWJ4L3VPN0MvekRkSjY3VXFodnNpTTMwUlNY?=
 =?utf-8?B?My9QaUxaQU8wNXRvek9XVVZUSE1JWGlGdkZtR25wSldwSWhnVTFCUmRtR012?=
 =?utf-8?B?aHBVZnZRZGVIdlBpeWw2aGJkbStudXJQMnJIQVpuc2hNdE5SbEZZZ1hlclFM?=
 =?utf-8?B?SCtQK0VFRzBRc2dtN01zbFpEYjZGNFVJd09pUVlxcVVDRm41VHNxOTBRV2l0?=
 =?utf-8?B?UTRFNlBSMUViMWVRWGdGVkdPK0oydmFIQWt0UjlicHduR2dHR2FZYThtamVr?=
 =?utf-8?B?YjczSW8vUnBUb3BJeEFLVHdZMkhEUE1VQUdiTW1LMWZmSjVId2NzMWZJTXRS?=
 =?utf-8?B?dDVOQ3dHUnB5STM3ekw1ME41S1Q2dlhVdFdSWi9tWHlMWlFqT1kwTXYzanFK?=
 =?utf-8?B?RHJPV1J1dzZFNzhQYW5WTWdjQ1V1SjF6QW96cXVHRHZlZlF0ODRlSmp3ZkZw?=
 =?utf-8?Q?t8cMl5E3N5kL2bZqk6ZInviafkTXyi5My35Y/b9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E246CAC8F6F4F428C498B78729BF600@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e76be42-b041-46a7-22f1-08d8eee1354a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:23:50.0939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5xvaW8LKfx0dB84iEZMVJPf1YkF6gN32Pku4QJ2l+Kcp8pphz9t/P+KKizIpPhOrq24/qthKgl6FV6eOCnk+NnDNsmbItk+BbNTjMJ8Jn8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gTWFyIDIyLCAyMDIxLCBhdCAxMTo0MiBQTSwgTmlsZXNoIEphdmFsaSA8bmphdmFs
aUBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+IA0KPiBGcm9tOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFy
dmVsbC5jb20+DQo+IA0KPiBGb3IgdGhlIG1haWxib3ggdGhyZWFkIHRoYXQgZW5jb3VudGVyIFBD
SWUgZXJyb3IsIHBhdXNlIHRoYXQNCj4gdGhyZWFkIHVudGlsIFBDSWUgbGluayByZXNldC9yZWNv
dmVyeSBjb21wbGV0ZWQgdG8gcHJldmVudA0KPiB0aGUgdGhyZWFkIGZyb20gcG9zc2libHkgdW5t
YXBwaW5nIGFueSB0eXBlIG9mIERNQSByZXNvdXJjZSB0aGF0IG1pZ2h0DQo+IGJlIGluIHByb2dy
ZXNzIGF0IHRoZSBzYW1lIHRpbWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxx
dXRyYW5AbWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZh
bGlAbWFydmVsbC5jb20+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbWJ4LmMg
fCAzOCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+IDEgZmlsZSBjaGFuZ2Vk
LCAyOSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9tYnguYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9t
YnguYw0KPiBpbmRleCAwMTQ5Zjg0Y2RkOGUuLjNiYzYwMjBjZmI4ZCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21ieC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9tYnguYw0KPiBAQCAtMTAyLDcgKzEwMiw3IEBAIHFsYTJ4MDBfbWFpbGJveF9jb21t
YW5kKHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBtYnhfY21kX3QgKm1jcCkNCj4gCWludAkJcnZhbCwg
aTsNCj4gCXVuc2lnbmVkIGxvbmcgICAgZmxhZ3MgPSAwOw0KPiAJZGV2aWNlX3JlZ190ICpyZWc7
DQo+IC0JdWludDhfdAkJYWJvcnRfYWN0aXZlOw0KPiArCXVpbnQ4X3QJCWFib3J0X2FjdGl2ZSwg
ZWVoX2RlbGF5Ow0KPiAJdWludDhfdAkJaW9fbG9ja19vbjsNCj4gCXVpbnQxNl90CWNvbW1hbmQg
PSAwOw0KPiAJdWludDE2X3QJKmlwdHI7DQo+IEBAIC0xMzYsNyArMTM2LDcgQEAgcWxhMngwMF9t
YWlsYm94X2NvbW1hbmQoc2NzaV9xbGFfaG9zdF90ICp2aGEsIG1ieF9jbWRfdCAqbWNwKQ0KPiAJ
CSAgICAiUENJIGVycm9yLCBleGl0aW5nLlxuIik7DQo+IAkJcmV0dXJuIFFMQV9GVU5DVElPTl9U
SU1FT1VUOw0KPiAJfQ0KPiAtDQo+ICsJZWVoX2RlbGF5ID0gMDsNCj4gCXJlZyA9IGhhLT5pb2Jh
c2U7DQo+IAlpb19sb2NrX29uID0gYmFzZV92aGEtPmZsYWdzLmluaXRfZG9uZTsNCj4gDQo+IEBA
IC0xNTksMTEgKzE1OSwxMCBAQCBxbGEyeDAwX21haWxib3hfY29tbWFuZChzY3NpX3FsYV9ob3N0
X3QgKnZoYSwgbWJ4X2NtZF90ICptY3ApDQo+IAl9DQo+IA0KPiAJLyogY2hlY2sgaWYgSVNQIGFi
b3J0IGlzIGFjdGl2ZSBhbmQgcmV0dXJuIGNtZCB3aXRoIHRpbWVvdXQgKi8NCj4gLQlpZiAoKHRl
c3RfYml0KEFCT1JUX0lTUF9BQ1RJVkUsICZiYXNlX3ZoYS0+ZHBjX2ZsYWdzKSB8fA0KPiAtCSAg
ICB0ZXN0X2JpdChJU1BfQUJPUlRfUkVUUlksICZiYXNlX3ZoYS0+ZHBjX2ZsYWdzKSB8fA0KPiAt
CSAgICB0ZXN0X2JpdChJU1BfQUJPUlRfTkVFREVELCAmYmFzZV92aGEtPmRwY19mbGFncykgfHwN
Cj4gLQkgICAgaGEtPmZsYWdzLmVlaF9idXN5KSAmJg0KPiAtCSAgICAhaXNfcm9tX2NtZChtY3At
Pm1iWzBdKSkgew0KPiArCWlmICgoKHRlc3RfYml0KEFCT1JUX0lTUF9BQ1RJVkUsICZiYXNlX3Zo
YS0+ZHBjX2ZsYWdzKSB8fA0KPiArCSAgICAgIHRlc3RfYml0KElTUF9BQk9SVF9SRVRSWSwgJmJh
c2VfdmhhLT5kcGNfZmxhZ3MpIHx8DQo+ICsJICAgICAgdGVzdF9iaXQoSVNQX0FCT1JUX05FRURF
RCwgJmJhc2VfdmhhLT5kcGNfZmxhZ3MpKSAmJg0KPiArCSAgICAgICFpc19yb21fY21kKG1jcC0+
bWJbMF0pKSB8fCBoYS0+ZmxhZ3MuZWVoX2J1c3kpIHsNCj4gCQlxbF9sb2cocWxfbG9nX2luZm8s
IHZoYSwgMHgxMDA1LA0KPiAJCSAgICAiQ21kIDB4JXggYWJvcnRlZCB3aXRoIHRpbWVvdXQgc2lu
Y2UgSVNQIEFib3J0IGlzIHBlbmRpbmdcbiIsDQo+IAkJICAgIG1jcC0+bWJbMF0pOw0KPiBAQCAt
MTg2LDcgKzE4NSwxMSBAQCBxbGEyeDAwX21haWxib3hfY29tbWFuZChzY3NpX3FsYV9ob3N0X3Qg
KnZoYSwgbWJ4X2NtZF90ICptY3ApDQo+IAkJcmV0dXJuIFFMQV9GVU5DVElPTl9USU1FT1VUOw0K
PiAJfQ0KPiAJYXRvbWljX2RlYygmaGEtPm51bV9wZW5kX21ieF9zdGFnZTEpOw0KPiAtCWlmICho
YS0+ZmxhZ3MucHVyZ2VfbWJveCB8fCBjaGlwX3Jlc2V0ICE9IGhhLT5jaGlwX3Jlc2V0KSB7DQo+
ICsJaWYgKGhhLT5mbGFncy5wdXJnZV9tYm94IHx8IGNoaXBfcmVzZXQgIT0gaGEtPmNoaXBfcmVz
ZXQgfHwNCj4gKwkgICAgaGEtPmZsYWdzLmVlaF9idXN5KSB7DQo+ICsJCXFsX2xvZyhxbF9sb2df
d2FybiwgdmhhLCAweGQwMzUsDQo+ICsJCSAgICAgICAiRXJyb3IgZGV0ZWN0ZWQ6IHB1cmdlWyVk
XSBlZWhbJWRdIGNtZD0weCV4LCBFeGl0aW5nLlxuIiwNCj4gKwkJICAgICAgIGhhLT5mbGFncy5w
dXJnZV9tYm94LCBoYS0+ZmxhZ3MuZWVoX2J1c3ksIG1jcC0+bWJbMF0pOw0KPiAJCXJ2YWwgPSBR
TEFfQUJPUlRFRDsNCj4gCQlnb3RvIHByZW1hdHVyZV9leGl0Ow0KPiAJfQ0KPiBAQCAtMjY2LDYg
KzI2OSw4IEBAIHFsYTJ4MDBfbWFpbGJveF9jb21tYW5kKHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBt
YnhfY21kX3QgKm1jcCkNCj4gCQlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmaGEt
Pm1ieF9pbnRyX2NvbXAsDQo+IAkJICAgIG1jcC0+dG92ICogSFopKSB7DQo+IAkJCWlmIChjaGlw
X3Jlc2V0ICE9IGhhLT5jaGlwX3Jlc2V0KSB7DQo+ICsJCQkJZWVoX2RlbGF5ID0gaGEtPmZsYWdz
LmVlaF9idXN5ID8gMSA6IDA7DQo+ICsNCj4gCQkJCXNwaW5fbG9ja19pcnFzYXZlKCZoYS0+aGFy
ZHdhcmVfbG9jaywgZmxhZ3MpOw0KPiAJCQkJaGEtPmZsYWdzLm1ib3hfYnVzeSA9IDA7DQo+IAkJ
CQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYS0+aGFyZHdhcmVfbG9jaywNCj4gQEAgLTI4Myw2
ICsyODgsOCBAQCBxbGEyeDAwX21haWxib3hfY29tbWFuZChzY3NpX3FsYV9ob3N0X3QgKnZoYSwg
bWJ4X2NtZF90ICptY3ApDQo+IA0KPiAJCX0gZWxzZSBpZiAoaGEtPmZsYWdzLnB1cmdlX21ib3gg
fHwNCj4gCQkgICAgY2hpcF9yZXNldCAhPSBoYS0+Y2hpcF9yZXNldCkgew0KPiArCQkJZWVoX2Rl
bGF5ID0gaGEtPmZsYWdzLmVlaF9idXN5ID8gMSA6IDA7DQo+ICsNCj4gCQkJc3Bpbl9sb2NrX2ly
cXNhdmUoJmhhLT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7DQo+IAkJCWhhLT5mbGFncy5tYm94X2J1
c3kgPSAwOw0KPiAJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYS0+aGFyZHdhcmVfbG9jaywg
ZmxhZ3MpOw0KPiBAQCAtMzI0LDYgKzMzMSw4IEBAIHFsYTJ4MDBfbWFpbGJveF9jb21tYW5kKHNj
c2lfcWxhX2hvc3RfdCAqdmhhLCBtYnhfY21kX3QgKm1jcCkNCj4gCQl3aGlsZSAoIWhhLT5mbGFn
cy5tYm94X2ludCkgew0KPiAJCQlpZiAoaGEtPmZsYWdzLnB1cmdlX21ib3ggfHwNCj4gCQkJICAg
IGNoaXBfcmVzZXQgIT0gaGEtPmNoaXBfcmVzZXQpIHsNCj4gKwkJCQllZWhfZGVsYXkgPSBoYS0+
ZmxhZ3MuZWVoX2J1c3kgPyAxIDogMDsNCj4gKw0KPiAJCQkJc3Bpbl9sb2NrX2lycXNhdmUoJmhh
LT5oYXJkd2FyZV9sb2NrLCBmbGFncyk7DQo+IAkJCQloYS0+ZmxhZ3MubWJveF9idXN5ID0gMDsN
Cj4gCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhhLT5oYXJkd2FyZV9sb2NrLA0KPiBAQCAt
NTMyLDcgKzU0MSw4IEBAIHFsYTJ4MDBfbWFpbGJveF9jb21tYW5kKHNjc2lfcWxhX2hvc3RfdCAq
dmhhLCBtYnhfY21kX3QgKm1jcCkNCj4gCQkJCWNsZWFyX2JpdChJU1BfQUJPUlRfTkVFREVELCAm
dmhhLT5kcGNfZmxhZ3MpOw0KPiAJCQkJLyogQWxsb3cgbmV4dCBtYnggY21kIHRvIGNvbWUgaW4u
ICovDQo+IAkJCQljb21wbGV0ZSgmaGEtPm1ieF9jbWRfY29tcCk7DQo+IC0JCQkJaWYgKGhhLT5p
c3Bfb3BzLT5hYm9ydF9pc3AodmhhKSkgew0KPiArCQkJCWlmIChoYS0+aXNwX29wcy0+YWJvcnRf
aXNwKHZoYSkgJiYNCj4gKwkJCQkgICAgIWhhLT5mbGFncy5lZWhfYnVzeSkgew0KPiAJCQkJCS8q
IEZhaWxlZC4gcmV0cnkgbGF0ZXIuICovDQo+IAkJCQkJc2V0X2JpdChJU1BfQUJPUlRfTkVFREVE
LA0KPiAJCQkJCSAgICAmdmhhLT5kcGNfZmxhZ3MpOw0KPiBAQCAtNTg1LDYgKzU5NSwxNiBAQCBx
bGEyeDAwX21haWxib3hfY29tbWFuZChzY3NpX3FsYV9ob3N0X3QgKnZoYSwgbWJ4X2NtZF90ICpt
Y3ApDQo+IAkJcWxfZGJnKHFsX2RiZ19tYngsIGJhc2VfdmhhLCAweDEwMjEsICJEb25lICVzLlxu
IiwgX19mdW5jX18pOw0KPiAJfQ0KPiANCj4gKwlpID0gNTAwOw0KPiArCXdoaWxlIChpICYmIGVl
aF9kZWxheSAmJiAoaGEtPnBjaV9lcnJvcl9zdGF0ZSA8IFFMQV9QQ0lfU0xPVF9SRVNFVCkpIHsN
Cj4gKwkJLyogVGhlIGNhbGxlciBvZiB0aGlzIG1haWxib3ggZW5jb3VudGVyIHBjaSBlcnJvci4N
Cj4gKwkJICogSG9sZCB0aGUgdGhyZWFkIHVudGlsIFBDSUUgbGluayByZXNldCBjb21wbGV0ZSB0
byBtYWtlDQo+ICsJCSAqIHN1cmUgY2FsbGVyIGRvZXMgbm90IHVubWFwIGRtYSB3aGlsZSByZWNv
dmVyeSBpcw0KPiArCQkgKiBpbiBwcm9ncmVzcy4NCj4gKwkJICovDQoNClNtYWxsIG5pdOKApi4g
Rml4IGNvbW1lbnQgZm9ybWF0dGluZyBmb3IgbXVsdGkgbGluZS4NCg0KPiArCQltc2xlZXAoMSk7
DQo+ICsJCWktLTsNCj4gKwl9DQo+IAlyZXR1cm4gcnZhbDsNCj4gfQ0KPiANCj4gLS0gDQo+IDIu
MTkuMC5yYzANCj4gDQoNCkNvZGUgaXRzZWxmIGxvb2tzIGdvb2QuIEFmdGVyIGZpeGluZyBjb21t
ZW50IHlvdSBjYW4gYWRkDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNo
dS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGlu
dXggRW5naW5lZXJpbmcNCg0K
