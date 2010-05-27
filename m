From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 7/11] drivers/scsi: Eliminate a NULL pointer dereference
Date: Thu, 27 May 2010 19:13:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005271911590.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271433330.5422@ask.diku.dk> <20100527165301.GU22515@bicker>
 <4BFEA700.20603@bfs.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:38579 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab0E0RNt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 13:13:49 -0400
In-Reply-To: <4BFEA700.20603@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: Dan Carpenter <error27@gmail.com>, HighPoint Linux Team <linux@highpoint-tech.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 27 May 2010, walter harms wrote:

> 
> 
> Dan Carpenter schrieb:
> > On Thu, May 27, 2010 at 02:33:47PM +0200, Julia Lawall wrote:
> >> If it is a problem to use 0 when host is NULL, then the code could be fixed
> >> in another way.
> >>
> > 
> > Yeah.  It seems like it would be better to give a clearly bogus number.
> > I would have said -1 but "scsi-1" looks normal so maybe something like 
> > 9999999?
> > 
> 
> lets spend some bytes:
> 
> 	
> 	if (host)
> 		dprintk("scsi%d: hptiop_probe failed\n",host->host_no);
> 	else
> 		dprintk("scsi: no host, hptiop_probe failed\n");

dprintk is defined in hptiop.h as:

#if 0
#define dprintk(fmt, args...) do { printk(fmt, ##args); } while(0)
#else
#define dprintk(fmt, args...)
#endif

So unless someone adjusts the #if 0, there is no code.  I guess there is a 
danger that adding such an if would actually generate some code?

julia
