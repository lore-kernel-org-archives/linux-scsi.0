From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sat, 29 Jan 2005 10:44:41 -0600
Message-ID: <1107017081.4535.29.camel@mulgrave>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:23530 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261301AbVA2QpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 11:45:02 -0500
In-Reply-To: <1106977566.9862.102.camel@plap>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
> Returning back DID_IMM_RETRY for these 'transport' related conditions
> would of course help in this issue -- but at the same time bring with it
> several side-effects which may not be desirable.
> 
> So, beyond this particular circumstance, what would be considered a
> 'proper' return status for this type of event? 

Well, the correct return, since this is a condition from the storage, is
simply the check condition and the sense code (rather than having the
driver interpret it).

> > Would this be an approach to consider?  Or should we tackle the problem
> > by addressing the quirky (cmd->retries > cmd->allowed) state?

That's what I think the correct approach should be....we have a few
other quirky devices that aren't pleased with our current NOT_READY
handling.  Were you going to look into coding up a patch for this?

James


