From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH] WD33C93: let platform stub override no_sync/fast/dma_mode
Date: Sat, 22 Mar 2008 00:04:24 +0100
Message-ID: <20080321230424.GA31455@alpha.franken.de>
References: <20080321212543.6F769C2DF8@solo.franken.de> <Pine.LNX.4.58.0803212302190.564@Indigo2.Peter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:40852 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765296AbYCUXEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 19:04:53 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0803212302190.564@Indigo2.Peter>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: peter fuerst <post@pfrst.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

On Fri, Mar 21, 2008 at 11:20:07PM +0100, peter fuerst wrote:
> 
> the code-sequence
> 
> 	wd33c93_init(...
> 	if (hdata->wh.no_sync == 0xff)
> 		hdata->wh.no_sync = 0;
> 
> was put/kept there intentionally - in this very order - to enable
> "nosync" from the command-line!

this hack is IMHO no longer needed. If the user wants to override no_sync
via kernel command line, it works as before. If the user doesn't no_sync
will be 0 (now set in sgiwd93.c before calling wd33c93_init()) and the
driver will try to do sync transfers for all devices. It works like before.
Or did I miss something ?

Thomas

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
