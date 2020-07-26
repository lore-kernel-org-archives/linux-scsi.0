Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA5EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C58206E3
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="UILo2Xh+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgGZLDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 07:03:07 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.112]:8808 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgGZLDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 07:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595761383; i=@ts.fujitsu.com;
        bh=dOdUhEOLWC4NdC1zSe+ICXla3gXpHtTYarxpk4WlmLU=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=UILo2Xh+gMIL4PDesyZ1L9oDxc09aKV36XPFd6HvvYV0o5cu/Yu2a4W4VhNSJiI3f
         kNfWX0w/uPp4GFncQr0LAloBYtfWgLEi9q5gVezfLfkvSx+ehioUpPXkt3KT7ItWqK
         T/l5t4jradcpMzTBNDp7GROF2Bugri3fKDKDSKEzmTMX0ZT3XWKKRkigs/X4oMYifo
         mNF5K/c0iW4jkObTotW+RrDhL/8WFErkxBig8dVNo516dpfsHF4ebzN0xIPgjtyYQN
         pCli9lZWHcMc39DWWEVFc6zIv4gfDljhO94/nSQkmYNLNf5z8zNL5CQNCpDE9oJ2ZJ
         UyaaSlRZ4ZCDQ==
Received: from [100.113.5.174] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-central-1.aws.symcld.net id A6/0F-32390-6E26D1F5; Sun, 26 Jul 2020 11:03:02 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRWlGSWpSXmKPExsViZ8MxVfdZkmy
  8wb0eMYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxsvjJQWT
  DCoeTN/B2MB4Sa2LkYtDSGAyo8SqDW9YIZx+RonH168wdjFycggLuEqsXnedBSQhIrCGUWLR6
  6VMIAkhgUKJWY+ug9lsAgYSKybdZwGxeQUcJfbc/AZkc3CwCKhKXHgoCmKKCoRLPFvhD1EhKH
  Fy5hOwak4BO4lDPdfApjALqEv8mXeJGcIWl7j1ZD5UXF5i+9s5zBMY+WYhaZ+FpGUWkpZZSFo
  WMLKsYrRMKspMzyjJTczM0TU0MNA1NDTWNQeyTPUSq3ST9FJLdZNT80qKEoGyeonlxXrFlbnJ
  OSl6eaklmxiBwZxSyJ65g3Hymw96hxglOZiURHmnhcjGC/El5adUZiQWZ8QXleakFh9ilOHgU
  JLgbU8EygkWpaanVqRl5gAjCyYtwcGjJMJ7AyTNW1yQmFucmQ6ROsWoKCXO+zgBKCEAksgozY
  Nrg0XzJUZZKWFeRgYGBiGegtSi3MwSVPlXjOIcjErCvL9AxvNk5pXATX8FtJgJaLH7JUmQxSW
  JCCmpBqaKHUZJWxU6zE+dNNnEsezKEf/Xa+77pzxfv1Yjzvy079YlJUe91788tCBP6y0La35v
  +ynl+aqN295GLtt7KfPCmtdrOeo/MljOmei0UjEou5l7Rd/BeXUvHya1n9Tj5Hf9Vy/xwmDLq
  00fJS/9irBayftxwpEvS5es/8p97JLocm7/uyWLNt6Yw9C52KP/oWcHf8HBnyGcSY/vxk5Zd0
  zx5ucnwh8uiNQtT5ut92Gd2/kl/U9m9DKd8jgrfq4n+cWPR5FPrFO1rr3IEdp+Wmvjm03P/Nn
  5wqbMk50xZ1tg5T+fDS+fvOtMznBUYnoZxlen7vm2sLIha/5D7heXuiIXh+rnvNE/LJf8c7v1
  XbNVSkosxRmJhlrMRcWJAItmxzdhAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-5.tower-248.messagelabs.com!1595761381!657455!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5642 invoked from network); 26 Jul 2020 11:03:02 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-5.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 11:03:02 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QB2qnh023290;
        Sun, 26 Jul 2020 12:02:52 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 62883203E0;
        Sun, 26 Jul 2020 13:02:51 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
Date:   Sun, 26 Jul 2020 13:02:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-26 07:16, Mike Christie wrote:
> On 7/15/20 11:04 AM, Bodo Stroesser wrote:
>> Fix:
>> After calling the aborted_task callback the core immediately
>> releases the se_cmd that represents the ABORT_TASK. The woken
>> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
>> and tl_cmd in case of aborted TMRs.
> 
> The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?

No. For an aborted ABORT_TASK, target_handle_abort is called.
If tas is not set, it executes this code:

        } else {
                /*
                 * Allow the fabric driver to unmap any resources before
                 * releasing the descriptor via TFO->release_cmd().
                 */
                cmd->se_tfo->aborted_task(cmd);
                if (ack_kref)
                        WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
                /*
                 * To do: establish a unit attention condition on the I_T
                 * nexus associated with cmd. See also the paragraph "Aborting
                 * commands" in SAM.
                 */
        }

        WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);

        transport_lun_remove_cmd(cmd);

        transport_cmd_check_stop_to_fabric(cmd);

That means: no matter whether SCF_ACK_REF is set in the cmd or not:
1) fabric's aborted_task handler and a waiter woken up by aborted_task must not call target_put_sess_cmd.
2) a waiter woken up by aborted_task() must not access se_cmd (or tl_cmd) since target_handle_abort
   might have released it completely meanwhile.

OTOH, if TMR is not aborted, fabric's queue_tm_rsp() handler is called. If SCF_ACK_REF is set fabric has to release cmd_kref when it no longer needs the se_/tl_cmd. 
Due to 2) I had to change the waiting tcm_loop_issue_tmr such, that it no longer needs access to tl_/se_cmd.
After that, there was no more need for TARGET_SCF_ACK_KREF. Removing it avoids to add different handling of normal and aborted case in tcm_loop_issue_tmr.

> 
> The way you coded it below so we don't need TARGET_SCF_ACK_KREF seems ok. I was just thinking that the above chunk of patch description could be dropped, or we need to fix some other drivers because they are doing something similar to loop before your patch.
> 
> 
>>
>> So I changed aborted_task and queue_tm_rsp to transfer result
>> code from se_cmd to tcm_loop_issue_tmr's stack and added the
>> missing wake_up() to aborted_task.
>> Now tcm_loop_issue_tmr after waking up no longer accesses se_cmd
>> and tl_cmd. Therefore tcm_loop_issue_tmr no longer needs to call
>> target_put_sess_cmd and flag TARGET_SCF_ACK_KREF is no longer
>> needed in se_cmd.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/loopback/tcm_loop.c | 39 ++++++++++++++++++++++----------------
>>   drivers/target/loopback/tcm_loop.h |  4 +++-
>>   2 files changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
>> index 16d5a4e117a2..0968bc8b6640 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -199,6 +199,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
>>   	struct tcm_loop_nexus *tl_nexus;
>>   	struct tcm_loop_cmd *tl_cmd;
>>   	int ret = TMR_FUNCTION_FAILED, rc;
>> +	DECLARE_COMPLETION_ONSTACK(compl);
>>   
>>   	/*
>>   	 * Locate the tl_nexus and se_sess pointers
>> @@ -213,26 +214,23 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
>>   	if (!tl_cmd)
>>   		return ret;
>>   
>> -	init_completion(&tl_cmd->tmr_done);
>> +	tl_cmd->is_tmr = true;
>> +	tl_cmd->tmr_done = &compl;
>> +	tl_cmd->tmr_result = &ret;
>>   
>>   	se_cmd = &tl_cmd->tl_se_cmd;
>>   	se_sess = tl_tpg->tl_nexus->se_sess;
>>   
>>   	rc = target_submit_tmr(se_cmd, se_sess, tl_cmd->tl_sense_buf, lun,
>> -			       NULL, tmr, GFP_KERNEL, task,
>> -			       TARGET_SCF_ACK_KREF);
>> -	if (rc < 0)
>> -		goto release;
>> -	wait_for_completion(&tl_cmd->tmr_done);
>> -	ret = se_cmd->se_tmr_req->response;
>> -	target_put_sess_cmd(se_cmd);
>> +			       NULL, tmr, GFP_KERNEL, task, 0);
>> +	if (rc < 0) {
>> +		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
>> +		return ret;
>> +	}
>>   
>> -out:
>> -	return ret;
>> +	wait_for_completion(tl_cmd->tmr_done);
>>   
>> -release:
>> -	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
>> -	goto out;
>> +	return ret;
>>   }
>>   
>>   static int tcm_loop_abort_task(struct scsi_cmnd *sc)
>> @@ -590,13 +588,22 @@ static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
>>   	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
>>   				struct tcm_loop_cmd, tl_se_cmd);
>>   
>> -	/* Wake up tcm_loop_issue_tmr(). */
>> -	complete(&tl_cmd->tmr_done);
>> +	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
>> +	*tl_cmd->tmr_result = se_cmd->se_tmr_req->response;
>> +	complete(tl_cmd->tmr_done);
>>   }
>>   
>>   static void tcm_loop_aborted_task(struct se_cmd *se_cmd)
>>   {
>> -	return;
>> +	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
>> +				struct tcm_loop_cmd, tl_se_cmd);
>> +
>> +	if (!tl_cmd->is_tmr)
>> +		return;
>> +
>> +	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
>> +	*tl_cmd->tmr_result = TMR_FUNCTION_REJECTED;
>> +	complete(tl_cmd->tmr_done);
>>   }
>>   
>>   static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
>> diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
>> index d3110909a213..e7615b9f5ed1 100644
>> --- a/drivers/target/loopback/tcm_loop.h
>> +++ b/drivers/target/loopback/tcm_loop.h
>> @@ -17,7 +17,9 @@ struct tcm_loop_cmd {
>>   	/* The TCM I/O descriptor that is accessed via container_of() */
>>   	struct se_cmd tl_se_cmd;
>>   	struct work_struct work;
>> -	struct completion tmr_done;
>> +	struct completion *tmr_done;
>> +	bool is_tmr;
>> +	int *tmr_result;
>>   	/* Sense buffer that will be mapped into outgoing status */
>>   	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
>>   };
>>
> 
