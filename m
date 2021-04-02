Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAD5C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 14:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 760BC6100C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 14:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhDBOlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:41:15 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:21582 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235670AbhDBOlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 10:41:15 -0400
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132EXVAG023970;
        Fri, 2 Apr 2021 14:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=MwsUsO77b4MoqVdKb5581t3rNp7TAWUKV5EAQCKy6yQ=;
 b=GkrQ7t35is5nOtuQOCkVmEgBElCgGPIYhkEzk8LCgxj3Jp1unKMbnMIRcw6xBjC3UtYk
 K7lL7S9D5Uy3Xn0zSvOOmSWH0+rTbr/rbjsjVJbiEJ8o/YovtZktr7TpkULIaFUi+6JE
 9oytMoW6JEodsZ/u7HWIPra7dfx6gW/42+odx7m0s3pI13QvMKMry1s9699z2r0F4b3o
 5Afq5Goh5Rfu/98C7BLO2CBEmg+VRuumqEGx/fPUEDd45yexYIcAH09YD+LC1aNClvco
 WNZr/2Xi7x5X1t6/SZ6BpJ3nacz7Yy8Vc7f1TmyvWwvelagbh/EY3imqbxV/QOMmbf3Y uQ== 
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 37nypjab8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 14:40:42 +0000
Received: from G4W10204.americas.hpqcorp.net (g4w10204.houston.hpecorp.net [16.207.82.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id DE2DB59;
        Fri,  2 Apr 2021 14:40:41 +0000 (UTC)
Received: from G4W10205.americas.hpqcorp.net (2002:10cf:520f::10cf:520f) by
 G4W10204.americas.hpqcorp.net (2002:10cf:5210::10cf:5210) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 2 Apr 2021 14:40:41 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.241.52.10) by
 G4W10205.americas.hpqcorp.net (16.207.82.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Fri, 2 Apr 2021 14:40:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2UPhBTJIyFLbCRjtbh1qMOrO/zTiPtx7V1+oC9oPHxN3CQqeCiOKJ1vLjY4vLMg/vAAwRiWOwFvfAKb7y15wQgZfp0ur+BLtVP/mwH2M6rHiYfAU1+m418Dgrs++DjZ0hZ3Pj+Rd0caGSyWubH/kq1PgMqGV6uxRgpIewM+FHAn9dWbEXYTaIvx52ReZQwgucHDJxtxuLzwe8zOS0kPEAOM3TpBl7wGTdGL21kgdXHxvLaXob0WYIAjlBzoSuGzBLTfoMkJ44qzQPwS81NQCkWdLPMDUixhrXY1J2X3YGvBHBnsG+Daev7xGSHbhF4LATB0BiiDEJ/3v8urWREbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwsUsO77b4MoqVdKb5581t3rNp7TAWUKV5EAQCKy6yQ=;
 b=QLj0X6Fe9KbzldKxrFNt+tGjGbAQWik5YL4ZFkWlkfRDc896Q2+HCUYn8Kfv4Hq03tmy5MUSjx0o6fxUDQGOiV2LmSfKOCD9kPYaOpHC2GZI8TJHYD/BJQLIbM5t3i6XzQc1+uvz9lciqp8KqauIuZtOZT6nBhvmieZhaGKV36CShChAr5u8V043gc0NOt4glk+dbo6EJf2mExs/P7j91NqsPM6uWq3p1avOFDmeyYzO1oG+Iui/ZPNfwFpcEvYjiRTTAEr4WqAfC9tIe1iDqwXPvjO9ej55WlbUwXiJbrndX2cE71F+kJ98h8UwEeCdjwmh2vT2VjG9NpRkwldufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::15) by TU4PR8401MB0928.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 14:40:40 +0000
Received: from TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::641e:1e11:30c:ec1a]) by TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::641e:1e11:30c:ec1a%5]) with mapi id 15.20.3999.030; Fri, 2 Apr 2021
 14:40:40 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Sergei Trofimovich <slyfox@gentoo.org>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
        Don Brace - C33706 <don.brace@microchip.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "storagedev@microchip.com" <storagedev@microchip.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "jszczype@redhat.com" <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] hpsa: add an assert to prevent from __packed
 reintroduction
Thread-Topic: [PATCH v2 3/3] hpsa: add an assert to prevent from __packed
 reintroduction
Thread-Index: AQHXJTVbufcVqy/YOUuxTwFDJNacxKqcI68AgAUqySA=
Date:   Fri, 2 Apr 2021 14:40:39 +0000
Message-ID: <TU4PR8401MB1055C76F16F4D8A2DCF541F8AB7A9@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
 <20210330071958.3788214-1-slyfox@gentoo.org>
 <20210330071958.3788214-3-slyfox@gentoo.org>
 <CAK8P3a2CmQpKynwGbtdWH+1L4=SkX2y4XKggT=8DrnsjxU4hSw@mail.gmail.com>
In-Reply-To: <CAK8P3a2CmQpKynwGbtdWH+1L4=SkX2y4XKggT=8DrnsjxU4hSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=hpe.com;
x-originating-ip: [165.225.216.224]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abb53a56-c949-4e8e-d7cd-08d8f5e5495f
x-ms-traffictypediagnostic: TU4PR8401MB0928:
x-ld-processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
x-microsoft-antispam-prvs: <TU4PR8401MB092814913BB3914E89AC9608AB7A9@TU4PR8401MB0928.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZsWyb0EAuZrOXu7iwoRxoUEZg+8ozaVkPQqmZF5F/iUTvnh7k4N6569A4CHpJ9fDWhjvWvXxROch8Ssxl6+t2OEVT06Kvqo93mP8/GTH/Z+RZ5E2I9osl7hvYTpSbFJeev+tUFFSsBKftZmxoS9JNfluGcjacdExQSBvDNIWQi1ES5yS303ULAcUZNk8MP03pRdsIhUWL/63qJJI7nLR8P0Q3hntdPVF3wGFVw2FCEQwBjij3bRNh2iFR2ItPSwTjjdjODjLmy7XrzxreF1ZeqDalnJ183vvwM+BHTWMirWGZJ8M1wzvPzjOM1K2oFYtKtuIlfH+HkJnOODB+/m/bY5w2FpxDVGslbsd1fA2RIzmkDAcwW2/Kw979Um2EM7EpfL2KNraQiT375S5i/2p6mN9wviX97oghJemv1dPo8/W/sw41PZSeVbzQpOqqm2DlAW/d4JSFpuhMPDHvM8OsBgMi5SGqb0KUkVndGegcEmtjhRWkHW3AkaMm+t2T7n/zzykQ4PZ1Nfe1d9d11Km+Gk2R6rjkU61CkzM08vbiAvK0wHXXmO+tjGfBclYrcsAfIr8tCP8WNQ08S+89/uu9BOoJEi0Zr8wKkZCDbldMc6/PhH+u4Bk8F6ejFBRwZ3m1lJNFKxSt0Ck5fZoGkQcxA2ySyWkkU7yGpdfOqKtOE0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(136003)(346002)(4326008)(55236004)(2906002)(6506007)(26005)(33656002)(76116006)(8936002)(8676002)(7416002)(316002)(52536014)(5660300002)(54906003)(66946007)(186003)(86362001)(478600001)(66446008)(64756008)(66556008)(55016002)(4744005)(9686003)(7696005)(110136005)(38100700001)(66476007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y0NZN2tPZ3dCZHhON2VvTHhmWXEzcFpzVVdkTWJ5enU3VWNjd2U1WUdDTkNh?=
 =?utf-8?B?TzY3VWdicWpHUUY4aWJlV0tqZW9NY01HWkxyc0I2WEc5WTM4OFNrcXFRSVZE?=
 =?utf-8?B?MGNSNWduZ2JuMUNpUWRmWmFOQnk1S3lZaE1sV2Z4Qnk5TnBZQVl5QWROQ3hU?=
 =?utf-8?B?U3dlRHJzbS9WY3ZDRUNIMUNKbTQ3Uys2TkF3WkFaemsvaXVXS3BmZEl0QmRV?=
 =?utf-8?B?WFM2bytWNXpXTHVLRXRiMm80dHRVdEdBeTFQMlIya0YwRDBDbWtZNjN3QVNi?=
 =?utf-8?B?bmRpdU03Y1ErODFnSCt2eUpGSWR3bFFkMllwdzlzL0dQaklSVXVwUWcvTXdr?=
 =?utf-8?B?MkJMRE5zWVpMK3ZxdWd2TGRoUGIzUjlsNUZXRU1XUVRUKzFXenJIQll6amxq?=
 =?utf-8?B?aURMaUhDRG84RGYxZ0hnbzNrZ25HSjlNSFV2RGVPZnMzMlh3bmN3bE1TSktt?=
 =?utf-8?B?clRtVExETEVLWEJjdE5TLytycUV5N0cvTURwV2hZbGtoY0JBMzZnczB1WEdD?=
 =?utf-8?B?RDdGT1FiaXg1SC9SU2xOdHBpY25hdTFpMnNvZC9UdVhFa0RTa0t1VjYyQTA2?=
 =?utf-8?B?azdHQ2ZBeHV3WElheGpRQ3FiMnpPOUhUOTdhV0RjNTBDMlRrYW52YVd4STVV?=
 =?utf-8?B?NmFqaUoxS3lFNUYxNUhsNWJ2V21Za29ublgrVERZNjdkK05qSE5YdW1OdXpo?=
 =?utf-8?B?cUI3ZCtTaGtGMUVsTVpDaHZwSG43MklXSWhzUTVua0VLRWVxUnd1L2lYemtu?=
 =?utf-8?B?VUxxTmFncmNzQ1FlaVFSMlpocGZSRDBPZjNzV1RsNTBmUjdwdGhTeFFjTmhX?=
 =?utf-8?B?SUNpSWVyRWtlYU1kK3VCdW5qbmcyeTIrWnNBWitQRHdqZjJkTFVLcEJLUGdJ?=
 =?utf-8?B?emd2a3gvdWkzVFZYQ1d2eSs0dzRPZmV6Z1hVTFdyeEk1NUhmTVpQb054aVlI?=
 =?utf-8?B?QlhWcVlMdUNUbXBSMlI1WE5JbTFDdzIyVXdxUzZ3NHZDNXJmNU9QMytNc0N5?=
 =?utf-8?B?TCtUdk1RMDJoSkt5MkV4YUFLWFM2bExLUjlVYnY0L3kzZlorUmp1V0t4SjZR?=
 =?utf-8?B?bW5vaCt2d1p5MW9yejdOV3NxT09CajhGT2RGTkowL0pvS2gyRm9OTDhyZnRU?=
 =?utf-8?B?Z0s5aDB6UUliTUJnUGV1LzlGNzk2V1lIOG5MWmtPdVR0MllpYnpueHNmU3BJ?=
 =?utf-8?B?bGt6UUFrRkpBOGpvL3JCM3pnbGVJd3hkVHVzMzFVTTZGMlZ4MUpUSjkzaTdM?=
 =?utf-8?B?ZUZyNk5mNG1QVzJHS2FZNmtTZGpWMlRYMEVXRXptazFhR2RvR3lzWnBuek5S?=
 =?utf-8?B?c3BsRWZqNExNTnBCRkRRakVUTUNseTRlR2RLZGJTamQ3ZExBY1hjNCtEbGZ0?=
 =?utf-8?B?TTZCVklWdllza3JUSmRUeEV1d25PbWFOd2doeDVJbHFGSEszYzhmSW1pYkgx?=
 =?utf-8?B?VVBYT3Z5WmZyd3h2dS9lVHJEK1NSQVd3MitJNmZoeCs1T1diaTgyQzZSSUpV?=
 =?utf-8?B?b0pQSG1xQldnTlNVT0U3NlB0ZUd4b3NoVWFrTnVGUi9IN04yRUdlWkRiWE1G?=
 =?utf-8?B?alo0U1I4WkpRK2toMWRsOElHU002cTNDUzhxRXdBa2VHSE9PbUt4bnVUZjdL?=
 =?utf-8?B?Y1FBUWk0YXpoSGNybkJTR1YwUkJnK1BXaFMyYS8wUWVwM1VnSURsZEE1WnEw?=
 =?utf-8?B?TnRTOFhrZkFSdlkrOGR4QWtQM0xGNStIbFRHMGF6b01aUUE2Wlo0cGlMN3VW?=
 =?utf-8?Q?FZaEuy6Oyed6oknTpOrFNBpLhSSeYFwp5DP2U4m?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: abb53a56-c949-4e8e-d7cd-08d8f5e5495f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 14:40:39.8189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Tj4C8Juv73hw83an1iEeBjuzHSNEJBtVue099MGJetteFLaIm3gRH3QkJPAHlQJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0928
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: KlgHk4vQXc6DnVg8SrxdwRck7kMTEmlL
X-Proofpoint-GUID: KlgHk4vQXc6DnVg8SrxdwRck7kMTEmlL
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_08:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SXQgbG9va3MgbGlrZSBpYTY0IGltcGxlbWVudHMgYXRvbWljX3QgYXMgYSA2NC1iaXQgdmFsdWUg
YW5kIGV4cGVjdHMgYXRvbWljX3QNCnRvIGJlIDY0LWJpdCBhbGlnbmVkLCBidXQgZG9lcyBub3Ro
aW5nIHRvIGVuc3VyZSB0aGF0Lg0KDQpGb3IgeDg2LCBhdG9taWNfdCBpcyBhIDMyLWJpdCB2YWx1
ZSBhbmQgYXRvbWljNjRfdCBpcyBhIDY0LWJpdCB2YWx1ZSwgYW5kDQp0aGUgZGVmaW5pdGlvbiBv
ZiBhdG9taWM2NF90IGlzIG92ZXJyaWRkZW4gaW4gYSB3YXkgdGhhdCBlbnN1cmVzDQo2NC1iaXQg
KDggYnl0ZSkgYWxpZ25tZW50Og0KDQpHZW5lcmljIGRlZmluaXRpb25zIGFyZSBpbiBpbmNsdWRl
L2xpbnV4L3R5cGVzLmg6DQogICAgdHlwZWRlZiBzdHJ1Y3Qgew0KICAgICAgICAgICAgaW50IGNv
dW50ZXI7DQogICAgfSBhdG9taWNfdDsNCg0KICAgICNkZWZpbmUgQVRPTUlDX0lOSVQoaSkgeyAo
aSkgfQ0KDQogICAgI2lmZGVmIENPTkZJR182NEJJVA0KICAgIHR5cGVkZWYgc3RydWN0IHsNCiAg
ICAgICAgICAgIHM2NCBjb3VudGVyOw0KICAgIH0gYXRvbWljNjRfdDsNCiAgICAjZW5kaWYNCg0K
T3ZlcnJpZGUgaW4gYXJjaC94ODYvaW5jbHVkZS9hc20vYXRvbWljNjRfMzIuaDoNCiAgICB0eXBl
ZGVmIHN0cnVjdCB7DQogICAgICAgICAgICBzNjQgX19hbGlnbmVkKDgpIGNvdW50ZXI7DQogICAg
fSBhdG9taWM2NF90Ow0KDQpQZXJoYXBzIGlhNjQgbmVlZHMgdG8gdGFrZSBvdmVyIHRoZSBkZWZp
bml0aW9uIG9mIGJvdGggYXRvbWljX3QgYW5kIGF0b21pYzY0X3QNCmFuZCBkbyB0aGUgc2FtZT8N
Cg0K
