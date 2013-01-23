From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 1/9] [SCSI] Detect overflow of sense data buffer
Date: Wed, 23 Jan 2013 16:21:07 -0500
Message-ID: <1358976067.4420.381.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <1358526434-1173-2-git-send-email-emilne@redhat.com>
	 <1358527592.2345.35.camel@dabdike.int.hansenpartnership.com>
	 <1358867323.4420.315.camel@localhost.localdomain>
	 <1358946385.2584.56.camel@dabdike.int.hansenpartnership.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AWVVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 16:21:17 -0500
In-Reply-To: <1358946385.2584.56.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2013-01-23 at 13:06 +0000, James Bottomley wrote:
> On Tue, 2013-01-22 at 10:08 -0500, Ewan Milne wrote:
> > On Fri, 2013-01-18 at 16:46 +0000, James Bottomley wrote:
> > > On Fri, 2013-01-18 at 11:27 -0500, Ewan D. Milne wrote:
> > > > --- a/drivers/scsi/scsi_error.c
> > > > +++ b/drivers/scsi/scsi_error.c
> > > > @@ -241,6 +241,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
> > > >  	if (! scsi_command_normalize_sense(scmd, &sshdr))
> > > >  		return FAILED;	/* no valid sense data */
> > > >  
> > > > +	if (sshdr.overflow)
> > > > +		scmd_printk(KERN_WARNING, scmd, "Sense data overflow");
> > > > +
> > > >  	if (scsi_sense_is_deferred(&sshdr))
> > > >  		return NEEDS_RETRY;
> > > >  
> > > > @@ -2059,14 +2062,18 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
> > > >  			sshdr->asc = sense_buffer[2];
> > > >  		if (sb_len > 3)
> > > >  			sshdr->ascq = sense_buffer[3];
> > > > +		if (sb_len > 4)
> > > > +			sshdr->overflow = ((sense_buffer[4] & 0x80) != 0);
> > > >  		if (sb_len > 7)
> > > >  			sshdr->additional_length = sense_buffer[7];
> > > >  	} else {
> > > >  		/*
> > > >  		 * fixed format
> > > >  		 */
> > > > -		if (sb_len > 2)
> > > > +		if (sb_len > 2) {
> > > > +			sshdr->overflow = ((sense_buffer[2] & 0x10) != 0);
> > > >  			sshdr->sense_key = (sense_buffer[2] & 0xf);
> > > > +		}
> > > >  		if (sb_len > 7) {
> > > >  			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
> > > >  					 sb_len : (sense_buffer[7] + 8);
> > > 
> > > This isn't the right way to do it:  The overflow bit is a recent
> > > introduction in SPC-4.  The correct way to tell if we have an overflow
> > > or not is to look at the additional sense length and compare it to the
> > > allocation length; this will work for everything.
> > 
> > Unfortunately, I am not sure that the allocation length that was sent
> > to the device is always available.
> 
> Well, yes it is, we just don't store it.  scsi_normalize_sense() takes
> as input the length of the sense buffer we gave it.  If we want an
> overflow indication, we can certainly compare that against the
> additional length (assuming we have enough bytes to get the additional
> length).
> 
> >   I will look into this more closely
> > but it appeared to me that e.g. FC drivers like qla2xxx get the sense
> > data automatically from the HBA firmware.  In the case of that driver
> > the host sense buffer size looks like it is hard-coded to 32 bytes,
> > for all I know the firmware might only asking for 18 bytes.
> 
> You mean for their ACA emulation in the transport?  They have to be
> picking up at least the standard minimum in order not to be in
> violation, surely?

I'm sure that's the case, I just don't know if the minimum is big
enough.  See below.

> 
> > Of course, for a normal REQUEST SENSE command where the allocation
> > length is in the CDB, it would indeed be easy to add a check against
> > the additional sense length.
> > 
> > > 
> > > I'm not even convinced that overflow is important: for a lot of the
> > > sense probes, we deliberately induce overflows by giving the request
> > > sense command a short buffer.  Printing a warning in scsi_check_sense
> > > will get very noisy very fast.
> > 
> > That would indeed be a problem.  I didn't see this behavior when testing
> > the changes but I'll need to investigate this further.
> > 
> > The purpose of detecting the sense data overflow was to provide some
> > visibility that a device is returning a large amount of sense data that
> > is currently being silently ignored.  In the case of descriptor format
> > sense data, it is possible that a descriptor we want to examine is
> > located after one or more other descriptors, and we might not get it
> > at all if the buffer isn't large enough.
> 
> But why should we care?  A lot of the time it will be spewing
> descriptors with irrelevant FRU information.  I really think printing
> there's been an overflow isn't a good idea.  I'm not sure there's much
> use in the sshdr indicating there's been one.  It *may* be useful to
> indicate how big the allocation length should have been, but I'm not
> even convinced of that, since the data is now lost.

My thinking was that it was important to log the fact that the device
had reported a Unit Attention queue overflow, which is reported in a
sense key specific descriptor, so I was concerned that if the sense
buffer wasn't big enough, the host would never see that there had
been a UA queue overflow.  That was why I had added the logging of
a sense buffer overflow.  I wasn't so much interested in reporting
sense buffer overflow for its own sake.

So, as it stands right now, I think I'll remove the 1/9 component
of the patch set, unless there is consensus that it is really needed.

> 
> James
> 
> 


