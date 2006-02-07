From: Willem Riede <osst@riede.org>
Subject: Re: osst changes required to move forward to block request
Date: Mon, 06 Feb 2006 20:02:21 -0500
Message-ID: <1139274141l.7464l.1l@athena.riede.org>
References: <20060206131944.GA1769@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:12477 "EHLO
	rwcrmhc14.comcast.net") by vger.kernel.org with ESMTP
	id S964921AbWBGBCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 20:02:39 -0500
In-Reply-To: <20060206131944.GA1769@lst.de> (from hch@lst.de on Mon Feb  6
	08:19:44 2006)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 02/06/2006 08:19:44 AM, Christoph Hellwig wrote:
> Hi Willem,
> 
> do you still maintain the osst driver?  We're moving forward to
> completly get rid of the scsi_request structure in the scsi midlayer,
> and osst is the only upper level driver still using it.  I've tried to
> convert it similar to st, but gave up.  The biggest problem for me is
> the scsi_request reuse over the driver where a pointer to a pointer to
> a scsi_request is passed along all the callchain, and I have a really
> hard time to find out whether the functions actually looks it, or only

"looks it"?? don't understand :-(

> reuse it.  The latter isn't nessecary these days that the slab allocator
> behind struct scsi_request does a very good job, and definitly not
> needed after converting away from it.
> 
> If you're still interested in the driver it would be very nice if you
> could untangle it so that the scsi_request is only passed along in
> places where subroutines need to look at it - after that converting
> the driver should be more along the lines of st so a lot easier.  I'd
> be more than happy to lend a helping hand or to in the conversion once
> I actually understand what I'm doing :)  It would be a pity to either
> stop the scsi subsystem from moving forward because of osst or breaking
> the driver.
> 
> 
> p.s. there's quite a few other changes in st that osst hasn't caught up
> on, maybe it's time for a big resync?

Yes, I'm still maintaining the driver, but since it does what it needs to, and  
there have not been any bug reports lately, things have been quiet on the osst  
front.

I have noticed some of the st changes, but things like the direct user space  
wouldn't have made much gain for osst, dues to the relatively low speed of the  
drives, compared to latest generation tape drives that st deals with.

But I will certainly help retire scsi_request. And anything else that is  
needed to keep up with proper kernel style. Let me know what those are, if you  
would? I'll start looking at how st has changed, and will be back with any  
questions I may have.

Regards, Willem Riede.
