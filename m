Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E82C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 23:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E1D20725
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 23:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jXZ+/oyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGKX1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 19:27:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgGKX1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 19:27:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06BNQw1G044055;
        Sat, 11 Jul 2020 23:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xROGGEprKM1P2BV0TlvlFzhqfWumGuMcd5VItxsUSrM=;
 b=jXZ+/oyd6az02HYNs9f+U7mtpj1xWNSZaJYiYqsVI1vPciyFCD56vBD8aabB/UAja9Yx
 TQoHXJeScSq7AxOIJ3UaMniY0LaoAUxFTJHY4dgm+l8O+Ul3P75QIiMopztVOINIocnY
 VsgSNGyXx5h3Ahp46up2QC6wnsxLiMG9I7/CYp3piAq3UlEvDDeEprYm4YTWEFY+/Npt
 VEiJofH2tvfaZHAz4BgU3qln/TAQ+s2ctXgaTYrM4edQBdvSkTuL7o+mxoxbJx46P9Yo
 66SQ4HTxTZtzzVslubkq4K+2FW6agNyEb0VCQP+mb4/xd4lLjFBAOlDK4VbxsWp6E0aq +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275ckt5jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 11 Jul 2020 23:26:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06BNNdDG006739;
        Sat, 11 Jul 2020 23:26:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3274rj5qhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jul 2020 23:26:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06BNQtiX008541;
        Sat, 11 Jul 2020 23:26:55 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 11 Jul 2020 16:26:55 -0700
Subject: Re: [PATCH 2/8] scsi: target: Add tmr_notify backend function
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-3-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <5c163079-563c-e3e5-2a9c-478a310bd022@oracle.com>
Date:   Sat, 11 Jul 2020 18:27:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200710104817.19462-3-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007110187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007110187
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> Target core is modified to call an optional backend
> callback function if a TMR is received or commands
> are aborted implicitly after a PR command was received.
> The backend function takes as parameters the se_dev, the
> type of the TMR, and the list of aborted commands.
> If no commands were aborted, an empty list is supplied.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_tmr.c       | 16 +++++++++++++++-
>   drivers/target/target_core_transport.c |  1 +
>   include/target/target_core_backend.h   |  2 ++
>   include/target/target_core_base.h      |  1 +
>   4 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index b65d7a0a5df1..39d93357db65 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -116,6 +116,7 @@ void core_tmr_abort_task(
>   	struct se_tmr_req *tmr,
>   	struct se_session *se_sess)
>   {
> +	LIST_HEAD(aborted_list);
>   	struct se_cmd *se_cmd, *next;
>   	unsigned long flags;
>   	bool rc;
> @@ -144,7 +145,7 @@ void core_tmr_abort_task(
>   		if (!rc)
>   			continue;
>   
> -		list_del_init(&se_cmd->state_list);
> +		list_move_tail(&se_cmd->state_list, &aborted_list);
>   		se_cmd->state_active = false;
>   
>   		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
> @@ -157,6 +158,11 @@ void core_tmr_abort_task(
>   			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
>   					0);
>   
> +		if (dev->transport->tmr_notify)
> +			dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
> +						   &aborted_list);
> +
> +		list_del_init(&se_cmd->state_list);
>   		target_put_cmd_and_wait(se_cmd);
>   
>   		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
> @@ -167,6 +173,9 @@ void core_tmr_abort_task(
>   	}
>   	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
> +	if (dev->transport->tmr_notify)
> +		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);

Is this needed? It seems like the backend can't do anything because 
there isn't enough info.

I saw in tcmu_tmr_notify it looks when then happens we can still do 
queue_tmr_ring, but there would be no commands. Was that intentional?


> +
>   	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
>   			tmr->ref_task_tag);
>   	tmr->response = TMR_TASK_DOES_NOT_EXIST;
> @@ -318,6 +327,11 @@ static void core_tmr_drain_state_list(
>   	}
>   	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
> +	if (dev->transport->tmr_notify)
> +		dev->transport->tmr_notify(dev, preempt_and_abort_list ?
> +					   TMR_LUN_RESET_PRO : TMR_LUN_RESET,
> +					   &drain_task_list);
> +
>   	while (!list_empty(&drain_task_list)) {
>   		cmd = list_entry(drain_task_list.next, struct se_cmd, state_list);
>   		list_del_init(&cmd->state_list);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index e6e1fa68de54..9fb0be0aa620 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2946,6 +2946,7 @@ static const char *target_tmf_name(enum tcm_tmreq_table tmf)
>   	case TMR_LUN_RESET:		return "LUN_RESET";
>   	case TMR_TARGET_WARM_RESET:	return "TARGET_WARM_RESET";
>   	case TMR_TARGET_COLD_RESET:	return "TARGET_COLD_RESET";
> +	case TMR_LUN_RESET_PRO:		return "LUN_RESET_PRO";
>   	case TMR_UNKNOWN:		break;
>   	}
>   	return "(?)";
> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
> index f51452e3b984..6336780d83a7 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -40,6 +40,8 @@ struct target_backend_ops {
>   	ssize_t (*show_configfs_dev_params)(struct se_device *, char *);
>   
>   	sense_reason_t (*parse_cdb)(struct se_cmd *cmd);
> +	void (*tmr_notify)(struct se_device *se_dev, enum tcm_tmreq_table,
> +			   struct list_head *aborted_cmds);
>   	u32 (*get_device_type)(struct se_device *);
>   	sector_t (*get_blocks)(struct se_device *);
>   	sector_t (*get_alignment_offset_lbas)(struct se_device *);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 18c3f277b770..549947d407cf 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -207,6 +207,7 @@ enum tcm_tmreq_table {
>   	TMR_LUN_RESET		= 5,
>   	TMR_TARGET_WARM_RESET	= 6,
>   	TMR_TARGET_COLD_RESET	= 7,
> +	TMR_LUN_RESET_PRO	= 0x80,
>   	TMR_UNKNOWN		= 0xff,
>   };
>   
> 

