From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 14 Mar 2004 17:27:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079303231.2848.69.camel@mulgrave>
References: <20040314082444.GA3416@linux.local.home>
	<1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de>
	<1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme>
	<1079278279.2022.34.camel@mulgrave> <20040314154713.GH19737@krispykreme>
	<20040314204158.GB1463@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44199 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261992AbUCNW1q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 17:27:46 -0500
In-Reply-To: <20040314204158.GB1463@havoc.gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-03-14 at 15:41, Jeff Garzik wrote:
> So, the block layer supports this hardware situation just fine... it's a
> matter of getting SCSI to understand that, I suppose :)

We already do all of that, if you look ...

The place where all of this becomes rather unoptimal for SCSI is in an
SMP where we get multiple queues racing on multiple CPUs for different
devices then having to be coalesced into a single queue for the host
adapter.  It causes cache line bouncing like you wouldn't believe...

> The issue of hardware-global resources constraining multiple device
> queues is one that requires a bit of thought.  Not impossible... I did
> it in my Carmel driver.  But so far, I have not seen any _real_
> solutions excepts for mine.  All the others have been hacks -- such as
> "hardware queue size 1024 for all devices, so limit each device
> to '1024 / n_devices' requests at a time."

We do this too.

If you look int the scsi_host structure you see can_queue, which is the
maximum number of total requests we allow to the entire host.  Then
there's queue_depth in scsi_device, which is the maximum number of
requests to the individual devices.  We even have a very simplistic
fairness scheme to prevent one device hogging all of the host queue
elements.

For dynamic resource situations we have the queuecommand return codes

SCSI_MLQUEUE_HOST_BUSY which means the entire host is temporarily out of
resources and causes the mid layer to hold off all commands for that
host until we get one back from any device on the host and

SCSI_MLQUEUE_DEVICE_BUSY which means that the device queue is
temporarily out of resources, hold off all commands to that device until
one returns from that device.

James


