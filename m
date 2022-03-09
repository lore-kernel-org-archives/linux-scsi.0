Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03563C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiCISmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiCISmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:42:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B595186429
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:41:43 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229GfXnA010464;
        Wed, 9 Mar 2022 18:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IpdAX7ZSLFqJGUX+RZRUiNZJjLiU3pDdUG59p3dH/9k=;
 b=YKBYCMXvqV+2EVtggC9GIGL71MTbKGokJ96t5Iz9tnGaTsfq3M5LBvg8X4pk+mEIawWM
 zOyXNj2HIdph/AL9FIUSQ574jZqUKs0RVcSgKxJP6U5/GlWmZBjdKojSdPpwflIXK1mm
 rTrs4N9ylO0D1C78K2Qy+SsHFoAknqo7WbtYtRdLZPQoo1GwS1vT/vdytTyFnLbiPRAx
 noM/3TF25/uaQXfmL1CjWIQUFNj1JJpGIc9M5wQaABjUbDlyvdwTZknhfW0dSLbQ8Y/v
 C2xwOGLDU6pekkIP/h2Wm9Nj40DKo5bG4DGfw88Ft8FCby2A41CgoABiQLIiITO+REJp fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0u207-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:41:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229IfdoZ166852;
        Wed, 9 Mar 2022 18:41:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3030.oracle.com with ESMTP id 3ekwwcygd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czMqN73hPJKM/4ptul7I865S7iG7U6t5P7x5tPcPpVQL1kOOCEUXQVlNS0Q3YCIgjbg6oI9/f6yoWSkLZN+8dJVxKO3kpUEInpTdMThDyYaHaXJlLB1KlKRrrucV1UtKvShDEvHBw7Od6kkOZI0UjrQKWgz/88PgZdS0kvnD9ccm8RsfE2AE7PNwZnDJTuoGHi6coyi5QPMr9A2O7x49SmKSFqTPkESY6Uvc2q9rESKpMOYMNDfnyFF/vx9C56zp29JQTlBDBYN7D93wQodlg0GoHu69kE2kpqjMTIo0tkeyGaqkIlCa/2/OTwc3kn8JsHScpAB4N/KnS31SRP/VpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpdAX7ZSLFqJGUX+RZRUiNZJjLiU3pDdUG59p3dH/9k=;
 b=lO/JVhrF9gXsNfa1zTSjrsh8ho5uXZ7SvFBsenp0O5FizJKSbLJCQso5Mjk0NoZ5kkbV/Ged77hUImeiKLsDT6em/ZtkrwV5uIROUpzNTGg+aIhaSHTRHIOAb/FU7ALttf/Ulqoi1EAhgWLy8W0PYX9xHN3SShv7CFVy9cGBttUkKwBLXWGczSU3BToxBbZ4RcqJ+tlQsnL/LJWK+0RBUyAQw2rQrSYDS2rMt2iQbEqB/Cmq+89yrQe8g6g8v3OKzzKqhv+805XE/L1Zm9rhzFXagobjuyAkVKkr36EkhScZiw9exzC9CwORlbAYJ+0V6trCt6EHgDBWDjUU04LzOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpdAX7ZSLFqJGUX+RZRUiNZJjLiU3pDdUG59p3dH/9k=;
 b=w1DE+/JY+GMcNFYA5vHj++tyIP70J2X4aS1Vk/WEjr3q9k6/ys51yrUOoTQLf72oiT8ldNChSy/gv5MP720lsVAa2MqqYKgjbnfFJr5QVBIYVHa8hrQvLqqs7v1dVyHlOLjEeXlWz5i8l2MSq95hoycqzAGkCj30Cgq8gSGETag=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3721.namprd10.prod.outlook.com (2603:10b6:5:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 18:41:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:41:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 04/13] qla2xxx: Fix missed DMA unmap for NVME ls requests
Thread-Topic: [PATCH 04/13] qla2xxx: Fix missed DMA unmap for NVME ls requests
Thread-Index: AQHYMsWBnUzj1rHTmUChAnl+vwL8Xay3ZQuA
Date:   Wed, 9 Mar 2022 18:41:31 +0000
Message-ID: <AEC08EDE-3B0A-4715-9A4E-FFBCEB48777A@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-5-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af917d2-5aef-40cb-61fe-08da01fc6e5a
x-ms-traffictypediagnostic: DM6PR10MB3721:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3721E9BFFDF3244661E176AEE60A9@DM6PR10MB3721.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3DkjnGTECLdBp9fqVeDUsyEO2xWabTZZ3r/vBKWaIUBqX+ccLqWrEjfL/qYApTYFjqxMHNhaiYF5ntE38qj5gmELLVOS9nOvjRQVPGIwCQLiS7NbEsMrYsKE4f82afEB3tn0vkQrdwlyyiO+fLqdSig15xE1kxEtud7t3IPV2wsYFxr3JPkbnqsV2G0WcZQFdCaqWWxBivDj1DgrxVc6dVDhJHzCVasMfjnrceEhbpBsm+ntCEd4y1q9urb3EmXD5WZmLAIKy91M5bYFRUYsdJr6UrD73s7/eExBuqLHrGXgL8KMHe6pvPV/ODM7K3+hTgXpMScfllZ8opqJ4CpD+yx5y6Ud/YNP/J1lB0YlY8Hd6guzORElnysG2go8QGplqwenbB5C4vxv/p0iSxzRbNFYaZ1j2WsgWX3a8YeRWJcRhkSSgCjFMhTywnuhVNdAfaFm+t4oyNey8lH6i+4+GP/EXmX/Ro2dj6r5YT0n2ol/YbB/NHWKt/PAQmW6K0DOUMvjFdMfnSfkIWx3nW9RvzCVaDEpYLf7XhUhl/9FRO8PsiAMlsh/Qz76ovEfWoFQXhVdXNZSysSKiyUdlPWuID45yGs0hB1FuW2TS9iQDjbA3zk9CQHKJeVgtJooZ36Npuj30kCoB8Onfb/Ye0qzqIVSgCuACSgUHWapIcT1CkLibA8eIQti2UNR0z3HP3xnqPvG1Divp+54A9VHFXnpBftP40LkCv10smG3Pltji8ZjFIUY7OPUSmEJUfGKom2wFFVq2fcUa9z3ZKuyQpXN7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(316002)(6506007)(54906003)(33656002)(6486002)(508600001)(2616005)(36756003)(186003)(26005)(83380400001)(6512007)(66556008)(53546011)(91956017)(4326008)(66946007)(76116006)(66446008)(66476007)(38100700002)(8676002)(64756008)(2906002)(38070700005)(8936002)(6916009)(5660300002)(122000001)(71200400001)(44832011)(45980500001)(159843002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yWmBGhAfXvf5hqzXXA1Ey8GEQ3vfx31B6hbFohr4Keqp7CZUB3/fhw4siTUM?=
 =?us-ascii?Q?5T0rK3rcwtiht/LLIIB8RnhMpR+1aeICtTIErMMN3j5tIaWD9ML1UCHRzYYQ?=
 =?us-ascii?Q?+rO6ypflxpFfJtlTf0UPq2BhjZFe1zAgdu9FN0vrlbK3s6JlEZ4QBFl3vFPU?=
 =?us-ascii?Q?iRiR2/kH/iYXu2OKX91/eA6mXmOZ6vn3A90W/AcxjcIqCOlRN+Xo2sSlKrTn?=
 =?us-ascii?Q?cx37/rp4AVRSheUxY4d9D5OhgSR9RFJTVZ9njIGNZL99WP5POXth+I/qUhx8?=
 =?us-ascii?Q?Ayl9tkhea9DxaLpAfoK50DhSXHu8LSQdy14NEaawZwzyvaK43FtQVDyb5Y3m?=
 =?us-ascii?Q?SkGI1DmYFbZRm85JqEpeY7QhQGPDWvlkX79sV/5TEzYvnAWKJn+s5EoVn893?=
 =?us-ascii?Q?QGMpLiHX7b8drR+rTHHsZjAgxFaRXfR1fXFZ03g7NdWSN7ZitF3tt2HPXxHh?=
 =?us-ascii?Q?ownxqr+JSa042V3U7Qwt9hh7s/NTp5XfVXSLf1OKHOX867ZgfNU2ZsEy3Uy/?=
 =?us-ascii?Q?2+k4GPW1N2WzxgGY4DmSRImsMtZscq40sJ3/KgQwQAcvdKQFktmJzx9Gm4gy?=
 =?us-ascii?Q?Rr+b76mQ1n1Hb0dfGZyUGQSWjx6cnyXqsZiE37qPA4DXACLYq3fAbDOBv0rI?=
 =?us-ascii?Q?lDO9aD6JtrXvvo8N1mxgYo6e+ofteYjMWQcA+vM7JD1prBwDBtJvFTAp+vbV?=
 =?us-ascii?Q?EUrxiYysuWsGhKKl64Utw9PMZLVRaO6revlxWI1NXDjl/OeIa7EuSkW/CarI?=
 =?us-ascii?Q?3ncrAKUUOgB1gRGbbltF4nogRN449Wlf2czDjCnTBMJmfhhn5+Xvh67TWDZV?=
 =?us-ascii?Q?K9Mhzxxl27UVulNvnbF2dpiPeTfwTXHK9ul1h9FhouAVqQPkJBnPlfujwGEe?=
 =?us-ascii?Q?IalhambRPRUM6zJbPWHzha0X19OdaXOi0XORKKnVPiAe2oaYYP7NGnjXAqcL?=
 =?us-ascii?Q?mVOEt2sk/jcoY7/gdgJGTWO6Kk1IMxaGhsgmLCGNn1UT80TFW2XajNStvFQu?=
 =?us-ascii?Q?R5aFLiUXxg2HSfxfsi3BShMh0wVcAO5Ivpfu+Q/YEUpd8+LNOdfTCjP7gcDY?=
 =?us-ascii?Q?0k0OVZQlZK9GN5EG9KZiLcgUkVpvF8H2GHsdtWVMBhigr5XVxgiuiPaVpKKP?=
 =?us-ascii?Q?0DYqTG+yH6kb2c0bd/vKWBX+tlOndH5hsLnj/CD+7e2ieaRYSOeVZ60fDo6R?=
 =?us-ascii?Q?B7ll7bQMP6ChmMsa2Jju17iL45+yBIhcroyQ9UHA0LDWtRVGTj6uR8eWTTXD?=
 =?us-ascii?Q?+DXkIQJjvv9DJHZvWRapTjOLYwmfIs2WxvgWN2Xn/WlbZ/iKX7C8Z2dYLFDw?=
 =?us-ascii?Q?8ICxd9cbRUVh5iwQax8/FLSWBbIJUfhACC+tfCJX7IPFuiz1D1ZOqVoW7CXP?=
 =?us-ascii?Q?H1tR6d7fmhn7pR41YwjE6SUNr6ppF8cD/G3l9piThqwikTvwgTWC00Yx0Ybq?=
 =?us-ascii?Q?/I12aR9nm07sSHvFPjHyLrA4T6v6JkMWdzsA6SL69BIhGZRzG0/4bGxBWaHf?=
 =?us-ascii?Q?kt38P9w9RJYgwEU7eJhMqzqM6dc4uRO/Fx+kwfkR4UvBcUZ/bVsQ3iEjoIXk?=
 =?us-ascii?Q?eZGI9v7TH3+kYT3uxHm7RLAmfXhw9imiOLT63veumRU1CneTkRGg45kWsdw9?=
 =?us-ascii?Q?2AR5FX3fowTppCJbZtDkCLq0bV/vE8pc3GXvIpSImkC1ds9nBCot6w8HE9pJ?=
 =?us-ascii?Q?GSMYsbE4zQ0OEb1w15XyJpOeG+U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98BAEA94D368F04EA8BDE5726422CA73@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af917d2-5aef-40cb-61fe-08da01fc6e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:41:32.0056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUT1bJ7dwyjkekMCm10/VxtpbGmLthe5L6YltSMvMadNj9K+YdiiFLCFV4PdgxwnLeDxoTs2oZoDiuslnj8eya4ge/c+fF5d6sdyTryMp8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3721
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090102
X-Proofpoint-ORIG-GUID: a9Ajuy_vS-UZcQNBsnJfbj_fgy8SJnoe
X-Proofpoint-GUID: a9Ajuy_vS-UZcQNBsnJfbj_fgy8SJnoe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> At NVME ELS request time, request structure is DMA mapped
> and never unmapped. Fix this by calling the unmap on
> ELS completion.
>=20
> Cc: stable@vger.kernel.org
> Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and t=
ransport registration")
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 3bf5cbd754a7..794a95b2e3b4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -175,6 +175,18 @@ static void qla_nvme_release_fcp_cmd_kref(struct kre=
f *kref)
> 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
> }
>=20
> +static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
> +{
> +	if (sp->flags & SRB_DMA_VALID) {
> +		struct srb_iocb *nvme =3D &sp->u.iocb_cmd;
> +		struct qla_hw_data *ha =3D sp->fcport->vha->hw;
> +
> +		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
> +				 fd->rqstlen, DMA_TO_DEVICE);
> +		sp->flags &=3D ~SRB_DMA_VALID;
> +	}
> +}
> +
> static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
> {
> 	struct srb *sp =3D container_of(kref, struct srb, cmd_kref);
> @@ -191,6 +203,8 @@ static void qla_nvme_release_ls_cmd_kref(struct kref =
*kref)
> 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
>=20
> 	fd =3D priv->fd;
> +
> +	qla_nvme_ls_unmap(sp, fd);
> 	fd->done(fd, priv->comp_status);
> out:
> 	qla2x00_rel_sp(sp);
> @@ -361,6 +375,8 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
> 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
> 	    fd->rqstlen, DMA_TO_DEVICE);
>=20
> +	sp->flags |=3D SRB_DMA_VALID;
> +
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> 		ql_log(ql_log_warn, vha, 0x700e,
> @@ -368,6 +384,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
> 		wake_up(&sp->nvme_ls_waitq);
> 		sp->priv =3D NULL;
> 		priv->sp =3D NULL;
> +		qla_nvme_ls_unmap(sp, fd);
> 		qla2x00_rel_sp(sp);
> 		return rval;
> 	}
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

