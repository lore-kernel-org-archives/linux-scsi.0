From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Fri, 24 Feb 2017 08:15:22 +0100
Message-ID: <ef796d74-4425-92ab-d602-c0b66a8cf19d@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
 <1487908867.2907.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36873 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbdBXHPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 02:15:25 -0500
In-Reply-To: <1487908867.2907.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On 02/24/2017 05:01 AM, Bart Van Assche wrote:
> On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
>> Primary goal is to make asynchronous aborts mandatory; there hasn't
>> been a single report so far where asynchronous abort won't work, so
>> the 'no_async_abort' flag has never been used and will be removed
>> with this patchset.
> 
> Hello Hannes,
> 
> There is a problem with asynchronous aborts. Some SCSI drivers, e.g. ib_srp,
> support fast error recovery by performing a transport layer reconnect without
> reporting this event as a failure to the SCSI core. While such a reconnect is
> ongoing it is important that no attempt is made to use the data structures
> that represent the connection. Hence the scsi_target_block() call in
> srp_reconnect_rport(). This blocks most .queuecommand() calls except those
> that originate from the SCSI EH. Hence the if (current == shost->ehandler)
> mutex_lock(&rport->mutex) code in srp_queuecommand(). Asynchronous aborts
> break this code because the asynchronous abort code submits an abort from
> another context than the SCSI EH thread. I know that this way of detecting
> the SCSI EH context is not an optimal solution. A few years ago I have tried
> to modify the SCSI EH such that reconnects and .queuecommand() calls could
> be serialized but James was not interested in such patches at that time.
> 
Don't think that's much of an issue.
scsi_abort_command() (ie the call which triggers async aborts) is only
called if the .eh_timed_out() callback returns BLK_EH_NOT_HANDLED.
So during reconnects we will not schedule any calls to async aborts.
We _might_ have scheduled an async abort prior to a call to
srp_reconnect_rport(), but that would be equivalent with calling
srp_reconnect_rport() with commands still in flight.
Is that even possible?
If so, how do you handle these commands after reconnect returns?
Any I_T_L nexus will be gone from the target, right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
