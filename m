Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9FEECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiH2QKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiH2QKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:10:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FFFDE82
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:09:55 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TDmuUm000319;
        Mon, 29 Aug 2022 16:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HS+QA10hJkm5tZ70bAAVMJw1zPrBdShPDTLd7xXJ4kA=;
 b=W5FYTt9kVPF8/EntzwUbAm5G/UBdACpfkl81c/FjgWBxVPg4NWyQKOuUMIb12IKcn/dv
 yqQq0mTCY8XVsdGm5sqZzrNzTdAAqSWHE7NuOlhs7uNRO97Y/+/i9Ti0pVHdQA/JQC8u
 /qM8XASUCudXHpr5SB2T9YJw/uqTUWhyO9tmojkTneZp89RefvFbk296N9YaZYO/jD+b
 l44wyEyrFz12ProJJ4+3Wg3FMKSQnZgYy6e+BB04sWmFcg4R/Wg56xR7KEdLFyQbm9P3
 N4FS5R0DkBCccC7VRk3t/CezORwFy4FL7HX5Spd65uNlSRggqv+RMPwdaxyr/9I96mfR Lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsbv6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:09:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TEVG8B005262;
        Mon, 29 Aug 2022 16:09:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2jwc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:09:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVK2EMs1lE1q9z5eN8F11OraQHIavK6uQL0XZJxnOQ9lx5asveBIqyFH7ZU6jJrUXnmsrhaS4u6/8XQaWEcsa/hM1kiDub14RpOgnuDmoFbfnvw1JQl3BEfn9OV77PJaHejSU9y9LdA16nY1lvFIhlOFA/OSzjBuH7g7YjkS8tNPtF7kdeyY3M8okCNyPnnclBHFtRVfNxmefru8RrBfHhLbyV9ANGT+06KgAfihDBT3bP+mO59W4rn+J9dUjrY1GfI62txtsgcObl4TKQuK8+DH9k26QnJeTyxyxRHxIUsCKov/cPMXN0xjv7WdvLxzIhp5uTB5jOnRBQBNauG4FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HS+QA10hJkm5tZ70bAAVMJw1zPrBdShPDTLd7xXJ4kA=;
 b=cIzFy6aMevo9MZOUuu3yCS8gY40PrQPteC9RtvLGcSoe1QwuCR3SskVS1b0mOkytv5wfL7wyBwlYEDhHp2Uz4e+L+nyFN4znHiGj1fp/D8mxjNNFv0VlLVuB/VsxJ9l9+fwodGXDdMmMq1Q2//d+TH5vBz0NV969m8pKS0dKHYgO7Bt6Zia2TvRzhQkzSbwik5xhoubc93E39D6ovjK9aLYafZ9z6eBIwgMlnIgCnyVAbWadFQvTaRRKILq92axOYeaWPB9peSjhWhOL7WY697z87xcI9gRPJvZejXyiHGdbNR4UmVuAN5WPelhwCmfR3gxkOoC6s8PfbVpV9FY0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HS+QA10hJkm5tZ70bAAVMJw1zPrBdShPDTLd7xXJ4kA=;
 b=Afb0moQm2+RnMN3L1HdobQxKHgGZ20H7USXMBeZbnXcy1bmgjq7I8BeoxpevyxXsRZvlNehjk/AQ6+yJidujezuAiLzPWwORvlpbeIz4Eaw9VzXLdgRaKoxhWhf98UmJXlM6iYi0vVu4YWnWLGCB/4RO6vyTvtIgQdi9W795y1g=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB4224.namprd10.prod.outlook.com (2603:10b6:208:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:09:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:09:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 1/7] Revert "scsi: qla2xxx: Fix response queue handler
 reading stale packets"
Thread-Topic: [PATCH v2 1/7] Revert "scsi: qla2xxx: Fix response queue handler
 reading stale packets"
Thread-Index: AQHYuTZRThs2w8mmo0SocT9zz5lTja3GERkA
Date:   Mon, 29 Aug 2022 16:09:48 +0000
Message-ID: <810DE24B-1FD9-4290-B478-385A990C84DA@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-2-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad33765c-360e-4458-1d76-08da89d8e5b3
x-ms-traffictypediagnostic: MN2PR10MB4224:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DfjyNqu74YU6BaUe4lpGLCfmSZVev3WqwudPURITh1cn/0tNDclwyo6mHfnLsD6ngGv+dFm52CaBeHwYXN/p4YnqBMcxr6BWqCGFb6zCH0yKccLR5VhkYW4NQO4KoaoTQMuQqvvuc+FGyza6gwvuj+gCH+L01cqnH+2gk/Wcp46nWaH5nfozoV2GPwlpeVK6HzpMFd4ND9PwWSZgik4Tz2Ke9Fo5FUndvpZ/cpf39k1rUg28RSb6rN78zRVodNrOqkXHKfCpv2VLgxybVzs/ZQTlOkeYIbaoCr7lr1DGuV3Og6wsWoslkDUXRetmo2QHJJ8kjm5srUfwQhGpOChwtykHUGNN+91cMaBoBkb5Nr/LshnLWUod4km/utKKwenvVuKbcQcIkHoh8MaxId6kg7VJj6XvhSKkqYyzp12wqfgXiuUPIro/sB5C2NLWAQSjlrf7/ECyW1ltS5AWy8ITDhxPMU5U0PVMdxFFJ6spvpwANAXs1A6ZiZS9lDN+gAvNyOLwEgeEHpcLpwv8fdbw0GtPTpUH1IcXj5j5hyzi0zQOISv34uweuKcts58N4kX6PlkKMsDbI45uTw+l20nKnI6JtzGzeoFqq5+7Uc1XO7Hoz2HCDeDO9bQypTp1okckF5V4SvTYCxPS8uUqY7uHge2pY9kUobk0xuN/BE+yLtycIXJIRZEqARyA1JLm4ktE4SlQa/rrL9XoFSWA0Wb0ev5KcSpGdKOvaHXpyhdQlKNQxh0PMbL51AVJgcqMOpVxXi0y13kTJ0LjM0PEJORGIPCglDn0TS76p1VmVcgUA3ejWkg19/jRVzbESwFLCbIOsGwnfv60FOIpqH34OxqFhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(39860400002)(346002)(66476007)(66446008)(4326008)(8676002)(66946007)(76116006)(6486002)(66556008)(64756008)(966005)(53546011)(2906002)(83380400001)(6512007)(8936002)(26005)(5660300002)(41300700001)(44832011)(478600001)(91956017)(33656002)(6506007)(316002)(71200400001)(38070700005)(2616005)(86362001)(122000001)(6916009)(54906003)(36756003)(186003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nyv6VIg7Dt+vgO7w2+Ls6P0vaagPDJR4CCdTT9lseAsRw4GyM+AAwyEU+2oY?=
 =?us-ascii?Q?JBrzz74wqJzq5QTxLlG61oX0bAN7HUlAdGsjnLtYl+RpH6ArTvbZuLmRHmhc?=
 =?us-ascii?Q?hS17C769zXpueWCtQm0jGc1hf2Z6dXRqCivTkC/VnkcHpT3p3YT/HVKnWQd0?=
 =?us-ascii?Q?zpDQM7bWOrB6pWipiEGhf7BwqG6iYffK6KeZkCeYkgRSppvcoGl+NKg3yycq?=
 =?us-ascii?Q?W8K4/9d193eRzwSpJ7UXfc5wOWAbHRplzaC3rl1k7c9aYmrUaVx9mSqkjvU/?=
 =?us-ascii?Q?gAxqeAfrNlFuElXVmxK6v4Mg/lQxeutsCRoAhb7ntiBXh/sBI0932SJaiqZF?=
 =?us-ascii?Q?oS0E/9G0JOkpjKbUbOlwHDsCg7jG945ayiQICiP5jfad3YJGdCJqAWZyLgiN?=
 =?us-ascii?Q?Wg2KxGkwYIYIAOEkHD8CgpxvlG1ICeI/WLbnQkWa7cwfB4Tg1/uq4IpB4FdG?=
 =?us-ascii?Q?C9v1gVh7xS5+H+vbWrg4bzWFUGgOJFhgv6slMdg3ef60TEydWroX/+kIuYfr?=
 =?us-ascii?Q?9wl+cESzBHH9q/tT+wqroKxERwSTl6c7u9pdXVNTuB9QS2jZG5HZ+znWJ+hj?=
 =?us-ascii?Q?clXdg3IJCREfSv3QMM/KmJx1DAp8TfXtJuMHXlbO4D7j8DQXosCA1Ko15Vti?=
 =?us-ascii?Q?vcJ2Wd5fWhA27yvQKqNpecQVcC2nKZYX4jihIsGCm5paVax15/Fz5P3p0djx?=
 =?us-ascii?Q?W2/bAtcRr54tyrx9qG37R2/GuUw6KajbH8B9Nuuk2ISHJT3mbANuT0J9nO/p?=
 =?us-ascii?Q?aI7nNYe/ch+Rgct+Eog8FX4ExslS5egY9AHRW/sNy7QmDrfA0WHw5jG8/REx?=
 =?us-ascii?Q?NF7ax+oMCXI6YE6DVFLT/R4+qF7Qsw6mHWELMd3GiG38mohiKVuC+lMEQMJO?=
 =?us-ascii?Q?pRPwSgQCCxDOHgfeSyWKyY1WfRSqBBVVua8JGAA+H65koKYH7af6TDV3CgfV?=
 =?us-ascii?Q?PFlEGJovTgPnYeGRumrO/lAPe5Oj4s2Ig+WRw8CUphl2F5QT1H7h3rImzfxY?=
 =?us-ascii?Q?5Gc37wv+Zw9A1LzIxxwlq37ADIVxhCMxJ52uDhxF/seHsrnHDpgbt9y6m2uI?=
 =?us-ascii?Q?LD6884Atsv7MtlFCwk4EUZMMVf8BVDH2DXyKtDS4Fut99kqCEbnYgubIBKHB?=
 =?us-ascii?Q?VcWwQPdbjPGKYeIFjR3q3oHWHGJ2FMNiqm37v0cBFh1EmUZ4ir0vPuV1hJZo?=
 =?us-ascii?Q?oOpNbET6dJuJqpBP2AtoTEfDGSW7FUE9G8Mj7YUnas7t/SJoYOoa9dvopubc?=
 =?us-ascii?Q?Wn4LHeDr/sFB9U/tNNitM1A5ksgykT9CInhaRD0bZGb039pumfxF9WF9SKIr?=
 =?us-ascii?Q?llT2YXbJ3bBWh5lZuh5paTTer/6Ig4D6bRgepK2NVZJTmgKgNDKzoL6QxzJ5?=
 =?us-ascii?Q?ZomneoW2OUqHcZXdUzZJC8Ux4yflC80oR8ykHlaRzthbpCu8jwoLwHyN4vl6?=
 =?us-ascii?Q?1m/aGw+4CFGfBrEuPLG2z5apr+F/YOXFwtmk3gIgbDWL/8Fu6gAOv4AD3/O6?=
 =?us-ascii?Q?7T4iOW8oDTPFb8U4HYhgGooX4sPN40QL+4O4dlpgLNU3tioU4LjYB1vfPFmV?=
 =?us-ascii?Q?PyvLQ8ntzW3iaKnoPiI+8Qn7wa59QX3vYQ5NrPN10wgWI2KGN91F48mcGZSE?=
 =?us-ascii?Q?pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA230658815C73458C556EC7E5886307@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad33765c-360e-4458-1d76-08da89d8e5b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:09:48.5696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TK16oaTJPZjfDtZjXBntlcpBLJ4Gl3f/IihtgOwQm9oH/q+ZyeBXYPuBjhdyv5qi6+CyDHNVBIxULWQVbArxm+8l6DdHa86n4UkdesdhWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290075
X-Proofpoint-GUID: 5LpLH0E708jyG23TWaEigE_DaKovug9E
X-Proofpoint-ORIG-GUID: 5LpLH0E708jyG23TWaEigE_DaKovug9E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Reverting this patch so that a fixed up patch, without adding new module
> parameters, could be submitted.
>=20
>    Link: https://lore.kernel.org/stable/166039743723771@kroah.com/
>=20
> This reverts commit b1f707146923335849fb70237eec27d4d1ae7d62.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h |  2 --
> drivers/scsi/qla2xxx/qla_isr.c | 25 ++-----------------------
> drivers/scsi/qla2xxx/qla_os.c  | 10 ----------
> 3 files changed, 2 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 5dd2932382ee..bb69fa8b956a 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -193,8 +193,6 @@ extern int ql2xsecenable;
> extern int ql2xenforce_iocb_limit;
> extern int ql2xabts_wait_nvme;
> extern u32 ql2xnvme_queues;
> -extern int ql2xrspq_follow_inptr;
> -extern int ql2xrspq_follow_inptr_legacy;
>=20
> extern int qla2x00_loop_reset(scsi_qla_host_t *);
> extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 76e79f350a22..ede76357ccb6 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3763,8 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct purex_entry_24xx *purex_entry;
> 	struct purex_item *pure_item;
> -	u16 rsp_in =3D 0, cur_ring_index;
> -	int follow_inptr, is_shadow_hba;
> +	u16 cur_ring_index;
>=20
> 	if (!ha->flags.fw_started)
> 		return;
> @@ -3774,25 +3773,7 @@ void qla24xx_process_response_queue(struct scsi_ql=
a_host *vha,
> 		qla_cpu_update(rsp->qpair, smp_processor_id());
> 	}
>=20
> -#define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
> -	do {								\
> -		if (_update) {						\
> -			_rsp_in =3D _is_shadow_hba ? *(_rsp)->in_ptr :	\
> -				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
> -		}							\
> -	} while (0)
> -
> -	is_shadow_hba =3D IS_SHADOW_REG_CAPABLE(ha);
> -	follow_inptr =3D is_shadow_hba ? ql2xrspq_follow_inptr :
> -				ql2xrspq_follow_inptr_legacy;
> -
> -	__update_rsp_in(follow_inptr, is_shadow_hba, rsp, rsp_in);
> -
> -	while ((likely(follow_inptr &&
> -		       rsp->ring_index !=3D rsp_in &&
> -		       rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED)) ||
> -		       (!follow_inptr &&
> -			rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED)) {
> +	while (rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
> 		pkt =3D (struct sts_entry_24xx *)rsp->ring_ptr;
> 		cur_ring_index =3D rsp->ring_index;
>=20
> @@ -3906,8 +3887,6 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
> 				}
> 				pure_item =3D qla27xx_copy_fpin_pkt(vha,
> 							  (void **)&pkt, &rsp);
> -				__update_rsp_in(follow_inptr, is_shadow_hba,
> -						rsp, rsp_in);
> 				if (!pure_item)
> 					break;
> 				qla24xx_queue_purex_item(vha, pure_item,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 0bd0fd1042df..1c7fb6484db2 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -338,16 +338,6 @@ module_param(ql2xdelay_before_pci_error_handling, ui=
nt, 0644);
> MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
> 	"Number of seconds delayed before qla begin PCI error self-handling (def=
ault: 5).\n");
>=20
> -int ql2xrspq_follow_inptr =3D 1;
> -module_param(ql2xrspq_follow_inptr, int, 0644);
> -MODULE_PARM_DESC(ql2xrspq_follow_inptr,
> -		 "Follow RSP IN pointer for RSP updates for HBAs 27xx and newer (defau=
lt: 1).");
> -
> -int ql2xrspq_follow_inptr_legacy =3D 1;
> -module_param(ql2xrspq_follow_inptr_legacy, int, 0644);
> -MODULE_PARM_DESC(ql2xrspq_follow_inptr_legacy,
> -		 "Follow RSP IN pointer for RSP updates for HBAs older than 27XX. (def=
ault: 1).");
> -
> static void qla2x00_clear_drv_active(struct qla_hw_data *);
> static void qla2x00_free_device(scsi_qla_host_t *);
> static int qla2xxx_map_queues(struct Scsi_Host *shost);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

