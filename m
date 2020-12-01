Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C199EC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59582208C3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvO2OO4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLAQXg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:23:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLAQXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:23:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G5JvM099406;
        Tue, 1 Dec 2020 16:22:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=hRPt2LzHZYHHsLKNJIBwvLlhWhHQbTShMaeamsuc97A=;
 b=WvO2OO4GY+tRAfsyE2/ZhIokVqgnmmhOJTbYUnTXqcuBbWIQ6zORceXdHU0y/C70rtPN
 a+lw1tH6zDetEcVMMcqxik8VrrRCOZPGwerMussHgZNYNpgP3oBVc1IT2MOZRhnfdgEB
 vvO57BZ1OzS6u8tTNP3cANTeRj3x2EuKIKhiiC9sKb+vduayRkQm8QF1o2hxjQg0ARsO
 oK9gkyrpA+x0YvjIg8EcAX6K8yMlno1Jue68WXgHwX66IivdmVUC4RdDulwc1aPakZso
 3qAwCHW6CdIoofZJl3vG7IuNnVHOuln+9D+AnCDOxvZlRV5KBK77W3iy5cTIKJ0l1we2 qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqkg1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:22:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G6O17072698;
        Tue, 1 Dec 2020 16:22:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404n2x2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:22:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1GMpSA018175;
        Tue, 1 Dec 2020 16:22:51 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:22:51 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 14/15] qla2xxx: Fix device loss on 4G and older HBAs.
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-15-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:22:51 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <06592E18-45D8-4E33-9B74-A6BF3BFD9A33@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-15-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Due to a bug in the older scan logic, when a once lost device
> re-appeared, it was not discovered. Fix this by resetting login_retry
> counter upon device discovery.
>=20
> This is applicable only for 4G and older HBAs.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 12e3b05baf41..dcc0f0d823db 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5982,6 +5982,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t =
*vha)
> 				break;
> 			}
>=20
> +			if (fcport->login_retry =3D=3D 0)
> +				fcport->login_retry =3D
> +					vha->hw->login_retry_count;
> 			/*
> 			 * If device was not a fabric device before.
> 			 */
> --=20
> 2.19.0.rc0
>=20


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

