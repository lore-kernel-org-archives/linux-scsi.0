From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 0/3] scsi: ufs & ums-*: fix module reference counting
Date: Thu, 8 Jan 2015 10:13:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501081010500.1633-100000@iolanthe.rowland.org>
References: <CAC5umyj7=e9OxssjTMJ_QszY5y09j7puwDUnCn9wPbcEYob28w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53934 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932304AbbAHPNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 10:13:25 -0500
In-Reply-To: <CAC5umyj7=e9OxssjTMJ_QszY5y09j7puwDUnCn9wPbcEYob28w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Thu, 8 Jan 2015, Akinobu Mita wrote:

> >> Why don't ufs and usb-storage define the host templates in the sub drivers?
> >> That's what libata or the mpt fusion driver do.
> >
> > Originally the subdrivers were all part of usb-storage.  When they were
> > split out into separate modules, there didn't seem to be any need to
> > copy the host template into each one.  (Especially since some of the
> > method pointers in the host template refer to routines in usb-storage
> > itself, not in the subdrivers.)  The fact that the .module member was
> > no longer adequate escaped our notice at the time.
> 
> For ufs, the reason why a host template is shared by sub drivers is similar
> to usb-storage.  Originally there was only a single pci driver for ufs.
> When platform driver for ufs was introduced, it was split into core driver
> (ufshcd) and sub drivers (ufshcd-pci and ufshcd-pltfrm).  They require
> exactly the same host template.
> 
> Is there any other preferable way to fix this problem?  The first time I
> found this in ufs driver, I was trying to fix it by merging core and sub
> drivers into a single compound module.  But I realized that usm-* drivers
> have the same problem, then I decided to propose what this patch series do
> instead.

I can't think of any other ways to fix it.  The only options seem to be
to duplicate the host template in each subdriver or to add the .module
field to the host structure.  I prefer the second option because it
doesn't involve so much code duplication.

Alan Stern

