Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADBFC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 00:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7080320748
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 00:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BftMPB/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGLAtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 20:49:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51340 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGLAtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 20:49:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06C0mqPS117001;
        Sun, 12 Jul 2020 00:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=No2N+GkJr4q72/7iTHRlUG1P1ozMzMN0B8FNnW7Xlac=;
 b=BftMPB/O4mko3mOyNsSZ76LOhXAV+V8DPyQG520o8m36KK+cNgjzdrG5PizeBT6+5dHV
 DnG5oELAxGUNd8T9zy+UmK0EmD5gCmCnkXRJ8wdEuH5GV9wNe7HqXSj8dfEAjMBg0eIy
 CSN9AQ5j9UDovWJcAkW3NNFGJLrBch5vX4Yk31Brf0uhiUUvxxiSDBYmTNBHxqsqocox
 tFZnjPDew4qgjWdYFjBgw/H8d/A9HhmJXojAfx1Ozpf0ziQpdbhyhYU4gLb7Ix5skyTc
 sLgSMiaZzfo0cQS7OTqSjTDBtN6/ydL6gqqhMlaOAfrPxNd7zIg6V6mPAf05o9Mcei6c yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762n25ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 12 Jul 2020 00:49:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06C0mVMu177220;
        Sun, 12 Jul 2020 00:49:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qbtj12k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Jul 2020 00:49:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06C0nD07019736;
        Sun, 12 Jul 2020 00:49:13 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 11 Jul 2020 17:49:13 -0700
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
Date:   Sat, 11 Jul 2020 19:49:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007120002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007120002
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/10/20 5:48 AM, Bodo Stroesser wrote:
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
>   drivers/target/target_core_tmr.c | 22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 89c84d472cd7..b65d7a0a5df1 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -116,14 +116,15 @@ void core_tmr_abort_task(
>   	struct se_tmr_req *tmr,
>   	struct se_session *se_sess)
>   {
> -	struct se_cmd *se_cmd;
> +	struct se_cmd *se_cmd, *next;
>   	unsigned long flags;
> +	bool rc;
>   	u64 ref_tag;
>   
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> +	spin_lock_irqsave(&dev->execute_task_lock, flags);
> +	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
>   
> -		if (dev != se_cmd->se_dev)
> +		if (se_sess != se_cmd->se_sess)
>   			continue;
>   
>   		/* skip task management functions, including tmr->task_cmd */
> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>   		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>   			se_cmd->se_tfo->fabric_name, ref_tag);
>   
> -		if (!__target_check_io_state(se_cmd, se_sess,
> -					     dev->dev_attrib.emulate_tas))
> +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> +		rc = __target_check_io_state(se_cmd, se_sess, 0);
> +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		if (!rc)
>   			continue;
>   
> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		list_del_init(&se_cmd->state_list);

Do we only want to do this if in the next patch tmr_notify can 
successfully accept the tmr?

If tmr_notify can't allocate memory for the abort case, we would delete 
it from the list. Later the initiator would send a LUN_RESET but 
core_tmr_drain_state_list won't see it and pass it to the tmr_notify call.

> +		se_cmd->state_active = false;
> +
> +		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
>   		/*
>   		 * Ensure that this ABORT request is visible to the LU RESET
> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>   		atomic_long_inc(&dev->aborts_complete);
>   		return;
>   	}
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
>   	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
>   			tmr->ref_task_tag);
> 

