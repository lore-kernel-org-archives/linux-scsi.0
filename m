Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B61C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Feb 2022 03:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379106AbiBEDDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 22:03:34 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:41136 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233604AbiBEDDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 22:03:33 -0500
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2150U3fG007626;
        Sat, 5 Feb 2022 03:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=o9t4lJYdoGcBwDiDvziegDJ+kqnjV2B0t42fG923ieY=;
 b=VpqmY8n1PRZuytnBRNY2S4tG73+Pc7gQs+3YxSZSiDqspijiklMsoXTG/Ggh8bfcv5VE
 pTkbRECk473ccpEi6Hi4ZyTTYP1PS56eKRNKZLSicm8zFeNjObeXYXTRo3PfUU+JDcZM
 titHwbUmpFWzkSdhyAyQvPhmmQT5ZYkPPQL8acV43EMdQ/PN7ykraym51bW1N+5uzuuD
 TdzeCeoyMyilluIQNTBrAWM22A+sN2TSwjt8hKDXha8Sap5w8FeZ20D6YY5Tw4dSKj7R
 hW04DD6uMyplXBrQTMw0DQQY+hcV+KcC6OP70IoRrqQtB3TtLgB2EFzOIp+RbEwbWpDO yA== 
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3e1erdrstq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Feb 2022 03:03:28 +0000
Received: from G4W9121.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.210.21.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 07C4C57;
        Sat,  5 Feb 2022 03:03:28 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
 G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Sat, 5 Feb 2022 03:03:27 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.241.52.10) by
 G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Sat, 5 Feb 2022 03:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoydcH5arNlcL/nm5fYpmZRBslvwz6dGmbiEj679zag2l4TweLqVhKxAvpKv68XAPd5ugFmSYr7JGoPKWI7XjXwjfFsN58rYENnU3lwvlS+yGymunxyShIc6y9N+nJscce9QCsnVEhvfQADQVJJX1Y5B0genH2gXaFG814Rn3a23uBZc7xH7r/NCtSQviEcJIcv1JrPntPckSMZNs2C+Y2f0fk4TvihnDTSdcbtKs7aVpLo79LwSJfoeDbimIQ3TpoOwiHaB4HLxUfbhj5eqQFiHCGvSEO2S4MvMmRgTVYxDpG7VJJxMokw5d/+GGDdWoGGeV+j1Aop/bDNWxTQo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9t4lJYdoGcBwDiDvziegDJ+kqnjV2B0t42fG923ieY=;
 b=Sxgp1dLZ5Li9NvrOijb6PcBAACKeIxEAs8JtPvItkyKgX1bYeyo7ZOOvzu20Cn4AGQWugmYzNUJlPKPdvyVh7HvJLuAeg6siSa4//DrQfK+hh7MbDCpwfwgWZLMzci7kM+1SET9J/n9DpCWiFDPXDkmE3bALD+CwTVADJQR3ldmLYZ6qCODB/tecMn1vs25rnMq5GD2U0MltNdW7tjchv1mgAqNfj3Xvy3ukD8p8yiXE0AKEEO6LKymlVzc4NRG9f2ZpfiTN04WPD9+ivdV4qIqXLgSeGN0fYIvtLfVmKtMudwED3f9UFbEiPerkEaUqyoZynT0N3/SB0U8y2m/6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:434::21)
 by DM4PR84MB1901.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Sat, 5 Feb
 2022 03:03:26 +0000
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f8ec:1dee:fed5:f051]) by SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f8ec:1dee:fed5:f051%5]) with mapi id 15.20.4951.012; Sat, 5 Feb 2022
 03:03:26 +0000
From:   "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
To:     Milan Broz <gmazyland@gmail.com>
CC:     Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>,
        "Dmitry Fomichev" <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Subject: RE: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHYGXmiT1kBxk65DkuP81XVV9oHsKyDAvwAgAEozvA=
Date:   Sat, 5 Feb 2022 03:03:26 +0000
Message-ID: <SJ0PR84MB182225795091C5A502E6B6E7C22A9@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
 <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
 <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
In-Reply-To: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 354df647-d057-44e2-cc4a-08d9e854141f
x-ms-traffictypediagnostic: DM4PR84MB1901:EE_
x-microsoft-antispam-prvs: <DM4PR84MB19012BF4AB240A170AAA4CFDC22A9@DM4PR84MB1901.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XS0JsOI2BWADM+hf0rJfbRGh4q3lKvoZo9MCQxIeGhv7gh3Ro+mEw6jigpzZWBUKHtNBsut0ykZLkJupGkEpxjk9nRT/bvtLlm4xdhAww9pXtNnLSOfHxnvJBLMnpoxBeRulziKIVo5r94cace8PLV3EJToar/U46enuAir1rn/4RjgpbeOcCSoVCYEY1GevdqJ4A6gPe9N3YeZXt2fWrIQYZML7KEcF/o4KA1nVWix6hPuTSGIaLzd/+ccFfIWbm4PwRNkJGkGi4VvJHayj44N+sAInaglOVrtl+Qbgfw6PQobCzuHrKVCQvljbaztInNAA7miZU83LYJ2IUJ4kO0+iF7MPDpQMGcMOpVFN/WFl3mOLmEYCkuUql8Jx9a+BsjtiKcUZwlYITCFP2eqz2ULi67jiWv0s2LKL3beUL/riIWzYtAThinpX2FHI/bcxsMw+ehT1r+5UilagPiFlpIkwrx/g1gD4yMc6RTfW4PTLfSgSDv4RUY5+S5xy4JkYTfNJkwxfwsHyXXcPHPz4E/TM5BEB8PY1TwhLJEpftRSQiqW0OikvSXJ48QSEpV+WX1TbbKhu36oOTLjVYNGUsmb+75zbXPAiI+WT2l+4Pualj3s8sw/5H7MOJTmQMoftKyIF4mLPu/ZCyTaLRi/9VH1BB9EBR8rRzi1slGvM/Z+iWpvUv0heO/SmBt8JcF7E9yLmLisfL2MN80JpODFUnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(64756008)(8936002)(8676002)(4326008)(52536014)(66476007)(66446008)(316002)(83380400001)(38100700002)(7416002)(6916009)(54906003)(82960400001)(5660300002)(122000001)(9686003)(38070700005)(86362001)(186003)(26005)(2906002)(33656002)(508600001)(66556008)(76116006)(66946007)(6506007)(7696005)(71200400001)(53546011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlZNdjcxQ3pMMlU2T013VUJyb29iOC9aYm5oWSt5cjE0YUJrNDYzM1pPZXQ3?=
 =?utf-8?B?cmlSeGpzbXFQVFBScmVVb1lQTTV1a3dMUE1vSXAvV2drMzVSYzh2ZHk1b1h2?=
 =?utf-8?B?VWVOZnJJWUNiOEVwQ1hqKzdUR1Vub1ZMU0tHblB2SVFBRHVlTUozL1g0L3dI?=
 =?utf-8?B?MUJlMW1GQnN2VHcyY000RWhRNkRMZHVTaC9hN2I1WUxiVmIxWTZTTDV5OXMz?=
 =?utf-8?B?MWdNMENMVjBTYmFpUWUzbEYwVHFUOEFWZkhMWS9BcVNRMWIxRGJzWEFRVHVa?=
 =?utf-8?B?Z3FIS1lYWkJRR3dabWZtTkhEa2NqbkRQL3lUbTZZTTNZeXNDSlB0U3BMRGF3?=
 =?utf-8?B?bzBWMnpwL21OSUY0L0tKM2JRdnpFK25aYjJGVnpCNS9kaEE1MXB5SXViN2R4?=
 =?utf-8?B?eWNjdW43OElZOERyU3NGaDgzcHVZQTAvc3l3bXg0VTNyTjRZRTNKdXFXVW1U?=
 =?utf-8?B?U1RCS1pFRC91NFpsZHkyU0MrcDdPamh1QlFHZlBEeVpHVnJpY095NnFvU1JG?=
 =?utf-8?B?aGtRZ2lNQ0d2V3lKVlhhLzY1OFAzU0RtQkQrR3lOWStiRlNCL1hib0dlNWVT?=
 =?utf-8?B?NzhwVE1FcWNkQlpURVI3dFluQVVPTHQvbWtsMEprZndNWTQyTExvMzVRSDdW?=
 =?utf-8?B?bFFCSDlacVp4QzBqWmcxaEQ4cldFcXNIdi95MEVydUVJTWZ5ME9YRkRvZlZQ?=
 =?utf-8?B?VllGUDEyemdWTW9RNzRRQzFqaFAvUFpEbndvMVlaRlpCL3BOUXZGbm5IazVu?=
 =?utf-8?B?Y3NCWjJ1VjlLcERQeDZMbEtGZEJDVDI4TmV6S2hsTTl4eER3NVdQdFhCTVdM?=
 =?utf-8?B?VXUxd2dFUUlZdXpvb2hEbDl6N0tEcExvYnp5Sm03ZWIza0gvcWU1N2g3bEdj?=
 =?utf-8?B?VHY3R2N0Z0JlUlh0cGZ5eTJPRjNSRHBFcFloSzBmNDArb1UxeXg2dk9ZUnkv?=
 =?utf-8?B?bTMvcWwxbmsrektEYlhxbXl3ZFdaaTROaXRLNmhRMVZlbEZiSnpmdjdrYW1J?=
 =?utf-8?B?d0tCOVBzRmNSZGlweWxrelZWRjNxQ3MrcmhpQWtJa0FjaFZRc0VMdVlqNUVo?=
 =?utf-8?B?MERCWG5qVE14b2VRWms3UW9XM2I4Z1h5UDBrVlk1YWZKSDQyN2h1dWY3a0pW?=
 =?utf-8?B?bC9FSWFydXJ1NkNHOTIrUklNWlltbzRMQWE0OEl0SllBZXo1UUovakNaVE04?=
 =?utf-8?B?KzVpZXlYakpGZTdhVnROT0I2TDA2RzFWNFNsamhidXpQRlpFMG42MlkzWEdw?=
 =?utf-8?B?Z3VROUFRQkFLbjZoMWJSZWo2dzZ1QjFSa1VRd1BoVzgxNWxTWEU4Y0VHNmZH?=
 =?utf-8?B?WHdDVWFaT0NRenoxQmt5L3kycGlkTTJuYTV0MVpqMVM2bG9CUHg0aGJTNUM2?=
 =?utf-8?B?VENROGFzeGpmNHFBY2UwVUNlN1c0RnF1OTFrLzNGT3BnZ3hTTlBVQXE0R29O?=
 =?utf-8?B?bEFCS2U2ajJtaU1XRFp1VEJjR0UzamRhNjVXV0lJbm5wbzlackUzVVI1NU5V?=
 =?utf-8?B?UFVoVEZjMWFWekRBTnJyS2dCb0U5dkF5Nng5OVEwNlEydFNUVndYbStuMWJx?=
 =?utf-8?B?dzdlN2NLYS9lTEdDS1ZkdFphdEFDRDJXZ0pSUi9YbkRWeEVDUGdEd3JCOW1j?=
 =?utf-8?B?bFlkK1VKUWs0MVpralp2NXBiTGtHSDJ2Mk9RTFJvMUMxZ1YzTUtzdlJMZ3Va?=
 =?utf-8?B?YTR3cmwwc00vQm0xY1VsNlgwNzVMZkZjYTJwTExVSTFTSXN4WHJBZ1piczhU?=
 =?utf-8?B?ME9BNnN6aHNqTkhZTTdoR0wrdktQTDQxM3d6TVB6MzBvMG55UmFaNlBkenZk?=
 =?utf-8?B?bzEvdXJ6UDl3TnNhYkRVaHR5VStMWXBvOUNpQ0c5QWxFUnk5Y1VNV01Gbmcy?=
 =?utf-8?B?QXNNNUsrTzlNd0lybzdtRVZSVGtLNFhxek1FVXdKRVQ1Mm9YcGt0a3hIcCtz?=
 =?utf-8?B?YUdUZkwyaTZ6Q3VvWkUrUmt3MXpHNFZCdHF3YVhsbmF1NWlEY0pGMU9oRnBQ?=
 =?utf-8?B?TEJ0aHlhZkxhdWhqNnRVTVAxYXBxZW9HaEhTc28rcDZlbi9lK0Z5bzJ4aDhH?=
 =?utf-8?B?S01DVzZhdkVzcDR2Y1YyTGYwK2lRNmlJQ3d0TjBraFcyRCtxQnI5a1IwZ2xF?=
 =?utf-8?B?ck9KYU40OHZaUmpUcktRbkJQQ1N2NE5WaklxR3hFQnZDeldBQnZ6VDJJVzFJ?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 354df647-d057-44e2-cc4a-08d9e854141f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2022 03:03:26.1223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8K9a/xo9rcnygBRek/F6uES71BK1SGBxGkCGOca4FpHWN8Kmj8qwJ+0RHG/QAf8lP0ZOiD0N6aj3R90AJ6M4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1901
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: g9Vhed7E_CH_EKh3hukwc813oi6xoHVs
X-Proofpoint-ORIG-GUID: g9Vhed7E_CH_EKh3hukwc813oi6xoHVs
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxlogscore=971 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1011 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202050015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMDQvMDIvMjAyMiAwODo0MyArMDEwMCwgTWlsYW4gQnJveiB3cm90ZToNCg0KPiBXaGF0J3Mg
dGhlIHByb2JsZW0gaGVyZSB5b3UgYXJlIHRyeWluZyB0byBmaXg/DQo+IEV2ZW4gaWYgSSByZWFk
IGxpbnV4LWJsb2NrIHBvc3RzLCBJIGRvIG5vdCB1bmRlcnN0YW5kIHRoZSBjb250ZXh0Li4NCg0K
MS4gTGV0IG1lIGRlbW9uc3RyYXRlIHRoaXMgaXNzdWUgd2l0aCB0aGUgZm9sbG93aW5nIGV4YW1w
bGUuDQoNCkdpdmVuIGEgZHJpdmVyIHdoaWNoIG1hcHMgYSBiaW8gdG8gdW5kZXJseWluZyBkZXZp
Y2VzIHdpdGggNDA5NiBsb2dpY2FsIGJsb2NrIHNpemUgYW5kIHRoZSBtYXBwaW5nOg0KYmlvOiBz
ZWN0b3I6MCwgc2l6ZTozMiwgZGlyOldSSVRFDQpWaXJ0dWFsIExCQSAgICAgUGh5c2ljYWwgTEJB
DQowICAgICAgICAgICAgICAgMA0KMSAgICAgICAgICAgICAgIDENCjIgICAgICAgICAgICAgICAw
DQozICAgICAgICAgICAgICAgMQ0KDQpUaGUgVHlwZSAxIG9yIDIgaW50ZWdyaXR5IGlzIGdlbmVy
YXRlZCBpbiBiaW9faW50ZWdyaXR5X3ByZXAoKSBieSBnZW5lcmF0ZV9mbiBhczoNClZpcnR1YWwg
TEJBICAgICBWaXJ0dWFsIHJlZl90YWdzDQowICAgICAgICAgICAgICAgMA0KMSAgICAgICAgICAg
ICAgIDENCjIgICAgICAgICAgICAgICAyDQozICAgICAgICAgICAgICAgMw0KDQpBY2NvcmRpbmcg
dG8gdGhlIG1hcHBpbmcgYmlvX3NwbGl0KCkgd291bGQgc3BsaXQgaXQgYXQgMTYuIFRoYXQgd291
bGQgYWR2YW5jZSBiaXBfaXRlci5iaV9zZWN0b3IgKGFrYSBzZWVkLCBzZWUgYmlwX2dldF9zZWVk
KCkpIGJ5IDE2Lg0KVmlydHVhbCBMQkEgICAgIFBoeXNpY2FsIExCQSAgICBzZWVkDQpTcGxpdCBi
aW8NCjAgICAgICAgICAgICAgICAwICAgICAgICAgICAgICAgMA0KMSAgICAgICAgICAgICAgIDEN
ClVwZGF0ZWQgYmlvOiBzZWN0b3I6MTYsIHNpemU6MTYNCjIgICAgICAgICAgICAgICAwICAgICAg
ICAgICAgICAgMTYNCjMgICAgICAgICAgICAgICAxICAgICAgICAgICAgICAgKzENCg0KUmVtYXBw
ZWQgdXBkYXRlZCBiaW86IHNlY3RvcjowDQpTdWJtaXR0aW5nIGl0IHdlIGV4cGVjdCB0byBoYXZl
IHJlZl90YWdzIHJlbWFwcGVkIHRvIHRoZSBhY3R1YWwgcGh5c2ljYWwgc3RhcnQgc2VjdG9yIGF0
IHRoZSBpbnRlZ3JpdHkgcHJlcGFyZV9mbiBhbmQgaW5jcmVtZW50ZWQgYnkgb25lIHBlciBibG9j
ayBvZiBkYXRhOg0KVmlydHVhbCBMQkEgICAgIFBoeXNpY2FsIExCQSAgICBzZWVkICAgIHZpcnR1
YWwgdGFncyAgICByZWZfdGFncw0KMiAgICAgICAgICAgICAgIDAgICAgICAgICAgICAgICAyICAg
ICAgIDIgICAgICAgICAgICAgICAxNg0KMyAgICAgICAgICAgICAgIDEgICAgICAgICAgICAgICAg
KzEgICAgICAzICAgICAgICAgICAgICAgMTcNCg0KQnV0IHdlIGdldCB3aXRoIHRoZSBjdXJyZW50
IGNvZGUgYSB3cm9uZyBzZWVkICgwKzE2KSBhbmQgdGhlcmUgaXMgbm8gcmVmX3RhZ2VzIHJlbWFw
cGluZyBpbiB0aGUgYmxvY2sgaW50ZWdyaXR5IHByZXBhcmVfZm46DQpWaXJ0dWFsIExCQSAgICAg
UGh5c2ljYWwgTEJBICAgIHNlZWQgICAgdmlydHVhbCB0YWdzICAgIHJlZl90YWdzDQoyICAgICAg
ICAgICAgICAgMCAgICAgICAgICAgICAgIDE2ICAgICAgMiAgICAgICAgICAgICAgIDINCjMgICAg
ICAgICAgICAgICAxICAgICAgICAgICAgICAgICsxICAgICAgMyAgICAgICAgICAgICAgIDMNClRo
aXMgSU8gd291bGQgZmFpbCBieSB0aGUgTlZNRSBjb250cm9sbGVyIHdpdGggUmVmZXJlbmNlIFRh
ZyBDaGVjayBFcnJvciAoODRoKSBiZWNhdXNlIHRoZSBmaXJzdCByZWZlcmVuY2UgdGFnICgyKSBp
cyBub3QgZXF1YWwgdG8gc3RhcnQgTEJBICgxNikuDQoNCk1hcnRpbidzIHBhdGNoIHJlc29sdmVz
IHRoaXMgaXNzdWUgYWR2YW5jaW5nIHRoZSBzZWVkIChiaXBfaXRlci5iaV9zZWN0b3IpIHByb3Bl
cmx5IGJ5IHRoZSBudW1iZXIgb2YgaW50ZWdyaXR5IGludGVydmFscyAoMikgc28gdGhlIHRhZydz
IHJlbWFwcGluZyB0YWtlcyBwbGFjZSBpbiBwcmVwYXJlX2ZuOg0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBpZiAoYmUzMl90b19jcHUocGktPnJlZl90YWcpID09IHZpcnQpDQogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGktPnJlZl90YWcgPSBjcHVfdG9f
YmUzMihyZWZfdGFnKTsNCg0KMi4gQnJvd3NpbmcgdGhlIGNvZGUgSSBmb3VuZCBhIHNuaXBwZXQg
b2YgYWR2YW5jaW5nIHRoZSBpbnRlZ3JpdHkgc2VlZCBkaXJlY3RseSwgd2l0aG91dCBjYWxsaW5n
IGJpb19hZHZhbmNlLT5iaW9faW50ZWdyaXR5X2FkdmFuY2UNCkkgaG9wZSBpdCBkb2VzIG5vdCBp
bnRyb2R1Y2UgdGhlIGFib3ZlbWVudGlvbmVkIGlzc3VlLCBwbGVhc2UgYWR2aXNlLg0KDQpEbWl0
cnkNCg==
