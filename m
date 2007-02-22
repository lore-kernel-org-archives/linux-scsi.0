From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 14:18:09 -0600
Message-ID: <20070222201809.GA1530@beardog.cca.cpqcorp.net>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:55768 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXBVUSL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 15:18:11 -0500
Content-Disposition: inline
In-Reply-To: <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Wed, Feb 21, 2007 at 07:14:27PM -0800, Andrew Morton wrote:
> >
> > +  	if (total_size == 0xFFFFFFFF) {
> 
> I seem to remember having already questioned this.  total_size is sector_t, which
> can be either 32-bit or 64-bit.  Are you sure that comparison works as
> intended in both cases?
> 
> 
> > +		if(total_size == 0xFFFFFFFF) {
> >  			cciss_read_capacity_16(cntl_num, i, 0,
> >  			&total_size, &block_size);
> >  			hba[cntl_num]->cciss_read = CCISS_READ_16;
> 
> Here too.

Andrew,
Using this test program and changing the type of x to int, long, long long signed and
unsigned the comparison always worked on x86, x86_64, and ia64. It looks to me like
the comparsion will always do what we expect. Unless you see some other problem.


#include <stdio.h>

int main(int argc, char *argv[])
{
	unsigned long long x;
	
	x =  0x00000000ffffffff;

	printf(sizeof(x) == 8 ? 
		"x = %lld, sizeof(x) = %d\n" :
		"x = %ld, sizeof(x) = %d\n",  x, sizeof(x));
	if (x == 0xffffffff)
		printf("equal\n");
	else
		printf("not equal\n");
	
}

-- mikem
