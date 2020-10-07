Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF2DC47425
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180CA2168B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 13:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yZVs0vd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgJGNyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 09:54:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbgJGNyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 09:54:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DsDZZ014412;
        Wed, 7 Oct 2020 13:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=0aawLROkkCKgLa5VbIIBRkJbFAIu5Tykhs2kHhNlpAE=;
 b=yZVs0vd20KAgUdnBbN6Pj8I8APaZcjt31VIYPoY9+q/kMNUz0B4tgMvkuz0nVt/U+y4D
 zoD5uOLQOUeSJ0sSiibr63Nhyp+qe7nHRUdT50nrK0Iow5ftIXmmcgJELmeD1MzCzqHi
 3ZdFY5jaAzD4lnB+JuY309NL4+Jdz39JgP/b7r1s8Kd2Lin4SgR/h8RIpj9JIZricwFG
 DHTPL8K8ccjBOjUvhrW2PhR2SAPfjTW1DH/vZIGJjbPtiPIIRWxku8UwcmNx1conYFUG
 tJQuYMIoO9Topz1SwlN4rPbEWEVsSV26ddwFnrntrDRh01qyapxiHqIBCzi+SmebYbin 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb21e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 13:54:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097DZXIq180644;
        Wed, 7 Oct 2020 13:54:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vphxfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 13:54:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097DscZ3006304;
        Wed, 7 Oct 2020 13:54:38 GMT
Received: from [192.168.1.26] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 06:54:38 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] qla2xxx: Do not consume srb greedily
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200929073802.18770-1-dwagner@suse.de>
Date:   Wed, 7 Oct 2020 08:54:36 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B442BF5B-8082-46E3-81F4-C78B0AC6B363@oracle.com>
References: <20200929073802.18770-1-dwagner@suse.de>
To:     Daniel Wagner <dwagner@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070090
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 29, 2020, at 2:38 AM, Daniel Wagner <dwagner@suse.de> wrote:
>=20
> qla2xx_process_get_sp_from_handle() will clear the slot which the
> current srb is stored. So this function has a side effect. Therefore,
> we can't use it in qla24xx_process_mbx_iocb_response() to check
> for consistency and later again in qla24xx_mbx_iocb_entry().
>=20
> Let's move the consistency check directly into
> qla24xx_mbx_iocb_entry() and avoid the double call or any open coding
> of the qla2xx_process_get_sp_from_handle() functionality.
>=20
> Fixes: 31a3271ff11b ("scsi: qla2xxx: Handle incorrect entry_type =
entries")
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
>=20
> Brown bag for me please. My test patch had an open coded version of
> qla2xx_process_get_sp_from_handle() which didn't consume the srb. When
> I prepared it for sending it out, I 'cleaned' it up by using
> qla2xx_process_get_sp_from_handle() twice.
>=20
> Sorry,
> Daniel
>=20
> drivers/scsi/qla2xxx/qla_isr.c | 42 =
+++++++++++++++---------------------------
> 1 file changed, 15 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index 96811354f78a..2baba87c4e0c 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1839,6 +1839,7 @@ qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req,
>     struct mbx_24xx_entry *pkt)
> {
> 	const char func[] =3D "MBX-IOCB2";
> +	struct qla_hw_data *ha =3D vha->hw;
> 	srb_t *sp;
> 	struct srb_iocb *si;
> 	u16 sz, i;
> @@ -1848,6 +1849,18 @@ qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req,
> 	if (!sp)
> 		return;
>=20
> +	if (sp->type =3D=3D SRB_SCSI_CMD ||
> +	    sp->type =3D=3D SRB_NVME_CMD ||
> +	    sp->type =3D=3D SRB_TM_CMD) {
> +		ql_log(ql_log_warn, vha, 0x509d,
> +			"Inconsistent event entry type %d\n", sp->type);
> +		if (IS_P3P_TYPE(ha))
> +			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
> +		else
> +			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> +		return;
> +	}
> +
> 	si =3D &sp->u.iocb_cmd;
> 	sz =3D min(ARRAY_SIZE(pkt->mb), =
ARRAY_SIZE(sp->u.iocb_cmd.u.mbx.in_mb));
>=20
> @@ -3406,32 +3419,6 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host =
*vha,
> 	sp->done(sp, comp_status);
> }
>=20
> -static void qla24xx_process_mbx_iocb_response(struct scsi_qla_host =
*vha,
> -	struct rsp_que *rsp, struct sts_entry_24xx *pkt)
> -{
> -	struct qla_hw_data *ha =3D vha->hw;
> -	srb_t *sp;
> -	static const char func[] =3D "MBX-IOCB2";
> -
> -	sp =3D qla2x00_get_sp_from_handle(vha, func, rsp->req, pkt);
> -	if (!sp)
> -		return;
> -
> -	if (sp->type =3D=3D SRB_SCSI_CMD ||
> -	    sp->type =3D=3D SRB_NVME_CMD ||
> -	    sp->type =3D=3D SRB_TM_CMD) {
> -		ql_log(ql_log_warn, vha, 0x509d,
> -			"Inconsistent event entry type %d\n", sp->type);
> -		if (IS_P3P_TYPE(ha))
> -			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
> -		else
> -			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> -		return;
> -	}
> -
> -	qla24xx_mbx_iocb_entry(vha, rsp->req, (struct mbx_24xx_entry =
*)pkt);
> -}
> -
> /**
>  * qla24xx_process_response_queue() - Process response queue entries.
>  * @vha: SCSI driver HA context
> @@ -3539,7 +3526,8 @@ void qla24xx_process_response_queue(struct =
scsi_qla_host *vha,
> 			    (struct abort_entry_24xx *)pkt);
> 			break;
> 		case MBX_IOCB_TYPE:
> -			qla24xx_process_mbx_iocb_response(vha, rsp, =
pkt);
> +			qla24xx_mbx_iocb_entry(vha, rsp->req,
> +			    (struct mbx_24xx_entry *)pkt);
> 			break;
> 		case VP_CTRL_IOCB_TYPE:
> 			qla_ctrlvp_completed(vha, rsp->req,
> --=20
> 2.16.4
>=20

Makes sense :) =20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
--
Himanshu Madhani	 Oracle Linux Engineering

