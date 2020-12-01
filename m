Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8220DC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023182151B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 15:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u+8wpnuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbgLAPra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:47:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39342 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388237AbgLAPra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 10:47:30 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FYweE195314;
        Tue, 1 Dec 2020 15:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=AQH+8d9d0LlW2Qi8jXlFVLbgWsicOMxeSFGWjBvIpDM=;
 b=u+8wpnuAerFVQ2QgId/VNPudjWlWyGduEbsZAJCKbO9Hc+B6Q+08yb7gaWwuS53uwCjs
 qEpCIi/wm+RVdBgffnyyY/NXtMLpYAwoy1Xjo5wGNBjXN7bGJ7It6zD2EPuXDXJuecNh
 VqHOoZcU6IgVQUmPKSr8V8lgScLLiJU/e6DMWIiZZZp4I3qc1gJxAF/LJDRiH0RytZ4u
 sbl76Uqlbwl2YWbx+SBVj7g7Du+XsZ97L/jBNg7Lgz6uyqc/8+DxaT2VgHSFyIBg6xCA
 yIHHQbVinC1OX9W5wf3xNbidRYF0nMB1/2Jqbws5BKzB85x/GDkFQOVfErbNeYtVb1KJ qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2aucg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:46:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FUIrT113585;
        Tue, 1 Dec 2020 15:46:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540ashrp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:46:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1FkjE1006870;
        Tue, 1 Dec 2020 15:46:45 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:46:45 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 03/15] qla2xxx: limit interrupt vectors to number of cpu
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-4-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 09:46:42 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B38F8D3A-9C5A-462A-BA42-E9798FA5AD13@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-4-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Driver created too many QPairs(126) with 28xx adapter.
> Limit the number of CPUs to lower wasted resources.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index a24b82de4aab..77dd7630c3f8 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3952,10 +3952,12 @@ qla24xx_enable_msix(struct qla_hw_data *ha, =
struct rsp_que *rsp)
> 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
> 		/* user wants to control IRQ setting for target mode */
> 		ret =3D pci_alloc_irq_vectors(ha->pdev, min_vecs,
> -		    ha->msix_count, PCI_IRQ_MSIX);
> +		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> +		    PCI_IRQ_MSIX);
> 	} else
> 		ret =3D pci_alloc_irq_vectors_affinity(ha->pdev, =
min_vecs,
> -		    ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> +		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> +		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> 		    &desc);
>=20
> 	if (ret < 0) {
> --=20
> 2.19.0.rc0
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

