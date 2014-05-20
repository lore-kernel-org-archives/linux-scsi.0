From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Tue, 20 May 2014 10:10:45 +0200
Message-ID: <537B0E05.80308@acm.org>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org> <537B04F5.4080808@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:33208 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaETIKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2014 04:10:47 -0400
In-Reply-To: <537B04F5.4080808@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>

On 05/20/14 09:32, Bart Van Assche wrote:
> On 05/19/14 18:43, Bart Van Assche wrote:
>> On 05/19/14 18:09, Paolo Bonzini wrote:
>>> Il 19/05/2014 17:08, Bart Van Assche ha scritto:
>>>> On 05/19/14 16:08, Paolo Bonzini wrote:
>>>>> 2) reentrancy: the softirq handler and scmd_eh_abort_handler can run
>>>>> concurrently, and call scsi_finish_command without any lock protecting
>>>>> the calls.  You can then get memory corruption.
>>>>
>>>> I'm not sure what the recommended approach is to address this race. But
>>>> it is possible to address this in the LLD. See e.g. the srp_claim_req()
>>>> function in the SRP LLD and how it is invoked from the reply handler,
>>>> the abort handler and the reset handlers in that LLD.
>>>
>>> That's not enough, unless I'm missing something.  Say the request
>>> handler claims the request and the abort handler doesn't:
>>>
>>> - the request handler calls scsi_done and ends up in scsi_finish_command.
>>>
>>> - the abort handler will return SUCCESS, and scmd_eh_abort_handler then
>>> calls scsi_finish_command.
>>
>> It depends on how the SCSI abort handler gets invoked. If the SCSI abort
>> handler gets invoked because a SCSI command timed out that means that
>> the block layer has already detected a timeout and also that the
>> REQ_ATOM_COMPLETE bit has already been set. In this scenario if a SCSI
>> LLD invokes scsi_done() that causes blk_complete_request() to return
>> without invoking __blk_complete_request() and hence without invoking
>> scsi_softirq_done().
> 
> (replying to my own e-mail)
> 
> Please note that scsi_eh_abort_cmds() neither checks nor sets the
> REQ_ATOM_COMPLETE bit before it invokes hostt->eh_abort_handler(). Would
> it make sense to modify that function such that it invokes
> blk_abort_request() instead ? That last function atomically
> test-and-sets the REQ_ATOM_COMPLETE bit before invoking the timeout handler.

(answering my own question)

REQ_ATOM_COMPLETE is already set before scsi_eh_scmd_add() is called
since that function is only invoked after the block layer has marked a
request as "complete". The only callers of scsi_eh_scmd_add() are
scsi_softirq_done(), scsi_times_out() and scmd_eh_abort_handler(). That
last function is invoked (indirectly) by scsi_times_out().

Bart.

