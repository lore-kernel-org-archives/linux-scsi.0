Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7491C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB149207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r8h3urfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgIBPeT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:34:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36898 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgIBPeR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:34:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FT8ZZ083366;
        Wed, 2 Sep 2020 15:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dY14se8FksUWkfQ+VaclhhbA9SRTDKTjK0P+Yp2prcU=;
 b=r8h3urfOOw2N4PUR6GYgbstlb4mUXHp6ZaoKMVtCA4WP2DX3O4DVbReduAtB41NAVtQC
 nYGBMCw4SdI89mkAWprEsCTOt7naInZ66q6S1mQbwK/tdqNyl5la3ObaHimuOjYau/9i
 EBOBfXBZhcaxP0ucixFJ/MPJtIrdvaFJaibHLZePvzRBy9WwHAStEQjN3EScVRjSZgG6
 8NzZ6AIW9C7aoaFoidEm7Lswz5gwpOTML4nD8WyimoqSrLDBHxUM9+GM818jGihM7ABh
 /PdcbgUM94BxAxDLSxYFmutXmWDPJgRxvrj9pXDpvl2cBfl5DP2sTJCGVkymyJVLzTCz Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eer3bvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:34:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FPGHq143516;
        Wed, 2 Sep 2020 15:34:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380su53rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:34:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FYDuO004069;
        Wed, 2 Sep 2020 15:34:13 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:34:13 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 02/13] qla2xxx: Setup debugfs entries for remote ports
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-3-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:34:12 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <01941EA3-8276-4766-AC8A-5EF5A7A056EF@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-3-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=11 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=11
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020147
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Create a base for adding remote port related entries in debugfs.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h    |  4 +++
> drivers/scsi/qla2xxx/qla_dfs.c    | 42 ++++++++++++++++++++++++++++++-
> drivers/scsi/qla2xxx/qla_gbl.h    |  2 ++
> drivers/scsi/qla2xxx/qla_init.c   |  2 ++
> drivers/scsi/qla2xxx/qla_target.c |  2 ++
> 5 files changed, 51 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 1bc090d8a71b..074d8753cfc3 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2544,6 +2544,8 @@ typedef struct fc_port {
> 	u8 last_login_state;
> 	u16 n2n_link_reset_cnt;
> 	u16 n2n_chip_reset;
> +
> +	struct dentry *dfs_rport_dir;
> } fc_port_t;
>=20
> enum {
> @@ -4780,6 +4782,8 @@ typedef struct scsi_qla_host {
> 	uint16_t ql2xexchoffld;
> 	uint16_t ql2xiniexchg;
>=20
> +	struct dentry *dfs_rport_root;
> +
> 	struct purex_list {
> 		struct list_head head;
> 		spinlock_t lock;
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index e62b2115235e..3c4b9b549b17 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -12,6 +12,29 @@
> static struct dentry *qla2x00_dfs_root;
> static atomic_t qla2x00_dfs_root_count;
>=20
> +void
> +qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
> +{
> +	char wwn[32];
> +
> +	if (!vha->dfs_rport_root || fp->dfs_rport_dir)
> +		return;
> +
> +	sprintf(wwn, "pn-%016llx", wwn_to_u64(fp->port_name));
> +	fp->dfs_rport_dir =3D debugfs_create_dir(wwn, =
vha->dfs_rport_root);
> +	if (!fp->dfs_rport_dir)
> +		return;
> +}
> +
> +void
> +qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp)
> +{
> +	if (!vha->dfs_rport_root || !fp->dfs_rport_dir)
> +		return;
> +	debugfs_remove_recursive(fp->dfs_rport_dir);
> +	fp->dfs_rport_dir =3D NULL;
> +}
> +
> static int
> qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
> {
> @@ -473,9 +496,21 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
> 	ha->tgt.dfs_tgt_sess =3D debugfs_create_file("tgt_sess",
> 		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
>=20
> -	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
> +	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
> 		ha->tgt.dfs_naqp =3D debugfs_create_file("naqp",
> 		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
> +		if (!ha->tgt.dfs_naqp) {
> +			ql_log(ql_log_warn, vha, 0xd011,
> +			       "Unable to create debugFS naqp node.\n");
> +			goto out;
> +		}
> +	}
> +	vha->dfs_rport_root =3D debugfs_create_dir("rports", =
ha->dfs_dir);
> +	if (!vha->dfs_rport_root) {
> +		ql_log(ql_log_warn, vha, 0xd012,
> +		       "Unable to create debugFS rports node.\n");
> +		goto out;
> +	}
> out:
> 	return 0;
> }
> @@ -515,6 +550,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
> 		ha->dfs_fce =3D NULL;
> 	}
>=20
> +	if (vha->dfs_rport_root) {
> +		debugfs_remove_recursive(vha->dfs_rport_root);
> +		vha->dfs_rport_root =3D NULL;
> +	}
> +
> 	if (ha->dfs_dir) {
> 		debugfs_remove(ha->dfs_dir);
> 		ha->dfs_dir =3D NULL;
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h =
b/drivers/scsi/qla2xxx/qla_gbl.h
> index 0ced18f3104e..36c210c24f72 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -935,6 +935,8 @@ void qlt_clr_qp_table(struct scsi_qla_host *vha);
> void qlt_set_mode(struct scsi_qla_host *);
> int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
> extern void qla24xx_process_purex_list(struct purex_list *);
> +extern void qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct =
fc_port *fp);
> +extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct =
fc_port *fp);
>=20
> /* nvme.c */
> void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 57a2d76aa691..b4d53eb4e53e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5486,6 +5486,8 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, =
fc_port_t *fcport)
>=20
> 	qla2x00_iidma_fcport(vha, fcport);
>=20
> +	qla2x00_dfs_create_rport(vha, fcport);
> +
> 	if (NVME_TARGET(vha->hw, fcport)) {
> 		qla_nvme_register_remote(vha, fcport);
> 		qla2x00_set_fcport_disc_state(fcport, =
DSC_LOGIN_COMPLETE);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c =
b/drivers/scsi/qla2xxx/qla_target.c
> index 1237d952973d..e28a977b0770 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1111,6 +1111,8 @@ void qlt_free_session_done(struct work_struct =
*work)
> 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> 	sess->free_pending =3D 0;
>=20
> +	qla2x00_dfs_remove_rport(vha, sess);
> +
> 	ql_dbg(ql_dbg_disc, vha, 0xf001,
> 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
> 		sess, sess->port_name, vha->fcport_count);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

