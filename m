Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2578C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 15:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956692077D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 15:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IPYfQKZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbgGAPjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 11:39:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbgGAPjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 11:39:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061FcEmF078885;
        Wed, 1 Jul 2020 15:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gS89WSm3Ys4J06VdBiAeWPQcb2O3EqSy09enLgjX5AA=;
 b=IPYfQKZcPNbTlFzJ6BBX5K5Ib0fjpRX36Povz9RejoTfsW/QVyOD/AVX61qd0Z/LC9Sn
 rWqVBCpYk6ntWoI6f1KFPnviEFHadgwsAtMQUQaSDXPylAuFJlbPuu1Qe5WJDmIdhxBv
 qbrSrCkwERoCiUuhFqWzuiurUO6yElrJr81YFReHTG4napjQaDMxVuu1YLqzXIxKzkD9
 HEZGCg9Ye6I6ud0KldARwDXPKJJOBzhIIi2KrmddI+BRTrgiGeBUvXRe/Qsuf40XXlcF
 w5FHxOqKCsXxphAyMbltpoeNzrvbDsA+WqWla1j8e/kTkQOrJrgCvjN5CbFvIHw0AHwy dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrnb84y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 15:39:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061FcjoM070963;
        Wed, 1 Jul 2020 15:39:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52kf2ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 15:39:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061FdV7e008693;
        Wed, 1 Jul 2020 15:39:31 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 15:39:31 +0000
Subject: Re: [PATCH 2/2] scsi: register sysfs for scsi workqueue
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        lduncan@suse.com
References: <20200701030745.16897-1-bob.liu@oracle.com>
 <20200701030745.16897-2-bob.liu@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <fe5cb411-aed9-0bb0-e55e-18629e41eb9d@oracle.com>
Date:   Wed, 1 Jul 2020 10:39:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701030745.16897-2-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=2 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=2 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010111
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/20 10:07 PM, Bob Liu wrote:
> So that scsi_wq_xxx and scsi_tmf_xxx can be bind to different cpu to get better
> isolation.
> 
> This patch unfolded create_singlethread_workqueue(), added WQ_SYSFS and dropped
> __WQ_ORDERED_EXPLICIT since __WQ_ORDERED_EXPLICIT workqueue isn't allowed to
> change "cpumask".
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/scsi/hosts.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 7ec91c3..37d1c55 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -272,8 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  	if (shost->transportt->create_work_queue) {
>  		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
>  			 "scsi_wq_%d", shost->host_no);
> -		shost->work_q = create_singlethread_workqueue(
> -					shost->work_q_name);
> +		shost->work_q = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			1, shost->work_q_name);
> +
>  		if (!shost->work_q) {
>  			error = -EINVAL;
>  			goto out_free_shost_data;
> @@ -487,7 +489,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	}
>  
>  	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
> -					    WQ_UNBOUND | WQ_MEM_RECLAIM,
> +					WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS,
>  					   1, shost->host_no);
>  	if (!shost->tmf_work_q) {
>  		shost_printk(KERN_WARNING, shost,
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

