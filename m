Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC75C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 949A8222C9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qGCjApxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKMBnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:43:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKMBnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 20:43:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1dARr034267;
        Wed, 13 Nov 2019 01:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=qKWXAm3FW7Kk0gbURMy2s+joUq+pupTB6xMdYcIJufw=;
 b=qGCjApxN7nBqzFf6zyzaBAS8IURACnnI3eN+qcS3f6qS5VVZkZnEyam1x2XE/RJJ7CqQ
 i9+xlbR3s8yrxekLkHaI1CwPgtVP4NfvMJmPpCvVu9I3pBu6c/9yYxJ4aIIfL0Hmukra
 Y89QYKSRukcK2AkIG7W39Bph8/yV2qkOY6TzEpuY0WTjlAFYgQE1jEHQAHeZWbST/YpA
 W8ewzOyhfd5fShYa2bO9IwWMsuZxslxz771je0vEjRAab7wP/QXc0ZSWDhHpwwOKn937
 TtjkUlqFheeK4ASSfimHcEfYgxYCA+bzc9gA9bGkIgF+jF1gAGofvPJ86+dw8szNYU3J +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtru0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:41:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1cONm070779;
        Wed, 13 Nov 2019 01:41:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w7j045v3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:41:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD1ftZm005101;
        Wed, 13 Nov 2019 01:41:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 17:41:54 -0800
To:     hmadhani@marvell.com
Cc:     Thomas Abraham <tabraham@suse.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hare@suse.com
Subject: Re: [PATCH] scsi: qla2xxx: avoid crash in qlt_handle_abts_completion() if mcmd == NULL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20191104181803.5475-1-tabraham@suse.com> (Thomas Abraham's
        message of "Mon, 4 Nov 2019 13:18:03 -0500")
Organization: Oracle Corporation
References: <20191104181803.5475-1-tabraham@suse.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
Date:   Tue, 12 Nov 2019 20:41:52 -0500
Message-ID: <yq11rucsgbj.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=978
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu: Ping.

Also see: https://patchwork.kernel.org/patch/11141981/

> qlt_ctio_to_cmd() will return a NULL mcmd if h == QLA_TGT_SKIP_HANDLE. If
> the error subcodes don't match the exact codes checked a crash will occur
> when calling free_mcmd on the null mcmd
>
> Signed-off-by: Thomas Abraham <tabraham@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index a06e56224a55..611ab224662f 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5732,7 +5732,8 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
>  			    vha->vp_idx, entry->compl_status,
>  			    entry->error_subcode1,
>  			    entry->error_subcode2);
> -			ha->tgt.tgt_ops->free_mcmd(mcmd);
> +			if (mcmd)
> +				ha->tgt.tgt_ops->free_mcmd(mcmd);
>  		}
>  	} else if (mcmd) {
>  		ha->tgt.tgt_ops->free_mcmd(mcmd);

-- 
Martin K. Petersen	Oracle Linux Engineering
