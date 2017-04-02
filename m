From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] iscsi-target: Fix TMR reference leak during session
 shutdown
Date: Sun, 02 Apr 2017 15:38:23 -0700
Message-ID: <1491172703.8846.43.camel@haakon3.risingtidesystems.com>
References: <1490862594-2712-1-git-send-email-nab@linux-iscsi.org>
         <1490862594-2712-2-git-send-email-nab@linux-iscsi.org>
         <1490893673.2753.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490893673.2753.8.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cyl@datera.io" <cyl@datera.io>, "jcs@datera.io" <jcs@datera.io>, "rlm@daterainc.com" <rlm@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-03-30 at 17:08 +0000, Bart Van Assche wrote:
> On Thu, 2017-03-30 at 08:29 +0000, Nicholas A. Bellinger wrote:
> > diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> > index 5041a9c..b464033 100644
> > --- a/drivers/target/iscsi/iscsi_target_util.c
> > +++ b/drivers/target/iscsi/iscsi_target_util.c
> > @@ -737,21 +737,23 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
> >  {
> >  	struct se_cmd *se_cmd = NULL;
> >  	int rc;
> > +	bool op_scsi = false;
> >  	/*
> >  	 * Determine if a struct se_cmd is associated with
> >  	 * this struct iscsi_cmd.
> >  	 */
> >  	switch (cmd->iscsi_opcode) {
> >  	case ISCSI_OP_SCSI_CMD:
> > -		se_cmd = &cmd->se_cmd;
> > -		__iscsit_free_cmd(cmd, true, shutdown);
> > +		op_scsi = true;
> >  		/*
> >  		 * Fallthrough
> >  		 */
> >  	case ISCSI_OP_SCSI_TMFUNC:
> > -		rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
> > -		if (!rc && shutdown && se_cmd && se_cmd->se_sess) {
> > -			__iscsit_free_cmd(cmd, true, shutdown);
> > +		se_cmd = &cmd->se_cmd;
> > +		__iscsit_free_cmd(cmd, op_scsi, shutdown);
> > +		rc = transport_generic_free_cmd(se_cmd, shutdown);
> > +		if (!rc && shutdown && se_cmd->se_sess) {
> > +			__iscsit_free_cmd(cmd, op_scsi, shutdown);
> >  			target_put_sess_cmd(se_cmd);
> >  		}
> >  		break;
> 
> Hello Nic,
> 
> I agree that this patch fixes a leak. However, an existing bug in
> iscsit_free_cmd() is not addressed by this patch. Before the TMF code started
> using kref_get() / kref_put() it was possible for transport_generic_free_cmd()
> to determine whether or not iscsit_free_cmd() should call __iscsit_free_cmd()
> by checking the command reference count. I think that since the TMF code
> manipulates the command reference count it is no longer possible for
> transport_generic_free_cmd() to determine this. If iscsit_free_cmd() is called
> while a LUN RESET is in progress then the return value of
> transport_generic_free_cmd() will be wrong. 

No.  Your assumption is incorrect wrt transport_generic_free_cmd()
having a wrong return value during LUN_RESET.

It's incorrect because when iscsit_free_cmd() is called with
shutdown=true resulting in transport_generic_free_cmd() with
wait_for_tasks=true, target_wait_free_cmd() checks for CMD_T_ABORTED to
determine if se_cmd has been aborted by target_core_tmr.c logic, and
returns aborted=true back up to transport_generic_free_cmd().

When transport_generic_free_cmd() gets aborted=true, it waits for
se_cmd->cmd_wait_comp to finish and calls cmd->se_tfo->release_cmd()
to release se_cmd back to the pre-allocated session pool.

At this point, transport_generic_free_cmd() with aborted=true must
return '1' it's caller, signaling iscsit_free_cmd() to not attempt to
perform the extra __iscsi_free_cmd() or target_put_sess_cmd(), because
se_cmd has already been released back to the session pool.
