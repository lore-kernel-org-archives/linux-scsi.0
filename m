From: "John Treubig" <jtreubig@hotmail.com>
Subject: Re: ATA Write Error and Time-out Notification in User Space
Date: Tue, 03 Jan 2006 13:27:28 -0600
Message-ID: <BAY101-F32BC19A49EC86F6FED361BDF2C0@phx.gbl>
References: <1136314722.22598.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay101-f32.bay101.hotmail.com ([64.4.56.42]:59760 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S932495AbWACT13
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 14:27:29 -0500
In-Reply-To: <1136314722.22598.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk
Cc: raw@dslr.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I receive this as great news, only I don't know where the -mm tree is 
located to see if I can get the patch or fix!  Can you give me a few 
pointers?!



From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Treubig <jtreubig@hotmail.com>
CC: raw@dslr.net, linux-ide@vger.kernel.org,linux-kernel@vger.kernel.org, 
linux-scsi@vger.kernel.org
Subject: Re: ATA Write Error and Time-out Notification in User Space
Date: Tue, 03 Jan 2006 18:58:42 +0000

On Maw, 2006-01-03 at 12:29 -0600, John Treubig wrote:
 > failure point.  I put a drive on the Secondary IDE bus hanging off the
 > motherboard Nvidia NForce 2 controller, began an access and pulled the 
plug.
 >   Sure enough the failures occured and were passed back to user level, 
but
 > the system did not hang.  I've repeated this a number of times.  I moved 
the
 > same drive to the Promise Controller and the hang occurs.  Thus it seems 
we
 > have proved the Promise sub-system is my problem.


Bingo. Yes I know why this is occuring now.

There is a known old bug with error handling in some cases on promise
chips. The core kernel code tries to clean up any remaining data after
an error (to handle chip prefetch/postwrite FIFOs) if DRQ_STAT is
asserted. Its a nice trick, saves on resets and slow recovery but isn't
compatible with some promise controllers.

The -mm tree has a partial but incomplete fix to this implemented, the
base kernel does not have this fixed.

Its been known for some time so perhaps the ide maintainers have patches
waiting for 2.6.16 now its opened ?

Alan

-
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


