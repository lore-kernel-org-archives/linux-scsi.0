From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH ver3] isd200: Allocate sense_buffer for hacked up
	scsi_cmnd
Date: Thu, 13 Mar 2008 15:16:53 -0500
Message-ID: <1205439413.2893.49.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803121109210.4595-100000@iolanthe.rowland.org>
	 <47D7F5A3.9010004@panasas.com>
	 <1205340884.2941.112.camel@localhost.localdomain>
	 <47D80D60.3060006@panasas.com> <47D810C9.90309@panasas.com>
	 <20080313130112.22c0776f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48944 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbYCMURA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 16:17:00 -0400
In-Reply-To: <20080313130112.22c0776f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, svens@stackframe.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 2008-03-13 at 13:01 -0700, Andrew Morton wrote:
> On Wed, 12 Mar 2008 19:20:09 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > 
> > Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
> > own struct scsi_cmnd like here isd200, must also take care of their own
> > sense_buffer.
> > 
> > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > ---
> >  drivers/usb/storage/isd200.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
> > index 4f2d143..971d13d 100644
> > --- a/drivers/usb/storage/isd200.c
> > +++ b/drivers/usb/storage/isd200.c
> > @@ -1470,6 +1470,7 @@ static void isd200_free_info_ptrs(void *info_)
> >  	if (info) {
> >  		kfree(info->id);
> >  		kfree(info->RegsBuf);
> > +		kfree(info->srb.sense_buffer);
> >  	}
> >  }
> >  
> > @@ -1495,7 +1496,9 @@ static int isd200_init_info(struct us_data *us)
> >  				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
> >  		info->RegsBuf = (unsigned char *)
> >  				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
> > -		if (!info->id || !info->RegsBuf) {
> > +		info->srb.sense_buffer =
> > +				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> > +		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
> >  			isd200_free_info_ptrs(info);
> >  			kfree(info);
> >  			retStatus = ISD200_ERROR;
> 
> I've thoroughly lost the plot here.

Don't worry ... that's why life gave us SCSI maintainers ...

>   Is this needed in 2.6.25?  If so, why?

Yes.  Because the changes that separate the sense buffer from the
commmand allocation which cause this bug went in in the merge window for
2.6.25

James


