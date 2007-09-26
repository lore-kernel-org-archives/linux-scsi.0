From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 11:52:07 +0900
Message-ID: <20070926115207B.fujita.tomonori@lab.ntt.co.jp>
References: <1190770955.8707.23.camel@localhost.localdomain>
	<20070925073735U.tomof@acm.org>
	<46F9C5ED.6050505@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:46120 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXIZDiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 23:38:51 -0400
In-Reply-To: <46F9C5ED.6050505@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 25 Sep 2007 22:37:33 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index adc9559..694015d 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -342,6 +342,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
> >  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
> >  	shost->use_clustering = sht->use_clustering;
> >  	shost->ordered_tag = sht->ordered_tag;
> > +
> > +	if (!sht->supported_mode)
> > +		sht->supported_mode = MODE_INITIATOR;
> > +
> >  	shost->active_mode = sht->supported_mode;
> 
> 
> I almost hesitate to speak up, after making the original suggestion, but:
> 
> Are there any const-ness worries for scsi_host_template, or plans for 
> the future?  I do not see any other examples of the host template 
> members getting modified.

Yeah, that's why I said it's hacky in the previous
discussion. Changing scsi_host_template behind llds is not nice, I
think.


> Perhaps this value should instead be mirrored in scsi_host, like
> many others?

supported_mode should be static like 'name'. I'm not sure about having
supported_mode in scsi_host. All the scsi_hosts of one driver always
use the same supported_mode value unlike active_mode.
