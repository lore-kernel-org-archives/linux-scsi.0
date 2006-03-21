From: Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] scsi: properly count the number of pages in scsi_req_map_sg()
Date: Tue, 21 Mar 2006 18:19:12 +0200
Message-ID: <20060321161912.GA32051@localdomain>
References: <20060321083830.GA2364@localdomain> <1142956494.4377.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noname.neutralserver.com ([70.84.186.210]:62832 "EHLO
	noname.neutralserver.com") by vger.kernel.org with ESMTP
	id S932204AbWCUQSf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 11:18:35 -0500
Content-Disposition: inline
In-Reply-To: <1142956494.4377.12.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>, brking@us.ibm.com, dror@xiv.co.il

On Tue, Mar 21, 2006 at 09:54:54AM -0600, James Bottomley wrote:
> This is a good email to discuss on the scsi list:
> linux-scsi@vger.kernel.org; whom I've added to the cc list.
> 
> On Tue, 2006-03-21 at 10:38 +0200, Dan Aloni wrote:
> > Improper calculation of the number of pages causes bio_alloc() to
> > be called with nr_iovecs=0, and slab corruption later.
> > 
> > For example, a simple scatterlist that fails: {(3644,452), (0, 60)},
> > (offset, size). bufflen=512 => nr_pages=1 => breakage. The proper
> > page count for this example is 2.
> 
> Such a scatterlist would likely violate the device's underlying
> boundaries and is not legal ... there's supposed to be special code
> checking the queue alignment and copying the bio to an aligned buffer if
> the limits are violated.  Where are you generating these scatterlists
> from?

These scatterlists can be generated using the sg driver. Though I am
actually running a customized version of the sg driver, it seems the 
conversion from a userspace array of sg_iovec_t to scatterlist stays 
the same and also applies to the original driver (see 
st_map_user_pages()).

-- 
Dan Aloni
da-x@monatomic.org, da-x@colinux.org, da-x@gmx.net, dan@xiv.co.il
