Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA420C77B7C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjEAPL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjEAPL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:11:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3C11BF
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:11:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EJ4vC003680;
        Mon, 1 May 2023 15:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=lc19oQMnBcS3EARVFNmXVOo/GtgTOFSWSn0aJfSAwA0=;
 b=QkAmzN4pHLu6WRNPUY9f+Tun/D3lDMvAfEJxkgAlXNoHJMzdgnAKt95e1g0JcInAQw0G
 O3bIFHMhJVrsmZaRMPubo1bJrOcvEQTcVxCAbxmk9HlbKqi8OV8rmu4ybqfcLf1N9vk/
 rBBhvEumGHekmfY5RumgAoG/LvsNPaFSDP2y/T29o/EUcy7elhpucyAK8skcM+Ip/I9Z
 Mf4mirH1kEhI7v9jty7ohu94PHyAKUSDnbXHbhVgP7yFv/w53yzEi7eL7xfE1TUaomYp
 Rgu0IhZVKl64awi2G+SN2CTMG98ryaMTm5Qj0xoI4Ee9RF9jT+7E7joVcJoOGiynJrVl JA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u4ajhs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:10:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341EG37t022265;
        Mon, 1 May 2023 15:10:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spatfub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4Qc68AOYYRF2r66S3dg87r4PukOwtcMU/4+Q+1pdQipnHqC6gGsiw5Uu/kmSz9ruevAmuALqputJNX3zox3hC2+l5vVmPXBbsHO5mHPRqX7PO3p01n0tRTRxTZqp1+bztDXFPBxRSpph7ZaxS82T9si+fYstpN3r8xaLzq3PJl9pfzyyPWwklKfl55JQUzaQZA0EwTKWW/vsuLm1nDrx6vmU/carCW/BTbisjgNbYEHF+OOMisFA2fydp6oIXcBfkwB37WYBUuj1emuSF2naU9UjBpiMFHp6OvZ5bg/0FHeGbx20CtjOpOB4q9ul6/LKHUwHMJ1bzAejEhZI0Ahgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lc19oQMnBcS3EARVFNmXVOo/GtgTOFSWSn0aJfSAwA0=;
 b=DJTAMNdxv/YxYJHcUMaMkAk86/u1HVSA6MML8GbFEPDhYKQuD2qy6pGJbZ38R2cmgiB3WYgVyGW2nnGFAW6wvJA+n5wOmkmqwAG1rDLDZ+/XzozXF9pxA9EsKmCCnBP6fw3hGNwijxqj/F+zGr6eoDwAE2/zx7WLu888CG5Rq9vDSywXHzzOiVkGm6VycQEd4rUbpGUPqCtD+iZ5NfayzdP2LxhvS0wrIjCzDXe1zyvghPr2/NXBTj9+EAc6eaVbXYnWTBfdYh11KJrCd4j/HJGh4dUICwoEp/qOSESk2YN8wpfdU6nygwRWh4WxWZM9tLox5VqTn09WHjgSoDnKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lc19oQMnBcS3EARVFNmXVOo/GtgTOFSWSn0aJfSAwA0=;
 b=mJHi/GJzHjf2NMxqMLUm4N2ThjqlT6eqmSrEq9p3EuiKhvCwZ/c8K0Eq1yjN4oygXM1SOjncmFSDfjjrx++kYQA3nBb0V3DmtGqHMAmybdiksn49iNqPn1ZmFdAOmFovQo3w6QtoHaclFPMAhznKFLt0T2Nx5lmYqCS/ZUkxyQ8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Mon, 1 May
 2023 15:10:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:10:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Fix mem access after free
Thread-Topic: [PATCH v2 5/7] qla2xxx: Fix mem access after free
Thread-Index: AQHZeaavWVr57uG/1U+ZthOZllZbm69FisWA
Date:   Mon, 1 May 2023 15:10:28 +0000
Message-ID: <19EAE73A-3C86-4261-B3B6-75CD283EB820@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-6-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CO6PR10MB5633:EE_
x-ms-office365-filtering-correlation-id: cfe26865-95f4-4005-a09f-08db4a5632e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9T5gkywGWE1vZuubjjU3mvNeC5BvVpX0xvXayEfFe4Aigdn/QheGzpCQbf7m3YQQkM+7l+8cGI4fUF/dYm17dffERisA9gFLcw7Y2OgujlphFOt/KGxZu73Zbwt1LLWR+L/8vi45Mpgp0jAEE/cUpIIGhix3IVB1VRo8u62EPf832tXE8nOfG3K6wAFA9L4qz2mFkCCV4jbgaILJTVR3/fpMODXl43qrONAPczVhP1gJAFSEMHHUKWjFzUNoLEHwW+d170HaEB+qooYfaoZsW1AvTmNqPZ+Sn3spBUuplyfsAqHAHtHkvY1T+3I2/63IrUYf7HWEw5dggQJ1OkfITW7xjf5q20vtwe0iIXSGF9t27qU2knYpwRRNC5qPeihNoB1Xmo4rpEhWCJ2zELmQ2u4rTuO2Hk8uqWcxqqvHtGtkaUE3K5ljm/2Fhed0XKhtFlujXLTHq4bH+py4wJ1ZVTtMgnNZUwxu9BCKI/yXto1D0e9UHnkA2dDmw4g5KynbjhVyXSa1tWkX/ZxRz6r+h8zoa1tQeSpvWVWzkKWTeKVXkKhH4d9EQS0tfmxAaiLwS/VPgxeWO9sbZApt5cI0lVrhzGTryA3eM42Ixskw5oC9uRijd06XdgMzSuEyvGONmS5N5mXnLNks7A1IFMz6Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(38070700005)(8936002)(8676002)(26005)(53546011)(2616005)(38100700002)(6506007)(6512007)(33656002)(44832011)(478600001)(186003)(5660300002)(36756003)(316002)(2906002)(71200400001)(54906003)(6486002)(86362001)(83380400001)(66476007)(66556008)(64756008)(66446008)(76116006)(6916009)(4326008)(66946007)(41300700001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0GDZMJ5ESaCwZ4SSilHe5x+O1Bwc/keN7+pMEU6rOqIvaxhpqDUP/NBqBz6g?=
 =?us-ascii?Q?ZdTynacsSufsg7/VO3XaBUNMl3TzBbmWQp8p4zlCNLntjvK0OUzwWDMvyjA/?=
 =?us-ascii?Q?GVL4v5Lg14gOhXnOQHmJjFlwXqrIcmvafQjjShVq6l7UbcBCOPRvkbcrzJY1?=
 =?us-ascii?Q?O5wiat5V6Y7ixBqyqjUxZcHTuuOklG5rw0dks67+kJXP67FS3luidHOdDfQy?=
 =?us-ascii?Q?Un+yX+80QgCaqsByVnb9gFEFiiA4oQL6W0GIWNiuxLwDDdWL7EhHd2PGS4FP?=
 =?us-ascii?Q?sCWRFiYNlRErH1CTQH3BTLQMYd5ibOz7Pm9mMtZEG5YQvuhi1Y1RU1NTLccK?=
 =?us-ascii?Q?U4R2ENdt7cLSe3sslsWWPTsH2kMtwTXisOAeUf9B4euIj853XhhEn49ModRX?=
 =?us-ascii?Q?d5WMm3ji/BWuuBfud2YqbtJInmk6kWZErbe/lo0PpnDnEY1jbjdS/UGl6diZ?=
 =?us-ascii?Q?Pw4Qpvju3OlF9pzqHkW2ODvcEpe1r6ulPJzsy4+xLbXK1y1g8xLsdh+JpC9B?=
 =?us-ascii?Q?xTdj9AepXXD2sRaCNxJPy87AXTYmsTZFvCMm+7dKbz9a4pYI8zye+dNNSZ3K?=
 =?us-ascii?Q?agpbKBDyLvJ/pebiBZbvpqI7Eyhga8CEPbSPfigqcTY4jti/rrOE22rDFRLe?=
 =?us-ascii?Q?guZwMIFpiPIb1ZOirMd/EBgNl6uJJwIZAqi4aTpUd1cTFDubpPiEZ7kGzgmR?=
 =?us-ascii?Q?ghs9H8+lckw3BRb5DPw3JKGXruqQhRdFYo4440KxisZbKyrLSW8owhc0O0dE?=
 =?us-ascii?Q?np/4XeMS5RNjknlC+96odNA6sVWmVjG/KNmhV/lsWcTwvbXjOt9u4MfeLjoj?=
 =?us-ascii?Q?OGOTdULoCdkFBjXwyMTAov+c9S+BFfz6bgAHAce664ZSLGIbRPNScdGa5Axu?=
 =?us-ascii?Q?zbsoZEIO8Blo3ZdB7HTScR3nJG1aCrFzyPJEBJPkAjslZIWFqWE9Iy/oHgvB?=
 =?us-ascii?Q?DXwGcpGzZXgUpYy8wKHf7Ak81jrDn/VwoUXOoti5M9rXmyUvrGmh3UrMTOxH?=
 =?us-ascii?Q?l77FQLQ1jxhD5R6USGr46FbWgTbfvhk5Na9xUt3tS1kyUW7fb8jvTP5VTbdd?=
 =?us-ascii?Q?TGzs3512/JPzfrgOk2q+m9iS2wcpyRxu2Vuu6eTOG9Pn+BpAhg4J8wFUA4TK?=
 =?us-ascii?Q?Oi3EDf0wGKfSyLJFtNLH2sY3EQiLzAwicHWYDI58ItZ5+YVsC/JBVfUDZUc/?=
 =?us-ascii?Q?nsaFqKe3Wgq1Uujr7HkxytKkl91GtcU+nRLEKy7CfTmtm6NvPG9aAxpy6wcl?=
 =?us-ascii?Q?Jkb4muCJTaBcyTHB2ckBGBRNTfNPLdrOiqFTbts2OwZHIwRTBrHxBf4UIu3/?=
 =?us-ascii?Q?NA6DPOcwMb1hvlHUBxHsFDda4Rk6y04ZZ5r3/Ng4GJ68O4HvxMmedvKUK81z?=
 =?us-ascii?Q?vzb/9Viebj6EAl6kiqxVx9t20erHVNUZXivbg4DJvsGwW684W7d5Yt/ZgUE8?=
 =?us-ascii?Q?ptzYy5YZfPHqtyzJI3TA4zMbYQngrkIee8SVM1frOAk+WrWnbtUz4xvKmByQ?=
 =?us-ascii?Q?wGtAbktCQJM+E4bI9XW/HbDbPJRB5ZAjxhUQN1viXbeLDyYO6iMiX9DDGNfR?=
 =?us-ascii?Q?7IQjYaLYCF3JMNb+i7kYRXylMq+WOvWOghU4EbHRG3IWXfeWgVRy+yNVUhpI?=
 =?us-ascii?Q?wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C304DD81D14D734CAE57D34E28644B88@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hAHK1Hn9rxfwrK7wRFX6/81Om5lQDXzaZSkVcKU/DHxmQea03ZoIrrLFcpTxS6iJLXjkCiPFs/VmoCIkFBR5YyViPU4YCHpjDqfWNR8X2/RwuBjSuqOrzt7+0BpWNrECwL8vvtHm3QwdXMKRebGTQ+yegKZfsrgIDTA1BDxsGCREOlvgQUeK1oScxcuUWIC3o0CwzEdQGE1mCxcvxxlDx4RjEIVwikgC7mOiiFilW9Aw/+TsWsV0OlfCRaKAMAx1LacF5j57QbW4wDp4R1lTFUisxBzAWv6azzwETsAC8yU9OrdhmASftBaHWe8iKx98GtN1RW1SLVZU4hxcLs8Vf2H5v3b/BQ8BDCQZo0mF5QjhP8+0cdigAaOxJWue81wGRFkQlDMsHnF2pXjXERWf+4rOeTctyXvfoaEpNOLyWqxHj08gbheXFmkBiPt8DnMR9BnUr5Ezcf72WLmS1J6v4HSUdwbsa9FLek7tyv0h7IdtzQJuNJ86mVSLhiH83cYVIdeZeOTFcKSkKQTJsAt8A+136fQltTmN2gjQc83XfuMZ3nOO2Z1Iw2GnhFmCvMgJU/RclbvYTeok/2FG+kVjiQx64hHDIKxnsQgxAKEdf2qET+jmzSAWDhSvUGdH28YbOyM10zBI6a8TfMHeSaV7A4oZD96hJ8Ab/viiuK2HZZeAA+c9q4OkkqPbYMnEOT0WoLFhh0dEzdItc0ZW9/OhJZ1YEmvVokgKagvoMdg6N6J6H+TXPgnCs7HKvCtsPb8f+kDRWMT78O+rm2T0cW6nkVvXspa7XZr6VgY/Af6T7Q8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe26865-95f4-4005-a09f-08db4a5632e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:10:28.4317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UeTOg1Xia0aEsnmgJ+PdPFEQwcemRxzfpq7CNujwgmDY/OA3FkY8+AbbFeK30Z1go8+CfSzCkKVuAv06t35Xrer5BuQ7pj5UU0RkNtfWUIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010122
X-Proofpoint-GUID: otzmFrqkY3H98Rs4t78TuFXoW4CUtrtn
X-Proofpoint-ORIG-GUID: otzmFrqkY3H98Rs4t78TuFXoW4CUtrtn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> System crash, where driver is accessing scsi layer's
> memory (scsi_cmnd->device->host) to search for a well known internal
> pointer (vha). The scsi_cmnd was released back to upper layer which
> could be freed, but the driver is still accessing it.
>=20
> 7 [ffffa8e8d2c3f8d0] page_fault at ffffffff86c010fe
>  [exception RIP: __qla2x00_eh_wait_for_pending_commands+240]
>  RIP: ffffffffc0642350  RSP: ffffa8e8d2c3f988  RFLAGS: 00010286
>  RAX: 0000000000000165  RBX: 0000000000000002  RCX: 00000000000036d8
>  RDX: 0000000000000000  RSI: ffff9c5c56535188  RDI: 0000000000000286
>  RBP: ffff9c5bf7aa4a58   R8: ffff9c589aecdb70   R9: 00000000000003d1
>  R10: 0000000000000001  R11: 0000000000380000 R12: ffff9c5c5392bc78
>  R13: ffff9c57044ff5c0 R14: ffff9c56b5a3aa00  R15: 00000000000006db
>  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 8 [ffffa8e8d2c3f9c8] qla2x00_eh_wait_for_pending_commands at ffffffffc064=
6dd5 [qla2xxx]
> 9 [ffffa8e8d2c3fa00] __qla2x00_async_tm_cmd at ffffffffc0658094 [qla2xxx]
>=20
> Remove access of freed memory. Currently the driver was checking to see i=
f
> scsi_done was called by seeing if the sp->type has changed. Instead,
> check to see if the command has left the  oustanding_cmds[] array as
> sign of scsi_done was called.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c |  38 ++++++++--
> drivers/scsi/qla2xxx/qla_os.c  | 130 ++++++++++++++++-----------------
> 2 files changed, 95 insertions(+), 73 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index f3107508cf12..a07c010b0843 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1862,9 +1862,9 @@ qla2x00_process_completed_request(struct scsi_qla_h=
ost *vha,
> }
> }
>=20
> -srb_t *
> -qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
> -    struct req_que *req, void *iocb)
> +static srb_t *
> +qla_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
> +       struct req_que *req, void *iocb, u16 *ret_index)
> {
> struct qla_hw_data *ha =3D vha->hw;
> sts_entry_t *pkt =3D iocb;
> @@ -1899,12 +1899,25 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, =
const char *func,
> return NULL;
> }
>=20
> - req->outstanding_cmds[index] =3D NULL;
> -
> + *ret_index =3D index;
> qla_put_fw_resources(sp->qpair, &sp->iores);
> return sp;
> }
>=20
> +srb_t *
> +qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
> +   struct req_que *req, void *iocb)
> +{
> + uint16_t index;
> + srb_t *sp;
> +
> + sp =3D qla_get_sp_from_handle(vha, func, req, iocb, &index);
> + if (sp)
> + req->outstanding_cmds[index] =3D NULL;
> +
> + return sp;
> +}
> +
> static void
> qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>     struct mbx_entry *mbx)
> @@ -3237,13 +3250,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct=
 rsp_que *rsp, void *pkt)
> return;
> }
>=20
> - req->outstanding_cmds[handle] =3D NULL;
> cp =3D GET_CMD_SP(sp);
> if (cp =3D=3D NULL) {
> ql_dbg(ql_dbg_io, vha, 0x3018,
>    "Command already returned (0x%x/%p).\n",
>    sts->handle, sp);
>=20
> + req->outstanding_cmds[handle] =3D NULL;
> return;
> }
>=20
> @@ -3514,6 +3527,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct r=
sp_que *rsp, void *pkt)
>=20
> if (rsp->status_srb =3D=3D NULL)
> sp->done(sp, res);
> +
> + /* for io's, clearing of outstanding_cmds[handle] means scsi_done was c=
alled */
> + req->outstanding_cmds[handle] =3D NULL;
> }
>=20
> /**
> @@ -3590,6 +3606,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rs=
p_que *rsp, sts_entry_t *pkt)
> uint16_t que =3D MSW(pkt->handle);
> struct req_que *req =3D NULL;
> int res =3D DID_ERROR << 16;
> + u16 index;
>=20
> ql_dbg(ql_dbg_async, vha, 0x502a,
>    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
> @@ -3608,7 +3625,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rs=
p_que *rsp, sts_entry_t *pkt)
>=20
> switch (pkt->entry_type) {
> case NOTIFY_ACK_TYPE:
> - case STATUS_TYPE:
> case STATUS_CONT_TYPE:
> case LOGINOUT_PORT_IOCB_TYPE:
> case CT_IOCB_TYPE:
> @@ -3628,6 +3644,14 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct r=
sp_que *rsp, sts_entry_t *pkt)
> case CTIO_TYPE7:
> case CTIO_CRC2:
> return 1;
> + case STATUS_TYPE:
> + sp =3D qla_get_sp_from_handle(vha, func, req, pkt, &index);
> + if (sp) {
> + sp->done(sp, res);
> + req->outstanding_cmds[index] =3D NULL;
> + return 0;
> + }
> + break;
> }
> fatal:
> ql_log(ql_log_warn, vha, 0x5030,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index d0cdbfe771a9..60734c569401 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1078,43 +1078,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, stru=
ct scsi_cmnd *cmd,
> return 0;
> }
>=20
> -/*
> - * qla2x00_eh_wait_on_command
> - *    Waits for the command to be returned by the Firmware for some
> - *    max time.
> - *
> - * Input:
> - *    cmd =3D Scsi Command to wait on.
> - *
> - * Return:
> - *    Completed in time : QLA_SUCCESS
> - *    Did not complete in time : QLA_FUNCTION_FAILED
> - */
> -static int
> -qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
> -{
> -#define ABORT_POLLING_PERIOD 1000
> -#define ABORT_WAIT_ITER ((2 * 1000) / (ABORT_POLLING_PERIOD))
> - unsigned long wait_iter =3D ABORT_WAIT_ITER;
> - scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> - struct qla_hw_data *ha =3D vha->hw;
> - srb_t *sp =3D scsi_cmd_priv(cmd);
> - int ret =3D QLA_SUCCESS;
> -
> - if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
> - ql_dbg(ql_dbg_taskm, vha, 0x8005,
> -    "Return:eh_wait.\n");
> - return ret;
> - }
> -
> - while (sp->type && wait_iter--)
> - msleep(ABORT_POLLING_PERIOD);
> - if (sp->type)
> - ret =3D QLA_FUNCTION_FAILED;
> -
> - return ret;
> -}
> -
> /*
>  * qla2x00_wait_for_hba_online
>  *    Wait till the HBA is online after going through
> @@ -1365,6 +1328,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> return ret;
> }
>=20
> +#define ABORT_POLLING_PERIOD 1000
> +#define ABORT_WAIT_ITER ((2 * 1000) / (ABORT_POLLING_PERIOD))
> +
> /*
>  * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
>  */
> @@ -1378,41 +1344,73 @@ __qla2x00_eh_wait_for_pending_commands(struct qla=
_qpair *qpair, unsigned int t,
> struct req_que *req =3D qpair->req;
> srb_t *sp;
> struct scsi_cmnd *cmd;
> + unsigned long wait_iter =3D ABORT_WAIT_ITER;
> + bool found;
> + struct qla_hw_data *ha =3D vha->hw;
>=20
> status =3D QLA_SUCCESS;
>=20
> - spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> - for (cnt =3D 1; status =3D=3D QLA_SUCCESS &&
> - cnt < req->num_outstanding_cmds; cnt++) {
> - sp =3D req->outstanding_cmds[cnt];
> - if (!sp)
> - continue;
> - if (sp->type !=3D SRB_SCSI_CMD)
> - continue;
> - if (vha->vp_idx !=3D sp->vha->vp_idx)
> - continue;
> - match =3D 0;
> - cmd =3D GET_CMD_SP(sp);
> - switch (type) {
> - case WAIT_HOST:
> - match =3D 1;
> - break;
> - case WAIT_TARGET:
> - match =3D cmd->device->id =3D=3D t;
> - break;
> - case WAIT_LUN:
> - match =3D (cmd->device->id =3D=3D t &&
> - cmd->device->lun =3D=3D l);
> - break;
> - }
> - if (!match)
> - continue;
> + while (wait_iter--) {
> + found =3D false;
>=20
> - spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> - status =3D qla2x00_eh_wait_on_command(cmd);
> spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> + for (cnt =3D 1; cnt < req->num_outstanding_cmds; cnt++) {
> + sp =3D req->outstanding_cmds[cnt];
> + if (!sp)
> + continue;
> + if (sp->type !=3D SRB_SCSI_CMD)
> + continue;
> + if (vha->vp_idx !=3D sp->vha->vp_idx)
> + continue;
> + match =3D 0;
> + cmd =3D GET_CMD_SP(sp);
> + switch (type) {
> + case WAIT_HOST:
> + match =3D 1;
> + break;
> + case WAIT_TARGET:
> + if (sp->fcport)
> + match =3D sp->fcport->d_id.b24 =3D=3D t;
> + else
> + match =3D 0;
> + break;
> + case WAIT_LUN:
> + if (sp->fcport)
> + match =3D (sp->fcport->d_id.b24 =3D=3D t &&
> + cmd->device->lun =3D=3D l);
> + else
> + match =3D 0;
> + break;
> + }
> + if (!match)
> + continue;
> +
> + spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> + if (unlikely(pci_channel_offline(ha->pdev)) ||
> +    ha->flags.eeh_busy) {
> + ql_dbg(ql_dbg_taskm, vha, 0x8005,
> +    "Return:eh_wait.\n");
> + return status;
> + }
> +
> + /*
> + * SRB_SCSI_CMD is still in the outstanding_cmds array.
> + * it means scsi_done has not called. Wait for it to
> + * clear from outstanding_cmds.
> + */
> + msleep(ABORT_POLLING_PERIOD);
> + spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> + found =3D true;
> + }
> + spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> + if (!found)
> + break;
> }
> - spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> + if (!wait_iter && found)
> + status =3D QLA_FUNCTION_FAILED;
>=20
> return status;
> }
> --=20
> 2.23.1
>=20
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

