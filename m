From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
	Scsi_Host->cmd_serial_number to atomic_t
Date: Sat, 18 Sep 2010 12:57:58 -0700
Message-ID: <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
	 <4C93BB8E.2080501@cisco.com>  <4C9427B6.9050404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C9427B6.9050404@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-09-17 at 21:45 -0500, Mike Christie wrote:
> On 09/17/2010 02:03 PM, Joe Eykholt wrote:
> >
> > How about instead of adding use_serial_number, let's just have the
> > drivers that want a serial number call scsi_cmd_get_serial()
> 
> I think this sounds better.
> 

In that case I will go ahead and add explict scsi_cmd_get_serial() calls
to the LLDs that use struct scsi_cmnd->serial_number in anything beyond
an obvious and simple informational purpose.

> You could also convert drivers to the host tagging if you needed a 
> unique id for each command sent to a host.

Hmmm, what does this entail again..?

> 
> > and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
> > used in debug messages in some drivers.  I didn't find other usages
> > but didn't do an exhaustive search.
> 
> The comments for serial_number say that it is only supposed to be used 
> for debugging printks and most drivers use it for that.

So I would suppose it would be OK for those drivers to continue to
printk serial_number to show the internal serial_number allocation is
now disabled by default.

> However, it looks like mpt and dpt_i2o are using it for error handling
> and/or lookup type of operations. I think the mpt* uses are not needed
> in the abort checks.
> 

In that case, then adding an explict scsi_cmd_get_serial() call in mpt*
and dpt_i20 ->queuecommand() callers would be a good first step.

> And eata is using it for ordering and tracking or something. It could 
> probably be converted to the host tagging if or what you suggested if it 
> needs the uniqueue id.

Adding an explict scsi_cmd_get_serial() for eata for now, and we can
consider LLD canidates for host tag conversion as a future step.

> 
> zfcp looks like it copies it. It does not look like the driver needs it.
> 

Ok, I will look at removing it's usage in zfcp or if necessary add an
the explict scsi_cmd_get_serial() call.

> scsi_error.c uses it in scsi_try_to_abort_cmd to check if a command has 
> completed, but I think that can be done by checking if REQ_ATOM_COMPLETE 
> is set.

Hmmm, good catch here.  Jejb and hch, does this item work for you..?

If so then I will take another peek for any ML uses of a struct
scsi_cmnd->serial_number that need to be addressed, and include Joe's
and Mike's recommendations into a v3 series.

Thanks for your comments here Mike!

--nab
