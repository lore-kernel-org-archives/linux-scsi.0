From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Wed, 17 Mar 2010 23:24:52 -0500
Message-ID: <4BA1AB14.6020600@cs.wisc.edu>
References: <20100309091848.4C7412BD8B@ochil.suse.de> <4B9657CD.6000805@emulex.com> <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080804040208010705020702"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45519 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0CREV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 00:21:27 -0400
In-Reply-To: <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080804040208010705020702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/16/2010 08:04 AM, Christof Schmitt wrote:
> On Tue, Mar 09, 2010 at 09:14:37AM -0500, James Smart wrote:
>> I don't ever expect to see large dev_loss_tmo values, but the patch is fine.
>>
>> Acked-by: James Smart<james.smart@emulex.com>
>>
>> -- james s
>>
>>
>> Hannes Reinecke wrote:
>>> The rport structure defines dev_loss_tmo as u32, which is
>>> later multiplied with HZ to get the actual timeout value.
>>> This might overflow for large dev_loss_tmo values. So we
>>> should be better using u64 as intermediate variables here
>>> to protect against overflow.
>>>
>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
> [...]
>
> I guess this is the intended use to prevent the dev_loss_tmo from
> removing the SCSI devices:
> http://git.kernel.org/?p=linux/kernel/git/hare/multipath-tools.git;a=commitdiff;h=b9903e2e8a6cdc5042897719fbae6c9346820bbf;hp=ed1dc6164fe530d146cfe65d4f99e44ec9b54b95
>
> But does this raise the question again how to run SCSI EH with remote
> port failures?
>
> The SCSI FC LLDs call fc_block_scsi_eh to wait until the fc_rport
> leaves the state FC_PORTSTATE_BLOCKED. This effectively prevents SCSI
> devices from being taken offline when there is a command timeout and
> the fc_rport is BLOCKED. With the large dev_loss_tmo, the dev_loss_tmo
> never expires and a problem with a single remote port can block the
> host error handler.
>

I did the attached patch for a problem where we were supposed to be 
getting a RSCN but we were not, so the scsi eh ended up running. Then we 
sat in the scsi eh for a long time. multipath was being used, so we 
wanted to fast fail, but the the fc block scsi eh helper only waits for 
the rport state to change.

It ended up the switch was busted and should have given a RSCN, but I 
think the patch is helpful for your problem where we fall into the long 
wait for legitimate reasons.

This patch works nicely when using multipath to get IO failed and hosts 
unblocked, but the problem is that it could offline the devices more 
quickly than what we are prepared for. We have something similar for 
iscsi, but the iscsi userspace daemon has a way to set the device back 
to running when it recovers. FC does not, and dm-multipath does not do 
this, so I am not pushing the patch.

I think if we can figure something out for that offline issue the patch 
could be helpful. I was thinking that if the the scsi eh failed because 
the fast io fail timer fired, then we could set the devices to a new 
state. The scsi_transport_fc and scsi_transport_iscsi code could use 
this new device state to indicate that the fast io fail timer has fired 
and we are failing IO, but the device is not in offline state and is not 
blocked.

--------------080804040208010705020702
Content-Type: text/plain;
 name="fc-fast-fail-block-scsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fc-fast-fail-block-scsi.patch"

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..ba69b7b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -717,7 +717,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	struct req_que *req = vha->req;
 	srb_t *spt;
 
-	fc_block_scsi_eh(cmd);
+	if (fc_block_scsi_eh(cmd) == DID_TRANSPORT_FAILFAST << 16)
+		return ret;
 
 	if (!CMD_SP(cmd))
 		return SUCCESS;
@@ -848,7 +849,8 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
-	fc_block_scsi_eh(cmd);
+	if (fc_block_scsi_eh(cmd) == DID_TRANSPORT_FAILFAST << 16)
+		return FAILED;
 
 	if (!fcport)
 		return FAILED;
@@ -928,7 +930,8 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	unsigned long serial;
 	srb_t *sp = (srb_t *) CMD_SP(cmd);
 
-	fc_block_scsi_eh(cmd);
+	if (fc_block_scsi_eh(cmd) == DID_TRANSPORT_FAILFAST << 16)
+		return ret;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -991,7 +994,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	srb_t *sp = (srb_t *) CMD_SP(cmd);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	fc_block_scsi_eh(cmd);
+	if (fc_block_scsi_eh(cmd) == DID_TRANSPORT_FAILFAST << 16)
+		return ret;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1d5b721..6239efe 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3194,19 +3194,24 @@ fc_scsi_scan_rport(struct work_struct *work)
  * failing recovery actions for blocked rports which would lead to
  * offlined SCSI devices.
  */
-void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
+int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
+		!(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+		return DID_TRANSPORT_FAILFAST << 16;
+	return 0;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 

--------------080804040208010705020702--
