From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] target: Re-org of core_tmr_lun_reset +
 FREE_CMD_INTR bugfix
Date: Sat, 08 Oct 2011 19:00:56 -0700
Message-ID: <1318125656.4978.103.camel@haakon2.linux-iscsi.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
	 <1317358511-10664-3-git-send-email-nab@linux-iscsi.org>
	 <20111009013006.GB32104@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111009013006.GB32104@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-10-08 at 21:30 -0400, Christoph Hellwig wrote:
> On Fri, Sep 30, 2011 at 04:55:09AM +0000, Nicholas A. Bellinger wrote:
> > This patch also includes a bugfix related to TRANSPORT_FREE_CMD_INTR
> > operation, where core_tmr_drain_cmd_list will skip this cause in order
> > to prevent an ABORT_TASK status from being returned for descriptors that
> > are already queued up to be related by processing thread context.
> 
> Please try to avoid mixing random bux fixes into code reorganization.
> 
> 

Fair enough, i'm happy to break out this single bug-fix into a separate
patch for mainline.

> I also really hate adding more special cases for
> TRANSPORT_FREE_CMD_INTR.  Freeing a command from interrupt should really
> done by using a qla2xxx specific workqueue, and the core should not know
> about the pending free before we call into transport_generic_free_cmd.
> 

Yes, the usage of TRANSPORT_FREE_CMD_INTR with qla2xx is also
problematic with transport_generic_wait_for_tasks(), because readding
se_cmd via transport_add_cmd_to_queue() will reset the
cmd->t_transport_active bit..

Putting this into a qla2xxx specific workqueue is fine by me.

> 
> This is pretty important for the conversion of the target execution
> model to concurrent workqueues in addition to simply not making the
> code a mess.  I guess I'll have move making qla2xxx not abusing the
> processing thread for everything the highest priority in that area
> so that we don't get more special cases for it added.
> 
> Except for that is looks fine to me.
> 

Currently there are no additional TRANSPORT_FREE_CMD_INTR cases that we
have run into thus far.

--nab
