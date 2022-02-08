Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D66C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 19:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386005AbiBHTWu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385664AbiBHTWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:22:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A151DC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:22:48 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I3Tvg013064;
        Tue, 8 Feb 2022 19:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rmYM8i/37J/WPMewtchDK3qEfyIcxTUryPVnx4ImwGU=;
 b=z28npF3nee/Z+JmjiNnBDQIpH/hnUQ0bPyhW20UtFMkAnVixbn8GpUIV+T9N52F1cjqR
 cOnLTh3TUdW7SXHIj6eblHZTVi6wZH2jh3qOrwxnZIxfaW7Pv0VCTuDreMbwN2k4tSXY
 nbqxwnPehGBDzC+GGekfn165zG6AT4ki2Py2xM+P4Yernd25/YECj5aKda+k5m8c+dCa
 mjZDx1cIMNFePjBMaQL4x4fmuGlZgJh3gRTrbcr3sQutKIRsYuNC60ocOiSkfA8KddhJ
 6y+BUrozZoDUnAF0KjkQMNVdiEgA9xgGy8pv1XhPAzK12Fu/44//bFDMm05aujqD/bpa gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgjhq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JFn6X172194;
        Tue, 8 Feb 2022 19:22:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3e1ec0xrus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsjnjcwEGE3IpAUxzxpQ2ek/sW2oc68wPXffs221epY50RTGg+pmxxD6QeohCBqSEX1jOkK9OgkAxDNGDMTMcofapnKDaBuCknUuqz4pASEyLDykv6GiEzJVWv1ohCjad7EcvQc02IKEQiX43Byh6UYlO/v49XchA6UcR0X7GzpCT/4OW6AbNLutKp3j3EIgxaHmXPEZL3ogsT8w1WdOVlspBPoEXKO0CMxRdyoOssdDFWRtUzJ7aSgnNAZ3oU7tbs9IBF2opaMv46breXdvV97zlKYT5xGMEqqHsfhq/4DzxWETqDIMUFs2qahqVrTp/5wiBllGw/4u+wMP7VE6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmYM8i/37J/WPMewtchDK3qEfyIcxTUryPVnx4ImwGU=;
 b=dP02ZJdIIC6JDYX7KOls4jc8skJ2h8cYPuvMfbDcs6A62e1pVs1204IYxuqVdqy+eopcQHAwgt6UWx1C3pwYWq2KY6JctbZsh6Y36w8tI6q/Ts1Zq7TgGGk0+awT0yB1gwPPMCx0AVlHC9mphXdDTnceX4Jj7jh63dR59eblisIyuk467ykyGqZEYNhStO3NNX/ZWj+6ii/5XmxaP50hEnhtIZc0ifNEjHdCDXlA6Env+GDE7BF4s7FBPCWeJnZnNa9rPe5Jpo9/hVcz1sAp7YXAhkqZfSY1Pfr2O6TdJbjq0+7+Y5Knoyf+CjCtB9ZmNgGK8HncMBYmn/KD7n0NnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmYM8i/37J/WPMewtchDK3qEfyIcxTUryPVnx4ImwGU=;
 b=ulcuQ0gYew1Rh4BNeEd4kLBJefbrRUQnXiYOt6/uaYOmBYSYbQycOdGj/W4vFL2luBl4MV04fC90OkQjwa2ycTQkcs7tSXeAAhe+t4pthfxRv3ZTFkc/qW/PmxNUkBdsyjpGikJvpVXwW+QS0469ntBXw92g00E8Ar8r40/P0RU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB3248.namprd10.prod.outlook.com (2603:10b6:208:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 19:22:11 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:22:11 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
Thread-Topic: [PATCH v2 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
Thread-Index: AQHYHREfVlNoBywASE+5cc/HnStVC6yKCDSA
Date:   Tue, 8 Feb 2022 19:22:11 +0000
Message-ID: <D1D4A081-273E-44F2-9BB7-54F9F033BFFF@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-5-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14dcbe4f-b189-4121-830e-08d9eb384e6c
x-ms-traffictypediagnostic: MN2PR10MB3248:EE_
x-microsoft-antispam-prvs: <MN2PR10MB32488E91F9F7FCACF89FDDE5E62D9@MN2PR10MB3248.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P7/v6uaCB3bBlN+lL15xY/8xo7XBJwKSwkCkqtVO3OCf7OT8tbOZ9hqN/FGGuHbqRQScOXbUva3Z5tde2pmDBKLc69GFd0pZ5CKjnZjrGMA6okLZ/VBqxlvQ/gbH9IaXjy2WvRsCrorY+Wb7HrobRYrhTiRB4h7Y6f4ZeRAHDoQ1GFeL9l37HnD5Xn7gJ31vperLlbJYbQSDJQJYqZkZXjnlxfAp8H8ANu1to1rw5JEeCyLmvRDxqcDKRcCXOzWsfq3PFOS897nGqxkH7qyUuq5un37qwBRsAe+SPoLOFdWF16usGWegF9KACFgLOtpdt/m69jo0milBU5XgiaM7uS3ipAJF3o5D1xFhFV0Gprody4eDGXuWSdfp8OiFEfvBk6e1TLdfWufEmm8t58ei+z6KdsxiKBrxk7gjq6fR+KcuoYZ+wj+qg3eCzuDAfFYFWTu97qfzxQqW7BDVMYXWkHUuot6NJxGm1DBJy7oyfu99xEHcjUho+fNVgM5Z5v1BorIo4agb1/DaeQ6DQucDz9ZMdJ6BK2GdlIcz2yChcRoBCKD2HdAzx4063QgTkWrSyDx9E2SK57odfRHFD3Rx0+BV0SK3xQYf3m0TqkZSf+56hw59SkvqhPGk8TDSjiZMJjNg8vtB0KAXykh5mLOMoxFHig9U8sTeC7kQFTrj+ikQxRYkCJhhyPPkm24TmW9zYqcWXpZW+fdAYD6NkUhF/oJ5rBYhRw1LIBhHEe14eijbOr5IYGSfv3CvIYusGtFw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(44832011)(186003)(71200400001)(5660300002)(7416002)(2616005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(6506007)(8936002)(66946007)(6512007)(91956017)(38070700005)(53546011)(76116006)(2906002)(26005)(83380400001)(86362001)(6916009)(508600001)(122000001)(38100700002)(6486002)(316002)(36756003)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nMyEDnCvMHdxbUaibsXfVeneTYBiUfVqv4A1+htR66nTvkh3vnm8a9juxav+?=
 =?us-ascii?Q?2mYpdNuq6eoZc02lilXgNadVguxDbQT7MVEYDsF4XOLYc2t8yGUHvx/fqREm?=
 =?us-ascii?Q?Du5O1WGuG4WDyr6xTuyoM7o0ieE/uMoMZj3SC6EZCvEftyJGCkQrTgO3Xiwq?=
 =?us-ascii?Q?z0/7bhFykaoLKf1s93lHLvmkGp7Mz+k6ShFV9+AlkFW4+trsIEF501sZrg2E?=
 =?us-ascii?Q?cWqC1R8A89TWVoQY5emBgDd3GxhCHa/KQK0/JbMVsynXW4Wpz5l1o3yo8nHM?=
 =?us-ascii?Q?YQs/aLylItyVMgkEmwCttIR4N9SiE/2F91ja+FMwSDA5gKpSJlSVydVtgplh?=
 =?us-ascii?Q?rPHIMm+yv5VmYOBa/ajMSA4kZGjTadXwX17U2uBNFoWk1CZxIymAdFOvUxeJ?=
 =?us-ascii?Q?+Cxt9UF46RuAm7TBRRUSmtK2SM5UCS14vCsH2Fa4hOvSH03P+XnK8KCHA0o0?=
 =?us-ascii?Q?gl4jtcr6B92Cey4wq704R/D/UBW/r9Y/BXQSqgK/aKvNGAG2E+y728BFY1wg?=
 =?us-ascii?Q?xf7MVTEemDBEdUBx25illLc9JOZ5RGHD+sbJ/0/NtJlPJHoRV3yjcfAYb3Qs?=
 =?us-ascii?Q?mX9dauuVN/gag37HWiyi7prQWDQbXwTsQOLqkBQaMEcTwZEYKQVcwoix0y0W?=
 =?us-ascii?Q?4ZRfg0BOJoIgQOS3SXm/8LwymIG4w5IroLUGDz52pzv+Uobfw/c+cQX65o4A?=
 =?us-ascii?Q?lRpW/vGu0hw49aHPsZOZRWRp2x48qp1tbqlNywxynBV4tb7kuo46vn2kd8LY?=
 =?us-ascii?Q?gPTCEL/eTehqviZL3QVLkF0LJX8+8UDMjZ7X+saLlatCGoQq2PsX1atKYWqr?=
 =?us-ascii?Q?N9gu0/6Gns4KL75yhFDZD9oPSRhyMuRJMqRCFy+9MNuIwTxwpkBsv6HSDrTK?=
 =?us-ascii?Q?e7d8n5mrrRP23rLI/RBXwdUzukkgilaj69zHwqgskR03oPwHg1RaeTo2YkuD?=
 =?us-ascii?Q?YKjecEOxaqvwOP8czB//3RcccAi11TvpMQzfMuXw1qmlhgd3mB4GCIuL8mkz?=
 =?us-ascii?Q?kqOHo5H6iys966JQi/7XL0coceMexiL/uBS7cUPsWTOU7oEpooX5NdY5dnAq?=
 =?us-ascii?Q?7Khwva6c+3NvK113eihwuVMI+2054aIeB6ZU//dwYoEw/mwbrTS04X5TYHaM?=
 =?us-ascii?Q?FlXQ5gE0n8FgvHOtGUYm6TVNwj2QyMBGSiGYydaEjzyZ3uwC1n21lWaxfJn4?=
 =?us-ascii?Q?Dlcp8LaEjlAlCfJkz4Z/VyDUdT8BzTHqJOt3nKgZhfXzChKTa3ejMLkRFXBz?=
 =?us-ascii?Q?/zttPgMAgl5LX+//hCnyvsMZ3voTFY0bmd17OAFffwaF2T3ODGYsWZ4MdvS5?=
 =?us-ascii?Q?ocpSDZVfGHRbwtzboDa2uxL+8ILDjYUvA8B34zA98kvhe5AMjEN+g1Ht6r2U?=
 =?us-ascii?Q?zTCMfxlPXeg+5nt5OvBTXxpTNcapwqdMWMnQOwznS1F/Umu1MJp+l/l1RfVw?=
 =?us-ascii?Q?7W+l/nrACuxNiQEmmEHT0W4VUQ4Ajc97KzLXVnGyRBEtmLibfuakMBypvrjC?=
 =?us-ascii?Q?T7ItHaN88VN/3t2Vq2FyNvLrdTD0o2I8iysYb5ec5qYHspRMzDirEQcmvyT9?=
 =?us-ascii?Q?BZDdSelZ1sUSimGCDEOivwK1jEetta1QQh4S2lOAI6LyBXJWQzBR1U0F6SVz?=
 =?us-ascii?Q?rCaDm3VFnTgZ0SWFRgS1xQeWwFFFi7mLSdMBApisI6gFCraJfWhanQ4p8Lji?=
 =?us-ascii?Q?tt/cTIMe7/pJCPaknJQGEvU1InY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F10621FF25F35349966ED14C0746FCAB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dcbe4f-b189-4121-830e-08d9eb384e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:22:11.5284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ac3m2VhBZ3lLJBPwGVQ7SRkzU8pC5I592enlA0yWmwm2pIYi3fbUV6CBeGGwEfJrYnAl5El1biW25h9dq5TIohTJzrVs0I+wIp4A+fm5iHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3248
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080114
X-Proofpoint-GUID: 4ZA5yGnaq123G6jDISe9ETJwICDV7mI6
X-Proofpoint-ORIG-GUID: 4ZA5yGnaq123G6jDISe9ETJwICDV7mI6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This makes it easier to find users of the NCR5380_cmd data structure with
> 'grep'.
>=20
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/NCR5380.h      | 2 --
> drivers/scsi/arm/cumana_1.c | 2 +-
> drivers/scsi/arm/oak.c      | 2 +-
> drivers/scsi/atari_scsi.c   | 2 +-
> drivers/scsi/dmx3191d.c     | 2 +-
> drivers/scsi/g_NCR5380.c    | 2 +-
> drivers/scsi/mac_scsi.c     | 2 +-
> drivers/scsi/sun3_scsi.c    | 2 +-
> 8 files changed, 7 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 8a3b41932288..845bd2423e66 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -230,8 +230,6 @@ struct NCR5380_cmd {
> 	struct list_head list;
> };
>=20
> -#define NCR5380_CMD_SIZE		(sizeof(struct NCR5380_cmd))
> -
> #define NCR5380_PIO_CHUNK_SIZE		256
>=20
> /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during =
PDMA */
> diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> index 3fd944374631..5d4f67ba74c0 100644
> --- a/drivers/scsi/arm/cumana_1.c
> +++ b/drivers/scsi/arm/cumana_1.c
> @@ -223,7 +223,7 @@ static struct scsi_host_template cumanascsi_template =
=3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D 2,
> 	.proc_name		=3D "CumanaSCSI-1",
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> 	.max_sectors		=3D 128,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> };
> diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
> index 78f33d57c3e8..f18a0620c808 100644
> --- a/drivers/scsi/arm/oak.c
> +++ b/drivers/scsi/arm/oak.c
> @@ -113,7 +113,7 @@ static struct scsi_host_template oakscsi_template =3D=
 {
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> 	.proc_name		=3D "oakscsi",
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> 	.max_sectors		=3D 128,
> };
>=20
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 95d7a3586083..e9d0d99abc86 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -711,7 +711,7 @@ static struct scsi_host_template atari_scsi_template =
=3D {
> 	.this_id		=3D 7,
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> };
>=20
> static int __init atari_scsi_probe(struct platform_device *pdev)
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 6df60b31ecb0..a171ce6b70b2 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -52,7 +52,7 @@ static struct scsi_host_template dmx3191d_driver_templa=
te =3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> };
>=20
> static int dmx3191d_probe_one(struct pci_dev *pdev,
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 7ba3c9312731..5923f86a384e 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -702,7 +702,7 @@ static struct scsi_host_template driver_template =3D =
{
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> 	.max_sectors		=3D 128,
> };
>=20
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 5c808fbc6ce2..71d493a0bb43 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -434,7 +434,7 @@ static struct scsi_host_template mac_scsi_template =
=3D {
> 	.sg_tablesize		=3D 1,
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> 	.max_sectors		=3D 128,
> };
>=20
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index f7f724a3ff1d..82a253270c3b 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -505,7 +505,7 @@ static struct scsi_host_template sun3_scsi_template =
=3D {
> 	.sg_tablesize		=3D 1,
> 	.cmd_per_lun		=3D 2,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> -	.cmd_size		=3D NCR5380_CMD_SIZE,
> +	.cmd_size		=3D sizeof(struct NCR5380_cmd),
> };
>=20
> static int __init sun3_scsi_probe(struct platform_device *pdev)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

