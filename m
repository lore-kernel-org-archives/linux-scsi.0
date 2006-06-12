From: Doug Maxey <dwm@bebe.enoyolf.org>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 14:01:17 -0500
Message-ID: <20060612190117.494981@bebe.enoyolf.org>
References: <8889.1149988615@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:5614 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932076AbWFLTBl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 15:01:41 -0400
In-reply-to: <20060612164934.GA7576@ranandlinuxbox.oc.cox.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org


On Mon, 12 Jun 2006 09:49:34 PDT, Ravi Anand wrote:
> >On Sat, 10 Jun 2006, Doug Maxey wrote:
> > 
> > Subject: [RFC] qla4xxx: TODO for re-submission
> > 
> > Howdy!
> > 
> > The qla4xxx driver for the QLogic ISP4XXX chipset will be getting a
> > little janitorial love along the lines of:
> > 
> > A) a rework of the 2006-06-06 Qlogic submitted qla4xxx code to get the
> >    driver to be in line with the kernel coding style.
>      
>      Agreed. There are some cleanup's that still need to be done.
>      If you have the patch please forward it over.
> 		
> > B) being made more compliant with the scsi_mid_low_api.txt.
>     
>      OK. Whats the missing piece ? 

Right now, the original driver is in functional separate pieces,
which is good from a development team standpoint.  One of the requests
(directives?) from smla is to have the driver in one file.  Dunno,
really not that big deal to me, but with function re-order, we could
shrink the line count by roughly 30%, from my current estimate.

Once that is done, the patch submissions could flow from functionally
standalone pieces that compile, but may not actually do anything.
The subsequent patches would add the layers of current functionality
(and the newer transport stuff) in layers, and be in small enough pieces
to allow easy review.

Making the driver patches suitable for easy review is really my goal...

> 	
> >    Being compiled for M$ does not count as an alternative OS. :)  In
> >    particular, move all the code to single .c file.  If and when
> >    another chipset comes along that can utilize some of the bits, look
> >    into splitting it back up.
>     
>      Layout of the file is pretty intutive and we would like to it
>      pretty much inline like the qla2xxx FC driver. 
>      Anyway this is very low down the priroity. Getting the other
>      items done which you have outlined below is more important.

maybe on your list. :)  Mike may have Christoph's and James' ears,
but the earlier offline comments lead me to believe otherwise, at least
style-wise.  Of course, Mike is the QB on this, so anxiously awaiting 
his comments.

> 
> > C) removal of unreachable or unused code.
>      Agreed.
> 
> > D) a rework of the function layout and size, including linewidth adjustments
> 
>      Patch would help to understand.

Yeah, let me wade through this once first.
 
> 
> > E) fixups to printk formatting, and moving to dev_printk().  For the
> >    first pass, just remove the debug printk()'s
> 
>      Agreed. 

wilco.

> > 
> > This will not be a re-write of the driver per se, just a refactoring
> > going on in parallel to the work of the QLogic folks and mike, in an
> > effort to get this driver into mainline.
> > 
> > The plan is to:
> > 1) submit the Documentation/LICENSE.qla4xxx.txt file and check
> >    the provenance with the original submitters..
>       
>      We already submitted it. Will be updating it most probably.

Yes, but see my response for B).  :->

> 
> > 2) pull all the data structs into the file, swizzle the types to be
> >    kernel compliant.
>      OK.
> 
> > 3) pull the core driver initialization (module_init(), pci init et al)
> >    into the file drivers/scsi/qla4xxx.c
>      Same as outlined in  B.
> 
> > 4) add the iscsi transport code.
> > 5) add the block layer code.
> 
>      In my mind item 4 & 5 are the important one's that we need to accomplish.
>      Mike I believe has done some of the modifications in the latest patch
>      set which he send out recently on open-iscsi reflector.
> > 6) add the device firmware access.
>      
>      Not sure about this.

simply an ordering of patches.  Maybe that should go in as step 2.

> 
> > 7) add the hooks for the Kconfig and Makefile
> > 
>     In one of the later patches we did update the top level Makefile and Kconfig.

Am thinking this would be the last of the series, no need to build if it 
does not get accepted. 

> 
> > Does this appear to be a workable plan?  Should the struct cleanup
> > wait and come in on an as needed basis?
> 
>   Yes, it is. Prioritising the work is important. Broadly speaking item 4 & 5 are the imporantant
>   ones as well cleaning up the code to be more compliant with the linux style.
> 
>   Apart from what David Somayajulu is working on, there are other stuff which we need to do
>   on the driver side. Important piece is the sysfs stuff which I am working on.
> 
>   If you can takeup the item 4 & 5 that would be great. Cleanup part let me know what part 
>   want to do  and I can do the rest.
>   
> > 
> > All comments will be appreciated.
> > 
> 
> Thanx for putting it together.
> 
> Ravi
> 


