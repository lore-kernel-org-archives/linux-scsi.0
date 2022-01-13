Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C767C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jan 2022 11:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiAMLNz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jan 2022 06:13:55 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:28484 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbiAMLNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Jan 2022 06:13:54 -0500
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DAJsGr012629;
        Thu, 13 Jan 2022 11:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pps0720;
 bh=wpsUnUryXsqnRk913J9DCEHhZ7IOS+VB3CZZ0tL3C+s=;
 b=D0h8dW2ZCEp8QwT9n741syE70aMU+06vjXaVuNcvCx+CoMGtNxS8wu9iusU0RDyOaYZE
 i++/jVXbvSSgBXeMj6QcRdBvCI4v3mMZZm3pXwv6PwaG8k1KWeO0HkysfAXu7Z5EV0XQ
 KOwIvXUmF8dZvScpLMbqNI+4QjOPGrLPK18Aeg3lBwgIpmFuNtLF6c7gpNApY2VOgwzP
 tBpwbxlAQOPRBXrdGzIkSOER+Ob/xId4jbs7G5+CRNqiLTQnOi9uD584mTs53BWbFUPp
 yTfdI/ZCbMSsMhDFqidibDPUYTR0aoMRUuU/CkH177vavxZlS7A+tmCj/oe5ie7qBP6z Fw== 
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3djj7egcat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 11:13:38 +0000
Received: from G4W9120.americas.hpqcorp.net (g4w9120.houston.hp.com [16.210.21.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2354.austin.hpe.com (Postfix) with ESMTPS id C5F3DA8;
        Thu, 13 Jan 2022 11:13:37 +0000 (UTC)
Received: from G9W8454.americas.hpqcorp.net (2002:10d8:a104::10d8:a104) by
 G4W9120.americas.hpqcorp.net (2002:10d2:150f::10d2:150f) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 13 Jan 2022 11:13:37 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.241.52.11) by
 G9W8454.americas.hpqcorp.net (16.216.161.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Thu, 13 Jan 2022 11:13:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nq2gtcDgqTDyLqksTESHDAZ5mrK+VgRaDga3rDuHi9TbE4Msd0wC7+IRtQbGDBinlKh0MONDuPKXiAvPkEFenC9AaEfVyTqkJu05vRkfBBQwtJ57U1d5kiKtsRWzJ/78timhKs98sUya33Sq6IxI05DnaRwBm3RDv6evEtFSxeww7O6/gAn4hVuWa/f/WYBC4jXW7Bapu0L4pw+LhGu6WQ+9bUdWWkPitgXzqG2hp36axCGU7Agh3J+/CJMHBP4LdxVONUftXNGNlyHIlmGjwqSzBUKBfVkOZkSuHsbItBdGA0DQc4whRlv401ORlszW3k3H/QgVgRjElMQtZgY8MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpsUnUryXsqnRk913J9DCEHhZ7IOS+VB3CZZ0tL3C+s=;
 b=gp3tmk1Wuzax+ALj/YV5JXWS18qzdd0N3s3OgTcAVo18hFVRpxj952dIvyR4pdTfPaxMx1H3+2bRhRgjawh4p6/Z6eR5NUICZWjkjLQzf2rH5PVjRAVngVjQu57OrumTUetrH9X6njxUyitgtv7h5FASH88KSmHi193er7nKn8lEB+U6Oe+AZp/n541c/dPNUvECyyKLqEz0E/88nJvUjBwn+h3IfngqDu+93fLUpJHZczBM0EoY7GFw1cMlPV2jFfygC2i3ylMTxEM/jTFAKrQgFstP6SKyUU/TxR2W9jF0cmmTP0cyyFPOXO2mmcIpOY7AEINnPsrNpm1wRSvy6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by PH0PR84MB1526.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 11:13:36 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%5]) with mapi id 15.20.4888.009; Thu, 13 Jan 2022
 11:13:36 +0000
From:   "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        "Dmitry Fomichev" <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHX9ae9F1LvItF/X0quij8FY4R836w7kj8egAY1AgCACJX2AIAWxvkA
Date:   Thu, 13 Jan 2022 11:13:36 +0000
Message-ID: <71B870D7-16B9-4299-ACB0-F4B6D5188C70@hpe.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
 <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
 <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
 <b16b20d3-fd5e-ce5c-f744-be5022b4156f@opensource.wdc.com>
In-Reply-To: <b16b20d3-fd5e-ce5c-f744-be5022b4156f@opensource.wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f10f7eaa-1f25-46e4-4864-08d9d685be7a
x-ms-traffictypediagnostic: PH0PR84MB1526:EE_
x-microsoft-antispam-prvs: <PH0PR84MB15266E4496D912360201EB01F7539@PH0PR84MB1526.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9QkViu1J4yBRsli54kqocflPF5aBB9lSzPA8HfE/r38Qxio6UbI99AUxOX1oe27BHNaQez/uJSdGu0EAHGfXwrH4RTLQ4RVF7rtzeePBLNuDbAvR6v1ixC4VL8XPE+7SpOi7uSCfPU4WwRSREVzNrb4Tk2B4M3hpMWXG2V3oh8JOAWDugKFR/9J3pf9oNd2rKufaWt1/tMOylN0K4eacyc+xn9iSTRG0ErSdeHOvjFX5/77Vq07B7CF/amaDJvFzCS20hSmEvgj9Zz8zaT9WoHmPCJPS0G5wjEnO5NZE8mW05d4Tc6dmGgFogcsz7dVXhh5qvZ+8bKLU33Eh7CtMNArRMi9PIrhvUNv7L8W42HAfT++8qPjpKB6fSYCtd/VvOAD9dOMLROT6USN9OfNU3QIpzC0qBRBLRZFPStKJesB6rI9H3vjtW/sHOcqnKZ8DdUEZB+VqC+H7gBIK8KcET7HKAgM52sAHUULYRnMFyqIPQ8SW7eN2rrAO0yN721loVDzeObP6NxaNvP5ojJg3mR3S3Z9DVFzzFB3RBw28Fxqt3NKoO1BB5KyJPF6RyVidJD8cDMKvC+V/TWxtVw2aMZPSwOJkKXSl0t4g9sjXz+V/M3FyD9LUN85Y83igcfxdAKHupf1jMhVqqoCNpwj/Skf0kenXaJIr2S/yiLyDlrp7pdEBgf/DjCT0OS1RYdvbyXwY0YJi3lduWVtPchk09Y09gW9CD+oEgfbNLXkOxQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(4326008)(86362001)(316002)(83380400001)(54906003)(82960400001)(2616005)(2906002)(8936002)(122000001)(110136005)(33656002)(5660300002)(8676002)(66946007)(6486002)(53546011)(6506007)(66556008)(66476007)(186003)(38100700002)(38070700005)(76116006)(91956017)(66446008)(71200400001)(64756008)(36756003)(6512007)(508600001)(26005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmVyNmMvWVhlQSt5NnZxZ2dSaVNWWmF5dXB2R3V6ZEc4bkFwQnNiQXNSSUh2?=
 =?utf-8?B?OW1vdFhXc20rR3dZbHZqNWJCZkdUS2g3R0JGQmlaK0duWFdPUkFGcWF4bWZT?=
 =?utf-8?B?M3lHS0hNd1ZEbXNTbVI0RjVMYzZDL05TODAwWkl5dUd5R0k2aWx0Rzdhdk1B?=
 =?utf-8?B?TGV1RlZ3dnhIaXZqMDZXSjAxajJpWEY4bWN2S21mQThDN3hUcEtEd1NOK25Q?=
 =?utf-8?B?dGFtalg1cmM4ZHZ5ZkVRVUU4WEdxSE9DcFE4UXhva2s3ZTB4V1ZEMzBjNnkz?=
 =?utf-8?B?Q3dHcnZTTGFCNldQVSsrZGpVcldMdkExajJJejdianorVis1MFdRMlZaZEUw?=
 =?utf-8?B?Yk9ZaFRRcUNWd20zUmZPa0NvWDR3aEZHaU9NVG5BMk1CcmJtNDN1UlhjWmsw?=
 =?utf-8?B?Vkpuek5nWkkrOXE1UFM1ZVZ1MkZUaTZiZENScVFNNHZkbnUxVHA2cVdaaFc4?=
 =?utf-8?B?STJEcnFDRkFZSHZ3V0llYzViMjJ4bkg5Y0RlRFUvdWd1dHp5RGkyb0xFMTlT?=
 =?utf-8?B?SlhmWnhEUEkyaDMwdEZVcWxNSzFkU2tnTUpVRjVySDFqVWdIVk9pMFMwQmxl?=
 =?utf-8?B?RDhrOGoxbDFDMFdtM3pxR0l1VndEQXU1blBrb2M5bHpvOU1xWmdVeGwrWHhz?=
 =?utf-8?B?WFBlS2p4bzFsSU8ybGEvbWNsVzhiVDlYb2hyM2txU0prNkJXWnV2bTJ5RURZ?=
 =?utf-8?B?VFYrVFlYZ0lrUGRsT3FINENMRFFDUGJKbktqeVZWWmdUOUE0aDNjODBqQU4z?=
 =?utf-8?B?eFVrdTk4UTBsTEhyWkcyYW4yNEw5TWhFSmEvSTVzdnVGVGJZTmcxREYySEp1?=
 =?utf-8?B?bU42blRWWXQxYis4N29IZFNzRENCZE5nemU5d2JNM2lCTzVyTHFnZjlJbW5F?=
 =?utf-8?B?S2o0MG1jOThmN3A3M2JjNW9rRStaMDlKOFVza2orN0hkNWRDYnozU1o5dnBO?=
 =?utf-8?B?WG9RRkxYZmFySjd1TVJ1b3oyYmFQb2dVRDNzajdvL0x0N2lsSGU4UUtjMkJw?=
 =?utf-8?B?Vmd3S2M3UkVjcjVSdk0wbFZxVXhYa2N3SDdJYUdBR2JDMVdYdytlcmFkcWpZ?=
 =?utf-8?B?dGNGVnF2WkNWSUZPR2FKaHhEQlJsOFA0bU96YzhWZjFwZXkyeWNIcmhwOGho?=
 =?utf-8?B?QmErZTZVelYzVVpia2RuVEMvS2NWK0JoZ2p4RkZZdWw4SEFVUDlZOTBhT1VY?=
 =?utf-8?B?NzVaWTkwalBlam9kZmxSeDlwMkZNVGFmSXduR3NlTi9LY3pCR0dIczNUbmZF?=
 =?utf-8?B?am1QZXNZQUpHSjNzR0hJelN2RmQ5K3pESkgwd3g4VS9wOXpKUGJiNWVjYm1L?=
 =?utf-8?B?KzZ3V0pjUUl6QXpQNnZCSGk0NU0wcWdnM1MwQy8yeHladWlQbUNpbGM5Uk5X?=
 =?utf-8?B?cHRmRVFkRnFzcVBpYzZ1cDlFcTVQTDZoZVpObUJQN3N6SHpaSHNWTlpNZ3Rh?=
 =?utf-8?B?MUtyY0tkL2p1czFrOFE2KzcvZEV1Ly93U2MveWp6QVBVVStHdUNFeEdGMmEv?=
 =?utf-8?B?a1Y4d3R1Y3puQUNId0xlMnBHMGgxZlVIYmVnTFhja3FHV3EyTmJHTDJjYVc3?=
 =?utf-8?B?MEVwU0FXS0lRUDF2RG04YVJNY2FzSWlqYmZqdjdWdHp4VXdFeVQyZUZodkhO?=
 =?utf-8?B?dThIY2pNcjFDTTBueVdTYkIvcXpsaVFpSGRXZ3Y1bTBPR0ordmFIMUJnRkR2?=
 =?utf-8?B?REVpQ1VaZkxyYWY1SVMxOXRQcEVVWUJ6TG5TYjhEbkpVM1BnUnRYZHdHbEls?=
 =?utf-8?B?VFRvd3p6SVluZjJ6alZaWlF6Rlpybll5bVFDUVo5L1BNYkp5YTAxd1NxOWZt?=
 =?utf-8?B?QzJWeVRURnZWOUVUVEJDM2tnRnRkWjIra1lCRDlxVFhOeUtQb3doVEpiUWZ4?=
 =?utf-8?B?WGg5cVFocm80UGNwTGJIUnQ3QkVLVnVyOFZNVzlIWkRlbTRRR0lBQUVBVDJ0?=
 =?utf-8?B?TGNHS1N4dzBTd0xydk96QVRkQnRJdHNLSGpsMkxlMnlpcXBQeXlrdGJiRERT?=
 =?utf-8?B?L3pEcmlEU0hIMksrYU43UnFQQUpSVTRNR3RqczFwVXh4QWJKRjRKU0k3NEpV?=
 =?utf-8?B?WkhVMGt6YUx1dGh3elEyUjBhYmFmTllwTDk0dEpuaEhsbEFvYnhXOGdYVVJF?=
 =?utf-8?B?T25TYkV5MVBUczJseFdoVnNyaFBMbVlEaGk5Z283elZQMGx5TUtDNDkxOEdH?=
 =?utf-8?Q?7YmojFikdyqRzTEziJdZ0Xg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24DFC1C77572D743ACB7B4FBD0617A34@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f10f7eaa-1f25-46e4-4864-08d9d685be7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:13:36.3065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hn+WYrYkJlRKBdcSwpo1K3iTsN1PE0sZKlzHbuC5qhSRXlMjQveFjWyCuRpLJvXLqUzEE2lkM1zWp0qqJ1cD4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1526
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: juFxDndSZqC9tAIXE6CICVM7axq6awrU
X-Proofpoint-GUID: juFxDndSZqC9tAIXE6CICVM7axq6awrU
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130067
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UGluZyBmb3IgcmV2aWV3Lg0KDQrvu79PbiAzMC8xMi8yMDIxLCAwNToyNCwgIkRhbWllbiBMZSBN
b2FsIiA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+IHdyb3RlOg0KDQogICAgT24g
MTIvMjQvMjEgMjE6MTYsIEx5YXNoa292LCBBbGV4ZXkgd3JvdGU6DQoNCiAgICBUaGlzIHRocmVh
ZCBzaG91bGQgcmVhbGx5IGJlIGFkZHJlc3NlZCB0byBsaW51eC1ibG9ja0B2Z2VyLmtlcm5lbC5v
cmcNCiAgICBhbmQgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcuDQoNCiAgICBBZGRlZCB0byBj
YyBoZXJlLg0KDQoNCiAgICA+IE1hcnRpbiwNCiAgICA+IA0KICAgID4gU29ycnkgYWJvdXQgZGVs
YXkuDQogICAgPiANCiAgICA+IEkgZG9uJ3QgYWdyZWUgd2l0aCB5b3UgYWJvdXQgVDEwIFBJIHJl
ZmVyZW5jZSB0YWcgaW4gY3VycmVudCBjb2RlLg0KICAgID4gdDEwX3BpX2dlbmVyYXRlIHdvcmtz
IHdpdGggdmlydHVhbCBibG9jayBudW1iZXJzIGFuZCB2aXJ0dWFsIHJlZmVyZW5jZSB0YWdzLg0K
ICAgID4gVmlydHVhbCB0YWcgbWFwcGVkIGludG8gcmVhbCB0YWcgbGF0ZXIgaW4gdGhlIA0KICAg
ID4gc3RhdGljIHZvaWQgdDEwX3BpX3R5cGUxX3ByZXBhcmUoc3RydWN0IHJlcXVlc3QgKnJxKQ0K
ICAgID4gLi4uDQogICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChiZTMy
X3RvX2NwdShwaS0+cmVmX3RhZykgPT0gdmlydCkNCiAgICA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBwaS0+cmVmX3RhZyA9IGNwdV90b19iZTMyKHJlZl90YWcpOw0K
ICAgID4gDQogICAgPiAuLi4NCiAgICA+IFNvLCB3ZSBuZWVkIGp1c3QgYSBwYWlyIGJldHdlZW4g
dGhlc2UgZnVuY3Rpb25zIHRvIGhhdmUgYSBnb29kIG1hcHBpbmcgYW5kIGdvb2QgcmVhbCByZWZl
cmVuY2UgdGFnIA0KICAgID4gT25jZSB0MTBfcGlfZ2VuZXJhdGUgaGF2ZSBzaGlmdCBhICJ2aXJ0
dWFsIiByZWYgdGFnIGZvciA0IGl0IG1ha2UgYSBiaW9faW50ZWdyaXR5X2FkdmFuY2UgdG8gYmUg
aGFwcHkuDQogICAgPiBBbmQgdDEwX3BpX3R5cGUxX3ByZXBhcmUgYWxzbyBoYXBweSBidXQgaXQg
bmVlZCB0byBiZSBzaGlmdCB3aXRoIDQgYXMgc2ltaWxhciB0byB0aGUgZ2VuZXJhdGUgZnVuY3Rp
b24uDQogICAgPiANCiAgICA+IFRoaXMgcGF0Y2ggdGVzdGVkIHdpdGggc29mdHdhcmUgcmFpZCAo
cmFpZCAxIC8gcmFpZCA2KSBvdmVyIG92ZXIgTk1WZSBkZXZpY2VzIHdpdGggNGsgYmxvY2sgc2l6
ZS4NCiAgICA+IEluIGx1c3RyZSBjYXNlIGl0IGNhdXNlZCBhIGJpbyBpbnRlZ3JpdHkgcHJlcGFy
ZSBjYWxsZWQgYmVmb3JlIGJpb19zdWJtaXQgc28gaW50ZWdyaXR5IHdpbGwgYmUgc3BsaXRzIGJl
Zm9yZSBzZW5kcyB0byB0aGUgbnZtZSBkZXZpY2VzLg0KICAgID4gV2l0aG91dCBwYXRjaCBpdCBj
YXVzZWQgYW4gVDEwIHdyaXRlIGVycm9ycyBmb3IgZWFjaCB3cml0ZSBvdmVyIDRrLCB3aXRoIHBh
dGNoIC0gbm8gZXJyb3JzLg0KICAgID4gDQogICAgPiBBbGV4DQogICAgPiANCiAgICA+IE9uIDIw
LzEyLzIwMjEsIDE5OjI5LCAiTWFydGluIEsuIFBldGVyc2VuIiA8bWFydGluLnBldGVyc2VuQG9y
YWNsZS5jb20+IHdyb3RlOg0KICAgID4gDQogICAgPiANCiAgICA+ICAgICBBbGV4ZXksDQogICAg
PiANCiAgICA+ICAgICA+IHQxMF9waV9nZW5lcmF0ZSAvIHQxMF9waV90eXBlMV9wcmVwYXJlIGhh
dmUganVzdCBhIGluY3JlbWVudCBieSDigJwx4oCdIGZvciANCiAgICA+ICAgICA+IHRoZSBpbnRl
Z3JpdHkgaW50ZXJuYWwgd2hpY2ggaXMgNGsgaW4gbXkgY2FzZSwNCiAgICA+ICAgICA+IHNvIGFu
eSBiaW9faW50ZWdyaXR5X2FkdmFuY2UgY2FsbCB3aWxsIGJlIG1vdmUgYW4gaXRlcmF0b3Igb3V0
c2lkZSBvZg0KICAgID4gICAgID4gZ2VuZXJhdGVkIHNlcXVlbmNlIGFuZCB0MTBfcGlfdHlwZTFf
cHJlcGFyZSBjYW7igJl0IGJlIGZvdW5kIGEgZ29vZCB2aXJ0dWFsDQogICAgPiAgICAgPiBzZWN0
b3IgZm9yIHRoZSBtYXBwaW5nLg0KICAgID4gICAgID4gQ2hhbmdpbmcgYW4gaW5jcmVtZW50IGJ5
IOKAnDHigJ0gdG8gYmUgcmVsYXRlZCB0byB0aGUgcmVhbCBpbnRlZ3JpdHkgc2l6ZSANCiAgICA+
ICAgICA+IHNvbHZlIGEgcHJvYmxlbSBjb21wbGV0ZWx5Lg0KICAgID4gDQogICAgPiAgICAgQnkg
ZGVmaW5pdGlvbiB0aGUgVDEwIFBJIHJlZmVyZW5jZSB0YWcgaXMgaW5jcmVtZW50ZWQgYnkgb25l
IHBlcg0KICAgID4gICAgIGludGVydmFsICh0eXBpY2FsbHkgdGhlIGxvZ2ljYWwgYmxvY2sgc2l6
ZSkuIElmIHlvdSBpbXBsZW1lbnQgaXQgYnkgYQ0KICAgID4gICAgIGRpZmZlcmVudCB2YWx1ZSB0
aGFuIG9uZSB0aGVuIGl0IGlzIG5vIGxvbmdlciB2YWxpZCBwcm90ZWN0aW9uDQogICAgPiAgICAg
aW5mb3JtYXRpb24uDQogICAgPiANCiAgICA+ICAgICBTZWVtcyBsaWtlIHRoZSBzcGxpdHRpbmcg
bG9naWMgaXMgYnJva2VuIHNvbWVob3cgYWx0aG91Z2ggSSBoYXZlbid0IHNlZW4NCiAgICA+ICAg
ICBhbnkgZmFpbHVyZXMgd2l0aCA0SyBvbiBTQ1NJLiBXaGF0IGRvZXMgeW91ciBzdG9yYWdlIHN0
YWNrIGxvb2sgbGlrZT8NCiAgICA+IA0KICAgID4gICAgIC0tIA0KICAgID4gICAgIE1hcnRpbiBL
LiBQZXRlcnNlbglPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCiAgICA+IA0KDQoNCiAgICAtLSAN
CiAgICBEYW1pZW4gTGUgTW9hbA0KICAgIFdlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaA0KDQo=
