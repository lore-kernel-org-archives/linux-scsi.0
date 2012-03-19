From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Date: Mon, 19 Mar 2012 22:40:19 +0000
Message-ID: <1332196819.3152.77.camel@dabdike>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	 <1332115963-26855-1-git-send-email-kys@microsoft.com>
	 <1332173560.3152.65.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-03-19 at 16:50 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Monday, March 19, 2012 12:13 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result correctly
> > when SRB status is INVALID
> > 
> > On Sun, 2012-03-18 at 17:12 -0700, K. Y. Srinivasan wrote:
> > > Currently Windows hosts only support a subset of scsi commands and for
> > commands
> > > that are not supported, the host returns a generic SRB failure status.
> > > However, they have agreed to change the return value to indicate that
> > > the command is not supported. In preparation for that, handle the
> > > SRB_STATUS_INVALID_REQUEST return value correctly.
> > >
> > > I would like to thank Jeff Garzik <jgpobox@gmail.com> and
> > > Douglas Gilbert <dgilbert@interlog.com> for suggesting the correct approach
> > > here.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/scsi/storvsc_drv.c |   12 ++++++++++++
> > >  1 files changed, 12 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > index 44c7a48..018c363 100644
> > > --- a/drivers/scsi/storvsc_drv.c
> > > +++ b/drivers/scsi/storvsc_drv.c
> > > @@ -202,6 +202,7 @@ enum storvsc_request_type {
> > >  #define SRB_STATUS_INVALID_LUN	0x20
> > >  #define SRB_STATUS_SUCCESS	0x01
> > >  #define SRB_STATUS_ERROR	0x04
> > > +#define SRB_STATUS_INVALID_REQUEST 0x06
> > 
> > I don't really think this is the correct approach.  We already have a
> > SCSI error return for this, which you're now translating in the driver
> > and hypervisor.  Rather than have a special byte return of
> > SRB_STATUS_INVALID_REQUEST, why not have the hypervisor do the right
> > thing and fill in the ILLEGAL_REQUEST sense return.  That way you don't
> > need a special error code and you don't need to construct the sense
> > buffer in the driver.  Now HyperV will be correctly set up for both pass
> > through and emulated responses.  It's surely not much work and you
> > already process sense data correctly in storvsc_command_completion(), so
> > you wouldn't need any patches to the driver for this approach.
> 
> James, the issue here is that currently shipping Windows hosts don't even do
> what I am handling here.

Right, I understand that.

>  Based on the input I got from you and Christoph,
> I convinced the windows team to at least return the SRB status that indicates
> an illegal request. I will suggest to them that perhaps they should also set the
> correct sense code and so I would not need this patch.

Not also; instead of.  There's no need for an extra SRB status.  Just
return the standard check condition sense data.

>  However, keep in mind
> that there is no current ETA on when Windows will ship with these changes - Windows 8
> may ship with code where they would return an invalid SRB status, but they are not 
> setting the sense code, hence this patch. When the Window host does the "right thing"
> I will clean this up, but I don't know when that will be.

I thought you just said you'd only just asked them if they could
implemented it, in which case no version of windows currently ships with
this, correct?

> More importantly, the second patch  in this series where I filter out
> the ATA_16 command
> on the guest is really important for us. Without that patch on a range
> on windows hosts
> including the current beta version of windows8 where the host is
> returning a generic 
> error in response to ATA_16 command, we cannot boot many Linux
> distros. If you
> prefer, I can drop the first patch and re-submit the second patch for
> consideration now.

I'm not sure about that either.  You presumably translate
SRB_STATUS_ERROR into DID_TARGET_FAILURE.  That should cause the
termination of the command with prejudice in exactly the same way as an
ILLEGAL_REQUEST sense code would (minus the useful error information),
so what's causing the boot failure?

James
