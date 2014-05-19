From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Mon, 19 May 2014 18:43:50 +0200
Message-ID: <537A34C6.7090905@acm.org>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:51708 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaESQnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 12:43:53 -0400
In-Reply-To: <537A2CB8.9060302@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>

On 05/19/14 18:09, Paolo Bonzini wrote:
> Il 19/05/2014 17:08, Bart Van Assche ha scritto:
>> On 05/19/14 16:08, Paolo Bonzini wrote:
>>> 2) reentrancy: the softirq handler and scmd_eh_abort_handler can run
>>> concurrently, and call scsi_finish_command without any lock protecting
>>> the calls.  You can then get memory corruption.
>>
>> I'm not sure what the recommended approach is to address this race. But
>> it is possible to address this in the LLD. See e.g. the srp_claim_req()
>> function in the SRP LLD and how it is invoked from the reply handler,
>> the abort handler and the reset handlers in that LLD.
> 
> That's not enough, unless I'm missing something.  Say the request
> handler claims the request and the abort handler doesn't:
> 
> - the request handler calls scsi_done and ends up in scsi_finish_command.
> 
> - the abort handler will return SUCCESS, and scmd_eh_abort_handler then
> calls scsi_finish_command.

It depends on how the SCSI abort handler gets invoked. If the SCSI abort
handler gets invoked because a SCSI command timed out that means that
the block layer has already detected a timeout and also that the
REQ_ATOM_COMPLETE bit has already been set. In this scenario if a SCSI
LLD invokes scsi_done() that causes blk_complete_request() to return
without invoking __blk_complete_request() and hence without invoking
scsi_softirq_done().

Bart.

