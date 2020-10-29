Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D46C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E338220725
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qphwEY3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgJ2UYe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:24:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:24:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKFU28174477;
        Thu, 29 Oct 2020 20:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=gxAhk61a103CWX3oZpmTSmIwSHQNkRRGoKzaTCOEFFU=;
 b=qphwEY3bFzRnRoDZEXQQjb51NfcQOhdnJpeWCsYZhL7RZJ19AV843uhQJmZKjSS+Eo83
 7N5nM34/QDB1pSFWP6ILoP4VNL5XQHLifzbnIPiWM195aAYPZAtHYVWfwwWVxjmO6G4b
 Z5BgqQJCxg4IGu+NQ3mYLY2ATp504/UtEXyog8ltdRNeNPyulCNtL69ZXdyQf6nYKv6P
 AbrPElHY9A80TixKJRTjlxwiAshuOqJWC4kZSsjnvI7hBRaThOHXNTukw2EXxLfpszF5
 LqT0y/nw23UHT+avJiKxfIFSNy+ybUoRPTH3vpNhLO5yX8zGSUolpxXGxu71JyMcTY9E 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb71e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:24:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKPeY070601;
        Thu, 29 Oct 2020 20:24:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1tn6p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:24:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TKONhC019221;
        Thu, 29 Oct 2020 20:24:23 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:24:20 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 3/8] tcm qla2xxx: drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-4-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:24:19 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D5EEF40-5E65-49AD-BAA2-C479D646BD14@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-4-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=3 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Small nit for the Subject:=20

Can you please use just =E2=80=9Cqla2xxx=E2=80=9D for this as convention =
to the driver updates.

> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> It looks like only the __qlt_24xx_handle_abts code path does not know
> the lun for an abort and it uses the TARGET_SCF_LOOKUP_LUN_FROM_TAG
> flag to have lio core look it up. LIO uses target_lookup_lun_from_tag
> to go from cmd tag to lun for the driver. However, qla2xxx has a
> tcm_qla2xxx_find_cmd_by_tag which does almost the same thing as the
> LIO helper (it finds the cmd but does not return the lun). This patch
> has qla2xxx use its internal helper.
>=20
> This is more of a transition patch and that is why I'm having qla2xxx
> use its internal function instead of killing it. The tcm qla2xxx =
driver
> is the only that needs the sess_cmd_list, so the first couple of =
patches
> move that list from LIO core to the driver. The final patches then
> remove the sess_cmd_lock from the main IO path.
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c  | 21 +++++++++++----------
> drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +---
> 2 files changed, 12 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c =
b/drivers/scsi/qla2xxx/qla_target.c
> index a27a625..f88548b 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2083,6 +2083,7 @@ static int __qlt_24xx_handle_abts(struct =
scsi_qla_host *vha,
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct qla_tgt_mgmt_cmd *mcmd;
> 	struct qla_qpair_hint *h =3D &vha->vha_tgt.qla_tgt->qphints[0];
> +	struct qla_tgt_cmd *abort_cmd;
>=20
> 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
> 	    "qla_target(%d): task abort (tag=3D%d)\n",
> @@ -2110,17 +2111,17 @@ static int __qlt_24xx_handle_abts(struct =
scsi_qla_host *vha,
> 	 */
> 	mcmd->se_cmd.cpuid =3D h->cpuid;
>=20
> -	if (ha->tgt.tgt_ops->find_cmd_by_tag) {
> -		struct qla_tgt_cmd *abort_cmd;
> -
> -		abort_cmd =3D ha->tgt.tgt_ops->find_cmd_by_tag(sess,
> +	abort_cmd =3D ha->tgt.tgt_ops->find_cmd_by_tag(sess,
> 				=
le32_to_cpu(abts->exchange_addr_to_abort));
> -		if (abort_cmd && abort_cmd->qpair) {
> -			mcmd->qpair =3D abort_cmd->qpair;
> -			mcmd->se_cmd.cpuid =3D abort_cmd->se_cmd.cpuid;
> -			mcmd->abort_io_attr =3D =
abort_cmd->atio.u.isp24.attr;
> -			mcmd->flags =3D =
QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
> -		}
> +	if (!abort_cmd)
> +		return -EIO;
> +	mcmd->unpacked_lun =3D abort_cmd->se_cmd.orig_fe_lun;
> +
> +	if (abort_cmd->qpair) {
> +		mcmd->qpair =3D abort_cmd->qpair;
> +		mcmd->se_cmd.cpuid =3D abort_cmd->se_cmd.cpuid;
> +		mcmd->abort_io_attr =3D abort_cmd->atio.u.isp24.attr;
> +		mcmd->flags =3D QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
> 	}
>=20
> 	INIT_WORK(&mcmd->work, qlt_do_tmr_work);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 61017ac..f5a91bf 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -574,13 +574,11 @@ static int tcm_qla2xxx_handle_tmr(struct =
qla_tgt_mgmt_cmd *mcmd, u64 lun,
> 	struct fc_port *sess =3D mcmd->sess;
> 	struct se_cmd *se_cmd =3D &mcmd->se_cmd;
> 	int transl_tmr_func =3D 0;
> -	int flags =3D TARGET_SCF_ACK_KREF;
>=20
> 	switch (tmr_func) {
> 	case QLA_TGT_ABTS:
> 		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
> 		transl_tmr_func =3D TMR_ABORT_TASK;
> -		flags |=3D TARGET_SCF_LOOKUP_LUN_FROM_TAG;
> 		break;
> 	case QLA_TGT_2G_ABORT_TASK:
> 		pr_debug("%ld: 2G Abort Task received\n", =
sess->vha->host_no);
> @@ -613,7 +611,7 @@ static int tcm_qla2xxx_handle_tmr(struct =
qla_tgt_mgmt_cmd *mcmd, u64 lun,
> 	}
>=20
> 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
> -	    transl_tmr_func, GFP_ATOMIC, tag, flags);
> +	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
> }
>=20
> static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port =
*sess,
> --=20
> 1.8.3.1
>=20

Once you fix the subject line. Please add my=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

