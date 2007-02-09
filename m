From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] completely convert sg to block layer helpers
Date: Fri, 09 Feb 2007 15:08:43 -0600
Message-ID: <45CCE2DB.307@cs.wisc.edu>
References: <1171010083.3713.29.camel@max> <45CCD03D.2030509@cs.wisc.edu> <45CCD139.9000500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36568 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946622AbXBIVIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 16:08:53 -0500
In-Reply-To: <45CCD139.9000500@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Mike Christie wrote:
>> Mike Christie wrote:
>>> any missing functionality. I am still testing the patch. I have not
>>> tested some of the older sg interfaces
>> I am pretty sure (100% :)), that I messed up the old interface handling.
>>
>>> -
>>> -static int
>>> -sg_write_xfer(Sg_request * srp)
>>> -{
>>> -	sg_io_hdr_t *hp = &srp->header;
>>> -	Sg_scatter_hold *schp = &srp->data;
>>> -	struct scatterlist *sg = schp->buffer;
>>> -	int num_xfer = 0;
>>> -	int j, k, onum, usglen, ksglen, res;
>>> -	int iovec_count = (int) hp->iovec_count;
>>> -	int dxfer_dir = hp->dxfer_direction;
>>> -	unsigned char *p;
>>> -	unsigned char __user *up;
>>> -	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
>>> -
>>> -	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
>>> -	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
>>> -		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
>>> -		if (schp->bufflen < num_xfer)
>>> -			num_xfer = schp->bufflen;
>> In sg_write_xfer here, for the old interface is it valid to have
>> hp->dxfer_len greater than hp->flags, then have sg_read_oxfer get
>> num_read_xfer that is not equal to hp->dxfer_len?
> 
> Could num_read_xfer would also not be equal to hp->flags, so three
> different values?


Three different values might be a bug, but the code should not oops. I
updated the code so that could support three different sizes if it ever
comes up. It does the same checks for schp->bufflen < num_xfer to handle
some of the problems and blk_rq_copy_user takes a write_len and len
value so if hp->dxfer_len are different hp->flags we copy the right
amount of data. I already changed the uncopy equivalent to copy on what
is passed in sg_read for the old interface.

I put the updated patches here
http://people.redhat.com/mchristi/sg/v3/
they were made against Jens bsg branch.

I will resend them, once I get comments or do more major cleanups and
fixes. But they are there if you want to look at them.
