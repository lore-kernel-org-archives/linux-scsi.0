From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [ANNOUNCE] hotplug-ng 001 release
Date: Fri, 18 Feb 2005 10:33:50 -0800
Message-ID: <20050218183350.GA21954@us.ibm.com>
References: <20050211211028.GB21512@suse.de> <20050212003458.GI2568@katya> <20050214224208.GC13110@suse.de> <20050216105117.GB2360@katya> <20050216110752.GC2360@katya> <1108594961l.5056l.5l@serve.riede.org> <20050216231741.GD2870@katya> <1108596771l.5056l.6l@serve.riede.org> <20050218171737.GA20012@us.ibm.com> <20050218181106.GC4424@katya>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e35.co.us.ibm.com ([32.97.110.133]:16085 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261426AbVBRSeS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 13:34:18 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1IIYHLg627414
	for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2005 13:34:17 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1IIYHMW452698
	for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2005 11:34:17 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1IIYGAN018131
	for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2005 11:34:17 -0700
Content-Disposition: inline
In-Reply-To: <20050218181106.GC4424@katya>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roman Kagan <rkagan@mail.ru>, Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Fri, Feb 18, 2005 at 09:11:06PM +0300, Roman Kagan wrote:
> On Fri, Feb 18, 2005 at 09:17:37AM -0800, Patrick Mansfield wrote:
> > You could also append the sdev->vendor and sdev->model, and use alias wild
> > cards.
> 
> String values haven't been used in the aliases so far, and I think for a
> reason: with all the unpredictable weird characters and string lengths
> they would make maintainance harder, not easier.

Yes, but modprobe should just work with them, even if scripts or other
usage has problems. I haven't seen any really odd strings for vendor or
model, ususally just spaces and alphanumeric, I don't remember (or even
remember where to look) for the allowed characters; there are always
devices that behave badly.

> > Also, sg loading would want (along with modprobe load all feature):
> > 
> > MODULE_ALIAS("scsi-type-*");
> 
> Is it certain that it can live together with s[dtr]?  I thought these
> guys now handled all the ioctls sg was supposed to themselves...

Yes.

The block SG_IO handles the ioctls, but not devices without a SCSI upper
level driver (i.e. not tape, disk or cdrom).

For example, media changers (though a driver has just been submitted),
scanners, enclosure devices, or printers (I've never seen any scsi
printers).

In my experience, there are always applications that want to use the
standard device driver (/dev/sda etc.) and others that want to use a
generic driver.

-- Patrick Mansfield
