From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Sun, 14 Mar 2004 15:41:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314204158.GB1463@havoc.gtf.org>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de> <1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme> <1079278279.2022.34.camel@mulgrave> <20040314154713.GH19737@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([216.162.42.101]:7630 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S261568AbUCNUmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 15:42:01 -0500
Content-Disposition: inline
In-Reply-To: <20040314154713.GH19737@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Mar 15, 2004 at 02:47:13AM +1100, Anton Blanchard wrote:
> Lets ignore the pci_map_sg problem and assume the qlogic driver did the 
> right thing. Whats to stop the upper layers from continually trying to 
> queue things when we run out of request slots? If its just sg_tablesize 
> then we are stuck with the current compromise (ie set it to something
> reasonably low).

The block layer is quite simple, really.

You have an asynchronous event, "start queue drain."

And the block layer won't touch your queue again until you have removed
all requests from the queue.  Once you have removed all requests from
the queue, the cycle repeats.

It is up to the block driver (and/or SCSI layer in this case) to stop
taking requests off the queue, when it can take no more.  And it is up
to that same driver to start taking requests again, when hardware
resources are once again available.

So, the block layer supports this hardware situation just fine... it's a
matter of getting SCSI to understand that, I suppose :)

The issue of hardware-global resources constraining multiple device
queues is one that requires a bit of thought.  Not impossible... I did
it in my Carmel driver.  But so far, I have not seen any _real_
solutions excepts for mine.  All the others have been hacks -- such as
"hardware queue size 1024 for all devices, so limit each device
to '1024 / n_devices' requests at a time."

	Jeff


