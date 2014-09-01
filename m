From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 21/22] scsi: reduce messages for command failure
Date: Mon, 1 Sep 2014 01:14:23 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C2F69F@G9W0745.americas.hpqcorp.net>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-22-git-send-email-hare@suse.de>
 <20140831222840.GM16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39408 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIABPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 21:15:33 -0400
In-Reply-To: <20140831222840.GM16432@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Hoffmann, Elliot" <elliot.hoffmann@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Sunday, 31 August, 2014 5:29 PM
> To: Hannes Reinecke
> Cc: James Bottomley; Ewan Milne; Christoph Hellwig; linux-
> scsi@vger.kernel.org; Hoffmann, Elliot; Yoshihiro Yunomae
> Subject: Re: [PATCH 21/22] scsi: reduce messages for command failure
> 
> On Thu, Aug 28, 2014 at 07:33:35PM +0200, Hannes Reinecke wrote:
> > When devices fail they can generate quite a lot of error
> > messages, possibly overloading the logging system.
> > So we should be putting these messages under logging control
> > to be able to silence them if requested.
> > And we should shorten the overall message; more verbose
> > logging can be requested by the normal scsi logging.
> 
> While the logging mask magic always confused me I'm fairly sure this
> disables logging the completion errors entirely by default.  If that
> was the intention it should be mentioned in the changelog.
> 
> I do however think printing them in a ratelimit way might be useful,
> so I'd like to see a few more arguments for not doing it that way if
> you really prefer it.

Before this patch set, ratelimited printing was impossible because
there were so many partial-line printk calls.  This patch set
may resolve that problem.

Multiple related lines may still cause problems; if it prints
CDB, sense key, and additional sense code on three lines, you
don't want the CDB and sense key suppressed with the additional
sense code still sneaking out (because command completions
are concurrent).

If those issues can be overcome, then I'd favor offering ratelimited
calls.  Maybe the logging level could be used to select the amount,
like:
	0 = no prints
	1..n = ratelimited versions of the prints
	n+1..m = not ratelimited versions of the prints


---
Rob Elliott    HP Server Storage



