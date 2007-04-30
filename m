From: David Miller <davem@davemloft.net>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Mon, 30 Apr 2007 11:46:37 -0700 (PDT)
Message-ID: <20070430.114637.41634896.davem@davemloft.net>
References: <20070429.143759.71876461.davem@davemloft.net>
	<Pine.LNX.4.60.0704301947570.15250@poirot.grange>
	<1177957447.3674.51.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1946587AbXD3Sq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 14:46:26 -0400
In-Reply-To: <1177957447.3674.51.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Mon, 30 Apr 2007 13:24:07 -0500

> On Mon, 2007-04-30 at 20:15 +0200, Guennadi Liakhovetski wrote:
> > Ok, looking through t10 docs there seem to be quite a few functions for 
> > the SAVE DATA POINTERS / MODIFY DATA POINTER / RESTORE POINTERS (btw, even 
> > POINTER vs. POINTERS use was inconsistent between the spi5r06, s2-r10l, 
> > ana a random book I have) also apart from the usual DISCONNECT / RESELECT, 
> > like re-requesting command / data / status.
> > 
> > Is there a SCSI driver that does all this pointer management correctly? 
> > And that's easy enough to understand and use as an example? For example, 
> > tmscsim just would reject MODIFY DP. And for every RESTORE POINTERS with 
> > sg there would be a KERN_INFO printk...
> 
> What most drivers do is to ignore the messages.  They assume they
> already know what the pointers are ... they're really only useful for
> disconnect and reconnect.  This is predicated on the assumption that the
> device won't use the save/restore to rewind in a transfer (i.e. save
> data pointers, accept more data and then disconnect) since all drivers
> seem to automatically save the pointer state at the moment of
> disconnect.

The new ESP driver in esp_scsi.c is a good example of doing at least
SAVE and RESTORE pointer management properly.  I plan to add the
necessary MODIFY bits soon.

I think it's important to get this right because a target can use
this to recover from internal errors during an I/O, in order to
transfer some block of the data again.

I am pretty sure that the firmware in the aic7xxx, sym53c8xx, et
al. have extensive code to handle this completely.  That's why there
aren't any good driver examples, not because it isn't being handled,
but because all the logic and important details are done in the scsi
adapter firmware.

