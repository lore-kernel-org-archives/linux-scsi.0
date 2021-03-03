Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F074FC43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1EBA64EEC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355736AbhCDAdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236046AbhCCQOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 11:14:42 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123FucWm004127;
        Wed, 3 Mar 2021 08:13:02 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:02 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123Fukqq004172;
        Wed, 3 Mar 2021 08:13:02 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfjVUhdt/XIQ7HZ0M0e4wc5mrZ/tF4Z4QeHcO/Jj3VkHPBhTy6aP+XI28dD2JKikFrmbzcqhYwTi21ZDeJ6dDAR6/GDuzqlRhIQsOD9ETomFnT8S4EexMnHlfOlEa9jgucA6wXO+6XOLNb/7dWxX9caqE7eTfJ9I9mI/dWbVNkmbRC9iJhJHM1TR5lWAT8YgSEJwuMQRqS9bpNpV9n0g5XR9cTSDVl35HNwBKwaQDQHq0uM2GVJJQ5fQkxH21F3a1wlmtledcYT09s7k4yNSWeRghecGZ82eNqEMkYoAEv6LDSUnLRG1K504cE8OlsqBcdu4qSPV19zDDESBmfB/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmZsqPIPpIOX0TyvutyLC/0RZ092NK1Op8RcjUrlfbo=;
 b=bHe5AYqJABXoJi6Gj+5xwXMWRKdAhf/aX94Q7NVx8vN8FGDS5gp9S+B5g5Cu14aolTLrzjkChoCyKIsNoGh9WZcdYoT+3bLsA7zYJJvKmtUAmO3x9D0PUlKwADb0Rsh3nv226+/snZ8RQWc+v5gb5ArfkWtEXHKhyJ7z7Zn3p9XOgGCsZ9LiMax1PBKrtrFe4zUQAvsblJEmLn/ZQDilPl0vR62wq6a4WGCcfCB44vc1/y6QSkdcQHdCoX3dh7W47+1GupNaCuuMDo+JRhiYfy3Yp8Xp9leliKqI/QPZLmqAxUJVEF6vSmXY1w2lPhCezxSttcbN6OasA7j3zwyClA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmZsqPIPpIOX0TyvutyLC/0RZ092NK1Op8RcjUrlfbo=;
 b=Rir6XT+ft3fStrXR86FMyZKUox3KPNmwPyrAEws+4n/TBgUDpSfQu9/DLONpOH9XFUqrMfUYfnkXpSAhIPWVmDQZq6JXjouptgob1dtCFbu0Y6SZYyuopz9Pga8ZMmlC8Ry23t5HVKtxLqVc4WcErrz32VamR965DRd3R9oTrJs=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB2294.namprd18.prod.outlook.com (2603:10b6:4:b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 3 Mar
 2021 16:13:00 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:13:00 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 15/30] scsi: qla2xxx: qla_iocb: Replace
 __qla2x00_marker()'s missing underscores
Thread-Topic: [EXT] [PATCH 15/30] scsi: qla2xxx: qla_iocb: Replace
 __qla2x00_marker()'s missing underscores
Thread-Index: AQHXEDwga7NeTUblu0G1n6cqauAPKKpyb5KQ
Date:   Wed, 3 Mar 2021 16:13:00 +0000
Message-ID: <DM6PR18MB305246A59CB7B20AFF1CFAA9AF989@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
 <20210303144631.3175331-16-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-16-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.94.50.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc311d31-d818-43a9-6352-08d8de5f373e
x-ms-traffictypediagnostic: DM5PR18MB2294:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2294D5CE62406384A003E540AF989@DM5PR18MB2294.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSzllL3X+BJpQnpyEqS/SAcaIoFuuaM9IcD7TMMnB+ckqd0efcMY0LcIf233n0GtEx5iflwGvajF7n73VMUbn7XXfIZ3uUYvfV3+UcskGjv0Ud2h3qvAYmvYVL+1bL0jQtWSWhfesB/SvWJDYftZ8eFP1iNcdHBPEDi66z2WPUJjER/H9IDqfYkTjL2HcdLkUsZenceHf7zKA1cEl+hh8w9ZIE4PLggA4wwgiomwQk84q/yrJ7fehCDKHFEaS84kChKGLRV7QEw1mp5ie0VqlE12+Tnx4Hp57/54+9eBZSFY4WGHrnTu61J2mIyZ2pAJkOuKJUjOpekfEgmfzwTFefYahT+UdSCTE+IaAqcYLDNWmoHDiGGjme5NB3B+8F8DE4nqfURLKaHGBIH9QkERqx9rrI9AavJ5sgG5/fguBO+n7R4R+Hg80uIWeyYjpINjmYZf+W6GfWDmT6hHnGJBXcuAs8TRVFd8jodKSYLDZqD/P2ePtpwl7h2CBmOGlwOG8zU8f+5HPzxLIl3uSWgW3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(4326008)(54906003)(6916009)(66946007)(478600001)(6506007)(33656002)(2906002)(86362001)(8936002)(66446008)(66476007)(64756008)(8676002)(5660300002)(55236004)(76116006)(71200400001)(9686003)(7696005)(55016002)(186003)(66556008)(83380400001)(316002)(52536014)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?44oVpVi6P/EXpsvLTVTj8Q6o9eKiwZhqgkrP0wj1vlZLpT0MnJ3ltupJAZdc?=
 =?us-ascii?Q?Ck9Oftv4omJiIEDYAjn6PooolCBUK/BhV7iNs+X7+LSZWlBpQ1gZubNoNrIQ?=
 =?us-ascii?Q?Ual966lXeGxw/7tH4xnHbBMifHnPXjqBhw7rfvF6oNKWLEYYphs4+LYwarry?=
 =?us-ascii?Q?j9x6Hw2JqlxBGpQ0ImdUv92dPk2ft87XdmZP9MteblzvH2hdpZYZhSzOQL8L?=
 =?us-ascii?Q?O7DnDfut2SgJfpm+nut8BJ9hDaG3TVyp7m6QcyPfirBNyAFDf9RF0Rz/dIPg?=
 =?us-ascii?Q?IhDV+6bIOmooTCduZcX+Uy0cox1f3ZBK4IeoyoEvUtTYHGXVkWreys/w1JHZ?=
 =?us-ascii?Q?Re5Tj8mRly/trXTxCXL8xgN8VCiX4k6LKh1xMZ/SNgpYw/NDNV79JrFlMJqr?=
 =?us-ascii?Q?8PVN+J6fhugzXO5D8Y1uhNz98o+FPvaXDcZ2Ol0C6zFemlaUegDQymoK84KA?=
 =?us-ascii?Q?h/QkifDELPBZYfX8klkhSiAZpY0qr++6mNR+iE0bkHprb4F7pLdFYE7N4ZUW?=
 =?us-ascii?Q?IkkE1OkuwoiDs7uBMoaAylErUOSIS02VPH/VfG/LzJAa91kKow0LTpTotlYg?=
 =?us-ascii?Q?H01iTT5OjuvWuBZHb89fAuTb/E+5e7CUjK/YFURX1chnRVDE/LCAT0uhtbLr?=
 =?us-ascii?Q?pM0jFMZzcvVQgWJaViKxPS6xc1DI40lc9GoSMRTt6ZrVKWIacRScaSVJuzE5?=
 =?us-ascii?Q?jJOnoxVfDgzcN0Fhf2fdF1GtYyM6bnTXq3GUZ5qqppmDuCCdGgcSw4KS3eCk?=
 =?us-ascii?Q?PJDpyBg1oBGtmJKm3UxN0C4qqtu2vOLC9Mmx2sNo5QEOPUXO8Fi7e3rh07BL?=
 =?us-ascii?Q?oyTlN8LiEAlgHV9mRBSRrbZWjDdqmUpi2xGFj6GUF8XuTOcIquPUAC935jxX?=
 =?us-ascii?Q?SZgCAX6T0XktaXERNiN7a4DWygA7IM5wVrUYWavakTBrHVNZzlOyc73nwjle?=
 =?us-ascii?Q?OyOojF0BCOJc5qqeVT4HrlEoqd4Edk19x3+BsCHpRUgY9NovJl+U9qz5Phhg?=
 =?us-ascii?Q?RNtmFNzqEPw39idThJr+UyXgyuWxS9BSfWJ46sGVj/h4MQQgkppu+Ne4CA9q?=
 =?us-ascii?Q?/kQDFMgNw1Ch1jNel+NkVYy3zdM8gtSUmfBfMzGShEtDAGogL5O3OnGSqnl+?=
 =?us-ascii?Q?nO1PF/viUHj8l1VUqzqsjl/qwC4GWDzIgyG0Zx+/cgsCijW/UPm1BHkzrt9B?=
 =?us-ascii?Q?PPCxj7+nfMTunzUsYOSpATn0A1pGhCZK+ua9mH5yc90Xu4SuiCH/81U+B3sr?=
 =?us-ascii?Q?aW446erR9O+w8zygv+XHSKHydD/KAAHBohYYu8hp2q396zb2KdOTpAOv7n9A?=
 =?us-ascii?Q?KXDw+XNFqlJxeJWj7V1ENJgn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc311d31-d818-43a9-6352-08d8de5f373e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 16:13:00.1850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mfh/WyZncHE39/RjkYlSwF38Clilk/bvdavlCV2hmSsuihLiVA1iLZGDOEe9wSDQcylY08KTy14Z70gXmHIpSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2294
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Lee Jones <lee.jones@linaro.org>
> Sent: Wednesday, March 3, 2021 8:16 PM
> To: lee.jones@linaro.org
> Cc: linux-kernel@vger.kernel.org; Nilesh Javali <njavali@marvell.com>; GR=
-
> QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>;
> James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org
> Subject: [EXT] [PATCH 15/30] scsi: qla2xxx: qla_iocb: Replace
> __qla2x00_marker()'s missing underscores
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/scsi/qla2xxx/qla_iocb.c:508: warning: expecting prototype for
> qla2x00_marker(). Prototype was for __qla2x00_marker() instead
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 8b41cbaf8535b..e765ee4ce162a 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -491,7 +491,7 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct
> req_que *req)
>  }
>=20
>  /**
> - * qla2x00_marker() - Send a marker IOCB to the firmware.
> + * __qla2x00_marker() - Send a marker IOCB to the firmware.
>   * @vha: HA context
>   * @qpair: queue pair pointer
>   * @loop_id: loop ID
> --
> 2.27.0

Lee,

Thanks for the patch.
Ack-by: Nilesh Javali <njavali@marvell.com>
