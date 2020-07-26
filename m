Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82067C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 00:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F98E2070C
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 00:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tCuOX7he"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGZADa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 20:03:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgGZADa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 20:03:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q02uuR136951;
        Sun, 26 Jul 2020 00:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aI6XbBPC92r4CrbMEdC/yTsAkqeGQ8nhgS87n3ecktA=;
 b=tCuOX7he1ul8rwXMVGd/ROsK7L1PdqHd6EARwGoCvNs4hCvW76hRksSK3wvnXNkAbs3C
 NOn1ZOZrdXc+9jo419928Giqy21VgPOiNk+FmFdBHe+/UIBPjVhP1PUll8oqjTk6ESph
 Uck+fSTK6AX0Vl/nj8xYosQqlx1ivElrNkehelWux6ZBN0MGdzjM4DTE5jHAN4Q062Bo
 YPWf74evNspNaUr7jzUhEbigepUZ6cXjFzIUtRQZVCMq/ovpRJScF17OVZ8TvtPIg0Zw
 z36raitbBLHfiwLQhbgBVAc+P6UUdD9VzIQ716X1OBes+KFr18kZDYmtIhDZQw5Y54Yu ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32gxd3g10p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 00:03:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PNwE57194651;
        Sun, 26 Jul 2020 00:03:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32gxmx0r8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 00:03:23 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06Q03MQK028733;
        Sun, 26 Jul 2020 00:03:22 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 17:03:22 -0700
Subject: Re: [PATCH v2 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
 <20200717161212.10731-2-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <12707afb-4821-f0d9-baff-4078b599a5ea@oracle.com>
Date:   Sat, 25 Jul 2020 19:03:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717161212.10731-2-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250200
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/20 11:12 AM, Bodo Stroesser wrote:
> This patch modifies core_tmr_abort_task() to use same looping
> and locking scheme as core_tmr_drain_state_list() does.
> 
> This frees the state_list element in se_cmd for later use
> by tmr notification handling.
> 
> Note: __target_check_io_state() now is called with param 0
> instead of dev->dev_attrib.emulate_tas, because tas is not
> relevant since we always get ABRT on same session like the
> aborted command.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_tmr.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 89c84d472cd7..b65d7a0a5df1 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -116,14 +116,15 @@ void core_tmr_abort_task(
>  	struct se_tmr_req *tmr,
>  	struct se_session *se_sess)
>  {
> -	struct se_cmd *se_cmd;
> +	struct se_cmd *se_cmd, *next;
>  	unsigned long flags;
> +	bool rc;
>  	u64 ref_tag;
>  
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> +	spin_lock_irqsave(&dev->execute_task_lock, flags);
> +	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
>  
> -		if (dev != se_cmd->se_dev)
> +		if (se_sess != se_cmd->se_sess)
>  			continue;
>  
>  		/* skip task management functions, including tmr->task_cmd */
> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>  		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>  			se_cmd->se_tfo->fabric_name, ref_tag);
>  
> -		if (!__target_check_io_state(se_cmd, se_sess,
> -					     dev->dev_attrib.emulate_tas))
> +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);

I don't think you can use flags twice. This call seems to be overwriting the outer spin lock caller's value, and I'm seeing a lot of warnings.


> +		rc = __target_check_io_state(se_cmd, se_sess, 0);
> +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);


Use spin_lock/spin_unlock since we know above we have disabled irqs right above. Or make the drain users work like above.

Just make it consistent so future devs don't have to wonder why we use different calls.

> +		if (!rc)
>  			continue;
>  
> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);> +		list_del_init(&se_cmd->state_list);
> +		se_cmd->state_active = false;
> +
> +		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>  
>  		/*
>  		 * Ensure that this ABORT request is visible to the LU RESET
> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>  		atomic_long_inc(&dev->aborts_complete);
>  		return;
>  	}
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>  
>  	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
>  			tmr->ref_task_tag);
> 

