From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas, aic94xx: fix dma mapping cockups with ATA
Date: Mon, 16 Jul 2007 17:42:06 -0400
Message-ID: <469BE62E.90302@garzik.org>
References: <1184611264.3447.28.camel@localhost.localdomain>	 <469BD2C2.4040002@garzik.org> <1184617317.3447.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36836 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbXGPVmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 17:42:08 -0400
In-Reply-To: <1184617317.3447.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2007-07-16 at 16:19 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> This one was noticed by Gilbert Wu of Adaptec:
>>>
>>> The libata core actually does the DMA mapping for you, so there has to
>>> be an exception in the device drivers that *don't* do dma mapping for
>>> ATA commands.  However, since we've already done this, libsas must now
>>> dma map any ATA commands that it wishes to issue ... and yes, this is a
>>> horrible mess.
>> Can you help me understand this logic?
>>
>> libsas must DMA map an ATA command... because libata also DMA maps an 
>> ATA command?  That does not make sense to me.
> 
> Why not? ... since the driver must *not* map an ATA command (to prevent
> double mapping from libata), it can't tell if the command comes from
> libsas or libata ... so libsas has to map any internal ATA commands it
> uses.
> 
> I think you're perhaps thinking libsas must map an ATA command libata
> has already mapped?  If so, no, libsas must only map the commands it is
> using internally independent of libata.

I was merely noting the patch description did not make sense to me, 
nothing more.  With this additional background, it does make sense :)

	Jeff



