From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH 2/2] RE: How to add/drop SCSI drives from within the drive r?
Date: Thu, 9 Dec 2004 22:15:55 -0600
Message-ID: <20041210041555.GA9972@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E570230CAA0@exa-atlanta> <1102645481.3814.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:21609 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261692AbULJEQD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 23:16:03 -0500
Content-Disposition: inline
In-Reply-To: <1102645481.3814.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Dec 09, 2004 at 08:24:41PM -0600, James Bottomley wrote:
> On Thu, 2004-12-09 at 20:21 -0500, Bagalkote, Sreenivas wrote:
> > +i.	Introduced driver ioctl that returns scsi address for a given ld.
> > +	
> > +	"Why can't the existing sysfs interfaces be used to do this?"
> > +		- Brian King (brking@us.ibm.com)
> > +	
> > +	"I've looked into solving this another way, but I cannot see how
> > +	to get this driver-private mapping of logical drive number-> HCTL
> > +	without putting code something like this into the driver."
> 
> OK now I look at the code, I have another suggestion.  Why not simply
> publish the logical drive number as an extra file in the device sysfs
> directory?  That way you can get your C:H:T:L, go to the end of the tree
> and cat megaraid_sd (or whatever you want to call it).

That works in the delete case, but doesn't work in the add case,
because there's no SCSI device created (yet) to have a sysfs directory
to put the file to get the information userspace needs to call
../../scan.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
