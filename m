Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D91AC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7FF42065C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b+L3rNSL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEOAKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 20:10:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgEOAKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 20:10:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ENvoHg175775;
        Fri, 15 May 2020 00:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=LL5/JgD6jBMuhfdz8Lyl09y0lxpE8ogV4kJHKjq0xLo=;
 b=b+L3rNSL1EzdVhsxe4zs+lQ/SpR1VT1B8xSQSQBLjkahyZSXw+V4zTtue/SZrlkGUyxF
 9UNgPup+UgiJYyiVCEvFnPbWAJ+2WEU9KuwkufDfPqmYkF5G3T3gglDwvBy3FmP9rFD+
 73E3snEo8iEvlROBpAQvOkDxzA8UFa31Ld6rYm4uTv8JRzqydreGrfp+WwTAIFcxfnkt
 mBELOB7FysPiy+ezOpuzfMscq0r4BOjxh9nihjoiShEw12E6rwPztb2RmTUPMS80OLBH
 8z9F5EL62xc21EBSJULeUKOy/9JngaQHTW8T3Qa8hXnUiPt29PJTsYcAcHrmMUlBmz7+ JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3100xwws9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 00:09:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ENxsdD055417;
        Fri, 15 May 2020 00:09:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100yqayjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 00:09:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F09q7J015591;
        Fri, 15 May 2020 00:09:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 17:09:51 -0700
To:     lduncan@suse.com, cleech@redhat.com
Cc:     open-iscsi@googlegroups.com, Bob Liu <bob.liu@oracle.com>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC RESEND PATCH v2] scsi: iscsi: register sysfs for iscsi
 workqueue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200505011908.15538-1-bob.liu@oracle.com>
Date:   Thu, 14 May 2020 20:09:49 -0400
In-Reply-To: <20200505011908.15538-1-bob.liu@oracle.com> (Bob Liu's message of
        "Tue, 5 May 2020 09:19:08 +0800")
Message-ID: <yq17dxet5wy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=2
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140204
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chris/Lee: Please review!

> Motivation:
> This patch enable setting cpu affinity through "cpumask" for iscsi workqueues
> (iscsi_q_xx and iscsi_eh), so as to get performance isolation.
>
> The max number of active worker was changed form 1 to 2, because "cpumask" of
> ordered workqueue isn't allowed to change.
>
> Notes:
> - Having 2 workers break the current ordering guarantees, please let me know
>   if anyone depends on this.
>
> - __WQ_LEGACY have to be left because of
> 23d11a5(workqueue: skip flush dependency checks for legacy workqueues)
>
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/scsi/libiscsi.c             | 4 +++-
>  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 70b99c0..adf9bb4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  	if (xmit_can_sleep) {
>  		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
>  			"iscsi_q_%d", shost->host_no);
> -		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
> +		ihost->workq = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, ihost->workq_name);
>  		if (!ihost->workq)
>  			goto free_host;
>  	}
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index dfc726f..bdbc4a2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4602,7 +4602,9 @@ static __init int iscsi_transport_init(void)
>  		goto unregister_flashnode_bus;
>  	}
>  
> -	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
> +	iscsi_eh_timer_workq = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, "iscsi_eh");
>  	if (!iscsi_eh_timer_workq) {
>  		err = -ENOMEM;
>  		goto release_nls;

-- 
Martin K. Petersen	Oracle Linux Engineering
