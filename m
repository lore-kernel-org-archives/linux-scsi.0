From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 13:13:40 +0200
Message-ID: <53847364.7060900@redhat.com>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>				 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>			 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>		 <5384541B.1010400@acm.org> <1401186086.14454.43.camel@dabdike>	 <53846D3E.6050901@redhat.com> <1401188364.14454.51.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0LON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 07:14:13 -0400
In-Reply-To: <1401188364.14454.51.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

Il 27/05/2014 12:59, James Bottomley ha scritto:
> On Tue, 2014-05-27 at 12:47 +0200, Paolo Bonzini wrote:
>> Il 27/05/2014 12:21, James Bottomley ha scritto:
>>> I could also see us one day extending the TMF capability to abort any
>>> running command, which would make even an assertion of block timed out
>>> or completed invalid.
>>
>> Actually the assertion would remain valid, and that's exactly what Bart
>> wants to document with this assertion.
>
> No, it wouldn't: if we abort a running command by definition the command
> hadn't timed out and might not be completed.  This is required by TMF
> handling because now you have an abort racing with a completion.  Either
> the command completes normally because it misses the abort or the abort
> gets to it and its returned status is set to TASK_ABORTED.  That's the
> only way you can tell if the abort was successful or not.
>
> If you're thinking we would tell block to ignore returning commands
> before issuing the abort, we'd never be able to tell if the abort were
> successful, so we have to allow the race to collect the status.

You could use a different mechanism than a softirq to tell the abort 
were successful, for example by overriding scsi_done.  But with respect 
to the block layer, the mechanics of avoiding the race and double-free 
would probably be the same.

Paolo
