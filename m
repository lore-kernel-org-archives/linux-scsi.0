From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Flexible timout intfrastructure take II
Date: 21 Jun 2004 13:11:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087841470.1797.71.camel@mulgrave>
References: <1087421869.2796.80.camel@mulgrave>
	<380DAEE648059C0AEE63E91D@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35997 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266366AbUFUSLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:11:20 -0400
In-Reply-To: <380DAEE648059C0AEE63E91D@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 12:24, Justin T. Gibbs wrote:
> You also need an:
> 
> EH_NOT_FOUND:		The HBA knows nothing about this command and
> 			has probably already completed it, but has no
> 			state to confirm this.
> 
> or do you propose that the drivers just blindly return EH_HANDLED?
> 
> Since scsi_done() has no return value, the LLD cannot know if the
> attempted completion was ignored due to losing the race with the timer.
> So it cannot keep state to ensure that it provides the correct response
> (EH_HANDLED) in this case.

How is this case different from EH_HANDLED?  If the command has been
completed after the timer fired then it still needs to be completed when
the driver is notified of the timeout.

James


