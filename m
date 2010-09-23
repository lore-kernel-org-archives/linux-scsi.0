From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
	Scsi_Host->cmd_serial_number to atomic_t
Date: Thu, 23 Sep 2010 14:46:29 -0700
Message-ID: <1285278389.1849.199.camel@haakon2.linux-iscsi.org>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
	 <4C93BB8E.2080501@cisco.com>  <4C9427B6.9050404@cs.wisc.edu>
	 <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:20350 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755167Ab0IWVur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 17:50:47 -0400
In-Reply-To: <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

On Sat, 2010-09-18 at 12:58 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2010-09-17 at 21:45 -0500, Mike Christie wrote:
> > On 09/17/2010 02:03 PM, Joe Eykholt wrote:
> > >
> > > How about instead of adding use_serial_number, let's just have the
> > > drivers that want a serial number call scsi_cmd_get_serial()
> > 
> > I think this sounds better.
> > 
> 
> In that case I will go ahead and add explict scsi_cmd_get_serial() calls
> to the LLDs that use struct scsi_cmnd->serial_number in anything beyond
> an obvious and simple informational purpose.
> 
> > You could also convert drivers to the host tagging if you needed a 
> > unique id for each command sent to a host.
> 
> Hmmm, what does this entail again..?
> 
> > 
> > > and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
> > > used in debug messages in some drivers.  I didn't find other usages
> > > but didn't do an exhaustive search.
> > 
> > The comments for serial_number say that it is only supposed to be used 
> > for debugging printks and most drivers use it for that.
> 
> So I would suppose it would be OK for those drivers to continue to
> printk serial_number to show the internal serial_number allocation is
> now disabled by default.
> 
> > However, it looks like mpt and dpt_i2o are using it for error handling
> > and/or lookup type of operations. I think the mpt* uses are not needed
> > in the abort checks.
> > 
> 
> In that case, then adding an explict scsi_cmd_get_serial() call in mpt*
> and dpt_i20 ->queuecommand() callers would be a good first step.
> 
> > And eata is using it for ordering and tracking or something. It could 
> > probably be converted to the host tagging if or what you suggested if it 
> > needs the uniqueue id.
> 
> Adding an explict scsi_cmd_get_serial() for eata for now, and we can
> consider LLD canidates for host tag conversion as a future step.
> 
> > 
> > zfcp looks like it copies it. It does not look like the driver needs it.
> > 
> 
> Ok, I will look at removing it's usage in zfcp or if necessary add an
> the explict scsi_cmd_get_serial() call.
> 
> > scsi_error.c uses it in scsi_try_to_abort_cmd to check if a command has 
> > completed, but I think that can be done by checking if REQ_ATOM_COMPLETE 
> > is set.
> 
> Hmmm, good catch here.  Jejb and hch, does this item work for you..?
> 
> If so then I will take another peek for any ML uses of a struct
> scsi_cmnd->serial_number that need to be addressed, and include Joe's
> and Mike's recommendations into a v3 series.
> 

Greetings Mike and Co,

I was doing some followup on these items for a v3 series and started
with a patch following mnc's recommendations for dropping the
scsi_error.c codes depending upon struct scsi_cmnd->serial_number:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..f35c127 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -644,11 +644,7 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
  */
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-       /*
-        * scsi_done was called just after the command timed out and before
-        * we had a chance to process it. (db)
-        */
-       if (scmd->serial_number == 0)
+       if (test_bit(REQ_ATOM_COMPLETE, &scmd->request->atomic_flags))
                return SUCCESS;
        return __scsi_try_to_abort_cmd(scmd);
 }

and while building I noticed that the simple single enum REQ_ATOM_COMPLETE=0 is
currently located in block/blk.h and along with blk_mark_rq_complete() and
blk_clear_rq_complete() for setting this bit within struct request->atomic_flags.

jens, hch, tejun, and co, do you guys have a preference how this should be handled
so that scsi_try_to_abort_cmd() can use proper atomic struct request bits here and
we can get rid of this (racy..?) method of using struct scsi_cmnd->serial_number
for anything wrt to per struct scsi_cmnd context timeout handling.

Thanks!

--nab

