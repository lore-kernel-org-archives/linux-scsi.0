From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/9] target: Enable READ_STRIP emulation in
 target_complete_ok_work
Date: Mon, 07 Apr 2014 01:15:27 -0700
Message-ID: <1396858527.19888.12.camel@haakon3.risingtidesystems.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
	 <1396517753-23546-10-git-send-email-nab@daterainc.com>
	 <5342589F.6030904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45484 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaDGIPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 04:15:30 -0400
In-Reply-To: <5342589F.6030904@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 2014-04-07 at 10:49 +0300, Sagi Grimberg wrote:
> On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch enables the use of READ_STRIP software emulation in
> > target_complete_ok_work() code for I/O READs.
> >
> > This is useful when the fabric does not support READ_STRIP hardware
> > offload, but would still like to interact with backend device
> > that have T10 PI enabled.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Cc: Quinn Tran <quinn.tran@qlogic.com>
> > Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_transport.c |   33 ++++++++++++++++++++++++++++++++
> >   1 file changed, 33 insertions(+)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 530a9e8..a184103 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1905,6 +1905,24 @@ static void transport_handle_queue_full(
> >   	schedule_work(&cmd->se_dev->qf_work_queue);
> >   }
> >   
> > +static bool target_check_read_strip(struct se_cmd *cmd)
> > +{
> > +	sense_reason_t rc;
> > +
> > +	if (cmd->prot_op != TARGET_PROT_DIN_STRIP)
> > +		return false;
> > +
> > +	if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
> > +		rc = sbc_dif_read_strip(cmd);
> > +		if (rc) {
> > +			cmd->pi_err = rc;
> > +			return true;
> > +		}
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >   static void target_complete_ok_work(struct work_struct *work)
> >   {
> >   	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
> > @@ -1969,6 +1987,21 @@ static void target_complete_ok_work(struct work_struct *work)
> >   					cmd->data_length;
> >   		}
> >   		spin_unlock(&cmd->se_lun->lun_sep_lock);
> > +		/*
> > +		 * Perform READ_STRIP of PI using software emulation when
> > +		 * backend had PI enabled, if the transport will not be
> > +		 * performing hardware READ_STRIP offload.
> > +		 */
> 
> You always call read_strip() even if the operation is not READ_STRIP 
> (the routine won't do anything in this case).
> Personally, I usually prefer to avoid calling a routine rather then 
> calling it and perform the checks there.
> 
> I suggest:
> 
> if (cmd->prot_op == TARGET_PROT_DIN_STRIP &&
>      target_check_read_strip(cmd)) {
> 	ret = transport_send_check_condition_and_sense(cmd, cmd->pi_err, 0);
> 	...
> }
> 
> 

Yep, this was done to save the indention in transport_complete_work_ok()
from being too obnoxious..

Squashing the following incremental patch into the original.

Thanks Sagi!

--nab

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 673a72d..d4b9869 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1909,9 +1909,6 @@ static bool target_check_read_strip(struct se_cmd *cmd)
 {
        sense_reason_t rc;
 
-       if (cmd->prot_op != TARGET_PROT_DIN_STRIP)
-               return false;
-
        if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
                rc = sbc_dif_read_strip(cmd);
                if (rc) {
@@ -1992,7 +1989,8 @@ static void target_complete_ok_work(struct work_struct *work)
                 * backend had PI enabled, if the transport will not be
                 * performing hardware READ_STRIP offload.
                 */
-               if (target_check_read_strip(cmd)) {
+               if (cmd->prot_op == TARGET_PROT_DIN_STRIP &&
+                   target_check_read_strip(cmd)) {
                        ret = transport_send_check_condition_and_sense(cmd,
                                                cmd->pi_err, 0);
                        if (ret == -EAGAIN || ret == -ENOMEM)



