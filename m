Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E56C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 07:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbiBDH66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 02:58:58 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:17418 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239871AbiBDH65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 02:58:57 -0500
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2145c0RT025527;
        Fri, 4 Feb 2022 07:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pps0720;
 bh=aRtZOoO3ocnaB+K6BW/9Rf2VsbyBF0lewrzZcqfyLxE=;
 b=IV9voubSicOOCGTzzDHJZDMe8GjpGxWLnsssNYaQW1xyb8k+Oun4EESQQM+M7pJIxTpU
 FsxorhZ3a8IIvdGlaqDnOx9CWQqzBjUP0bFOU074UPSf9hAiMJvBS6zCwrnE6G5rRwcW
 2gjdFgglzICZnVTy/8TANRH2sMcgsXYtJRaIm1at1Tcqyl5+Hmu1gcof2DyWbJTUwvLb
 2NsXk3SD5orATFHFfyYSxp7Mz4zLD7n0SjU2AIf2GsQx2UAB8DhizY3JyK2lbfWJ2T76
 xZfT5noMs4JAA/7pey80vGSDiC6yNzCMk3AfuPHw5Gga3J9ednVnXMq5gRAjGBu5095n 9w== 
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3e0x5grtyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 07:58:52 +0000
Received: from G2W6310.americas.hpqcorp.net (g2w6310.austin.hp.com [16.197.64.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5008.houston.hpe.com (Postfix) with ESMTPS id C17284F;
        Fri,  4 Feb 2022 07:58:51 +0000 (UTC)
Received: from G1W8108.americas.hpqcorp.net (2002:10c1:483c::10c1:483c) by
 G2W6310.americas.hpqcorp.net (2002:10c5:4034::10c5:4034) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 4 Feb 2022 07:58:51 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (15.241.52.12) by
 G1W8108.americas.hpqcorp.net (16.193.72.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Fri, 4 Feb 2022 07:58:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlBhWNIeoLR4o2RdBVmMy9ubvksx7n0WfXvYZZHw22LYtrHDygvooLXqGIk/rn9KkKPZKwjPf+FX+9qPHsxD52jr6eV60FmSoJkutC6hBjwVhJHvv5c9eZRoUAWE7gK26vaqGpRGGXGAL/FR0H2HxaaZVT2vmzKQNF6o5s3w5yQcQXmF4zSFrZW6Y5mWd5zQPgNZCbhU9D0L75nTofLPRu/KA9HJ2+A1+TMngeMuOQ1ltmYSfOZh7UDTnWbVUh2iEMKLjs0Kx3jgc9UUs9qAlkxQYmpJ9KOHk3ogtM+7x8DJDuK7qqHiUjvP4gEozhv8uRFaJizOPLAYJV2A6YEYEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRtZOoO3ocnaB+K6BW/9Rf2VsbyBF0lewrzZcqfyLxE=;
 b=jNRFxcvyNm9ojKfqdBKgjcHekCZ+I98BTxB8y2M90kzMORvr9GuzB8tFNCB1jcTo1eLqLRuS4WyQok1I51HYowkCyuG8yQboIpQgrEDvuA7nkAJqQvOKUViV4U87Zxwxhg7wrO/AXSUlzRjjy3plfVU9aiBv5UVKs20tV6u407k72DT+UeXFQPo2kUABSyChHtqAijU8Wt8SHGWuaPz9U9O2fvBV/lV85m2J7ZfetbB1gL8/oQ3JAZAekSmfRhaj6fWQRaHE3AQ0nqBZsALRxlENKo6ZnMPhdZ318ZXfQSuJ4QKZSy7X1g4YekGI0uLJi5xNuymxJHjAQlLX2VWQYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by DM4PR84MB1709.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:48::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Fri, 4 Feb
 2022 07:58:50 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%5]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 07:58:49 +0000
From:   "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
To:     Milan Broz <gmazyland@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
CC:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHYGXmu8xbekrL+u0uyE4tyb91/SKyDAvwAgAA2bwA=
Date:   Fri, 4 Feb 2022 07:58:49 +0000
Message-ID: <C86CF721-6C22-4382-842C-0098BD9D42DE@hpe.com>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
 <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
 <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
In-Reply-To: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03ff2633-5461-4bd4-ccde-08d9e7b42de8
x-ms-traffictypediagnostic: DM4PR84MB1709:EE_
x-microsoft-antispam-prvs: <DM4PR84MB1709393B574AC82F62EAEFB9F7299@DM4PR84MB1709.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lKk+CL4ytkxuym5pJntRWV1ayhxI+U9appW7yMWa1tNPnSAVrHH+jb80qcnbqfg9m8I098+bl144MW+A/jPt8VdLIxfR25+FZ18ojMRl/NEwiB1NC7HbSPSzZcuJ2z5hiXmpzsXuBpjo7uffHQUe0NRJk4yXWkIwbR3xBy8QjiWqwN6ieAnFg3wRwmQI3gdyzQr1twff4ps8bv1SuTqWX9IVuALzhWUkcgYTcV4YERhboyjnH2KWNgj8ztoI7oqF9J6rjtsXosBRENUIn36QWpZRQuoiR6wT2W2bjWrqRVGkib1X0Na4k2+a5B1JjJ1Zv0SKnWR5RRUu+Ps8nvhnqlOkpQNNFXoFvyk+6ltRm9uFft9kiJowSu8olI8wJPCLxyiRR928Vy3u4tpWqlET0O6NBStsqwgQNQMy3ZR2wWP5mFuUw7DLsydxOigUGr+k5aH3HE5KzoqJp1abQqdnON3isZ5pW61yHKtLs9oTIWau8eO8+jFgUX3rQhEWr7btkxrwtA57DKnFszZGlnY9tqxoOOEWKZrVnNYeyOXFnEGMYJqY6kWrTZ/icsdmbU8H/loWlUniwMF8Ogr1s4DsSwSqmX2fzoSchtW1Kr21IJRZQbl4+eodPqZ/DLzLpH0DsSGKMJfF38/CrYuWmS/7fSykXOoZqL68/2yfH/LttU74l45PmVcOC0DH8lhu54GiAuEfuACSUANLePLC9X91FS1R9locnupt+ovTB3ReIcM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(66476007)(66446008)(6486002)(186003)(76116006)(8936002)(4326008)(26005)(66946007)(2906002)(2616005)(82960400001)(6506007)(6512007)(64756008)(8676002)(53546011)(71200400001)(38070700005)(7416002)(316002)(6636002)(110136005)(54906003)(33656002)(508600001)(38100700002)(36756003)(5660300002)(122000001)(86362001)(83380400001)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm00UGhBcm9XQ0xtdGIvRk9PcmUrZnVaY0ZGVjNPYkFLVU5PaVBINVNXb2RM?=
 =?utf-8?B?Z3pZRmIzc3A2d1cvcjdONXcvZThQbTJQb1VVTmszZ0kxdzJvbk5SN0JaRC9P?=
 =?utf-8?B?QTYwaGZZaXJSaDFKVHhqZEhwSHZ2d2JOVmxiRmZFUWVtMmJEd2IvYnp3OVBF?=
 =?utf-8?B?bmxxL2dXOG11OUtpRzYyK0xub2FESzg2Zm1XcFhtTFB1YTB4RDNJVTJGYkJT?=
 =?utf-8?B?VTk0aWJ4OFJja2FwVnZpcXZFZXVxTVFhanZXOFpUUm9Mcjd4elYwT0pmWGp5?=
 =?utf-8?B?cDRGMFE4RTFsdU5qZml4VGdrUzJGbU1YaHBJSk54aWdOM0UxazJ4R1ZZRFhh?=
 =?utf-8?B?clROd2d5cUtaekF3cmwwTUJaZ091OGQ5TGtaSzZIQVk5cjRUd3k3VXFVM0xi?=
 =?utf-8?B?dFoyNzlSeWhyWGVmTURhR2gyaHdzb0FDY0FXQ2hwbUI0TG9TaGY0RTJPRCtK?=
 =?utf-8?B?KzlXZEFmajJvMWJiK1RIczd3Rk96Ymh6K05uL2hUL2JPLzk4RTZiN0RXamUv?=
 =?utf-8?B?TVdUUEt0OHIyL0FRZWIvNEg3YUtITHdkZlYxVGVweUljdVpINHdNc3Qxdmha?=
 =?utf-8?B?SDg4Uk1YdC9kUzYvUHRUU0RKS1hqZFlKTHZhZTFsRkVNaUV3YXNJMnRlUUww?=
 =?utf-8?B?RmZqeUlmODYxdStlY1FmcnJSNjdjRWUrbTlrSmhPY2I1S0xTbnJYK1c1Q0F3?=
 =?utf-8?B?aDhCalBqbU9lQXBNQ0dlN3pRUkU4NmtEbVJxaVRCVHNHTWlaZWp0bnFpTlR5?=
 =?utf-8?B?Y1k0LzIwRFpMTjQxYkV2em1OOHdFZk80WVZtbm8yT2F4Y0J1Nm1sbzVFbGEv?=
 =?utf-8?B?L0cwRTRQZk1TNFFzZnZYVUVGK0RGeGJaQVQyK0NjbFNzYUsweGltbUpIVTN0?=
 =?utf-8?B?WWdudTFKbDFOZDV4OUcvZWRJaDlIbXBiQnlyNnY2b0lDMVg1WkVGSkpDU2dr?=
 =?utf-8?B?Q0tRcmI5enhEVnhlcUt3RjROck5rZDhldVJQVVJqZWg5ODkzeDZPeWFnTHR2?=
 =?utf-8?B?RW1XMTJTMFJHMkhFNDhzYnV3V1dVajRVRHNUT1R5VWcwU0hDcXhiZDczNWJL?=
 =?utf-8?B?UWZFdXdrbzNTbDM0dUtpRisxMzM2MktIZ29ZTElROTFMRXYyaW03T3dLa2Jv?=
 =?utf-8?B?T1pXS25wcU1RWS81TDFxSTY5TU1HVUdEaXpmaUd3aldPZDl1MGFCcisrb2Mv?=
 =?utf-8?B?RXl1Nk1uZVdGQ2loa09LSys2YWpPSldsdFd5a0Z1VnVsMnhNZEErQXBIbW5D?=
 =?utf-8?B?L01OQWlyNlhJR3o2RGE3dGEyWVc4U2k1b2w0ZUZBYnVlM0VSZVMrZWdudkE5?=
 =?utf-8?B?c25yL1pmRWhmenA0M09sYU83K2ZkdnBqbmNydTR6ZTh6SnV3RUkzL3NqYUVn?=
 =?utf-8?B?WWJGVlhPSGZMMTNHUXEraTNqUTQwY3RQNW9qeCtMMTlrdUh0S3BQUGx0eDAv?=
 =?utf-8?B?Y3ZoL2lXdmdKV2F2dmdIUHZzTmJoR1A5UHNVS1dockJJS2I0UktrOFhLeG5G?=
 =?utf-8?B?UFUyQXQ2WW1kOTNLdjAxbG5pSUZLejhWWnV3OHh2MVVYVENuNXE2M2hzcER6?=
 =?utf-8?B?ODlXVGVleU1RaWNCNGtxdGE0a29pMnR1NkNnMDZRLzB1MkdTdUJtNGhseXh5?=
 =?utf-8?B?bXpMOWxrSm1PS1ZHeUZRWUsxZlA3cG0zOFg1NjBQaFlyMy85R2k1YS9IZG1M?=
 =?utf-8?B?YmpNcmVtWjl3c2lvendCZTZLQnlQaW5NbENRaXQ4cjYzcjhwRytrOG1Zamc2?=
 =?utf-8?B?WkZHeUtkQVVyazBld2ZzeGVWRGVuK3RrOXY4dVlaSUJkL0VqWXZpelZjTS91?=
 =?utf-8?B?QkgvWVJlMzNiMkhFTVN3K0Y5MWNUTDMrNGI5aW9LRG4vQmxJL0dJV0drVFl4?=
 =?utf-8?B?emxXTG9uRFZOelBJdW1TRFF3VGh0R3V2NWZxQ2JNckpJTE1VRnE1REhoNVRi?=
 =?utf-8?B?Rkt3c1VnRFl1dnh5ZHNkZDI5VGExeUZidVhDbEcrU01xeDVzRWhyYldZNnJH?=
 =?utf-8?B?RnRoeWRNT2R6QitRUW41cUYxdVhtQ3d2ZzNpU0lXTGJ5WS9TRE1TMWZvMkpY?=
 =?utf-8?B?ZXdQdGViN01WZGJjUXFkUGlGUmQrSXhCUDNBSXh0YlJQZEM2T29MU2tIaG1F?=
 =?utf-8?B?bnVKUjRJV1hodEx5bjBCTDFMRkh3bVJ1ZUM4VmlrSjZvMW1teW1VTkd4WHh1?=
 =?utf-8?Q?B2JOklQwMq3fluvN4cPcHc4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E9C55B7EB491B47A5CF7BBFC6335EF5@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ff2633-5461-4bd4-ccde-08d9e7b42de8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 07:58:49.8435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fIqGV/HLWoQKsbXR78ja1SNt2Hf4PtLBRcsfCL5MmKeJ/7XqD8Z8oXNHpd8RUtN88EeZlIyK+hv/gkgkZjjmHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1709
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: HWV6F0Ud2LHcOq0anVEr06CS0SezdVsb
X-Proofpoint-ORIG-GUID: HWV6F0Ud2LHcOq0anVEr06CS0SezdVsb
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040040
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWlsYW4sDQoNCkkgYW5kIERtaXRyaXkgdHJpZXMgdG8gZml4IGEgcHJvYmxlbSB3aXRoIEJJTyBz
cGxpdCB3aXRoIGludGVncml0eSBkYXRhIGF0dGFjaGVkLg0KVGhpcyBpcyBjYXNlLCBpbnRlZ3Jp
dHkgZ2VuZXJhdGVkL2F0dGFjaGVkIGJlZm9yZSBiaW9fc3VibWl0IG92ZXIgcmFpZCBkZXZpY2Ug
KG1kIHN0YWNrIGluIG15IGNhc2UpIGFuZCBiaW8gaXMgc3ViamVjdCBvZiBiaW9faW50ZWdyaXR5
X2FkdmFuY2UuDQpCdXQgYmlvX2ludGVncml0eV9hZHZhbmNlIGluY29ycmVjdGx5IHNwbGl0IGFu
IGludGVncml0eSBkYXRhLCBhcyBpdCdzIGFzc3VtZSBpbnRlZ3JpdHkgaXRlcmF0b3IgaW4gdGhl
IDUxMmIgYmxvY2tzLg0KKCBiaXAtPmJpcF9pdGVyLmJpX3NlY3RvciArPSBieXRlc19kb25lID4+
IDkgKQ0KQnV0IHQxMCBnZW5lcmF0ZSBmdW5jdGlvbiAodDEwX3BpX2dlbmVyYXRlKSBpbmNyZWFz
ZSBhIGl0ZXJhdG9yIGJ5IDEgZm9yIGVhY2ggaW50ZWdyaXR5IGludGVydmFsIGluIHRoZSB0MTBf
cGlfZ2VuZXJhdGUgZnVuY3Rpb24uDQooICAgICAgICBmb3IgKGkgPSAwIDsgaSA8IGl0ZXItPmRh
dGFfc2l6ZSA7IGkgKz0gaXRlci0+aW50ZXJ2YWwpIHsNCiAgICAgICAgICAgICAgICBpdGVyLT5z
ZWVkKys7DQogICAgICAgIH0NCikNCkl0J3MgZ29vZCBmb3IgdGhlIHNjc2kgd2l0aCA1MTJiIGJs
b2NrcywgYnV0IGJhZCBmb3IgdGhlIG52bWUgd2l0aCA0ayBibG9jayBzaXplLg0KDQpTbyB0d28g
c29sdXRpb25zIGV4aXN0IA0KMSkgbXkgc29sdXRpb24gLSBsZXRzIGZpeCBhbiB0MTBfcGlfZ2Vu
ZXJhdGUgLyB0MTBfcGlfdmVyaWZ5IC8gIHQxMF9waV90eXBlMV9wcmVwYXJlIHRvIGluY3JlYXNl
IGl0ZXJhdG9yIGJ5IHZhbHVlIHJlbGF0ZWQgdG8gcmVhbCBpbnRlZ3JpdHkgYmxvY2sgaW4gdGhl
IDUxMmIgYmxvY2tzLg0KMikgTWFydGluIHNvbHV0aW9uLCBqdXN0IGNoYW5nZSBhbiBiaW9faW50
ZWdyaXR5X2FkdmFuY2UgZnVuY3Rpb24gdG8gbWFrZSBpdGVyYXRvciBzaGl0IGluIHRoaXMgaW50
ZWdyaXR5IGRhdGEgYmxvY2tzIHVuaXRzIGluc3RlYWQgb2YgNTEyYiBibG9ja3MuDQoNCkFsZXgN
Cg0K77u/T24gMDQvMDIvMjAyMiwgMTA6NDQsICJNaWxhbiBCcm96IiA8Z21henlsYW5kQGdtYWls
LmNvbT4gd3JvdGU6DQoNCiAgICBPbiAwNC8wMi8yMDIyIDA0OjQ0LCBNYXJ0aW4gSy4gUGV0ZXJz
ZW4gd3JvdGU6DQogICAgPiANCiAgICA+IERtaXRyeSwNCiAgICA+IA0KICAgID4+IE15IG9ubHkg
Y29uY2VybiBpcyBkbV9jcnlwdCB0YXJnZXQgd2hpY2ggb3BlcmF0ZXMgb24gYmlwX2l0ZXIgZGly
ZWN0bHkNCiAgICA+PiB3aXRoIHRoZSBjb2RlIGNvcHktcGFzdGVkIGZyb20gYmlvX2ludGVncml0
eV9hZHZhbmNlOg0KICAgID4+DQogICAgPj4gc3RhdGljIGludCBkbV9jcnlwdF9pbnRlZ3JpdHlf
aW9fYWxsb2Moc3RydWN0IGRtX2NyeXB0X2lvICppbywgc3RydWN0IGJpbyAqYmlvKQ0KICAgID4+
IHsNCiAgICA+PiAJc3RydWN0IGJpb19pbnRlZ3JpdHlfcGF5bG9hZCAqYmlwOw0KICAgID4+IAl1
bnNpZ25lZCBpbnQgdGFnX2xlbjsNCiAgICA+PiAJaW50IHJldDsNCiAgICA+Pg0KICAgID4+IAlp
ZiAoIWJpb19zZWN0b3JzKGJpbykgfHwgIWlvLT5jYy0+b25fZGlza190YWdfc2l6ZSkNCiAgICA+
PiAJCXJldHVybiAwOw0KICAgID4+DQogICAgPj4gCWJpcCA9IGJpb19pbnRlZ3JpdHlfYWxsb2Mo
YmlvLCBHRlBfTk9JTywgMSk7DQogICAgPj4gCWlmIChJU19FUlIoYmlwKSkNCiAgICA+PiAJCXJl
dHVybiBQVFJfRVJSKGJpcCk7DQogICAgPj4NCiAgICA+PiAJdGFnX2xlbiA9IGlvLT5jYy0+b25f
ZGlza190YWdfc2l6ZSAqIChiaW9fc2VjdG9ycyhiaW8pID4+IGlvLT5jYy0+c2VjdG9yX3NoaWZ0
KTsNCiAgICA+Pg0KICAgID4+IAliaXAtPmJpcF9pdGVyLmJpX3NpemUgPSB0YWdfbGVuOw0KICAg
ID4+IAliaXAtPmJpcF9pdGVyLmJpX3NlY3RvciA9IGlvLT5jYy0+c3RhcnQgKyBpby0+c2VjdG9y
Ow0KICAgID4+ICAgICAgICAgICAgICAgICBeXl4NCiAgICA+Pg0KICAgID4+IAlyZXQgPSBiaW9f
aW50ZWdyaXR5X2FkZF9wYWdlKGJpbywgdmlydF90b19wYWdlKGlvLT5pbnRlZ3JpdHlfbWV0YWRh
dGEpLA0KICAgID4+IAkJCQkgICAgIHRhZ19sZW4sIG9mZnNldF9pbl9wYWdlKGlvLT5pbnRlZ3Jp
dHlfbWV0YWRhdGEpKTsNCiAgICA+PiAuLi4NCiAgICA+PiB9DQogICAgPiANCiAgICA+IEkgY29w
aWVkIE1pbGFuIGFuZCBNaWtlIHdobyBhcmUgbW9yZSBmYW1pbGlhciB3aXRoIHRoZSBkbS1kcnlw
dCBpbnRlcm5hbHMuDQoNCiAgICBIaSwNCg0KICAgIFdoYXQncyB0aGUgcHJvYmxlbSBoZXJlIHlv
dSBhcmUgdHJ5aW5nIHRvIGZpeD8NCiAgICBFdmVuIGlmIEkgcmVhZCBsaW51eC1ibG9jayBwb3N0
cywgSSBkbyBub3QgdW5kZXJzdGFuZCB0aGUgY29udGV4dC4uLg0KDQogICAgQW55d2F5LCBjYyB0
byBNaWt1bGFzIGFuZCBkbS1kZXZlbCwgYXMgZG0taW50ZWdyaXR5L2RtLWNyeXB0IGlzDQogICAg
dGhlIG1ham9yIHVzZXIgb2YgYmlvX2ludGVncml0eSBoZXJlLg0KDQogICAgSWYgeW91IHRvdWNo
IHRoZSBjb2RlLCBwbGVhc2UgYmUgc3VyZSB5b3UgcnVuIGNyeXB0c2V0dXAgdGVzdHN1aXRlDQog
ICAgd2l0aCB0aGUgaW50ZWdyaXR5IHRlc3RzLg0KICAgIChJT1cgaW50ZWdyaXR5c2V0dXAgdGVz
dHMgYW5kIExVS1MyIHdpdGggYXV0aGVudGljYXRlZCBlbmNyeXB0aW9uDQogICAgdGhhdCB1c2Vz
IGRtLWNyeXB0IG92ZXIgZG0taW50ZWdyaXR5LikNCg0KICAgIEFsbCB3ZSBuZWVkIGlzIHRoYXQg
ZG0taW50ZWdyaXR5IGNhbiBwcm9jZXNzIGJpbyBpbnRlZ3JpdHkgZGF0YQ0KICAgIGRpcmVjdGx5
LiAoSSBrbm93IHNvbWUgcGVvcGxlIGRvIG5vdCBsaWtlIGl0LCBidXQgdGhpcyB3YXMNCiAgICB0
aGUgbW9zdCAiZWxlZ2FudCIgc29sdXRpb24gaGVyZS4pDQoNCiAgICBIZXJlIGRtLWNyeXB0IHVz
ZXMgdGhlIGRhdGEgZm9yIGF1dGhlbnRpY2F0ZWQgZW5jcnlwdGlvbiAoYWRkaXRpb25hbA0KICAg
IGF1dGggdGFnIGluIGJpbyBmaWVsZCksIHNvIGJlY2F1c2UgZG0tY3J5cHQgb3ducyBiaW8sIGlu
dGVncml0eSBkYXRhDQogICAgbXVzdCBiZSBhbGxvY2F0ZWQgaW4gZG0tY3J5cHQgKHN0YWNrZWQg
b3ZlciBkbS1pbnRlZ3JpdHkpLg0KDQogICAgTWlsYW4NCg0K
