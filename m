From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ATA Write Error and Time-out Notification in User Space
Date: Tue, 03 Jan 2006 18:58:42 +0000
Message-ID: <1136314722.22598.36.camel@localhost.localdomain>
References: <BAY101-F1894F0927E1FB790D14772DF2C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY101-F1894F0927E1FB790D14772DF2C0@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: raw@dslr.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Maw, 2006-01-03 at 12:29 -0600, John Treubig wrote:
> failure point.  I put a drive on the Secondary IDE bus hanging off the 
> motherboard Nvidia NForce 2 controller, began an access and pulled the plug. 
>   Sure enough the failures occured and were passed back to user level, but 
> the system did not hang.  I've repeated this a number of times.  I moved the 
> same drive to the Promise Controller and the hang occurs.  Thus it seems we 
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

