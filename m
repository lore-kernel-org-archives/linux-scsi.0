From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 7/9] target: Enable WRITE_INSERT emulation in
 target_execute_cmd
Date: Mon, 07 Apr 2014 01:11:11 -0700
Message-ID: <1396858271.19888.9.camel@haakon3.risingtidesystems.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
	 <1396517753-23546-8-git-send-email-nab@daterainc.com>
	 <5342562F.1070706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45459 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaDGILJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 04:11:09 -0400
In-Reply-To: <5342562F.1070706@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 2014-04-07 at 10:39 +0300, Sagi Grimberg wrote:
> On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch enables WRITE_INSERT emulation in target_execute_cmd()
> > in order to locally generate DIF PI before submitting the WRITE
> > to the underlying backend device.
> >
> > This is required for fabric drivers that currently don't support
> > DIF over-the-wire, in order to inact with backend devices that
> > have hardware (IBLOCK) or software (FILEIO + RAMDISK) support
> > for handling T10 PI.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Cc: Quinn Tran <quinn.tran@qlogic.com>
> > Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_transport.c |    9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 9c820ba..530a9e8 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1767,6 +1767,15 @@ void target_execute_cmd(struct se_cmd *cmd)
> >   	cmd->t_state = TRANSPORT_PROCESSING;
> >   	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
> >   	spin_unlock_irq(&cmd->t_state_lock);
> > +	/*
> > +	 * Perform WRITE_INSERT of PI using software emulation when backend
> > +	 * device has PI enabled, if the transport has not already generated
> > +	 * PI using hardware WRITE_INSERT offload.
> > +	 */
> > +	if (cmd->prot_op == TARGET_PROT_DOUT_INSERT) {
> > +		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
> > +			sbc_dif_write_insert(cmd);
> > +	}
> >   
> >   	if (target_handle_task_attr(cmd)) {
> >   		spin_lock_irq(&cmd->t_state_lock);
> Looks good to me.
> 
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
> 
> This is useless though without the code setting this prot_op in 
> sbc_set_prot_op_checks()...

Not sure I follow..  sbc_set_prot_op_checks() is already setting
TARGET_PROT_DOUT_INSERT when no protect field in the WRITE CDB has been
set, eg:

static int
sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
                       bool is_write, struct se_cmd *cmd)
{
        if (is_write) {
                cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
                                         TARGET_PROT_DOUT_INSERT;

                <SNIP>
        }
}

Which in-turn is what causes this code to invoke sbc_dif_write_insert
(now sbc_dif_generate) when the backend supports PI, and the fabric
itself does not support WRITE_INSERT hw offload.

--nab 

