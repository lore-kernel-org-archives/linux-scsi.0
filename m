From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Wed, 29 Oct 2014 11:55:38 +0100
Message-ID: <5450C7AA.40706@acm.org>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-3-git-send-email-hch@lst.de> <544F5C5C.3090104@acm.org> <20141028173926.GB22593@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52794 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJ2Kzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 06:55:49 -0400
In-Reply-To: <20141028173926.GB22593@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/28/14 18:39, Christoph Hellwig wrote:
> On Tue, Oct 28, 2014 at 10:05:32AM +0100, Bart Van Assche wrote:
>> I might be missing some background information here, but it's not clear to
>> me why the function like scsi_block_when_processing_errors() was introduced
>> some time ago. What if immediately after error handling has finished a new
>> request is queued that kicks the error handler again before the caller of
>> scsi_block_when_processing_errors() has finished the actions that should
>> not occur concurrently with error handling ? Has it already been considered
>> to introduce a mutex to serialize error handling and activity that should
>> not occur concurrently with error handling ?
>
> I've not looked into changing the conditions, but your questions are
> good ones.  I'd like to go even further and ask the question of what
> we try to protect here.  For SG_SCSI_RESET the answer is that we want
> to enforce a single outstanding TMF, as require by old parallel SCSI HBAs,
> and possible by various drivers.  I don't quite understand why we check
> the EH state before executing other ioctl, though.  Even more confusing
> is that some driver like st.c and sg.c only enforce this on some ioctls.
>
> Changing the exclusion rules isn't in the scope of this series, but if
> you interested in looking into this series I'd be happy if we get the
> ball on it rolling.

Hello Christoph,

As you know I'm working on several different projects simultaneously so 
I'm not sure I will be able to free up some time soon to work on this. I 
will add this on my to-do list but if anyone else would like to start 
working on this that would be welcome.

Bart.


