Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5BBC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4EF206D8
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="JtvGwCUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGZLfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 07:35:16 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.2]:35648 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgGZLfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 07:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595763312; i=@ts.fujitsu.com;
        bh=UJb5vCLk/CQ3bnpzSDNKzjC5gRDbQ7Czmb68DMr3byU=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=JtvGwCUo6aPiEind9pKpA5g24rBrV605gaMHhcpwpiNOlaln6Z31xFPhzeHX7FNOY
         w9+XxMalOutySodJqDaRSm8RNA2bpJQ39mxWef/hh3iUa1nsi2Qo9WqNbJxx2bykmM
         wp+jb7KyUNgwY79Tl5NinQflBRy8ZzqDohQE4Vso2tLeLx1i2pGIhzcxLed2Gg+3r2
         NEQX8UT6SWNOdFp3+VOtolc5P1bTWP7CmAC9GR5PgF4BGbYVwOVlcFLXqEcBVt+8th
         CCIz1hKA1HbKSnhrlDSj2G7shO4KzJAmr2UiZ6h9u7/C3Jea69l69FCbia8IADUTyY
         x51xanfsJ1E4w==
Received: from [100.112.192.94] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-west-1.aws.symcld.net id B0/EE-63291-07A6D1F5; Sun, 26 Jul 2020 11:35:12 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRWlGSWpSXmKPExsViZ8MxVTc/Szb
  eYNo9DYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxuNnPYwF
  C6Urtr+4xd7A+Easi5GLQ0hgMqPEhI3NbBBOP6PEom+9rF2MnBzCAm4SGyY8ZAFJiAisAUq8X
  soEUbWUUeLDmxYWkCo2AQOJFZPug9m8Ao4S01YcAutmEVCV+DXhNXsXIweHqEC4xLMV/hAlgh
  InZz4BK+cUsJN4+moOI4jNLKAu8WfeJWYIW1zi1pP5TBC2vMT2t3OYJzDyzULSPgtJyywkLbO
  QtCxgZFnFaJ5UlJmeUZKbmJmja2hgoGtoaKRraGmia2Gsl1ilm6iXWqpbnlpcomuol1herFdc
  mZuck6KXl1qyiREYzikFh4J3MPa9+aB3iFGSg0lJlHdaiGy8EF9SfkplRmJxRnxRaU5q8SFGG
  Q4OJQlehQygnGBRanpqRVpmDjC2YNISHDxKIrzzQdK8xQWJucWZ6RCpU4yKUuK8x0ESAiCJjN
  I8uDZYPF9ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMxbDjKFJzOvBG76K6DFTECL3S9Jgiw
  uSURISTUw5fJNConVDBH97H0gu+xvvET74sdqP266v86OuXRZKCpwgbqisnpOxpR0JQb2SRPK
  n0vdEDQSuVyxi+WLacrP+ugfx6zDjli3PfYzjmtrN4+8sGVXpq2tLr8dz6SU7Ce6d9x33TzPo
  b5iwvo9Kuv8E8SsPvS+MjK+mLbn4YOV7CKfOCZVLnt4a+mL3POM3TM2zvIw/uQ6w86MNW7emb
  +6Fxku99TmBM94ELw/NFRkX1XKjxXZKzM8ZC8s9S+NPcHzw4Lp0oO+2TJWRfP7PvrO+PBZZ/v
  9WVlvbF4qNSV7MSkXV86YOf+udjsPN4tF263OP61SPgwup/cVhnM6d59Xv/cvvadByF80ZNf/
  fhElluKMREMt5qLiRAAdnAfWYgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-35.tower-267.messagelabs.com!1595763311!456663!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 20237 invoked from network); 26 Jul 2020 11:35:11 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-35.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 11:35:11 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QBZ84p031320;
        Sun, 26 Jul 2020 12:35:08 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id D7C3120478;
        Sun, 26 Jul 2020 13:35:04 +0200 (CEST)
Subject: Re: [PATCH v2 1/8] scsi: target: Modify core_tmr_abort_task()
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
 <20200717161212.10731-2-bstroesser@ts.fujitsu.com>
 <12707afb-4821-f0d9-baff-4078b599a5ea@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <388238d9-e698-db39-ec30-b61723da0dd5@ts.fujitsu.com>
Date:   Sun, 26 Jul 2020 13:35:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <12707afb-4821-f0d9-baff-4078b599a5ea@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-26 02:03, Mike Christie wrote:
> On 7/17/20 11:12 AM, Bodo Stroesser wrote:
>> This patch modifies core_tmr_abort_task() to use same looping
>> and locking scheme as core_tmr_drain_state_list() does.
>>
>> This frees the state_list element in se_cmd for later use
>> by tmr notification handling.
>>
>> Note: __target_check_io_state() now is called with param 0
>> instead of dev->dev_attrib.emulate_tas, because tas is not
>> relevant since we always get ABRT on same session like the
>> aborted command.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_tmr.c | 22 ++++++++++++++--------
>>   1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>> index 89c84d472cd7..b65d7a0a5df1 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -116,14 +116,15 @@ void core_tmr_abort_task(
>>   	struct se_tmr_req *tmr,
>>   	struct se_session *se_sess)
>>   {
>> -	struct se_cmd *se_cmd;
>> +	struct se_cmd *se_cmd, *next;
>>   	unsigned long flags;
>> +	bool rc;
>>   	u64 ref_tag;
>>   
>> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
>> +	spin_lock_irqsave(&dev->execute_task_lock, flags);
>> +	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
>>   
>> -		if (dev != se_cmd->se_dev)
>> +		if (se_sess != se_cmd->se_sess)
>>   			continue;
>>   
>>   		/* skip task management functions, including tmr->task_cmd */
>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>   		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>>   			se_cmd->se_tfo->fabric_name, ref_tag);
>>   
>> -		if (!__target_check_io_state(se_cmd, se_sess,
>> -					     dev->dev_attrib.emulate_tas))
>> +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> 
> I don't think you can use flags twice. This call seems to be overwriting the outer spin lock caller's value, and I'm seeing a lot of warnings.

Oops. Thank you!

Bad cut and paste. I wanted to make core_tmr_abort_task similar to core_tmr_drain_state_list.
But then I moved the calls for se_sess->sess_cmd_lock inside core_tmr_abort_task instead of copying the ones from core_tmr_drain_state_list.

I'm wondering why I don't see warnings when waiting with irq blocked ...

I'll resend without _irqsave / _irqrestore.
 
> 
> 
>> +		rc = __target_check_io_state(se_cmd, se_sess, 0);
>> +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> 
> 
> Use spin_lock/spin_unlock since we know above we have disabled irqs right above. Or make the drain users work like above.
> 
> Just make it consistent so future devs don't have to wonder why we use different calls.
> 
>> +		if (!rc)
>>   			continue;
>>   
>> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);> +		list_del_init(&se_cmd->state_list);
>> +		se_cmd->state_active = false;
>> +
>> +		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>   
>>   		/*
>>   		 * Ensure that this ABORT request is visible to the LU RESET
>> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>>   		atomic_long_inc(&dev->aborts_complete);
>>   		return;
>>   	}
>> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>> +	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>   
>>   	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
>>   			tmr->ref_task_tag);
>>
> 
