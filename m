Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C78C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C9F208C3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r3Q+1zrd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404019AbgLAQDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:03:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57932 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388988AbgLAQDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:03:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FtbXs070025;
        Tue, 1 Dec 2020 16:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=g7wZWUjiAwtslkfsb7ZLNU8nnXRxaujbc+9USd3QZ2U=;
 b=r3Q+1zrdJiNBceghCQhd7bXZOiwumtY60qrm4hqZ6nkW9d5F+lc5JMUScTFlPKee0SC9
 F5kCQUl8gyBRK2tW1lU0RdI0/rgo6knmizvtNSgB/KyXEbDcUh7fRrTwZONccTthMwdt
 xkEqXfWt9eIYIfVJgtC/7kX27XcTTvBiUVCg7gn2SRwquWWJwDyDRDmL49sfsnXV3xkC
 665AOXVn8RHZZdmThWBqXGopVOQrKi6jo/Dl1nU8dt8nkcL2Suev06xflEBSUM15Tnmh
 ECbeUyzBMhqc+eSyTrFgPowuSPbLzm++R4LlJb0Fs9kk6kSKYHNYhNbwzO+Nyn8WhLkl gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqkc7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:02:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FtJlR098205;
        Tue, 1 Dec 2020 16:02:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540fx5nvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:02:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1G2SfJ023224;
        Tue, 1 Dec 2020 16:02:29 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:02:28 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 08/15] qla2xxx: Fix FW initialization error on big endian
 machines
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-9-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:02:26 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <42EEC2BC-8DB9-4E32-B91A-F529E118C4FB@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-9-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Some fields are not correctly byte swapped causing failure
> during initialization. As probe() returns failure, HBAs
> will not be claimed when this happens.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

I think this patch needs following fixes tag

Fixes: 9f2475fe7406b ("scsi: qla2xxx: SAN congestion management =
implementation")
Fixes: cf3c54fb49a4e ("scsi: qla2xxx: Add SLER and PI control =
support=E2=80=9D)

> ---
> drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index 40af7f1524ce..1b4261c3c476 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1129,7 +1129,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
> 		if (ha->flags.scm_supported_a &&
> 		    (ha->fw_attributes_ext[0] & =
FW_ATTR_EXT0_SCM_SUPPORTED)) {
> 			ha->flags.scm_supported_f =3D 1;
> -			ha->sf_init_cb->flags |=3D BIT_13;
> +			ha->sf_init_cb->flags |=3D cpu_to_le16(BIT_13);
> 		}
> 		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
> 		       (ha->flags.scm_supported_f) ? "Supported" :
> @@ -1137,9 +1137,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
>=20
> 		if (vha->flags.nvme2_enabled) {
> 			/* set BIT_15 of special feature control block =
for SLER */
> -			ha->sf_init_cb->flags |=3D BIT_15;
> +			ha->sf_init_cb->flags |=3D cpu_to_le16(BIT_15);
> 			/* set BIT_14 of special feature control block =
for PI CTRL*/
> -			ha->sf_init_cb->flags |=3D BIT_14;
> +			ha->sf_init_cb->flags |=3D cpu_to_le16(BIT_14);
> 		}
> 	}
>=20
> --=20
> 2.19.0.rc0
>=20

Otherwise, Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

