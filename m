From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6.0 aacraid driver update
Date: Wed, 27 Aug 2003 10:19:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062004786.3506.4.camel@markh1.pdx.osdl.net>
References: <1061567229.2067.15.camel@markh1.pdx.osdl.net>
	 <20030822171600.A19262@infradead.org>
	 <1061995388.22721.34.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57263 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263489AbTH0RT7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 13:19:59 -0400
In-Reply-To: <1061995388.22721.34.camel@dhcp23.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-08-27 at 07:43, Alan Cox wrote:
> On Gwe, 2003-08-22 at 17:16, Christoph Hellwig wrote:
> > > -	u32 			SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> > > +	unsigned long		SavedIrql;     	/* Previous IRQL when the spin lock is taken */
> > 
> > This is still broken.  you must not store irq flags in structures but
> > have to restore them in the same function you take them in, otherwise things
> > like the irq window on sparc32 can fuck up.  Also it's really confusing.
> 
> Sparc isnt supported. Also last time I checked this field was no longer
> in use. I've just not had time to remove it yet.

SavedIrql is used in aac_insert_entry and aac_queue_get although I am
working on a change to fix that.

Mark.
-- 
Mark Haverkamp <markh@osdl.org>

