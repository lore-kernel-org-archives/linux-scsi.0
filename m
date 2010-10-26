From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Tue, 26 Oct 2010 15:08:34 -0700
Message-ID: <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
	 <20101021150840.GA24309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13.bullet.mail.ne1.yahoo.com ([98.138.90.76]:24275 "HELO
	nm13.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760468Ab0JZWNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 18:13:33 -0400
In-Reply-To: <20101021150840.GA24309@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On Thu, 2010-10-21 at 08:08 -0700, Mike Anderson wrote:
> Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > *) core drivers/scsi remaining issue(s):
> > 
> > The issue raised by andmike during RFCv4 described as:
> > 
> > "If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it
> > would be correct for the scsi_decide_disposition cases but it would
> > appear this would stop __scsi_try_to_abort_cmd from being called in the
> > time out case as REQ_ATOM_COMPLETE is set prior to calling
> > blk_rq_timed_out."
> > 
> > The complete discussion is here:
> > 
> > http://marc.info/?l=linux-scsi&m=128535319915212&w=2
> > 
> > We still need folks with experience to dig into this code, so you know
> > the scsi_error.c code please jump in!
> > 
> 
> I provided two logging traces below for the two cases mentioned in the
> above email thread. The second trace used a modified version of
> scsi_debug so that I could generate the needed unit attention codes.
> 1.) On the check for complete comment the logging below marked with
> "***" indicated that during a timeout that the complete bit is set. We
> would not want to have a check for complete skip the call to
> __scsi_try_to_abort_cmd. 
> 
> scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> sd 1:0:0:0: [sdb] Done: TIMEOUT
> sd 1:0:0:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
> Waking error handler thread
> Error handler scsi_eh_1 waking up
> sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> Total of 1 commands on 1 devices require eh work
> scsi_eh_1: aborting cmd:0xffff88019e171b80
> 
> ***
> sd 1:0:0:0: scsi_try_to_abort_cmd: Comp bit set
> ***
> 
> scsi_debug: abort
> scsi_debug: cmd 00 00 00 00 00 00 
> scsi_eh_done scmd: ffff88019e171b80 result: 0
> scsi_send_eh_cmnd: scmd: ffff88019e171b80, timeleft: 10000
> scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> scsi_eh_tur: scmd ffff88019e171b80 rtn 2002
> scsi_eh_1: flush retry cmd: ffff88019e171b80
> scsi_restart_operations: waking up host to restart
> scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> Error handler scsi_eh_1 sleeping
> 

Hi Mike and Co,

After considering a couple of different approches here, I ended up with
the following simple patch that has been tested on linus HEAD from this
afternoon w/ forcing scsi_debug cmd TIMEOUT during modprobe and via
sg_dd ops.  (See comments below)

[PATCH] scsi: Add SCSI_EH_SOFTIRQ_DONE usage

This patch introduces a SCSI_EH_SOFTIRQ_DONE flag that is set in scsi_softirq_done()
from block soft_irq context that is used to signal when scsi_try_to_abort_cmd() should
be calling __scsi_try_to_abort_cmd() for a timed out struct scsi_cmnd instead of
returning SUCCESS via checking only blk_test_rq_complete().  This is done because
blk_rq_timed_out_timer() calls blk_mark_rq_complete() before blk_rq_timed_out() ->
struct request_queue->rq_timed_out_fn().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_error.c |    3 ++-
 drivers/scsi/scsi_lib.c   |    6 ++++++
 drivers/scsi/scsi_priv.h  |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6e496c3..e75b388 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -651,7 +651,8 @@ static int scsi_try_to_abort_cmd(struct scsi_cmnd
*scmd)
         * block/blk.h:blk_mark_rq_complete() has already been called
         * from the block softirq
         */
-       if (blk_test_rq_complete(scmd->request))
+       if ((blk_test_rq_complete(scmd->request)) &&
+           (scmd->eh_eflags & SCSI_EH_SOFTIRQ_DONE))
                return SUCCESS;

        return __scsi_try_to_abort_cmd(scmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8041fe1..7e3c477 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1402,6 +1402,12 @@ static void scsi_softirq_done(struct request *rq)
        int disposition;

        INIT_LIST_HEAD(&cmd->eh_entry);
+       /*
+        * Set the SCSI_EH_SOFTIRQ_DONE flag to signal scsi_error.c:
+        * scsi_try_to_abort_cmd() that this cmd has reached
+        * scsi_softirq_done()
+        */
+       cmd->eh_eflags |= SCSI_EH_SOFTIRQ_DONE;

        /*
         * Set the serial numbers back to zero
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..2f64350 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -17,6 +17,7 @@ struct scsi_nl_hdr;
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD     0x0001  /* Cancel this cmd */
+#define SCSI_EH_SOFTIRQ_DONE   0x0002  /* cmd reached
scsi_softirq_done() */

 #define SCSI_SENSE_VALID(scmd) \
        (((scmd)->sense_buffer[0] & 0x70) == 0x70)


-----------------------------------------------------------------

So far with this patch I see the follow two concerns:

*) SCSI_EH_SOFTIRQ_DONE uses cmd->eh_eflags which gets explictly cleared
in scsi_eh_finish_cmd().  AFAICT, the checks for scsi_try_to_abort_cmd()
are always done before scsi_eh_finish_cmd() gets called.   Comments
here..?

*) A potential race between SCSI_EH_SOFTIRQ_DONE being set in
scsi_softirq_done(), and the check in scsi_try_to_abort_cmd().  As this
code originaly used a non atomic cmd->serial_number check here between
the same two pieces of code, this *should* be OK right..?

> 
> 2.) In the logging output below my previous comment on the START_UNIT
> path hitting the serial_number check in scsi_try_to_abort_cmd is shown
> to be incorrect as the START_UNIT is handled as a failed and not a
> cancel action.
> 
> scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> scsi_debug:    [sense_key,asc,ascq]: [0x6,0x4,0x2]
> scsi_debug:    <1 0 0 0> non-zero result=0x8000002
> sd 1:0:0:0: scsi_check_sense: return FAILED for restart
> sd 1:0:0:0: [sdb] Done: FAILED
> sd 1:0:0:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
> sd 1:0:0:0: [sdb]  Sense Key : Unit Attention [current] 
> sd 1:0:0:0: [sdb]  Add. Sense: Logical unit not ready, initializing command required
> Waking error handler thread
> Error handler scsi_eh_1 waking up
> 
> ***
> sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
> ***
> 
> Total of 1 commands on 1 devices require eh work
> sd 1:0:0:0: scsi_check_sense: return FAILED for restart
> scsi_eh_1: Sending START_UNIT to sdev: 0xffff8801a2134000
> scsi_debug: cmd 1b 00 00 00 01 00 
> scsi_eh_done scmd: ffff8801a1730180 result: 0
> scsi_send_eh_cmnd: scmd: ffff8801a1730180, timeleft: 29999
> scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> scsi_debug: cmd 00 00 00 00 00 00 
> scsi_eh_done scmd: ffff8801a1730180 result: 0
> scsi_send_eh_cmnd: scmd: ffff8801a1730180, timeleft: 10000
> scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> scsi_eh_tur: scmd ffff8801a1730180 rtn 2002
> scsi_eh_1: flush retry cmd: ffff8801a1730180
> scsi_restart_operations: waking up host to restart
> scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> Error handler scsi_eh_1 sleeping
> 
> 

AFAICT this second case should be addressed by above patch
as well..  I will go ahead and test with your scsi_debug patch to
trigger this case, and everything looks good for the above two cases I
will respin against the latest linus HEAD.  Mike still wants to do a
bunch of testing to this code over the next weeks, and we will continue
to shake out any remaining items here.

That said, the libfc rport state + host_lock less issue would be the
only known remaining item to get this series merged for .37.  We can
always leave unlocked_qcmd=0 for libfc for the initial merge of these
patches, and have mnc and james smart dig into the nitty gritty details
post merge window.  Comments please libfc folks..?

Many, many thanks again to Mike Anderson for his detailed explanations
of these two cases.

--nab


