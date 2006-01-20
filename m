From: Andrew Morton <akpm@osdl.org>
Subject: Re: OOM Killer killing whole system
Date: Fri, 20 Jan 2006 14:50:06 -0800
Message-ID: <20060120145006.0a773262.akpm@osdl.org>
References: <1137337516.11767.50.camel@localhost>
	<20060120041114.7f06ecd8.akpm@osdl.org>
	<Pine.LNX.4.64.0601201401500.14198@turbotaz.ourhouse>
	<1137793685.11771.58.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60577 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932258AbWATWsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 17:48:11 -0500
In-Reply-To: <1137793685.11771.58.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Titov <a.titov@host.bg>
Cc: chase.venters@clientec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Anton Titov <a.titov@host.bg> wrote:
>
> On Fri, 2006-01-20 at 14:04 -0600, Chase Venters wrote:
> > On Fri, 20 Jan 2006, Andrew Morton wrote:
> > >> Jan 15 06:05:09 vip 216477 pages slab
> > >
> > > It's all in slab.  800MB.
> > >
> > > I'd be suspecting a slab memory leak.  If it happens again, please take a
> > > copy of /proc/slabinfo, send it.
> > >
> > 
> > Andrew & Anton,
> >  The culprit was 1.5 million SCSI commands in the scsi command cache. 
> > 
> > Thanks,
> > Chase
> 
> I currently have this:
> scsi_cmd_cache    1458778 1458790    384   10    1 : tunables   54 27
> 8 : slabdata 145879 145879      0
> 
> in /proc/slabinfo, which is pretty close to 1.5 million. The system is
> working fine but it should be not very loaded anyway, so a mem leakage
> will not show up early. Just checked, that scsi_cmd_cache on other
> machines of mine is under 100, so it seems like a problem.

That's great, thanks.

This is 2.6.15 and we have a deadly bug in scsi.

Next time you reboot 2.6.15 on that machine can you please send the output
of `dmesg -s 1000000'?  You might have to set CONFIG_LOG_BUF_SHIFT=17 to
prevent it from being truncated.

