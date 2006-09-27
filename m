From: David Brownell <david-b@pacbell.net>
Subject: Re: fix compile-time divide-by-zero in scsi_ioctl
Date: Wed, 27 Sep 2006 16:28:26 -0700
Message-ID: <200609271628.27120.david-b@pacbell.net>
References: <20060926154848.CFDC63DAF7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20060927202710.GV5017@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:34751 "HELO
	smtp109.sbc.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965167AbWI0X2c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 19:28:32 -0400
In-Reply-To: <20060927202710.GV5017@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wednesday 27 September 2006 1:27 pm, Matthew Wilcox wrote:
> On Tue, Sep 26, 2006 at 08:48:48AM -0700, David Brownell wrote:
> > This fixes a compiler-reported divide-by-zero when HZ < 100.
> 
> Shouldn't we instead be using jiffies_to_clock_t?  Thus:

Could be ... the units in that function unclear to me though.

What I care about is not needing to carry a patch around in my tree ...
I got no response when I posted a fix to LKML several months back,
your suggestion could well be better!

FWIW HZ=64 can be convenient for various embedded platforms with
32768/sec system clocks; HZ=100 can be impractical.

- Dave



> Index: at91/block/scsi_ioctl.c
> ===================================================================
> --- at91.orig/block/scsi_ioctl.c	2006-07-30 01:17:34.000000000 -0700
> +++ at91/block/scsi_ioctl.c	2006-07-30 01:44:17.000000000 -0700
> @@ -63,7 +63,7 @@ static int scsi_get_bus(request_queue_t 
>  
>  static int sg_get_timeout(request_queue_t *q)
>  {
> -	return q->sg_timeout / (HZ / USER_HZ);
> +	return jiffies_to_clock_t(q->sg_timeout);
>  }
>  
>  static int sg_set_timeout(request_queue_t *q, int __user *p)
> 
