Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FA1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC692080C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q2lwCqyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLTrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:47:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgHLTrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:47:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJl3YJ118618;
        Wed, 12 Aug 2020 19:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=f2tTHqdIAfCkB1rssI6XdstGgmMogXbRsEtQWnBJDcs=;
 b=Q2lwCqyMtwvU/VcUZxKlmCbxHIpwPzUgHFreXOB+KLEpSYCg4YonbzMvLZo0ZAmTiUd3
 13ox41VchA/QD07UcqQz2/+7oAqgeLTmccYScw3JErx2n8gtSZrHjI5R9fQ3EhHp2HSr
 hXmSCu78vRamH/pBqo5MrDLAjAwUOQjbafC1lNxVBQBHiD2Tkyvt7gN53dE2nbDr7R68
 bLu81gf5PqANOWwpmyIkkwzCT03T8Y9FWSGIM/JM66mUsavuPPoi5Ni5ExPUJvkr31IK
 NxvQJDeq35DqEDBO5jtKXxcdAnV8bzdl0e45DOH78CCPHPh1gtazRgiiIIn0kqq8WTQt EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mvthf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:47:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJhNHP109789;
        Wed, 12 Aug 2020 19:47:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32t5y7ps7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:47:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07CJlCJD009466;
        Wed, 12 Aug 2020 19:47:12 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:47:12 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 09/11] qla2xxx: fix null pointer access while
 connections disconnect from subsystem
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-10-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:47:11 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <56E6FCD0-0901-428B-B386-049899E86416@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-10-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=3 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> NVMEAsync command is being submitted to QLA, while the same nvme =
controller
> is in the middle of reset. The reset path has deleted the association =
and
> freed aen_op->fcp_req.private. Add a check for this private pointer
> before issuing the command.
>=20
> ...
> 6 [ffffb656ca11fce0] page_fault at ffffffff8c00114e
>    [exception RIP: qla_nvme_post_cmd+394]
>    RIP: ffffffffc0d012ba  RSP: ffffb656ca11fd98  RFLAGS: 00010206
>    RAX: ffff8fb039eda228  RBX: ffff8fb039eda200  RCX: 00000000000da161
>    RDX: ffffffffc0d4d0f0  RSI: ffffffffc0d26c9b  RDI: ffff8fb039eda220
>    RBP: 0000000000000013   R8: ffff8fb47ff6aa80   R9: 0000000000000002
>    R10: 0000000000000000  R11: ffffb656ca11fdc8  R12: ffff8fb27d04a3b0
>    R13: ffff8fc46dd98a58  R14: 0000000000000000  R15: ffff8fc4540f0000
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 7 [ffffb656ca11fe08] nvme_fc_start_fcp_op at ffffffffc0241568 =
[nvme_fc]
> 8 [ffffb656ca11fe50] nvme_fc_submit_async_event at ffffffffc0241901 =
[nvme_fc]
> 9 [ffffb656ca11fe68] nvme_async_event_work at ffffffffc014543d =
[nvme_core]
> 10 [ffffb656ca11fe98] process_one_work at ffffffff8b6cd437
> 11 [ffffb656ca11fed8] worker_thread at ffffffff8b6cdcef
> 12 [ffffb656ca11ff10] kthread at ffffffff8b6d3402
> 13 [ffffb656ca11ff50] ret_from_fork at ffffffff8c000255
>=20
> --
> PID: 37824  TASK: ffff8fb033063d80  CPU: 20  COMMAND: =
"kworker/u97:451"
> 0 [ffffb656ce1abc28] __schedule at ffffffff8be629e3
> 1 [ffffb656ce1abcc8] schedule at ffffffff8be62fe8
> 2 [ffffb656ce1abcd0] schedule_timeout at ffffffff8be671ed
> 3 [ffffb656ce1abd70] wait_for_completion at ffffffff8be639cf
> 4 [ffffb656ce1abdd0] flush_work at ffffffff8b6ce2d5
> 5 [ffffb656ce1abe70] nvme_stop_ctrl at ffffffffc0144900 [nvme_core]
> 6 [ffffb656ce1abe80] nvme_fc_reset_ctrl_work at ffffffffc0243445 =
[nvme_fc]
> 7 [ffffb656ce1abe98] process_one_work at ffffffff8b6cd437
> 8 [ffffb656ce1abed8] worker_thread at ffffffff8b6cdb50
> 9 [ffffb656ce1abf10] kthread at ffffffff8b6d3402
> 10 [ffffb656ce1abf50] ret_from_fork at ffffffff8c000255
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index be1d49f5c622..f451683db75c 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -535,6 +535,11 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
> 	struct nvme_private *priv =3D fd->private;
> 	struct qla_nvme_rport *qla_rport =3D rport->private;
>=20
> +	if (!priv) {
> +		/* nvme association has been torn down */
> +		return rval;
> +	}
> +
> 	fcport =3D qla_rport->fcport;
>=20
> 	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

