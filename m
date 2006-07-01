From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.17-mm5
Date: Sun, 2 Jul 2006 08:32:28 +1000
Message-ID: <17574.63484.261979.866512@cse.unsw.edu.au>
References: <20060701033524.3c478698.akpm@osdl.org>
	<20060701142419.GB28750@tlg.swandive.local>
	<20060701143047.b3975472.akpm@osdl.org>
	<1151792765.3438.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:17582 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751201AbWGAWcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2006 18:32:45 -0400
In-Reply-To: message from James Bottomley on Saturday July 1
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Grant Wilson <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Saturday July 1, James.Bottomley@SteelEye.com wrote:
> On Sat, 2006-07-01 at 14:30 -0700, Andrew Morton wrote:
> > On Sat, 1 Jul 2006 15:24:19 +0100
> > Grant Wilson <grant.wilson@zen.co.uk> wrote:
> > 
> > > More RAID1 problems - OOPS on shutdown.
> 
> Actually, is there any more of the trace, like what was going on just
> before the oops?
> 
> It looks very like a lifetime issue (i.e. md thinks the array is dead
> and has torn it down, but there's still an outstanding command).  It
> would be nice to know what the outstanding command might have been.

md writes the superblock after tearing down the array, which is
admittedly a bit careless.

The problem seems to be simply that on some hardware at least,
BIO_RW_BARRIER writes result in an EIO.  Don't know why yet.

NeilBrown
