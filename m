From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
	Scsi_Host->cmd_serial_number to atomic_t
Date: Fri, 24 Sep 2010 13:41:20 -0700
Message-ID: <1285360880.1849.230.camel@haakon2.linux-iscsi.org>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
	 <4C93BB8E.2080501@cisco.com>  <4C9427B6.9050404@cs.wisc.edu>
	 <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
	 <1285278389.1849.199.camel@haakon2.linux-iscsi.org>
	 <4C9C4604.1020804@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:29112 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932314Ab0IXUpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 16:45:39 -0400
In-Reply-To: <4C9C4604.1020804@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>

On Fri, 2010-09-24 at 08:32 +0200, Jens Axboe wrote:
> On 2010-09-23 23:46, Nicholas A. Bellinger wrote:
> > On Sat, 2010-09-18 at 12:58 -0700, Nicholas A. Bellinger wrote:

<SNIP>

> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 1de30eb..f35c127 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -644,11 +644,7 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> >   */
> >  static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> >  {
> > -       /*
> > -        * scsi_done was called just after the command timed out and before
> > -        * we had a chance to process it. (db)
> > -        */
> > -       if (scmd->serial_number == 0)
> > +       if (test_bit(REQ_ATOM_COMPLETE, &scmd->request->atomic_flags))
> >                 return SUCCESS;
> >         return __scsi_try_to_abort_cmd(scmd);
> >  }
> > 
> > and while building I noticed that the simple single enum
> > REQ_ATOM_COMPLETE=0 is
> 
> > currently located in block/blk.h and along with blk_mark_rq_complete()
> > and blk_clear_rq_complete() for setting this bit within struct
> > request->atomic_flags.
> > 
> > jens, hch, tejun, and co, do you guys have a preference how this
> > should be handled so that scsi_try_to_abort_cmd() can use proper
> > atomic struct request bits here and we can get rid of this (racy..?)
> > method of using struct scsi_cmnd->serial_number for anything wrt to
> > per struct scsi_cmnd context timeout handling.
> 
> Just add a
> 
> static inline int blk_test_rq_complete(struct request *rq)
> {
>         return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
> }
> 
> in block/blk.h
> 
> I need this too for some lockless completion patches I am playing with.
> 

Hi Jens,

Perfect, thanks for the heads up on this wrapper.  I will go ahead and
include this into a RFCv4 series and update scsi_try_to_abort_cmd()
accordingly.

Best,

--nab


