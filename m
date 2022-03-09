Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40D2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiCISjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiCISjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:39:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9465163D5C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:38:11 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229GN1iW003117;
        Wed, 9 Mar 2022 18:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BVQ4FvTVxWekdYCMZFfMifh7xQmSRCqpCqjSGFSJaDE=;
 b=R6YKuNdYFVMNbmDCQqUCU542rmxSQRUMqBOYLKYS8TMUIZ1J6Hh7seN31Tve1OuD5v4l
 nV8Uuz5K9GoEnbP/T5xLoSHP4OZFAPBQzLAMCgExxl34uljPQWuGZnY50/AMI7b83QU3
 qDRG4Q5teIY4iorbm9HmRqw39A7z9WnHJuMXypFr80jHk8V9FZD8zEaqnTVP1wYf3rfP
 PHVZBUCavK2ptUhFrIHsBRkpE8yY9BttYI/bIG0m067NVLqVqs8jIqhAxrG1NK+r7Zye
 BXzTJhXw4BAOtT0UCeNMMv4zNDV+y5Sko8zL3RfWVYjug8cD61cSNVnlSoF1DHo8moqd ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du35jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:38:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229IUOWQ073174;
        Wed, 9 Mar 2022 18:38:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3ekvyw2pvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKm5aOdLfeJodU0jmGZQGKfzJkAijGNQQgPx/MhrbQoOp5dSZ0VTe+eUC12ZGwXi7qKnYGP+EfEn9B4r5mXAetNwUDfUuZqsIgpKfUi6LD4RwX9EbbQjU2Yi5qWFqJZ2ZWPW37yVwYP0TJgZjCE9Q9Awwz/sK54UHfGB+75t+f5T5ftbeMA6ii4V/ft/Q3d7P+D8BF0sHb0LLvc3FSV30jWUkf3XDROP95Yps38Fq3tZdaP9fS0tGss84pjxbVXqjXtqpj2z/+lKdjvwXa33tiTxT6kAe4O011a+gQQ025G/TNUuDC1VWpgm4kkYMVTk0JcpHKTwO2Iw+3YRwEcrbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVQ4FvTVxWekdYCMZFfMifh7xQmSRCqpCqjSGFSJaDE=;
 b=EtdGyrWlGD/ztAAgfZaVdLzqvFbZEQrzzixT8nTL2v1hdNSLcCB40uG8ZWKuIgaAi2BtSSqnw72RnzLd+/tUs4OZhwqZnVQ0yliDE4HACQKOSIRDSN17mehbmrQoo5OCnjdGhgb6mOS6xg4u/seEldyUyRtlW2fQZ6D5HtsH1wNb60hftRl/8jys/bFsMr5PbYGLgcf5Wi4Hi30iC2FcoYkGmMozptfgwDmIfH2a0Ikjd5HnVo8UgIa2dnqebwPCBjQfmdIrQAVdHTAerhJC/829/4Gcip24K8A45dADB0IAowRgztOG7SuEWLk8hPI/qMbTck5t04kZBTrmYqbqag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVQ4FvTVxWekdYCMZFfMifh7xQmSRCqpCqjSGFSJaDE=;
 b=z6cLbcYDT2m/nkA140R4f1KkqzTZUt+XWc91s36Qvv1Frc/dYWZf2oYSLMcfyhjSmYwPe/+mG5Y9VCHU2Ak7/nZdmhU0WhhFV+74bXZ4sCiv4gLUZvtOMxWb59mYP6QVRDV3XwAToIb+dKNntGt9c7p5hvyca9UbpKNyG8QTbTQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB3741.namprd10.prod.outlook.com (2603:10b6:208:117::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 18:38:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:38:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 02/13] qla2xxx: Fix disk failure to rediscover
Thread-Topic: [PATCH 02/13] qla2xxx: Fix disk failure to rediscover
Thread-Index: AQHYMsV/tc9DHzBYukOrLzM3XZTMVKy3ZBOA
Date:   Wed, 9 Mar 2022 18:38:03 +0000
Message-ID: <B6082291-A75D-4521-A495-30D5815E0EBF@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-3-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 154402ca-616e-4647-e9de-08da01fbf221
x-ms-traffictypediagnostic: MN2PR10MB3741:EE_
x-microsoft-antispam-prvs: <MN2PR10MB3741B7FC7C3635F13D49E231E60A9@MN2PR10MB3741.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: axF20X62ISTJyZ1hlD5OMjT/NNiSkEkGRVQ7FlvKsQS4MMEjYiI+9t6q6x94+QO0dur+ZVUB51ufUXj6WhEtc/3ruKNrbeQA58W+1opbPCLaFVPYxS+KGPeqO+XkLR2GGDr0FAAZn9P/wAosdwTxUVoSR+9IrK4Ezki17h/OX4c8BtGV8o5kb1jdVhasYvamU7RgKkpYINZy6SFUgs3JTNzf58dfmNO3AArQFzSJmAyonnhG6eXjVWqEnmC2wnGYVL5ncyb2tSr6f9sg3ZJXgLOlseTiIa7iaaeCrr0pGBg9dCR2oDAC9x3M5HA1i4byfpFQXLN1RGi3tYXmemgy51u50wJdpR2Fsf6gG3+WIX6GoFLkGzve65IapOhbXLqF7TwScy8GuNxBvzGl799pRCXTj+0N4wWsk6AUqK2C+Ppm3R+T93ehbGG43qBVHN7Edwohj9MTkNzfcxkKtbc0fDrSvBlGeCp8WB9xi0HotZzNAT0myWUnnMflb9M6KjEmICdikNtqXWE5Gob61OBp6f5jRgILYDksiB5Mox1CfUsxq/STZvca4FCUrq+mo3OiJwBggp3jZfiR/w0t3W/D5Yx2IY4XhMp4yeMaY49PisZVHkS9xVUMoMymh85KQEuLm8BC64SsHRMDQbu+vDc/Uv9UIguFIztsofXVc1UP9Y8TYkQ7ctoiWnSEZCi/VJvW5uBK7+qTuYyaqoEtXYy3JanPjlepaqmtCksTOQ4rLh47QmJT38ao7z1qZVtYKuyK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(66946007)(91956017)(66556008)(44832011)(66476007)(8676002)(6486002)(5660300002)(6512007)(4326008)(66446008)(6506007)(53546011)(316002)(38070700005)(33656002)(2616005)(2906002)(86362001)(8936002)(64756008)(122000001)(38100700002)(508600001)(36756003)(6916009)(186003)(54906003)(26005)(83380400001)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVpEaUdIN1VFalFUQXdxRFFuY2g3aVdHVnF5TDc4S3JWajBZWmtSYVZFdzBV?=
 =?utf-8?B?bVpmbG5qV1p0MW1vT0wxeGZEeUlSMXo0MDJCS3lWWVhKTWJhQ21KSEVwSDIy?=
 =?utf-8?B?MmV4Tm00QVZGRndGRnBxUTVxOGUzeXc3VlE1RjNURDFYbkJJRDN2WUR2WWdN?=
 =?utf-8?B?SXBsVFUzZzFHNFNFblorSzkvVUowRGlpY1pWL2dETlQraWhUQnVkQzJacEUx?=
 =?utf-8?B?Z0ZaMHZsTUlrWkpHc3BLS1hsYk1Nd1p6VEhLNHExNW5OWVkzbWdZWEh5UWU0?=
 =?utf-8?B?bVlXTXdIajQwUkgvT0hSa0JwZXFZSy8rNmxhbWdlYnJDMVJ4c0cweTFBcW1z?=
 =?utf-8?B?M1JsaXQ2aE9MS05rRWhGMWFXUGlUU05rOVV2ZFhKSHRLd1ZCcS9OSE5paHJo?=
 =?utf-8?B?QndIUS9ZUjhib1lVSXdpVHpNbDArOU8xOWE2RWMxTG83akdBdXY3a3BvMG82?=
 =?utf-8?B?S1pFaWhUWHdYdnlubjBQcEtta2d5OUpEdEcxeFhqT1V4bFJJa2J6SXM5cTR2?=
 =?utf-8?B?ZnlQd3ZqR2xNNk9wcTFhODFEQjdQYnZRUit6RFU5NHBzS2JSQ2ZZRy9sQUtw?=
 =?utf-8?B?Zjg3L3U4azB0ZUZxM0FPYWxpS0h0SDBIUHNXUXlvckdUbzUwZlBYM0ZXSTRF?=
 =?utf-8?B?RXlQbldhYXhqeXd1aE5KTFk0L3dlL1FveFVTQmhlZTRWNnlIT09QOVBtajUz?=
 =?utf-8?B?VTZOdFdYYVprZ0xUbU56aDdqZ0FaYWF1RVY1Vk5QeEJ2aDdRNk5ZRFQyUGhF?=
 =?utf-8?B?ZVkwSzFLTXJDK3Z0WHowOUh0OVFHdG83Z3d6clBNYkd1TWEzK2prYkNRbWNm?=
 =?utf-8?B?NTU0bDZPR2JaLzMxM3lKYlFGcFZUOHpFSlZ4eXN0emRKWnI0YU54dloreHpJ?=
 =?utf-8?B?MkpCdWNwZG1sMGZWem8zQXNteGlnSnZkZk5OVlpTdytQQkxKYnhjUmVZanh5?=
 =?utf-8?B?QlhxT1hqWHd5MXBHMW1hU3Z6TmxoT0NGMTVKakdJMzJaOHpDWXNkYnZCTkpP?=
 =?utf-8?B?cWZZTWFZOFMydHpWOHMrRmh4VmNHT1gxSncyN3VGU3pkaXBmZFNYZFhSVmcv?=
 =?utf-8?B?OUErdVk2U1Blbk5wS0I2ZlhsTi94anZvZm5qeHJNWFRTUEpkdnV3dTduTHdH?=
 =?utf-8?B?Uytzd0JNM1pxSEFlejAyUno1eFFyc045Sjl5K1VXeUl2T1VqMXIxUWtyVkRO?=
 =?utf-8?B?QmsrTTJPL0lQTS9IOUY1SU5VU2U5L0dSc1VtVjhZSE5qVktOMU1vbkx2VFNX?=
 =?utf-8?B?VWIrcTh2UXhYQU0yM3NrQ3oyQkFmSmtzN1ZZa3lObjZMZ2xpRm1JNHpjYnRJ?=
 =?utf-8?B?dkh4aW0wY1BNTzk3SFgxNERsczJaTDd1dkJFMHhOaFEyMXl2WTVyUWlwVGhu?=
 =?utf-8?B?a2NhcHRFY0daY0pXSFAwbS8vNE1EN2I5Uy95SWcvdnI4ZWM2OWFiYlh6ZElp?=
 =?utf-8?B?OFB3VTdWRXdJUWhxbkZ0c3c3OWxNdXVhMzM0QVV4N2s0UFhkczhvTUZ5bU5o?=
 =?utf-8?B?UXVlcmRBU3FMZkVqVk5PYndGdFJ3QVNHcW1QYWlIV1FsNmtZM2RtUTdvODh5?=
 =?utf-8?B?MjdvNjhrRmc4WkVDQW40YytQaURTL2NVdmNySDlhN0hvd0VmL1pVVGo4SVF0?=
 =?utf-8?B?S2x4Q0VNU1pQc0xSdlFkOWN4M0NrZk5QWWxhdjZ0OFhOdnZlaGZHTkJTaWhk?=
 =?utf-8?B?OVYzRnhWRGxKK281bVc3OE5ZWGpyYUdmKzVoYS9Vc2w2MjR2UWV0MzBlbUxD?=
 =?utf-8?B?ZjdYYmVUY2gxK1Q2d1d4R0tNMUtuWERGbVJpR2JlTUFadEI0YTdIUlpteksv?=
 =?utf-8?B?UHpoZUdmY01WUEFkQjJSQVlTU0xvdXUrOUVnbHc0OFNPd05QU1VLK3R4a2pW?=
 =?utf-8?B?YUpHUmFiYzN0bWIrVVNwU0tTUERKRWdmb0pqVkpCUXhyREFpeUEyR3VSbnk1?=
 =?utf-8?B?RGxxcmRlMnJjVWJaUENVV1hLTlBFOW1pejM2UWxvVEcycFVDWXhaUEFHRGxD?=
 =?utf-8?B?Qmo1L1Q4dDMvSVluekVDdndZU01UWWJpODBVKzVpeGlDOTZGSmJmS2JWa04y?=
 =?utf-8?B?cWRRL3VuNVB6QWNxbGJBK01oTmZlb2IvRlNjTWhJZXNiOEZuV2ZOOFBXVnVX?=
 =?utf-8?B?NUppV29URUJ4UWpYQktkU3dEZmtOVGVocWxmMEllbTkweTNKeXY1cFg4VWlm?=
 =?utf-8?B?ZldzN2dMcUFHdlpadWxBMmlyQ1lKRjZlb3lPdjQrdHBCaWhiaTBiQm9nblV4?=
 =?utf-8?Q?7AFaPMgLbXUm1vYnWAbE2gdjm2cXf+k90mUMl3pXUc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B04C0A0A829A134997868BFD5F6EBF2A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154402ca-616e-4647-e9de-08da01fbf221
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:38:03.6293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wv2m/Ltq4F5XW27+FiHXkmAMuxRM3+WtiSlEA6dGnVoYJ/ZDlGM/Qxtq5XU6XMqoMhlG+STT0mDdq3ZgoNdFPWJDxkVeEooOvGyAmG+bJwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3741
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090101
X-Proofpoint-ORIG-GUID: RHD5Noe7AUzaq4Fap-O3UKjHrBrApvTs
X-Proofpoint-GUID: RHD5Noe7AUzaq4Fap-O3UKjHrBrApvTs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gTWFyIDgsIDIwMjIsIGF0IDEyOjIwIEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IFVzZXIgZXhwZXJpZW5jZSBzb21lIG9mIHRoZSBMVU4gZmFpbGVkIHRv
IHJlZGlzY292ZXJlZCBhZnRlcg0KPiBsb25nIGNhYmxlIHB1bGwgdGVzdC4gVGhlIGlzc3VlIGlz
IHRyaWdnZXJlZCBieSBhIHJhY2UNCj4gY29uZGl0aW9uIGJldHdlZW4gZHJpdmVyIHNldHRpbmcg
c2Vzc2lvbiBvbmxpbmUgc3RhdGUgdnMgdXBwZXIgbGF5ZXIvVUwNCgkJCQkJCQkgICBeXl5eXl5e
Xl5eXl5eIA0KSSB3b3VsZCBqdXN0IHJlbW92ZSDigJx1cHBlciBsYXllcuKAnSBpbiBhYm92ZSBz
dGF0ZW1lbnQuIA0KDQo+IHN0YXJ0aW5nIHRoZSBMVU4gc2NhbiBwcm9jZXNzIGF0IHRoZSBzYW1l
IHRpbWUuIEN1cnJlbnQgY29kZQ0KPiBzZXQgdGhlIG9ubGluZSBzdGF0ZSBhZnRlciBub3RpZnlp
bmcgdXBwZXIgbGF5ZXIgdGhlIHNlc3Npb24gaXMNCj4gYXZhaWxhYmxlLiBJbiB0aGlzIGNhc2Us
IFVMIHdhcyBmYXN0ZXIgb24gdGhlIHRyaWdnZXIgdG8gc3RhcnQNCj4gdGhlIExVTiBzY2FuIHBy
b2Nlc3MgYmVmb3JlIGRyaXZlciBjb3VsZCBzZXQgdGhlIHNlc3Npb24gaW4NCj4gb25saW5lIHN0
YXRlLiBMVU4gc2NhbiBlbmRzIHVwIHdpdGggZmFpbHVyZSBkdWUgdG8gdGhlIHNlc3Npb24NCj4g
b25saW5lIGNoZWNrIHdhcyBmYWlsaW5nLg0KPiANCj4gU2V0IHRoZSBvbmxpbmUgc3RhdGUgYmVm
b3JlIHJlcG9ydGluZyB0byBVTA0KPiBvZiB0aGUgYXZhaWxhYmlsaXR5IG9mIHRoZSBzZXNzaW9u
Lg0KPiANCg0KVGhlIGFib3ZlIDIgbGluZXMgYXJlIHJlZHVuZGFudCB3aXRoIHRoZSBmaXJzdCBw
YXJhZ3JhcGguIA0KDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IEZpeGVzOiBhZWNm
MDQzNDQzZDMgKCJzY3NpOiBxbGEyeHh4OiBGaXggUmVtb3RlIHBvcnQgcmVnaXN0cmF0aW9uIikN
Cj4gU2lnbmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4g
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyB8IDUgKysrLS0NCj4gZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX252bWUuYyB8IDUgKysrKysNCj4gMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2luaXQuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4g
aW5kZXggODM1ZWQ0MTc5ODg3Li42ZmZlNDRiODA1YjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2luaXQuYw0KPiBAQCAtNTc1OCw2ICs1NzU4LDggQEAgcWxhMngwMF9yZWdfcmVtb3RlX3BvcnQo
c2NzaV9xbGFfaG9zdF90ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0KQ0KPiAJaWYgKGF0b21pY19y
ZWFkKCZmY3BvcnQtPnN0YXRlKSA9PSBGQ1NfT05MSU5FKQ0KPiAJCXJldHVybjsNCj4gDQo+ICsJ
cWxhMngwMF9zZXRfZmNwb3J0X3N0YXRlKGZjcG9ydCwgRkNTX09OTElORSk7DQo+ICsNCj4gCXJw
b3J0X2lkcy5ub2RlX25hbWUgPSB3d25fdG9fdTY0KGZjcG9ydC0+bm9kZV9uYW1lKTsNCj4gCXJw
b3J0X2lkcy5wb3J0X25hbWUgPSB3d25fdG9fdTY0KGZjcG9ydC0+cG9ydF9uYW1lKTsNCj4gCXJw
b3J0X2lkcy5wb3J0X2lkID0gZmNwb3J0LT5kX2lkLmIuZG9tYWluIDw8IDE2IHwNCj4gQEAgLTU4
NTgsNiArNTg2MCw3IEBAIHFsYTJ4MDBfdXBkYXRlX2ZjcG9ydChzY3NpX3FsYV9ob3N0X3QgKnZo
YSwgZmNfcG9ydF90ICpmY3BvcnQpDQo+IAkJcWxhMngwMF9yZWdfcmVtb3RlX3BvcnQodmhhLCBm
Y3BvcnQpOw0KPiAJCWJyZWFrOw0KPiAJY2FzZSBNT0RFX1RBUkdFVDoNCj4gKwkJcWxhMngwMF9z
ZXRfZmNwb3J0X3N0YXRlKGZjcG9ydCwgRkNTX09OTElORSk7DQo+IAkJaWYgKCF2aGEtPnZoYV90
Z3QucWxhX3RndC0+dGd0X3N0b3AgJiYNCj4gCQkJIXZoYS0+dmhhX3RndC5xbGFfdGd0LT50Z3Rf
c3RvcHBlZCkNCj4gCQkJcWx0X2ZjX3BvcnRfYWRkZWQodmhhLCBmY3BvcnQpOw0KPiBAQCAtNTg3
NSw4ICs1ODc4LDYgQEAgcWxhMngwMF91cGRhdGVfZmNwb3J0KHNjc2lfcWxhX2hvc3RfdCAqdmhh
LCBmY19wb3J0X3QgKmZjcG9ydCkNCj4gCWlmIChOVk1FX1RBUkdFVCh2aGEtPmh3LCBmY3BvcnQp
KQ0KPiAJCXFsYV9udm1lX3JlZ2lzdGVyX3JlbW90ZSh2aGEsIGZjcG9ydCk7DQo+IA0KPiAtCXFs
YTJ4MDBfc2V0X2ZjcG9ydF9zdGF0ZShmY3BvcnQsIEZDU19PTkxJTkUpOw0KPiAtDQo+IAlpZiAo
SVNfSUlETUFfQ0FQQUJMRSh2aGEtPmh3KSAmJiB2aGEtPmh3LT5mbGFncy5ncHNjX3N1cHBvcnRl
ZCkgew0KPiAJCWlmIChmY3BvcnQtPmlkX2NoYW5nZWQpIHsNCj4gCQkJZmNwb3J0LT5pZF9jaGFu
Z2VkID0gMDsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9udm1lLmMg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jDQo+IGluZGV4IDcxOGM3NjFmZjVmOC4u
NTcyMzA4MmQ5NGQ2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZt
ZS5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9udm1lLmMNCj4gQEAgLTM3LDYg
KzM3LDExIEBAIGludCBxbGFfbnZtZV9yZWdpc3Rlcl9yZW1vdGUoc3RydWN0IHNjc2lfcWxhX2hv
c3QgKnZoYSwgc3RydWN0IGZjX3BvcnQgKmZjcG9ydCkNCj4gCQkoZmNwb3J0LT5udm1lX2ZsYWcg
JiBOVk1FX0ZMQUdfUkVHSVNURVJFRCkpDQo+IAkJcmV0dXJuIDA7DQo+IA0KPiArCWlmIChhdG9t
aWNfcmVhZCgmZmNwb3J0LT5zdGF0ZSkgPT0gRkNTX09OTElORSkNCj4gKwkJcmV0dXJuIDA7DQo+
ICsNCj4gKwlxbGEyeDAwX3NldF9mY3BvcnRfc3RhdGUoZmNwb3J0LCBGQ1NfT05MSU5FKTsNCj4g
Kw0KPiAJZmNwb3J0LT5udm1lX2ZsYWcgJj0gfk5WTUVfRkxBR19SRVNFVFRJTkc7DQo+IA0KPiAJ
bWVtc2V0KCZyZXEsIDAsIHNpemVvZihzdHJ1Y3QgbnZtZV9mY19wb3J0X2luZm8pKTsNCj4gLS0g
DQo+IDIuMTkuMC5yYzANCj4gDQoNClBhdGNoIGl0c2VsZiBsb29rcyBnb29kLiBBZnRlciBmaXhp
bmcgY29tbWl0IG1lc3NhZ2UgeW91IGNhbiBhZGQgDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBN
YWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRo
YW5pCSBPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCg0K
