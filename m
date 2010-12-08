From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Wed, 08 Dec 2010 15:19:42 +0100
Message-ID: <1291817982.2181.1380.camel@quux.techfak.uni-bielefeld.de>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
	 <alpine.LNX.2.00.1011301813460.9731@kai.makisara.local>
	 <1291223211.2814.72.camel@larosa>
	 <alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
	 <alpine.LNX.2.00.1012060952570.7928@kai.makisara.local>
	 <1291628171.2181.1366.camel@quux.techfak.uni-bielefeld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:54955 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab0LHOTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2010 09:19:43 -0500
In-Reply-To: <1291628171.2181.1366.camel@quux.techfak.uni-bielefeld.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon, 2010-12-06 at 10:36 +0100, Lukas Kolbe wrote:
> On Mon, 2010-12-06 at 09:59 +0200, Kai Makisara wrote:
> > On Thu, 2 Dec 2010, Kai Makisara wrote:
> 
> > OK, today I have had some time (national holiday). I think I have tracked 
> > down this problem. The patch at the end should fix it. Basically, 
> > normalize_buffer() needs to know the order of the pages in order to 
> > properly free the pages and update the buffer size. When allocation 
> > failed, the order was not yet stored into the tape buffer definition. This 
> > does explain the problem after allocation failed.
> 
> Thank you, this does indeed look nasty (like a not easily catched bug).
> 
> > Why allocation failed is another problem which has been discussed elsewhere.
> 
> I just tonight discovered that Debian's .config has
> CONFIG_FUSION_MAX_SGE=40. Right now I'm testing with the mptsas' drivers
> maximum of 128 and see if I can reproduce the failure under memory
> pressure again. Sorry for not catching this one earlier! After reading
> the source, I had the assumption that it already was 128 ...

Debian has since fixed to the new default value here, and after a few
days of testing with CONFIG_FUSION_MAX_SGE=128 and your patch I wasn't
able to reproduce the failure anymore!

Kind regards,
Lukas


