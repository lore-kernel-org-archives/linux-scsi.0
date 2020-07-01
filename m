Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8214CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 15:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6203F207F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 15:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RzyyBE2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgGAP2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 11:28:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731763AbgGAP2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 11:28:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061FNRG5144729;
        Wed, 1 Jul 2020 15:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E9jY30hj+ZKGGRNx8bb4PuMEiQ00MFjpeLHWCV4VVyU=;
 b=RzyyBE2kO9ifAw7EqE6OTjWWDdDabB7InaOph0EW/a7iiLv6v2TiqVH37ld2LhWoA3Cz
 M7Ec/qHBgHWR54DV9hnP5zPqyzBI1K3/p6dL1+gyZI6W8f9kbLm4jXu2tNiYpHpHq2EZ
 BLU1wlixuqOMcej+Moi2t2enPpl36da5zkafjGAWzmsO1vii3vOVtna4ricoTV3BJAPa
 CTLD1ioAAHdqDP4rbLpo6c6rqSl/4NTbvSgK4/Gpjg6kcKe3CY436RC6DQzv8WLPbJkB
 H5TQNOmaSS8jsx9Wln7TzlFqj1YhYOQGdKt29VGzXEF0DdbHi17Rhnd0i9XpQ8rpmRXk XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbse5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 15:28:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061FMknU066079;
        Wed, 1 Jul 2020 15:28:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg16kjcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 15:28:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061FSNt8003656;
        Wed, 1 Jul 2020 15:28:24 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 15:28:23 +0000
Subject: Re: [PATCH 1/2] scsi: iscsi: change back iscsi workqueue max_active
 argu to 1
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        lduncan@suse.com
References: <20200701030745.16897-1-bob.liu@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8e09f77c-ac01-358b-0451-d4107ef5cd34@oracle.com>
Date:   Wed, 1 Jul 2020 10:28:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701030745.16897-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=2 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010110
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/20 10:07 PM, Bob Liu wrote:
> Commit 3ce4196 (scsi: iscsi: Register sysfs for iscsi workqueue) enables
> 'cpumask' support for iscsi workqueues.
> 
> While there is a mistake in that commit, it's unnecessary to set
> max_active = 2 since 'cpumask' can be modified when max_active = 1.
> 
> This patch change back max_active to 1 so as to keep the same behaviour as
> before.
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/scsi/libiscsi.c             | 2 +-
>  drivers/scsi/scsi_transport_iscsi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index e5a64d4..49c8a18 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2629,7 +2629,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  			"iscsi_q_%d", shost->host_no);
>  		ihost->workq = alloc_workqueue("%s",
>  			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			2, ihost->workq_name);
> +			1, ihost->workq_name);
>  		if (!ihost->workq)
>  			goto free_host;
>  	}
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f4cc08e..7ae5024 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4760,7 +4760,7 @@ static __init int iscsi_transport_init(void)
>  
>  	iscsi_eh_timer_workq = alloc_workqueue("%s",
>  			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			2, "iscsi_eh");
> +			1, "iscsi_eh");
>  	if (!iscsi_eh_timer_workq) {
>  		err = -ENOMEM;
>  		goto release_nls;
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

I think it should get it into 5.8 to fix the bug I mentioned in the other thread.

For 5.9, you'll want to send another patch to update the iscsi_destroy_workq that got added in 5.8.

scsi_transport_iscsi.c:

iscsi_destroy_workq = create_singlethread_workqueue("iscsi_destroy");

