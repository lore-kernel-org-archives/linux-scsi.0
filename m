From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 08 May 2007 11:46:42 -0500
Message-ID: <4640A972.3010108@cs.wisc.edu>
References: <20070508171710.1ac730cd@the-village.bc.nu>	 <20070508161444.GA4163@kernel.dk> <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44325 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933808AbXEHQr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2007 12:47:27 -0400
In-Reply-To: <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-05-08 at 18:14 +0200, Jens Axboe wrote:
>> On Tue, May 08 2007, Alan Cox wrote:
>>> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
>>> nor should it). However they get injected into the SCSI layer via
>>> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
>>> along to a device with unchecked_isa_dma set which either panics or
>>> truncates the buffer to 24bits.
>>>
>>> According to Jens the right long term fix is for the CD layer to route
>>> the requests differently but in the mean time this has been tested by a
>>> victim and verified to sort the problem out. For the other 99.9% of users
>>> it's a no-op and doesn't bounce data.
>>>
>>> Signed-off-by: Alan Cox <alan@redhat.com>
>> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>>
>> Christoph passed me his patch to get rid of ->generic_packet() in the
>> cdrom layer, so the work is almost complete. This patch is fine as a
>> work-around until that gets merged, though.
> 
> Actually, I think the new scsi request infrastructure should be doing
> the bouncing (rather than have it done in each problem path we
> discover).
> 
> Mike Christie tells me we're missing bouncing by accident in the
> scsi_execute path (but not the scsi_execute_async path).  He says this
> is the fix he proposed:
> 
> http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> 

Hey Jens and James, one thing I forgot to mention is that I could not
remember if I needed an extra bio_get in there. I thought I did not
because the caller is not touching the bio after the bio_endio calls
like is done with the blk/bio_map_user path. But I did that patch so
long ago I do not remember now.
