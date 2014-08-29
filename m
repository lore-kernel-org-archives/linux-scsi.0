From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 14:37:19 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1408291112440.7204@nippy.intranet>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>  <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>  <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>  <53FF1EB8.9010700@redhat.com> <1409234983.2475.2.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52110 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaH2EiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2014 00:38:21 -0400
In-Reply-To: <1409234983.2475.2.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>


On Thu, 28 Aug 2014, James Bottomley wrote:

> > I'm fine with not calling scsi_done from eh_abort, but I cannot 
> > guarantee that another thread will not complete the cmnd in the mean 
> > time before hand.
> 
> This is expected.  After error handling begins, the block layer ignores 
> all done callbacks for commands under EH.

This thread seems like FAQ's to me (I was looking for answers myself). It 
would be nice if the EH docs would clearly state something like, "calling 
scsi_done on a command being aborted is a no-op".

I found your post to this thread helpful,
    http://www.spinics.net/lists/linux-scsi/msg77305.html
although it does raise more questions.

Given that eh_abort_handler() may return SUCCESS or FAILURE, what are the 
implications for cmd->result? I took a look at esp_scsi to see if that 
would shed some light.

That driver does the following in eh_abort_handler().
	cmd->result = DID_ABORT << 16;
	cmd->scsi_done(cmd);
	...
	return SUCCESS;
but only in certain circumstances. In others, it will wait for an active 
command to complete normally. eh_abort_handler() then returns SUCCESS if 
the command completes normally and quickly, and FAILURE if not (which 
seems semantically strange to me).

In that driver, the command waited upon in eh_abort_handler() will never 
have result host byte == DID_ABORT.

None of which makes much sense to me. Is it permissible to have normal 
command completion (host byte == DID_OK) and have eh_abort_handler() 
return SUCCESS?

Conversely, is it okay to set_host_byte(cmd, DID_ABORT) and then 
return FAILURE from eh_abort_handler()?

It would be nice if the docs could state unequivocally "a aborted command 
is presumed to have no meaningful result" (Is this true? If not, which 
bytes matter?)

Another subtlety is that the abort handler is apparently expected to 
perform autosense for an aborted command (or wait for that to happen 
normally) and only return after this has taken place (rather than 
immediately killing the command).

> You can get the situation where we try to abort (or do other EH) on a 
> command you think you've already completed, but you just return success 
> for that.

In general, the LLD cannot distinguish between a command previously 
completed and a command it has never encountered. But it seems that 
eh_abort_handler() should return SUCCESS either way.

That seems like an unintuitive interpretation of "successfully aborted" so 
it perhaps this needs to be documented too. The drivers I've looked at 
(esp_scsi and ncr5380) don't do this. If asked to abort some command which 
they completed in the past, they would return failure.

-- 
