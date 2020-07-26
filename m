Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9816C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81AEC2076A
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 05:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YG/I6oCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgGZFSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 01:18:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgGZFSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 01:18:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q5C6WM014638;
        Sun, 26 Jul 2020 05:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QktKNy7p43bAgE7dQ3QXhm+togrKjiXOhqm7RUv5MUI=;
 b=YG/I6oCLt4jvGrbHt7h19sL2d5AzscXqnZ6nPD8OSdPOLxlUg37B3aYJmrm1Z9mbcNGJ
 YhLFC1MqLnWbVSk0HClV5cL0lQt3qxF/QwvJLV0xwC/O4TZ37ruldK5JvjTO302kxN8r
 dE/HVw/I5ZjcSX7glnX7pjZm27+x+VT5323vsq5dO7yBFqq3MnDiYOXSnn+uonB6GlEM
 ApvpAZC4F9yLqyLPAt01OKQGRnedGpKo8jdQcKkJTsWnDudAwewivWvV5GxFikotugJr
 CZDSU+qgZ1D1BZ4N3x4lvo/BLwhdB9UDU5qK+gyRY6uY8D53xhr4yli47TpIojY7S4SD zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32gxd3gbvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 05:18:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06Q5CZZt024547;
        Sun, 26 Jul 2020 05:16:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32gxajfs4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 05:16:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06Q5GRVs024582;
        Sun, 26 Jul 2020 05:16:27 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 22:16:27 -0700
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
Date:   Sun, 26 Jul 2020 00:16:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=2 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 suspectscore=2
 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/20 11:04 AM, Bodo Stroesser wrote:
> Fix:
> After calling the aborted_task callback the core immediately
> releases the se_cmd that represents the ABORT_TASK. The woken
> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
> and tl_cmd in case of aborted TMRs.

The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?

The way you coded it below so we don't need TARGET_SCF_ACK_KREF seems ok. I was just thinking that the above chunk of patch description could be dropped, or we need to fix some other drivers because they are doing something similar to loop before your patch.


> 
> So I changed aborted_task and queue_tm_rsp to transfer result
> code from se_cmd to tcm_loop_issue_tmr's stack and added the
> missing wake_up() to aborted_task.
> Now tcm_loop_issue_tmr after waking up no longer accesses se_cmd
> and tl_cmd. Therefore tcm_loop_issue_tmr no longer needs to call
> target_put_sess_cmd and flag TARGET_SCF_ACK_KREF is no longer
> needed in se_cmd.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/loopback/tcm_loop.c | 39 ++++++++++++++++++++++----------------
>  drivers/target/loopback/tcm_loop.h |  4 +++-
>  2 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 16d5a4e117a2..0968bc8b6640 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -199,6 +199,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
>  	struct tcm_loop_nexus *tl_nexus;
>  	struct tcm_loop_cmd *tl_cmd;
>  	int ret = TMR_FUNCTION_FAILED, rc;
> +	DECLARE_COMPLETION_ONSTACK(compl);
>  
>  	/*
>  	 * Locate the tl_nexus and se_sess pointers
> @@ -213,26 +214,23 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
>  	if (!tl_cmd)
>  		return ret;
>  
> -	init_completion(&tl_cmd->tmr_done);
> +	tl_cmd->is_tmr = true;
> +	tl_cmd->tmr_done = &compl;
> +	tl_cmd->tmr_result = &ret;
>  
>  	se_cmd = &tl_cmd->tl_se_cmd;
>  	se_sess = tl_tpg->tl_nexus->se_sess;
>  
>  	rc = target_submit_tmr(se_cmd, se_sess, tl_cmd->tl_sense_buf, lun,
> -			       NULL, tmr, GFP_KERNEL, task,
> -			       TARGET_SCF_ACK_KREF);
> -	if (rc < 0)
> -		goto release;
> -	wait_for_completion(&tl_cmd->tmr_done);
> -	ret = se_cmd->se_tmr_req->response;
> -	target_put_sess_cmd(se_cmd);
> +			       NULL, tmr, GFP_KERNEL, task, 0);
> +	if (rc < 0) {
> +		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
> +		return ret;
> +	}
>  
> -out:
> -	return ret;
> +	wait_for_completion(tl_cmd->tmr_done);
>  
> -release:
> -	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
> -	goto out;
> +	return ret;
>  }
>  
>  static int tcm_loop_abort_task(struct scsi_cmnd *sc)
> @@ -590,13 +588,22 @@ static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
>  	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
>  				struct tcm_loop_cmd, tl_se_cmd);
>  
> -	/* Wake up tcm_loop_issue_tmr(). */
> -	complete(&tl_cmd->tmr_done);
> +	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
> +	*tl_cmd->tmr_result = se_cmd->se_tmr_req->response;
> +	complete(tl_cmd->tmr_done);
>  }
>  
>  static void tcm_loop_aborted_task(struct se_cmd *se_cmd)
>  {
> -	return;
> +	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
> +				struct tcm_loop_cmd, tl_se_cmd);
> +
> +	if (!tl_cmd->is_tmr)
> +		return;
> +
> +	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
> +	*tl_cmd->tmr_result = TMR_FUNCTION_REJECTED;
> +	complete(tl_cmd->tmr_done);
>  }
>  
>  static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
> diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
> index d3110909a213..e7615b9f5ed1 100644
> --- a/drivers/target/loopback/tcm_loop.h
> +++ b/drivers/target/loopback/tcm_loop.h
> @@ -17,7 +17,9 @@ struct tcm_loop_cmd {
>  	/* The TCM I/O descriptor that is accessed via container_of() */
>  	struct se_cmd tl_se_cmd;
>  	struct work_struct work;
> -	struct completion tmr_done;
> +	struct completion *tmr_done;
> +	bool is_tmr;
> +	int *tmr_result;
>  	/* Sense buffer that will be mapped into outgoing status */
>  	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
>  };
> 

