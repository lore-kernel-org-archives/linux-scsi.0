From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 17:00:33 -0600
Message-ID: <1202166033.3096.141.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48660 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757265AbYBDXAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:00:41 -0500
In-Reply-To: <20080204224314.113afe7b@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>


On Mon, 2008-02-04 at 22:43 +0000, Alan Cox wrote:
> > better. So for example, I personally suspect that ATA-over-ethernet is way 
> > better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
> > low-level, and against those crazy SCSI people to begin with.
> 
> Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> would probably trash iSCSI for latency if nothing else.

Actually, there's also FCoE now ... which is essentially SCSI
encapsulated in Fibre Channel Protocols (FCP) running over ethernet with
Jumbo frames.  It does the standard SCSI TCQ, so should answer all the
latency pieces.  Intel even has an implementation:

http://www.open-fcoe.org/

I tend to prefer the low levels as well.  The whole disadvantage for IP
as regards iSCSI was the layers of protocols on top of it for
addressing, authenticating, encrypting and finding any iSCSI device
anywhere in the connected universe.

I tend to see loss of routing from operating at the MAC level to be a
nicely justifiable tradeoff (most storage networks tend to be hubbed or
switched anyway).  Plus an ethernet MAC with jumbo frames is a large
framed nearly lossless medium, which is practically what FCP is
expecting.  If you really have to connect large remote sites ... well
that's what tunnelling bridges are for.

James


