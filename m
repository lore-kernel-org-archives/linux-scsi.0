Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC57C4742C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 23:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A9C120679
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 23:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LdM1wtFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbgKJXIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:08:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgKJXIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 18:08:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAMxG8s036617;
        Tue, 10 Nov 2020 23:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j6iPz8m6B+bpOb6wS9Lj/r5nqSr89y1Jd5OMqVgfyRQ=;
 b=LdM1wtFuUuL82Po4Ca5Hr00Y4bK7j2fHeRPys/0L8ZfK7KZfHgt5eFQ3gsy5WdNSAZ4j
 vGdtOLkssj31bHDd6bPBXGvAXM4P06eNkLBAlpuERzBb/SkEhdQbNs4M7RSd9n1gx0g4
 7Rh5IrBTL36DJHZVT5DL+wVNNlvRKx7GRW13jD6KCUL3QdnBPasuIz/SU9xk0VBPDAVL
 rrZC62VDPBN2jrMO/4wMmrxukM1nJkXidKZUaG9wKKsTp7UJm++VFnhVRN5lD+8FUq7s
 9XZQod+GlayYJWievYxArEiFmClFF+joguZWgJJ1tgnQ9rW/fRo1O7BGfSz5L206UU51 KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72emm4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 23:08:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAN55I9165794;
        Tue, 10 Nov 2020 23:08:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7h484-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 23:08:07 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAN85H8024433;
        Tue, 10 Nov 2020 23:08:05 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 15:08:05 -0800
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, m.lombardi85@gmail.com
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <d7107857-ef7a-3c88-8146-a5e7abce5ce6@oracle.com>
 <840cb2fe-5642-78d0-e700-d3652021cb5d@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4e336e71-2739-186d-1f8a-5a2f406aebdb@oracle.com>
Date:   Tue, 10 Nov 2020 17:08:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <840cb2fe-5642-78d0-e700-d3652021cb5d@redhat.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=2 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/20 3:29 PM, Maurizio Lombardi wrote:
> 
> 
> Dne 28. 10. 20 v 21:37 Mike Christie napsal(a):
>>>
>>> Possible solutions that I can think of:
>>>
>>> - Make iscsit_release_commands_from_conn() wait for the abort task to finish
>>
>> Yeah you could set a completion in there then have aborted_task do the complete() call maybe?
>>
> 
> We could do something like this, what do you think?
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 067074ef50818..ffd3dbc53a42f 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -490,13 +490,16 @@ EXPORT_SYMBOL(iscsit_queue_rsp);
>   
>   void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   {
> +	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
> +
>   	spin_lock_bh(&conn->cmd_lock);
> -	if (!list_empty(&cmd->i_conn_node) &&
> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
> +	if (!list_empty(&cmd->i_conn_node))
>   		list_del_init(&cmd->i_conn_node);
>   	spin_unlock_bh(&conn->cmd_lock);
>   
>   	__iscsit_free_cmd(cmd, true);
> +	if (se_cmd && se_cmd->abrt_task_compl)
> +		complete(se_cmd->abrt_task_compl);
>   }
>   EXPORT_SYMBOL(iscsit_aborted_task);
>   
> @@ -4080,6 +4083,7 @@ int iscsi_target_rx_thread(void *arg)
>   
>   static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>   {
> +	DECLARE_COMPLETION_ONSTACK(compl);
>   	LIST_HEAD(tmp_list);
>   	struct iscsi_cmd *cmd = NULL, *cmd_tmp = NULL;
>   	struct iscsi_session *sess = conn->sess;
> @@ -4096,8 +4100,24 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>   
>   		if (se_cmd->se_tfo != NULL) {
>   			spin_lock_irq(&se_cmd->t_state_lock);
> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
> +				/*
> +				 * LIO's abort path owns the cleanup for this,
> +				 * so put it back on the list and let
> +				 * aborted_task handle it.
> +				 */
> +				list_move_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
> +				WARN_ON_ONCE(se_cmd->abrt_task_compl);
> +				se_cmd->abrt_task_compl = &compl;
> +			}
>   			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>   			spin_unlock_irq(&se_cmd->t_state_lock);
> +
> +			if (se_cmd->abrt_task_compl) {
> +				spin_unlock_bh(&conn->cmd_lock);
> +				wait_for_completion(&compl);
> +				spin_lock_bh(&conn->cmd_lock);

You can still hit your freed conn race I think. The aborted_task callout 
is not the last time we are referencing the iscsi cmd and conn. That 
code path still has to do the release_cmd callout for example. Once we 
get past this wait_for_completion the abort code path could be still 
running. If this iscsit_release_commands_from_conn completes first then 
we can hit your case where we free the conn before the abort code path 
has done release_cmd and we could hit that cmd->conn->sess reference.

I think if you do the complete in iscsit_release_cmd then we would not 
hit that issue.

There might be a second issue though. What happens if aborted_task ran 
first and deleted the cmd from the conn_cmd_list. It would then be 
running while iscsit_release_commands_from_conn is running. We would 
then not do the wait_for_completion above.


> +			}
>   		}
>   	}
>   	spin_unlock_bh(&conn->cmd_lock);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index db53a0d649da7..5611e6c00f18c 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1391,6 +1391,7 @@ void transport_init_se_cmd(
>   	init_completion(&cmd->t_transport_stop_comp);
>   	cmd->free_compl = NULL;
>   	cmd->abrt_compl = NULL;
> +	cmd->abrt_task_compl = NULL;
>   	spin_lock_init(&cmd->t_state_lock);
>   	INIT_WORK(&cmd->work, NULL);
>   	kref_init(&cmd->cmd_kref);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 549947d407cfd..25cc451930281 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -491,6 +491,7 @@ struct se_cmd {
>   	struct list_head	se_cmd_list;
>   	struct completion	*free_compl;
>   	struct completion	*abrt_compl;
> +	struct completion	*abrt_task_compl;

This should be on the iscsi cmd since only iscsi uses it.

>   	const struct target_core_fabric_ops *se_tfo;
>   	sense_reason_t		(*execute_cmd)(struct se_cmd *);
>   	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
> 

