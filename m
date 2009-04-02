From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Thu, 2 Apr 2009 08:27:15 -0700
Message-ID: <20090402152715.GF18394@sequoia.sous-sol.org>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu> <12386094922477-git-send-email-michaelc@cs.wisc.edu> <12386094933319-git-send-email-michaelc@cs.wisc.edu> <200904021602.55587.jdelvare@suse.de> <49D4D68A.8080606@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:60545 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbZDBPbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 11:31:23 -0400
Content-Disposition: inline
In-Reply-To: <49D4D68A.8080606@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jean Delvare <jdelvare@suse.de>, linux-scsi@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

* Mike Christie (michaelc@cs.wisc.edu) wrote:
>>> -	if (q->queue == ERR_PTR(-ENOMEM))
>>> +	if (IS_ERR(q->queue)) {
>>
>> This indeed solves the problem I had underlined before, but
>> introduces a new one. Right now the only error returned by kfifo_init
>> is -ENOMEM. This may however change in the future, and then the
>> above code would silently convert the other error code to -ENOMEM.
>> This might make it difficult to trace errors.
>
> What do you mean by converting other errors codes to -ENOMEM?

Jean means the goto label...it will jump to essentially return -ENOMEM.

>> I know this is all just theoretical, at the moment your code is
>> correct, but I don't much like relying on assumptions which are not
>> guaranteed to last. So I would rather cleanly transmit the error code
>> up to the caller, or change the calling convention of kfifo_init() to
>
> What do you mean by cleanly transmitting the error code up the caller?

It's handwavy here...meaning if kfifo_init returned some other
error for some other condition, propagating that up the stack to the
iscsi_pool_init() caller.  Probably not all that critical to return
ENOMEM vs someother errno in this case.

thanks,
-chris
