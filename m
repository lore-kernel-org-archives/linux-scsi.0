From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] libiscsi: ensure session spin lock usage consistent
Date: Wed, 7 Feb 2018 17:42:15 -0600
Message-ID: <5A7B8ED7.2050901@redhat.com>
References: <20180205191323.5274-1-lduncan@suse.com>
 <5A7B8099.4000506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751022AbeBGXmQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 18:42:16 -0500
In-Reply-To: <5A7B8099.4000506@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>, hare@suse.de

On 02/07/2018 04:41 PM, Mike Christie wrote:
>  
>>  static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>> @@ -1908,7 +1908,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>>  
>>  	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
>>  
>> -	spin_lock(&session->lock);
>> +	spin_lock_bh(&session->lock);
>>  	task = (struct iscsi_task *)sc->SCp.ptr;
>>  	if (!task) {
>>  		/*
>> @@ -2022,7 +2022,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>>  done:
>>  	if (task)
>>  		task->last_timeout = jiffies;
>> -	spin_unlock(&session->lock);
>> +	spin_unlock_bh(&session->lock);
>>  	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
>>  		     "timer reset" : "nh");
>>  	return rc;

I guess you want this chunk too. It does not now, but someone could add
a blk_abort_request call that ends up calling into the driver.
