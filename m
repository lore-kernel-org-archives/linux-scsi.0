From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit
 packets in the RESET path
Date: Tue, 09 Oct 2012 12:38:20 +0100
Message-ID: <1349782700.2615.65.camel@dabdike.int.hansenpartnership.com>
References: <1349201011-14572-1-git-send-email-kys@microsoft.com>
	 <426367E2313C2449837CD2DE46E7EAF930A1FCB6@SN2PRD0310MB382.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A1FCB6@SN2PRD0310MB382.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-08 at 15:51 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > Sent: Tuesday, October 02, 2012 2:04 PM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org
> > Cc: KY Srinivasan; stable@vger.kernel.org
> > Subject: [PATCH 1/1] Drivers: scsi: storvsc: Account for in-transit packets in the
> > RESET path
> > 
> > Properly account for I/O in transit before returning from the RESET call.
> > In the absense of this patch, we could have a situation where the host may
> > respond to a command that was issued prior to the issuance of the RESET
> > command at some arbitrary time after responding to the RESET command.
> > Currently, the host does not do anything with the RESET command.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/scsi/storvsc_drv.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 528d52b..0144078 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1221,7 +1221,12 @@ static int storvsc_host_reset_handler(struct scsi_cmnd
> > *scmnd)
> >  	/*
> >  	 * At this point, all outstanding requests in the adapter
> >  	 * should have been flushed out and return to us
> > +	 * There is a potential race here where the host may be in
> > +	 * the process of responding when we return from here.
> > +	 * Just wait for all in-transit packets to be accounted for
> > +	 * before we return from here.
> >  	 */
> > +	storvsc_wait_to_drain(stor_device);
> > 
> >  	return SUCCESS;
> >  }
> > --
> > 1.7.4.1
> 
> James,
> 
> This patch is critical for running Linux based workloads on our Cloud infrastructure - Azure.
> Please let me know if there are any issues.

So just for next time: it's a bit hard to work out this is a critical
issue from the change log.  If I had to guess, I'd say the response to a
command killed by reset causes some type of use after free and a
potential oops (all of which would have been very nice in the change
log)?

James
        
