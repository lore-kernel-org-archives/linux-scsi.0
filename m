Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BF4C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5540960E53
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbhHEPZa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:25:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58488 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242233AbhHEPZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:25:10 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FDrXc026486;
        Thu, 5 Aug 2021 15:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aynKReO00nEK+JtMgSs5DOfy8YufB/6jl3vW0KWp8VE=;
 b=tvE1WOtpsRaPD/X+uADB0BH8zsHAbf3eVvaQ51XV7tvTHx5n3By9KU+EWAy83icEGNbh
 LsduUmcn/ysw4Oy6PW8a+YCxrB1d92axbsAJXj9NqL9ahNH6yFO34xl8UgsJs6+ZPP8a
 F7vrAqrBv2k5pmKN+tJjnPYFkbch1Jcyh4bvcCrpINtawV3I7abRNec7+EHF12/bj9g+
 aeIRmsxowi/OlnOUkCIkz/tm8TdVsXmJaa4rKZpkKo9myE+TdMS7HFwb+Gq9pVdNZm/V
 MRb0rRZh++jr6xeLuKszPHGJmvRf54+zsW6m+f4FKD+wkP6d4uCTTqXDvrFVriknJYNd zA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aynKReO00nEK+JtMgSs5DOfy8YufB/6jl3vW0KWp8VE=;
 b=QGGl+0dcrx9ITfDbxaQXxzDAZ12qX9k3fvGJ7tTX0RnM2r+5ONmqfi8+ttKoimhHTQQZ
 hWqw7PjcpcaQcKlHHSao28XYJT0T7GnmzY0cWCy+P6ZOVpG9Cwdsk7lBfDyVPkEdr2C5
 8X5XQEfO64nfnHwCO6MHTLHMEgURdfLF2ScBkaVn0RobYTOXZWPdTyMxjJgGyFiR16Ps
 xC+qofYjUlDH5kutWBY1Bxacxr94QnnUJ9VPBpndoeWGWqpKD03y0AlBdB00EmA5LcMH
 kDb8BBbAYh7dHZgoaPzXrUAX5qmFi++kg+d7uYhxtd0Mrmudk7Zzscltz4oj9MxEMR2A dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0d1vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:24:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FFb75114252;
        Thu, 5 Aug 2021 15:24:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3a4un3y4tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFNiMx0z+9qL7Mh7nhZGD0zXeys44GsecSAP40ktxpMTojvWlefrT9ZutB+unAwk+I/uO6Od2UzaUKN63q0KRTRJ7RZrwBORslL3YHK31t6tkukqPNXfCOV/5hR3s2jo+gqkTGeIFXzFi617z2TEu6jYuuAkbdzVzO+gdDH5aTXNahRT2zoM3+Zi2DBdRCV9YjspHgESI51j1+hbcSGOU1nc5PTQT+3YSRnQLFloih/hM+omlnZCxHpm8PevCkHKOYd9PQBCIl4iDTeO6TTkMrFUfGq1hS8vXzENEqpm073v980hIm70b9nDo4gouaBIDIJHubJtt+buKC82y87Kyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aynKReO00nEK+JtMgSs5DOfy8YufB/6jl3vW0KWp8VE=;
 b=Lt5YpPectO9IRQwbMQke5t+bnc64BwlbDeAvbfz+VI3XNv1qLfozm8K4pgFVachVTQNEsKHPhzA/nuknC9k9GXTbP1HOBRpmc1JSRJ3zNrAtmCpwRkKOS2VnHtDThKJx6cA698v+udHc7UeQaSU1P/AxpWp99NCB3vidKw1aPyhNdcKSDbyWMcKxmKUeO6uKfGJ9b9KFFl4S4Kdg3heBfJkyW3QYFoZSO/hcWG4LYzVpk7q3gAJAgHBJevP8x+3PHRZ1PgOS/uTN5emzUhn/rk1z6srWHkYRC52pOX68+SlMs/NvaowIeBL7JpMDL9joOMro0KeBgQJ48hqXI1KSog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aynKReO00nEK+JtMgSs5DOfy8YufB/6jl3vW0KWp8VE=;
 b=bU0mGQo/8zsE/lRVpMd+wj8HjrVKtJMgtbynlIDC8VCbVl4buG3LI9iuyn1wsiJq80q++2d2i9TWuqdQE9k1wzpYHqoTOtUkeJW7xmEb2hHK4db0//cJl251yqCYAqXK1bE9PhZbOsK0PjmoD3R+wU6elaVvdFsEOqMkTOYitsg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 15:24:51 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:24:51 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 04/14] qla2xxx: Changes to support FCP2 Target
Thread-Topic: [PATCH 04/14] qla2xxx: Changes to support FCP2 Target
Thread-Index: AQHXiePFONkNyB37lUm84tjkBPOJ4KtlCEmA
Date:   Thu, 5 Aug 2021 15:24:51 +0000
Message-ID: <90174B55-43DC-4281-9282-FA6726356373@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-5-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c52fe381-ce45-4307-bbc1-08d958252b64
x-ms-traffictypediagnostic: SA2PR10MB4508:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45082940FC2136BC6237C39AE6F29@SA2PR10MB4508.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WFWWU3fDu0FHZqSopFTRn6MNA0LFRWQ1GHQbP47ypaEkMjVqAfhrHW/kzkkVuB9NGTzWiij4fLOTpH6KOs4p6LS0NFj42SwGcrQIz5CF/s0d8PGbFGoy11xo4ciExaFwPatSNWEbEXSaFDG2geKZNS6PGtOGZrrLCgyJ3PzAmw1FB5ZhjWI1At6Ruf3g90b88+hWbsFWMz5Ow6pOvGm0Fpx3qqQQlvtpT1FxYw+l1LEizIgh5r/QhwYplGznysPzg7HbyBqJm9uiuBDdUSFe9pBaDJ/ARz0RQKxr/eGNvIzEKmA0SYv6/B9kuFd1YfIPcC9esxS8jpGjbCv4ZEERoH1lhd6Mo+vXc12uQBuaW9RnP1r5zBXuKNSJeLgRq0baLFVstCzxtss47kp8vDsm6PLYpCehbdJy/9IJMmDQmXeNYYgsZ3NIcRpvJ+S63KvmunJ4/CjZ+MRpZ3aRHmI64h9pytj/BsPeMmQd38RGAfSjiw/JNRqMga+tzRdVB8V/J+yjcK14Ed4PvlaBYC+7ZEojifNdDc7mep+TpGOzNWlcqcRgdkQEnvOzlnAc6ookX4JjaxEulFFvxThQefDtXfQL/XAkpBHbZrwbgpEhK4ktf5ZZY0NTqUDZxxbivPkSpxdYZEiYKtEwOf4JX0L9rdflXz/bNbFvtdGBpoiQ3WFvJ6Kxwx+jEvD6zq/OxNjQ+yyJkP1jDmU/l0qFayqE7DPR2bv2MHbAxC6OtBdwD04=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(39860400002)(376002)(366004)(53546011)(316002)(71200400001)(6486002)(6506007)(26005)(186003)(6916009)(4326008)(66446008)(66946007)(66476007)(478600001)(76116006)(64756008)(38070700005)(36756003)(44832011)(33656002)(54906003)(6512007)(66556008)(5660300002)(2616005)(8936002)(86362001)(38100700002)(83380400001)(122000001)(8676002)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym9zQkdRR2NBTUhUT1FqZGYxZ1M1b0Y5YnhFUGJiN2t4QWJ4UWx6M1pFUmZX?=
 =?utf-8?B?NjhvQlZUYUNuTmFRS0ZmWktaMGRqQ3FzemwvaXpJQTMvY0k1bFM1bUtPVDl1?=
 =?utf-8?B?VndLZUVPUCtab1NxM0RYZzJVVnU5WmJmMVBseVFQU2pwV01UR1VwRDJMSXR0?=
 =?utf-8?B?cWFtQ05pQWZZU2V2SEFEQWpCR21xTkpkTU1MV3NNTWNIcjVzNTVHR0I1bFQ2?=
 =?utf-8?B?aDhKVy9uVjJGOWZ1ZjBCVW1xSXVmcEcvQ1hmYXRiQkluUzcwdWdhWmdkZ0Zu?=
 =?utf-8?B?aGFjcjBvSFFYZXZMdTFkS2JjckU4a1NqK3FrS3Vkc1dwNHAxaHRGOEwvSlM3?=
 =?utf-8?B?THVKbEF0SHJHcktkSnIvR2lDcWVkQi94RFh4Q3VTSlo2SWtvZEVjU1dRc1FB?=
 =?utf-8?B?MU5JejJEZEpMdzlpMzZvTzJ6bHlhR0NrclpKdmxVekRjYjhSOXp4ajlDeXZm?=
 =?utf-8?B?eWJrbVVOcUxwTnZmOHZ1d0ttVUFpeDN3ZlQxS2dPZm5jMmFxNXp5YUFzbEVU?=
 =?utf-8?B?UW45UkMxemtWaUNXM1dxam1IRUNXN0tqMjQyNzZsV2pvL1ltSHpkMnp3N3hV?=
 =?utf-8?B?L1hXbGN4OG91dzducVJ6VUNMWmgzM0IxbUljR05IRDI5VXAyK3Bja05UcTR5?=
 =?utf-8?B?REZJQ3NySWxXbTBZaDA2TmVYWlI1ZFNBaDdlcHpxZWxDOVgxN3FydWxrc1hv?=
 =?utf-8?B?U0REemVZNFZhRktmZUd3T1JUVFZjVFlyaVNqTWxHRDNHMHA2c0pYVDFRSE5W?=
 =?utf-8?B?Z2hWTksvanlGanRVeHl6Q0VHQUFyNVhhV1NlL2ZTNnlWd04zK3hXcnF1SW85?=
 =?utf-8?B?cjlkblBDUTJXOTRncGpRTmVnYTJFS0xoNGdlNHB3ZWlZRGdtRUlFa3NYNmFn?=
 =?utf-8?B?NnI3QVZISGJ0c0trSG56RXlxVGFxbnlCallVN1o5ZEJDRk9WN1lMMU9qeVRV?=
 =?utf-8?B?QzdnUkJOUzFRVHByak1GeGhxQjdFSXNxQ0JaWkhYd1JpUGlGMTQzNmdtc015?=
 =?utf-8?B?anR4ZjVzUVZwejZLczJ3aWlscklnVjg4UWNNNjU1enhzQkh0WDFxbTZWZFcr?=
 =?utf-8?B?K1lPcksvdlJ0UEJDVktWWU1JTisrQklHOHpzcnZKRFI0ZTh5WnB4MXQyY2pr?=
 =?utf-8?B?aFphT2lKSy9EODJWdVppOG1xbnBBNXJjaGtzeFNrMGM4MmJhZTBGNDNrYnVM?=
 =?utf-8?B?eEtxNWh6a2V1T0VVRWFaN3hHSDBTSEY3OTNzeU8vcStWY1YrVEN0Mi93OTdV?=
 =?utf-8?B?cWlBZ2g3a2RhTlhua1BtVWNhQ1NwOHFjOS9rUTZwOHFCeCsvMlp5c3hNN0hG?=
 =?utf-8?B?NXBWNk8vVjZ3Z0J3SDVySVFKMDY4TzlBR3o0RCt2UEM5aG96cHBVNUFWc1Nt?=
 =?utf-8?B?d1JVQ3libUV2ODFXSG41SnFGQVFLTmtVYUM3bUlrNUF3b0UyVHZhZjlham16?=
 =?utf-8?B?L3JsV2hWWTZrWERPTjhUZHBVaEcwUVZzQmdyVHRsY3VKbFdER0NQaW43N3Aw?=
 =?utf-8?B?bmdnUXR4U0thRjc1YTcydGsxaE5JenFwb1hjWWp4a2JYNFowaUlDanRNbWwx?=
 =?utf-8?B?dVFGUzRBTE9MOCtsdzZrdld6TlgyR2w3b3NKa2VNK0s4QkdMNUoxNWdPYTdw?=
 =?utf-8?B?WGM1aFBtbE1MdXJWeGJQRDNLNXlPbzdjb09adnJJZnFESllSWFQ3aWhTNUR4?=
 =?utf-8?B?S3RNZUZGMjdDRkVqQ1dNRE5NWVlIK2JHRElkQ3R4cmJ2S082RkZiMWZxUk1r?=
 =?utf-8?Q?eSUiK/9tbvZ96EHt3FKNszekFRH4qUQqb+w/8gm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A05796BD8F9C4409610935F4946A2C7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52fe381-ce45-4307-bbc1-08d958252b64
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:24:51.3832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 517QpvVFCZTSJVnIU8MFwwpjrEfcc1foN360KIrj+IhWxIsnewVR14D8Rk4JMlI4mSDNqgMv8hhbZjMdTA0iO+oLI8LCHIhW3/T1N6bZobA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050093
X-Proofpoint-ORIG-GUID: zAzxgtJiRS3k9NZKx3wfn1EQxqCuEEL3
X-Proofpoint-GUID: zAzxgtJiRS3k9NZKx3wfn1EQxqCuEEL3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gQXVnIDUsIDIwMjEsIGF0IDU6MTkgQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFw
QG1hcnZlbGwuY29tPg0KPiANCj4gQWRkIGNoYW5nZXMgdG8gc3VwcG9ydCBGQ1AyIFRhcmdldC4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNhdXJhdiBLYXNoeWFwIDxza2FzaHlhcEBtYXJ2ZWxsLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4N
Cj4gLS0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kYmcuYyAgfCAgMyArLS0NCj4gZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyB8ICA2ICsrKysrKw0KPiBkcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfb3MuYyAgIHwgMTEgKysrKysrKysrKysNCj4gMyBmaWxlcyBjaGFuZ2VkLCAx
OCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9kYmcuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kYmcu
Yw0KPiBpbmRleCBmMmQwNTU5MmMxZTIuLjI1NTQ5YThhMmQ3MiAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RiZy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9kYmcuYw0KPiBAQCAtMTIsOCArMTIsNyBAQA0KPiAgKiAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAq
IHwgTW9kdWxlIEluaXQgYW5kIFByb2JlICAgICAgICB8ICAgICAgIDB4MDE5OSAgICAgICB8ICAg
ICAgICAgICAgICAgIHwNCj4gICogfCBNYWlsYm94IGNvbW1hbmRzICAgICAgICAgICAgIHwgICAg
ICAgMHgxMjA2ICAgICAgIHwgMHgxMWE1LTB4MTFmZgl8DQo+IC0gKiB8IERldmljZSBEaXNjb3Zl
cnkgICAgICAgICAgICAgfCAgICAgICAweDIxMzQgICAgICAgfCAweDIxMGUtMHgyMTE2ICB8DQo+
IC0gKiB8CQkJCSAgfCAJCSAgICAgICB8IDB4MjExYSAgICAgICAgIHwNCj4gKyAqIHwgRGV2aWNl
IERpc2NvdmVyeSAgICAgICAgICAgICB8ICAgICAgIDB4MjEzNCAgICAgICB8IDB4MjEwZS0weDIx
MTUgIHwNCj4gICogfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAg
ICAgICAgIHwgMHgyMTFjLTB4MjEyOCAgfA0KPiAgKiB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICAgICAgICAgfCAweDIxMmMtMHgyMTM0ICB8DQo+ICAqIHwgUXVl
dWUgQ29tbWFuZCBhbmQgSU8gdHJhY2luZyB8ICAgICAgIDB4MzA3NCAgICAgICB8IDB4MzAwYiAg
ICAgICAgIHwNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQo+IGluZGV4IDI0NjgzYWMxYTYyMC4u
YmUwOWRjNGIzYmYyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5p
dC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gQEAgLTE3ODcs
NiArMTc4NywxMiBAQCB2b2lkIHFsYTJ4MDBfaGFuZGxlX3JzY24oc2NzaV9xbGFfaG9zdF90ICp2
aGEsIHN0cnVjdCBldmVudF9hcmcgKmVhKQ0KPiANCj4gCWZjcG9ydCA9IHFsYTJ4MDBfZmluZF9m
Y3BvcnRfYnlfbnBvcnRpZCh2aGEsICZlYS0+aWQsIDEpOw0KPiAJaWYgKGZjcG9ydCkgew0KPiAr
CQlpZiAoZmNwb3J0LT5mbGFncyAmIEZDRl9GQ1AyX0RFVklDRSkgew0KPiArCQkJcWxfZGJnKHFs
X2RiZ19kaXNjLCB2aGEsIDB4MjExNSwNCj4gKwkJCSAgICAgICAiRGVsYXlpbmcgc2Vzc2lvbiBk
ZWxldGUgZm9yIEZDUDIgcG9ydGlkPSUwNnggIg0KPiArCQkJICAgICAgICIlOHBoQyAiLCBmY3Bv
cnQtPmRfaWQuYjI0LCBmY3BvcnQtPnBvcnRfbmFtZSk7DQoNCkRvIG5vdCBzcGxpdCBMb2cgbWVz
c2FnZSBhY3Jvc3MgbGluZXPigKYNCg0KPiArCQkJcmV0dXJuOw0KPiArCQl9DQo+IAkJZmNwb3J0
LT5zY2FuX25lZWRlZCA9IDE7DQo+IAkJZmNwb3J0LT5yc2NuX2dlbisrOw0KPiAJfQ0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgYi9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfb3MuYw0KPiBpbmRleCA5MjFiZDRkMTI3ZjQuLjYxYWU4Y2JiYTY3MCAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCj4gKysrIGIvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX29zLmMNCj4gQEAgLTM5ODEsNiArMzk4MSwxNyBAQCBxbGEyeDAwX21h
cmtfYWxsX2RldmljZXNfbG9zdChzY3NpX3FsYV9ob3N0X3QgKnZoYSkNCj4gCSAgICAiTWFyayBh
bGwgZGV2IGxvc3RcbiIpOw0KPiANCj4gCWxpc3RfZm9yX2VhY2hfZW50cnkoZmNwb3J0LCAmdmhh
LT52cF9mY3BvcnRzLCBsaXN0KSB7DQo+ICsJCWlmIChmY3BvcnQtPmxvb3BfaWQgIT0gRkNfTk9f
TE9PUF9JRCAmJg0KPiArCQkgICAgKGZjcG9ydC0+ZmxhZ3MgJiBGQ0ZfRkNQMl9ERVZJQ0UpICYm
DQo+ICsJCSAgICBmY3BvcnQtPnBvcnRfdHlwZSA9PSBGQ1RfVEFSR0VUICYmDQo+ICsJCSAgICAh
cWxhMngwMF9yZXNldF9hY3RpdmUodmhhKSkgew0KPiArCQkJcWxfZGJnKHFsX2RiZ19kaXNjLCB2
aGEsIDB4MjExYSwNCj4gKwkJCSAgICAgICAiRGVsYXlpbmcgc2Vzc2lvbiBkZWxldGUgZm9yIEZD
UDIgZmxhZ3MgMHgleCAiDQo+ICsJCQkgICAgICAgInBvcnRfdHlwZSA9IDB4JXggcG9ydF9pZD0l
MDZ4ICVwaEMiLCBmY3BvcnQtPmZsYWdzLA0KDQpEaXR0byBoZXJlLi4gbm8gbmVlZCB0byBzcGxp
dCBsb2cgbWVzc2FnZSANCg0KPiArCQkJICAgICAgIGZjcG9ydC0+cG9ydF90eXBlLCBmY3BvcnQt
PmRfaWQuYjI0LA0KPiArCQkJICAgICAgIGZjcG9ydC0+cG9ydF9uYW1lKTsNCj4gKwkJCWNvbnRp
bnVlOw0KPiArCQl9DQo+IAkJZmNwb3J0LT5zY2FuX3N0YXRlID0gMDsNCj4gCQlxbHRfc2NoZWR1
bGVfc2Vzc19mb3JfZGVsZXRpb24oZmNwb3J0KTsNCj4gCX0NCj4gLS0gDQo+IDIuMTkuMC5yYzAN
Cj4gDQoNCk9uY2UgeW91IGZpeCBpdC4uIHlvdSBjYW4gYWRkDQoNClJldmlld2VkLWJ5OiBIaW1h
bnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNo
dSBNYWRoYW5pCSBPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCg0K
