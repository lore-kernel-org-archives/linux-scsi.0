Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B48C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CD12087C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:44:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QaLGu5CT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgHLToi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:44:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48410 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgHLToh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:44:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJgLWQ056399;
        Wed, 12 Aug 2020 19:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=IZjX23u6UxxKVeQfX1ZL1aHNoRBLSHFHYPfRBoNhGwg=;
 b=QaLGu5CTP7lWOCMT6XETnvxhf6fTrvU75z/Dp59pgZd74mI1MuoJZf+ICuuK1wCxZiiA
 BapKXZb1JNbonc2jv9GQsl40XGAhbKgI9Pw/24u8Tw2rv6JF7cmvpH2k7vHWJsov2+WY
 t/aHNFUgg74LPXp5hCgcqXnEbAis4ceCVLTbZ0Hz4bET6CL1/6IFPbOA4HLG4WvAVg9g
 NgNeYmAdm5CSGkJNafNgG7ARzRENtMJkQvLvajdDIyRzaHZX4ciP1so8a+plc3IukUsZ
 5CtcXhPU+NPYBW7oUgpVG649zRZRWZSDB7Jnnmbs6JAQDbstCvORfFx1/2yTHGsr/XH2 sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32t2ydu5rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:44:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJhWS5166803;
        Wed, 12 Aug 2020 19:44:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32u3h41uv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:44:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJiXfn032605;
        Wed, 12 Aug 2020 19:44:34 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:44:33 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 05/11] qla2xxx: reduce noisy debug message
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-6-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:44:32 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A6D9078-3BB9-4F9F-B8E4-85A4DCDC52C4@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-6-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=3 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Update debug level and message for ELS IOCB done.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index 27bcd346af7c..ab5275dbc338 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2024,8 +2024,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, =
struct req_que *req,
> 				res =3D DID_ERROR << 16;
> 			}
> 		}
> -		ql_dbg(ql_dbg_user, vha, 0x503f,
> -		    "ELS IOCB Done -%s error hdl=3D%x comp_status=3D0x%x =
error subcode 1=3D0x%x error subcode 2=3D0x%x total_byte=3D0x%x\n",
> +		ql_dbg(ql_dbg_disc, vha, 0x503f,
> +		    "ELS IOCB Done -%s hdl=3D%x comp_status=3D0x%x error =
subcode 1=3D0x%x error subcode 2=3D0x%x total_byte=3D0x%x\n",
> 		    type, sp->handle, comp_status, fw_status[1], =
fw_status[2],
> 		    le32_to_cpu(ese->total_byte_count));
> 		goto els_ct_done;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

