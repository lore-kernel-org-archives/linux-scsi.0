Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F20AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A27A2311C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbhAFPGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:06:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57680 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbhAFPGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 10:06:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106F5Rei119091;
        Wed, 6 Jan 2021 15:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=9q8T3Vu7++8yb/vA+4O2rs0n8Q/tuQGKbT2eHjdz5Js=;
 b=z61Q4F5fYSjONIc+6hv/5VQuiXD47IDMkA/KHodVKJTI6UXmikR9PuifyymVLYoRxsAv
 LqTVsBVANgqMQ3E73LQIBj93J1OPAHlZsS4ZztH1v3SQESu36/QO5G8TBQbAsYWbQn4w
 x6oF1pjo5pXqGK1LVRBZm8kOPFk4hbD8/HVYM4EGYYcsSM3CE5kb79D/i4VMa3GMTfah
 YflfTXimwy+2QFEjTRFBoxck3tNWtUTtvvd5BHMz1ZtLU2TcPnT6X3II6Dai1T2C74Kl
 Ps7xUwVld7TBKeqaoyIRIddj6qK0E775wuR8VmF+MFDmaT9iOk+vlkzAbSaiQKPAbdKq Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35wcuxrn53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:06:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106EuR85181075;
        Wed, 6 Jan 2021 15:06:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35v4rcs8s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:06:01 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106F61Lc021063;
        Wed, 6 Jan 2021 15:06:01 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 07:06:01 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 2/7] qla2xxx: Add error counters to debugfs node
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210105103847.25041-3-njavali@marvell.com>
Date:   Wed, 6 Jan 2021 09:06:00 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BA528001-1181-4D7C-AC1B-992162EFF591@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-3-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Display error counters via debugfs node.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dfs.c | 28 ++++++++++++++++++++++++++++
> 1 file changed, 28 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index d5ebcf7d70ff..ccce0eab844e 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -286,6 +286,10 @@ qla_dfs_tgt_counters_show(struct seq_file *s, =
void *unused)
> 		core_qla_snd_status, qla_core_ret_sta_ctio, =
core_qla_free_cmd,
> 		num_q_full_sent, num_alloc_iocb_failed, =
num_term_xchg_sent;
> 	u16 i;
> +	fc_port_t *fcport =3D NULL;
> +
> +	if (qla2x00_chip_is_down(vha))
> +		return 0;
>=20
> 	qla_core_sbt_cmd =3D qpair->tgt_counters.qla_core_sbt_cmd;
> 	core_qla_que_buf =3D qpair->tgt_counters.core_qla_que_buf;
> @@ -349,6 +353,30 @@ qla_dfs_tgt_counters_show(struct seq_file *s, =
void *unused)
> 		vha->qla_stats.qla_dif_stats.dif_ref_tag_err);
> 	seq_printf(s, "DIF App tag err =3D %d\n",
> 		vha->qla_stats.qla_dif_stats.dif_app_tag_err);
> +
> +	seq_puts(s, "\n");
> +	seq_puts(s, "Initiator Error Counters\n");
> +	seq_printf(s, "HW Error Count =3D		%14lld\n",
> +		   vha->hw_err_cnt);
> +	seq_printf(s, "Link Down Count =3D	%14lld\n",
> +		   vha->short_link_down_cnt);
> +	seq_printf(s, "Interface Err Count =3D	%14lld\n",
> +		   vha->interface_err_cnt);
> +	seq_printf(s, "Cmd Timeout Count =3D	%14lld\n",
> +		   vha->cmd_timeout_cnt);
> +	seq_printf(s, "Reset Count =3D		%14lld\n",
> +		   vha->reset_cmd_err_cnt);
> +	seq_puts(s, "\n");
> +
> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +		if (!fcport || !fcport->rport)
> +			continue;
> +
> +		seq_printf(s, "Target Num =3D %7d Link Down Count =3D =
%14lld\n",
> +			   fcport->rport->number, =
fcport->tgt_short_link_down_cnt);
> +	}
> +	seq_puts(s, "\n");
> +
> 	return 0;
> }
>=20
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

