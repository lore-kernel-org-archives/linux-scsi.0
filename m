Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B17C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A8B214F1
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+bPqu2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgIBPgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:36:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgIBPgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:36:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FZeoI019928;
        Wed, 2 Sep 2020 15:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=NaCsitATn3dHFJxJO6J5m4LAPnsKt0YCGXY6d923Tqc=;
 b=O+bPqu2gDBF2L6ggS+QNimGtIVDTZ5xxwqQ7ZfdzllRYYgw4pAR/4cg/Oi6V9LrLPwvt
 vueBGjXhCvDXewQ0aTcq55EmBYu+wtDaPLBbjjNagYD74XvhOUWNEOUQrVIFTaush+d4
 xIlcTcsEEQOcVmROjmEUy6vqJsaelBwRn8PIkTJ4nKPcythlCg2izKMyJRPRaZEeT2Fu
 AStTPkGFzlXyZkIfYQexWhr6ucB35A5vEb6oDjSQ1GuCi6SKf9Y2Mz2MXNtmv1+Mqo+0
 AlTNpN6YpqjZ9JMe4m3/XFhnGezwN2+M16FSYSJ10J4P7JHZhgaakPeOQAHSpASoHLkX KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn1swh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:36:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FZEO7142021;
        Wed, 2 Sep 2020 15:36:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kq6gyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:36:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082FaD23028105;
        Wed, 2 Sep 2020 15:36:14 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:36:13 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 04/13] qla2xxx: Honor status qualifier in FCP_RSP per
 spec
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-5-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:36:13 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BC1EA634-E943-4C28-8B1C-3ACC83CD5795@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-5-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=3 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=3
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> FCP-4 (referred FCP-4 rev-2b) identifies the earlier known "retry =
delay
> timer" field as "status qualifier", which is described in SAM-5 and
> later specs. This fix makes appropriate driver side modifications to
> honor the new definition. The SAM document referred was SAM-6 rev-5.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_fw.h     |  2 +-
> drivers/scsi/qla2xxx/qla_inline.h | 38 +++++++++++++++++++++++++++----
> drivers/scsi/qla2xxx/qla_isr.c    | 18 ++++-----------
> 3 files changed, 40 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h =
b/drivers/scsi/qla2xxx/qla_fw.h
> index bba1b77fba7e..f0052d75849c 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -619,7 +619,7 @@ struct sts_entry_24xx {
> #define SF_NVME_ERSP            BIT_6
> #define SF_FCP_RSP_DMA		BIT_0
>=20
> -	__le16	retry_delay;
> +	__le16	status_qualifier;
> 	__le16	scsi_status;		/* SCSI status. */
> #define SS_CONFIRMATION_REQ		BIT_12
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h =
b/drivers/scsi/qla2xxx/qla_inline.h
> index 861dc522723c..5501b4c581ec 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -266,11 +266,41 @@ qla2x00_handle_mbx_completion(struct qla_hw_data =
*ha, int status)
> }
>=20
> static inline void
> -qla2x00_set_retry_delay_timestamp(fc_port_t *fcport, uint16_t =
retry_delay)
> +qla2x00_set_retry_delay_timestamp(fc_port_t *fcport, uint16_t =
sts_qual)
> {
> -	if (retry_delay)
> -		fcport->retry_delay_timestamp =3D jiffies +
> -		    (retry_delay * HZ / 10);
> +	u8 scope;
> +	u16 qual;
> +#define SQ_SCOPE_MASK		0xc000 /* SAM-6 rev5 5.3.2 */
> +#define SQ_SCOPE_SHIFT		14
> +#define SQ_QUAL_MASK		0x3fff
> +
> +#define SQ_MAX_WAIT_SEC		60 /* Max I/O hold off time in =
seconds. */
> +#define SQ_MAX_WAIT_TIME	(SQ_MAX_WAIT_SEC * 10) /* in 100ms. */
> +
> +	if (!sts_qual) /* Common case. */
> +		return;
> +
> +	scope =3D (sts_qual & SQ_SCOPE_MASK) >> SQ_SCOPE_SHIFT;
> +	/* Handle only scope 1 or 2, which is for I-T nexus. */
> +	if (scope !=3D 1 && scope !=3D 2)
> +		return;
> +
> +	/* Skip processing, if retry delay timer is already in effect. =
*/
> +	if (fcport->retry_delay_timestamp &&
> +	    time_before(jiffies, fcport->retry_delay_timestamp))
> +		return;
> +
> +	qual =3D sts_qual & SQ_QUAL_MASK;
> +	if (qual < 1 || qual > 0x3fef)
> +		return;
> +	qual =3D min(qual, (u16)SQ_MAX_WAIT_TIME);
> +
> +	/* qual is expressed in 100ms increments. */
> +	fcport->retry_delay_timestamp =3D jiffies + (qual * HZ / 10);
> +
> +	ql_log(ql_log_warn, fcport->vha, 0x5101,
> +	       "%8phC: I/O throttling requested (status qualifier =3D =
%04xh), holding off I/Os for %ums.\n",
> +	       fcport->port_name, sts_qual, qual * 100);
> }
>=20
> static inline bool
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index ab5275dbc338..d38dd6520b53 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2855,7 +2855,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 	int logit =3D 1;
> 	int res =3D 0;
> 	uint16_t state_flags =3D 0;
> -	uint16_t retry_delay =3D 0;
> +	uint16_t sts_qual =3D 0;
>=20
> 	if (IS_FWI2_CAPABLE(ha)) {
> 		comp_status =3D le16_to_cpu(sts24->comp_status);
> @@ -2953,8 +2953,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 	sense_len =3D par_sense_len =3D rsp_info_len =3D resid_len =3D
> 	    fw_resid_len =3D 0;
> 	if (IS_FWI2_CAPABLE(ha)) {
> -		u16 sts24_retry_delay =3D =
le16_to_cpu(sts24->retry_delay);
> -
> 		if (scsi_status & SS_SENSE_LEN_VALID)
> 			sense_len =3D le32_to_cpu(sts24->sense_len);
> 		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
> @@ -2968,13 +2966,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
> 		ox_id =3D le16_to_cpu(sts24->ox_id);
> 		par_sense_len =3D sizeof(sts24->data);
> -		/* Valid values of the retry delay timer are 0x1-0xffef =
*/
> -		if (sts24_retry_delay > 0 && sts24_retry_delay < 0xfff1) =
{
> -			retry_delay =3D sts24_retry_delay & 0x3fff;
> -			ql_dbg(ql_dbg_io, sp->vha, 0x3033,
> -			    "%s: scope=3D%#x retry_delay=3D%#x\n", =
__func__,
> -			    sts24_retry_delay >> 14, retry_delay);
> -		}
> +		sts_qual =3D le16_to_cpu(sts24->status_qualifier);
> 	} else {
> 		if (scsi_status & SS_SENSE_LEN_VALID)
> 			sense_len =3D =
le16_to_cpu(sts->req_sense_length);
> @@ -3012,9 +3004,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 	 * Check retry_delay_timer value if we receive a busy or
> 	 * queue full.
> 	 */
> -	if (lscsi_status =3D=3D SAM_STAT_TASK_SET_FULL ||
> -	    lscsi_status =3D=3D SAM_STAT_BUSY)
> -		qla2x00_set_retry_delay_timestamp(fcport, retry_delay);
> +	if (unlikely(lscsi_status =3D=3D SAM_STAT_TASK_SET_FULL ||
> +		     lscsi_status =3D=3D SAM_STAT_BUSY))
> +		qla2x00_set_retry_delay_timestamp(fcport, sts_qual);
>=20
> 	/*
> 	 * Based on Host and scsi status generate status code for Linux
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

