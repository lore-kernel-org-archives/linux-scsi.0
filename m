Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52174C83001
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297AB2087E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wTtu/8oT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgD1AFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 20:05:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgD1AFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 20:05:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S02hbS005593
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 00:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wve4IxxI+gHT33a9fQHr5iG6L8KLhtH8AGU/s0ckWtQ=;
 b=wTtu/8oTWGq85EQIXsKUuQwftitZRvMyQWiBZgbG/Mep5rfNZcTo4Bpz6xbKxHjJvtH4
 ts45E4sriIDPY3eRhQxyzzJ8lKjP6SiZ5GeANIkkxHRISBEBKbHvUjO4tBGpgbi3Bv4Q
 R48h94suyKRp63G/rLkoCztrgidb+VOTa81sc4SBZrlQmIApDgKZk4VERWebUpmk98RU
 Gd41GYbaVH11CcJA73r6UwCbNr+lx6bN3ag0OPccNXrqRGDaPmDAVB58i1jf/YMJLXt/
 Gi+k5ZWOwD1M6JzswgDFuWAidP9x4KrHrGwy+EgsFEpyUxCmu1njimboFbIaP/eyiBU9 FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucfvpp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 00:05:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RNwDpc120704
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 00:03:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30mxrra9ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 00:03:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03S037fD002292
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2020 00:03:07 GMT
Received: from [10.191.31.22] (/10.191.31.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 17:03:07 -0700
Subject: Re: [PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20200417111545.30437-1-bob.liu@oracle.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <f4051cbe-0bdf-badb-5b00-0d875fa03261@oracle.com>
Date:   Tue, 28 Apr 2020 08:02:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200417111545.30437-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=3 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270196
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Friendly ping..

On 4/17/20 7:15 PM, Bob Liu wrote:
> Then users can set cpu affinity through "cpumask" for iscsi workqueues, so
> as to get performance isolation.
> 
> This patch changes the max number of active worker form 1 to 2,
> since ordered workqueue wont' be allowed to change "cpumask".
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
> 

