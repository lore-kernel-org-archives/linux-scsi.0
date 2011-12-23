From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 3/3] qla2xxx: Add tcm_qla2xxx fabric module for
 mainline target
Date: Fri, 23 Dec 2011 13:51:08 -0800
Message-ID: <1324677068.16979.103.camel@haakon2.linux-iscsi.org>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
	 <1324173746-14361-4-git-send-email-nab@linux-iscsi.org>
	 <CAL1RGDX-MR6pEwDN-vSjx92wUD3x5zk26UAG9QKpw1jp5-85mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54785 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1LWVvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2011 16:51:19 -0500
In-Reply-To: <CAL1RGDX-MR6pEwDN-vSjx92wUD3x5zk26UAG9QKpw1jp5-85mg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>

On Thu, 2011-12-22 at 00:10 -0800, Roland Dreier wrote:
> Hi Nic,
> 
> On Sat, Dec 17, 2011 at 6:02 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > +/*
> > + * Called from qla_target_template->free_cmd(), and will call
> > + * tcm_qla2xxx_release_cmd via normal struct target_core_fabric_ops
> > + * release callback.  qla_hw_data->hardware_lock is expected to be held
> > + */
> > +void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
> > +{
> > +       barrier();
> > +       /*
> > +        * Handle tcm_qla2xxx_init_cmd() -> transport_get_lun_for_cmd()
> > +        * failure case where cmd->se_cmd.se_dev was not assigned, and
> > +        * a call to transport_generic_free_cmd_intr() is not possible..
> > +        */
> > +       if (!cmd->se_cmd.se_dev) {
> > +               target_put_sess_cmd(cmd->se_cmd.se_sess, &cmd->se_cmd);
> > +               transport_generic_free_cmd(&cmd->se_cmd, 0);
> > +               return;
> > +       }
> > +
> > +       if (!atomic_read(&cmd->se_cmd.t_transport_complete))
> > +               target_put_sess_cmd(cmd->se_cmd.se_sess, &cmd->se_cmd);
> > +
> > +       INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
> > +       queue_work(tcm_qla2xxx_free_wq, &cmd->work);
> > +}
> 
> can you explain why you do the second target_put_sess_cmd()
> without a "return" here?  (the one when t_transport_complete == 0)
> 
> It seems this leads to use-after-free ... suppose cmd->execute_task in
> __transport_execute_tasks() returns an error (eg due to malformed
> emulated command from the initiator -- the easiest way to trigger this
> is to do something like "sg_raw /dev/sda 12 00 00 00 00 00" on a
> tcm_qla2xxx exported LUN).
> 
> Then we'll call transport_generic_request_failure()  which will end up
> calling transport_cmd_check_stop_to_fabric(), which will call into
> tcm_qla2xxx_check_stop_free(), which will do target_put_sess_cmd()
> so we'll be down to 1 reference on the cmd.
> 
> Then when the HW finishes sending the SCSI status back, we'll
> go into qla_tgt_do_ctio_completion(), which will call into ->free_cmd()
> and end up in the function quoted above.
> 
> Since we failed the command we never call transport_complete_task()
> so t_transport_complete will be 0 and we'll call target_put_sess_cmd()
> a second time and therefore free the command immediately, and then
> go ahead and queue up the work to free it a second time.
> 
> You can make this 100% reproducible and fatal by booting with
> "slub_debug=FZUP" (or whatever the corresponding SLAB config
> option is, I forget), and then doing some malformed emulated
> command that ends up returning bad SCSI status (like the sg_raw
> example above).
> 
> I still don't understand the command reference counting and freeing
> scheme well enough to know what the right fix is here.  Are we
> supposed to return after that put in the transport_complete==0 case?
> But I thought we weren't supposed to free commands from interrupt
> context, although I don't know what's wrong with doing what ends
> up being just a kmem_cache_free() in the end.  So is doing the put in
> the free_cmd function (which is called from the CTIO completion
> handling interrupt context) OK?
> 
> Why do we have that put if t_transport_complete isn't set, anyway?
> Doesn't the request failure path drop the reference?  Or is the problem
> that we return SCSI status without setting t_transport_complete?
> 
> Thoughts?
> 

I believe this is actually left over cruft from when
qla_tgt_cmd->cmd_stop_free had to be set explicitly set in the failure
release path in tcm_qla2xxx_free_cmd().  Eg:

        if (!atomic_read(&cmd->se_cmd.t_task->t_transport_complete)) {
                atomic_set(&cmd->cmd_stop_free, 1);
                smp_mb__after_atomic_dec();
        }


So the (t_transport_complete == 0) check causing the issue above should
be safe to remove now..  The same is true for the !cmd->se_cmd.se_dev
check in tcm_qla2xxx_free_cmd() as well.

I'll get this addressed in lio-core/qla_tgt-3.3 shortly.

Thanks,

--nab




