From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Fri, 8 Aug 2003 07:32:18 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308080727490.4191@kai.makisara.local>
References: <20030806231359.A28252@mail.kroptech.com>
 <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local> <20030807201916.A1065@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:65088 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S271196AbTHHEcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2003 00:32:21 -0400
In-Reply-To: <20030807201916.A1065@mail.kroptech.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Thu, 7 Aug 2003, Adam Kropelin wrote:

> On Fri, Aug 08, 2003 at 12:00:56AM +0300, Kai Makisara wrote:
...
> My knowledge of the SCSI subsystem is weak, so forgive me if this is a
> stupid question. If st knows the block size to be invalid, why does the
> io ever get submitted at all? Perhaps the io gets issued and
> completed, at which time st learns the block size was wrong, warns about
> it, and somehow the next command thru the SCSI layer hoses up? I'm
> really just grasping at straws here (as you can tell).
>
The size of the next block on tape is not known until the block is read.
The read is done and it returns 'check condition' and the sense data says
what happens. st then logs this and returns error for the read. This is
standard behavior for tapes.

> > > kernel BUG at include/asm/dma-mapping.h:37!
> >
> > This comes from 'BUG_ON(direction == DMA_NONE)' in dma_map_sg(). I
> > inserted a printk into st_do_scsi() in st.c to see if DMA_NONE is used for
> > some command that should transfer data. No errors seen in these printk
> > results.
>
> I tried aic7xxx_old and hit the same BUG so Justin's driver would seem
> to be exonerated. The new backtrace is below. The commonality is clearly
> the st driver and the SCSI midlayer. Perhaps I'll try to verbosify
> things a bit in that area and see what comes up.
>
I will try to get my old Adaptec working tonight or during the weekend and
see if I can reproduce the error. It seems to be dependent on the SCSI
adapter.

-- 
Kai
