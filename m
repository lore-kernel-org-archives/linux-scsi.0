Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B15C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125CF61353
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhDLK1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:27:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237753AbhDLK1V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:27:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAQt0B022873;
        Mon, 12 Apr 2021 03:26:55 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm336-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:26:54 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAQs8o022858;
        Mon, 12 Apr 2021 03:26:54 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm335-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:26:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bt4ZBin6mr2NShJVQGMDOj0za2JMoUke5DX5cWERNZrAsiwZTzfC1krYUT2rydh32pJmZ7sq28VVP3YsPHq5Qbq/ozyQkFy1jEzmus+vUi70x7cOWNIfF2y/1gAlxa00AaFcvT71oTBY4YLBKrTJ65MMQhOyQd+1/s1Wj4cfjcDhThqLEIhgm3H0zTtqJ7Yzw/K5JdHtze2T1+kDIYc7VVD+hXprr31jhZ0E3plrSsQGP9165O5n65s80p+RHUnpQURK2Bjr0LmQYgEAcnHDvlTi9IPkAywW7MrSP+XrLWd7Ucw4lvYGhPN6wMdRm+KLj6svfF8We5692wxeNN5p6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rI6HHbcV/SYmo1cU1uRKfDpPttkDZteufVwmTIXO3yI=;
 b=ElSXNTdTk7Do9q76eezGBBYiOPmbR3IVwJxHa/2AoA2mQlIHiPhFJoJZggFUy/2gboQW+F5uiTI152jtBSQYAgiFf/vO9Upd/WWMsvPS8tx3Ude/waGXUlb93mmswwCP5FNv1cnXK0RsAotAnFd0KKW+3ejvptpUXJX0a67o7sxwIGT67ZniW2i+bwy6PYL0/4yd9j7ilqk0KtWMzRYYTP6Nah/G9mtttSRAhuXOwWXJfcsten+hlUW/ioMrquUbFY2+gZy8ATedMj22+Oot/dSCFzmYp5YS1I73g6Gbn/g9g00Z4oUxCMTv90KH4soLKJhopmBrA6NyX8pKtbgeqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rI6HHbcV/SYmo1cU1uRKfDpPttkDZteufVwmTIXO3yI=;
 b=gHPwk9HzP2HnTkYYuZeRC7isNhbs70z9cHRDXgIAzvPw97/CsSQNRZO0pTTiZU4tcUCahr4PI6NHHxdcSk7GAEGxTFaES0fLv4WMJ5gx7X1NOUieHOO+4UQL0G+PcbhEVFYf6Ez2lOW/5mtfhl/0o0ImhZl9qS5goLcfkbD3Kas=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3219.namprd18.prod.outlook.com (2603:10b6:a03:1a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:26:51 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:26:51 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 05/13] scsi: qedi: fix use after free during abort
 cleanup
Thread-Topic: [EXT] [PATCH 05/13] scsi: qedi: fix use after free during abort
 cleanup
Thread-Index: AQHXLjkABP2hHfMCXUiFosFrcNca5aqwsBZg
Date:   Mon, 12 Apr 2021 10:26:51 +0000
Message-ID: <BYAPR18MB299833B19DE44B0A4519A2B9D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-6-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-6-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd0e2336-f004-4cdf-994b-08d8fd9d7c84
x-ms-traffictypediagnostic: BY5PR18MB3219:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32192910053E9DBD72A4AE50D8709@BY5PR18MB3219.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: chK1QXU0/naS3cmpp/dtKjcQ26gir0ilwORBKChqlY6AYiXFiD3dXr34Dd5OeyZun9LiVTEGhG1q1dr/NB3Rifk3skrjxlZQ4jsKKQ7FGRQaN0NIk93eGtN7o6Xk84T7D9zmnrqQaid66dNNllsyju4LnNWPVD4CeonFoWbHww9DxuuRsT8r4IxBKbtTTIlVNyVqeGoerw9LPPe6OZaWDsjEaj1TYaY8RNhqbb22Nxj/THvXUtkUNVqhfvQgoKXoOUKaUXz3fsMhgpxQO5msk+DUPFEpRbU49LFfNKClt9M74Cl4+xUwSZfJyHpcSKcgl5h57QkQjkNLF2+CR+h9vnvoBDh4boaVrIz1DKf7QAgxLItw0g01J3cjogQPKTZBJOFpehLndh4XH7zeb3rJcHZvnXry0T+sg6V2vRFMc27wPSWqELDWW3Y+CSFDczUQg4cDYeko+p4UHVDirp2UtYvzP8mZzyJEoBxDjWSf/mqDSJaulpmrs9WG9sKQL9LU0sgCfGBQne0rGzUzSe7kjDNY8rcCfGIYQSCmFCrzUyduL9aNc6eVKHipAl32vvKORN6eKfGgoXfN/dJgNRTHxdgYK8t3jZTiW9prj4mFT1s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(76116006)(66476007)(66946007)(64756008)(66446008)(316002)(186003)(2906002)(7696005)(38100700002)(26005)(52536014)(110136005)(8676002)(53546011)(6506007)(8936002)(66556008)(33656002)(5660300002)(9686003)(478600001)(86362001)(71200400001)(83380400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?f78Tw8cCGYXS6TDoFOAiH9bMCnoCS3CaXkQ8Hv/+4a3swmKwhJJAFUv4cAIP?=
 =?us-ascii?Q?/wTBqM5/mskOLH0sGT/bwZtG+tasxQ9quhde9/sZIZ02NJgsktvgiIjasQ09?=
 =?us-ascii?Q?QcePlp2SdHZTnl9ZXn4C0ahIooyysARAFOGl2zoqVDd1GfE//MOKwSPHvfCX?=
 =?us-ascii?Q?ZXrd6/bkCSWlLK2iPOjWqLC4u4PUJOeLOz4h3ZfLfBqtl2L5m87kSNIAoO/3?=
 =?us-ascii?Q?fEMaqcrNgQdzUb1i8A55qAwDDeTQrr15upWXKYQexkBaVPdzfWLD9aqsUiML?=
 =?us-ascii?Q?VNHVPc1bE1K1bictqFn2+y8RCnIgpevutd9EPsAPfRgXKfS+lS2rPNdHY4cA?=
 =?us-ascii?Q?COmLUeQGp5Eogy6W9pPDCwg7SC+Z83cjGJoREkZ93w76r5bE/nc2cFI7sW2G?=
 =?us-ascii?Q?FXmCZ1LsPEYEnyLB0tQK/FaaMFF4sL/hRaILkvDhsf7+P4eZ8tpD6GN5P1oe?=
 =?us-ascii?Q?QxCKoUpehRFyYzPMgVFSgHwvd7t8Y9+Th/p6R60rrPCGI6INNg3PnG85QeDD?=
 =?us-ascii?Q?XKvV4sC1U8IH2f8aWiLQnXFhUnkogcxn25DFByjsWqYTD6XXIOgHr4njOIfQ?=
 =?us-ascii?Q?9rx7/Qe0gAg6ZU2URuJVCY42KJPHMNZJCP0esD1G/9qCBz/LFI1xe6ZcCUoN?=
 =?us-ascii?Q?NYudqF/gklbVPG2sOxFXkex5p6PcF/2NUPle3PIzvQP3fbPNG5wunhEBxRyf?=
 =?us-ascii?Q?v1lRpQt3eZj02YT4DPN2P+wgEpVWkyEZp80gaA00ZELBj4iTbJdzWgIzTeWq?=
 =?us-ascii?Q?2nKopcz/24tvRUQoAUhCvBMp848VxcAJjPjkCGW+GaJfEiWTIkFr6uueyrYB?=
 =?us-ascii?Q?0XsfKDgkW7rby8QcAe3QSQQ3nS+RdlGFIiQ8oVx8301x3guppfcgd761Mk5N?=
 =?us-ascii?Q?zcwDSpbe2WyPkjWPc9i2793ZPam6XG52fZ9oBup8M4xTrOzDCYG+QmwTxFRu?=
 =?us-ascii?Q?IvTp15CZNnJghkaNIhgZfHb4khIlr9G0VaxUl27HdxXjuRrsDneBSpQSPmcy?=
 =?us-ascii?Q?uQ9MknNt3fPbx4YnQzKpJLpvv0Pmzd2mhjYYiCZ+6QeWslT2MNSBqqidRysY?=
 =?us-ascii?Q?u083NYtpuvhvK4bpNGbUyQZ7P765MJ13whgsC/fAf0uY4fqHokT+MdipLRI4?=
 =?us-ascii?Q?th70asu1ENeZOPR6yRiuFAwepxar9nCz0EqmW6KygecBc6blcQheBvu9rahG?=
 =?us-ascii?Q?MesKy1//AvTB3ekJWTaQM/X/s0wP8Pg1NxhJaNxslkfei1rPDtu9gOJ7XL5U?=
 =?us-ascii?Q?iD2/l5aTm7uxbu7/vtSzJDuOJCct2Ztu3vZPELOTAmcyO1Hq5Ssf3IM9/NgX?=
 =?us-ascii?Q?uCGKkcDDysNxb9Svfo3/puq6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0e2336-f004-4cdf-994b-08d8fd9d7c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:26:51.2303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NzgLYM5J7mHkF6RiguZVw19QXpmZSDfGb71ILQ8gqicFYCzTsDVlIyOxm/DsQTihc5Ws3z7MYzUGJInquMxUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3219
X-Proofpoint-ORIG-GUID: HoOeV9dYK6oxmictzFm_rsQLLawwvqcO
X-Proofpoint-GUID: U5bP1tV6urwDpwC5BDFNehCxaBg8bW7W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 05/13] scsi: qedi: fix use after free during abort =
cleanup
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This fixes two bugs:
>=20
> 1. The scsi cmd task could be completed and the abort could timeout while=
 we
> are running qedi_tmf_work so we need to get a ref to the task.
>=20
> 2. If qedi_tmf_work's qedi_wait_for_cleanup_request call times out then w=
e will
> also force the clean up of the qedi_work_map but
> qedi_process_cmd_cleanup_resp could still be accessing the qedi_cmd for t=
he
> abort tmf. We can then race where qedi_process_cmd_cleanup_resp is still
> accessing the mtask's qedi_cmd but libiscsi has escalated to session leve=
l
> cleanup and is cleaning up the mtask while we are still accessing it.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 110 ++++++++++++++++++---------------
>  drivers/scsi/qedi/qedi_iscsi.h |   1 +
>  2 files changed, 61 insertions(+), 50 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> ad4357e4c15d..c5699421ec37 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -729,7 +729,6 @@ static void qedi_process_nopin_local_cmpl(struct
> qedi_ctx *qedi,
>=20
>  static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  					  struct iscsi_cqe_solicited *cqe,
> -					  struct iscsi_task *task,
>  					  struct iscsi_conn *conn)
>  {
>  	struct qedi_work_map *work, *work_tmp; @@ -742,7 +741,7 @@
> static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  	u32 iscsi_cid;
>  	struct qedi_conn *qedi_conn;
>  	struct qedi_cmd *dbg_cmd;
> -	struct iscsi_task *mtask;
> +	struct iscsi_task *mtask, *task;
>  	struct iscsi_tm *tmf_hdr =3D NULL;
>=20
>  	iscsi_cid =3D cqe->conn_id;
> @@ -768,6 +767,7 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>  			}
>  			found =3D 1;
>  			mtask =3D qedi_cmd->task;
> +			task =3D work->ctask;
>  			tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
>  			rtid =3D work->rtid;
>=20
> @@ -776,52 +776,47 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>  			qedi_cmd->list_tmf_work =3D NULL;
>  		}
>  	}
> -	spin_unlock_bh(&qedi_conn->tmf_work_lock);
> -
> -	if (found) {
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> -			  "TMF work, cqe->tid=3D0x%x, tmf flags=3D0x%x,
> cid=3D0x%x\n",
> -			  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
> -
> -		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -		    ISCSI_TM_FUNC_ABORT_TASK) {
> -			spin_lock_bh(&conn->session->back_lock);
>=20
> -			protoitt =3D build_itt(get_itt(tmf_hdr->rtt),
> -					     conn->session->age);
> -			task =3D iscsi_itt_to_task(conn, protoitt);
> -
> -			spin_unlock_bh(&conn->session->back_lock);
> +	if (!found) {
> +		spin_unlock_bh(&qedi_conn->tmf_work_lock);
> +		goto check_cleanup_reqs;
> +	}
>=20
> -			if (!task) {
> -				QEDI_NOTICE(&qedi->dbg_ctx,
> -					    "IO task completed, tmf rtt=3D0x%x,
> cid=3D0x%x\n",
> -					    get_itt(tmf_hdr->rtt),
> -					    qedi_conn->iscsi_conn_id);
> -				return;
> -			}
> +	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> +		  "TMF work, cqe->tid=3D0x%x, tmf flags=3D0x%x, cid=3D0x%x\n",
> +		  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
> +
> +	spin_lock_bh(&conn->session->back_lock);
> +	if (iscsi_task_is_completed(task)) {
> +		QEDI_NOTICE(&qedi->dbg_ctx,
> +			    "IO task completed, tmf rtt=3D0x%x, cid=3D0x%x\n",
> +			   get_itt(tmf_hdr->rtt), qedi_conn->iscsi_conn_id);
> +		goto unlock;
> +	}
>=20
> -			dbg_cmd =3D task->dd_data;
> +	dbg_cmd =3D task->dd_data;
>=20
> -			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> -				  "Abort tmf rtt=3D0x%x, i/o itt=3D0x%x, i/o
> tid=3D0x%x, cid=3D0x%x\n",
> -				  get_itt(tmf_hdr->rtt), get_itt(task->itt),
> -				  dbg_cmd->task_id, qedi_conn-
> >iscsi_conn_id);
> +	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> +		  "Abort tmf rtt=3D0x%x, i/o itt=3D0x%x, i/o tid=3D0x%x, cid=3D0x%x\n"=
,
> +		  get_itt(tmf_hdr->rtt), get_itt(task->itt), dbg_cmd->task_id,
> +		  qedi_conn->iscsi_conn_id);
>=20
> -			if (qedi_cmd->state =3D=3D CLEANUP_WAIT_FAILED)
> -				qedi_cmd->state =3D CLEANUP_RECV;
> +	spin_lock(&qedi_conn->list_lock);
> +	if (likely(dbg_cmd->io_cmd_in_list)) {
> +		dbg_cmd->io_cmd_in_list =3D false;
> +		list_del_init(&dbg_cmd->io_cmd);
> +		qedi_conn->active_cmd_count--;
> +	}
> +	spin_unlock(&qedi_conn->list_lock);
> +	qedi_cmd->state =3D CLEANUP_RECV;
> +unlock:
> +	spin_unlock_bh(&conn->session->back_lock);
> +	spin_unlock_bh(&qedi_conn->tmf_work_lock);
> +	wake_up_interruptible(&qedi_conn->wait_queue);
> +	return;
>=20
> -			spin_lock(&qedi_conn->list_lock);
> -			if (likely(dbg_cmd->io_cmd_in_list)) {
> -				dbg_cmd->io_cmd_in_list =3D false;
> -				list_del_init(&dbg_cmd->io_cmd);
> -				qedi_conn->active_cmd_count--;
> -			}
> -			spin_unlock(&qedi_conn->list_lock);
> -			qedi_cmd->state =3D CLEANUP_RECV;
> -			wake_up_interruptible(&qedi_conn->wait_queue);
> -		}
> -	} else if (qedi_conn->cmd_cleanup_req > 0) {
> +check_cleanup_reqs:
> +	if (qedi_conn->cmd_cleanup_req > 0) {
>  		spin_lock_bh(&conn->session->back_lock);
>  		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
>  		protoitt =3D build_itt(ptmp_itt, conn->session->age); @@ -844,6
> +839,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi=
,
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
>  			  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>  			  cqe->itid, qedi_conn->iscsi_conn_id);
> +		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
>=20
>  	} else {
>  		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt); @@ -946,8
> +942,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
>  		goto exit_fp_process;
>  	case ISCSI_CQE_TYPE_TASK_CLEANUP:
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "CleanUp
> CqE\n");
> -		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited,
> task,
> -					      conn);
> +		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited,
> conn);
>  		goto exit_fp_process;
>  	default:
>  		QEDI_ERR(&qedi->dbg_ctx, "Error cqe.\n"); @@ -1374,12
> +1369,22 @@ static void qedi_tmf_work(struct work_struct *work)
>  	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
>  	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
>=20
> -	ctask =3D iscsi_itt_to_task(conn, tmf_hdr->rtt);
> -	if (!ctask || !ctask->sc) {
> +	spin_lock_bh(&conn->session->back_lock);
> +	ctask =3D iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
> +	if (!ctask || iscsi_task_is_completed(ctask)) {
> +		spin_unlock_bh(&conn->session->back_lock);
>  		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
> -		goto abort_ret;
> +		goto clear_cleanup;
>  	}
>=20
> +	/*
> +	 * libiscsi gets a ref before sending the abort, but if libiscsi times
> +	 * it out then it could release it and the cmd could complete from
> +	 * under us.
> +	 */
> +	__iscsi_get_task(ctask);
> +	spin_unlock_bh(&conn->session->back_lock);
> +
>  	cmd =3D (struct qedi_cmd *)ctask->dd_data;
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
>  		  "Abort tmf rtt=3D0x%x, cmd itt=3D0x%x, cmd tid=3D0x%x,
> cid=3D0x%x\n", @@ -1389,19 +1394,20 @@ static void qedi_tmf_work(struct
> work_struct *work)
>  	if (qedi_do_not_recover) {
>  		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT
> %d\n",
>  			 qedi_do_not_recover);
> -		goto abort_ret;
> +		goto put_task;
>  	}
>=20
>  	list_work =3D kzalloc(sizeof(*list_work), GFP_ATOMIC);
>  	if (!list_work) {
>  		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
> -		goto abort_ret;
> +		goto put_task;
>  	}
>=20
>  	qedi_cmd->type =3D TYPEIO;
>  	list_work->qedi_cmd =3D qedi_cmd;
>  	list_work->rtid =3D cmd->task_id;
>  	list_work->state =3D QEDI_WORK_SCHEDULED;
> +	list_work->ctask =3D ctask;
>  	qedi_cmd->list_tmf_work =3D list_work;
>=20
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, @@ -1434,7 +1440,9
> @@ static void qedi_tmf_work(struct work_struct *work)
>  	qedi_cmd->task_id =3D tid;
>  	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
>=20
> -abort_ret:
> +put_task:
> +	iscsi_put_task(ctask);
> +clear_cleanup:
>  	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
>  	return;
>=20
> @@ -1455,6 +1463,8 @@ static void qedi_tmf_work(struct work_struct *work)
>  	}
>  	spin_unlock(&qedi_conn->list_lock);
>=20
> +	iscsi_put_task(ctask);
> +
>  	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);  }
>=20
> diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscs=
i.h index
> 39dc27c85e3c..68ef519f5480 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.h
> +++ b/drivers/scsi/qedi/qedi_iscsi.h
> @@ -212,6 +212,7 @@ struct qedi_cmd {
>  struct qedi_work_map {
>  	struct list_head list;
>  	struct qedi_cmd *qedi_cmd;
> +	struct iscsi_task *ctask;
>  	int rtid;
>=20
>  	int state;
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

