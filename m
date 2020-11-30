Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71772C64E8A
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07B082076E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 19:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9rTKV3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbgK3TQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:16:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40530 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388228AbgK3TQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 14:16:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJEtID180387;
        Mon, 30 Nov 2020 19:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=QRRyLHr54zLVvqts0q1E1e7aOWhET0v7UIce6bgUCrc=;
 b=L9rTKV3U9zLnRPNGh2azi9OleWIrKjaWkUwL8aqkJ/az28XpQrLIaXl1EAKkIyrAiDX1
 nkKrBPANksPj57rVaWB4+ILg/o+vtLhF2RfHfUFqVtmzRs3kpnPhYBXk/024nZ9pbSn4
 1KP6rLX1GVgdQf25IyUkR8bPVKih/thFmavYD7Wa8ZJSGRTbIWeSYA6QJhMODwJLPfXU
 eQK5Ymw4tVvovNk/MNJaeKwpHi3jT5I/uQD4I/EBV5Mfa1Eyms1aLeFY/2Rlj2Wzb0B+
 LOCTioUfv70qBA66vWeH2WB5yuksEEjRLGhs52NIPLNYuUGB8biqmvYi46grZ7tHq2Ch XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2aq073-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 19:15:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ6DNH075561;
        Mon, 30 Nov 2020 19:13:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540ar1a2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:13:20 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUJDJPX021683;
        Mon, 30 Nov 2020 19:13:19 GMT
Received: from dhcp-10-154-168-92.vpn.oracle.com (/10.154.168.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 11:13:18 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 05/14] scsi: qla2xxx: tcm_qla2xxx: Remove
 BUG_ON(in_interrupt()).
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201126132952.2287996-6-bigeasy@linutronix.de>
Date:   Mon, 30 Nov 2020 13:13:15 -0600
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>, linux-m68k@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <74BF47E2-787C-41DA-8810-6369DFD0CC53@oracle.com>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-6-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=11
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 26, 2020, at 7:29 AM, Sebastian Andrzej Siewior =
<bigeasy@linutronix.de> wrote:
>=20
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>=20
> tcm_qla2xxx_free_session() has a BUG_ON(in_interrupt()).
>=20
> While in_interrupt() is ill-defined and does not provide what the name
> suggests, it is not needed here: the function is always invoked from
> workqueue context through "struct qla_tgt_func_tmpl" ->free_session()
> hook it is bound to.
>=20
> The function also calls wait_event_timeout() down the chain, which
> already has a might_sleep().
>=20
> Remove the in_interrupt() check.
>=20
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: <GR-QLogic-Storage-Upstream@marvell.com>
> ---
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c =
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 784b43f181818..b55fc768a2a7a 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1400,8 +1400,6 @@ static void tcm_qla2xxx_free_session(struct =
fc_port *sess)
> 	struct se_session *se_sess;
> 	struct tcm_qla2xxx_lport *lport;
>=20
> -	BUG_ON(in_interrupt());
> -
> 	se_sess =3D sess->se_sess;
> 	if (!se_sess) {
> 		pr_err("struct fc_port->se_sess is NULL\n");
> --=20
> 2.29.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

