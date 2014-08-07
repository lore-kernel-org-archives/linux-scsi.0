From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v1.3 4/18] arcmsr: limit max. number of SCSI command request
Date: Thu, 07 Aug 2014 14:45:00 +0200
Message-ID: <53E374CC.2070707@redhat.com>
References: <1406882389.10378.46.camel@Centos6.3-64>	 <20140801123552.GB30397@infradead.org> <1407124855.5217.23.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbaHGMqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2014 08:46:03 -0400
In-Reply-To: <1407124855.5217.23.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, Christoph Hellwig <hch@infradead.org>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/04/2014 06:00 AM, Ching Huang wrote:
> On Fri, 2014-08-01 at 05:35 -0700, Christoph Hellwig wrote:
>>> @@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
>>>  		arcmsr_handle_virtual_command(acb, cmd);
>>>  		return 0;
>>>  	}
>>> -	if (atomic_read(&acb->ccboutstandingcount) >=
>>> -			ARCMSR_MAX_OUTSTANDING_CMD)
>>> +	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
>>>  		return SCSI_MLQUEUE_HOST_BUSY;
>> The scsi midlayer already takes care of this check for you.
>>
> Hello Christoph,
>
> We have 4 types of Adapter that some adpaters have command queue less
> than ARCMSR_MAX_OUTSTANDING_CMD.
> So we have to check outstanding command number here.

I think you could set the correct value of can_queue in arcmsr_probe
after you have read the firmware spec.

>
> Thanks for your comment.
> Ching
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

