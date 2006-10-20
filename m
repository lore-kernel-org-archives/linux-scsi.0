From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: Fix warnings (and bug on 1TB discs)
Date: Fri, 20 Oct 2006 09:53:42 -0500
Message-ID: <E717642AF17E744CA95C070CA815AE55AE2CF8@cceexc23.americas.cpqcorp.net>
References: <20061020032755.GQ2602@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:40599 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S2992629AbWJTOxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2006 10:53:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20061020032755.GQ2602@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> 
> On Thu, Oct 19, 2006 at 09:23:36PM -0600, Matthew Wilcox wrote:
> > CCISS was producing warnings about shifts being greater 
> than the size 
> > of the type and pointers being of incompatible type.  Turns 
> out this 
> > is because it's calling do_div on a 32-bit quantity.  Upon further 
> > investigation, the sector_t total_size is being assigned to an int, 
> > and then we're calling do_div on that int.  Obviously, 
> sector_div is 
> > called for here, and I took the chance to refactor the code 
> a little.
> 
> Oops, forgot:
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Acked-by: Mike Miller <mike.miller@hp.com>

> 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index 
> > dcccaf2..bc66026 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -1923,7 +1923,6 @@ static void cciss_geometry_inquiry(int c  {
> >  	int return_code;
> >  	unsigned long t;
> > -	unsigned long rem;
> >  
> >  	memset(inq_buff, 0, sizeof(InquiryData_struct));
> >  	if (withirq)
> > @@ -1939,26 +1938,23 @@ static void cciss_geometry_inquiry(int c
> >  			printk(KERN_WARNING
> >  			       "cciss: reading geometry failed, volume "
> >  			       "does not support reading geometry\n");
> > -			drv->block_size = block_size;
> > -			drv->nr_blocks = total_size;
> >  			drv->heads = 255;
> >  			drv->sectors = 32;	// Sectors per track
> > -			t = drv->heads * drv->sectors;
> > -			drv->cylinders = total_size;
> > -			rem = do_div(drv->cylinders, t);
> >  		} else {
> > -			drv->block_size = block_size;
> > -			drv->nr_blocks = total_size;
> >  			drv->heads = inq_buff->data_byte[6];
> >  			drv->sectors = inq_buff->data_byte[7];
> >  			drv->cylinders = 
> (inq_buff->data_byte[4] & 0xff) << 8;
> >  			drv->cylinders += inq_buff->data_byte[5];
> >  			drv->raid_level = inq_buff->data_byte[8];
> > -			t = drv->heads * drv->sectors;
> > -			if (t > 1) {
> > -				drv->cylinders = total_size;
> > -				rem = do_div(drv->cylinders, t);
> > -			}
> > +		}
> > +		drv->block_size = block_size;
> > +		drv->nr_blocks = total_size;
> > +		t = drv->heads * drv->sectors;
> > +		if (t > 1) {
> > +			unsigned rem = sector_div(total_size, t);
> > +			if (rem)
> > +				total_size++;
> > +			drv->cylinders = total_size;
> >  		}
> >  	} else {		/* Get geometry failed */
> >  		printk(KERN_WARNING "cciss: reading geometry failed\n");
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" 
> > in the body of a message to majordomo@vger.kernel.org More 
> majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 
