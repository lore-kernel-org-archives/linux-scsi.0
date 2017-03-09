From: Bill Kuzeja <William.Kuzeja@stratus.com>
Subject: [PATCH] qla2xxx: Fix crash in qla2xxx_eh_abort on bad ptr
Date: Thu, 9 Mar 2017 11:47:23 -0500
Message-ID: <1489078043-388-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us-smtp-delivery-131.mimecast.com ([63.128.21.131]:39447 "EHLO
        us-smtp-delivery-131.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754526AbdCIRyC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 12:54:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, Bill Kuzeja <William.Kuzeja@stratus.com>

I've seen this issue only after a Qlogic card breaks upon initialization 
(one of my test cases). After the break, qla2x00_abort_all_cmds gets 
invoked. This routine has a relatively new section introduced by these 
commits:

commit 1535aa75a3d8 ("scsi: qla2xxx: fix invalid DMA access after command aborts in PCI device remove")
commit c733ab351243 ("scsi: qla2xxx: do not abort all commands in the adapter during EEH recovery")
commit 2780f3c8f0233 ("scsi: qla2xxx: Avoid that issuing a LIP triggers a kernel crash") 

The section is problematic in certain cases. Here's the if statement in 
question:

    if (GET_CMD_SP(sp) && !ha->flags.eeh_busy) {
       /* Get a reference to the sp and drop the lock.
        * The reference ensures this sp->done() call
        * - and not the call in qla2xxx_eh_abort() -
        * ends the SCSI command (with result 'res').
        */
        sp_get(sp);
        spin_unlock_irqrestore(&ha->hardware_lock,flags);
        qla2xxx_eh_abort(GET_CMD_SP(sp));
        spin_lock_irqsave(&ha->hardware_lock, flags);
    }

Now here's the panic my test provokes:

[  927.823858] Call Trace:
[  927.581661]  qla2xxx_eh_abort+0x19/0x2b0 [qla2xxx]
[  927.829269]  [<ffffffffa046c146>] qla2x00_abort_all_cmds+0xf6/0x14 [qla2xxx]
[  927.845014]  [<ffffffffa046c4bf>] qla2x00_disable_board_on_pci_error+0x8f/0x160 [qla2xxx]
[  927.863054]  [<ffffffff810a805b>] process_one_work+0x17b/0x470
[  927.875916]  [<ffffffff810a8e96>] worker_thread+0x126/0x410
[  927.888203]  [<ffffffff810a8d70>] ? rescuer_thread+0x460/0x460
[  927.901067]  [<ffffffff810b064f>] kthread+0xcf/0xe0
[  927.911823]  [<ffffffff810b0580>] ?kthread_create_on_node+0x140/0x140
[  927.926224]  [<ffffffff81696718>] ret_from_fork+0x58/0x90
[  927.938132]  [<ffffffff810b0580>] ?kthread_create_on_node+0x140/0x140

We crash in qla2xxx_eh_abort trying to get the vha:

	scsi_qla_host_t *vha = shost_priv(cmd->device->host);

Closer examination of the crash shows that the value of "cmd" is 2,
certainly not a valid pointer.

What's happening here?

The check at the top of the if-block GET_CMD_SP(sp) implicitly != NULL 
would have prevented this sort of thing. However, since sp->u.scmd.cmd 
is not *quite* null (in my crashes it's usually 2), we fall into the 
if-block and call qla2xxx_eh_abort - and crash trying to get cmd.

Note that the GET_CMD_SP(sp) is doing this:

#define GET_CMD_SP(sp) (sp->u.scmd.cmd)

and is acting upon a union:

        union {
                struct srb_iocb iocb_cmd;
                struct fc_bsg_job *bsg_job;
                struct srb_cmd scmd;
	}

The address it's getting is the first element in this structure:

struct srb_cmd {
	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
....
}

However, since this is a union, the same memory can be used this way 
instead:

struct srb_iocb {
	union {
		struct {
			uint16_t flags;
			uint16_t data[2];
			u32 iop[2];
		} logio;
	....

Turns out, in the kernel panics I have gotten, the iocb type is logio
(verified by srb->type = SRB_LOGIN_CMD). 

To further check, I looked at the logio iocb in the crash:

        logio = {
          flags = 0x2,
          data = {0x0, 0x0}
        ....

which follows since:

       lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;

and

#define SRB_LOGIN_COND_PLOGI	BIT_1

In order to eliminate this crash, this patch adds an extra check to the
top of the if statement to check whether or not sp->type == SRB_SCSI_CMD. 
If not, then don't bother doing the rest of the if-block. It doesn't look
like we should be invoking qla2xxx_eh_abort for anything other than
srb_cmds anyways.

I thought about changing the definition of GET_CMD_SP to include this
type check and return NULL if sp is not type SRB_SCSI_CMD - like this:

#define GET_CMD_SP(sp) ((sp->type == SRB_SCSI_CMD) ? sp->u.scmd.cmd : NULL)

I decided against it as there are multiple places in the code that do not
check for NULL. If you're calling GET_CMD_SP you should be dealing with 
an SRB_SCSI_CMD....but we aren't in this case. So, for this patch I went 
with the more contained and safer change.

This problem is hard to hit, but I have run into it doing negative
testing many times now (with a test specifically designed to bring it
out), so I can verify that this fix works. My testing has been against
a RHEL7 driver variant, but the bug and patch are equally relevant to
to the upstream driver.

Fixes: 1535aa75a3d8 ("scsi: qla2xxx: fix invalid DMA access after command aborts in PCI device remove")
Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d01c90c..4eec095 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1617,7 +1617,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
-				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy) {
+				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy &&
+				    (sp->type == SRB_SCSI_CMD)) {
 					/* Get a reference to the sp and drop the lock.
 					 * The reference ensures this sp->done() call
 					 * - and not the call in qla2xxx_eh_abort() -
-- 
1.8.3.1
