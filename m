From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in
	sgiwd93.c
Date: Wed, 03 Dec 2008 15:02:22 -0600
Message-ID: <1228338142.5551.77.camel@localhost.localdomain>
References: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
	 <46353.88.114.226.209.1228321494.squirrel@webmail.movial.fi>
	 <1228324123.5551.25.camel@localhost.localdomain>
	 <ac3eb2510812030952k5b57a9c7qb68e3684de170d75@mail.gmail.com>
	 <1228327306.5551.36.camel@localhost.localdomain>
	 <35647.88.114.226.209.1228329736.squirrel@webmail.movial.fi>
	 <ac3eb2510812031051k9d9312bma119bfae35afc230@mail.gmail.com>
	 <1228330800.5551.58.camel@localhost.localdomain>
	 <ac3eb2510812031229l51912169o3e96346ed51c48f0@mail.gmail.com>
	 <1228337529.5551.72.camel@localhost.localdomain>
	 <ac3eb2510812031259v1a4ebe25tc841daaa2fe5a722@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52816 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYLCVCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 16:02:21 -0500
In-Reply-To: <ac3eb2510812031259v1a4ebe25tc841daaa2fe5a722@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Greg KH <greg@kroah.com>

On Wed, 2008-12-03 at 21:59 +0100, Kay Sievers wrote:
> On Wed, Dec 3, 2008 at 21:52, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2008-12-03 at 21:29 +0100, Kay Sievers wrote:
> >> On Wed, Dec 3, 2008 at 20:00, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> >> We are already in the middle of a ~400 files "struct device" bus_id
> >> >> conversion, and only very few maintainers respond to these patches. We
> >> >> also never got any reply to the SCSI bus_id patch we sent weeks ago.
> >> >> :)
> >> >
> >> > When did you send it?  Searching the scsi archives on bus_id produces no
> >> > results, what was the subject line?
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver-core/bus_id-scsi.patch;hb=HEAD
> >
> > Hmm, OK ... if you want a review, over the SCSI list is best.
> >
> > Things like this:
> >
> >
> >> --- a/drivers/scsi/scsi_ioctl.c
> >> 182 +++ b/drivers/scsi/scsi_ioctl.c
> >> 183 @@ -170,7 +170,8 @@ static int scsi_ioctl_get_pci(struct scs
> >> 184
> >> 185          if (!dev)
> >> 186                 return -ENXIO;
> >> 187
> >> -        return copy_to_user(arg, dev->bus_id, sizeof(dev->bus_id))? -EFAULT: 0;
> >> 188 +        return copy_to_user(arg,
> >> 189
> >> +                           dev_name(dev), strlen(dev_name(dev)))? -EFAULT: 0;
> >> 190  }
> >
> > Give cause for concern:  in the original, we know we scribble over 20
> > bytes of user space.  With the new one we scribble over an unknown
> > number (which could potentially be much greater than 20).  That's an
> > accident waiting to happen in userspace.
> 
> Yeah, but the name will have no real limit. What should we do here?
> Just Truncate at 20, because we "know" it's not longer?

Well, the problem is the stupid ioctl which gives nowhere to say how
many bytes the buffer is.  For safety's sake, yes, I think you have to
limit it to 20 bytes.  Otherwise, on the day we introduce long names
some random application using this ioctl will die with data corruption
and that will be extremely hard to debug.

James


