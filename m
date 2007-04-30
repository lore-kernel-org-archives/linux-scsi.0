From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Mon, 30 Apr 2007 13:24:07 -0500
Message-ID: <1177957447.3674.51.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
	 <1177881499.3688.82.camel@mulgrave.il.steeleye.com>
	 <20070429.143759.71876461.davem@davemloft.net>
	 <Pine.LNX.4.60.0704301947570.15250@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35359 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423535AbXD3SYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 14:24:13 -0400
In-Reply-To: <Pine.LNX.4.60.0704301947570.15250@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org

On Mon, 2007-04-30 at 20:15 +0200, Guennadi Liakhovetski wrote:
> Ok, looking through t10 docs there seem to be quite a few functions for 
> the SAVE DATA POINTERS / MODIFY DATA POINTER / RESTORE POINTERS (btw, even 
> POINTER vs. POINTERS use was inconsistent between the spi5r06, s2-r10l, 
> ana a random book I have) also apart from the usual DISCONNECT / RESELECT, 
> like re-requesting command / data / status.
> 
> Is there a SCSI driver that does all this pointer management correctly? 
> And that's easy enough to understand and use as an example? For example, 
> tmscsim just would reject MODIFY DP. And for every RESTORE POINTERS with 
> sg there would be a KERN_INFO printk...

What most drivers do is to ignore the messages.  They assume they
already know what the pointers are ... they're really only useful for
disconnect and reconnect.  This is predicated on the assumption that the
device won't use the save/restore to rewind in a transfer (i.e. save
data pointers, accept more data and then disconnect) since all drivers
seem to automatically save the pointer state at the moment of
disconnect.

James


