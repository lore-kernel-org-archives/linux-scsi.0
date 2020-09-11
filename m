Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27845C2BC11
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DB5221ED
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vibNFZhH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgIKP7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:59:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgIKP6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 11:58:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BDMQFM156701;
        Fri, 11 Sep 2020 13:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Red1KfmdrafTES2OBbtSFrSu50BYGfLvnMworFNXkMg=;
 b=vibNFZhHQaKI31k2Y2zZKGhK/KffgNBmfqHAktuk1/o5mZv8jr7h8oPcPCSHsBm/rM9X
 jJ1CbNmKtUksgsbOsnEvyyt2A0+QlWwpxMjFyRCXXUYSuJnh3tni6HB9FAX540IyqwWr
 grTbcYhzU7Ggw5QSHkktml2YEP5f8ktzp9X9vtHHKC5AMVhujnCnSRtcp3gL9rhcxD/p
 FKfUm7cg9B5MuTHXqojkIdKhgZL+ziUm3ahoU489EWv/PZbrP5gpDE3PYotwk3QDzTL1
 QZurtR6Eduqgvl7DQBc32P6jLaYuLFn/K3DmzzLdRcI25HZAYY67Bemd2Cz+Sf2kBSPo wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23re7me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 13:23:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BDLBUG053057;
        Fri, 11 Sep 2020 13:23:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmkcy2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 13:23:30 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BDNTnO009072;
        Fri, 11 Sep 2020 13:23:29 GMT
Received: from [192.168.1.18] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 06:23:29 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] scsi: qla2xxx: remove unneeded variable 'rval'
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200911091021.2937708-1-yanaijie@huawei.com>
Date:   Fri, 11 Sep 2020 08:23:28 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        hmadhani@marvell.com, linux-scsi@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF312963-5603-4541-80AF-5266DA0DEBB1@oracle.com>
References: <20200911091021.2937708-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110108
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 11, 2020, at 4:10 AM, Jason Yan <yanaijie@huawei.com> wrote:
>=20
> This addresses the following coccinelle warning:
>=20
> drivers/scsi/qla2xxx/qla_init.c:7112:5-9: Unneeded variable: "rval".
> Return "QLA_SUCCESS" on line 7115
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 0bd04a62af83..df56ac8c3f00 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -7109,10 +7109,9 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
> 	unsigned long flags =3D 0;
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
> -	int rval =3D QLA_SUCCESS;
>=20
> 	if (IS_P3P_TYPE(ha))
> -		return rval;
> +		return QLA_SUCCESS;
>=20
> 	vha->flags.online =3D 0;
> 	ha->isp_ops->disable_intrs(ha);
> @@ -7127,7 +7126,7 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
> 	if (IS_NOPOLLING_TYPE(ha))
> 		ha->isp_ops->enable_intrs(ha);
>=20
> -	return rval;
> +	return QLA_SUCCESS;
> }
>=20
> /* On sparc systems, obtain port and node WWN from firmware
> --=20
> 2.25.4
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

