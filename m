Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B546CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79ABA20781
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tZTUNdBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLTrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:47:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLTrw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:47:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJlSh2118792;
        Wed, 12 Aug 2020 19:47:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=b+C6ouxc8V9AGI+0MnRxZZpi3Mh36ODq3lsmAnWyqXs=;
 b=tZTUNdBWD00A39KGqhbfOAySzyWPwePvbrZKNTzJ0t33wsNBzaHf7tIWNZYWg0oJuB/J
 4wAoNhuib30HmdtmrKugnL+IqdvNqm/y6fhFP9axEYMbhsjyztP2w/kFqONoqHGLHbSZ
 LkQvSHfjz3pPexVKNYffpd0CZoh0vMg5nTQnVtPEEVV2kIm3V13MChGUWCvUCYaM5FkH
 lEcGHiaBXPl4i/edC3ctnxXJ/d/nNKqL0VPWiyv1W2rTB6Nmf11trQk/NNKlCeFmtiVg
 kSoKIsK5QjNRO0IKfsUtfZEJhHY0vSWqMPqhWZi44DtqU6wivTn8sBX/jiqBSN8yZUEY eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32sm0mvtmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:47:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJiWTZ160990;
        Wed, 12 Aug 2020 19:47:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32t60254q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:47:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07CJlmGo009675;
        Wed, 12 Aug 2020 19:47:48 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:47:48 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 11/11] qla2xxx: Revert: Disable T10-DIF feature with
 FC-NVMe during probe
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-12-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:47:47 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FE6212E-85A1-4083-970B-7611C056D416@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-12-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=3 mlxlogscore=913
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=3 mlxlogscore=904 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> FCP T10-PI and NVME features are independent of each other. This
> patch allows both features to co-exist.
>=20
> Fixes: 5da05a26b8305a6 ("scsi: qla2xxx: Disable T10-DIF feature with =
FC-NVMe during probe")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 4 ----
> 1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index fda812b9b564..8da00ba54aec 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2834,10 +2834,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
> 	/* This may fail but that's ok */
> 	pci_enable_pcie_error_reporting(pdev);
>=20
> -	/* Turn off T10-DIF when FC-NVMe is enabled */
> -	if (ql2xnvmeenable)
> -		ql2xenabledif =3D 0;
> -
> 	ha =3D kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
> 	if (!ha) {
> 		ql_log_pci(ql_log_fatal, pdev, 0x0009,
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

