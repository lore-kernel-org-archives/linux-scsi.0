From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Tue, 28 Oct 2003 10:40:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028104054.K4263@vienna.EGENERA.COM>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com> <20031027120631.E4263@vienna.EGENERA.COM> <20031027093116.A21595@beaverton.ibm.com> <20031028091920.J4263@vienna.EGENERA.COM> <20031028070640.A8503@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:24194 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S264009AbTJ1PnN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:43:13 -0500
Content-Disposition: inline
In-Reply-To: <20031028070640.A8503@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Oct 28, 2003 at 07:06:40AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

Rumor has it that on Tue, Oct 28, 2003 at 07:06:40AM -0800 Patrick Mansfield said:

> udev needs to somehow handle duplicates, but unless we tell it a
> device is multi-pathed, it can't tell an error case (tried to give the
> same name to two separate devices) from the multi-path case.
> 

Does udev need to care about multi-pathing? I'm not sure that it does - it doesn't 
do multi-pathing, it just makes device nodes, right?

It seems that if we want the underlying paths to show up as separate named devices 
we would need to use an ID key that is different from the one that the multipath 
detection code uses so that we do get the underlying paths. That's why I 
suggested the below. 
 
If it's the same ID key, we'd be relying on udev's duplicate handling behavior and
the results would likely be order dependent. 

> > It may be that the way this is used best is to use it as a call out in udev 
> > if you're not doing multi-path. Then if you are using MP, configure udev to 
> > use scsi bus based names and have the MP detection script call out to scsi_id.
> > That's at least how I think I would set it up.
> 
> That is one way to configure them. The current udev would need a lot of
> entries to handle all possible names - if you wanted to be able to add
> a new LUN or path and have it just show up with the path in its name.
>

I would have hoped for a setting to do that without having to configure each
individual possible entry. Something that made it work similar to the scsidev utility.

> Users might also want the name of the MP device to be similar to the
> names for the paths of the device. This means udev would need to be passed
> information that these are multi-pathed devices (assuming it would
> otherwise create only one entry).
> 

Do md/dm devices get created by udev? Then the problem shows up again. 
We'd get the md device named "disk-1" as well :)

Cheers,

Phil


-- 
Philip R. Auld, Ph.D.                  Technical Staff 
Egenera Corp.                        pauld@egenera.com
165 Forest St., Marlboro, MA 01752       (508)858-2600
