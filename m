From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Thu, 23 Feb 2017 08:35:57 +0100
Message-ID: <b30cbe02-2d4b-ec20-906e-c1161ccd4bbd@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
 <1487798485.10204.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751144AbdBWHgE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 02:36:04 -0500
In-Reply-To: <1487798485.10204.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On 02/22/2017 10:21 PM, Bart Van Assche wrote:
> On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
>> this is a resend of a small patchset for cleaning up SCSI EH.
>> Primary goal is to make asynchronous aborts mandatory; there hasn't
>> been a single report so far where asynchronous abort won't work, so
>> the 'no_async_abort' flag has never been used and will be removed
>> with this patchset.
>> Additionally there's a cleanup for handle failed EH commands, and
>> to detect retries of failed commands.
> 
> An additional comment: I don't think it is safe to execute a host
> reset while any asynchronous aborts are ongoing. I think the SCSI EH
> will get really confused if after a host reset has been performed a
> response is received from an asynchronous abort that was issued
> before the host reset started. Although a SCSI target must not send
> a LU RESET response before all previously submitted SCSI commands
> and TMFs have finished, what prevents in e.g. a multipath topology
> that an abort response and a LU RESET response are received out of
> order?
> 
Hmm.
Not sure this can happen nowadays.
eh_abort() is synchronous, and the command is considered in-flight until
eh_abort() returns.
And as SCSI EH only starts until all commands are completed or timed out
we will not have any stuck TMFs before sending a host reset.
Things are different when calling 'sg_reset' manually, but I'll be
revisiting that anyway in the near future as it has it's own set of
problems.

Cheers,

Hannes
> Thanks,
> 
> Bart.
> 


-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
