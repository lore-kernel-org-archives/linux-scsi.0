Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED6AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1506121E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhDLKf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:35:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46768 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239042AbhDLKfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:35:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAVFYo024233;
        Mon, 12 Apr 2021 03:34:42 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:34:42 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAYg0T030585;
        Mon, 12 Apr 2021 03:34:42 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:34:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F576o78DBt55HNAurycCAEcPJWHoijY1xZg6MZ1brIpPCYs9UE69ogaJVgVC2/OL0VJHdwkD2V5O8KkcRwafIDBB/H56/fYMZB6SDQRg5nZs60LDI5Sd6gneDCzhTMUKa0xyWWEHRwE59N42gawKATvlFsasKD8cDIvygDDxhtpUMoGdrx/zEEOdTqbqwpP4NDy+Zd38tPUULqU61RHYpv23KZFXoOmqSyaTm0dVDYs9fW+v9Zc6kgJ2+S/JWTGDh01O2sKi+68+EG3WstncsdIK1gVEvlfuxrB1Bng0FG0NNv/P3kJSiMf3YQB4cWPkDkU3Of4Bp0rjcHuABJMsfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRmywE70QtxT1xQRUnQN5Z4WhsBliwKn8saFy4y14tc=;
 b=Qc8POBV1LtLLM/64XAlEzGvvmMEUqy3qyN1Kflas+hqm8xx6ncEqUlrHJ56/JWktI1W4o/0WxEzTNyWH/MyguM7g33xYDDtLD5FfQJ6s6E8D1arRTTHH/xouoTSKFxxSEnlX8i2CSSHdo5mEZ9f7gzUchtNA1vrO/Qsr5koj3F818KO4t3fkP4cCwFdJfvy9A/jqvkv2sBm1jCsHVq4tGSeXOfdNPrr/4Pmi0H4RJIq61aLkaR3xNSVk29CZgD/JkhtXh6OaguC+vvbcKPS8mx22kfbKxSnm1u26y9svEbqj2w+aTIp5Jz0GmM6rd72MUqIHxlkHM0DGZ04ika/cig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRmywE70QtxT1xQRUnQN5Z4WhsBliwKn8saFy4y14tc=;
 b=A8A302MJxHcunpy7h0yEKx1oGUDaXOufMXdZF3pGCjfpocwe5NdIOVfBwkoJTwpEv+uEd1zXqUQTCNYZTWAfi5HktfzsfLcAQ5YuT7QaV6KEJJwcAq4v78HNMOfC8fwXlzSmVMx//b4y7vSn4nKdf9Tm+RYa0MBZq4tx3ir9T7Q=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3348.namprd18.prod.outlook.com (2603:10b6:a03:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 10:34:39 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:34:39 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 11/13] scsi: qedi: pass send_iscsi_tmf task to abort
Thread-Topic: [EXT] [PATCH 11/13] scsi: qedi: pass send_iscsi_tmf task to
 abort
Thread-Index: AQHXLjkHtZ5JRXe28U6AzM2gxAVUuqqwsk4Q
Date:   Mon, 12 Apr 2021 10:34:39 +0000
Message-ID: <BYAPR18MB2998C372567704451C3264E5D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-12-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-12-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66173120-2866-411b-65ac-08d8fd9e9375
x-ms-traffictypediagnostic: BY5PR18MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3348310B6A470153A897FCDAD8709@BY5PR18MB3348.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cr9mYG/79h3y6nd38EO9ZRhX2Vyq1kEEuT4c1vGOxy7FDTfwK4R0Nr1DqErmqEyDwbiysZPg7dUoNt+YlfvT+os4KZodL2c2aB3625VfxUfXtxIh51HFiEntd35Ioo8f+0D5sBKdg9GSh8XRVvbAw/yNySp34MnN82H71Ctxme15JvKThWny0B/ZbrNoTUEAKa6T1TeYCY6BGyEaJOzcom87H3obaeijrApE+RLcJA1I9z/NOp0kP6CtXIG+tyL8c1OkTgkcrzR8zZ2IYuUCRJaW/I1Ug1hK+MZxYSHLvdvLosMbNKYzrnq1xg4wAuc+SNMELxK/QQP2wCXW107B1ppYyKGdBm0+dSMBnxY8y3JkVotlxmuICa7twtDeeHgi2IDTPmLK9L1Houbqnphi7nepKNs9cLtLsOgQvlqrFl2IstiqPD4Q6OPlYT1m4+krcLtWH+csbLlTUCmePQvxKDdFA0T4foUu+R8l4+B7LjM4r4pmj40qzcCrC56k1LYEO+9fkzG3DIJ7+UmFmH7rjgMhEXvyQ1TyhzDWUaNNq0o9McO8wdPf70IhhDI9/NpdkaDi3T713ULPxQYxpqVG4q59VciI6gEXS8v2TCmdI6s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(26005)(38100700002)(9686003)(110136005)(478600001)(7696005)(83380400001)(64756008)(66946007)(71200400001)(316002)(66446008)(66556008)(86362001)(186003)(76116006)(8936002)(8676002)(33656002)(6506007)(53546011)(55016002)(52536014)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tqfYzn+H2OdVm6/5cnjlfvyHH+4Dn3kHawv5Q7OeZGVlX3t7tS31qm5qlyl9?=
 =?us-ascii?Q?p+7i5qWqQV61SNjylHPvbQZNtZTpF066cRgNDUlRLtytdqaB3mxPONvzX0T9?=
 =?us-ascii?Q?GIT46PQaqU3x2JBexhBvVDEtoVJWqV0CdTF4isUu64zEjLGb0KglmDoe0b3Z?=
 =?us-ascii?Q?xoC+B5A7VioxWqMQERhFDQUzUcTgaOyhYAu/gxf87kvY4JMWwqjYnNDrYaZI?=
 =?us-ascii?Q?ZvLfzACN9NpIJujp2PQAjJ8t5pN1SdRnBSZTtfxaq23Yc51ZyJeUerBcNPSj?=
 =?us-ascii?Q?kNWFipEU+bJLlcGAulVJWuGIkYPda5tlssDpWacmn9zfYz3ssN08mg9HLVh2?=
 =?us-ascii?Q?uiRpwG84kYmDyxCwXPxWLm9+H0/rbzTk+Qv942zBXI/xo9F7LHW8XA1eqLoc?=
 =?us-ascii?Q?Ji7cG37wpm9WGdHw8JsPYZF/BLXmaazKdh36jArvk+jWEMPrxnjX0HmOg9Gi?=
 =?us-ascii?Q?YgJu1qn4NiXjvZer1iqNpwEC5ZWOJgQgS8R4Bgj4+rx/2oPCItyk0YdvwWbO?=
 =?us-ascii?Q?JMaoTViTr3FGidGJl92v8AF6ziDjy6sPiI37jRFO+jhpzf0JevPRf6LRgyLI?=
 =?us-ascii?Q?zJTO820wwmoa5AAMYweAj23Vbh4DK3vQfL2hf1PDdsk37Y0DswwvhsiMxNLx?=
 =?us-ascii?Q?MqwFcFzx/oUt06Xvjk1TB9ZMO20EHSNAdiBwAnrvIlD1uuOx+xtcaECddJow?=
 =?us-ascii?Q?xIezqvxINcC5NRTrna9Wek7G8PujxdXPwPdj0DSaB4rhyjl24l9E8LsFUuAn?=
 =?us-ascii?Q?tMXC5yWa/fjrLAaMP5oMmb9b5hvIPzJVeqcY96YV9GAF2L2FL20f3KayxKim?=
 =?us-ascii?Q?anFo9cKT3jYbqjfGFhF7wZW0Gk4lhXnDHQIbrBi3phcHH08aQ0m1oCXAoWo1?=
 =?us-ascii?Q?8J5tI94eyuovuFCFwyC5m0b+gwRifF3GHVwDl8szGzkFbcpyr/VnPJsf7DIT?=
 =?us-ascii?Q?TdmpIa6kbDC8bwsvq/3Ntq2b3XtOBPydcrwQA8nXI6Wrpbf9hDpcTZd3prdW?=
 =?us-ascii?Q?xcCeKlZwztQX213F2yenHZJ4A2wV0bH1NLzIadAlxDC3X+erXwZ45N4gOj1z?=
 =?us-ascii?Q?fzFjcmQLEdy16b/Bqs3XF9SHNhrRDssmI7tQ06IvgZUcLUq/rs1y4o4Ascif?=
 =?us-ascii?Q?dJe59y8OIAPhwV7lo5XnKyxnpWDVV7P267mlEQp1BAs7mz8Zw+0UaH8Wc38y?=
 =?us-ascii?Q?Z3FFa0ryUzN2sZirSjz0kmgLRpX1Cg6V/hvIJhNG6cp576s9BwilQnAHoYAY?=
 =?us-ascii?Q?Usc3id3vrW8VndmnF9QSl27EuKplEkBPTuNtgJQQSjced8ekFgUxBU/wd8Cl?=
 =?us-ascii?Q?uVebj0kEHfPJQcqtMD9CUe2v?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66173120-2866-411b-65ac-08d8fd9e9375
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:34:39.1360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QGn3f4e2gDklJvKsDwwYGU6asgiEfe4F8fryQsazjZ0jQRzJGwi6tuEHw0UhO+nw1QUETm3gLK1lGT1vBdZJHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3348
X-Proofpoint-GUID: gnjz32b1kEbz9EgpxQ3vcG3n1Ncveo1S
X-Proofpoint-ORIG-GUID: UohYO71Ci-9L2ungK-kcIyoPF10xERzt
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
> Subject: [EXT] [PATCH 11/13] scsi: qedi: pass send_iscsi_tmf task to abor=
t
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> qedi_abort_work knows what task to abort so just pass it to send_iscsi_tm=
f.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> f13f8af6d931..475cb7823cf1 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -15,7 +15,7 @@
>  #include "qedi_fw_scsi.h"
>=20
>  static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
> -			  struct iscsi_task *mtask);
> +			  struct iscsi_task *mtask, struct iscsi_task *ctask);
>=20
>  void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)  { @@ -1425,7 +1425,=
7
> @@ static void qedi_abort_work(struct work_struct *work)
>  		goto ldel_exit;
>  	}
>=20
> -	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
> +	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
>=20
>  put_task:
>  	iscsi_put_task(ctask);
> @@ -1455,14 +1455,13 @@ static void qedi_abort_work(struct work_struct
> *work)
>  	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);  }
>=20
> -static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task=
 *mtask)
> +static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task=
 *mtask,
> +			  struct iscsi_task *ctask)
>  {
>  	struct iscsi_tmf_request_hdr tmf_pdu_header;
>  	struct iscsi_task_params task_params;
>  	struct qedi_ctx *qedi =3D qedi_conn->qedi;
>  	struct e4_iscsi_task_context *fw_task_ctx;
> -	struct iscsi_conn *conn =3D qedi_conn->cls_conn->dd_data;
> -	struct iscsi_task *ctask;
>  	struct iscsi_tm *tmf_hdr;
>  	struct qedi_cmd *qedi_cmd;
>  	struct qedi_cmd *cmd;
> @@ -1502,12 +1501,6 @@ static int send_iscsi_tmf(struct qedi_conn
> *qedi_conn, struct iscsi_task *mtask)
>=20
>  	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
>  	     ISCSI_TM_FUNC_ABORT_TASK) {
> -		ctask =3D iscsi_itt_to_task(conn, tmf_hdr->rtt);
> -		if (!ctask || !ctask->sc) {
> -			QEDI_ERR(&qedi->dbg_ctx,
> -				 "Could not get reference task\n");
> -			return 0;
> -		}
>  		cmd =3D (struct qedi_cmd *)ctask->dd_data;
>  		tmf_pdu_header.rtt =3D
>  				qedi_set_itt(cmd->task_id,
> @@ -1560,7 +1553,7 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn=
,
> struct iscsi_task *mtask)
>  	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
>  	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
>  	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
> -		rc =3D send_iscsi_tmf(qedi_conn, mtask);
> +		rc =3D send_iscsi_tmf(qedi_conn, mtask, NULL);
>  		break;
>  	default:
>  		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=3D0x%x\n",
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
