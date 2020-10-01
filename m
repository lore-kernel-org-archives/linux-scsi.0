Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CC2C4727E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 16:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5471D20897
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 16:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bz4Yh3Vf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbgJAQsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:48:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732107AbgJAQsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 12:48:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091GjCmX176030;
        Thu, 1 Oct 2020 16:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Hcuvzvizet1f4z8OHZuL46p13PAZdx5HGCo/sBMMYNU=;
 b=Bz4Yh3Vfgm+Q3p3m9iP8SH4bqurkl+EaCRDANVhGP+IPC+Rs2KlJYATH+KponZCArDRv
 4+jxkv171NaoHUeay7dOll+KuGUrdN3tQLw+Du4r1rYD+BIkFgSi0OG/Mb0dg7GaMh5i
 6JaNBO68GaPPxBgLzaoeqL+4Z6/metdgi8uB7Yv27rs7szilg/mxqhlEWxS38WFGaK9D
 G2+RkedW7UL2HYEOmJxJ9puL+1Xnf7Y+GFkSl0k/KtaFFsRVFIpJkCVOCW7i5fykQMfn
 XhyaWMfbapJ0IRbYH970XX97h303oUN6iU/ohd6QZEWOe/uttDlJB4a76WWXmGLsmIIm eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nf307-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 16:48:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091GiqXW116424;
        Thu, 1 Oct 2020 16:46:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33tfdw3pnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 16:46:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091GkeZ0000590;
        Thu, 1 Oct 2020 16:46:40 GMT
Received: from dhcp-10-154-119-140.vpn.oracle.com (/10.154.119.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 09:46:39 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 3/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in qla_dbg.c
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200930022515.2862532-4-yebin10@huawei.com>
Date:   Thu, 1 Oct 2020 11:46:39 -0500
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB4B635B-7365-46EE-BA9C-6071CA2CAB4D@oracle.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
 <20200930022515.2862532-4-yebin10@huawei.com>
To:     Ye Bin <yebin10@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 29, 2020, at 9:25 PM, Ye Bin <yebin10@huawei.com> wrote:
>=20
> Fix follow warning:
> [drivers/scsi/qla2xxx/qla_dbg.c:2451]: (warning) %ld in format string =
(no. 4)
> 	requires 'long' but the argument type is 'unsigned long'.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c =
b/drivers/scsi/qla2xxx/qla_dbg.c
> index 1434789c9919..bb7431912d41 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2448,7 +2448,7 @@ static void ql_dbg_prefix(char *pbuf, int =
pbuf_size,
> 		const struct pci_dev *pdev =3D vha->hw->pdev;
>=20
> 		/* <module-name> [<dev-name>]-<msg-id>:<host>: */
> -		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%ld: ", =
QL_MSGHDR,
> +		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%lu: ", =
QL_MSGHDR,
> 			 dev_name(&(pdev->dev)), msg_id, vha->host_no);
> 	} else {
> 		/* <module-name> [<dev-name>]-<msg-id>: : */
> --=20
> 2.25.4
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

