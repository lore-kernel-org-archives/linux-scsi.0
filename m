From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 12:20:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615192045.GA13704@us.ibm.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com> <40CF4207.9050108@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:39605 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265880AbUFOTUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 15:20:55 -0400
Content-Disposition: inline
In-Reply-To: <40CF4207.9050108@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov [luben_tuikov@adaptec.com] wrote:
> >Could we get the eh_times_out part of the patch broken out as the
> >addition of the return values look like a good idea along with some
> >method to call a modified version of scsi_done through a exported
> >function to the LLDD.
> 
> Hm, yes, I saw the thread back in January I believe it was on this.
> 
> Basically I want to keep queuecommand() and scsi_done()
> pretty much unchanged -- being antagonists of each other.
> 
> SAM 5.4 describes that interface (SCSI Core <--> LLDD) and
> SAM 5.1 describes Application Client <--> SCSI Core.
> 
> We seem on track with 5.4 and I'd rather not overload
> scsi_done().
> 
> Note that this patch would be a lot _less_ intrusive than the
> one propsed in January, as the one proposed in January
> discloses the internals of SCSI Core to LLDD, via
> the scsi midlayer scsi_eh_scmd_add() method which
> drivers would be supposed to call.
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107461451911771&w=2
> 
> I'd rather all this information be conveyed through
> the Service Response and Status Code values to be
> returned to SCSI Core from the LLDD via scsi_done(), in
> the scsi command structure.
> 
> Then SCSI Core makes the decision, as to what is to be
> done with the command.
> 
> This patch is very small and non-intrusive with 0 effects
> to any LLDD or SCSI Core.

In the patch as is you overload the eh_cmd_timed_out template function
to mean the LLDD wants to try to handle timed out commands plus start /
restart / stop the timers. This would appear to limit the interface to
the LLDD doing both operations which should be separate decisions?

Also in the comments for the patch you mention that the LLDD may decide
to resubmit the IO which I assume is why you would want to have control
of the timers, but wouldn't the LLDD need to also consult if the IO
should be resubmitted which propagates these tests and could result in
inconsistent policy.

-andmike
--
Michael Anderson
andmike@us.ibm.com

