Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34762C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE7120725
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:23:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NzP4JJUb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgJ2UXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:23:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:23:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKF8ZF097604;
        Thu, 29 Oct 2020 20:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=nTUuJowlhZ/FtR4EMTlpfsAnYD62v0+7cBlT9SFipaw=;
 b=NzP4JJUb2tXfB0nx2xY3Tw4rZMppqkw1QFAAKkVQzZ+Yc6c6zRtzlPXJg1XjN+k8kWqA
 ICNwEol17W/OEt8UKL5VWAD6ccJlg2A18RM+XCRBDOa/ZxuYX/OznWi+QMw1iZMa15Ch
 G1wSZsGAtjqCRi/ZY51ygdM+H63nXu4MBBGBdIQZYHQBwWpaE4Dd+dh2OOUCyjEfY3bg
 cG3S80h6fwh0ONLjapE2G+KuRVYkBFFg26hv46mmpf4klDNcT0Bc0JKKE554AQjRJK47
 wwA4kWhxEs/h4a+GcZvcS3+59zLqSuBANaTqZathjbpdG1TgvIncudf6OQUh7fVbspxZ SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7m6v40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:22:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKFQ1V169021;
        Thu, 29 Oct 2020 20:20:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6yw0ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:20:55 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKKsil010588;
        Thu, 29 Oct 2020 20:20:54 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:20:54 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/8] target: fix lun ref count handling
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-2-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:20:52 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A5B2340E-D501-40EA-B814-1C255F9928B3@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-2-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=3
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> This fixes 2 bugs in the lun refcounting.
>=20
> 1. For the TCM_WRITE_PROTECTED case we were returning an error after
> taking a ref to the lun, but never dropping it (caller just send
> status and drops cmd ref).
>=20
> 2. We still need to do a percpu_ref_tryget_live for the virt lun0 like
> we do for other luns, because the tpg code does the refcount/wait
> process like it does with other luns.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/target/target_core_device.c | 43 =
+++++++++++++++++--------------------
> 1 file changed, 20 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/target/target_core_device.c =
b/drivers/target/target_core_device.c
> index 405d82d..1f673fb 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -65,6 +65,16 @@
> 			atomic_long_add(se_cmd->data_length,
> 					&deve->read_bytes);
>=20
> +		if ((se_cmd->data_direction =3D=3D DMA_TO_DEVICE) &&
> +		    deve->lun_access_ro) {
> +			pr_err("TARGET_CORE[%s]: Detected =
WRITE_PROTECTED LUN"
> +				" Access for 0x%08llx\n",
> +				se_cmd->se_tfo->fabric_name,
> +				se_cmd->orig_fe_lun);
> +			rcu_read_unlock();
> +			return TCM_WRITE_PROTECTED;
> +		}
> +
> 		se_lun =3D rcu_dereference(deve->se_lun);
>=20
> 		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
> @@ -76,17 +86,6 @@
> 		se_cmd->pr_res_key =3D deve->pr_res_key;
> 		se_cmd->se_cmd_flags |=3D SCF_SE_LUN_CMD;
> 		se_cmd->lun_ref_active =3D true;
> -
> -		if ((se_cmd->data_direction =3D=3D DMA_TO_DEVICE) &&
> -		    deve->lun_access_ro) {
> -			pr_err("TARGET_CORE[%s]: Detected =
WRITE_PROTECTED LUN"
> -				" Access for 0x%08llx\n",
> -				se_cmd->se_tfo->fabric_name,
> -				se_cmd->orig_fe_lun);
> -			rcu_read_unlock();
> -			ret =3D TCM_WRITE_PROTECTED;
> -			goto ref_dev;
> -		}
> 	}
> out_unlock:
> 	rcu_read_unlock();
> @@ -106,21 +105,20 @@
> 			return TCM_NON_EXISTENT_LUN;
> 		}
>=20
> -		se_lun =3D se_sess->se_tpg->tpg_virt_lun0;
> -		se_cmd->se_lun =3D se_sess->se_tpg->tpg_virt_lun0;
> -		se_cmd->se_cmd_flags |=3D SCF_SE_LUN_CMD;
> -
> -		percpu_ref_get(&se_lun->lun_ref);
> -		se_cmd->lun_ref_active =3D true;
> -
> 		/*
> 		 * Force WRITE PROTECT for virtual LUN 0
> 		 */
> 		if ((se_cmd->data_direction !=3D DMA_FROM_DEVICE) &&
> -		    (se_cmd->data_direction !=3D DMA_NONE)) {
> -			ret =3D TCM_WRITE_PROTECTED;
> -			goto ref_dev;
> -		}
> +		    (se_cmd->data_direction !=3D DMA_NONE))
> +			return TCM_WRITE_PROTECTED;
> +
> +		se_lun =3D se_sess->se_tpg->tpg_virt_lun0;
> +		if (!percpu_ref_tryget_live(&se_lun->lun_ref))
> +			return TCM_NON_EXISTENT_LUN;
> +
> +		se_cmd->se_lun =3D se_sess->se_tpg->tpg_virt_lun0;
> +		se_cmd->se_cmd_flags |=3D SCF_SE_LUN_CMD;
> +		se_cmd->lun_ref_active =3D true;
> 	}
> 	/*
> 	 * RCU reference protected by percpu se_lun->lun_ref taken above =
that
> @@ -128,7 +126,6 @@
> 	 * pointer can be kfree_rcu() by the final se_lun->lun_group put =
via
> 	 * target_core_fabric_configfs.c:target_fabric_port_release
> 	 */
> -ref_dev:
> 	se_cmd->se_dev =3D rcu_dereference_raw(se_lun->lun_se_dev);
> 	atomic_long_inc(&se_cmd->se_dev->num_cmds);
>=20
> --=20
> 1.8.3.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

