Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF153C41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFED208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="stKDT7x0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgJGNgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 09:36:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbgJGNgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 09:36:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DZedN181990;
        Wed, 7 Oct 2020 13:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=qzztbz137uTsx9vqSjB5304pXY2n0tbh024P77RqzFw=;
 b=stKDT7x0W/SxhCNvCHdJSewezI7HAc6cHYGW9Rca/W84/4oSB2MLhbAuZt7VPu5dVb0y
 3sgkkN50Fd4hk3D88/Pt/3N3gPd2s/iNHF+pdN15guxNUUas9EGISMhoKkmJjOK7jQKV
 +7s8iDhG16nQq4sHvowDGvnrBB6wiOdKWR6ZL3B+gEC9wWsWna6Pnum3eBXr17piZSUw
 NkQ21D8KpoHH38+TbNk2J7ndd82sQ/rWn8ul7+6P/aI48UYS6NEPNF6lVDiv5bD8HbH5
 VjyqIanw8aGallb7RUMUrKgnoQJRKqKoQZAHnLurj0DSeZ+MX0HOdms7txe2+SWIT65C Hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn1psv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 13:35:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DZYaB180660;
        Wed, 7 Oct 2020 13:35:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vph8xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 13:35:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097DZg34002242;
        Wed, 7 Oct 2020 13:35:43 GMT
Received: from [192.168.1.26] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 06:35:42 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200919025202.17531-1-miaoqinglang@huawei.com>
Date:   Wed, 7 Oct 2020 08:35:42 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <68C6E741-9A58-4E4E-B746-4E810EA7D651@oracle.com>
References: <20200919025202.17531-1-miaoqinglang@huawei.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 18, 2020, at 9:52 PM, Qinglang Miao <miaoqinglang@huawei.com> =
wrote:
>=20
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>=20
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
> v2: based on linux-next(20200917), and can be applied to
>    mainline cleanly now.
>=20
> drivers/scsi/qla2xxx/qla_dfs.c | 68 ++++------------------------------
> 1 file changed, 8 insertions(+), 60 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index e62b21152..9e49b47f6 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -37,20 +37,7 @@ qla2x00_dfs_tgt_sess_show(struct seq_file *s, void =
*unused)
> 	return 0;
> }
>=20
> -static int
> -qla2x00_dfs_tgt_sess_open(struct inode *inode, struct file *file)
> -{
> -	scsi_qla_host_t *vha =3D inode->i_private;
> -
> -	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
> -}
> -
> -static const struct file_operations dfs_tgt_sess_ops =3D {
> -	.open		=3D qla2x00_dfs_tgt_sess_open,
> -	.read		=3D seq_read,
> -	.llseek		=3D seq_lseek,
> -	.release	=3D single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(qla2x00_dfs_tgt_sess);
>=20
> static int
> qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
> @@ -106,20 +93,7 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file =
*s, void *unused)
> 	return 0;
> }
>=20
> -static int
> -qla2x00_dfs_tgt_port_database_open(struct inode *inode, struct file =
*file)
> -{
> -	scsi_qla_host_t *vha =3D inode->i_private;
> -
> -	return single_open(file, qla2x00_dfs_tgt_port_database_show, =
vha);
> -}
> -
> -static const struct file_operations dfs_tgt_port_database_ops =3D {
> -	.open		=3D qla2x00_dfs_tgt_port_database_open,
> -	.read		=3D seq_read,
> -	.llseek		=3D seq_lseek,
> -	.release	=3D single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(qla2x00_dfs_tgt_port_database);
>=20
> static int
> qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
> @@ -154,20 +128,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, =
void *unused)
> 	return 0;
> }
>=20
> -static int
> -qla_dfs_fw_resource_cnt_open(struct inode *inode, struct file *file)
> -{
> -	struct scsi_qla_host *vha =3D inode->i_private;
> -
> -	return single_open(file, qla_dfs_fw_resource_cnt_show, vha);
> -}
> -
> -static const struct file_operations dfs_fw_resource_cnt_ops =3D {
> -	.open           =3D qla_dfs_fw_resource_cnt_open,
> -	.read           =3D seq_read,
> -	.llseek         =3D seq_lseek,
> -	.release        =3D single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(qla_dfs_fw_resource_cnt);
>=20
> static int
> qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
> @@ -244,20 +205,7 @@ qla_dfs_tgt_counters_show(struct seq_file *s, =
void *unused)
> 	return 0;
> }
>=20
> -static int
> -qla_dfs_tgt_counters_open(struct inode *inode, struct file *file)
> -{
> -	struct scsi_qla_host *vha =3D inode->i_private;
> -
> -	return single_open(file, qla_dfs_tgt_counters_show, vha);
> -}
> -
> -static const struct file_operations dfs_tgt_counters_ops =3D {
> -	.open           =3D qla_dfs_tgt_counters_open,
> -	.read           =3D seq_read,
> -	.llseek         =3D seq_lseek,
> -	.release        =3D single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(qla_dfs_tgt_counters);
>=20
> static int
> qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
> @@ -459,19 +407,19 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
>=20
> create_nodes:
> 	ha->dfs_fw_resource_cnt =3D =
debugfs_create_file("fw_resource_count",
> -	    S_IRUSR, ha->dfs_dir, vha, &dfs_fw_resource_cnt_ops);
> +	    S_IRUSR, ha->dfs_dir, vha, &qla_dfs_fw_resource_cnt_fops);
>=20
> 	ha->dfs_tgt_counters =3D debugfs_create_file("tgt_counters", =
S_IRUSR,
> -	    ha->dfs_dir, vha, &dfs_tgt_counters_ops);
> +	    ha->dfs_dir, vha, &qla_dfs_tgt_counters_fops);
>=20
> 	ha->tgt.dfs_tgt_port_database =3D =
debugfs_create_file("tgt_port_database",
> -	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
> +	    S_IRUSR,  ha->dfs_dir, vha, =
&qla2x00_dfs_tgt_port_database_fops);
>=20
> 	ha->dfs_fce =3D debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, =
vha,
> 	    &dfs_fce_ops);
>=20
> 	ha->tgt.dfs_tgt_sess =3D debugfs_create_file("tgt_sess",
> -		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
> +		S_IRUSR, ha->dfs_dir, vha, &qla2x00_dfs_tgt_sess_fops);
>=20
> 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
> 		ha->tgt.dfs_naqp =3D debugfs_create_file("naqp",
> --=20
> 2.23.0
>=20

Nice cleanup.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

