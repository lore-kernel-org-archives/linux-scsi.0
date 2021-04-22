Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADA6C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541846142F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhDVRH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:07:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47368 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbhDVRHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:07:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH65wn195441;
        Thu, 22 Apr 2021 17:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=t90vo1OyuaWrhxrjYIsE74mvLr4Sntrv3IUKXoQ64Fs=;
 b=FDNONwJBOp8kxui2SHfS+LeNvf8C7reTHxYfN2Ea9PUbkP1Xf40PNThtBCoDHt/UKegD
 dYmZwa2/aEtic/SxNt/QzeYCjMOeZknNGnAcjH++ohfE1rMC/kPhKNEmkREv4bQqpnHe
 3DY6MnhAHBZjclDChRTTP++WgiGsuf6cqlqrCX9F9pixlWccAG12gm/VQFO8SC+/P+n8
 orRwshKO5mIvjHjifGBtxWljY/LgaDObwuXm8xJfMNYZC3HDg94QoKSZ96EhMY+I4IoS
 0MtNrwDLe4ciibB5tmtKNJ23TyiesjqFjpOA93uNJIvlWVkqxdZ2q3ywYWx1w7C6diJV 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37yn6ce5ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:06:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH69k9102947;
        Thu, 22 Apr 2021 17:06:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3030.oracle.com with ESMTP id 383cdrte2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:06:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3YJOjm1++/9Xvvhxig3VNZ4Zfee9YYVrCqXhJtOd94s+Nx3FsaNpIA6J5QXdvhdYYK8MBLq3dihwmDcUhFaLf1qFTTs2N97VsLTNSWMQMzJOkVqpsbuAGUYncUBHewlqVG0+7oy5Te9BLeonGrhOKmsZZT5+btZtEKn31hJmFGz1KtkAtzQEACMW5wNosj1tmxD3Mn/JGX4QjsEVoOhe9N2CMSIA17bQSL/Zpxs7rLoiqIOyXfHwxGfw0C8UyhDvb5gBGj7AuxMNsYsMZvXPL8gHbOanZa1IKXiwAi2HEsRdc8+BDA8FHPOoeEuStYYrJfQgV6VqTzYP25duBm4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t90vo1OyuaWrhxrjYIsE74mvLr4Sntrv3IUKXoQ64Fs=;
 b=RwdhniKgHqYQTixZuimKZ28Bg/6CWNyO1LGkMTS9553yNE3Fubd6mCjtdxJ5t6cQWFnv/judNKenm3Lb3Kk44vpKW7t3tSj/jwEJZ/WK21quibKDxwnihDe0PMNlb52YUEghXjUkr2A2NChRsnmayy7lfS3/7J2ozGkEpKPYGER3X7ag7ruYvCda7qFUwPjVP55yiCRAQtXLA9Bq3ZqL55GDXxw/KY7+evVQAFRV7PlP6LS+PYmo2+dAUQ+A6SdhE2NU/i/RM1fcx41608TRl6DVn/HejWQpUFDO7WCxZUIeTXDrj63//yiekmHHvkDK4cS55lPffuPBRYXwI3S9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t90vo1OyuaWrhxrjYIsE74mvLr4Sntrv3IUKXoQ64Fs=;
 b=mMNbGao9uyMO83ResCH5a1I6uq+i1Rb5Y3IOYekRYmeDklX87l/zlZukxKtPAtIWacGzkPJXwNCrb+4ERa3alkIPhN6mQcJP08KeNhp2BaxidhS4Shx7w3aSu2RJzfPEcPeFzimCb66jeOOIs0RqvlGMATUBY5I7hV7JUeFKfO0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4427.namprd10.prod.outlook.com (2603:10b6:806:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Thu, 22 Apr
 2021 17:06:34 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:06:34 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
CC:     target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: qla2xxx: Prevent PRLI in target mode
Thread-Topic: [PATCH] scsi: qla2xxx: Prevent PRLI in target mode
Thread-Index: AQHXN46UzywkF3RgbEeQhF1bFm4To6rAxJOA
Date:   Thu, 22 Apr 2021 17:06:34 +0000
Message-ID: <7D8211B1-BD51-45A0-AC63-BE23C2218433@oracle.com>
References: <20210422153414.4022-1-a.kovaleva@yadro.com>
In-Reply-To: <20210422153414.4022-1-a.kovaleva@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97675415-9c99-471c-9c90-08d905b0fbd8
x-ms-traffictypediagnostic: SA2PR10MB4427:
x-microsoft-antispam-prvs: <SA2PR10MB4427327E9A0F154EE0F42AFDE6469@SA2PR10MB4427.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MT/mHiHpvlzN4rgtvAhys3XrWQ2YfOPRYFm/YVSGZoKIdmv8ievYH5oRKdW5L4uE3PoSZvPRQbhkAzmXntbQsDo0MpdNpFv6VV2xgJb/JKPejeTGuGG9i35dW21k+k5k2QW3DrFTEG1rxMFMH9g0RwwqogS4Knil7FVniRxkfx9YClLBTfufZmltfSh//j3LirsvWs0kGvDsv135Q/UvQl3axpy+36SBxkbpTCSpi+r443lMArq+RnnFHPewU8ZObRkqdm809DVzoq/YBlM8V5L3oFMIYWyvXspfnK2+bDkx/xGXklIjNAl8jCg26i0TjsYP6WS/2r3QbVOerDQKEoQxYGLOKyePL+Rg3qZHKD+g/DJM2PD3IryK3qLcmFM4/e7Mzm4YLct5lIGK1F5UaEhlZkNYTzTXwdo7NySO+ObIiA5Lesxu6L70iQjMB7YJiEnYpNEYoUOtSDU8HmwWsNnPmfNalkLTIBGph2DNAiunU0lQA9YizVEwPgAObfKX+Qk+6NVeW3vgQeCdcDUP0OWP1X1Gz7hD4EgPdjUvWw9FcX64L2YRP1GDMg7JYzq1xG0r09ssCcdoDZiO8ClfPkfh5WbxVT6fCYibh3WDVexNK/ADd3BBY2B7qdE1rK5XeezB9mvkc6NH0daAT22ZPaPUrmntjBjmVscQjbfdm9dK0aTZ28bsVDASdA4TnZnTuKcarnPwaHfHBMYZ6CvjlOTnn48qC3fxcPz/dHR+mllKDqPE2Eg4GYgiUOYyUJyQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(2616005)(4326008)(186003)(478600001)(26005)(66556008)(66446008)(966005)(6916009)(316002)(86362001)(64756008)(66946007)(5660300002)(76116006)(71200400001)(83380400001)(66476007)(44832011)(2906002)(38100700002)(8936002)(54906003)(53546011)(6506007)(33656002)(36756003)(6486002)(122000001)(8676002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NUNQR1o0RkNvd2RqYnh0Sk9yWjViQ3RUdTZSdXl3enM0Z0hiVTlXK1B1eXR2?=
 =?utf-8?B?Y3BBYnBpaVBEUjhSbzMrSVdnd1h3eHhBalJKTGVBTFQxRDMxN3NFRG1SektI?=
 =?utf-8?B?V21xR2hsSWtBVkdla0l4bFJkNUZsZU1QeGZ5S05iR0M2YURwSjUwZnlDemJG?=
 =?utf-8?B?ZTFOSlVEOS92Z2huUSs1eEFPdmNVeEwrM0pBYkxWODlsM2VzOVpvc2VabUV4?=
 =?utf-8?B?d2p4amJhcFRWWEU0K0Q5YVNxSWg0R1pHQmlFWTd0UHgxeGRsQ3FSRk1sbjRu?=
 =?utf-8?B?bmxnQ0gvSlYzSnVzWjYvUEJFc3l3M0k1RU9WSFdEYzZiMVZXcU5yMkJUaCtT?=
 =?utf-8?B?bmVlVG52aDJFQjc3TlhNZGw2VWV3ZVFNYmh4TlBPUDJpS2p4RzZlazhZZWpX?=
 =?utf-8?B?ZkZZYURSK1NoaTBmUEJKMWZJNzY4TEY3a2xpQ05iOGRmaGVMMHIxdjB1eVV0?=
 =?utf-8?B?MzRJTnNzcHp5djJNQllTRk56ZU5aaVoxREFYWWI4eFRhTTFVdjZHdjlzditi?=
 =?utf-8?B?bjMzRU5SVzBFem03aUdVL2RUcVNYZXRSMGx5V1hTOVhUNS84aGZOZXZjMTRO?=
 =?utf-8?B?OEx5bXRJWmRPQ3NMS1JBVWFrZVlHdjI3UnVHVWFXazNmMTljMmhWYkl5bEdl?=
 =?utf-8?B?VVE4cHlyNUpNci94UWlrMG5sem9ZVU5MeG5CSzBhQWJ2d2sweEEra2NOeDU0?=
 =?utf-8?B?N3NxcXpXMzVmeGRMeStlb3l0MEN2UlhoZm9obUZpYnlVWFR0QTFvSGpTajM0?=
 =?utf-8?B?Y2h3ai84NjByS2RjaTZQK3BLUHVsc2RHZGwxQXZlM0YyS2ZpVGoyamhPMnVl?=
 =?utf-8?B?OTBiNGErQThrcUlFa3ZSUU1ISUxQVjZ1NUx0cWV5cGwxQk9Bb3ZxbjhuTjR5?=
 =?utf-8?B?N05DUWVTTjhvVGQ4QnlvV1pZZitTYUdnVG9EdTg2WE1DR210cXpxVElaVlNW?=
 =?utf-8?B?RFpvRnZRM2IvVHdRTDNOVkNjRGxTUFA5ckNnMi9NTVE1MEN6eEVHYUJBR2pP?=
 =?utf-8?B?SzkwZi85UzMxRGducW9IbjllYUZxVjhuT1FDeGVpRzhBZUJVSWdvelB3N1dH?=
 =?utf-8?B?R1JGSWVzdFZpamlvV2ZoU1NmbWQzbFJNZUxSWWpRcEErMGp4RFJINlBBSGFa?=
 =?utf-8?B?RERHblo2dXQ5VWlUQmF0cjJOQW8rTDgrdWFidm50dnQ2eTdmTUlaYWQyNWZQ?=
 =?utf-8?B?ZjJwTlRYemFSbHNQS2lYdVNJTjJLRnA3VFRlTXRzbW5VaXVacWJHaUVNNm9w?=
 =?utf-8?B?UVdsYk5CbkhZaExmb01BVVRJbDZkRnhhNWVqaWN6bElkdXlsVjkxZmVSOXB2?=
 =?utf-8?B?b1h3UTdZWFZRWDJVUTlWNHpLdUx2WnNoZmFBYjdpSlZLb1VkckRkUGtFK1J6?=
 =?utf-8?B?L2N1TzlrWXBmUlNtYURiTk9HdkhEcXlJVWhqRUc2eFFMcXY5aWx6V2hObGdL?=
 =?utf-8?B?eG01emtTZlErYXdGUU82TXV4Q2dSQklTYWNVZThJUFF5UjlZeEtFZU5zRzFJ?=
 =?utf-8?B?bDgvVEp3VHFpTk4wbzdzRWFQd284QXRGRGo0REs3MEpiNTVSRjlLZ25Sd1VS?=
 =?utf-8?B?QTFQUEYxS0UvTFQ5dENZVWlnZlJaL3BoeVU4WjN6K1p5SmV0bmdUSzdDYURZ?=
 =?utf-8?B?blBOb2NDY1ZXbCtCSHZHRFE1c1plM1d3ZFJ3NjYzTkFCcUQvUkt2S0NoN1Iy?=
 =?utf-8?B?ZFZuVzEwRzdzU2NVOGZYdkwwM0tTR2pVWTV5MjNwMjQ2eXVjODBDSnZWUzBo?=
 =?utf-8?B?VC9QcFBpUEtNdEVCWGhnSzZ6TU5xQ2pUUlprdm9aQ0FFdDZlajFhdVkwaSsv?=
 =?utf-8?B?UG9vRTRpYXdYNnRqRlZyQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <46CEF6E9DBB4A14D9B3FC82AEF3BCB22@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97675415-9c99-471c-9c90-08d905b0fbd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:06:34.6437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qp3enZ+esXFMcG87jeS2ZzGpiaz/ldpWihk7mhW6FgL3X3lHzHq09KX/jfgGR3KT6ttNuSvRZvYCte9eB+SGszaMLf/EX7YHaW+kLz95H2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4427
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220128
X-Proofpoint-GUID: 51poA6lUb1POJ6H37CRUvGkgPkLM15Am
X-Proofpoint-ORIG-GUID: 51poA6lUb1POJ6H37CRUvGkgPkLM15Am
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gQXByIDIyLCAyMDIxLCBhdCAxMDozNCBBTSwgQW5hc3Rhc2lhIEtvdmFsZXZhIDxh
LmtvdmFsZXZhQHlhZHJvLmNvbT4gd3JvdGU6DQo+IA0KPiBJbiBhIGNhc2Ugd2hlbiB0aGUgaW5p
dGlhdG9yIGluIFAyUCBtb2RlIGJ5IHNvbWUgY2lyY3Vtc3RhbmNlcyBkbyBub3QNCj4gc2VuZCBQ
UkxJLCB0aGUgdGFyZ2V0LCBpbiBhIGNhc2Ugd2hlbiB0aGUgdGFyZ2V0IHBvcnTigJlzIFdXUE4g
aXMgbGVzcw0KPiB0aGFuIGluaXRpYXRvcuKAmXMgb25lLCBjaGFuZ2VzIHRoZSBkaXNjb3Zlcnkg
c3RhdGUgaW4gRFNDX0dOTCwgYW5kIHdoZW4NCj4gZ25sIGNvbXBsZXRlcywgaXQgc2VuZHMgUFJM
SSB0byB0aGUgaW5pdGlhdG9yLg0KPiANCj4gVXN1YWxseSB0aGUgaW5pdGlhdG9yIGluIFAyUCBt
b2RlIGFsd2F5cyBzZW5kcyBQUkxJLiBXZSBjYXRjaCB0aGlzIGlzc3VlDQo+IG9uIExpbnV4IHN0
YWJsZSB2NS40LjYgaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvc3RhYmxlL21zZzQ1ODUx
NS5odG1sDQo+IA0KPiBUaGUgY2hhbmdlIGZpeGVzIHRoaXMgcGFydGljdWxhciBjb3JuZXIgY2Fz
ZSBpbiB0aGUgYmVoYXZpb3VyIG9mIHRoZQ0KPiBQMlAgbW9kIHRhcmdldCBsb2dpbiBzdGF0ZSBt
YWNoaW5lLg0KPiANCj4gRml4ZXM6IGE5ZWQwNmQ0ZTY0MGEgKCJzY3NpOiBxbGEyeHh4OiBBbGxv
dyBQTE9HSSBpbiB0YXJnZXQgbW9kZSIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuYXN0YXNpYSBLb3Zh
bGV2YSA8YS5rb3ZhbGV2YUB5YWRyby5jb20+DQo+IFJldmlld2VkLWJ5OiBSb21hbiBCb2xzaGFr
b3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT4NCj4gLS0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9pbml0LmMgfCAzICsrKw0KPiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gaW5kZXggZjAxZjA3MTE2YmQzLi43MWY3OWM5
ODhmZGMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4g
KysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBAQCAtMTE5NCw2ICsxMTk0
LDkgQEAgc3RhdGljIGludCBxbGEyNHh4X3Bvc3RfcHJsaV93b3JrKHN0cnVjdCBzY3NpX3FsYV9o
b3N0ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0KQ0KPiB7DQo+IAlzdHJ1Y3QgcWxhX3dvcmtfZXZ0
ICplOw0KPiANCj4gKwlpZiAodmhhLT5ob3N0LT5hY3RpdmVfbW9kZSA9PSBNT0RFX1RBUkdFVCkN
Cj4gKyAgICAgICAgICAgICAgICByZXR1cm4gUUxBX0ZVTkNUSU9OX0ZBSUxFRDsNCj4gKw0KPiAJ
ZSA9IHFsYTJ4MDBfYWxsb2Nfd29yayh2aGEsIFFMQV9FVlRfUFJMSSk7DQo+IAlpZiAoIWUpDQo+
IAkJcmV0dXJuIFFMQV9GVU5DVElPTl9GQUlMRUQ7DQo+IC0tIA0KPiAyLjMwLjINCj4gDQoNCkxv
b2tzIEdvb2QuIA0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFk
aGFuaUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUgTWFkaGFuaQkgT3JhY2xlIExpbnV4IEVu
Z2luZWVyaW5nDQoNCg==
