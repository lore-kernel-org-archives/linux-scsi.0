Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCB5C2BBD0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1125120678
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MCMzkrli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIBPfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:35:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgIBPfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:35:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FYwxp089320;
        Wed, 2 Sep 2020 15:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=myRg0eqVKQyenXybhty7ky8DK2ncQbSGm+UIlN6pU1o=;
 b=MCMzkrlig42tAS7dtw8V9wJ/+tyKazntBSkLU+PYd2FDEkHVJ98WZLFv0aDT6XGQjDEC
 +Q3W+fyYkGQJxAlAFuTmeRnPes71fcdDpi2t0ElJo4Zs6rQOnEacL6UNawwZpnlMYI5V
 1OtirzX7QEab26iqztrSyh39xJpUJ8ho4x3lz7YQp++JGtej9UR8NiAeCkna3zhHRJ6z
 LACzFhoMcR+sywIxs3yvFigjOJmkg3rFdUvWbWLJqVvlso0oEr9bwrGrCrLRcJFcuAGi
 837AUXb9g7oxEemc9hn6yTXE+VeIznPvsg26ZTygJhR7x/bzyuykN5yCsl4BS2iNAmfs HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eer3c37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:35:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FZ5h4172425;
        Wed, 2 Sep 2020 15:35:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380su557a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:35:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082FZGiC029459;
        Wed, 2 Sep 2020 15:35:16 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:35:16 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 03/13] qla2xxx: Allow dev_loss_tmo setting for FC-NVMe
 devices
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-4-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:35:15 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <610EB2F9-0263-4D29-9989-03237EBAEF03@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-4-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Add a remote port debugfs entry to get/set dev_loss_tmo for NVMe
> devices.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
> drivers/scsi/qla2xxx/qla_dfs.c | 58 ++++++++++++++++++++++++++++++++++
> 1 file changed, 58 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index 3c4b9b549b17..616ce891818d 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -12,6 +12,61 @@
> static struct dentry *qla2x00_dfs_root;
> static atomic_t qla2x00_dfs_root_count;
>=20
> +#define QLA_DFS_RPORT_DEVLOSS_TMO	1
> +
> +static int
> +qla_dfs_rport_get(struct fc_port *fp, int attr_id, u64 *val)
> +{
> +	switch (attr_id) {
> +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> +		/* Only supported for FC-NVMe devices that are =
registered. */
> +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> +			return -EIO;
> +		*val =3D fp->nvme_remote_port->dev_loss_tmo;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int
> +qla_dfs_rport_set(struct fc_port *fp, int attr_id, u64 val)
> +{
> +	switch (attr_id) {
> +	case QLA_DFS_RPORT_DEVLOSS_TMO:
> +		/* Only supported for FC-NVMe devices that are =
registered. */
> +		if (!(fp->nvme_flag & NVME_FLAG_REGISTERED))
> +			return -EIO;
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +		return =
nvme_fc_set_remoteport_devloss(fp->nvme_remote_port,
> +						      val);
> +#else /* CONFIG_NVME_FC */
> +		return -EINVAL;
> +#endif /* CONFIG_NVME_FC */
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +#define DEFINE_QLA_DFS_RPORT_RW_ATTR(_attr_id, _attr)		=
\
> +static int qla_dfs_rport_##_attr##_get(void *data, u64 *val)	\
> +{								\
> +	struct fc_port *fp =3D data;				\
> +	return qla_dfs_rport_get(fp, _attr_id, val);		\
> +}								\
> +static int qla_dfs_rport_##_attr##_set(void *data, u64 val)	\
> +{								\
> +	struct fc_port *fp =3D data;				\
> +	return qla_dfs_rport_set(fp, _attr_id, val);		\
> +}								\
> +DEFINE_DEBUGFS_ATTRIBUTE(qla_dfs_rport_##_attr##_fops,		=
\
> +		qla_dfs_rport_##_attr##_get,			\
> +		qla_dfs_rport_##_attr##_set, "%llu\n")
> +
> +DEFINE_QLA_DFS_RPORT_RW_ATTR(QLA_DFS_RPORT_DEVLOSS_TMO, =
dev_loss_tmo);
> +
> void
> qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp)
> {
> @@ -24,6 +79,9 @@ qla2x00_dfs_create_rport(scsi_qla_host_t *vha, =
struct fc_port *fp)
> 	fp->dfs_rport_dir =3D debugfs_create_dir(wwn, =
vha->dfs_rport_root);
> 	if (!fp->dfs_rport_dir)
> 		return;
> +	if (NVME_TARGET(vha->hw, fp))
> +		debugfs_create_file("dev_loss_tmo", 0600, =
fp->dfs_rport_dir,
> +				    fp, =
&qla_dfs_rport_dev_loss_tmo_fops);
> }
>=20
> void
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

