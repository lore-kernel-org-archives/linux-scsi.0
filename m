From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
Date: Fri, 17 Sep 2010 05:20:21 +0200
Message-ID: <20100917032021.GB25217@lst.de>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org> <1284691571.26423.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1284691571.26423.50.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2010 at 10:46:11PM -0400, James Bottomley wrote:
> So at least from where I stand, my object is to reduce the number of
> times we take and release the lock, which this doesn't do.  As I said
> before: we need to figure out the rest, which likely includes an atomic
> for the serial number (which is almost unused).  I think the check
> against SHOST_DEL is fine unlocked.


The check by itself for sure is.  But I wonder whether we make any
assumptions about it not changing while we are in ->queuecommand, which
isn't nessecarily the case after this patch.
