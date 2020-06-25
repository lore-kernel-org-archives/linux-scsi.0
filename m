Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700A6C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A12420702
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IUNB5pVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405259AbgFYOL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 10:11:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48082 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404890AbgFYOL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 10:11:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PE81Qn062673;
        Thu, 25 Jun 2020 14:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5YtC0rXorsqe6qezeg910C4ASw0yMikhO6NV3vtVAGE=;
 b=IUNB5pVs5b74nwe6nQoV7rvtAFhSEvScmaZ+U2Tl7/X52UUJsT6snu4tD1oj+eUqzyH0
 LdjwN/9z7RadgZMAzu2y3mBZj2Fx6p2gzxXsytvu03HAM5xzhBNTmWIpr4Ilak2enVhu
 is8HXj9zIOfpe0onrDrBLNCt4P8Glo/eAbEVy1DULhJXA+ZREwNbufPy3LOhHnL5MOYx
 eHfFdLoyO8nd82S6mawFk+e1WrGIlfUCsekl/3EUD7J4sjvjDvygJPjlGh29aKhresyO
 eE21G6LbdRg8/a7N//VXWCj/EVgda4WXCqcx4UtKMIEHLu4xHGAGKjh22KqXxhmlVXs8 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu0sah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 14:11:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PEAN8o151980;
        Thu, 25 Jun 2020 14:11:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9309b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 14:11:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PEBjEG030550;
        Thu, 25 Jun 2020 14:11:45 GMT
Received: from dhcp-10-154-182-3.vpn.oracle.com (/10.154.182.3) by default
 (Oracle Beehive Gateway v4.0) with ESMTP ; Thu, 25 Jun 2020 14:11:05 +0000
MIME-Version: 1.0
Message-ID: <6B3598A1-4F56-4D63-A672-644242B0A8F2@oracle.com>
Date:   Thu, 25 Jun 2020 14:11:04 +0000 (UTC)
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix a condition in
 qla2x00_find_all_fabric_devs()
References: <20200619143041.GD267142@mwanda>
In-Reply-To: <20200619143041.GD267142@mwanda>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250091
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 19, 2020, at 9:30 AM, Dan Carpenter <dan.carpenter@oracle.com> =
wrote:
>=20
> This code doesn't make sense unless the correct "fcport" was found.
>=20
> Fixes: 9dd9686b1419 ("scsi: qla2xxx: Add changes for devloss timeout =
in driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is from static analysis and review.  I'm not super familiar with
> the code and I can't test it.  Please review it extra carefully.
>=20
> drivers/scsi/qla2xxx/qla_init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 4576d3ae9937..2436a17f5cd9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5944,7 +5944,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t =
*vha)
> 			break;
> 		}
>=20
> -		if (NVME_TARGET(vha->hw, fcport)) {
> +		if (found && NVME_TARGET(vha->hw, fcport)) {
> 			if (fcport->disc_state =3D=3D DSC_DELETE_PEND) {
> 				qla2x00_set_fcport_disc_state(fcport, =
DSC_GNL);
> 				vha->fcport_count--;
> --=20
> 2.27.0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering





