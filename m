From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RESEND 1/2] SCSI: use scsi_device->timeout consistently
Date: Mon, 20 Nov 2006 23:25:34 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611202311280.6260@kai.makisara.local>
References: <20061119125115.GJ2184@htj.dyndns.org>
 <Pine.LNX.4.64.0611192353590.4946@kai.makisara.local> <4560E825.3080504@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:54487 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S966308AbWKTVYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 16:24:25 -0500
In-Reply-To: <4560E825.3080504@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, 20 Nov 2006, Tejun Heo wrote:

> Kai Makisara wrote:
> > On Sun, 19 Nov 2006, Tejun Heo wrote:
> > 
> > > Each high level driver uses scsi_device->timeout diffrently.
> > >
> > ...
> > > Index: scsi-misc-2.6/drivers/scsi/st.c
> > > ===================================================================
> > > --- scsi-misc-2.6.orig/drivers/scsi/st.c
> > > +++ scsi-misc-2.6/drivers/scsi/st.c
> >> @@ -3986,7 +3986,8 @@ static int st_probe(struct device *dev)
> > >   tpnt->partition = 0;
> > >   tpnt->new_partition = 0;
> > >   tpnt->nbr_partitions = 0;
> > > -	tpnt->device->timeout = ST_TIMEOUT;
> > > +	if (!SDp->timeout)
> > > +		SDp->timeout = ST_TIMEOUT;
> > 
> > I don't think this should be done. It probably makes the default timeout way
> > too short. The error recovery with tapes takes a long time. The user can
> > change the timeout if the default (900 seconds) seems too long (or short).
> > 
> > I don't think there is anything in the midlevel or low-level code to set the
> > timeout based on the device characteristics. This is left to the ULD.
> 
> Low level driver should configure timeout or retries to a known value iff it
> knows what it's doing, when it knows both transport and device-type specific
> characteristic.

I am not so optimistic ;-)

>                 AFAICS, the only driver which modifies sdev->timeout is ipr
> and it does so only when it knows the device is of certain type.  So, I don't
> think it will cause any trouble, and using different initialization in
> different ULDs is too subtle.
> 
It does not cause trouble now but I think it is an accident waiting to 
happen. The ULD probably knows more about the device characteristics than 
the low-level driver. (I admit that there are other than device specific 
aspects in setting timeouts and these should not be in ULD.)

What about this variant:
	if (SDp->timeout < ST_TIMEOUT)
		SDp->timeout = ST_TIMEOUT;

It does guarantee that the timeout is long enough for tape drives. It also 
lets the low-level driver set a longer timeout if it has some reason to 
make it longer than the ULD does.

-- 
Kai
