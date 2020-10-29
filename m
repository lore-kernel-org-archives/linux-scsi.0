Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD8AC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D91C20728
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aOSmZE2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgJ2UZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:25:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgJ2UZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:25:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKOk7K088409;
        Thu, 29 Oct 2020 20:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=cqThcqIbDRLKkXinS6V6I8/gYAgjh5raxeKDSSWwnFM=;
 b=aOSmZE2Svr7VJuLIDBOQc1PzkLhla7bQogp3kUZovV0iaIooVWCiPJIF9pSWvDLPenAw
 6/+qNNdT3fiR8ASy23+/IFJ4cw/AxDtTgtJPtK5xSr02nzq1fvUWv8HTO6sjn6ocJGGJ
 U43zTalgHp4v79a3FNnV4B477wQScz/1qiwE0ZGIoXFc0IUm5MXRqALSDck6jojlBCXm
 poprqLhIItT+qlvdKHzaEHXEHW0CW+RGT2OXcejo0NkleZS/TIsemnbaKqg0wRtYzG0T
 wKT9tRCgjLFMlx1u2otjxqY/C0u8EJxo1gkyUog04ovbUHl9JZhux8LffBxnjgYL10mC iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm4cfxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:25:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKBBk110105;
        Thu, 29 Oct 2020 20:25:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx60x3qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:25:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKP0Be006048;
        Thu, 29 Oct 2020 20:25:00 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:25:00 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 4/8] target: remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-5-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:24:59 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D928056-648C-4DDA-A2E7-CBFE429F7A6D@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-5-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=3 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> TARGET_SCF_LOOKUP_LUN_FROM_TAG is no longer used so remove it.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/target/target_core_transport.c | 33 =
---------------------------------
> include/target/target_core_base.h      |  1 -
> 2 files changed, 34 deletions(-)
>=20
> diff --git a/drivers/target/target_core_transport.c =
b/drivers/target/target_core_transport.c
> index d47619a..465b6583 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1772,29 +1772,6 @@ static void target_complete_tmr_failure(struct =
work_struct *work)
> 	transport_cmd_check_stop_to_fabric(se_cmd);
> }
>=20
> -static bool target_lookup_lun_from_tag(struct se_session *se_sess, =
u64 tag,
> -				       u64 *unpacked_lun)
> -{
> -	struct se_cmd *se_cmd;
> -	unsigned long flags;
> -	bool ret =3D false;
> -
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, =
se_cmd_list) {
> -		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> -			continue;
> -
> -		if (se_cmd->tag =3D=3D tag) {
> -			*unpacked_lun =3D se_cmd->orig_fe_lun;
> -			ret =3D true;
> -			break;
> -		}
> -	}
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> -
> -	return ret;
> -}
> -
> /**
>  * target_submit_tmr - lookup unpacked lun and submit uninitialized =
se_cmd
>  *                     for TMR CDBs
> @@ -1842,16 +1819,6 @@ int target_submit_tmr(struct se_cmd *se_cmd, =
struct se_session *se_sess,
> 		core_tmr_release_req(se_cmd->se_tmr_req);
> 		return ret;
> 	}
> -	/*
> -	 * If this is ABORT_TASK with no explicit fabric provided LUN,
> -	 * go ahead and search active session tags for a match to figure
> -	 * out unpacked_lun for the original se_cmd.
> -	 */
> -	if (tm_type =3D=3D TMR_ABORT_TASK && (flags & =
TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
> -		if (!target_lookup_lun_from_tag(se_sess, tag,
> -						&se_cmd->orig_fe_lun))
> -			goto failure;
> -	}
>=20
> 	ret =3D transport_lookup_tmr_lun(se_cmd);
> 	if (ret)
> diff --git a/include/target/target_core_base.h =
b/include/target/target_core_base.h
> index 549947d..b3c9946 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -195,7 +195,6 @@ enum target_sc_flags_table {
> 	TARGET_SCF_ACK_KREF		=3D 0x02,
> 	TARGET_SCF_UNKNOWN_SIZE		=3D 0x04,
> 	TARGET_SCF_USE_CPUID		=3D 0x08,
> -	TARGET_SCF_LOOKUP_LUN_FROM_TAG	=3D 0x10,
> };
>=20
> /* fabric independent task management function values */
> --=20
> 1.8.3.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

