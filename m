From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/4] libfcoe: Add fcoe_sysfs
Date: Tue, 13 Mar 2012 19:42:40 -0700
Message-ID: <20120314024240.GB22955@kroah.com>
References: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
 <20120312230931.10580.58845.stgit@localhost6.localdomain6>
 <20120313050013.GB15426@kroah.com>
 <4F5FF22F.2030105@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030422Ab2CNCmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 22:42:45 -0400
Received: by iagz16 with SMTP id z16so1647886iag.19
        for <linux-scsi@vger.kernel.org>; Tue, 13 Mar 2012 19:42:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F5FF22F.2030105@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>

On Wed, Mar 14, 2012 at 01:19:44AM +0000, Love, Robert W wrote:
> On 03/12/2012 10:00 PM, Greg KH wrote:
> > On Mon, Mar 12, 2012 at 04:09:31PM -0700, Robert Love wrote:
> >> +static void fcoe_ctlr_attrs_release(struct device *dev)
> >> +{
> >> +	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
> >> +
> >> +	put_device(ctlr->dev.parent);
> >> +	ctlr->dev.parent = NULL;
> > You should never have to put a reference count on your parent, nor worry
> > about setting this value to NULL.  Just assign the parent when you
> > register the device, no need to increment it.
> 
> Cool, I'll make these changes.
> 
> >> +#define fcoe_ctlr_id(x)				\
> >> +	((x)->id)
> >> +#define fcoe_ctlr_work_q_name(x)		\
> >> +	((x)->work_q_name)
> > <snip>
> >
> > Ick, what are all of these for, please don't do that.
> >
> 
> These are only interesting when you look at the macros used to create 
> the show/store handlers for the attributes.

<snip>

Ah, yes, sorry, that's worthwhile.

> My feeling is that when you looked at the code you just saw unnecessary 
> accessors routines as their usage is not so obvious. I do not intend to 
> be using these accessors anywhere else other than the withing the 
> show/store building routines.

Ok, and they are in the .c file, not .h, right?

> Given my explanation, do you still dislike these?

Nope, they are fine.

> I could move them to the fcoe_sysfs.c so they're not in a header and 
> therefore would look less like accessors that developers should use...

Yes, that will be good.

thanks,

greg k-h
