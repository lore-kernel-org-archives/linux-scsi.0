From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 17:43:20 -0800
Message-ID: <1202262200.2220.118.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net> <47A8B510.8000807@garzik.org>
	 <47A8B757.10101@vlnb.net>
	 <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:21908 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750917AbYBFBvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 20:51:10 -0500
In-Reply-To: <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Julian Satran <Julian_Satran@il.ibm.com>

On Tue, 2008-02-05 at 16:11 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2008-02-05 at 22:21 +0300, Vladislav Bolkhovitin wrote:
> > Jeff Garzik wrote:
> > >>> iSCSI is way, way too complicated. 
> > >>
> > >> I fully agree. From one side, all that complexity is unavoidable for 
> > >> case of multiple connections per session, but for the regular case of 
> > >> one connection per session it must be a lot simpler.
> > > 
> > > Actually, think about those multiple connections...  we already had to 
> > > implement fast-failover (and load bal) SCSI multi-pathing at a higher 
> > > level.  IMO that portion of the protocol is redundant:   You need the 
> > > same capability elsewhere in the OS _anyway_, if you are to support 
> > > multi-pathing.
> > 
> > I'm thinking about MC/S as about a way to improve performance using 
> > several physical links. There's no other way, except MC/S, to keep 
> > commands processing order in that case. So, it's really valuable 
> > property of iSCSI, although with a limited application.
> > 
> > Vlad
> > 
> 
> Greetings,
> 
> I have always observed the case with LIO SE/iSCSI target mode (as well
> as with other software initiators we can leave out of the discussion for
> now, and congrats to the open/iscsi on folks recent release. :-) that
> execution core hardware thread and inter-nexus per 1 Gb/sec ethernet
> port performance scales up to 4x and 2x core x86_64 very well with
> MC/S).  I have been seeing 450 MB/sec using 2x socket 4x core x86_64 for
> a number of years with MC/S.  Using MC/S on 10 Gb/sec (on PCI-X v2.0
> 266mhz as well, which was the first transport that LIO Target ran on
> that was able to reach handle duplex ~1200 MB/sec with 3 initiators and
> MC/S.  In the point to point 10 GB/sec tests on IBM p404 machines, the
> initiators where able to reach ~910 MB/sec with MC/S.  Open/iSCSI was
> able to go a bit faster (~950 MB/sec) because it uses struct sk_buff
> directly. 
> 
 
Sorry, these where IBM p505 express (not p404, duh) which had a 2x
socket 2x core POWER5 setup.  These along with an IBM X-series machine)
where the only ones available for PCI-X v2.0, and this probably is still
the case. :-)

Also, these numbers where with a ~9000 MTU (I don't recall what the
hardware limit on the 10 Gb/sec switch lwas) doing direct struct iovec
to preallocated struct page mapping for payload on the target side.
This is known as RAMDISK_DR plugin in the LIO-SE.  On the initiator, LTP
disktest and O_DIRECT where used for direct to SCSI block device access.

I can big up this paper if anyone is interested.

--nab

