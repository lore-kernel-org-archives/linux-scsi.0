Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E92C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392176AbiDUUHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386080AbiDUUG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:06:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2449FB7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:04:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LIEFVt009531;
        Thu, 21 Apr 2022 20:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wo4N6dl+4t19r5Q1LbogW9cB4uQYNc7+bSkUwp7Qoi0=;
 b=KzwxqN6NwaVwql756bkYlWK5EkFBH2VzLLYVKpswcu3zgXYYQnjNlkdP5hp+fsKBhzQk
 k/a/nhkM03SiQiIH0JLO0x1K8e8KpIOxZGaHe3wS9p6j7BxYMsh5cFse1yfPRum/4M+v
 t7/TMXM/3Z02wXn1zWmlTB27sLiWwR/pT7bF8Cm1G2L5oEzT7xbQyuSTtv4imM+tTM1L
 6nj2V7enyH2eKdpgURzV10nNFjeSzwtn0C6erws3RNu3iMOBAoVAOHvIHEgTqDj3LnJu
 eKxgiON58va7fDvegWGG1Ahw4ktr8aT5RxWtEW4x9ophaLTwmGEL+XheFhD7YqOLrSq+ vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2w28g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:03:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LK2DXq022957;
        Thu, 21 Apr 2022 20:03:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8cqa3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:03:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPlLSnH6TwEJ7S4xadiKlmGwZcxPbkSyXNfCptuiCEEK6E0RIYJu2m2xVAU2RktmeGznyl/1Y0H8wx+dPBbHAh0opXawewXdCTm7mz1JM2C8a+XGpeVGd5ffjfE49KeKGdOCCrlt+bKsoS4pPop72+I9xfHI9v2m8e4vRVzorhf90aeyYHRTxSAblTQF08tmB/f40kYKGYG+aeUBvtNtNaBdCZyMhYe+ZGuZO218Z8chydfTSlHCpGM7xo3FgtEZscPyhsDC/gDW75RReQj+kZCCII/DcRvSJOJQybmz4Uljgr6y5QF+u82zAER5GJzu9hyprJ4TNsFfIMusQdTTNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo4N6dl+4t19r5Q1LbogW9cB4uQYNc7+bSkUwp7Qoi0=;
 b=U893wo1cg2ffSuW5oN286l7vJVGkE85mqi4Ylf9ev89uAgOWZq2ry+gQFdtj22/KvwIJz86DhIga7aHM5QYp6Ku6RqEYCkz0oMVfo/oeIfBn9QHRiEJBRdYJG6CgR9lUzVVDgpgVcb8IdhoI1st15zpA9yaIPvMwmE1TfWGKzcG7G3eWZWQe3Lzsdttp1x4A6f2cRjop6v3uBL1EhoNUu2KoaiMKdY9GEL4iXQSHiCMpVp+sAbjypx71WPYYBCAHJPZfqfjZgTKFuTsrxzoHEd4ZVHrHF0CJJ1Rc2kxvDMdQDH4nXx+OofMw1HJINPn0n7bBwcnZanajIh0CsiVujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo4N6dl+4t19r5Q1LbogW9cB4uQYNc7+bSkUwp7Qoi0=;
 b=JP79bX00I9h/HZHogXOAPP2izTeuup933FPYS3IEOgd9fQj54SKKcEa+na8yGBTG9eLWR3dGW2tImeFYGoXm1YLnO9qhoXyTPV28xn6BBN5aXLcNgB388pIejKuD7sfQPcexW79WcuQibTa6HvxDf9Ct8v/iZqmJEtK9yG/uSOU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1720.namprd10.prod.outlook.com (2603:10b6:910:a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Thu, 21 Apr
 2022 20:03:50 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:03:50 +0000
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
Subject: Re: [PATCH v2 1/9] scsi: sd_zbc: Improve source code documentation
Thread-Topic: [PATCH v2 1/9] scsi: sd_zbc: Improve source code documentation
Thread-Index: AQHYVa5Ag+XeLs8QJUuynys2c/rxG6z6yniA
Date:   Thu, 21 Apr 2022 20:03:50 +0000
Message-ID: <78344F6A-88B5-44BE-852E-637E326C3ED7@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-2-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 164c477a-bb79-44ff-ca42-08da23d20d98
x-ms-traffictypediagnostic: CY4PR10MB1720:EE_
x-microsoft-antispam-prvs: <CY4PR10MB172060FE7695CA81AEE61A3CE6F49@CY4PR10MB1720.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ev4b7M1osOkf/2ozBWJwX9ZL4vwPY9BUUCd4g3zikNY7jAYjpKobTnvqmw9pg6hVmIsiI33sCMv4o0Ap5x+83JzitX0shcg+uzqRiu8aXPYk6BnfFW6Z5JsivquXigAVgoa5NUviM9Ir9zY+v2bSfgXftaqcK4NcavXwXj+RP8SblMnM0r4UZUFVNuKcv4PAAMXAExUx9LF/XbiYY6TFPgILJh0X/16Fbetl/839wnO4lHW7AJismU6K4HL8t+s4rnecFmWWO3wEC+KJEit43gRMRoaTIvfdCPJKEUvvo0mfo0F4/MnN5eOGovh8+H9xOQ7e8esbo1GZ/AjfFVmFJOZO0rRGhNk/5c5UehbhpLG/QHEhSPy6qlDsr1VUNH73Q2LXTfSttpQWjuqDCZwprJS3A9iweQNvSGrkxp9PirYxy5ccV4Rd3tBesava65edxH7iAZ/2VsZsm2EcIK4AqrTms8GNRcGtJucNZ1h29n5z5Uj3EUrHVc5VbSM6/2xS9gaSip/huE5bpi4vKWoW7bY+PXKw9aYFpw/3QWKmA/JmwXFzZ+AnQEPoW/FH7mkJ73MO8+mGM1itmL5uW0C+RgvfwF6zWMboUiorThpUbyCyUanvFUnEYgZwNMOySAk8Odk5+LDX66wO8jdbcMNpDmChaDMuPnNaHHPth12H+JiU02Ua/sDGkna8k7f07nmPq2kItZ6y71CG11zmhkD34e9VfaH6z9LyJMILSoQlUKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(2906002)(4326008)(83380400001)(6512007)(38070700005)(53546011)(8676002)(33656002)(316002)(8936002)(5660300002)(38100700002)(44832011)(26005)(66556008)(76116006)(64756008)(508600001)(91956017)(6916009)(122000001)(66946007)(2616005)(86362001)(6486002)(66476007)(66446008)(36756003)(54906003)(71200400001)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CuUNqjmZLGgl88a5hj3J5MvZEh6MY0neBuf2y69GFmyngQ4iIFviA7eP0oir?=
 =?us-ascii?Q?ZP25ZQxp5BWDB1uMcJ2fihdAHVLgSk0XUJRVH5AF/WloRUDorAbsT8js4cWP?=
 =?us-ascii?Q?0vXNi1ar2j1q4LjaLPV0Y63Zieke0j5JqjHjtlZUGSEUPdhq8tI7UB44u6BI?=
 =?us-ascii?Q?D3QtCEaafmFzPbkeFIYMl7L6Jpzo5c4JWbSoX+N5raq+H6+K9yVbM4aw0XqF?=
 =?us-ascii?Q?SVBEEBZERv1mNrr4I1rDT+3us52clD4BU8lrPexCeV3QIiKQkJDV9Zi+jJd7?=
 =?us-ascii?Q?xBWCmm9teE0//NL905jvVxGqBo/6baGiIn3vSXjLg+T/Zq7ep6eMLwUym55d?=
 =?us-ascii?Q?F6qKrQ7egOWcNqRlqbz+saaGeYXrfVOBZLWymonbf9vtvwfD49qBRSSOTSMy?=
 =?us-ascii?Q?OF6uW6LByN2ca9ZVrbNR/t1xAj/dpNqWcNYHiV07miCARwhrNrPfAfXbyQt7?=
 =?us-ascii?Q?ANZ8oYkhOcOV+vo2CRYBNRWTTgSieN4Ih/LHWT25G44pCgunFEelP55RgG2Z?=
 =?us-ascii?Q?NChnfzTFLcMXR/CKXqTVYuhvRfL3BmsKHqvWuuy5tCdsDJxbyilrM6eN8Z7v?=
 =?us-ascii?Q?TocQrjZOFQWeBBO9VPLOd3rjGUS0Jlsw8FWLs716FfQ1QRV/s73EF8iRAM5j?=
 =?us-ascii?Q?qDLDr0EQTpCyIfULSa8x8dGsaoYJGezQGjTDs1Tu1ueR7E3m2Jpfyz8ALt3g?=
 =?us-ascii?Q?wkzIP7d4Swt0kGcvdMN+aIpAC7BECBy/d4oZvfDOX5V79XY7ENgHWkXWgR8W?=
 =?us-ascii?Q?8E339TxdoZJ+i8iUlRPD0Ja6E23j8Sk/qjgloMmc4PhKbA5m8j/lMrVEsn8G?=
 =?us-ascii?Q?QVcxVrus+XjH+CfjykR3tFWG31+l2tSNyzy1c8Mge0u9EmYy+9xHwbGumMRc?=
 =?us-ascii?Q?iOKDjq055cf3wWX8f9Ozb1hrZBzQF6X3Xf7ctxASL2yyPrAa6cHqnOUdNmjb?=
 =?us-ascii?Q?9o2hSdzbHAJXp3RGEZfsgbur0eCtGusa28RGPPJv3jhNyEENUnUWs2KPIAWG?=
 =?us-ascii?Q?PFFKEfsWkzEU13aOq8s5GflwXtLZ0Wd3BUZIDh+0MtIQuKrO1B8EUuBfLptB?=
 =?us-ascii?Q?LhW6ujMVtOIpgAsMqPi0aQOJS/FFkNUXVXSgLV4aKaOwsZiacbMLEs7SzQTx?=
 =?us-ascii?Q?vIQ92QkXoCiZaFxOI+/3/KAzZQQ24wWpL4kDmz2pszJQhcmWZhi/wBSe0jTT?=
 =?us-ascii?Q?DG15gWqQjR2K2cXJ/vybcYEbbj23QLbRB4t0wQgN3aFtyI1hdsmJdc7uu5+e?=
 =?us-ascii?Q?O1lRAx1hKPvz+BOzJAINpBI+Zx/emhM0NjXMo7T4kEbLfa+SLLOCnPhrcCAV?=
 =?us-ascii?Q?jcD4DoGSUwMgFRqGRI2QBz146wT5zTO4K97rso9Pol+ZpAp8dHDRk2nKCR84?=
 =?us-ascii?Q?pqN+dsF5kPicjB5aLbudc+aAshNQSZqZKgCAIh3U0J4Vh8v1nPI9hEkBN6L9?=
 =?us-ascii?Q?8qmi1zkAyY/+IH3BtJETljb1dWZbT7W3CWC/t4n50ZQzOOZ9zEcxNldKeb2S?=
 =?us-ascii?Q?15hBYH7KvvI5yfROAixWFiNlzYxxXOFe1cTBSijnjnrVNiuLEIC7plcHq5VG?=
 =?us-ascii?Q?nO/fyYAHth/0gaB1ynN+cvQNbRVNacY348E7OXp74l4rwGygnemtRQEdelbg?=
 =?us-ascii?Q?jdpFrqgpYeHrjI0DrbMnXatAeUOBb4xCYVHS9jA98fVyEQJ8UepY9O7zdg8O?=
 =?us-ascii?Q?4sROLjPDOboowQh8GBBrKz8kz8BNt357pIv6w/u551fheZXDH9ZkD3KZtSS/?=
 =?us-ascii?Q?yo7o4gw7Jl5FoMNWvh8dljFl8vnefa9iAnHfD8btg+Ddz5wB4AIS?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEE05C866EE6894EBFBDBC6140993B59@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164c477a-bb79-44ff-ca42-08da23d20d98
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:03:50.3474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZpnyHnLB4ndTbbzhrAUztjiODDW6Xe+tVR2B1kb5HGLbUM6PaWXUqsmYCOwstZh7LS+9yA+LlWqv3jD2FLsMRykJ5XlmkjPw3x36aU+HA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1720
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210106
X-Proofpoint-GUID: u_p-zG_L6GC6TJ2AxvvYk6p21U1VkRJa
X-Proofpoint-ORIG-GUID: u_p-zG_L6GC6TJ2AxvvYk6p21U1VkRJa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Add several kernel-doc headers. Declare input arrays const. Specify the
> array size in function declarations.
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd.h     |  5 ++--
> drivers/scsi/sd_zbc.c | 55 ++++++++++++++++++++++++++++++++++++++++---
> 2 files changed, 54 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 0a33a4b68ffb..4849cbe771a7 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -222,7 +222,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
> #ifdef CONFIG_BLK_DEV_ZONED
>=20
> void sd_zbc_release_disk(struct scsi_disk *sdkp);
> -int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
> +int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
> int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
> blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
> 					 unsigned char op, bool all);
> @@ -238,8 +238,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,
>=20
> static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
>=20
> -static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
> -				    unsigned char *buf)
> +static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BU=
F_SIZE])
> {
> 	return 0;
> }
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 7f466280993b..2ae44bc52a5f 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -20,6 +20,12 @@
>=20
> #include "sd.h"
>=20
> +/**
> + * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
> + * @zone: Zone for which to return the write pointer offset.
> + *
> + * Return: offset of the write pointer from the start of the zone.
> + */
> static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
> {
> 	if (zone->type =3D=3D ZBC_ZONE_TYPE_CONV)
> @@ -44,7 +50,21 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct b=
lk_zone *zone)
> 	}
> }
>=20
> -static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
> +/**
> + * sd_zbc_parse_report - Parse a SCSI zone descriptor
> + * @sdkp: SCSI disk pointer.
> + * @buf: SCSI zone descriptor.
> + * @idx: Index of the zone relative to the first zone reported by the cu=
rrent
> + *	sd_zbc_report_zones() call.
> + * @cb: Callback function pointer.
> + * @data: Second argument passed to @cb.
> + *
> + * Return: Value returned by @cb.
> + *
> + * Convert a SCSI zone descriptor into struct blk_zone format. Additiona=
lly,
> + * call @cb(blk_zone, @data).
> + */
> +static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
> 			       unsigned int idx, report_zones_cb cb, void *data)
> {
> 	struct scsi_device *sdp =3D sdkp->device;
> @@ -189,6 +209,17 @@ static inline sector_t sd_zbc_zone_sectors(struct sc=
si_disk *sdkp)
> 	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
> }
>=20
> +/**
> + * sd_zbc_report_zones - SCSI .report_zones() callback.
> + * @disk: Disk to report zones for.
> + * @sector: Start sector.
> + * @nr_zones: Maximum number of zones to report.
> + * @cb: Callback function called to report zone information.
> + * @data: Second argument passed to @cb.
> + *
> + * Called by the block layer to iterate over zone information. See also =
the
> + * disk->fops->report_zones() calls in block/blk-zoned.c.
> + */
> int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
> 			unsigned int nr_zones, report_zones_cb cb, void *data)
> {
> @@ -276,6 +307,10 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zon=
e *zone, unsigned int idx,
> 	return 0;
> }
>=20
> +/*
> + * An attempt to append a zone triggered an invalid write pointer error.
> + * Reread the write pointer of the zone(s) in which the append failed.
> + */
> static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
> {
> 	struct scsi_disk *sdkp;
> @@ -585,7 +620,7 @@ static int sd_zbc_check_zoned_characteristics(struct =
scsi_disk *sdkp,
>  * sd_zbc_check_capacity - Check the device capacity
>  * @sdkp: Target disk
>  * @buf: command buffer
> - * @zblocks: zone size in number of blocks
> + * @zblocks: zone size in logical blocks
>  *
>  * Get the device zone size and check that the device capacity as reporte=
d
>  * by READ CAPACITY matches the max_lba value (plus one) of the report zo=
nes
> @@ -696,6 +731,11 @@ static void sd_zbc_revalidate_zones_cb(struct gendis=
k *disk)
> 	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
> }
>=20
> +/*
> + * Call blk_revalidate_disk_zones() if any of the zoned disk properties =
have
> + * changed that make it necessary to call that function. Called by
> + * sd_revalidate_disk() after the gendisk capacity has been set.
> + */
> int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> {
> 	struct gendisk *disk =3D sdkp->disk;
> @@ -774,7 +814,16 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
> 	return ret;
> }
>=20
> -int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
> +/**
> + * sd_zbc_read_zones - Read zone information and update the request queu=
e
> + * @sdkp: SCSI disk pointer.
> + * @buf: 512 byte buffer used for storing SCSI command output.
> + *
> + * Read zone information and update the request queue zone characteristi=
cs and
> + * also the zoned device information in *sdkp. Called by sd_revalidate_d=
isk()
> + * before the gendisk capacity has been set.
> + */
> +int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
> {
> 	struct gendisk *disk =3D sdkp->disk;
> 	struct request_queue *q =3D disk->queue;


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

