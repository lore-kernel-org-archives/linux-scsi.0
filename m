From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error
 recovery
Date: Fri, 13 Jun 2014 08:49:57 -0700
Message-ID: <1402674597.2224.20.camel@dabdike.int.hansenpartnership.com>
References: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
	 <53849960.60505@linux.vnet.ibm.com> <539B190D.2040509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44812 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbaFMPuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 11:50:00 -0400
In-Reply-To: <539B190D.2040509@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 10:30 -0500, Brian King wrote:
> On 05/27/2014 08:55 AM, Nathan Fontenot wrote:
> > On 05/23/2014 10:52 AM, Brian King wrote:
> >> If a CRQ reset is triggered for some reason while in the middle
> >> of performing VSCSI adapter initialization, we don't want to
> >> call the done function for the initialization MAD commands as
> >> this will only result in two threads attempting initialization
> >> at the same time, resulting in failures.
> >>
> >> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> > 
> > Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> > 
> >> ---
> >>
> >>  drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix drivers/scsi/ibmvscsi/ibmvscsi.c
> >> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix	2014-05-23 10:36:04.000000000 -0500
> >> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:50:03.000000000 -0500
> >> @@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
> >>  				       evt->hostdata->dev);
> >>  			if (evt->cmnd_done)
> >>  				evt->cmnd_done(evt->cmnd);
> >> -		} else if (evt->done)
> >> +		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
> >> +			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
> >>  			evt->done(evt);
> >>  		free_event_struct(&evt->hostdata->pool, evt);
> >>  		spin_lock_irqsave(hostdata->host->host_lock, flags);
> >> _
> 
> Hi James,
> 
> Are these two patches in your queue? They both fix rather nasty issues
> that have caused kernel crashes in our testing.

Should they be cc'd to stable, or are they recently introduced bugs?

James


