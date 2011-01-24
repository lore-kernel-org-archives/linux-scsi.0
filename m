From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Crash in 2.6.37
Date: Mon, 24 Jan 2011 19:14:02 +0100
Message-ID: <1295892842.4379.16.camel@belgarion.office.romunt.nl>
References: <4D3C05E9.9030105@grumpydevil.homelinux.org>
	 <1295828488.8278.33.camel@mulgrave.site>
	 <4D3D2054.1060905@grumpydevil.homelinux.org>
	 <20110124150031.0a30e263@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tritonia.xxlwebhosting.nl ([81.4.88.63]:60150 "EHLO
	tritonia.xxlwebhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1AXSOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 13:14:24 -0500
In-Reply-To: <20110124150031.0a30e263@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2011-01-24 at 15:00 +0100, Stefan Richter wrote:
> On Jan 24 Rudy Zijlstra wrote:
> > On 01/24/2011 01:21 AM, James Bottomley wrote:
> > > On Sun, 2011-01-23 at 11:41 +0100, Rudy Zijlstra wrote:
> > >    
> > >> Dears,
> > >>
> > >> I got the following crash by:
> > >> - cp several G onto a raid 5 on a Marvell 88SE6480//// based controller
> > >> while also doing
> > >> - cp * ../test/ on the same raid.
> > >>
> > >> I strongly suspect mvsas to be the cause
> > >>      
> > > I've got to ask why?
> > >    
> > cause the 88SE6480 has been giving grief for a long time, and i was 
> > loading that one specifically.
> > you may well be right (i do not read crash info i fear), but a bit 
> > strange to have NFS crash when nfs was not much used at that moment
> > 
> [...]
> > >> [ 2821.393697] Pid: 1105, comm: rpc.mountd Not tainted 2.6.37 #1
> > >> X7SB4/E/X7SB4/E
> > >> [ 2821.393697] RIP: 0010:[<ffffffff815a1b5c>]  [<ffffffff815a1b5c>]
> > >> cache_revisit_request+0xab/0x105
> > >>      
> > > This says the bad deref occurred in the sunrpc authentication cache.
> > > Nothing at all in the trace implicates mvsas ... in fact nothing even
> > > remotely relates to it at all.  It really looks like an NFS problem.
> 
> Perhaps a silent memory corruption, with an innocent bystander becoming a
> victim?
> 
> Rudy, if possible repeat the test with NFS completely shut down and
> disabled.


I'll schedule that for Saturday morning. Earliest time i can disable NFS
without user impact and do another stress test on mvsas. And i need to
be physically close to the system, as a kernel crash needs a reset
button to recover.

