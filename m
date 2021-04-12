Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB4BC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152FD6121E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhDLKYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:24:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239203AbhDLKYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:24:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CALWW4014617;
        Mon, 12 Apr 2021 03:24:13 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm2wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:24:13 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAODgr020204;
        Mon, 12 Apr 2021 03:24:13 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm2wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:24:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbrm59zHztQKgL6DuHV4rWLP0OC2lwtjsM52n4tMTWrm3+dj7rUjwW+JdaaQne/lXOLIW8LeYMup3d5kTSPrNpt+a5et9PxmzSRRrr1vTSplpA/A2yKw98K8CJscMcj4izTm761gtBHfGOpMrZL9/l72dyDGwurE+B6OKHGRG2E2dax2na1DCprTjUCVcOwUb4YMC+cCFVMyhfmwv1ASU1IpRF/To3cRFXAeTT9N6g899MmeqTex6H+u/z+oc1LzwhJLeQygSZJClfynmRfGxDz35No55eloEGUXstINW0WPkTTAs+wxAevBaT3YfQrpz1EV8t2s1WJh4RT5TVfAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLJDTVFcDI287pzCbnqLKXWXC4Ku2m627gNrzggfktg=;
 b=TjSD3CRPtLr62BNdiCSuEib5+Hsrnq0+d70s/umP87y2KXJ7PSNe57eZJQ9+BisaebHCJYJ4BNTWKyAL3gKfyk9Dh2IdI+IH0RZBE5cDSS1d4AXR3FbU0Oebx04GZHaloGmkRJvd30+Afo4+cj83mdcHaemgydBUMojyWl9aoQPG18WglKZI0jwkUfpUah75XOI7VfTyVSECRuJzYqjOJvi/CqyW4ccIoxQWiFXpI9LGO8n5VEMYY15HGHgBz/lH3r4L97MqARyOWSVY/6bMzF6KtmEiEdIbOJ4OXzSDEof5hWsOo8yxOQKrkx5NcEodvnUHwzgqXonbaoDywrAKvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLJDTVFcDI287pzCbnqLKXWXC4Ku2m627gNrzggfktg=;
 b=u4Ay74OwuOVO9SvhgPuuHQjMUyGmDsHDgrdarSLa8RpkwyEM0OfpVFvSTy6Ub9OqL2gTFvAl16e/tsQXG1Fp97Y+gG+Z8gZB7f5UMuuiWi8L+xd151AAfE8RPKTv/wTqBtR+NNlfLpsQgsGJUrsRUOyIJtj7m5bZbnMTtJVGKNc=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB3900.namprd18.prod.outlook.com (2603:10b6:a03:2e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:24:11 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:24:11 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 04/13] scsi: qedi: fix abort vs cmd re-use race
Thread-Topic: [EXT] [PATCH 04/13] scsi: qedi: fix abort vs cmd re-use race
Thread-Index: AQHXLjj/cgThNwHT20GXkuoOmNdQwqqwr0iQ
Date:   Mon, 12 Apr 2021 10:24:11 +0000
Message-ID: <BYAPR18MB29980576C7E171DAA6577D47D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-5-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-5-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c1cdd2d-0ca3-42f7-a0c6-08d8fd9d1d65
x-ms-traffictypediagnostic: SJ0PR18MB3900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB39003E4A364D3F93FE5FC2EFD8709@SJ0PR18MB3900.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nUPdEgKGg4I9iwLjRuf7ReQY2hkdNwCbSZa9sm7a2XsXe68uXK0DvohB4juQFPeessn1iBH3HFgoTcMTIu/49u8Z5yO+aJ/ueTPygPIX2FqGPCkSJ49v4/YvGUFLUir7c+ALbdUFoRroa+TRCouq0bSx1INXrSzRpuxc12OFanUlqaPuEZg4WMJZwQM+aJWLA2c899lf/+Qhqi9RKOPHkQyGawAEFOpxg2w15ykubkaZAPdZKhsp2V1gx1sMUWY99fOmvDt7ifL78KsdpIAlmdLuvlIqE3IfapIp9eJyf9y0izw3d+atr7Rp+DXXsZ/Lx6hSKoi23JYzxB/QBJXbugoCH4re4fPqxGxxgjfIwz/yo+Js6xC9Blc4nrjD5KkJieCvAJJTUCYntuCsuGB7TjGqn0SmX+HnBzSq/Hsesy2DGVyPRCb9GqA4onjrK7kzJrr8h26ydTaoNPdXP/ryedmBbILSB+//L6mBFcVltct7a0HqpBaJwgI+KoUKNQZsnacALalnzdTriASCLpUoFxK12qZd00I1UoeO4A4GXVvxob2NMQxQ57euz/p9lMSou8nnP03XB7Y188vlJX3peBfCVEk6xkwDnKRaJKA6wxw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(86362001)(316002)(8936002)(9686003)(6506007)(71200400001)(64756008)(38100700002)(76116006)(110136005)(83380400001)(53546011)(66946007)(66446008)(33656002)(5660300002)(26005)(2906002)(52536014)(8676002)(478600001)(7696005)(66556008)(186003)(66476007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?n2Z5AjjzXcx7JILaWCFEM+3Z2qWtpWZkk0pYfNg92gfx8NuuaSZCR7FRqB2Z?=
 =?us-ascii?Q?0JSHbDQapqekwZ2AUbpqL0Z20e3kJHBnfRXvBKalp4jTtdby0FzFFiDKlOZl?=
 =?us-ascii?Q?vIZmRPIVzS8EicEPSGNoE4EtOBrvssJgqoHmIqtbmxjPdMS5GLd6cogEB89T?=
 =?us-ascii?Q?nUjOqSYVX6AAkzAmVdP38GEScP89O3CMbQywxct5GhVQEmgWuYzu5vbS18xU?=
 =?us-ascii?Q?QGOeXx9b4/o1bvQBi3gOU5/f0ZF75VEIDd0G5b3i5rIUmWo8W0+QWaS3QmQ7?=
 =?us-ascii?Q?60LE4+4TgCKuteyVH9+UylLSqxUvWFb+kipy3s6YzHU/DufE2/s3nfcVcRji?=
 =?us-ascii?Q?r10qrXBoNmT6YZuUczAcO/odhTM2Cf/6EKPutMXh349WWK7vgqMqSLInc+pH?=
 =?us-ascii?Q?3br96SNMaFM2rUbn/kqJ1APfnGCyou7ujo4mTvCuH+5JuMPwNCHWCA7QTt7U?=
 =?us-ascii?Q?Lsym5tUKUOY2c7BfnWmyv4Hc4Mu4WE/VQb/ZPnm3OdMywSO/2u7c2OD1nT9Z?=
 =?us-ascii?Q?zOvB5KXTIFfYjPhJM45ITPCmJH7VG9d/HRt4OAAhe7AY4VxklU/VUApMEMRd?=
 =?us-ascii?Q?KUPyq5Zc/cshZMSw+d1MQIZMaDNCUswiGrjOnuZwPc2Bd0kJXTxvm3lQppJD?=
 =?us-ascii?Q?cqiRSYaCkWu7GkKlF8AQUo7+9Mbyo3j7uSqHWMnZnSq8HL0ZLnOkqfcyKiMl?=
 =?us-ascii?Q?UFC5y1cLf7SJP/9hIxDKItg2+auVmjfwdgeIxG5CwLNHZLzU+hKErG1p54gU?=
 =?us-ascii?Q?e5BX5ELwWOLHK3usrx+A3Ds+MVK8pzgNfgmiKH1RkU32+nSyKe3LB6I8anNt?=
 =?us-ascii?Q?SylcJwXvmRgUPzauuOpTJlF7a9unI6rbTKkauwy9lm8cmfKJjaeH/vW6hkZU?=
 =?us-ascii?Q?jj6XV8F4lRv9sxPxIEM++vLCMNrH3rKMQoyVH8SKWZ1pkK/wFotF+N9Jc15F?=
 =?us-ascii?Q?j6iOtgu5vCq8bMelRUg845o5Rarw9XeS5yD+d0bNhob2ishv/IPvmOzR1bto?=
 =?us-ascii?Q?3VShPLp+4YFW/f5xSSdulZSI+JNwTY0FH+staajFUvYefft8f+jvNLEQz9oD?=
 =?us-ascii?Q?hqOcXv/uDKvxYVgI3bLxTXmWLWdcb66Ph4KQSxOtWppZyPxm1MPvu8/A+4hU?=
 =?us-ascii?Q?DnBfb9Y+voKvBQc3Aj5w+E3vMPWYN+jE5ngsHRI8ghh6WmZwBjlkAnuoIHcl?=
 =?us-ascii?Q?xK1VAIp0ZeeDE8PcRSaLUO7SFsvjUnn+BJMwpU5+irBQ1gt6E+blTUM4Tkgs?=
 =?us-ascii?Q?EHB8JJhvnVy+L5z6AQCBZgL0wRcd/smPjpItmRkja0lYy3b34Y7f0NQ2dkWJ?=
 =?us-ascii?Q?ZECA9B7Ce2tjNoAbbu7WtN+A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1cdd2d-0ca3-42f7-a0c6-08d8fd9d1d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:24:11.5928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BChFrAauqcTlpyweN+5UkHow2hz9/84DCEvLeeY+PuLfCecIBRvJTWFG8MA72rISjJt8v9FiojVNGP797We+xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3900
X-Proofpoint-ORIG-GUID: wTN7B6V1rOKg-t1_SNFoFyCX230WuHys
X-Proofpoint-GUID: yazceJPNmNBtChIZInhCZsrL3qvYDixV
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
> Subject: [EXT] [PATCH 04/13] scsi: qedi: fix abort vs cmd re-use race
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> If the scsi cmd completes after qedi_tmf_work calls iscsi_itt_to_task the=
n the
> qedi qedi_cmd->task_id could be freed and used for another cmd. If we the=
n call
> qedi_iscsi_cleanup_task with that task_id we will be cleaning up the wron=
g cmd.
>=20
> This patch has us wait to release the task_id until the last put has been=
 done on
> the iscsi_task. Because libiscsi grabs a ref to the task when sending the=
 abort,
> we know that for the non abort timeout case that the task_id we are
> referencing is for the cmd that was supposed to be aborted.
>=20
> The next patch will fix the case where the abort timesout while we are ru=
nning
> qedi_tmf_work.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 13 -------------
>  drivers/scsi/qedi/qedi_iscsi.c | 20 +++++++++++++++++---
>  2 files changed, 17 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> cf57b4e49700..ad4357e4c15d 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -73,7 +73,6 @@ static void qedi_process_logout_resp(struct qedi_ctx
> *qedi,
>  	spin_unlock(&qedi_conn->list_lock);
>=20
>  	cmd->state =3D RESPONSE_RECEIVED;
> -	qedi_clear_task_idx(qedi, cmd->task_id);
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
>=20
>  	spin_unlock(&session->back_lock);
> @@ -138,7 +137,6 @@ static void qedi_process_text_resp(struct qedi_ctx
> *qedi,
>  	spin_unlock(&qedi_conn->list_lock);
>=20
>  	cmd->state =3D RESPONSE_RECEIVED;
> -	qedi_clear_task_idx(qedi, cmd->task_id);
>=20
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
>  			     qedi_conn->gen_pdu.resp_buf,
> @@ -164,13 +162,11 @@ static void qedi_tmf_resp_work(struct work_struct
> *work)
>  	iscsi_block_session(session->cls_session);
>  	rval =3D qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
>  	if (rval) {
> -		qedi_clear_task_idx(qedi, qedi_cmd->task_id);
>  		iscsi_unblock_session(session->cls_session);
>  		goto exit_tmf_resp;
>  	}
>=20
>  	iscsi_unblock_session(session->cls_session);
> -	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
>=20
>  	spin_lock(&session->back_lock);
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
> @@ -245,8 +241,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx
> *qedi,
>  		goto unblock_sess;
>  	}
>=20
> -	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
> -
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
>  	kfree(resp_hdr_ptr);
>=20
> @@ -314,7 +308,6 @@ static void qedi_process_login_resp(struct qedi_ctx
> *qedi,
>  		  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>  		  cmd->task_id, qedi_conn->iscsi_conn_id);
>  	cmd->state =3D RESPONSE_RECEIVED;
> -	qedi_clear_task_idx(qedi, cmd->task_id);
>  }
>=20
>  static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi, @@ -468,7 +461,6 =
@@
> static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
>  		}
>=20
>  		spin_unlock(&qedi_conn->list_lock);
> -		qedi_clear_task_idx(qedi, cmd->task_id);
>  	}
>=20
>  done:
> @@ -673,7 +665,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qed=
i,
>  	if (qedi_io_tracing)
>  		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
>=20
> -	qedi_clear_task_idx(qedi, cmd->task_id);
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
>  			     conn->data, datalen);
>  error:
> @@ -730,7 +721,6 @@ static void qedi_process_nopin_local_cmpl(struct
> qedi_ctx *qedi,
>  		  cqe->itid, cmd->task_id);
>=20
>  	cmd->state =3D RESPONSE_RECEIVED;
> -	qedi_clear_task_idx(qedi, cmd->task_id);
>=20
>  	spin_lock_bh(&session->back_lock);
>  	__iscsi_put_task(task);
> @@ -821,8 +811,6 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>  			if (qedi_cmd->state =3D=3D CLEANUP_WAIT_FAILED)
>  				qedi_cmd->state =3D CLEANUP_RECV;
>=20
> -			qedi_clear_task_idx(qedi_conn->qedi, rtid);
> -
>  			spin_lock(&qedi_conn->list_lock);
>  			if (likely(dbg_cmd->io_cmd_in_list)) {
>  				dbg_cmd->io_cmd_in_list =3D false;
> @@ -856,7 +844,6 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
>  			  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>  			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
>=20
>  	} else {
>  		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt); diff --git
> a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c index
> 08c05403cd72..d1da34a938da 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -772,7 +772,6 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn,
> struct iscsi_task *task)
>  	}
>=20
>  	cmd->conn =3D conn->dd_data;
> -	cmd->scsi_cmd =3D NULL;
>  	return qedi_iscsi_send_generic_request(task);
>  }
>=20
> @@ -783,6 +782,10 @@ static int qedi_task_xmit(struct iscsi_task *task)
>  	struct qedi_cmd *cmd =3D task->dd_data;
>  	struct scsi_cmnd *sc =3D task->sc;
>=20
> +	/* Clear now so in cleanup_task we know it didn't make it */
> +	cmd->scsi_cmd =3D NULL;
> +	cmd->task_id =3D -1;
> +
>  	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
>  		return -ENODEV;
>=20
> @@ -1383,13 +1386,24 @@ static umode_t qedi_attr_is_visible(int
> param_type, int param)
>=20
>  static void qedi_cleanup_task(struct iscsi_task *task)  {
> -	if (!task->sc || task->state =3D=3D ISCSI_TASK_PENDING) {
> +	struct qedi_cmd *cmd;
> +
> +	if (task->state =3D=3D ISCSI_TASK_PENDING) {
>  		QEDI_INFO(NULL, QEDI_LOG_IO, "Returning ref_cnt=3D%d\n",
>  			  refcount_read(&task->refcount));
>  		return;
>  	}
>=20
> -	qedi_iscsi_unmap_sg_list(task->dd_data);
> +	if (task->sc)
> +		qedi_iscsi_unmap_sg_list(task->dd_data);
> +
> +	cmd =3D task->dd_data;
> +	if (cmd->task_id !=3D -1)
> +		qedi_clear_task_idx(iscsi_host_priv(task->conn->session->host),
> +				    cmd->task_id);
> +
> +	cmd->task_id =3D -1;
> +	cmd->scsi_cmd =3D NULL;
>  }
>=20
>  struct iscsi_transport qedi_iscsi_transport =3D {
> --
> 2.25.1

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

