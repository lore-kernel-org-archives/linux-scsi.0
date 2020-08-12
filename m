Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986AAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D8920781
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQmH6xAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLTtv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:49:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52322 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:49:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJmBVd073056;
        Wed, 12 Aug 2020 19:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=H0cC+hjK80wjmUZnMp++r0RKpSyQPnNeXEG4DSuMHaM=;
 b=BQmH6xAYr1jpsuOfYOpTyQVRhIw7FdcFeX4Jg1kTv+lhPBohzX95JbHU9WduYopfuT1Z
 wpxyoZVekjJaafNcoyPGYBFUW1Qcx+v1SzGAAG+6cGBmxQlIrG6cpk6GfqEjIELZr48X
 c7T/yBHAvQwk8+FLi93C/OIf0ec0hHuWdooSlOuhGffQTf7ob9N3TqNi+XJUy5FWfZp+
 L9fTLiMCNSeBGv5DiMIBec2Rd/yeLYb0PSUnMt8emlarJCNq2i/d3tTMewS4RvRpVkMF
 WUIRjODIktvY/eBN/gioliE2YLC4hdHKiqQ/RyLzQxVRk3cn4gXvnKj4Jy3QPKkgnDru DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32t2ydu6kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:49:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJmWIg170078;
        Wed, 12 Aug 2020 19:49:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32t60259nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:49:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07CJnhJY017852;
        Wed, 12 Aug 2020 19:49:43 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:49:42 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] scsi: qla2xxx: use MBX_TOV_SECONDS for mailbox command
 timeout values
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200805200546.22497-1-ematsumiya@suse.de>
Date:   Wed, 12 Aug 2020 14:49:42 -0500
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78821939-F52C-4D6F-93BF-A6BAFEF82D52@oracle.com>
References: <20200805200546.22497-1-ematsumiya@suse.de>
To:     Enzo Matsumiya <ematsumiya@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 phishscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2020, at 3:05 PM, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>=20
> Improves readability of qla_mbx.c
>=20
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_mbx.c | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index df31ee0d59b2..b99eed55eb4a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5190,7 +5190,7 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, =
uint32_t risc_addr, uint32_t *data)
> 	mcp->mb[8] =3D MSW(risc_addr);
> 	mcp->out_mb =3D MBX_8|MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_3|MBX_2|MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> 	if (rval !=3D QLA_SUCCESS) {
> @@ -5378,7 +5378,7 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, =
uint32_t risc_addr, uint32_t data)
> 	mcp->mb[8] =3D MSW(risc_addr);
> 	mcp->out_mb =3D MBX_8|MBX_3|MBX_2|MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_1|MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> 	if (rval !=3D QLA_SUCCESS) {
> @@ -5650,7 +5650,7 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, =
uint16_t loop_id, uint16_t priority,
> 	mcp->mb[9] =3D vha->vp_idx;
> 	mcp->out_mb =3D MBX_9|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_4|MBX_3|MBX_1|MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> 	if (mb !=3D NULL) {
> @@ -5737,7 +5737,7 @@ qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
>=20
> 	mcp->out_mb =3D MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
>=20
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> @@ -5772,7 +5772,7 @@ qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
>=20
> 	mcp->out_mb =3D MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
>=20
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> @@ -5964,7 +5964,7 @@ qla81xx_set_led_config(scsi_qla_host_t *vha, =
uint16_t *led_cfg)
> 	if (IS_QLA8031(ha))
> 		mcp->out_mb |=3D MBX_6|MBX_5|MBX_4|MBX_3;
> 	mcp->in_mb =3D MBX_0;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
>=20
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> @@ -6000,7 +6000,7 @@ qla81xx_get_led_config(scsi_qla_host_t *vha, =
uint16_t *led_cfg)
> 	mcp->in_mb =3D MBX_2|MBX_1|MBX_0;
> 	if (IS_QLA8031(ha))
> 		mcp->in_mb |=3D MBX_6|MBX_5|MBX_4|MBX_3;
> -	mcp->tov =3D 30;
> +	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
>=20
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> --=20
> 2.28.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

