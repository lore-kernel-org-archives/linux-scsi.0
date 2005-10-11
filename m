From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 5378] New: aic7xxx deadlock/freeze on Adaptec
	AIC-7899P
Date: Mon, 10 Oct 2005 22:00:49 -0500
Message-ID: <1128999650.4824.41.camel@mulgrave>
References: <200510061626.j96GQxFD025499@fire-1.osdl.org>
	 <20051010184144.4dfe2241.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25039 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751359AbVJKDBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 23:01:01 -0400
In-Reply-To: <20051010184144.4dfe2241.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-10-10 at 18:41 -0700, Andrew Morton wrote:
> ISTR that there have been several reports of this regression.
> 
> What could have caused this?

Well ... the prior bug reports with this are in aic79xx, and there there
were no significant code changes between the working and the non working
versions.  The aic7xxx driver has been fairly significantly changed but
all in the area of setup and initialisation.

This one looks like a sequencer error, possibly induced by a flakey bus.
Apparently it actually managed to recover once, which is surprising for
the aic driver, but then it died a second time around.  There actually
was a sequencer change (backport from aic latest driver) that could be
responsible.  However, it's in both 2.6.12 and 2.6.13.

James


