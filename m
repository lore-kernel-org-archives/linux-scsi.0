From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Thu, 22 Apr 2004 07:56:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422065603.GK17014@parcelfarce.linux.theplanet.co.uk>
References: <1081518779.2203.29.camel@mulgrave> <20040413171208.GA2550@us.ibm.com> <1082568881.1728.22.camel@mulgrave> <20040422055744.GA7861@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:55176 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262353AbUDVG4E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 02:56:04 -0400
Content-Disposition: inline
In-Reply-To: <20040422055744.GA7861@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Wed, Apr 21, 2004 at 10:57:45PM -0700, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > The slight problem in all this is that the module refcounting model is
> > different from the device one (in modules, you can't send a deletion
> > (rmmod) unless your "ref" count is zero).
> > 
> > The best fix would be to move the module model over to the device model.
> > So you can rmmod at any point, removal triggers the appropriate
> > scsi_remove_device etc calls and the rmmod command hangs around until
> > it's safe to remove the module ... for SCSI we could do this before the
> > device references are dropped because there's a point where we can
> > guarantee no more commands will be sent to the host adapter.

Or we could just admit that there is more to life than a plain refcount.
 
> Yes it would be good to convert the module model someday. We already
> allow today to hot unplug an adapter with the module ref count positive
> and cover almost the same code paths as a rmmod.

I bow to your stunning power of observation.  Of *course* all modules are
like that - so obviously that it would be an unpardonable waste of time to
explore what else might be out there.  If some isolated pathological cases
do not fit that model, they are better off broken, really.

Sheesh...
