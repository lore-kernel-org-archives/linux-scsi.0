From: Neil Brown <neilb@suse.de>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 21:19:58 +1000
Message-ID: <18195.19678.500863.613193@notabene.brown>
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015014503.GF9715@thunk.org>
	<200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbXJOLUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 07:20:10 -0400
In-Reply-To: message from Rob Landley on Monday October 15
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday October 15, rob@landley.net wrote:
> 
> This is my objection.  Even when enumerating multiple devices of the same type 
> is tricky, enumerating multiple devices of _different_ types should not be.  
> There's a great big type indicator that is being _deliberately_ ignored, and 
> large classes of devices (millions of laptops) where you know there's only 
> going to be _one_ instance of a given type.

My perspective is different.

The range of addressing option for "all disk devices" is far too rich
to be able to assign a stable device number every device: there are
multiple, multi-dimensional addressing scheme, and some devices might
not even have a stable address at all (e.g. USB?).
So the reality of dealing with disk devices is that you cannot provide
a stable single-number naming scheme for all devices on all machines.

Therefore it is best to not have stable single-number naming schemes
for any devices on any machines.  Why?  Because it ensure there will
not be any second class citizens.

If some devices that are even reasonably common (e.g. IDE drives) are
stable, then some application developers or system integrators will
work under the assumption of stability and whatever they build will
break when you try it on different hardware.  This happened during the
early days of SCSI support - code assumed the stability of
major/minor numbers and so did not work properly with SCSI which
cannot provide that stability in general.

Having a totally uniform approach makes development and testing a lot
easier - there are fewer special cases.

I would prefer that 'total uniformity' went even further than
/dev/sd?? to /dev/disk??.  i.e. Anything that is or behaves
substantially like a disk drive should be "/dev/diskXX", where numbers
are assigned sequentially on discovery. (I wonder why we need
/dev/scdX to be separate from /dev/sdX).

Note that stable names a still a very real option.  udev provides
several.  /dev/disk-by-path/XXX will be stable for lots of "screwed
in" devices.  /dev/disk-by-id will be stable for devices the report a
unique id. etc.

The different between IDE, SATA, SCSI and even USB is peripheral for
the large majority of uses, and I think maintaining the distinction in
the major/minor number or in the "primary" /dev name is - for the
above reasons - more of a cost that a value.

NeilBrown
