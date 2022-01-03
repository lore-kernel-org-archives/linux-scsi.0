Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD65FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiACAcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:32:36 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43510 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiACAcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:32:36 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029DRog028072;
        Mon, 3 Jan 2022 00:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OL///E/KPn9w9RTea0u5+bNx4KFXaEqrHoMaikIev0c=;
 b=tATWxHcMuwtK9qhkaVJ4Z5MxwrJy15YwgIwf1wn5ujczIyI/FYvcszqwu7B8swbCSW6H
 bkxz18qdWaMFokupbHPeVF4F8KLUC0SlPh/3Wb+uT3AP1QxdDdajLTp1x0wtEV2JdDr5
 LreVNmUaVDSLaz1zIhfDb3PuZLOFx+IYCDvryAF/cAEzRG7hDzeZEwy7wH2dPNJ8N8mj
 Q4njdqCDW2mmh4heKeYoe6sMkF+od+0vdOMXderngJHDsYTs0cerjRDmf1ip6iKRxuJB
 4Mh1QwB10RUN1CZ2LV2DAKL35nrtEfVsxTvtw7ZQdVtIUD2DuNdML+xQgr0fGUJ0IUll AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadj1sqgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:32:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030Q9Pf143018;
        Mon, 3 Jan 2022 00:32:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3030.oracle.com with ESMTP id 3dad0bfmcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:32:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yyky0XdhDwmATbAhorFznWbBMc89QXgH7XYsbT8177CjvIyZ8N7cH0FHGOnGONK1rNlusXOah3jcFwSLcAbWqPmzu+Tj36FUYSv35aOElHeP1XXB1+Wv5QjTjE/5PBw1i1AmbBI9lwXePYlwf7kJqV1+q+kMpKUOHUqZM250sXfi722mR/7CVM5gdw8r3s5FUefRPva/RZuXvefJ0RAMZAJ/gW+TDmkRdgoSMEaksavgS4sf3k2n7ezjVA6Qsdtd7LVbzXRBW22n3hcgp6tCFrfEvTrvt1oZJ/B9MNDvmvUFsYXzUayg2ULohjigjaAV2RJqqXiX3yR+GnyQ9HPxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL///E/KPn9w9RTea0u5+bNx4KFXaEqrHoMaikIev0c=;
 b=f2zqUoyV4m5U04DKR5eI14qLZHoR8fLTR450QEikTXVqyDI/JkKkW/e+ZXqfEwMeVx7ctkrv4pnAWjj4xoNqq5z3FK+frHWEjJDglWVcehIwZsZeHNsUHqktobFDQ5G2Ll/JBjBmiY4aVEjv64i1OS97+LU7F2v/ftXeHcLJU7nAMKl0+kcIE6jqYMLt+OJYRi7E9z4f+G0hNM3XFQfiuMXlBE2UcShq/BuN1GJCj+ZsNRcEkSdZC5bgdAwpenhAvdyTTvfpllNoG3QZt1g9OEO1vcp7CpBy8siizFPAtsWf4OUCSPlmbmQNgy2yZp4zrci4cYe3CqVFaBJr9Wv3Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL///E/KPn9w9RTea0u5+bNx4KFXaEqrHoMaikIev0c=;
 b=SffY5RgFk7dmYjx3WYJH1ynnuSIJocPWIfnb1+sQAsH/UbpNRQ4c4Ovt4vwTDsY3W65bsgRDWH9h1em6p3a6gu5qhWHPVtOGX7R3jvmJtPRWZrooQaTBkUqyXWR4eD63tLEbJt9W63a+I/UhLE4xdGAKxibeKMYDJvTxuidYK7w=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 00:32:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:32:30 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/16] qla2xxx: Refactor asynchronous command
 initialization
Thread-Topic: [PATCH 01/16] qla2xxx: Refactor asynchronous command
 initialization
Thread-Index: AQHX+JT+9xjoQRgqQU6u0vwZ9xNKo6xQgZ2A
Date:   Mon, 3 Jan 2022 00:32:30 +0000
Message-ID: <06AB77AA-66B7-48B8-BB26-8AB77E06D45D@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-2-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06791ad8-6ca2-42a5-9a53-08d9ce5086e5
x-ms-traffictypediagnostic: SN6PR10MB2510:EE_
x-microsoft-antispam-prvs: <SN6PR10MB25103B853E33528B9DED6E14E6499@SN6PR10MB2510.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hmrFccDv+svqNTvzd1gtiQHY3kqyg45CasY2zX/rcoSbNf3+wHuAet+lVYaASFWyVZ65hbsXoipuADZ6gbebmG1Q1wQSUkDAzFUVN+P7PoL8JwJBU8blfdhIdfKrkwwxryNvjVPT7pc+E40FWkoNgH83QxuY911RbYJ+DRn3cpUSD/n8bz/vdt3CAW601J0Cuh2Y9ebWlfSuVjtmHNZ6bj6OhQTFw535jafmUYOxv6KH5Jb5cY/1z6RrdIdCgSBwtbSLDrNCouzSwlhiUnRWz/W/V0h6ldiJNDkGQ/1uqw/8VzIKV7wyWNqhShhA/RwqT5xPXfo4Jg7sEqJn5SNGMu2D9afZwaPu2Gkkl1R/eAk3DLpQ+qQ8VLmv8ZN8EUFAJIdj1MKUZuKo1XpP9xBAP084sVZsSr6A8o83/TxpNNcr/I4GzmhVOxm9tqNmUxLYJ5TZZjVbgd1OJHST83vpCX1DSprm2Hs1aEZpgDrHXDUaxPNgS2OW/w5ubZ2GsxVsm1CXyW9ce07qxFKM9VFhLdSXoO6ZXOQi8V4zrT0d+hjh1DK7Le+EeQkaW2YHRB7Z7lKozFF8VPDJt8pfmYvr/Hq3KA5Q9h7Z2oJ80jaKKXQhCAd/S5qe+HOn6/fuFOwHeruZOa9nB63rtxLtfpCS6HKhohMvSLc8aAHjRwb8xdHjIPz/ocEF3eBCBAtX9Ukp7BDxUHOfKRqUG3rXc5P9EufYdgGmV4V4ggerO1zIw4U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(86362001)(38100700002)(2616005)(38070700005)(26005)(508600001)(53546011)(6486002)(186003)(36756003)(6506007)(316002)(6512007)(83380400001)(64756008)(71200400001)(33656002)(5660300002)(8676002)(91956017)(66556008)(66446008)(66946007)(2906002)(76116006)(66476007)(6916009)(4326008)(44832011)(54906003)(8936002)(30864003)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e74aoZ1F2R68MXGHFvgKHrz+NgiRX2F6M8Xs8HdHMiA/pufqsIafN/LSdmv3?=
 =?us-ascii?Q?dRVbi3GNcEuDtMosXxzwsHRmAMFwvRpPm9LkA9VVx8kRO/QoPWOdeGoXjhaz?=
 =?us-ascii?Q?KWSiulUGHNX1INt4fYeB5w69w2LOauS+3Ej9UyXdqjQwO2C4Fo3iTMKs/swf?=
 =?us-ascii?Q?xC21XkU57QhHmDBwHoZQuR2HrZH4pMsv3zn+xwG2DlyO7EGSZ+c92+wqlCtP?=
 =?us-ascii?Q?AqPRf6FOMC7zpnD9LI3B2ISJMFaGjbNNlHaE+h6NMyxaJJ5Vp5o7cwEiEC9m?=
 =?us-ascii?Q?UdPA6efzOrPxtBcK9skgWCbx4Hc7ZaO3kAPo/PBB7oUCFhU0PwhHSrVeSBwy?=
 =?us-ascii?Q?zEQjSC+ePdxj5IrI9V6kUTUTDrDNPEN/6jczlRHVcVNYzbVc0DqePErrCmlE?=
 =?us-ascii?Q?D1wpvYsB7+3goO8MWcQSqdYgOBdsi7iIO6k40gqUlQ5XpIsGe0v1ttwoRynC?=
 =?us-ascii?Q?pQH8a9MCRS+7PhngylyvR1lqIZJlV/pUuNi/pfgjaFHLinZt4QyPM4eNFogT?=
 =?us-ascii?Q?LVyhkJOJACmn0BpsndnQDq5oUFEI9u2Z6hXeVX4z1IaqnGQC9KKJeU5RGp/r?=
 =?us-ascii?Q?BwRa74bbSZqz1Gb35C8U02bkxe/3A88ym8OfWiCMkmYg3wd8mqXjkNsgFx10?=
 =?us-ascii?Q?hgAYFzMH54Z+DEo2hVVDj+HJ5foAhH0nMASchzRCqcy6UulAUXE3FTGHkfMd?=
 =?us-ascii?Q?weV28+U5XvBdWt7W7NuEfFWypN7B7IewFRAYTIeHYERu706c/688/6NgBFqB?=
 =?us-ascii?Q?jsNT2jl3+PZ4FEP4/FlB4AImM+9gG23KHYJbz9eFavF7ud3zPBitUria+myR?=
 =?us-ascii?Q?JGHRLR5yV7z3opLhALcaDjD7FhSEcf18HzQAtzX1wKlYMsvjs7329v7rDGu7?=
 =?us-ascii?Q?rJbNUWEkE448kdByNX+XqlGot+DZBCzwD8Ne48+7HPZKMX+hpZaLTkEM+/FP?=
 =?us-ascii?Q?4BIKz68mEid2IH6UotbOBrXgkS8ODxT218ui65EfnjYvT9PwzIkd8Xx+NO8r?=
 =?us-ascii?Q?RPPUByZQC3HRIIklQj3Y2nMxzKMxvNOYzQtYbfGkUtEctCGp9eMfc3/jE4Eb?=
 =?us-ascii?Q?VIJmrbH20JWFeTrSf9Nl353SSGJ2gJrCUz6dTzEsoUVqw8CKbm0UR2vn2ZZZ?=
 =?us-ascii?Q?Q12WuEZVb1fB3PzJAAsAXw84WDfWg9Oh6E0ez3PJRBVCmSNUonqIPpGj/h97?=
 =?us-ascii?Q?4CMoMJiVVeEqRkwsVfoCgDpr6JvrMvm/s7HsTqJ8MQFMdswsSFeQL4gIyqO1?=
 =?us-ascii?Q?IczNdQLvD/OZm+LAEIWH8dYtzlqYgTPdBFHyg3wj4KjKmj1X6p4DNBxIYm8V?=
 =?us-ascii?Q?jFcumHoLXAtsTCaamLLnVvTGZdwOqUtEEuRgeV+0N9fCaEIF1PS5RC6HhXcm?=
 =?us-ascii?Q?mbP7gvVMB2sV7NqnIGN5kjBVG7DmfY/6KVGbF8xSm1ca5aXfaN/QGnDgXVnY?=
 =?us-ascii?Q?jgerVrTU74jhRRNhkrzigR05eqOZMyO9wqFszOyJyfuxsMVGwFEL1M+N2M47?=
 =?us-ascii?Q?XA0KXr9hUP659Th2H3zgNL8OldYI+VAVuZxlkBK97zm0gtceYO1ssY+HtXdh?=
 =?us-ascii?Q?v57Fj/kIMtO/V8zTST0Io4ZclWyZQ4rAAp2WMmu2sEfCGfa8Qp3t1tvwz7SJ?=
 =?us-ascii?Q?VLVS2OG2h+8uicSZpGaFUK2xjGVsgK3BsbuuiR9oAO+6R2Ys+xiW8kfs8cQo?=
 =?us-ascii?Q?lYq8YmsNv1paVN7hHEDJwcjOrBo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78A640A3E9DCD94A8B879783B50EC55C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06791ad8-6ca2-42a5-9a53-08d9ce5086e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:32:30.4441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7Dwt59H2EesX75QYw3PPrtyvinzplIlIdakAK6+JVL0sJsmzmIN3G66/e8XIWKgogNQL0+HwDKhi6dVyFR5wcC0Qml7gN1lZZ0lP42QH+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030002
X-Proofpoint-GUID: e-pWpPU7QRcp3Vv7MKVfXFAuLsxPOCxC
X-Proofpoint-ORIG-GUID: e-pWpPU7QRcp3Vv7MKVfXFAuLsxPOCxC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:06 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Daniel Wagner <dwagner@suse.de>
>=20
> Move common open coded asynchronous command initializing code such as
> setting up the timer and the done callback into one function. This is
> a preparation step and allows us later on to change the low level
> error flow handling at a central place.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h    |  3 +-
> drivers/scsi/qla2xxx/qla_gs.c     | 70 +++++++++-------------------
> drivers/scsi/qla2xxx/qla_init.c   | 77 ++++++++++---------------------
> drivers/scsi/qla2xxx/qla_iocb.c   | 29 ++++++------
> drivers/scsi/qla2xxx/qla_mbx.c    | 11 ++---
> drivers/scsi/qla2xxx/qla_mid.c    |  5 +-
> drivers/scsi/qla2xxx/qla_mr.c     |  7 ++-
> drivers/scsi/qla2xxx/qla_target.c |  6 +--
> 8 files changed, 76 insertions(+), 132 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 8d8503a28479..5056564f0d0c 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -316,7 +316,8 @@ extern int qla2x00_start_sp(srb_t *);
> extern int qla24xx_dif_start_scsi(srb_t *);
> extern int qla2x00_start_bidir(srb_t *, struct scsi_qla_host *, uint32_t)=
;
> extern int qla2xxx_dif_start_scsi_mq(srb_t *);
> -extern void qla2x00_init_timer(srb_t *sp, unsigned long tmo);
> +extern void qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
> +				  void (*done)(struct srb *, int));
> extern unsigned long qla2x00_get_async_timeout(struct scsi_qla_host *);
>=20
> extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 28b574e20ef3..744eb3192056 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -598,7 +598,8 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port=
_id_t *d_id)
>=20
> 	sp->type =3D SRB_CT_PTHRU_CMD;
> 	sp->name =3D "rft_id";
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_sns_sp_done);
>=20
> 	sp->u.iocb_cmd.u.ctarg.req =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
> @@ -638,8 +639,6 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port=
_id_t *d_id)
> 	sp->u.iocb_cmd.u.ctarg.req_size =3D RFT_ID_REQ_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D RFT_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla2x00_async_sns_sp_done;
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - hdl=3D%x portid %06x.\n",
> @@ -694,7 +693,8 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port=
_id_t *d_id,
>=20
> 	sp->type =3D SRB_CT_PTHRU_CMD;
> 	sp->name =3D "rff_id";
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_sns_sp_done);
>=20
> 	sp->u.iocb_cmd.u.ctarg.req =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
> @@ -732,8 +732,6 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	sp->u.iocb_cmd.u.ctarg.req_size =3D RFF_ID_REQ_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D RFF_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla2x00_async_sns_sp_done;
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - hdl=3D%x portid %06x feature %x type %x.\n",
> @@ -785,7 +783,8 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port=
_id_t *d_id,
>=20
> 	sp->type =3D SRB_CT_PTHRU_CMD;
> 	sp->name =3D "rnid";
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_sns_sp_done);
>=20
> 	sp->u.iocb_cmd.u.ctarg.req =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
> @@ -823,9 +822,6 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D RNN_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla2x00_async_sns_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - hdl=3D%x portid %06x\n",
> 	    sp->name, sp->handle, d_id->b24);
> @@ -892,7 +888,8 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
>=20
> 	sp->type =3D SRB_CT_PTHRU_CMD;
> 	sp->name =3D "rsnn_nn";
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_sns_sp_done);
>=20
> 	sp->u.iocb_cmd.u.ctarg.req =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> 	    sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
> @@ -936,9 +933,6 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D RSNN_NN_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla2x00_async_sns_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - hdl=3D%x.\n",
> 	    sp->name, sp->handle);
> @@ -2913,8 +2907,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_por=
t_t *fcport)
> 	sp->name =3D "gpsc";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla24xx_async_gpsc_sp_done);
>=20
> 	/* CT_IU preamble  */
> 	ct_req =3D qla24xx_prep_ct_fm_req(fcport->ct_desc.ct_sns, GPSC_CMD,
> @@ -2932,9 +2926,6 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_por=
t_t *fcport)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GPSC_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D vha->mgmt_svr_loop_id;
>=20
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla24xx_async_gpsc_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0x205e,
> 	    "Async-%s %8phC hdl=3D%x loopid=3D%x portid=3D%02x%02x%02x.\n",
> 	    sp->name, fcport->port_name, sp->handle,
> @@ -3190,7 +3181,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_=
id_t *id)
> 	sp->name =3D "gpnid";
> 	sp->u.iocb_cmd.u.ctarg.id =3D *id;
> 	sp->gen1 =3D 0;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_gpnid_sp_done);
>=20
> 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> 	list_for_each_entry(tsp, &vha->gpnid_list, elem) {
> @@ -3238,9 +3230,6 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_=
id_t *id)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GPN_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	sp->done =3D qla2x00_async_gpnid_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0x2067,
> 	    "Async-%s hdl=3D%x ID %3phC.\n", sp->name,
> 	    sp->handle, &ct_req->req.port_id.port_id);
> @@ -3348,9 +3337,8 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	sp->name =3D "gffid";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla24xx_async_gffid_sp_done);
>=20
> 	/* CT_IU preamble  */
> 	ct_req =3D qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFF_ID_CMD,
> @@ -3368,8 +3356,6 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GFF_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->done =3D qla24xx_async_gffid_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0x2132,
> 	    "Async-%s hdl=3D%x  %8phC.\n", sp->name,
> 	    sp->handle, fcport->port_name);
> @@ -3892,9 +3878,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha=
, struct srb *sp,
> 	sp->name =3D "gnnft";
> 	sp->gen1 =3D vha->hw->base_qpair->chip_reset;
> 	sp->gen2 =3D fc4_type;
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_gpnft_gnnft_sp_done);
>=20
> 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
> 	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
> @@ -3910,8 +3895,6 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha=
, struct srb *sp,
> 	sp->u.iocb_cmd.u.ctarg.req_size =3D GNN_FT_REQ_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->done =3D qla2x00_async_gpnft_gnnft_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s hdl=3D%x FC4Type %x.\n", sp->name,
> 	    sp->handle, ct_req->req.gpn_ft.port_type);
> @@ -4057,9 +4040,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc=
4_type, srb_t *sp)
> 	sp->name =3D "gpnft";
> 	sp->gen1 =3D vha->hw->base_qpair->chip_reset;
> 	sp->gen2 =3D fc4_type;
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_gpnft_gnnft_sp_done);
>=20
> 	rspsz =3D sp->u.iocb_cmd.u.ctarg.rsp_size;
> 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
> @@ -4074,8 +4056,6 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc=
4_type, srb_t *sp)
>=20
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->done =3D qla2x00_async_gpnft_gnnft_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s hdl=3D%x FC4Type %x.\n", sp->name,
> 	    sp->handle, ct_req->req.gpn_ft.port_type);
> @@ -4189,9 +4169,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	sp->name =3D "gnnid";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_gnnid_sp_done);
>=20
> 	/* CT_IU preamble  */
> 	ct_req =3D qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
> @@ -4210,8 +4189,6 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GNN_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->done =3D qla2x00_async_gnnid_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - %8phC hdl=3D%x loopid=3D%x portid %06x.\n",
> 	    sp->name, fcport->port_name,
> @@ -4317,9 +4294,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_p=
ort_t *fcport)
> 	sp->name =3D "gfpnid";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_gfpnid_sp_done);
>=20
> 	/* CT_IU preamble  */
> 	ct_req =3D qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GFPN_ID_CMD,
> @@ -4338,8 +4314,6 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_p=
ort_t *fcport)
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GFPN_ID_RSP_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
>=20
> -	sp->done =3D qla2x00_async_gfpnid_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0xffff,
> 	    "Async-%s - %8phC hdl=3D%x loopid=3D%x portid %06x.\n",
> 	    sp->name, fcport->port_name,
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 1fe4966fc2f6..e6f13cb6fa28 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -167,16 +167,14 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wai=
t)
> 	if (wait)
> 		sp->flags =3D SRB_WAKEUP_ON_COMP;
>=20
> -	abt_iocb->timeout =3D qla24xx_abort_iocb_timeout;
> 	init_completion(&abt_iocb->u.abt.comp);
> 	/* FW can send 2 x ABTS's timeout/20s */
> -	qla2x00_init_timer(sp, 42);
> +	qla2x00_init_async_sp(sp, 42, qla24xx_abort_sp_done);
> +	sp->u.iocb_cmd.timeout =3D qla24xx_abort_iocb_timeout;
>=20
> 	abt_iocb->u.abt.cmd_hndl =3D cmd_sp->handle;
> 	abt_iocb->u.abt.req_que_no =3D cpu_to_le16(cmd_sp->qpair->req->id);
>=20
> -	sp->done =3D qla24xx_abort_sp_done;
> -
> 	ql_dbg(ql_dbg_async, vha, 0x507c,
> 	       "Abort command issued - hdl=3D%x, type=3D%x\n", cmd_sp->handle,
> 	       cmd_sp->type);
> @@ -320,12 +318,10 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_p=
ort_t *fcport,
> 	sp->name =3D "login";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_login_sp_done);
>=20
> 	lio =3D &sp->u.iocb_cmd;
> -	lio->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> -
> -	sp->done =3D qla2x00_async_login_sp_done;
> 	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
> 		lio->u.logio.flags |=3D SRB_LOGIN_PRLI_ONLY;
> 	} else {
> @@ -377,7 +373,6 @@ int
> qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
> {
> 	srb_t *sp;
> -	struct srb_iocb *lio;
> 	int rval =3D QLA_FUNCTION_FAILED;
>=20
> 	fcport->flags |=3D FCF_ASYNC_SENT;
> @@ -387,12 +382,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_p=
ort_t *fcport)
>=20
> 	sp->type =3D SRB_LOGOUT_CMD;
> 	sp->name =3D "logout";
> -
> -	lio =3D &sp->u.iocb_cmd;
> -	lio->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> -
> -	sp->done =3D qla2x00_async_logout_sp_done;
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_logout_sp_done),
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0x2070,
> 	    "Async-logout - hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x %8phC ex=
plicit %d.\n",
> @@ -439,7 +430,6 @@ int
> qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
> {
> 	srb_t *sp;
> -	struct srb_iocb *lio;
> 	int rval;
>=20
> 	rval =3D QLA_FUNCTION_FAILED;
> @@ -449,12 +439,8 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_por=
t_t *fcport)
>=20
> 	sp->type =3D SRB_PRLO_CMD;
> 	sp->name =3D "prlo";
> -
> -	lio =3D &sp->u.iocb_cmd;
> -	lio->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> -
> -	sp->done =3D qla2x00_async_prlo_sp_done;
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_prlo_sp_done);
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0x2070,
> 	    "Async-prlo - hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x.\n",
> @@ -575,16 +561,15 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_p=
ort_t *fcport,
>=20
> 	sp->type =3D SRB_ADISC_CMD;
> 	sp->name =3D "adisc";
> -
> -	lio =3D &sp->u.iocb_cmd;
> -	lio->timeout =3D qla2x00_async_iocb_timeout;
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_adisc_sp_done);
>=20
> -	sp->done =3D qla2x00_async_adisc_sp_done;
> -	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
> +	if (data[1] & QLA_LOGIO_LOGIN_RETRIED) {
> +		lio =3D &sp->u.iocb_cmd;
> 		lio->u.logio.flags |=3D SRB_LOGIN_RETRIED;
> +	}
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0x206f,
> 	    "Async-adisc - hdl=3D%x loopid=3D%x portid=3D%06x %8phC.\n",
> @@ -1084,7 +1069,6 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, in=
t res)
> int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
> {
> 	srb_t *sp;
> -	struct srb_iocb *mbx;
> 	int rval =3D QLA_FUNCTION_FAILED;
> 	unsigned long flags;
> 	u16 *mb;
> @@ -1117,10 +1101,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, f=
c_port_t *fcport)
> 	sp->name =3D "gnlist";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	mbx =3D &sp->u.iocb_cmd;
> -	mbx->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla24xx_async_gnl_sp_done);
>=20
> 	mb =3D sp->u.iocb_cmd.u.mbx.out_mb;
> 	mb[0] =3D MBC_PORT_NODE_NAME_LIST;
> @@ -1132,8 +1114,6 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc=
_port_t *fcport)
> 	mb[8] =3D vha->gnl.size;
> 	mb[9] =3D vha->vp_idx;
>=20
> -	sp->done =3D qla24xx_async_gnl_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0x20da,
> 	    "Async-%s - OUT WWPN %8phC hndl %x\n",
> 	    sp->name, fcport->port_name, sp->handle);
> @@ -1269,12 +1249,10 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_=
port_t *fcport)
>=20
> 	sp->type =3D SRB_PRLI_CMD;
> 	sp->name =3D "prli";
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_prli_sp_done);
>=20
> 	lio =3D &sp->u.iocb_cmd;
> -	lio->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> -
> -	sp->done =3D qla2x00_async_prli_sp_done;
> 	lio->u.logio.flags =3D 0;
>=20
> 	if (NVME_TARGET(vha->hw, fcport))
> @@ -1344,10 +1322,8 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, =
fc_port_t *fcport, u8 opt)
> 	sp->name =3D "gpdb";
> 	sp->gen1 =3D fcport->rscn_gen;
> 	sp->gen2 =3D fcport->login_gen;
> -
> -	mbx =3D &sp->u.iocb_cmd;
> -	mbx->timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla24xx_async_gpdb_sp_done);
>=20
> 	pd =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> 	if (pd =3D=3D NULL) {
> @@ -1366,11 +1342,10 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha,=
 fc_port_t *fcport, u8 opt)
> 	mb[9] =3D vha->vp_idx;
> 	mb[10] =3D opt;
>=20
> -	mbx->u.mbx.in =3D pd;
> +	mbx =3D &sp->u.iocb_cmd;
> +	mbx->u.mbx.in =3D (void *)pd;
> 	mbx->u.mbx.in_dma =3D pd_dma;
>=20
> -	sp->done =3D qla24xx_async_gpdb_sp_done;
> -
> 	ql_dbg(ql_dbg_disc, vha, 0x20dc,
> 	    "Async-%s %8phC hndl %x opt %x\n",
> 	    sp->name, fcport->port_name, sp->handle, opt);
> @@ -1974,18 +1949,16 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint32_t lun,
> 	if (!sp)
> 		goto done;
>=20
> -	tm_iocb =3D &sp->u.iocb_cmd;
> 	sp->type =3D SRB_TM_CMD;
> 	sp->name =3D "tmf";
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
> +			      qla2x00_tmf_sp_done);
> +	sp->u.iocb_cmd.timeout =3D qla2x00_tmf_iocb_timeout;
>=20
> -	tm_iocb->timeout =3D qla2x00_tmf_iocb_timeout;
> +	tm_iocb =3D &sp->u.iocb_cmd;
> 	init_completion(&tm_iocb->u.tmf.comp);
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
> -
> 	tm_iocb->u.tmf.flags =3D flags;
> 	tm_iocb->u.tmf.lun =3D lun;
> -	tm_iocb->u.tmf.data =3D tag;
> -	sp->done =3D qla2x00_tmf_sp_done;
>=20
> 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
> 	    "Async-tmf hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x.\n",
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index ed604f2185bf..95aae9a9631e 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2560,11 +2560,15 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry =
*tsk)
> 	}
> }
>=20
> -void qla2x00_init_timer(srb_t *sp, unsigned long tmo)
> +void
> +qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
> +		     void (*done)(struct srb *sp, int res))
> {
> 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
> -	sp->u.iocb_cmd.timer.expires =3D jiffies + tmo * HZ;
> +	sp->done =3D done;
> 	sp->free =3D qla2x00_sp_free;
> +	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> +	sp->u.iocb_cmd.timer.expires =3D jiffies + tmo * HZ;
> 	if (IS_QLAFX00(sp->vha->hw) && sp->type =3D=3D SRB_FXIOCB_DCMD)
> 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
> 	sp->start_timer =3D 1;
> @@ -2672,11 +2676,11 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int e=
ls_opcode,
> 	sp->type =3D SRB_ELS_DCMD;
> 	sp->name =3D "ELS_DCMD";
> 	sp->fcport =3D fcport;
> -	elsio->timeout =3D qla2x00_els_dcmd_iocb_timeout;
> -	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
> -	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
> -	sp->done =3D qla2x00_els_dcmd_sp_done;
> +	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT,
> +			      qla2x00_els_dcmd_sp_done);
> 	sp->free =3D qla2x00_els_dcmd_sp_free;
> +	sp->u.iocb_cmd.timeout =3D qla2x00_els_dcmd_iocb_timeout;
> +	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
>=20
> 	elsio->u.els_logo.els_logo_pyld =3D dma_alloc_coherent(&ha->pdev->dev,
> 			    DMA_POOL_SIZE, &elsio->u.els_logo.els_logo_pyld_dma,
> @@ -2993,17 +2997,16 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int =
els_opcode,
> 	ql_dbg(ql_dbg_io, vha, 0x3073,
> 	       "%s Enter: PLOGI portid=3D%06x\n", __func__, fcport->d_id.b24);
>=20
> -	sp->type =3D SRB_ELS_DCMD;
> -	sp->name =3D "ELS_DCMD";
> -	sp->fcport =3D fcport;
> -
> -	elsio->timeout =3D qla2x00_els_dcmd2_iocb_timeout;
> 	if (wait)
> 		sp->flags =3D SRB_WAKEUP_ON_COMP;
>=20
> -	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT + 2);
> +	sp->type =3D SRB_ELS_DCMD;
> +	sp->name =3D "ELS_DCMD";
> +	sp->fcport =3D fcport;
> +	qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT + 2,
> +			     qla2x00_els_dcmd2_sp_done);
> +	sp->u.iocb_cmd.timeout =3D qla2x00_els_dcmd2_iocb_timeout;
>=20
> -	sp->done =3D qla2x00_els_dcmd2_sp_done;
> 	elsio->u.els_plogi.tx_size =3D elsio->u.els_plogi.rx_size =3D DMA_POOL_S=
IZE;
>=20
> 	ptr =3D elsio->u.els_plogi.els_plogi_pyld =3D
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 10d2655ef676..2aacd3653245 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6483,19 +6483,16 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha=
, mbx_cmd_t *mcp)
> 	if (!sp)
> 		goto done;
>=20
> -	sp->type =3D SRB_MB_IOCB;
> -	sp->name =3D mb_to_str(mcp->mb[0]);
> -
> 	c =3D &sp->u.iocb_cmd;
> -	c->timeout =3D qla2x00_async_iocb_timeout;
> 	init_completion(&c->u.mbx.comp);
>=20
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	sp->type =3D SRB_MB_IOCB;
> +	sp->name =3D mb_to_str(mcp->mb[0]);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_mb_sp_done);
>=20
> 	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
>=20
> -	sp->done =3D qla2x00_async_mb_sp_done;
> -
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> 		ql_dbg(ql_dbg_mbx, vha, 0x1018,
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 1c024055f8c5..c4a967c96fd6 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -972,9 +972,8 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
> 	sp->type =3D SRB_CTRL_VP;
> 	sp->name =3D "ctrl_vp";
> 	sp->comp =3D &comp;
> -	sp->done =3D qla_ctrlvp_sp_done;
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla_ctrlvp_sp_done);
> 	sp->u.iocb_cmd.u.ctrlvp.cmd =3D cmd;
> 	sp->u.iocb_cmd.u.ctrlvp.vp_index =3D vp_index;
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index 350b0c4346fb..e3ae0894c7a8 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -1793,11 +1793,11 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *=
fcport, uint16_t fx_type)
>=20
> 	sp->type =3D SRB_FXIOCB_DCMD;
> 	sp->name =3D "fxdisc";
> +	qla2x00_init_async_sp(sp, FXDISC_TIMEOUT,
> +			      qla2x00_fxdisc_sp_done);
> +	sp->u.iocb_cmd.timeout =3D qla2x00_fxdisc_iocb_timeout;
>=20
> 	fdisc =3D &sp->u.iocb_cmd;
> -	fdisc->timeout =3D qla2x00_fxdisc_iocb_timeout;
> -	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
> -
> 	switch (fx_type) {
> 	case FXDISC_GET_CONFIG_INFO:
> 	fdisc->u.fxiocb.flags =3D
> @@ -1898,7 +1898,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fc=
port, uint16_t fx_type)
> 	}
>=20
> 	fdisc->u.fxiocb.req_func_type =3D cpu_to_le16(fx_type);
> -	sp->done =3D qla2x00_fxdisc_sp_done;
>=20
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS)
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 8993d438e0b7..83c8c55017d1 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -656,12 +656,10 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, =
fc_port_t *fcport,
>=20
> 	sp->type =3D type;
> 	sp->name =3D "nack";
> -
> -	sp->u.iocb_cmd.timeout =3D qla2x00_async_iocb_timeout;
> -	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
> +	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> +			      qla2x00_async_nack_sp_done);
>=20
> 	sp->u.iocb_cmd.u.nack.ntfy =3D ntfy;
> -	sp->done =3D qla2x00_async_nack_sp_done;
>=20
> 	ql_dbg(ql_dbg_disc, vha, 0x20f4,
> 	    "Async-%s %8phC hndl %x %s\n",
> --=20
> 2.23.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

