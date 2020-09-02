Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B2DC433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E30C20767
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bpWeB964"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgIBPd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:33:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgIBPdX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:33:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FUMcE174493;
        Wed, 2 Sep 2020 15:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=uhxdXiUtXG2qBj5Sfwde7Ug93nby6LvyWCTFZJOo7u8=;
 b=bpWeB964p8R96Ci5We69TVjbfAyL6UZTCPxGm4Dgb7Pw/HTkV96ESbAnHSNhxQfWZ4wz
 Mvq7Jij1xhRNPsRHpkZZWA+fFUz9ueTl4qsg5uEk7oFzcK5Og76WU2Tu2TSPFBUwIcc7
 vNzh+T3BOhVJGKgBdv/dXU/btWN61fF+a01eqgczeQ6VfJbTqeu4DvBOVOA7vpJzyHN+
 GHfeNU/8PATD2CH7miad2NKgYNWX7EbNPuxjfrkuCRYxrfBCvg8wildJqIDNrqwupMlk
 tp0CoGu1v9H31Wz1v3itqV1sG8rkNvlYVhwiNtcxrieZ9CLSytX74T4MUQqkVyzs+dqE kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eymb99p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:33:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FPJht143943;
        Wed, 2 Sep 2020 15:33:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380su52fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:33:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FXJ89003562;
        Wed, 2 Sep 2020 15:33:19 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:33:18 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 01/13] qla2xxx: Fix I/O failures during remote port
 toggle testing
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-2-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:33:18 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <D0FF3BEA-57AE-4FB6-84DA-517BBA68CB9C@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-2-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020147
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Driver was using a lower value for dev_loss_tmo making it more prone =
to
> I/O failures during remote port toggle testing. Set dev_loss_tmo to =
zero
> during remote port registration to allow nvme-fc default dev_loss_tmo =
to
> be used, which is higher than what driver was using.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> drivers/scsi/qla2xxx/qla_nvme.h | 3 ---
> 2 files changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0ded9a778bb0..b05e4545ef5f 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -42,7 +42,7 @@ int qla_nvme_register_remote(struct scsi_qla_host =
*vha, struct fc_port *fcport)
> 	req.port_name =3D wwn_to_u64(fcport->port_name);
> 	req.node_name =3D wwn_to_u64(fcport->node_name);
> 	req.port_role =3D 0;
> -	req.dev_loss_tmo =3D NVME_FC_DEV_LOSS_TMO;
> +	req.dev_loss_tmo =3D 0;
>=20
> 	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_INITIATOR)
> 		req.port_role =3D FC_PORT_ROLE_NVME_INITIATOR;
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h =
b/drivers/scsi/qla2xxx/qla_nvme.h
> index fbb844226630..cf45a5b277f1 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.h
> +++ b/drivers/scsi/qla2xxx/qla_nvme.h
> @@ -14,9 +14,6 @@
> #include "qla_def.h"
> #include "qla_dsd.h"
>=20
> -/* default dev loss time (seconds) before transport tears down ctrl =
*/
> -#define NVME_FC_DEV_LOSS_TMO  30
> -
> #define NVME_ATIO_CMD_OFF 32
> #define NVME_FIRST_PACKET_CMDLEN (64 - NVME_ATIO_CMD_OFF)
> #define Q2T_NVME_NUM_TAGS 2048
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

