Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4016C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 20:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA0E20825
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 20:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPFIgcUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgH0UbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 16:31:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0UbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 16:31:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RKTLK5125483;
        Thu, 27 Aug 2020 20:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=dMIkdRRaTmWClqDBKVRa3A+mjyzpBTcrT5uX5NfhxdI=;
 b=YPFIgcUS+wKZIMoV/5spoZaaKelOoYh770p4q5gHwpNaUK9+/wFsjOHe5QIFu5wpjLk/
 gbfDO9DQQ2poPQPtli+GTOzMtGBA27B6Rj8FlgDQTlmev7U8aVLeqlwbngTO5RtDsoU5
 ajUNp9mpzTNhwiNypthXURBfgzux9kvRQMjaRpFHt5AQ7JpdwUObffaT1XuIdY5tkRtP
 8lqEs99hQ3JN0QidND524nGF8f0ew04tPYNkONz0ovIyK/oSDSrRft05YnCg0FAbz/1f
 7JzEl3Dxpb3/LpA656KNTtsEgB5oy/+PGg+zT7xdWL5TNYDQA/CtcQvHJI90sFnGtXd+ mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6u768j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 20:31:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RKUjFh143438;
        Thu, 27 Aug 2020 20:31:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333ru1xex1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 20:31:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RKV0DE001813;
        Thu, 27 Aug 2020 20:31:00 GMT
Received: from dhcp-10-154-191-150.vpn.oracle.com (/10.154.191.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 13:31:00 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3] fix qla2xxx regression on sparc64
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200827.222729.1875148247374704975.rene@exactcode.com>
Date:   Thu, 27 Aug 2020 15:30:58 -0500
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F2E82F86-EEBF-41D8-9C00-73D9D17F9AB5@oracle.com>
References: <20200827.222729.1875148247374704975.rene@exactcode.com>
To:     Rene Rebe <rene@exactcode.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 27, 2020, at 3:27 PM, Rene Rebe <rene@exactcode.com> wrote:
>=20
> Commit 98aee70d19a7e3203649fa2078464e4f402a0ad8 in 2014 broke qla2xxx
> on sparc64, e.g. as in the Sun Blade 1000 / 2000. Unbreak by partial
> revert to fix endianess in nvram firmware default initialization. Also
> mark the second frame_payload_size in nvram_t __le16 to avoid new
> sparse warnings.
>=20
> Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size =
modifier.")
> Signed-off-by: Ren=C3=A9 Rebe <rene@exactcode.de>
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 8c92af5e4390..00782e859ef8 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1626,7 +1626,7 @@ typedef struct {
> 	 */
> 	uint8_t	 firmware_options[2];
>=20
> -	uint16_t frame_payload_size;
> +	__le16	frame_payload_size;
> 	__le16	max_iocb_allocation;
> 	__le16	execution_throttle;
> 	uint8_t	 retry_count;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 57a2d76aa691..0916c33eb076 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4603,18 +4603,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
> 			nv->add_firmware_options[0] =3D BIT_5;
> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
> -			nv->frame_payload_size =3D 2048;
> +			nv->frame_payload_size =3D cpu_to_le16(2048);
> 			nv->special_options[1] =3D BIT_7;
> 		} else if (IS_QLA2200(ha)) {
> 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
> 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
> 			nv->add_firmware_options[0] =3D BIT_5;
> 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
> -			nv->frame_payload_size =3D 1024;
> +			nv->frame_payload_size =3D cpu_to_le16(1024);
> 		} else if (IS_QLA2100(ha)) {
> 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
> 			nv->firmware_options[1] =3D BIT_5;
> -			nv->frame_payload_size =3D 1024;
> +			nv->frame_payload_size =3D cpu_to_le16(1024);
> 		}
>=20
> 		nv->max_iocb_allocation =3D cpu_to_le16(256);
>=20
>=20
> --=20
>  Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 =
Berlin
>  =
https://urldefense.com/v3/__https://exactcode.com__;!!GqivPVa7Brio!OiHyjIc=
eMlSLvY201K45s3J5OfycTE7Z8SH-AOktRAnXCmsreUUnZY8iX7nQVshbmnOO$  | =
https://urldefense.com/v3/__https://t2sde.org__;!!GqivPVa7Brio!OiHyjIceMlS=
LvY201K45s3J5OfycTE7Z8SH-AOktRAnXCmsreUUnZY8iX7nQVlPyHRLL$  | =
https://urldefense.com/v3/__https://rene.rebe.de__;!!GqivPVa7Brio!OiHyjIce=
MlSLvY201K45s3J5OfycTE7Z8SH-AOktRAnXCmsreUUnZY8iX7nQVulmVRVj$=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

