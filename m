From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Flexible timout intfrastructure take II
Date: Mon, 21 Jun 2004 11:24:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <380DAEE648059C0AEE63E91D@aslan.scsiguy.com>
References: <1087421869.2796.80.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:2568 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S266337AbUFURYs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:24:48 -0400
In-Reply-To: <1087421869.2796.80.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> [This is basically the same patch posted on the flexible timeout
> infrastructure thread, but with all the comments/doc stuff done as well]
> 
> The object of this infrastructure is to give HBAs early warning that
> error handling is about to happen and also provide them with the
> opportunity to do something about it.

..

> There are three possible returns:
> 
> EH_HANDLED:	I've fixed the problem, please complete the command for me
> (as soon as the timer fires, scsi_done will do nothing, so the timer
> itself will call a special version of scsi_done that doesn't check the
> timer).
> 
> EH_NOT_HANDLED:	Invoke error recovery as normal
> 
> EH_RESET_TIMER:	The command will complete, reset the timer to its
> original value and start it ticking again.

You also need an:

EH_NOT_FOUND:		The HBA knows nothing about this command and
			has probably already completed it, but has no
			state to confirm this.

or do you propose that the drivers just blindly return EH_HANDLED?

Since scsi_done() has no return value, the LLD cannot know if the
attempted completion was ignored due to losing the race with the timer.
So it cannot keep state to ensure that it provides the correct response
(EH_HANDLED) in this case.

--
Justin

