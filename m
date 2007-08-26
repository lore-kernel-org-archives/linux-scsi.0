From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: cciss: fix error reporting for SG_IO
Date: Sat, 25 Aug 2007 21:15:07 -0700 (PDT)
Message-ID: <213452.45405.qm@web33010.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web33010.mail.mud.yahoo.com ([209.191.69.125]:21521 "HELO
	web33010.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750778AbXHZEVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Aug 2007 00:21:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > This fixes a problem with the way cciss was filling out the "errors"
> > field of the request structure upon completion of requests.
> > Previously, it just put a 1 or a 0 in there and used the negation
> > of this as the uptodate parameter to one of the functions in the
> > block layer, being a block device.  For the SG_IO ioctl, this was not
> > sufficient, and we noticed that, for example, sg_turs from sg3_utils
> > did not correctly detect problems due to cciss having set rq->errors
> > incorrectly.
> 
> Do we think this problem is sufficiently serious to merit merging
> this (largeish) patch into 2.6.23?
> 
> I'm thinking "no", but that might be wrong...

Without saying too much (I hope), if you want multipath i/o to cciss 
devices to work which depend on device mapper, (which I can't say what 
specific device(s) match that description without getting myself into 
trouble) then you want this patch.  If my understanding is correct, then
some DM multipath stuff depends on TUR response to know if a path is
failed.  If you don't care about that, then you can skip it.
 
-- steve



       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
