Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC45C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596D3611F2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJUOBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:01:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50624 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231408AbhJUOBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:01:43 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LDf79X030527;
        Thu, 21 Oct 2021 13:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+zha2WnfexNHkbGV0q4sVUWA+kapvDg/XsTvS/zUE0g=;
 b=1KcAw5rdjjYvNZXyLfKnIfPhwszm+/2MFBj31SsmzVxSbZTKOk+bybYll2Xfwvzzxh5B
 4UFICfJzMjPBWOq6HfQCEO18N/MFjxwFh+BS+/oWN35hnbJMtnsgezVS+c3zy14d6Wnc
 I7rTkkC3FoISgc19jhFLnJWF67pgm9mmX91m086T1K8pyz8ZNgrPa3jneDSIwJ0CtVpL
 06Xt3Q3Dg65MZBKsV4pGsnIexDxWHjuHb6sx93rOnAW95qGVS/0ikaaycK0djtO/Dr/r
 W/Lw/G9bk5d3ZFMKXIwlrMjjziHYSFxUOvXYtVIQteRjMoRnDGRd4nXy9S2OUzSwFKKi qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm50jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:59:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LDpcBd117048;
        Thu, 21 Oct 2021 13:59:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 3br8gw2fbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHCN2Cwis2tV4r7AVxWrqZANvvAwbQwx33c8B+A++f063vtcbSPyO/Q4e7pzaZQEwgYLR/wlAAD5paTF6l0gt3e/xhsf3d2fTjrX3J4083GeYcBgxpkIUZta3BftYWOKJvmil4hlRpnUjW11EfU58a0D+vXirkUdhXMCt+7Tg7eDcpd+0LnM0q8iuwK/k8ll8wJOoI8jYgyDgImDJI3Cya91wnCetXhyF7OwDM8x2WezpJuK2WS3t1imr7bO/EGcwZ4uhxt8nqolLqQ31IFhUz6M0EGFSXJqf5gOOszk3s6Yv7LoHrkgwZD4or6sv9dbfAY/dcx2VF0QpGtlkKF1jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zha2WnfexNHkbGV0q4sVUWA+kapvDg/XsTvS/zUE0g=;
 b=P7r3SnJDSFPXlCgO+QmFbmhzWcKAkcrrMKJbqk73D8XFnAgWishWizeOMNB4VX63s4hkZa0Y6h1DaraoIJhCCizdqRr17CVFHd8J11Wde/HLyZJZV9bbtP7pQ4tqirkg0zmkbaBaZfoBAhl3WP0nXzPwtJgHqkghBsbDhqTvUFVPFs5TBdSFSSLJR7l64+FcPElg6ibqxo3vhw2pmTDnCCfnodlkRT6Lm7OC6/YYh3obZakkcg8lquTZYoWmroFyRXX4aNHADL1x8FhNj1Or31gPmNxY9+5ZqEqJ7SeHPp/001fxYgXrSkDUh8SiXdGUaT4lNdjy2bmEWgKIsbGHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zha2WnfexNHkbGV0q4sVUWA+kapvDg/XsTvS/zUE0g=;
 b=PzNvCYr/L3EUV6d9efOEF/c4PMPfqA6ed08fbxkGjS/omjSjkYogoxz4hwqji5fG8arxZn7Q3VOWEzHE8blD3KMOQ/kX+DnwdlYQ8aoAB+5qxr8v9x7D5SlTAKvzs95OO1caQv9/JHXLbRhCckctaRsDXPIpKL1UNrl3WPcg/Fc=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB4946.namprd10.prod.outlook.com (2603:10b6:208:323::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 21 Oct
 2021 13:59:21 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 13:59:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 03/13] qla2xxx: turn off target reset during issue_lip
Thread-Topic: [PATCH v2 03/13] qla2xxx: turn off target reset during issue_lip
Thread-Index: AQHXxk3S4085gDVPnU2qXpv2gtvfkKvdexQA
Date:   Thu, 21 Oct 2021 13:59:21 +0000
Message-ID: <388BDEBA-9388-4CAD-A627-75F05AE48206@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-4-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05eea9d2-dcbb-4c55-2286-08d9949afb5e
x-ms-traffictypediagnostic: BLAPR10MB4946:
x-microsoft-antispam-prvs: <BLAPR10MB4946A1CA8EB1A2078DF0150DE6BF9@BLAPR10MB4946.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KSNI7aDzYwYX/t+Lx5YzqsFZdBJoZdn5sJxysjbdSCgmb4IOYGxzxebvedX4SS0AAp3knMpoeBYMoazuxE1ETIx79eeiNWeBBWnNh92q8bPSJjoOwMJ1fQMu6e4yYkB1CGUJUNMtAGmDc9ihhEom1y6WpeLelMDTfBR+NaoWWN+JUd6qDD7cRUavxBKjVcrDbyfnf8Jw1PKHQN/rsD4FB7w1de9DWRCDD8UeVr5x9Sm3UtzY1/6hnLOTttZL36mfYVivoEN3ZBNBSzNpYwHaubezD0zuHhyNNAp9Xb9Fto2OPiLbcDrXQdiJuqWccb11c5Mcq3s5zX0gCKu5sB7/1MX/+u9YcZxqxlENrIfsIY425KpKbswK305O03oOS5CU/Q7LAzMi2SB6Vp5/qrsuLfnUWuq/6m/2jyb81xUBGsUmoEGTE9pn+6uO/lgYHX6d3sP8gsZvwnVexqe7gqEMT0T2vQG7oWzvI6Y5E3d28BqC0U0SyvqcFURFVYMkwIqigFipOjxcfF8NPZphypCCKjvTyWQhBthf/pIwa1EylSU7q4F7Dabk/DM80dvX0gTGEnaJB8v2e8kZo+VXdTuiqJgSUhsFe5EvWP7oqqvvhsfMPVDPV56SH0n2CRWsi7YLu8/1PsFDlkJeE8pFkcI71HMO78XC0HUecOFV2mc3LSjXxx6ZbYeOT+WWM1nApOkMnfArm50BQG6z3RVbBjTh9pLNiu6RucVAH0wTlvYaY4BuUb7Cl9lmwhNCVWDq48Oo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(54906003)(6506007)(122000001)(38100700002)(8676002)(6486002)(53546011)(316002)(38070700005)(83380400001)(8936002)(86362001)(5660300002)(66556008)(66446008)(26005)(71200400001)(4326008)(33656002)(508600001)(66476007)(186003)(66946007)(64756008)(2616005)(36756003)(44832011)(76116006)(91956017)(6916009)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YBEwmO5ZVVmydKxE8Oee9e0x7yMoQqczh+cP+wvvseBnpxUG+WwVo/Ye/std?=
 =?us-ascii?Q?Q6F3/y2leigeIZnOAeBd5UkjEqAwAW0wDuSuiQPB/csIBZKdOXfhBf/MTacJ?=
 =?us-ascii?Q?4NFqhQuePTCOORuViowuqddl9+iCs/bsjBTIhmIV0xpn2xoPti2X1PLT3keZ?=
 =?us-ascii?Q?KRRCnD1gLok1jv/BVxZjjY9ePgGoniXdXTz0etyyV5ITbaJ9v3EcFmIJmuvh?=
 =?us-ascii?Q?VZbnoL+ZH/8n6QFLfuLw1t00FzQdiueFYVJK97RvsDdb4KHG8wQahUakixfc?=
 =?us-ascii?Q?UlUEd8xhj1nHAQcJxzsiZIjCzRqGK2ZbUF6zqNs6dwy4aip8sjxJenkDLF0D?=
 =?us-ascii?Q?w4zi1PJeWv4hwNwWQrFIJusXyigA/KlkPyjs5Bxqt/tbDNnz1lhCS9oGX1G/?=
 =?us-ascii?Q?MtqdsgQ1BRLMDulCntG51ooelzYTpnRvKNXAsAmoHuOeQ2/wdK4O/jiffoyw?=
 =?us-ascii?Q?kNr7dj6TstmZGzgaWIE0SsCCOdGd2Wphi7O+/wlSjEIq/BqzZ3ENm+7+WcRR?=
 =?us-ascii?Q?rqtzeHHwr6kgnyQxal0G5K5DdsnWni5I6nm7oN/1AzqD8Y9IZkMQhVOGUJQk?=
 =?us-ascii?Q?jHaiNV87LI4oTFdIpM+35A0nGKi7MZL3VHobhmDJI6GDzmx1d+HwnMbHYgHH?=
 =?us-ascii?Q?38IGrWLk/90rnY4ORidAE5ZHTyOAzJag+YGWAx+vPEXPjjKGGXaW2beVMD0h?=
 =?us-ascii?Q?Bz9zKk3NsmB2B+xiAXhN3sELLT1gWFboeaT9a5w7jHJExvc8WeQ/Uq7r6naj?=
 =?us-ascii?Q?yf2eGMay9YrboQUrArSOglY8U8opQDrCYM1cBgT9Dm+Nzd2fsl+5p/AukO6F?=
 =?us-ascii?Q?EYL9RcCcz2HFDSOUG/JrloH3v+efANdh8an5llXFq36HJTiaVJI+Akbgmjea?=
 =?us-ascii?Q?SBfK0vrrSq5u4AB0idD/e0LO31GRpUmnqgn3i2Ns5TNUmupjWLLayIxi78Az?=
 =?us-ascii?Q?6SUxH/vaXbLwqRrP7PDwn47/aPFjHSrFwhrSu/NDllIckpeiSxdTe+dwwATE?=
 =?us-ascii?Q?zibx4A89uWOYivc7blKyW7WeCsmlojuU4bpxAJ6RkKLVMz3du/Z9ho+H4bcI?=
 =?us-ascii?Q?GqYLiOU9Sfkhv1Uqc2O5fwafXpalc/XFTfEHaE4pTJ6RZk6F901SSPfqj2F5?=
 =?us-ascii?Q?HP8ETpWshefYCdzwz0Oe/3sAQ/T7Go52Ioep/e4UIOLjBCVhVzZfj98AhBK/?=
 =?us-ascii?Q?os5ohrikmpQqxOe3Sz9+fSRPQp3xZzHxF9dpZ/dZqID0nZ0WbrmYyHX4AcWE?=
 =?us-ascii?Q?1b/n8aFGsPiTCJFFQKClW3s49rcjtV5fxDqxJADO58eh7ncLBg3Q+GMkvlEx?=
 =?us-ascii?Q?aA5ELrCyQB/ov6jDnyRn9xMhH/N+HfGdDXPwOoCAqb/oAT8tXe0dSitXIRyq?=
 =?us-ascii?Q?PXwcnEiQFhsYYtkYPHEJWgBwic3vT64Fd4PpVULZzVLrtDYo/SmGrlvLosFh?=
 =?us-ascii?Q?T3WaM8xw8evGaYF/I6iaRTSikk7C7sWCwPiPG7NMNYCBHEZNIWkuHw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <317EB008568548488151F1DDEDE4E594@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05eea9d2-dcbb-4c55-2286-08d9949afb5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 13:59:21.1851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4946
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210074
X-Proofpoint-GUID: JeDSUUbrlEkx2ffTremjCY_5x1c1IU_c
X-Proofpoint-ORIG-GUID: JeDSUUbrlEkx2ffTremjCY_5x1c1IU_c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:31 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> When user use issue_lip to do link bounce, driver sends
> additional target reset to remote device before resetting
> the link. The target reset would affect other paths with
> active IOs. This patch will remove the unnecessary
> target reset.
>=20
> Fixes: 5854771e314e ("[SCSI] qla2xxx: Add ISPFX00 specific bus reset rout=
ine")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h |  2 --
> drivers/scsi/qla2xxx/qla_mr.c  | 23 -----------------------
> drivers/scsi/qla2xxx/qla_os.c  | 27 ++-------------------------
> 3 files changed, 2 insertions(+), 50 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 8aadcdeca6cb..8faaa0ec595d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -171,7 +171,6 @@ extern int ql2xasynctmfenable;
> extern int ql2xgffidenable;
> extern int ql2xenabledif;
> extern int ql2xenablehba_err_chk;
> -extern int ql2xtargetreset;
> extern int ql2xdontresethba;
> extern uint64_t ql2xmaxlun;
> extern int ql2xmdcapmask;
> @@ -820,7 +819,6 @@ extern void qlafx00_abort_iocb(srb_t *, struct abort_=
iocb_entry_fx00 *);
> extern void qlafx00_fxdisc_iocb(srb_t *, struct fxdisc_entry_fx00 *);
> extern void qlafx00_timer_routine(scsi_qla_host_t *);
> extern int qlafx00_rescan_isp(scsi_qla_host_t *);
> -extern int qlafx00_loop_reset(scsi_qla_host_t *vha);
>=20
> /* qla82xx related functions */
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index 6e920da64863..350b0c4346fb 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -738,29 +738,6 @@ qlafx00_lun_reset(fc_port_t *fcport, uint64_t l, int=
 tag)
> 	return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
> }
>=20
> -int
> -qlafx00_loop_reset(scsi_qla_host_t *vha)
> -{
> -	int ret;
> -	struct fc_port *fcport;
> -	struct qla_hw_data *ha =3D vha->hw;
> -
> -	if (ql2xtargetreset) {
> -		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> -			if (fcport->port_type !=3D FCT_TARGET)
> -				continue;
> -
> -			ret =3D ha->isp_ops->target_reset(fcport, 0, 0);
> -			if (ret !=3D QLA_SUCCESS) {
> -				ql_dbg(ql_dbg_taskm, vha, 0x803d,
> -				    "Bus Reset failed: Reset=3D%d "
> -				    "d_id=3D%x.\n", ret, fcport->d_id.b24);
> -			}
> -		}
> -	}
> -	return QLA_SUCCESS;
> -}
> -
> int
> qlafx00_iospace_config(struct qla_hw_data *ha)
> {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 03ff2596715b..3fca6b8bb23f 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -202,12 +202,6 @@ MODULE_PARM_DESC(ql2xdbwr,
> 		" 0 -- Regular doorbell.\n"
> 		" 1 -- CAMRAM doorbell (faster).\n");
>=20
> -int ql2xtargetreset =3D 1;
> -module_param(ql2xtargetreset, int, S_IRUGO);
> -MODULE_PARM_DESC(ql2xtargetreset,
> -		 "Enable target reset."
> -		 "Default is 1 - use hw defaults.");
> -
> int ql2xgffidenable;
> module_param(ql2xgffidenable, int, S_IRUGO);
> MODULE_PARM_DESC(ql2xgffidenable,
> @@ -1695,27 +1689,10 @@ int
> qla2x00_loop_reset(scsi_qla_host_t *vha)
> {
> 	int ret;
> -	struct fc_port *fcport;
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> -	if (IS_QLAFX00(ha)) {
> -		return qlafx00_loop_reset(vha);
> -	}
> -
> -	if (ql2xtargetreset =3D=3D 1 && ha->flags.enable_target_reset) {
> -		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> -			if (fcport->port_type !=3D FCT_TARGET)
> -				continue;
> -
> -			ret =3D ha->isp_ops->target_reset(fcport, 0, 0);
> -			if (ret !=3D QLA_SUCCESS) {
> -				ql_dbg(ql_dbg_taskm, vha, 0x802c,
> -				    "Bus Reset failed: Reset=3D%d "
> -				    "d_id=3D%x.\n", ret, fcport->d_id.b24);
> -			}
> -		}
> -	}
> -
> +	if (IS_QLAFX00(ha))
> +		return QLA_SUCCESS;
>=20
> 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
> 		atomic_set(&vha->loop_state, LOOP_DOWN);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

