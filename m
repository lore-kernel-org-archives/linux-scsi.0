From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Tue, 28 Oct 2003 07:06:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028070640.A8503@beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com> <20031027120631.E4263@vienna.EGENERA.COM> <20031027093116.A21595@beaverton.ibm.com> <20031028091920.J4263@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:48794 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263988AbTJ1PHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:07:52 -0500
Content-Disposition: inline
In-Reply-To: <20031028091920.J4263@vienna.EGENERA.COM>; from pauld@egenera.com on Tue, Oct 28, 2003 at 09:19:20AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Tue, Oct 28, 2003 at 09:19:20AM -0500, Philip R. Auld wrote:

> From what I read about it that doesn't make sense. Udev will use the callout 
> to scsi_id, get the id and use the name "disk-1" if it matches (in your 
> example). What it does when it finds that it has already created "disk-1" 
> I guess is the issue. It could just remake it and you'd end up only having 
> a udev device for the last one found. I could be misunderstanding udev 
> still though :) 

udev needs to somehow handle duplicates, but unless we tell it a
device is multi-pathed, it can't tell an error case (tried to give the
same name to two separate devices) from the multi-path case.

> It may be that the way this is used best is to use it as a call out in udev 
> if you're not doing multi-path. Then if you are using MP, configure udev to 
> use scsi bus based names and have the MP detection script call out to scsi_id.
> That's at least how I think I would set it up.

That is one way to configure them. The current udev would need a lot of
entries to handle all possible names - if you wanted to be able to add
a new LUN or path and have it just show up with the path in its name.

Users might also want the name of the MP device to be similiar to the
names for the paths of the device. This means udev would need to be passed
information that these are multi-pathed devices (assuming it would
otherwise create only one entry).

-- Patrick Mansfield
