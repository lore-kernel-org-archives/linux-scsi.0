From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Tue, 11 Mar 2014 04:14:05 +0000
Message-ID: <1394511243.2142.1.camel@dabdike.int.hansenpartnership.com>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
		 <1394461725-76203-4-git-send-email-hare@suse.de>
	 <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
	 <531E25F3.6090102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:56864 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaCKEOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2014 00:14:50 -0400
In-Reply-To: <531E25F3.6090102@suse.de>
Content-Language: en-US
Content-ID: <9EB282F48C48E149BA7A08335D01D86D@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "jlinton@tributary.com" <jlinton@tributary.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>, "kay@vrfy.org" <kay@vrfy.org>

On Mon, 2014-03-10 at 21:52 +0100, Hannes Reinecke wrote:
> On 03/10/2014 07:24 PM, James Bottomley wrote:
> > On Mon, 2014-03-10 at 15:28 +0100, Hannes Reinecke wrote:
> >> EVPD page 0x83 is used to uniquely identify the device.
> >> So instead of having each and every program issue a separate
> >> SG_IO call to retrieve this information it does make far more
> >> sense to display it in sysfs.
> >
> > Christoph's suggestion of binary sysfs attributes for this rather than
> > the text ones you have is better ... because your current ones are going
> > to truncate when they run off the one page of data sysfs text attributes
> > get (i.e. about 2k of vpd).
> >
> Yes, I thought of that, too.
> I thought to remember that binary attributes are reserved for 
> firmware/hardware-dependent interfaces.
> If that's not the case I'll be moving to a binary attribute here.
> Will be resending the patchset.
> 
> What should happen with the first patch in the series, then?
> When moving to a binary attribute the first patch isn't required 
> anymore; should I drop it or send as a separate patch?

It can be applied separately.

I also still think we can get around the caching problem by requesting
the vpd page every time.  Arrays will change it under us and the cache
will go stale.  Even enclosures sometimes swallow unplug plug events and
simply change the vpd data.

James


James

