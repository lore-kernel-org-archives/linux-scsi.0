From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 16:48:22 -0800
Message-ID: <1202258902.2220.102.camel@haakon2.linux-iscsi.org>
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
	 <47A8B29B.8050406@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:38233 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761098AbYBFAsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:48:51 -0500
In-Reply-To: <47A8B29B.8050406@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Julian Satran <Julian_Satran@il.ibm.com>

On Tue, 2008-02-05 at 22:01 +0300, Vladislav Bolkhovitin wrote:
> Jeff Garzik wrote:
> > Alan Cox wrote:
> > 
> >>>better. So for example, I personally suspect that ATA-over-ethernet is way 
> >>>better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
> >>>low-level, and against those crazy SCSI people to begin with.
> >>
> >>Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> >>would probably trash iSCSI for latency if nothing else.
> > 
> > 
> > AoE is truly a thing of beauty.  It has a two/three page RFC (say no more!).
> > 
> > But quite so...  AoE is limited to MTU size, which really hurts.  Can't 
> > really do tagged queueing, etc.
> > 
> > 
> > iSCSI is way, way too complicated. 
> 
> I fully agree. From one side, all that complexity is unavoidable for 
> case of multiple connections per session, but for the regular case of 
> one connection per session it must be a lot simpler.
> 
> And now think about iSER, which brings iSCSI on the whole new complexity 
> level ;)

Actually, the iSER protocol wire protocol itself is quite simple,
because it builds on iSCSI and IPS fundamentals, and because traditional
iSCSI's recovery logic for CRC failures (and hence alot of
acknowledgement sequence PDUs that go missing, etc) and the RDMA Capable
Protocol (RCaP).

The logic that iSER collectively disables is known as within-connection
and within-command recovery (negotiated as ErrorRecoveryLevel=1 on the
wire), RFC-5046 requires that the iSCSI layer that iSER is being enabled
to disable CRC32C checksums and any associated timeouts for ERL=1.

Also, have a look at Appendix A. in the iSER spec.

      A.1. iWARP Message Format for iSER Hello Message ...............73
      A.2. iWARP Message Format for iSER HelloReply Message ..........74
      A.3. iWARP Message Format for SCSI Read Command PDU ............75
      A.4. iWARP Message Format for SCSI Read Data ...................76
      A.5. iWARP Message Format for SCSI Write Command PDU ...........77
      A.6. iWARP Message Format for RDMA Read Request ................78
      A.7. iWARP Message Format for Solicited SCSI Write Data ........79
      A.8. iWARP Message Format for SCSI Response PDU ................80

This is about as 1/2 as many traditional iSCSI PDUs, that iSER
encapulates.

--nab

