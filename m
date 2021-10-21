Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36DEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1E360F50
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhJUOiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:38:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54822 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:38:01 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYVbC000664;
        Thu, 21 Oct 2021 14:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IiIFoRNX6qj/u66TFmcDQFdZefEkYBdAp2/67KllIQ0=;
 b=V+X1lZcciBT8uROyCx3VvAzgkH/x8Ygi0fHlelmGTZITGl7WQU4fFlUbfE+v6tyKSYJE
 RoP5muKeONVySja206J5+iAh4VCcToKZcsD4nDbEdUHUoIBIK2YTlIHAgLt0dhBFUrXd
 u+3B2fsCv0Z1U6IX4AWAdYqSAx1kcTwSWSGc3tmHrGrfDVGVD3vnnCQGR79+5+13qXV1
 z5saDdM09dICPn7hC3XQeTGleUcZOQYHeNCjwKRSk7W9Az4+2hQVBrBTc1wHGthePgvG
 B6UXZilBHgMvlDDVAPb1shYAFcr/xWDeBPxd2odCzVYHa20XeevCeup6CTH4g9BJk1SE WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypnj1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:35:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZcbY129905;
        Thu, 21 Oct 2021 14:35:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3020.oracle.com with ESMTP id 3br8gw4k99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEFSPY8h/LQHeLxmrB52IDk6/kSH2osE7STXESXHv/WXyn15z6WDoKNXzQN4ZVeRoTASfJKmqKzwHD2If66LvkQIrbRcYrvpRg75rz1eq4dyaNLz/XxPjilJjGL2+w/4wBentZKwG4oBWmCg848ota3dvOwEBN3FJMC7EacgtZ5N2+iPaQt6KBeaRTW9lVc/W/Oxew9G87asOh97AyWpiZ8MgASm++GDikrKIwuaAdA9uWRjW+Ifqys3Lqt+YI+KJQP/A00jiP049x4+N6RQT53kwebBsRDWZIVZ2UcA6XH+vL+TzLFC0y1UyiVZ40zQ+QoDL5AptL1nNLqSfsDBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiIFoRNX6qj/u66TFmcDQFdZefEkYBdAp2/67KllIQ0=;
 b=mI9mas4hXbeN9aOvjbKbV3e940baDe1lH+zr3R/TrhdpAETJcixyWLMoZROudTOOeKe6qEC4in6ovSXS38fQMfBwZvPB+FKEn2Q010J0asN/SZIGEaeTyazbP9v7Fw21uXKbyK2miHY8fMdkPebsI3a1ZvAhc3cafNgeG+asR1G1etGprUvGs7CdDy7twp25Fb836XghZBk1fPHlU/YkXf4VJsw0naRpd2u01J2ILyM35g52KnD/WW51GKW5zSdenP4BgWbIBjLNeDco9BHwntdy/gp3DY8BM+hEtJPUzYxYCvzA/QrL/GhrVSPL8H9Qoxzt3JUy6TQpe1U7jEReGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiIFoRNX6qj/u66TFmcDQFdZefEkYBdAp2/67KllIQ0=;
 b=QqKSXlhb6tjS2KJ6kVyl/Q5rBDhVPu1ECzQsRlAuf0zCmDuWGPcYKeD9jLswppz2Zr8dyjVIYvAihpujgobLEyhqGKvGwu3SSx6nS14/ftYjThsbboW2c9MeRHtQGqnA7zr/TpI1bgGfAzPnvCBT11LjsTuM6G/+8LaZZpKr9bk=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB2771.namprd10.prod.outlook.com (2603:10b6:208:7b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:35:38 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:35:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 08/13] qla2xxx: edif: tweak trace message
Thread-Topic: [PATCH v2 08/13] qla2xxx: edif: tweak trace message
Thread-Index: AQHXxk3VS1Cbox/uz0miCXOLKtj4JKvdhTeA
Date:   Thu, 21 Oct 2021 14:35:37 +0000
Message-ID: <9E93BFE1-0583-46EF-A38C-45CA055A1E7E@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-9-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8054fb23-70c8-4609-c955-08d994a00cc0
x-ms-traffictypediagnostic: BL0PR10MB2771:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR10MB2771E6088FA471691702F807E6BF9@BL0PR10MB2771.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:12;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kgrn4tvgi5mPaMRcZF258AboyPOXsZFbu1EbLI4xI8iGnuI7ViQzTaMqP8obyUhT0lSOY7yCajc3lHaDBnzq2N3eAINpBwDqz36r1o1Qw9WUYw3uB4ouSfziPEiiTChoRoSiGDOyjpuzjRP/xRmjF53ZrO0a/IBFYLbgJgAIQAatChu473iKsrLxO651ulTCJc811MV9dvdYozl9oiMNrL41l8/598557SpcNrT/UAmMZj/p6zD8oaLbl4o0T77v//e97FJUjblXBaRqQn71wLAdFCYyHuoDc3vXVXccxugiKUdN81GMiBiVSu02HcKSLsPuaFlYvXFUno+vfmHocT+sxTrHRYGnPW+lS+luB7RxJr4x063WK7B/72GerWve4QsNJSPDNfXZfZYEsxrwNb8qvrblRUoSKdIUNik1YbvT6pwQHq7vz9B3IGjkIXzUTuksPYCClpRRkvtUKUqBnTkRMnXIGA/ReEegZWPsnP81I+FoB7CMhH/6LZ+983ongki8y7RZu5ogx7ylAwCR4k3sciXMYnzf+KA3H7zSuPD56XJCcrVUHiFnQ+bU8+rzYqon2r5ph94WzCGktMlBaAZsVimJ8j1ivv2rW1Q9wwisuKKv/c7TLT2gkMGZSQ58b+pH6Ivr4EYF5fjj6Ee5/zFdwl4reIDfCOhW7bqkRUmARKgWPjvQSVGeYrnvF/A/N94yIBcra2jcexZHofGFoza3OqoMQd+UVE647ALB3BU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(71200400001)(54906003)(33656002)(64756008)(44832011)(186003)(26005)(66476007)(6512007)(91956017)(66556008)(66946007)(66446008)(53546011)(6506007)(36756003)(38100700002)(122000001)(76116006)(15650500001)(83380400001)(86362001)(6486002)(8676002)(4326008)(6916009)(508600001)(316002)(2906002)(8936002)(38070700005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0IxQnIvbG9yZG1MRFl5MGx5SUh3ZlNBTGc1VDR2NjVQdSs4V3plR0plNmJq?=
 =?utf-8?B?aXR0Si9OZGk1ZDVxYVhRUEY2QStudW9xdUZSQUNoTVp4TXhYcTJVdWVFaVQr?=
 =?utf-8?B?akNkWUhZeUdWQlpmSVdkV3hQTkZJN0xkRjNSQlpmK3BCYjdRK1Nva1c2aVNW?=
 =?utf-8?B?Y01tNUoxMW1SQ2RBR09iVHRxcDFSMjJKVzRXTTdEUTllVkVUS0paQlFhclJ4?=
 =?utf-8?B?TGZrNjF2VHdnNEVRcHBtbDh4YUg3ZjFBL3FXK2kxSUhwdnltdG1MODRQcSto?=
 =?utf-8?B?N3haNHcvRkNzSGxjckN6OGR3L1ZhUi9BL3N5QzZiWlNISnJnOWsyeWdOcUxD?=
 =?utf-8?B?eXN6Zmp4RE9vd1AwdjRlUVNHOHErb2tkZDhsaEtwUzd5UlhnaW1jWG82SWs0?=
 =?utf-8?B?bzNmWk1kTmx3ZlZpblYxb3lUWFNxcnppTVV0WHBhNHN0QWlPOFRXaVN1aEhK?=
 =?utf-8?B?NjlKb2l0Vnh1Nmk1S1NOVGo4UGx0WGFNU3FrdGxjVDZ4d1JHMUw4aU54djZ3?=
 =?utf-8?B?b0taNGtUcEVvRFNRcnpJTC9jeFB2TGlPOVA4NEhleEgycWlSUVB6eGVjcjNt?=
 =?utf-8?B?c3NHWC91K1k0ZU9RRnczY3dzd3VWYy9ZZkk2ZGxxSVBuZ1ZYNmM5MTVncGtz?=
 =?utf-8?B?UVhZV0h1S0V2bjJXK1BDV1FHQWkxY1JHQXFTMHZGWVduZUZZT0s1dnhzcE0v?=
 =?utf-8?B?N09FVmNzKy9xakhHZjVFNnkwK3h3NE5zV0xRV2gzUDFrTjFNOG5mUFJ3VU90?=
 =?utf-8?B?ZWhNcDBXRmFmM1g2WjBwMEI3aGZiN1p1QlJ3bENENEkzVFgwN20zdThORDQx?=
 =?utf-8?B?WnNhNmw2TXdIcWVCeVM1ekJCeTIzbDdDcVNCTHNwMnhHdndrQ3lEajl1Y3gv?=
 =?utf-8?B?YlN5UXR1c2ZSUU1YaVFzenB6aGxER1VJTUpDV2pFc1BsWUVZaDhVbG5ieDda?=
 =?utf-8?B?c2paaWxhQmNiWnhUMHMyeFpVNDhRWVpCM3YrdU9Qb1lqckcxaHdqV1JGazBC?=
 =?utf-8?B?L1BBMVpFZ2pyQU56cTNUV3llaHlVblZ2SEF3dTlvVFh2SW1rQTdocTlKMmlJ?=
 =?utf-8?B?VjVZRWtFeDEzaEFIQjg2TjBsWXZMNm8zeUVTTFUvQm9IYnF0Q0FndGRPVExJ?=
 =?utf-8?B?dnlKTzcycE81WW15SjIyNHZmUkYwZVNPY0Z2U2k5bFZXRHBCZ2xhK2hXWkh6?=
 =?utf-8?B?bTBUeFhRanJhTFpyZCtNT3JmNjcyY2dkWVNSQ25oN0pCTUtPK2lQaHhxVVRQ?=
 =?utf-8?B?MGNwRmt5L25pOVRBV0JDcno0ZmFJSmpMMmdvOGYyNDF5VEZLN05Eb3YyUnhH?=
 =?utf-8?B?anpPWUhRRVpUMUcrZnZCdkpxRjVyZWFpUVhBVnA3THZrbmdpeHlIYlhQUWlu?=
 =?utf-8?B?NVNSOTZBclNiY1BXNjlhNVhoek9QUGhMaUNTSitNcEQyc2t3OE9wNlFGZVp6?=
 =?utf-8?B?VTAyd3FUaGRGcnp5Mjc0LzJ6cjBDVkZwNEYybGpJTFo1dUQvUEFxakYzczM1?=
 =?utf-8?B?NDlkRE55Nk15WjFjVk53QTRXWjllOWg0TXJ6Zm91dnJxNU5MZURkT1g0eWRC?=
 =?utf-8?B?Q3VZbFZBTzFTWUUveXdLa0hiV1J3V2M3MGdmMC9vRm9uVERxVCtod1lSenJk?=
 =?utf-8?B?Z3ZuL0xvMHU4eXVTY1FnOXpQMVNBeU1lNmRadzhLNk4rR1hGNXdHelNiN2c1?=
 =?utf-8?B?TzdUeW1SeDJLNXJXNXloMzMvbSs0bE5DZnZmL0tyWklKNDRTN0YxdTQ0a2NN?=
 =?utf-8?B?R0F6ZXBlb1ZIVHBnWTM4bENLRFl0Tml3Vlkvbk5HME5XQWhlZm51ZEFOUW5N?=
 =?utf-8?B?cVNhazJwaEJMR0F3OFVVUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <723E113331A9E94F8D969DB4B293037F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8054fb23-70c8-4609-c955-08d994a00cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:35:37.8415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2771
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-ORIG-GUID: 5df5xctdFP-yyByddQxf86tB_YS6GNIC
X-Proofpoint-GUID: 5df5xctdFP-yyByddQxf86tB_YS6GNIC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gT2N0IDIxLCAyMDIxLCBhdCAyOjMyIEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IE1vZGlmeSB0cmFjZSBtZXNzYWdlcyBmb3IgYWRkaXRpb25hbCBkZWJ1
Z2FiaWxpdHkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVs
bC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5j
b20+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGVmLmggIHwgIDQgKystLQ0K
PiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZWRpZi5jIHwgIDYgKysrKystDQo+IGRyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgfCAxNSArKysrKysrKystLS0tLS0NCj4gZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2lzci5jICB8ICA0ICsrKysNCj4gNCBmaWxlcyBjaGFuZ2VkLCAyMCBp
bnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9kZWYuaCBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0K
PiBpbmRleCA4OTI0ZWViOTM2N2QuLjllYmY0YTIzNGQ5YSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9kZWYuaA0KPiBAQCAtNjM5LDkgKzYzOSw5IEBAIHN0cnVjdCBxbGFfZWxzX3B0X2FyZyB7DQo+
IAl1OCBlbHNfb3Bjb2RlOw0KPiAJdTggdnBfaWR4Ow0KPiAJX19sZTE2IG5wb3J0X2hhbmRsZTsN
Cj4gLQl1MTYgY29udHJvbF9mbGFnczsNCj4gKwl1MTYgY29udHJvbF9mbGFncywgb3hfaWQ7DQo+
IAlfX2xlMzIgcnhfeGNoZ19hZGRyZXNzOw0KPiAtCXBvcnRfaWRfdCBkaWQ7DQo+ICsJcG9ydF9p
ZF90IGRpZCwgc2lkOw0KPiAJdTMyIHR4X2xlbiwgdHhfYnl0ZV9jb3VudCwgcnhfbGVuLCByeF9i
eXRlX2NvdW50Ow0KPiAJZG1hX2FkZHJfdCB0eF9hZGRyLCByeF9hZGRyOw0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMgYi9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfZWRpZi5jDQo+IGluZGV4IGNhM2I5NDc3NzBiOS4uYmIzYTFhZmI4NmE4IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZWRpZi5jDQo+ICsrKyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gQEAgLTE3NjUsNyArMTc2NSw4IEBAIHFsYV9l
bHNfcmVqZWN0X2lvY2Ioc2NzaV9xbGFfaG9zdF90ICp2aGEsIHN0cnVjdCBxbGFfcXBhaXIgKnFw
LA0KPiAJcWxhX2Vsc19wdF9pb2NiKHZoYSwgZWxzX2lvY2IsIGEpOw0KPiANCj4gCXFsX2RiZyhx
bF9kYmdfZWRpZiwgdmhhLCAweDAxODMsDQo+IC0JICAgICJTZW5kaW5nIEVMUyByZWplY3QuLi5c
biIpOw0KPiArCSAgICAiU2VuZGluZyBFTFMgcmVqZWN0IG94X2lkICUwNHggczolMDZ4IC0+IGQ6
JTA2eFxuIiwNCj4gKwkgICAgYS0+b3hfaWQsIGEtPnNpZC5iMjQsIGEtPmRpZC5iMjQpOw0KPiAJ
cWxfZHVtcF9idWZmZXIocWxfZGJnX2VkaWYgKyBxbF9kYmdfdmVyYm9zZSwgdmhhLCAweDAxODUs
DQo+IAkgICAgdmhhLT5ody0+ZWxzcmVqLmMsIHNpemVvZigqdmhhLT5ody0+ZWxzcmVqLmMpKTsN
Cj4gCS8qIGZsdXNoIGlvY2IgdG8gbWVtIGJlZm9yZSBub3RpZnlpbmcgaHcgZG9vcmJlbGwgKi8N
Cj4gQEAgLTIzNjIsNiArMjM2Myw3IEBAIHZvaWQgcWxhMjR4eF9hdXRoX2VscyhzY3NpX3FsYV9o
b3N0X3QgKnZoYSwgdm9pZCAqKnBrdCwgc3RydWN0IHJzcF9xdWUgKipyc3ApDQo+IAlhLnR4X2Fk
ZHIgPSB2aGEtPmh3LT5lbHNyZWouY2RtYTsNCj4gCWEudnBfaWR4ID0gdmhhLT52cF9pZHg7DQo+
IAlhLmNvbnRyb2xfZmxhZ3MgPSBFUERfRUxTX1JKVDsNCj4gKwlhLm94X2lkID0gbGUxNl90b19j
cHUocC0+b3hfaWQpOw0KPiANCj4gCXNpZCA9IHAtPnNfaWRbMF0gfCAocC0+c19pZFsxXSA8PCA4
KSB8IChwLT5zX2lkWzJdIDw8IDE2KTsNCj4gDQo+IEBAIC0yNDExLDYgKzI0MTMsOCBAQCB2b2lk
IHFsYTI0eHhfYXV0aF9lbHMoc2NzaV9xbGFfaG9zdF90ICp2aGEsIHZvaWQgKipwa3QsIHN0cnVj
dCByc3BfcXVlICoqcnNwKQ0KPiAJcHVyZXgtPnB1cl9pbmZvLnB1cl9kaWQuYi5hbF9wYSA9ICBw
LT5kX2lkWzBdOw0KPiAJcHVyZXgtPnB1cl9pbmZvLnZwX2lkeCA9IHAtPnZwX2lkeDsNCj4gDQo+
ICsJYS5zaWQgPSBwdXJleC0+cHVyX2luZm8ucHVyX2RpZDsNCj4gKw0KPiAJcmMgPSBfX3FsYV9j
b3B5X3B1cmV4X3RvX2J1ZmZlcih2aGEsIHBrdCwgcnNwLCBwdXJleC0+bXNncCwNCj4gCQlwdXJl
eC0+bXNncF9sZW4pOw0KPiAJaWYgKHJjKSB7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfaW5pdC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBp
bmRleCAyY2NkYzc2Y2YwZDkuLmRiZmZjNTllMTY3NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
aW5pdC5jDQo+IEBAIC0zMzMsOSArMzMzLDYgQEAgcWxhMngwMF9hc3luY19sb2dpbihzdHJ1Y3Qg
c2NzaV9xbGFfaG9zdCAqdmhhLCBmY19wb3J0X3QgKmZjcG9ydCwNCj4gCQkgICAgdmhhLT5lX2Ri
ZWxsLmRiX2ZsYWdzICYgRURCX0FDVElWRSkgew0KPiAJCQlsaW8tPnUubG9naW8uZmxhZ3MgfD0N
Cj4gCQkJCShTUkJfTE9HSU5fRkNTUCB8IFNSQl9MT0dJTl9TS0lQX1BSTEkpOw0KPiAtCQkJcWxf
ZGJnKHFsX2RiZ19kaXNjLCB2aGEsIDB4MjA3MiwNCj4gLQkJCSAgICAiQXN5bmMtbG9naW46IHcv
IEZDU1AgJThwaEMgaGRsPSV4LCBsb29waWQ9JXggcG9ydGlkPSUwNnhcbiIsDQo+IC0JCQkgICAg
ZmNwb3J0LT5wb3J0X25hbWUsIHNwLT5oYW5kbGUsIGZjcG9ydC0+bG9vcF9pZCwgZmNwb3J0LT5k
X2lkLmIyNCk7DQo+IAkJfSBlbHNlIHsNCj4gCQkJbGlvLT51LmxvZ2lvLmZsYWdzIHw9IFNSQl9M
T0dJTl9DT05EX1BMT0dJOw0KPiAJCX0NCj4gQEAgLTM0NCwxMiArMzQxLDE0IEBAIHFsYTJ4MDBf
YXN5bmNfbG9naW4oc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSwgZmNfcG9ydF90ICpmY3BvcnQs
DQo+IAlpZiAoTlZNRV9UQVJHRVQodmhhLT5odywgZmNwb3J0KSkNCj4gCQlsaW8tPnUubG9naW8u
ZmxhZ3MgfD0gU1JCX0xPR0lOX1NLSVBfUFJMSTsNCj4gDQo+ICsJcnZhbCA9IHFsYTJ4MDBfc3Rh
cnRfc3Aoc3ApOw0KPiArDQo+IAlxbF9kYmcocWxfZGJnX2Rpc2MsIHZoYSwgMHgyMDcyLA0KPiAt
CSAgICAgICAiQXN5bmMtbG9naW4gLSAlOHBoQyBoZGw9JXgsIGxvb3BpZD0leCBwb3J0aWQ9JTA2
eCByZXRyaWVzPSVkLlxuIiwNCj4gKwkgICAgICAgIkFzeW5jLWxvZ2luIC0gJThwaEMgaGRsPSV4
LCBsb29waWQ9JXggcG9ydGlkPSUwNnggcmV0cmllcz0lZCAlcy5cbiIsDQo+IAkgICAgICAgZmNw
b3J0LT5wb3J0X25hbWUsIHNwLT5oYW5kbGUsIGZjcG9ydC0+bG9vcF9pZCwNCj4gLQkgICAgICAg
ZmNwb3J0LT5kX2lkLmIyNCwgZmNwb3J0LT5sb2dpbl9yZXRyeSk7DQo+ICsJICAgICAgIGZjcG9y
dC0+ZF9pZC5iMjQsIGZjcG9ydC0+bG9naW5fcmV0cnksDQo+ICsJICAgICAgIGxpby0+dS5sb2dp
by5mbGFncyAmIFNSQl9MT0dJTl9GQ1NQID8gIkZDU1AiIDogIiIpOw0KPiANCj4gLQlydmFsID0g
cWxhMngwMF9zdGFydF9zcChzcCk7DQo+IAlpZiAocnZhbCAhPSBRTEFfU1VDQ0VTUykgew0KPiAJ
CWZjcG9ydC0+ZmxhZ3MgfD0gRkNGX0xPR0lOX05FRURFRDsNCj4gCQlzZXRfYml0KFJFTE9HSU5f
TkVFREVELCAmdmhhLT5kcGNfZmxhZ3MpOw0KPiBAQCAtNTg2Nyw2ICs1ODY2LDEwIEBAIHZvaWQg
cWxhX3JlZ2lzdGVyX2ZjcG9ydF9mbihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+IA0KPiAJ
cWxhMngwMF91cGRhdGVfZmNwb3J0KGZjcG9ydC0+dmhhLCBmY3BvcnQpOw0KPiANCj4gKwlxbF9k
YmcocWxfZGJnX2Rpc2MsIGZjcG9ydC0+dmhhLCAweDkxMWUsDQo+ICsJICAgICAgICIlcyByc2Nu
IGdlbiAlZC8lZCBuZXh0IERTICVkXG4iLCBfX2Z1bmNfXywNCj4gKwkgICAgICAgcnNjbl9nZW4s
IGZjcG9ydC0+cnNjbl9nZW4sIGZjcG9ydC0+bmV4dF9kaXNjX3N0YXRlKTsNCj4gKw0KPiAJaWYg
KHJzY25fZ2VuICE9IGZjcG9ydC0+cnNjbl9nZW4pIHsNCj4gCQkvKiBSU0NOKHMpIGNhbWUgaW4g
d2hpbGUgcmVnaXN0cmF0aW9uICovDQo+IAkJc3dpdGNoIChmY3BvcnQtPm5leHRfZGlzY19zdGF0
ZSkgew0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jIGIvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+IGluZGV4IGIyNmYyNjk5YWRiMi4uNGUxZGZm
YTMyOWYxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4g
KysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+IEBAIC0yMjMzLDYgKzIyMzMs
MTAgQEAgcWxhMjR4eF9lbHNfY3RfZW50cnkoc2NzaV9xbGFfaG9zdF90ICp2LCBzdHJ1Y3QgcmVx
X3F1ZSAqcmVxLA0KPiAJCQkJfQ0KPiANCj4gCQkJfSBlbHNlIGlmIChjb21wX3N0YXR1cyA9PSBD
U19QT1JUX0xPR0dFRF9PVVQpIHsNCj4gKwkJCQlxbF9kYmcocWxfZGJnX2Rpc2MsIHZoYSwgMHg5
MTFlLA0KPiArCQkJCSAgICAgICAiJXMgJWQgc2NoZSBkZWxldGVcbuKAnSwNCgkJCQkJCV5eXl5e
IA0KUGxlYXNlIHVzZSDigJxzY2hlZHVsZWTigJ0gaGVyZS4gT3IgYmV0dGVyIHlldCBtb3JlIG1l
YW5pbmdmdWwgbWVzc2FnZSBzbyBpdHMgZWFzeSB0byByZWFkIGR1cmluZyBkZWJ1Z2dpbmcuIA0K
DQo+ICsJCQkJICAgICAgIF9fZnVuY19fLCBfX0xJTkVfXyk7DQo+ICsNCj4gCQkJCWVscy0+dS5l
bHNfcGxvZ2kubGVuID0gMDsNCj4gCQkJCXJlcyA9IERJRF9JTU1fUkVUUlkgPDwgMTY7DQo+IAkJ
CQlxbHRfc2NoZWR1bGVfc2Vzc19mb3JfZGVsZXRpb24oc3AtPmZjcG9ydCk7DQo+IC0tIA0KPiAy
LjE5LjAucmMwDQo+IA0KDQpPbmNlIHNtYWxsIG5pdCBhYm92ZSBpcyBmaXhlZCwgZmVlbCBmcmVl
IHRvIGFkZA0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFu
aUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUgTWFkaGFuaQkgT3JhY2xlIExpbnV4IEVuZ2lu
ZWVyaW5nDQoNCg==
