From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: 16 Jun 2004 14:17:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087413469.2796.58.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF28034F94EE@xbl.ma.emulex.com>
	<1087405441.2067.25.camel@mulgrave>  <40D09845.9030201@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35784 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264610AbUFPTR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 15:17:59 -0400
In-Reply-To: <40D09845.9030201@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: "Smart, James" <James.Smart@Emulex.Com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-16 at 13:58, Luben Tuikov wrote:
> EH_RESET_TIMER means "This command had nothing to do with why
> its timer timed out and is expected to complete shortly."
> 
> Do we want to increment its retry counter for this,
> as it isn't really a retry.

It's a simple way to ensure the interface doesn't get abused.  As long
as the command is truly completed, there won't be a problem.

> > handling into the behaviour the user has requested.  The only wrinkle
> > was the no retry streaming commands.  The assumption is that a retry
> 
> They also fall in the same category -- the application client cannot
> retry them, but the LLDD knows best and it may perform some magic
> for which SCSI Core shouldn't account for.

Yes, that's why the proposal permits a single retry of an ostensibly
non-retryable command.

> > doesn't actually happen under eh_timed_out, but only an attempt to
> > collect an existing command which may be delayed because of transport or
> > other problems the host knows about.
> 
> Can we get a finalised patch so we can test it?
> James, is the one you posted what you'll have in?

I need to add comments and things, it can probably be in scsi-misc-2.6
in a day or so.

James


