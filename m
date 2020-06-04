Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B78C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B131F206DC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="raUsJ6qU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgFDQdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:33:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgFDQdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2020 12:33:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 054GWXSU018604
        for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2020 16:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uIYkBbYk2BZ//WqFHd8H5GhayuvyfEJNUPUwgHAux5Y=;
 b=raUsJ6qUadFOHEt7Y0DqeAQ8dxEGkelM7zrvauGD/iJ7cfXCbmOAmLql31rXCaPEcEwk
 GZPBdOrhKw5QRmE/AdYYas41VcRuz9bbL+5Icnl/t8FAODMuH1hZQ7OhBtZzJVHDT4t6
 V8Xjwo2VLHkXvZ2RK2rp6HJ0xwj6j76ov7iqZWCdqRzQDVlBPlUJ+HibAw/gpRxOAL8U
 4QZOYIuH+0d939AAhaItSRIsGXv0DNGhH6SGqaD0vgUSCykgA0eNj2dqU6KnWfdCKH7r
 95/Tm5iWxn5rei3qFOhCHvLuPpFIEaxdnEfAL/ztiWIAHmjSWnxlf5cXkwF2Pw7FRNsM 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31evap2p9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2020 16:33:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 054GO7u6104669
        for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2020 16:33:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31dju595ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2020 16:33:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 054GXKgi031286
        for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2020 16:33:20 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jun 2020 09:33:19 -0700
Subject: Re: [PATCH] scsi: register sysfs for scsi workqueue
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20200603070616.29629-1-bob.liu@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <90107ccf-c081-c0a0-474a-e707d6626eab@oracle.com>
Date:   Thu, 4 Jun 2020 11:33:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603070616.29629-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006040112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=2 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040113
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/3/20 2:06 AM, Bob Liu wrote:
> This patch enable setting cpu affinity through "cpumask" for scsi workqueues
> (scsi_wq_* and scsi_tmf_*), so as to get better isolation.
> 
> The max number of active worker was changed form 1 to 2, since "cpumask" of
> ordered workqueue isn't allowed to change.

Do we just want to set it to 0? For all users but iscsi we use it for 
scanning. With 0, we can multiple rports/sessions in parallel.

For iscsi we do scanning and also unbinding (target removal) from it. It 
looks like we have the big iscsi_host mutex, so it would not help.

For the fc drivers that only scan through the fc class, we look ok. I 
think we want to flush/cancel the specific scan work item instead of 
flushing the entire workqueue when we are only concerned with a specific 
port in fc_rport_final_delete (the host removal we want to still do the 
entire workqueue). I think we want to do the same in snic snic_tgt_del.

For zfcp, I have no idea. You should cc them.


> 
> __WQ_LEGACY was left because of
> 23d11a5(workqueue: skip flush dependency checks for legacy workqueues)
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>   drivers/scsi/hosts.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1d669e4..aa48142 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -272,8 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (shost->transportt->create_work_queue) {
>   		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
>   			 "scsi_wq_%d", shost->host_no);
> -		shost->work_q = create_singlethread_workqueue(
> -					shost->work_q_name);
> +		shost->work_q = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, shost->work_q_name);
> +
>   		if (!shost->work_q) {
>   			error = -EINVAL;
>   			goto out_free_shost_data;
> @@ -487,8 +489,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   	}
>   
>   	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
> -					    WQ_UNBOUND | WQ_MEM_RECLAIM,
> -					   1, shost->host_no);
> +			WQ_SYSFS | WQ_UNBOUND | WQ_MEM_RECLAIM, 2, shost->host_no);
>   	if (!shost->tmf_work_q) {
>   		shost_printk(KERN_WARNING, shost,
>   			     "failed to create tmf workq\n");
> 
