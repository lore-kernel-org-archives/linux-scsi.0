Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45416C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D2E620691
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fMNDy0pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgFJCML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:12:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:12:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A26Q50115746;
        Wed, 10 Jun 2020 02:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=lSt+S6LOEb+jknDxz3wUyTwsinGlkdwtYM/fHYL6/9w=;
 b=fMNDy0pjbQlIJ71Da2Pwqr46ZgR4WqnMkWbeF7EysBytClj+17t5rH3Cwb4USORgViSU
 tKJlewJdLniZ0pyK+1v8WVSDMMamH+7AY5FToX+9TM1+UhYWCSKqBmGBTmFXGwKAQSIs
 SN2gudTvXYUqiYWfFtVxIvTh/K1EofT/a+gqVmFtqB7PxmziaqJBqiL2J8EYrv+c832R
 6WN6DDO9v217a0sqBwJPm9bBFywPceVP8rRyeGtUxYgiXDbqzwrdA/s8nXaWEdAuOFNu
 Z8k2ISApM9VE3lpefq2r2GlvhPk9sX/oCwTJSZzeZNEJ/qYynPbdMJfZ5MlT+SenGFIt Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smyrpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:11:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A28MbA044822;
        Wed, 10 Jun 2020 02:11:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31gn27h0x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:11:57 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05A2BiZk021877;
        Wed, 10 Jun 2020 02:11:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:11:30 -0700
To:     Avri Altman <avri.altman@wdc.com>
Cc:     kjlu@umn.edu, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>
Subject: Re: [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k10fsmaj.fsf@ca-mkp.ca.oracle.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
Date:   Tue, 09 Jun 2020 22:11:27 -0400
In-Reply-To: <20200522045932.31795-1-dinghao.liu@zju.edu.cn> (Dinghao Liu's
        message of "Fri, 22 May 2020 12:59:29 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=44 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=44
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri: Please review!

> When ufs_bsg_alloc_desc_buffer() returns an error code,
> a pairing runtime PM usage counter decrement is needed
> to keep the counter balanced.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/scsi/ufs/ufs_bsg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
> index 53dd87628cbe..516a7f573942 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -106,8 +106,10 @@ static int ufs_bsg_request(struct bsg_job *job)
>  		desc_op = bsg_request->upiu_req.qr.opcode;
>  		ret = ufs_bsg_alloc_desc_buffer(hba, job, &desc_buff,
>  						&desc_len, desc_op);
> -		if (ret)
> +		if (ret) {
> +			pm_runtime_put_sync(hba->dev);
>  			goto out;
> +		}
>  
>  		/* fall through */
>  	case UPIU_TRANSACTION_NOP_OUT:

-- 
Martin K. Petersen	Oracle Linux Engineering
