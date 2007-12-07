From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 07 Dec 2007 19:19:32 +0100
Message-ID: <1197051572.3599.10.camel@lov.site>
References: <20071207150549.GA24254@elte.hu>
	 <20071207165902.3686FDBA2@gherkin.frus.com>
	 <20071207180615.GC19173@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbXLGSUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 13:20:38 -0500
In-Reply-To: <20071207180615.GC19173@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

On Fri, 2007-12-07 at 19:06 +0100, Ingo Molnar wrote:
> * Bob Tracy <rct@frus.com> wrote:
> 
> > Ingo Molnar wrote:
> > > 
> > > * Bob Tracy <rct@frus.com> wrote:
> > > 
> > > > > Current state of the source tree is the 6f37ac... version, so I'll 
> > > > > start backing out the above diffs in related groups and continue 
> > > > > until I've got a working kernel.  For lack of an obvious target, 
> > > > > I'll start with the seemingly innocuous change to sysctl_check.c.  
> > > > > I'll report back when I've got something.
> > > > 
> > > > That was quick :-).  Backing out the sysctl_check.c diff gives me a 
> > > > working kernel.  Beats the #$%@! out of me how/why, though.
> > > > 
> > > > Michael Cree: could you try backing out the diff below from your 
> > > > 2.6.24-rc3 tree and see if things are now working for you?
> > > > 
> > > > Here's "uname -a", just to confirm (maybe) I'm running on what I say 
> > > > works:
> > > > 
> > > > Linux smirkin 2.6.24-rc2-g6f37ac79-dirty #2 Fri Dec 7 08:03:12 CST 2007 alpha
> > > > 
> > > > Here's the diff I backed out (patch -R).  It's short...
> > > > 
> > > > diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> > > > index 5a2f2b2..4abc6d2 100644
> > > > --- a/kernel/sysctl_check.c
> > > > +++ b/kernel/sysctl_check.c
> > > > @@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_table[] = {
> > > >  	{ NET_ROSE,		"rose",		trans_net_rose_table },
> > > >  	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
> > > >  	{ NET_X25,		"x25",		trans_net_x25_table },
> > > > -	{ NET_TR,		"tr",		trans_net_tr_table },
> > > > +	{ NET_TR,		"token-ring",	trans_net_tr_table },
> > > >  	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
> > > >  	/*  NET_ECONET not used */
> > > >  	{ NET_SCTP,		"sctp",		trans_net_sctp_table },
> > > 
> > > reverting this makes the kernel image shorter by 8 bytes - so 
> > > perhaps some alignment issue somewhere? Or something gets overflown? 
> > > Does any of this get actually used by your bootup?
> > 
> > Dunno...  The dmesg output is not terribly useful here, because most 
> > of the "interesting" stuff concerning udev startup that appears on the 
> > console never makes it into a log.  Note that, for the bad cases, I 
> > don't see the same console output that Michael reported, although the 
> > net effect is the same: the partitions don't get found, so I'm offered 
> > the chance to enter my root password and do some poking around, and 
> > when I do, none of the block devices are present under /dev.
> > 
> > I'm open to suggestions on how to take this analysis further.  Michael 
> > indicated he's running a conference this week, so I don't know when 
> > he'll be able to come up for air.
> 
> i'm not sure how to do direct debugging on udev, so i can only guess 
> about what effect on the kernel side could have caused this. One bad 
> hack would be to "probe" udevd's behavior by changing the NET_TR entry 
> in various ways:
> 
>   "tr" -> "token-ring"         # breaks
>   "tr" -> "tr"                 # works
>   "tr" -> "token-rin0"         # ?            (1)
>   "tr" -> "TR"                 # ?            (2)
> 
> the question is, does tweak (1) and tweak (2) work or break?
> 
> but it would be a lot more effective i guess to get some udevd expert's 
> attention on this ...

Could we get the output of:
  ls -l /sys/block/sda/
and:
  grep . /sys/block/sda/*/dev
?

Kay

