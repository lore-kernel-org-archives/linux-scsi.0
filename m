From: Roland Dreier <roland@purestorage.com>
Subject: Re: [RFC-v4 3/3] qla2xxx: Add tcm_qla2xxx fabric module for mainline target
Date: Thu, 22 Dec 2011 00:10:44 -0800
Message-ID: <CAL1RGDX-MR6pEwDN-vSjx92wUD3x5zk26UAG9QKpw1jp5-85mg@mail.gmail.com>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org> <1324173746-14361-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1324173746-14361-4-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

On Sat, Dec 17, 2011 at 6:02 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> +/*
> + * Called from qla_target_template->free_cmd(), and will call
> + * tcm_qla2xxx_release_cmd via normal struct target_core_fabric_ops
> + * release callback. =A0qla_hw_data->hardware_lock is expected to be=
 held
> + */
> +void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
> +{
> + =A0 =A0 =A0 barrier();
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Handle tcm_qla2xxx_init_cmd() -> transport_get_lun=
_for_cmd()
> + =A0 =A0 =A0 =A0* failure case where cmd->se_cmd.se_dev was not assi=
gned, and
> + =A0 =A0 =A0 =A0* a call to transport_generic_free_cmd_intr() is not=
 possible..
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!cmd->se_cmd.se_dev) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 target_put_sess_cmd(cmd->se_cmd.se_sess=
, &cmd->se_cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 transport_generic_free_cmd(&cmd->se_cmd=
, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (!atomic_read(&cmd->se_cmd.t_transport_complete))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 target_put_sess_cmd(cmd->se_cmd.se_sess=
, &cmd->se_cmd);
> +
> + =A0 =A0 =A0 INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
> + =A0 =A0 =A0 queue_work(tcm_qla2xxx_free_wq, &cmd->work);
> +}

can you explain why you do the second target_put_sess_cmd()
without a "return" here?  (the one when t_transport_complete =3D=3D 0)

It seems this leads to use-after-free ... suppose cmd->execute_task in
__transport_execute_tasks() returns an error (eg due to malformed
emulated command from the initiator -- the easiest way to trigger this
is to do something like "sg_raw /dev/sda 12 00 00 00 00 00" on a
tcm_qla2xxx exported LUN).

Then we'll call transport_generic_request_failure()  which will end up
calling transport_cmd_check_stop_to_fabric(), which will call into
tcm_qla2xxx_check_stop_free(), which will do target_put_sess_cmd()
so we'll be down to 1 reference on the cmd.

Then when the HW finishes sending the SCSI status back, we'll
go into qla_tgt_do_ctio_completion(), which will call into ->free_cmd()
and end up in the function quoted above.

Since we failed the command we never call transport_complete_task()
so t_transport_complete will be 0 and we'll call target_put_sess_cmd()
a second time and therefore free the command immediately, and then
go ahead and queue up the work to free it a second time.

You can make this 100% reproducible and fatal by booting with
"slub_debug=3DFZUP" (or whatever the corresponding SLAB config
option is, I forget), and then doing some malformed emulated
command that ends up returning bad SCSI status (like the sg_raw
example above).

I still don't understand the command reference counting and freeing
scheme well enough to know what the right fix is here.  Are we
supposed to return after that put in the transport_complete=3D=3D0 case=
?
But I thought we weren't supposed to free commands from interrupt
context, although I don't know what's wrong with doing what ends
up being just a kmem_cache_free() in the end.  So is doing the put in
the free_cmd function (which is called from the CTIO completion
handling interrupt context) OK?

Why do we have that put if t_transport_complete isn't set, anyway?
Doesn't the request failure path drop the reference?  Or is the problem
that we return SCSI status without setting t_transport_complete?

Thoughts?

 - R.
