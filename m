From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle
 errors from the host
Date: Wed, 25 Apr 2012 09:53:19 +0100
Message-ID: <1335343999.3075.12.camel@dabdike.lan>
References: <1333654012-23850-1-git-send-email-kys@microsoft.com>
	  <426367E2313C2449837CD2DE46E7EAF92CE74A@CH1PRD0310MB381.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF92CE74A@CH1PRD0310MB381.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-04-18 at 12:38 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Tuesday, April 10, 2012 11:14 AM
> > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > apw@canonical.com
> > Subject: RE: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors
> > from the host
> > 
> > 
> > 
> > > -----Original Message-----
> > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > Sent: Thursday, April 05, 2012 3:27 PM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > > apw@canonical.com
> > > Cc: KY Srinivasan
> > > Subject: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Properly handle errors from
> > > the host
> > >
> > > If the host returns error for pass through commands, deal with them
> > > appropriately. I would like to thank James for patiently helping
> > > me with this patch.
> > 
> > James,
> > 
> > Thank you for suggesting the fix here. I hope this is what you were looking for.
> > 
> > Regards,
> > 
> > K. Y

OK, I have the patch, but the change log is a bit rubbish.  I changed it
to

Hyper-V cannot process some commands like ATA_12 and ATA_16. It also returns a
very generic error when this happens (SRB_STATUS_ERROR).  Most of the time we
treat SRB_STATUS_ERROR as DID_TARGET_FAILURE which causes error handler retry,
but in the case of pass through commands, they'll never succeed (and the error
handler will offline the device), so put a discriminating block in the command
completion routing and send the SRB_STATUS_ERROR upwards with DID_PASSTHROUGH
for commands we know should not be retried.

James
