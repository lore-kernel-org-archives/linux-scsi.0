From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Tue, 22 Oct 2002 00:30:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022073040.GA10377@beaverton.ibm.com>
References: <20021021213441.A2864@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021021213441.A2864@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> the ->finish method is a relicat from the old day were we never had
> hotplugging and allowed the driver to do fixups after all busses
> had been scanned.  Nowdays only sd and sr actually implement it,
> and both only defer actions to there that should actually happen in
> ->attach.  Change both drivers to move that code into ->attach,
> clenaup the Templates to use C99 initializers and get rid of the
> methods.
> 
> This also cleans up some very crude race-avoidable code in those
> drivers, btw..

Looks good Christoph. I applied this patch to James scsi-misc-2.5 tree
and I ran it under UML and did not see any boot / shutdown problems. I
will run it on our FC 2x tomorrow.

It looks to me like we could also investigate removing sd_disks and
sd_dsk_arr by using the per driver storage of the device model. In the 2
sd_disks access cases we have the scsi_device and should be able to
locate the device object. I believe the sd_dsk_arr could also be covered
in a similar method.

-andmike
--
Michael Anderson
andmike@us.ibm.com

