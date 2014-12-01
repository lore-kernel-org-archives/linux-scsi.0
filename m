From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 5/4] scsi: remove MSG_*_TAG defines
Date: Mon, 01 Dec 2014 12:44:23 +0100
Message-ID: <547C5497.5020706@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <20141124150725.GA23165@infradead.org> <54784762.8020304@acm.org> <20141201090315.GA4042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:50919 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaLALot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2014 06:44:49 -0500
In-Reply-To: <20141201090315.GA4042@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>

On 12/01/14 10:03, Christoph Hellwig wrote:
> On Fri, Nov 28, 2014 at 10:58:58AM +0100, Bart Van Assche wrote:
>>>   	if (disable_syn_offset_one_fix) {
>>> -		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
>>> +		scsiq->q2.tag_code &= ~SIMPLE_QUEUE_TAG;
>>>   		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
>>>   				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
>>>   	} else {
>>
>> One of the statements in advansys.c (tag_code &= 0xDC) makes assumptions
>> about the numeric value of MSG_SIMPLE_TAG. This makes me wonder whether it
>> is safe to change MSG_SIMPLE_TAG into another value ?
>
> MSG_SIMPLE_TAG and SIMPLE_QUEUE_TAG are two different symbolic names
> for the 0x20 value assigned to the SCSI-2 protocol "SIMPLE QUEUE TAG"
> message.  Having both is confusing, so I decided to only keep the one
> that is named closer to the spec, and in the same namespace as the
> symbolic names we use for other SCSI-2 messages.

Thanks for the clarification. Using different namespaces for symbolic 
constants for initiator and target drivers definitely looks like a good 
idea to me. The patch itself also looks fine to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
