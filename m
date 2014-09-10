From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/21] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Wed, 10 Sep 2014 06:51:15 -0700
Message-ID: <20140910135115.GA22861@kroah.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
 <1410349611-17573-2-git-send-email-hdegoede@redhat.com>
 <54103AA3.7000801@redhat.com>
 <1410350184.12706.18.camel@linux-fkkt.site>
 <54103D73.5050104@redhat.com>
 <1410353663.12706.20.camel@linux-fkkt.site>
 <54104EFD.1090701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaIJNwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 09:52:03 -0400
Content-Disposition: inline
In-Reply-To: <54104EFD.1090701@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

On Wed, Sep 10, 2014 at 03:15:41PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/10/2014 02:54 PM, Oliver Neukum wrote:
> > On Wed, 2014-09-10 at 14:00 +0200, Hans de Goede wrote:
> >> Hi,
> >>
> >> On 09/10/2014 01:56 PM, Oliver Neukum wrote:
> >>> On Wed, 2014-09-10 at 13:48 +0200, Hans de Goede wrote:
> >>>> Hi,
> >>>>
> >>>> Note this series is NOT intended for stable, but I accidentally
> >>>> had "cc = stable@vger.kernel.org" in my .git/config when sending
> >>>> this series, please ignore for stable.
> >>>>
> >>>> NACK for stable.
> >>>
> >>> If this is not for stable, what do you intend to do about
> >>> the problems in stable? For example patch#01 of this series
> >>> looks like clear stable material to me.
> >>
> >> The plan for stable is mostly, as lame as that is, to make sure
> >> we get all the right quirks in place so that error handling
> >> does not get triggered, for now.
> > 
> > How? A medium can be defect. Short of entirely disabling it,
> > error handling will be triggered.
> 
> I agree that this is a concern, but defective disks are not the
> norm. All the bugs I've received sofar seem to be about incompatibilities
> between the Linux uas/scsi stack and the device, not defective mediums.
> 
> >> I agree that once this set has seen wider testing, we should
> >> reconsider, and probably add it, to stable. But at this point
> >> in time I'm worried that it may cause regressions, and as such
> >> it is not stable material atm IHMO.
> > 
> > Well, we would exchange something known to work imperfectly
> > for something feared to work imperfectly.
> 
> True. Note as said I'm not against this going into stable, I just don't
> want to rush it into stable. So first lets get it reviewed and into
> 3.18 (and see how it works for the users who have been having troubles
> sofar, see my request for testing), and then see from there.
> 
> I assume that you agree that this is (way) too late for 3.17?

Yes it is.

And I agree, let's test this out first, and if it solves problems,
_then_ we can backport it to stable as needed.

thanks for the patches, I'll queue them up for 3.18.

greg k-h
