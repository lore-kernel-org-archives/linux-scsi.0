Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44D0C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5771220643
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="fubDvqaI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgEROuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 10:50:15 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:16896 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbgEROuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 10:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589813409; i=@ts.fujitsu.com;
        bh=UklrNRpQLPxu/j3bbNyAAohNBVING2UH7Rpo60evUHI=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=fubDvqaIfGYKI0fw6WmyMAJq2YtxkGqhzzl3VHh+pFfouDUKgvJoPjpmrCD5w3CUq
         G2wHyUSDr1hId81LnSsYwnY/Yp3UVpISFOmUmnBcWNFIupuifI7n5LOZecMRKMgzvq
         9Ymhdo/QbzbbqDjOXfwrOWRMSA+gc69AgFBv5DABfv81QcSi5Ko1k/S6UF+pxeNP40
         DMHAX6il7NbcDxFTqyqwwisIsCeXr0tsdU7NI1Hhi92nzEk0wJ8MM/HWLCtOSQGMLW
         J2anLNHNwjHbSSgMHWl7jW0y9JNq07oV0AlRsZeDbbx1GA0xAAf87ntnmeF72sDMFt
         E24NEWQ6wRNvg==
Received: from [100.113.2.218] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id 39/4F-37389-1A0A2CE5; Mon, 18 May 2020 14:50:09 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRWlGSWpSXmKPExsViZ8MRortwwaE
  4g12rRCy6r+9gs1h+/B+TxfojGxgtWpe+ZXJg8fj49BaLx/t9V9k8Pm+SC2COYs3MS8qvSGDN
  2LJtPnNBT3JF4489rA2Mp/y7GLk4hAQmM0oc3vGdsYuRE8jpZ5RY8VkNxBYWCJXY9uUbM0iRi
  EAro8Trz1PZIIoKJY4s3c4MYrMJGEismHSfBcTmFXCU6Fk/BcxmEVCVWDDhOjuILSoQLvFiyx
  9WiBpBiZMznwDVcHBwCthJzFtYCRJmFjCTmLf5ITOELS5x68l8JghbXmL72znMExj5ZiHpnoW
  kZRaSlllIWhYwsqxitEgqykzPKMlNzMzRNTQw0DU0NNY11DW10Eus0k3USy3VTU7NKylKBErq
  JZYX6xVX5ibnpOjlpZZsYgSGdUoho9UOxq1r3+sdYpTkYFIS5Q0vORQnxJeUn1KZkVicEV9Um
  pNafIhRhoNDSYJXfgZQTrAoNT21Ii0zBxhjMGkJDh4lEd5D84HSvMUFibnFmekQqVOMuhwnVy
  1ZxCzEkpeflyolzvt0HlCRAEhRRmke3AhYvF9ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMx
  7EWQVT2ZeCdymV0BHMAEd4XpxH8gRJYkIKakGpm2XsqLWVXWcXF6c1vvmaPC6gwbnuzQc5jbM
  muLpvbB/+fyQlb3Lrok5luz19uxmcLrvy7rx8QHj9S3tt9f1n3OZ8qbAsGdLM+8ulXhlp5e/I
  ystnT1P2pvoihhsjQtcIsYWc/XYQckG83jjcw+evviyyJXn2t4vlgnHMhzjf4n4qUd5hfpPiH
  nCZx3QpzXnuXhk3e19R5feSHCuX77fxEtdtDIph4FxC3vQw2RdjqPBCueCuzZzGRec8r99vis
  qgnvWtjmCzBXeP5v3s2SXWX54JtP/1kc45U3lZKeQqp1ZVZP139xtfmNybfvyO9dlk7enOCq9
  6fmxiiPcS9HeZoXfwf0chjJr1uqbzVZQYinOSDTUYi4qTgQAs8ube3IDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-39.tower-232.messagelabs.com!1589813408!195545!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23043 invoked from network); 18 May 2020 14:50:09 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-39.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 May 2020 14:50:09 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04IEo5Ih020740;
        Mon, 18 May 2020 15:50:05 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 0263F2067E;
        Mon, 18 May 2020 16:49:54 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: tcmu: userspace must not complete queued
 commands
To:     Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200512154250.12310-1-bstroesser@ts.fujitsu.com>
 <06ebddec-bd10-2ac6-2435-eb3019352c5f@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <caa87b41-340b-2448-8e67-73f627b51f1e@ts.fujitsu.com>
Date:   Mon, 18 May 2020 16:49:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <06ebddec-bd10-2ac6-2435-eb3019352c5f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/17/20 22:38, Mike Christie wrote:
> On 5/12/20 10:42 AM, Bodo Stroesser wrote:
>> When tcmu queues a new command - no matter whether in command
>> ring or in qfull_queue - a cmd_id from IDR udev->commands is
>> assigned to the command.
>>
>> If userspaces sends a wrong command completion containing the
>> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
>> finds the command in the IDR and calls tcmu_handle_completion()
>> for it. This might do some nasty things, because commands in
>> qfull_queue do not have a valid dbi list.
>>
>> To fix this bug, we no longer add queued commands to the idr.
>> Instead the cmd_id is assign when a command is written to
>> the command ring.
>>
>> Due to this change I had to adapt the source code at several
>> places where up to now an idr_for_each had been done.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_user.c | 154 ++++++++++++++++++--------------------
>>   1 file changed, 71 insertions(+), 83 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index f769bb1e3735..de75583b74c6 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -882,41 +882,24 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
>>   	return command_size;
>>   }
>>   
>> -static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
>> -				struct timer_list *timer)
>> +static void tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
>> +				 struct timer_list *timer)
>>   {
>> -	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>> -	int cmd_id;
>> -
>> -	if (tcmu_cmd->cmd_id)
>> -		goto setup_timer;
>> -
>> -	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
>> -	if (cmd_id < 0) {
>> -		pr_err("tcmu: Could not allocate cmd id.\n");
>> -		return cmd_id;
>> -	}
>> -	tcmu_cmd->cmd_id = cmd_id;
>> -
>> -	pr_debug("allocated cmd %u for dev %s tmo %lu\n", tcmu_cmd->cmd_id,
>> -		 udev->name, tmo / MSEC_PER_SEC);
>> -
>> -setup_timer:
>>   	if (!tmo)
>> -		return 0;
>> +		return;
>>   
>>   	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
>>   	if (!timer_pending(timer))
>>   		mod_timer(timer, tcmu_cmd->deadline);
>>   
>> -	return 0;
>> +	pr_debug("Timeout set up for cmd %p, dev = %s, tmo = %lu\n", tcmu_cmd,
>> +		 tcmu_cmd->tcmu_dev->name, tmo / MSEC_PER_SEC);
>>   }
>>   
>>   static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
>>   {
>>   	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>>   	unsigned int tmo;
>> -	int ret;
>>   
>>   	/*
>>   	 * For backwards compat if qfull_time_out is not set use
>> @@ -931,13 +914,11 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
>>   	else
>>   		tmo = TCMU_TIME_OUT;
>>   
>> -	ret = tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
>> -	if (ret)
>> -		return ret;
>> +	tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
>>   
>>   	list_add_tail(&tcmu_cmd->queue_entry, &udev->qfull_queue);
>> -	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
>> -		 tcmu_cmd->cmd_id, udev->name);
>> +	pr_debug("adding cmd %p on dev %s to ring space wait queue\n",
>> +		 tcmu_cmd, udev->name);
>>   	return 0;
>>   }
>>   
>> @@ -959,7 +940,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>>   	struct tcmu_mailbox *mb;
>>   	struct tcmu_cmd_entry *entry;
>>   	struct iovec *iov;
>> -	int iov_cnt, ret;
>> +	int iov_cnt, cmd_id;
>>   	uint32_t cmd_head;
>>   	uint64_t cdb_off;
>>   	bool copy_to_data_area;
>> @@ -1060,14 +1041,21 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>>   	}
>>   	entry->req.iov_bidi_cnt = iov_cnt;
>>   
>> -	ret = tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out,
>> -				   &udev->cmd_timer);
>> -	if (ret) {
>> -		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
>> +	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
>> +	if (cmd_id < 0) {
>> +		pr_err("tcmu: Could not allocate cmd id.\n");
>>   
>> +		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
>>   		*scsi_err = TCM_OUT_OF_RESOURCES;
>>   		return -1;
>>   	}
>> +	tcmu_cmd->cmd_id = cmd_id;
>> +
>> +	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
>> +		 tcmu_cmd, udev->name);
>> +
>> +	tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out, &udev->cmd_timer);
>> +
>>   	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
>>   
>>   	/*
>> @@ -1279,50 +1267,39 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
>>   	return handled;
>>   }
>>   
>> -static int tcmu_check_expired_cmd(int id, void *p, void *data)
>> +static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
>>   {
>> -	struct tcmu_cmd *cmd = p;
>> -	struct tcmu_dev *udev = cmd->tcmu_dev;
>> -	u8 scsi_status;
>>   	struct se_cmd *se_cmd;
>> -	bool is_running;
>> -
>> -	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
>> -		return 0;
>>   
>>   	if (!time_after(jiffies, cmd->deadline))
>> -		return 0;
>> +		return;
>>   
>> -	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
>> +	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
>> +	list_del_init(&cmd->queue_entry);
>>   	se_cmd = cmd->se_cmd;
>> +	cmd->se_cmd = NULL;
>>   
>> -	if (is_running) {
>> -		/*
>> -		 * If cmd_time_out is disabled but qfull is set deadline
>> -		 * will only reflect the qfull timeout. Ignore it.
>> -		 */
>> -		if (!udev->cmd_time_out)
>> -			return 0;
>> +	pr_debug("Timing out inflight cmd %u on dev %s.\n",
>> +		 cmd->cmd_id, cmd->tcmu_dev->name);
>>   
>> -		set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
>> -		/*
>> -		 * target_complete_cmd will translate this to LUN COMM FAILURE
>> -		 */
>> -		scsi_status = SAM_STAT_CHECK_CONDITION;
>> -		list_del_init(&cmd->queue_entry);
>> -		cmd->se_cmd = NULL;
>> -	} else {
>> -		list_del_init(&cmd->queue_entry);
>> -		idr_remove(&udev->commands, id);
>> -		tcmu_free_cmd(cmd);
>> -		scsi_status = SAM_STAT_TASK_SET_FULL;
>> -	}
>> +	target_complete_cmd(se_cmd, SAM_STAT_CHECK_CONDITION);
>> +}
>>   
>> -	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
>> -		 id, udev->name, is_running ? "inflight" : "queued");
>> +static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
>> +{
>> +	struct se_cmd *se_cmd;
>>   
>> -	target_complete_cmd(se_cmd, scsi_status);
>> -	return 0;
>> +	if (!time_after(jiffies, cmd->deadline))
>> +		return;
>> +
>> +	list_del_init(&cmd->queue_entry);
>> +	se_cmd = cmd->se_cmd;
>> +	tcmu_free_cmd(cmd);
>> +
>> +	pr_debug("Timing out queued cmd %p on dev %s.\n",
>> +		  cmd, cmd->tcmu_dev->name);
>> +
>> +	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
>>   }
>>   
>>   static void tcmu_device_timedout(struct tcmu_dev *udev)
>> @@ -1407,16 +1384,15 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
>>   	return &udev->se_dev;
>>   }
>>   
>> -static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
>> +static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
>>   {
>>   	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
>>   	LIST_HEAD(cmds);
>> -	bool drained = true;
>>   	sense_reason_t scsi_ret;
>>   	int ret;
>>   
>>   	if (list_empty(&udev->qfull_queue))
>> -		return true;
>> +		return;
>>   
>>   	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
>>   
>> @@ -1425,11 +1401,10 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
>>   	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
>>   		list_del_init(&tcmu_cmd->queue_entry);
>>   
>> -	        pr_debug("removing cmd %u on dev %s from queue\n",
>> -		         tcmu_cmd->cmd_id, udev->name);
>> +	        pr_debug("removing cmd %p on dev %s from queue\n",
>> +		         tcmu_cmd, udev->name);
>>   
>>   		if (fail) {
>> -			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
>>   			/*
>>   			 * We were not able to even start the command, so
>>   			 * fail with busy to allow a retry in case runner
>> @@ -1444,10 +1419,8 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
>>   
>>   		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
>>   		if (ret < 0) {
>> -		        pr_debug("cmd %u on dev %s failed with %u\n",
>> -			         tcmu_cmd->cmd_id, udev->name, scsi_ret);
>> -
>> -			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
>> +		        pr_debug("cmd %p on dev %s failed with %u\n",
>> +			         tcmu_cmd, udev->name, scsi_ret);
>>   			/*
>>   			 * Ignore scsi_ret for now. target_complete_cmd
>>   			 * drops it.
>> @@ -1462,13 +1435,11 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
>>   			 * the queue
>>   			 */
>>   			list_splice_tail(&cmds, &udev->qfull_queue);
>> -			drained = false;
>>   			break;
>>   		}
>>   	}
>>   
>>   	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
>> -	return drained;
>>   }
>>   
>>   static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
>> @@ -1652,6 +1623,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
>>   		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
>>   			all_expired = false;
>>   	}
>> +	if (!list_empty(&udev->qfull_queue))
>> +		all_expired = false;
> 
> Just drop.

This patch should just fix a bug, but not change behavior of
tcmu. Therefore I think the two additional lines are necessary
to keep a consistent behavior.

> It's never going to happen and doesn't tell us a lot. We
> don't know what list it was on and why LIO core's refcounts got messed up
I agree.

> 
> The WARN_ON should just be removed in some other patchset one day. If we
> wanted to detect if non timed out commands were running at this time
> then it should go in lio core, because it would be a problem that
> affects all drivers.

I agree.

In this case we can remove or change the additional two lines again
together with the other stuff.

> 
> I think we actually want the opposite and should WARN or BUG if commands
> have timed out and we are freeing the device.

Better not BUG, but WARN but be ok, I think.

> In this case userspace
> could still be accessing the buffers we are going to free. It probably

No. Userspace can access the uio device only, if it has mapped the
uio space. But in that case userspace holds a ref_cnt of the tcmu_dev
and therefore tcmu_dev_kref_release cannot happen at that time.

> won't happen now that we run this from the release function and so the
> device is closed though.
> 
> 
> 
>>   	idr_destroy(&udev->commands);
>>   	WARN_ON(!all_expired);
>>   
>> @@ -2037,9 +2010,6 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>>   	mutex_lock(&udev->cmdr_lock);
>>   
>>   	idr_for_each_entry(&udev->commands, cmd, i) {
>> -		if (!test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags))
>> -			continue;
>> -
>>   		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
>>   			  cmd->cmd_id, udev->name,
>>   			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
>> @@ -2077,6 +2047,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>>   
>>   	del_timer(&udev->cmd_timer);
>>   
>> +	run_qfull_queue(udev, false);
>> +
>>   	mutex_unlock(&udev->cmdr_lock);
>>   }
>>   
>> @@ -2698,6 +2670,7 @@ static void find_free_blocks(void)
>>   static void check_timedout_devices(void)
>>   {
>>   	struct tcmu_dev *udev, *tmp_dev;
>> +	struct tcmu_cmd *ucmd, *tmp_cmd;
> 
> ucmd probably would have been best when the code was first written. Now,
> you should use tcmu_cmd or cmd to match the existing naming style.

Ok. I'll change it.

> 
> 
>>   	LIST_HEAD(devs);
>>   
>>   	spin_lock_bh(&timed_out_udevs_lock);
>> @@ -2708,9 +2681,24 @@ static void check_timedout_devices(void)
>>   		spin_unlock_bh(&timed_out_udevs_lock);
>>   
>>   		mutex_lock(&udev->cmdr_lock);
>> -		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
>>   
>> -		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
>> +		/*
>> +		 * If cmd_time_out is disabled but qfull is set deadline
>> +		 * will only reflect the qfull timeout. Ignore it.
>> +		 */
>> +		if (udev->cmd_time_out) {
>> +			list_for_each_entry_safe(ucmd, tmp_cmd,
>> +			                         &udev->inflight_queue,
>> +			                         queue_entry) {
>> +				tcmu_check_expired_ring_cmd(ucmd);
>> +			}
>> +			tcmu_set_next_deadline(&udev->inflight_queue,
>> +			                       &udev->cmd_timer);
>> +		}
>> +		list_for_each_entry_safe(ucmd, tmp_cmd, &udev->qfull_queue,
>> +			                 queue_entry) {
>> +			tcmu_check_expired_queue_cmd(ucmd);
>> +		}
>>   		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
>>   
>>   		mutex_unlock(&udev->cmdr_lock);
>>
> 
