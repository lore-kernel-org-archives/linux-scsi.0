From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 00:51:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095864709.6297.5.camel@gaston>
References: <1095789421.2467.414.camel@mulgrave>
	 <200409211409.11095.jbarnes@engr.sgi.com>
	 <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
	 <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
	 <20040921214302.GG146363@sgi.com>
	 <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
	 <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
	 <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	 <1095864485.2143.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:25298 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266003AbUIVOzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 10:55:31 -0400
In-Reply-To: <1095864485.2143.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>


> I favour 1. iomb; I think, since I/O barriers can be either heavyweight
> or non-existent depending on the architecture, iomb() should imply mb()
> but not vice versa.

Read & write barriers are different for IO. Actually, as I stated earlier,
the real issue isn't much with IO barriers proper (which are mostly dealt
with within the implementation of the IO accessors), but in IO vs. memory
accesses, at least on PPC. Cacheable and non-cacheable accesses go through
completely different path on the CPU and can be completely re-ordered one
to each other unless more heavy barriers are used. That has been a pain
for ages for us since Linux doesn't provide an abstraction to order those,
it would be nice to get that in place now ;)

Ben.


