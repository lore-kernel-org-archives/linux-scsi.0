Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8811C388F7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 19:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7C62087D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 19:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U9eR4nIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgKETQH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 14:16:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgKETQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 14:16:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5J9EHW013558;
        Thu, 5 Nov 2020 19:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KvvG5TT9NZ9sxhdA8+ScR/AAkvRO1N29HYALFB/X8qw=;
 b=U9eR4nIWyWmRxJ631VV1Yc3HwMEkuqiGA7c1yxtOe7tF0tyh7WznO0LuUARNyuSrw0f3
 sgWnBlxZDQMLGsb8+Hga3UL3vrAp4M9MvHZigx9XZm6Abou69JWDRTcfcVjeQzmDBTAI
 RWBqKFGr+xjaVdegWmAGR3EYx5LaXCiWqxTk9Q/i2unSY4yST30rsda+287ljX6fWH8c
 KB7g/byi/hDdPgqWVdGkfO/hQ0pRtbnY802/t3kLjwA9vMEQ5oefx8zOX1N0uY4DtA7p
 4KVAcBFGVo6l6ed/pQkotBe91yRVNuDZm217asc7JvM0Eg62533U5ur0pP/EwcwP9N6z Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34hhw2wnre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 19:15:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5JB62J087973;
        Thu, 5 Nov 2020 19:15:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34hw0hvke0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 19:15:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A5JFqgq012884;
        Thu, 5 Nov 2020 19:15:52 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Nov 2020 11:15:52 -0800
Subject: Re: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
 <e575da88-8b40-3062-9835-419456b46989@oracle.com>
 <08d150e63f2b79cd0199fb49355ce601@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
Date:   Thu, 5 Nov 2020 13:15:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <08d150e63f2b79cd0199fb49355ce601@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/20 11:27 AM, Muneendra Kumar M wrote:
> Hi Mike,
> Thanks for the input.
> Below are my replies.
> 
> 
>> Hey sorry for the late reply. I was trying to test some things out but am
>> not sure if all drivers work the same.
> 
>> For the code above, what will happen if we have passed that check in the
>> driver, then the driver does the report del and add sequence? Let's say
>> it's initially calling the abort callout, and we passed that check, we then
>> do the >del/add seqeuence, what will happen next? Do the fc drivers return
>> success or failure for the abort call. What happens for the other callouts
>> too?
> 
>> If failure, then the eh escalates and when we call the next callout, and we
>> hit the check above and will clear it, so we are ok.
> 
> If success then we would not get a chance to clear it right?
> [Muneendra]Agreed. So what about clearing the flags in fc_remote_port_del. I
> think this should address all the concerns?
> 
>> If this is the case, then I think you need to instead go the route where
>> you add the eh cmd completion/decide_disposition callout. You would call
>> it in scmd_eh_abort_handler, scsi_eh_bus_device_reset, etc when we are
>> deciding if we want to retry/fail the command.
> [Muneendra]Sorry I didn't get what you are saying could you please elaborate
> on the same.
> 
> In this approach you do not need the eh_timed_out changes, since we only
> seem to care about the port state after the eh callout has completed.
> [Muneendra]what about setting the SCMD_NORETRIES_ABORT bit?
> 

I don't think you need it. It sounds like we only care about the port state
when the cmd is completing. For example we have:

1. the case where the cmd times out, we do aborts/resets, then the
port state goes into marginal, then the aborts/resets complete. We want to
fail the cmds without retries.

2. If the port state is in marginal, the cmd times out, we do the aborts/resets
and when we are done if the port state is still marginal we want to fail the
cmd without retries.

3. If the port state is marginal (or any value), before or after the cmd
initially times out, but the port state goes back to online, then when the
aborts/resets complete we want to retry the cmd.

So can we just add a callout to check the port state when the eh has completed
like the untested unfinished patch below:


diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 983eeb0..8ad3a9a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6041,6 +6041,7 @@ struct scsi_host_template lpfc_template = {
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_timed_out		= fc_eh_timed_out,
+	.eh_timed_out		= fc_eh_should_retry_cmd,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f11f51e..7c66d17 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -140,6 +140,7 @@ static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *host = sdev->host;
 	int rtn;
 
 	if (scsi_host_eh_past_deadline(sdev->host)) {
@@ -159,7 +160,8 @@ static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
 						    "eh timeout, not retrying "
 						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
-				   scsi_cmd_retry_allowed(scmd)) {
+				   scsi_cmd_retry_allowed(scmd) &&
+				   host->hostt->eh_should_retry_cmd(scmd)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
@@ -2105,7 +2107,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd)) {
+		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
+		    host->hostt->eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2ff7f06..7011963 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2043,6 +2043,18 @@ static int fc_vport_match(struct attribute_container *cont,
 	return &i->vport_attr_cont.ac == cont;
 }
 
+bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
+
+	if (rport->port_state == FC_PORTSTATE_MARGINAL)
+		return false;
+
+	/* Other port states will set the sdev state */
+	/* TODO check comment above */ 
+	return true;
+}
+EXPORT_SYMBOL_GPL(fc_eh_should_retry_cmd);
 
 /**
  * fc_eh_timed_out - FC Transport I/O timeout intercept handler
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 701f178..51d5af0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -315,6 +315,13 @@ struct scsi_host_template {
 	 */
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
+	/*
+	 * Optional routine that allows the transport to decide if a cmd is
+	 * retryable. Return true if the transport is in a state the cmd
+	 * should be retried on.
+	 */
+	bool (*eh_should_retry_cmd)(struct scsi_cmnd *);
+
 	/* This is an optional routine that allows transport to initiate
 	 * LLD adapter or firmware reset using sysfs attribute.
 	 *
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 1c7dd35..f21b583 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -803,6 +803,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 int fc_block_rport(struct fc_rport *rport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
 enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
+bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);
 
 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
 {


