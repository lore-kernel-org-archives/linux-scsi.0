From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 6 Jun 2003 13:23:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606202350.GC3330@beaverton.ibm.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> <3EE0B316.4060207@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:37042 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262283AbTFFUI3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 16:08:29 -0400
Content-Disposition: inline
In-Reply-To: <3EE0B316.4060207@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

Luben Tuikov [tluben@rogers.com] wrote:
> James was talking about ``device server not ready'' aliased to
> online -- i.e. if online is 0 then only INQUIRY or TUR should
> be sent from SCSI Core (unless SCSI Core decides to _know_ about
> the different ULP).  The semantics on this are somewhat touched
> in the INQUIRY description in SPC-3.
> 
> (This means that the device is on the SAN, but not ready to
> process commands.)
> 
> You're talking about hardware removal -- more specifically
> logical removal of a host -- in which case of course there's no
> _host_, so how can online be checked.... (online being
> member of sdev, sdev being parented by shost...)
> 
> IOW, you probably need either a flag in shost, to mean that
> it's logically removed (whether hdwr or not) until it is
> actually gone, or an external flag per host... it's your call.
> 

I agree we need some indication the the host is gone as mention in the
above paragraph and previously by others in similar threads.

Instead of talking bit fields it might be good to write down the states
for scsi_device and Scsi_Host and the policy for each state. This is
partially being done in this thread, but I believe it is confusing as we
keep mapping to an already overloaded bit field.

I am currently updating my previously posted SCSI Mid refcounting text
to match recent updates by Christoph. I am also adding current bit fields
in scsi_device and Scsi_Host used for state.

It might be helpful to indicate when a hotplug event will go out and the
expected action. I currently do not have this in the document.

-andmike
--
Michael Anderson
andmike@us.ibm.com

