Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C1FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0DD206DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zx6YrzI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHLTnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:43:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:43:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJgccf017213;
        Wed, 12 Aug 2020 19:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=HyeZzXX4/1x0gomaRUAv/Nps13DQUCxi6dGzF6qZtLQ=;
 b=Zx6YrzI08RK/DJ/FRbTQriTXR6cZPPOPeDnWYA5aZ8qQ6AOKZPJiRbVA1xDs74fJ6TNa
 8PYluQBDW/HXasAEw9RSqAqU0+uCh6W9DqUzFPEb/iv4D3c1oNQaFvKQwWAAZqxAtoTr
 reEgd9bUh01UyJJzgIvMAkWsg3AgUb4+DfyDMsrQF+F210qlBluRJUgfOad4wdEyjqAP
 IkKr4J86cN6n+OKShva++xDyiuWBr9MuwpML5b4o5bYCY3RFC74o1F/WJF5XClPH7Sju
 Vk7qzMVEbcmzDiWFwXTJN1MFgdPoGKKonozCZcX+95kg5NDj8I3Mf3Otjm/58ZCD8exL nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32smpnmrq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:43:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJWWww110263;
        Wed, 12 Aug 2020 19:43:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32t6025148-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:43:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJhlbM000379;
        Wed, 12 Aug 2020 19:43:47 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:43:47 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 06/11] qla2xxx: Allow ql2xextended_error_logging
 special value 1 to be set anytime
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-7-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:43:46 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <68129E90-57AC-4912-A960-801BF5F3C7C8@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-7-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=3 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> ql2xextended_error_logging could now be set anytime to 1 to get the =
default
> mask value, as opposed to load time only.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.h | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h =
b/drivers/scsi/qla2xxx/qla_dbg.h
> index 91eb6901815c..e1d7de63e8f8 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -380,5 +380,8 @@ extern int qla24xx_soft_reset(struct qla_hw_data =
*);
> static inline int
> ql_mask_match(uint level)
> {
> +	if (ql2xextended_error_logging =3D=3D 1)
> +		ql2xextended_error_logging =3D QL_DBG_DEFAULT1_MASK;
> +
> 	return (level & ql2xextended_error_logging) =3D=3D level;
> }
> --=20
> 2.19.0.rc0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

