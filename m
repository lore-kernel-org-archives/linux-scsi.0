From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv6 8/8] scsi: inline command aborts
Date: Wed, 19 Apr 2017 22:14:52 -0400
Message-ID: <yq1fuh3rfj7.fsf@oracle.com>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
        <1491485796-44411-9-git-send-email-hare@suse.de>
        <1491869956.4199.35.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17514 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753617AbdDTCPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:15:10 -0400
In-Reply-To: <1491869956.4199.35.camel@sandisk.com> (Bart Van Assche's message
        of "Tue, 11 Apr 2017 00:19:17 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

> On Thu, 2017-04-06 at 15:36 +0200, Hannes Reinecke wrote:
>> The block layer always calls the timeout function from a workqueue
>> context, so there is no need to have yet another workqueue for
>> running command aborts.
>> 
>> [ ... ]
>> @@ -271,10 +266,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>>  		rtn = host->hostt->eh_timed_out(scmd);
>>  
>>  	if (rtn == BLK_EH_NOT_HANDLED) {
>> -		if (scsi_abort_command(scmd) != SUCCESS) {
>> +		int ret;
>> +
>> +		ret = scsi_abort_command(scmd);
>> +		if (ret == FAILED) {
>>  			set_host_byte(scmd, DID_TIME_OUT);
>>  			scsi_eh_scmd_add(scmd);
>> -		}
>> +		} else if (ret == FAST_IO_FAIL)
>> +			rtn = BLK_EH_RESET_TIMER;
>>  	}
>
> Has this patch been tested with the traditional block layer? For the
> traditional block layer scsi_times_out() is called with the queue lock
> held. Does this patch cause .eh_abort_handler(), a function that may
> sleep, to be called with the queue lock held?

Hannes: Ping!

-- 
Martin K. Petersen	Oracle Linux Engineering
