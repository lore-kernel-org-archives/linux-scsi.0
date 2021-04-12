Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC0EC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E621C6109E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhDLK2W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:28:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239060AbhDLK2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:28:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAQt0H022873;
        Mon, 12 Apr 2021 03:27:50 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm36a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:27:49 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAQs8w022858;
        Mon, 12 Apr 2021 03:27:49 -0700
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2056.outbound.protection.outlook.com [104.47.46.56])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm368-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:27:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrPVsiL+bh1gpLLQCfU/feCnCj1n9aZNKpTKFDLYCeXn+hoPNYexXSijmLbHzQ4RgdLbtg4CH+qmKThG/Yx3K8ugHa/aeI4kQlHpT4Xjiwf6C/Isra/6tAgSeG2UEsj4xAkDM4hOvsbUjYbxzWLDKxm8A0JdbPPAPjZUSN8qUXKp3bZPENURMV0IHuJohrtFNFLVsF0RTbZ8AwCbvnhWkVD64Ssy8vHufG8tozbvqlcmIVf7k2rPAdZX6apex7dVMYTKK7H/ZqXkK3Bw+uZhXFpIFQjXnK5SzpOyh6jivIEI2O9u3ProQvZVoM1tPN6FE3RpYV6VgKgFsAq0vPQzjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SZdL9fsSVli+GTwfoG5iKwgNjs2o1OKrqWo7LOvwjw=;
 b=MPXaPp/hdEcSkspHSjNGl11X1zezrCio2zVhZNxCF4AKbrcUHUrPfhi2s48T5NjUH2u0GrdOtwl+JhQ0D8pVNA6USw2UVAChYASQo1GmEgKwB8bh8tftP5GxiR6h6htmQQ9NC2mHjA5x40Kml4g9TGjE2nwVFnEwLwZWpAtABtYO+M+nFqjk0Rnv8RWSplLZSEcljzPdCK6sDmmenRvG5HzDwEvCnVDYi1caDkXnbDpOU3UxzBfS88g9jEzckt0gcaLWDHiaMxOnjpNiCMThJnW0z8c5l3CgJ1ydSVxdJ7MjcKTC6XIdCQuovH4BHkGg8K7+FgXfM6sZXVtjEjEScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SZdL9fsSVli+GTwfoG5iKwgNjs2o1OKrqWo7LOvwjw=;
 b=dk6w11c5cVE88JfSX/weIVhW2vHgewCF4maQYkxELMc9QGhlql5PX+i2ECcTo9yz8vCPnoU/aY6CYsnsHqStGVRQmdVKOeWtNqgRqHYzs75u4rB2S+P+GoVVx9XHf2ooiICymlGtRi1JWVanLEwpF36CNlr3m+2nWANruSRqWHQ=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3219.namprd18.prod.outlook.com (2603:10b6:a03:1a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:27:47 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:27:47 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 06/13] scsi: qedi: fix tmf tid allocation
Thread-Topic: [EXT] [PATCH 06/13] scsi: qedi: fix tmf tid allocation
Thread-Index: AQHXLjkBJ3k2DEI9g0+d0Tp9jfZQ76qwsGsQ
Date:   Mon, 12 Apr 2021 10:27:47 +0000
Message-ID: <BYAPR18MB2998ABA59643636C0F3CB539D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-7-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-7-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e32c5306-b6bf-4c82-0041-08d8fd9d9e25
x-ms-traffictypediagnostic: BY5PR18MB3219:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3219178A3BE29261FC793768D8709@BY5PR18MB3219.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pWM3f+OCDxQ0gPgN9HUNGBnkiO/T1CFTJEVZZDcMLCIDUWo9ECvLpB63EOdm20BARkv2HJ5a667AaZQXzoEJWFeHtc4rRT5RIp2CIC8ervVoJ2+Gam4ItVGbAxzJWXTuLWBIzluoaSZpFGMNFQiAaI0ZTaahsvOwCfyrLvrOFQaOoeLe3z1RZLJu22nwtQ7l4IJnc/O0HOxleXm/FUDaAw+13pGeyJQ5YfgsNByaDB2A15HprrAYgyIq30l3oATzw4mIPUFRmpBZ4e76mjg0IRX/W9VEpRtgi1SjjS4DVda+XCDJnoEiP+dyeYSja4zjCIlicf7Bf8mTORV5lf8xfZORbE95UPzMOO/q2qkSdaMRegJAOdxzchPrIolnxWsiI3nJfvw7oRmmKf4hKwogw0nU+ByGOQ9mp8/EeY0XYsvL105GxhB81OpYX9tJOgpiep0zCV5XJmo58QkyBP2+zFntvTvgLGm+j+1GxjXjxsW6V8j3Pt7Wo4YhtHAncpIJLyRGThbtoXjpL1LYcp5r0IJ7JjPvZhn4oszbkZ3CEZ5PkWDq+qmMpm+rkiZAOYjprpDnRdO0B15XYA1BaHi0GhnN0p0m2bbGQhEEAe5CSu8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(76116006)(66476007)(66946007)(64756008)(66446008)(316002)(186003)(2906002)(7696005)(38100700002)(26005)(52536014)(110136005)(8676002)(53546011)(6506007)(8936002)(66556008)(33656002)(5660300002)(9686003)(478600001)(86362001)(71200400001)(83380400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LXy/JqtvT4p9xWT/jSDpSg8HeW1gzGwA6AW1hC5/v/xygxJaAbx8mPT0ZcLI?=
 =?us-ascii?Q?/C3jwHM3nScYRqWLObRldldD51scZQGZ+H+W0PvhgxqFjP0lTmD1je5zLxLZ?=
 =?us-ascii?Q?cpfHANp+mvsHHtIQ7Sppk11zJXib1J9RBrEDU/e1kq8y8AW3Q7fqArNibsqk?=
 =?us-ascii?Q?IMDdihMZ1wPXcD987MMXemuQAvAJcNcoQFYJM+pbD34Li4ian6CcV4DT4/ue?=
 =?us-ascii?Q?ICUBj8PXiO/QofTuCyVxk6oHrYFZC8AqiwBSRWZxvXwCwLVhhz4lxuyqyM3t?=
 =?us-ascii?Q?l1wTiRWiJ6E05QoWlHRghVs4is7npx0AH8k6uBFpqxfac/0pG/ca6swWgYbi?=
 =?us-ascii?Q?mE1j7exW9I25QfTKuA0z8ZaA+eiFqbyK/KsXeh27FiWyI2/qienpKI70qeJu?=
 =?us-ascii?Q?GmcNi9SMsl2JcOrHpWxbUQrf3aM5p2K95zgioaJ0ta3NYpC8JWn0RC+z6aig?=
 =?us-ascii?Q?m0OSqbX8kje0Ha3lmaXo9ajZ95fClbsGGwMnEc5ZE23u1xIJ3sC5KLV4Olp/?=
 =?us-ascii?Q?eR4DiKvOvPegI13G+7SuXusTig9yT+1WXFRiSiBYr/HwduCvXouJBnk6I+ZQ?=
 =?us-ascii?Q?T7gCcJEz1p/Tv5u+DcB1OoeYHKjgOA65Po51UJLVz4Qny9Vua6NXHb/trsYW?=
 =?us-ascii?Q?WrC6//BtErKhp1Lpn0CqyWAoozJrKleNWcHnW6+O2RLPAIBxRMfCiVd1Gosq?=
 =?us-ascii?Q?jo5Hi66qM4LyzvwScVvHdt3YT/8l77hz4YpwxEA0TOwYRlq4+G9tNrsYkjCb?=
 =?us-ascii?Q?tkGggEBayY19R7ungLQCtwllfY9l2hdc5VPSsJ7s8TktJB+JKznGgxz8Ibdp?=
 =?us-ascii?Q?CLs0nMiyNHw0LGyre5gMweAGNrCpk+pMn3IOme4NYsEo0DsFDFYEH+iX5FVj?=
 =?us-ascii?Q?FW1HSLLfCRE4ZVjwsJgHGtF8/kLROUTRug8E2WBH5wWCV+LJHcbO5uNr8Ps7?=
 =?us-ascii?Q?XzzJHU+KbaSsSC4dyNTj4Iih8GxCJxrqAfIr/q3Sk0auBABmERqmY7EMA/WQ?=
 =?us-ascii?Q?q6YnHALAOuKlpm2XDA/qtvAdRenteg854JWt1QZ/DlppvLvV3HASZ2K5Igdu?=
 =?us-ascii?Q?t+jrGWNACbfbmb/k+uwo62RadTM9M5Lx6TXZYedIhypMdmP/K/5di5i80XPG?=
 =?us-ascii?Q?sJAT5adaI5jlyb+W17m+8tiVvPM6y1XMtkuLtj53u7BXUUID4NC2UliBsQR6?=
 =?us-ascii?Q?Z5y+lDxh5M6mQiDkXMr+iMZXorAdUP9+0zSVzw6pxeEyK/Iix/bn4yn3a+H3?=
 =?us-ascii?Q?wsg+fHNVDk1WxgKXbd/x5eX9U3ulyepgfCMtOLaEKWqbN5wXM1FZTJ1OYZf7?=
 =?us-ascii?Q?tFFPVdyT3WG12tZfSxsw5GcM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32c5306-b6bf-4c82-0041-08d8fd9d9e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:27:47.6363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KhW0m0vQdl+bvqkBCHWQ7TH7PshLFVgBpeDJ+YXQlR3qoQvwPHbEGRi+e+z23/VIsDVBf8kAIUY2hp7lOqz0cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3219
X-Proofpoint-ORIG-GUID: chR2ZTFY24drqDp4KhViJ_HC4GeExhTC
X-Proofpoint-GUID: mDfm8FZ6Smddvi42cjaYXu-FK612qD5g
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
> Subject: [EXT] [PATCH 06/13] scsi: qedi: fix tmf tid allocation
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
> qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid allo=
cation
> from the callers.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
>  drivers/scsi/qedi/qedi_gbl.h   |  3 +-
>  drivers/scsi/qedi/qedi_iscsi.c |  2 +-
>  3 files changed, 25 insertions(+), 56 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> c5699421ec37..542255c94d96 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -14,8 +14,8 @@
>  #include "qedi_fw_iscsi.h"
>  #include "qedi_fw_scsi.h"
>=20
> -static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
> -			       struct iscsi_task *mtask);
> +static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
> +			  struct iscsi_task *mtask);
>=20
>  void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)  { @@ -1350,7 +1350,=
7
> @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
>  	return 0;
>  }
>=20
> -static void qedi_tmf_work(struct work_struct *work)
> +static void qedi_abort_work(struct work_struct *work)
>  {
>  	struct qedi_cmd *qedi_cmd =3D
>  		container_of(work, struct qedi_cmd, tmf_work); @@ -1363,7
> +1363,6 @@ static void qedi_tmf_work(struct work_struct *work)
>  	struct iscsi_task *ctask;
>  	struct iscsi_tm *tmf_hdr;
>  	s16 rval =3D 0;
> -	s16 tid =3D 0;
>=20
>  	mtask =3D qedi_cmd->task;
>  	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr; @@ -1404,6 +1403,7 @@
> static void qedi_tmf_work(struct work_struct *work)
>  	}
>=20
>  	qedi_cmd->type =3D TYPEIO;
> +	qedi_cmd->state =3D CLEANUP_WAIT;
>  	list_work->qedi_cmd =3D qedi_cmd;
>  	list_work->rtid =3D cmd->task_id;
>  	list_work->state =3D QEDI_WORK_SCHEDULED; @@ -1430,15 +1430,7
> @@ static void qedi_tmf_work(struct work_struct *work)
>  		goto ldel_exit;
>  	}
>=20
> -	tid =3D qedi_get_task_idx(qedi);
> -	if (tid =3D=3D -1) {
> -		QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=3D0x%x\n",
> -			 qedi_conn->iscsi_conn_id);
> -		goto ldel_exit;
> -	}
> -
> -	qedi_cmd->task_id =3D tid;
> -	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
> +	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
>=20
>  put_task:
>  	iscsi_put_task(ctask);
> @@ -1468,8 +1460,7 @@ static void qedi_tmf_work(struct work_struct *work)
>  	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);  }
>=20
> -static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
> -			       struct iscsi_task *mtask)
> +static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct
> +iscsi_task *mtask)
>  {
>  	struct iscsi_tmf_request_hdr tmf_pdu_header;
>  	struct iscsi_task_params task_params;
> @@ -1484,7 +1475,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn
> *qedi_conn,
>  	u32 scsi_lun[2];
>  	s16 tid =3D 0;
>  	u16 sq_idx =3D 0;
> -	int rval =3D 0;
>=20
>  	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
>  	qedi_cmd =3D (struct qedi_cmd *)mtask->dd_data; @@ -1548,10 +1538,7
> @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
>  	task_params.sqe =3D &ep->sq[sq_idx];
>=20
>  	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
> -	rval =3D init_initiator_tmf_request_task(&task_params,
> -					       &tmf_pdu_header);
> -	if (rval)
> -		return -1;
> +	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
>=20
>  	spin_lock(&qedi_conn->list_lock);
>  	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list); @@ -
> 1563,47 +1550,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn
> *qedi_conn,
>  	return 0;
>  }
>=20
> -int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
> -			  struct iscsi_task *mtask)
> +int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task
> +*mtask)
>  {
> +	struct iscsi_tm *tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
> +	struct qedi_cmd *qedi_cmd =3D mtask->dd_data;
>  	struct qedi_ctx *qedi =3D qedi_conn->qedi;
> -	struct iscsi_tm *tmf_hdr;
> -	struct qedi_cmd *qedi_cmd =3D (struct qedi_cmd *)mtask->dd_data;
> -	s16 tid =3D 0;
> +	int rc =3D 0;
>=20
> -	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
> -	qedi_cmd->task =3D mtask;
> -
> -	/* If abort task then schedule the work and return */
> -	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -	    ISCSI_TM_FUNC_ABORT_TASK) {
> -		qedi_cmd->state =3D CLEANUP_WAIT;
> -		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_work);
> +	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
> +	case ISCSI_TM_FUNC_ABORT_TASK:
> +		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
>  		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
> -
> -	} else if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -		    ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
> -		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -		    ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
> -		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -		    ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
> -		tid =3D qedi_get_task_idx(qedi);
> -		if (tid =3D=3D -1) {
> -			QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=3D0x%x\n",
> -				 qedi_conn->iscsi_conn_id);
> -			return -1;
> -		}
> -		qedi_cmd->task_id =3D tid;
> -
> -		qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
> -
> -	} else {
> +		break;
> +	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
> +	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
> +	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
> +		rc =3D send_iscsi_tmf(qedi_conn, mtask);
> +		break;
> +	default:
>  		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=3D0x%x\n",
>  			 qedi_conn->iscsi_conn_id);
> -		return -1;
> +		return -EINVAL;
>  	}
>=20
> -	return 0;
> +	return rc;
>  }
>=20
>  int qedi_send_iscsi_text(struct qedi_conn *qedi_conn, diff --git
> a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h index
> 116645c08c71..fb44a282613e 100644
> --- a/drivers/scsi/qedi/qedi_gbl.h
> +++ b/drivers/scsi/qedi/qedi_gbl.h
> @@ -31,8 +31,7 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
>  			  struct iscsi_task *task);
>  int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
>  			   struct iscsi_task *task);
> -int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
> -			  struct iscsi_task *mtask);
> +int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task
> +*mtask);
>  int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
>  			 struct iscsi_task *task);
>  int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn, diff --git
> a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c index
> d1da34a938da..821225f9beb0 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -742,7 +742,7 @@ static int qedi_iscsi_send_generic_request(struct
> iscsi_task *task)
>  		rc =3D qedi_send_iscsi_logout(qedi_conn, task);
>  		break;
>  	case ISCSI_OP_SCSI_TMFUNC:
> -		rc =3D qedi_iscsi_abort_work(qedi_conn, task);
> +		rc =3D qedi_send_iscsi_tmf(qedi_conn, task);
>  		break;
>  	case ISCSI_OP_TEXT:
>  		rc =3D qedi_send_iscsi_text(qedi_conn, task);
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

