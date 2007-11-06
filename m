From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Do not requeue requests if FAILFAST is set
Date: Tue, 06 Nov 2007 12:01:04 -0600
Message-ID: <4730ABE0.6020405@cs.wisc.edu>
References: <4730248C.2030901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43892 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbXKFSBN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Nov 2007 13:01:13 -0500
In-Reply-To: <4730248C.2030901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi James,
> 
> the FAILFAST flag is currently not honored in scsi_request_fn().
> So if scsi_dispatch_cmd() returns an error or the queue is not
> ready, the request will always be requeued regardless of the
> FAILFAST setting.
> This can result in a delayed fallback for multipathing, as
> these requests will only be catched once the timeout expires.
> 
> This patch avoids requeuing if the FAILFAST flag is set, and
> terminates the request immediately.
> 
> Comments et al welcome.
> 

I think that might be better than my transport errors patch. If 
multipath is being used then we told people to set the recovery timeout, 
to a very low value. So that way commands would not sit in a blocked 
queue very long.

With your patch, if the queue was blocked because we are doing recovery, 
then the command is returned upwards as soon as the driver/class returns 
the command to the scsi layer. And that is nice since it fixes that 
issue where the fibre channel class/driver fails commands in the driver 
when fail fast tmo fires, but commands in the blocked queue sit around 
until dev loss tmo fires or the rport comes back.

Is there any case though where fail fast is set on the request, but the 
driver really does want to retry on the driver? Was there some other 
user of something like DID_IMM_RETRY that could be used with multipath 
or raid and when they return DID_IMM_RETRY they wanted to bypass the 
fail fast checks? If so that would be my only reason for splitting up 
the error values and relying on the transport class timers (fc fail fast 
tmo and iscsi recovery tmo) to decide when to fail commands (assuming 
that the fc class is also changed so when fail fast tmo fires blocked 
commands are failed).

Oh yeah since we are now doing dm-multipath with SAS, what is that class 
doing as far as failing commands when there is a transport issue? Does 
it have something like fc's fail fast tmo? Does it fail running commands 
right away so the scsi layer can requeue or does it try to do some lower 
level recovery and try to continue the command until some timeout fires?
