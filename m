Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61247C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiDUUTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiDUUTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:19:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842F839B
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:16:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LIK5wB014729;
        Thu, 21 Apr 2022 20:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uyWeehdzn3A4HUfdaNigCAMYdxtFN4cWjYP+FeG1taY=;
 b=jvqvs/edcm4Q22QCYMZ/rJJW4do8lfNFNf0BuvJCCUpVpVrh+Pn/XifOoiKtibdLldwF
 elF0JEB17dRjo4DUX1NJHHsxWQPEHDrdoeYxgKpJcoRIt/EOaNa9g4VBS1OqZwP13j2s
 mcTlZdZ0yysFsHNGnJ7WQ9rQVzUxRGEbQNqTSzTJ65FV8d79mCoyxoFfuWro0skrsXbv
 u/DsLEroee1AOgZ5Ds+jnElVCq1Ng5iugiBeNtQgSfhg5GLrs66Iv8D9lsTwlYxvOKNP
 6yQ5ybIfkyqm1GVblhrj3AFk+J+ar3Nc4pLhGGJ3i4IYBzl9t/3eINs2eI2ofhFv+MK8 fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtn4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:16:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LKAqEM004426;
        Thu, 21 Apr 2022 20:16:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm8a0y8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:16:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+tK+C/z9Pp5vNVz8PgGsYsQPiffxrGTS5/pcyZ415wgX3c7O780TvoC07udzqYvjAhYys5fdf1xu3iMVjggfGPtfw/jEb18KalTBcvirE2GbGV9UZiGeB4ZD5vJOo9LKlojv+MqRXDvS2B77cqS84xw0xETVlpihzVXY7o7zbloOl3XeaL5MTHBQuxJ1xYLF0EUfhFMs9Ee8PpPRNX9zo+1kUjYMC7fRWNDHklhrm4oouD/EOwZBvGmLdn0PHs9iEmBG1v7MmdlWYA71DbWA6TBwNOGZP82nGqqNsHPvfOINi9YWUd21kaqtCTwe2tplfVoralCieH6A7b8odz6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uyWeehdzn3A4HUfdaNigCAMYdxtFN4cWjYP+FeG1taY=;
 b=KEWIvXj13Ci3R9ISZ6fwB1wbETf/bHlzqBhsmZwt5UfkzmhgLK7cfRizFtx6FdounlKf7fxo82TE5im/9L2KFzYMX6E+oY7Q4FKubQdL5ZoKJKGw/g2UP6XmjhGuhQxQTfTOFihvGAPeXBbWzbAnPm8re/Ev07PSNjkVZCr+DeeZksSbDg4eD99PG8DhlaaOa/xe42U3drkU88fAKk4y+BBjrciQYW25JkyVmCl09GsZUdXjSVeyBC9oXv6wJXR9O1d7oN71mUFi5hVJUcMz9zkQ4nhQPbz7aIm7HRkkw5NoHnvRaU5GzHxJbiJHHAzPxtNKiBSSo5+3+pUNt1VN2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyWeehdzn3A4HUfdaNigCAMYdxtFN4cWjYP+FeG1taY=;
 b=sKE6S/uXIXlDHnzG5nDoWo7tG25PNucpzx39yq1f01CMeV31cCnY+GCn2lS9CYcH+aYFn9KKD5tyRNEE+VEQhZuDq8yHlhtxB02HPzDkzp6vDgA1wb8TEz+G+CgW/5fXsz2mBnLBiwsm5XuzdKThbJI/EiXD5Lj0MlKnJiGF/Pg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BL0PR10MB2963.namprd10.prod.outlook.com (2603:10b6:208:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 20:16:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:16:30 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 7/9] scsi_debug: Fix a typo
Thread-Topic: [PATCH v2 7/9] scsi_debug: Fix a typo
Thread-Index: AQHYVa5BC3li46XBWESOqo/KCLRIAKz6zgKA
Date:   Thu, 21 Apr 2022 20:16:30 +0000
Message-ID: <EA111F66-5F3E-400D-9332-0B436D5D6CB8@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-8-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd2c814f-2d68-40b3-ba85-08da23d3d2a2
x-ms-traffictypediagnostic: BL0PR10MB2963:EE_
x-microsoft-antispam-prvs: <BL0PR10MB296343AAA61B55885924A783E6F49@BL0PR10MB2963.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0mOMwUKhpIYY+d3wOH2edmGHQnYtuymLAvJg9v6HXLjmJ86pO4DyM3ygItPoB7fS3v98Dpf+dAifUFhQFIDxsUAtwyp5MaIEIfsfJq84qmXGGa7OpehItxwwoUwrm1s5ai1jHWmsby9nY/PK48Qh4BRy64ELGohBsRKHLE3Q3KOkqLFEYFnNwR6Y+myvRv/637RuPxMVoku//J/VUTFOU8y9qVe3IyRk+I206iRSIhyd8gBJa0xA3xAS1gZVf0R0YP/RbBLr/qtc0VoJ3zbUQjeVScPQJmr6KX8wOLBo1yn82IAdFdbx/6biD6LRvm9XJw1g4JS2C6JiG3j0n4NMxhQuWsDluS2iu4HR+q8qh6LXYBmcuOW0vb8iSA9rTuOpe4Nj1W/KC0dRl2RoYpnQFJls43GzTZqpVMp8uAMcfu7BYt4S8KijMDLUYTDuMRetSH8RLD8e0Ntuy4Wb1cZDiCKFBviF9PuaGMjQj9aXkh5JyEHIKO/BPccew3eSo9ZqBxLCy7dXBkFSaJL4zj70F9uhMRXMseQvG+Y5FZd9dg5BmzPo3n69aq0zieUxO+8LKiSZ/HpaDmSCxW0COonT5xSxsZw1egUl94pi/rpG0EuD/vPapy8UvSMmn++UPujTaTNfOY/olNfigsnmLOrU9JqO0nl0Ygru9cCpy1z1c5Ue4lahcZo2wPg5z2rIJd1B6c65lO0ljTLRwa1GjjrEyr9c9DhmF2NJ/R2n4mnmVkbe+SjSxlZqNQGhh+jDJHXR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(86362001)(4744005)(122000001)(2906002)(38100700002)(6486002)(6506007)(38070700005)(53546011)(186003)(8936002)(316002)(6916009)(6512007)(54906003)(26005)(33656002)(76116006)(66946007)(66476007)(66556008)(71200400001)(5660300002)(64756008)(91956017)(44832011)(83380400001)(2616005)(4326008)(66446008)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DdFhDv+a6pShF2PYOIQCDpuYBgap0NN3iQZGCikvMfJ78HNMLaSXRLieYszj?=
 =?us-ascii?Q?UnuA+RMlg/C4M7NJTdUTYvdcOWEzGyWGaBeP6dWGeBj1NeRKeyF/bnn/UOQG?=
 =?us-ascii?Q?OJoggV0W8EPg/G54onr6AgKDxorLjmufcLPBs0g3X0SfP6lvr+01xUNWzjqG?=
 =?us-ascii?Q?oGMlR/RmiVzWyJOFoEOnu8mJ8PM2+64QbdUWn+joYvfh8dg8jVtTAMycZCxv?=
 =?us-ascii?Q?ZBDMPfjaAmRSuYM9uIZOCOr/2TSQv8g7bzcvf4go7bpefc4Ql5G8d7KRByKi?=
 =?us-ascii?Q?zoFOezqzHSxH8V0hQBBHwQs8OzJBHFBoTyToLsiTBWRKyx/Eqrx1m6MUBq5N?=
 =?us-ascii?Q?YemrWfAp6mmipTCRLWmZeLo8kEw6ZOAUxKax3DHIDhnPPLa5D89Jx67SyQf7?=
 =?us-ascii?Q?RYnkMV8pUYtl1ZkaKgwcJd5Mb7Oo9D+TWo3SiEz7kSh8tV5CXHoruqmSmiVC?=
 =?us-ascii?Q?tmwrm6cFMUbrFvZ7B/jiDWUdwBUyx40a0+xRCaQFgMx0X+S+wi4qO/Y85gbr?=
 =?us-ascii?Q?q8XcetYK1d5S/RJYCl7xSknH3LgXPX5lgNFOXApiXVeH4AvaFKP/hlog+LSq?=
 =?us-ascii?Q?yqNudrj06qQKb4QOrPDo2UbeNUJmsfct8lyako5PBIvbeOSCfymopcs3rgCu?=
 =?us-ascii?Q?Zq+wS5npuiQsNLWor6822KXCYL0vKtR7tnmH+tBxYFkUbGRBynLSRTmkIn4Q?=
 =?us-ascii?Q?EXW+TcJSjfLmtAsat3NMun7xQ2ktcz7xGJ+DyJ1L9YOT+kccrJPbl3W1KVe/?=
 =?us-ascii?Q?wpAr1K0greLG83dazGUlzhJjDHJzDMsq+WqxJqfauXetWoFwMFOo1aaae3cv?=
 =?us-ascii?Q?UA+3Nh58crQG2bVhntCQeMyDUe3DgxAn80HjrEMbRHj6dIrHqcedZdT+0E/6?=
 =?us-ascii?Q?dTKWQlqWHzhkjygCEwOgiHRi5lqZpT8cv78I3NKoyljT7/ecWHqxoauTKA2f?=
 =?us-ascii?Q?guZhY3ddzaNn7pYZUyy7obJ6mW8cJ+Ud5rr9EZS2YHL0WX1QpTMbFjv4qsY2?=
 =?us-ascii?Q?ntXtK6MFxkIJgiVLU/z+beQyI1Amkgj8rWSbx/5prxsf4l0BW+qLrmXmcyV3?=
 =?us-ascii?Q?geTDzDHGhEmpXfilkoI4xwssoAEDbZQsL21MENYD+ycQ7E5JAja4+OdyOou+?=
 =?us-ascii?Q?2xbT0DfWoEWxjMzvwEM+QzrK0O8MrEWx1XLM5MxNDmfIG//Pff4VemaIv5FO?=
 =?us-ascii?Q?ytC4GkSENcVrf6tuPzgQqhGq/qbSL7WiUg42cUB7xtTOJrZSPG3Q0apaEmEj?=
 =?us-ascii?Q?Qj1YnGpFWfubq7rWCmXFhnxvIGv2tWRhUiwWKZMgsf7J7xUIJa3Rg5IL0It1?=
 =?us-ascii?Q?w6uU+uvjm6g7HsG8Z2CpqYX+29FC5Qq9u3demOi8Qu+vptxrZSKguGYvmNIH?=
 =?us-ascii?Q?3e5SXBZkanSsaIC9MoRf5LwDnB0nLyf762tRnro9Dfu7h+DVioGSqypUHiO8?=
 =?us-ascii?Q?1cY8xExPBhhOTGJ9VqOeMgwGslLcjehU0/qmNFcxH+DemSiCQBk77dlmcYoo?=
 =?us-ascii?Q?+cMg9qrrxeUc3tk53N/hFBy7m6+ps9BoTM7k+e/AJYj3neIRZT4aGyXRxLCG?=
 =?us-ascii?Q?Kobu6yFxju+v+OMsZ9BBzuadPen39qqI8hkFGpHNAUvSTbMlDL6wZO6qViAw?=
 =?us-ascii?Q?hQ+yYWobDvV9C18wVz2Jw2YHTFD+Bn8844sfAXakCX7Jv36EzqZ45kDQDjBt?=
 =?us-ascii?Q?CnjZYn5rtXjhPkVIh/d+uUJ8PYrvRiM4xPVYxbHxy+tCuDLvHhT6KYhfaJJO?=
 =?us-ascii?Q?86tp0O/v3qkHNVIKyK4w0x5LGz7Iq0h5kWJgO/WnPhU5vKprgoY2?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4B87C5256DF6645BA2EC3803AD364EA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2c814f-2d68-40b3-ba85-08da23d3d2a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:16:30.4673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DGQRuubye5Jidf6+GP8h4MBJEdICVWR0Kpg5L7HXigAN7NK9onxASYjd3s8iWUP2BEp65e1kHv8fXiJ7leGvZ7MaKDXQAAwtmxt3e/QEybo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2963
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210107
X-Proofpoint-ORIG-GUID: flGe-Q7wWh_MKjr03dEht3gK7JUkqxGB
X-Proofpoint-GUID: flGe-Q7wWh_MKjr03dEht3gK7JUkqxGB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Change a single occurrence of "nad" into "and".
>=20
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/scsi_debug.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c607755cce00..7cfae8206a4b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4408,7 +4408,7 @@ static int resp_verify(struct scsi_cmnd *scp, struc=
t sdebug_dev_info *devip)
>=20
> #define RZONES_DESC_HD 64
>=20
> -/* Report zones depending on start LBA nad reporting options */
> +/* Report zones depending on start LBA and reporting options */
> static int resp_report_zones(struct scsi_cmnd *scp,
> 			     struct sdebug_dev_info *devip)
> {

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

