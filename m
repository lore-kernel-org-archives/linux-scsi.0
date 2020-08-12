Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F01CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E112B20781
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m64Oi6tE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLTqO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:46:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60018 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgHLTqO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:46:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJhOHE115018;
        Wed, 12 Aug 2020 19:46:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Alv6uO6YRvqLMN7fxc/fii8n8nkjmRATGcH3fUdsZQQ=;
 b=m64Oi6tEDCPAbdODq10mO5dzVT/xLzl3C/gyVsV3HJu/ClFLzvARFTRfXM0kPPfof6cm
 88zOkx8Lfhch19jxfhxjtZyQQy6dSKJUAn0uandCCjRlgaqAw4SxWOMg0Y9rLvTpMpc9
 7mRL290IjMm7/2oBGcxLetKSkQtK1u0Y2y4n3nYZ8NSTzW+SxW7FsFvUGntacyifrPmA
 Nxm8grXLUfqQtSliZHKZk1tQAmUAwJ69l22WGvkV+N/AzU+XZlINlpCueMUEbCtnVojE
 YiyKCuu2nr5+mM+A1MEObNERRQLrWPxcpERBbvfK21yUucJvtHdK3RpthUItECXTYcN7 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mvtbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:46:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJhL74109546;
        Wed, 12 Aug 2020 19:46:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32t5y7ppwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:46:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJkADq000975;
        Wed, 12 Aug 2020 19:46:10 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:46:09 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 07/11] qla2xxx: Fix WARN_ON in qla_nvme_register_hba
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-8-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:46:08 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <67EC8249-BC57-4753-862C-924BB433BF83@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-8-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=11 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=11 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> qla_nvme_register_hba puts out a warning when there are not enough
> queue pairs available for FC-NVME.
> Just fail the NVME registration rather than a WARNING + Call Trace.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  1 +
> drivers/scsi/qla2xxx/qla_nvme.c | 10 +++++++++-
> 2 files changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 8c92af5e4390..1bc090d8a71b 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3880,6 +3880,7 @@ struct qla_hw_data {
> 		uint32_t	scm_supported_f:1;
> 				/* Enabled in Driver */
> 		uint32_t	scm_enabled:1;
> +		uint32_t	max_req_queue_warned:1;
> 	} flags;
>=20
> 	uint16_t max_exchg;
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index d66d47a0f958..be1d49f5c622 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -686,7 +686,15 @@ int qla_nvme_register_hba(struct scsi_qla_host =
*vha)
> 	tmpl =3D &qla_nvme_fc_transport;
>=20
> 	WARN_ON(vha->nvme_local_port);
> -	WARN_ON(ha->max_req_queues < 3);
> +
> +	if (ha->max_req_queues < 3) {
> +		if (!ha->flags.max_req_queue_warned)
> +			ql_log(ql_log_info, vha, 0x2120,
> +			       "%s: Disabling FC-NVME due to lack of =
free queue pairs (%d).\n",
> +			       __func__, ha->max_req_queues);
> +		ha->flags.max_req_queue_warned =3D 1;
> +		return ret;
> +	}
>=20
> 	qla_nvme_fc_transport.max_hw_queues =3D
> 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
> --=20
> 2.19.0.rc0
>=20

Makes Sense

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

