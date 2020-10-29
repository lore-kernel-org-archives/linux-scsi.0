Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDF8C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1054820756
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 20:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ua/Q0lOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgJ2UaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:30:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52210 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 16:30:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKTIef010156;
        Thu, 29 Oct 2020 20:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=SgLCHkqQRidaXGKl3mo1lotCFrzxJeAymL4wcvSLf4s=;
 b=Ua/Q0lOZ7V3bsOamsEAyx3gKbEXKw84ajKm4npc4dGFgDctEzYPxOXBLTmArWtM2JQ40
 ANBZSO/mJg2kUhyC9hEfpeL92f+wVEXv+oGV7Wb6z2JMAXF44lXpk6Nx3nJLCv/jbjqK
 JpLYlq1mqp9UtYQ5K8mgKQA4cYyR+D6t4y3KUN6woGkSyenaGInY4qVn+RXgSt99v/xn
 MMM5yCRsqfwM49digIBu9lKeXy1Ef/1bkJLG8YyIUbgMB/fFBWjb2NRcitWGqbiaDt41
 NBNBeddBU27Zlf9Vyo3DAf3c4IBKlFyvUZu9Nc4OFtY/sjjiKBAz11FYyo84muOJrehO /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb7282-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:30:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKUCWC138858;
        Thu, 29 Oct 2020 20:30:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx60x7vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:30:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TKUIJI023860;
        Thu, 29 Oct 2020 20:30:18 GMT
Received: from dhcp-10-154-184-179.vpn.oracle.com (/10.154.184.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:30:18 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 8/8] tcm loop: allow queues, can queue and cmd per lun to
 be settable
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <1603954171-11621-9-git-send-email-michael.christie@oracle.com>
Date:   Thu, 29 Oct 2020 15:30:17 -0500
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8780449C-0847-4A48-B4D4-95BC9020158B@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
 <1603954171-11621-9-git-send-email-michael.christie@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=11 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=11
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290142
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 29, 2020, at 1:49 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> Make can_queue, nr_hw_queues and cmd_per_lun settable by the user
> instead of hard coding them.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/target/loopback/tcm_loop.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/target/loopback/tcm_loop.c =
b/drivers/target/loopback/tcm_loop.c
> index 16d5a4e..badba43 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -46,6 +46,15 @@
>=20
> static int tcm_loop_queue_status(struct se_cmd *se_cmd);
>=20
> +static unsigned int tcm_loop_nr_hw_queues =3D 1;
> +module_param_named(nr_hw_queues, tcm_loop_nr_hw_queues, uint, 0644);
> +
> +static unsigned int tcm_loop_can_queue =3D 1024;
> +module_param_named(can_queue, tcm_loop_can_queue, uint, 0644);
> +
> +static unsigned int tcm_loop_cmd_per_lun =3D 1024;
> +module_param_named(cmd_per_lun, tcm_loop_cmd_per_lun, uint, 0644);
> +
> /*
>  * Called from struct target_core_fabric_ops->check_stop_free()
>  */
> @@ -305,10 +314,8 @@ static int tcm_loop_target_reset(struct scsi_cmnd =
*sc)
> 	.eh_abort_handler =3D tcm_loop_abort_task,
> 	.eh_device_reset_handler =3D tcm_loop_device_reset,
> 	.eh_target_reset_handler =3D tcm_loop_target_reset,
> -	.can_queue		=3D 1024,
> 	.this_id		=3D -1,
> 	.sg_tablesize		=3D 256,
> -	.cmd_per_lun		=3D 1024,
> 	.max_sectors		=3D 0xFFFF,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> 	.module			=3D THIS_MODULE,
> @@ -342,6 +349,9 @@ static int tcm_loop_driver_probe(struct device =
*dev)
> 	sh->max_lun =3D 0;
> 	sh->max_channel =3D 0;
> 	sh->max_cmd_len =3D SCSI_MAX_VARLEN_CDB_SIZE;
> +	sh->nr_hw_queues =3D tcm_loop_nr_hw_queues;
> +	sh->can_queue =3D tcm_loop_can_queue;
> +	sh->cmd_per_lun =3D tcm_loop_cmd_per_lun;
>=20
> 	host_prot =3D SHOST_DIF_TYPE1_PROTECTION | =
SHOST_DIF_TYPE2_PROTECTION |
> 		    SHOST_DIF_TYPE3_PROTECTION | =
SHOST_DIX_TYPE1_PROTECTION |
> --=20
> 1.8.3.1
>=20

Looks Okay.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

