From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI kobject unregistration ordering problem
Date: Mon, 13 Oct 2003 16:01:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031013230149.GA1956@beaverton.ibm.com>
References: <20031013151254.521d882e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:45269 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262074AbTJMW5k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2003 18:57:40 -0400
Content-Disposition: inline
In-Reply-To: <20031013151254.521d882e.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Andrey Borzenkov <arvidjaar@mail.ru>, viro@parcelfarce.linux.theplanet.co.uk

Andrew Morton [akpm@osdl.org] wrote:
> 
> Guys,
> 
> I have the below patch queued, but Greg and Pat don't like it because
> 
> > > For one, the fact a parent is unregistered before its children violates
> > > the intended semantics of the interface. #$^!@#$ SCSI. They know this, and
> > > they should not be doing it.
> >
> > Exactly, that's why I do not want this patch applied.  The SCSI people
> > have said they would fix this problem, as they should.  Let's not paper
> > over the issue with this kobject patch.
> 
> So it looks like SCSI needs fixing.  Could someone please take care of this?
> Thanks.
> 

I will get back on this. As I previously stated in the thread below the
patch makes the problem go away, but is not the right fix for the "real"
problem. The issues of the delayed call to device_del causes other get /
put issues for changes Christoph is trying to do. I thought there was a
need for another release function in the block layer for cases of
surprise disconnect, but I will get more current data by changing a view
to not delay the call to device_del.

http://marc.theaimsgroup.com/?l=linux-kernel&m=106401215205983&w=2

-andmike
--
Michael Anderson
andmike@us.ibm.com

