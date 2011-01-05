From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: Fix excessive stack usage
Date: Wed, 05 Jan 2011 14:23:05 -0800
Message-ID: <1294266185.14650.140.camel@haakon2.linux-iscsi.org>
References: <1294187361.7879.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45277 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AEW3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 17:29:07 -0500
In-Reply-To: <1294187361.7879.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-01-04 at 18:29 -0600, James Bottomley wrote:
> This is showing up in compiles:
> 
>   CC [M]  drivers/target/target_core_alua.o
> drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
> drivers/target/target_core_pr.c:1952: warning: the frame size of 1124 bytes is larger than 1024 bytes
> 
> And is caused by a tmp[1024] buffer in the routine.  This looks to be
> fixable with a GFP_KERNEL allocation ... although it's hard to say; the
> routine is called under the dev_reservation_lock which, best as I can
> tell, is only ever called with user context ... so why isn't it a mutex?

Hi James,

The struct se_device->dev_reservation_lock is expected to be obtained
from within both normal backend transport_processing_thread() kthread
context for PR CDB processing logic, as well as from the configfs
shutdown context for MappedLUNs for individual NodeACLs during:

unlink /sys/kernel/config/target/$FABRIC/$WWN/tpgt_$TPGT/acls/$INITIATOR_WWN/lun_0/lun_0

in order to clear the NodeACL specific PR metadata (and update the APTPL
struct file when enabled) for the associated LUN once the explict
MappedLUN has been unlinked.

The main reason that struct se_device->dev_reservation_lock and struct
t10_reservation_template->registration_lock where originally coded as a
spinning locks and not sleeping mutexes was for the latter active I/O
shutdown case in the configfs unlink path for MappedLUNs starting from:

target_core_fabric_configfs.c:target_fabric_mappedlun_unlink() ->

	target_core_device.c:core_dev_del_initiator_node_lun_acl() ->

		target_core_device.c:core_update_device_list_for_node() -> 

			target_core_pr.c:core_scsi3_free_pr_reg_from_nacl() ->

				target_core_pr.c:__core_scsi3_free_registration()

For this particular case MappedLUN unlink / shutdown case we never
expect to sleep (at least for MappedLUN shutdown and PR metadata
shutdown) as long as the explict NodeACL still exists.

There is also the case for core_scsi3_emulate_pro_register_and_move()
where struct se_device->dev_reservation_lock is held and
__core_scsi3_locate_pr_reg() -> spin_lock(&pr_tmpl->registration_lock)
gets called in order to ensure consistency of REGISTER_AND_MOVE across
multiple fabric modules to same struct se_device backend.

So all of that said I think converting dev_reservation_lock and/or
registration_lock to mutexes and allowing a context switch to happen
would make the configfs MappedLUN shutdown case with active PR fabric
ops more complex.

I think the proper fix for this is simply to shrink the local scope tmp
buffer to 512 bytes in __core_scsi3_update_aptpl_buf() considering that
typical use even with the largest initiator_node and target_node WWN
values defined by SCSI (224 bytes by iSCSI IQNs) along with the handful
of other PR APTPL keys being copied from tmp -> passed buf is still
going to be well below 300 bytes.

> There's also no need to zero initialise an entire string buffer; as long
> as the kernel prints the string (which it does in this case), it's fine
> just to start it with a null.
> 

Thanks, below is what I have pushed into lio-core-2.6.git.

--nab

>From 7171f272af8d49f3a9d554302c0717f899be3bcb Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 5 Jan 2011 22:21:48 +0000
Subject: [PATCH] target: Fix excessive stack usage

This patch fixes the following compile warning wrt to excess local scope variable usage
in __core_scsi3_update_aptpl_buf():

  CC [M]  drivers/target/target_core_alua.o
drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
drivers/target/target_core_pr.c:1952: warning: the frame size of 1124 bytes is larger than 1024 bytes

This patch shrinks the tmp buffer to 512 bytes as the largest SCSI defined WWN for the
initiator_node and target_node keys are 224 bytes (for iSCSI IQNs) per sprintf call +
the handful of extra APTPL keys ranging from 4 to 16 bytes, which still puts us well
the 512 byte limit.

Reported-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 6b275bb..c36eaa6 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1857,7 +1857,7 @@ static int __core_scsi3_update_aptpl_buf(
 	struct se_portal_group *tpg;
 	struct se_subsystem_dev *su_dev = SU_DEV(dev);
 	struct t10_pr_registration *pr_reg;
-	unsigned char tmp[1024], isid_buf[32];
+	unsigned char tmp[512], isid_buf[32];
 	ssize_t len = 0;
 	int reg_count = 0;
 
@@ -1877,8 +1877,8 @@ static int __core_scsi3_update_aptpl_buf(
 	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
 			pr_reg_list) {
 
-		memset(tmp, 0, 1024);
-		memset(isid_buf, 0, 32);
+		tmp[0] = '\0';
+		isid_buf[0] = '\0';
 		tpg = pr_reg->pr_reg_nacl->se_tpg;
 		lun = pr_reg->pr_reg_tg_pt_lun;
 		/*
@@ -1893,7 +1893,7 @@ static int __core_scsi3_update_aptpl_buf(
 		 * reservation holder.
 		 */
 		if (dev->dev_pr_res_holder == pr_reg) {
-			snprintf(tmp, 1024, "PR_REG_START: %d"
+			snprintf(tmp, 512, "PR_REG_START: %d"
 				"\ninitiator_fabric=%s\n"
 				"initiator_node=%s\n%s"
 				"sa_res_key=%llu\n"
@@ -1906,7 +1906,7 @@ static int __core_scsi3_update_aptpl_buf(
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		} else {
-			snprintf(tmp, 1024, "PR_REG_START: %d\n"
+			snprintf(tmp, 512, "PR_REG_START: %d\n"
 				"initiator_fabric=%s\ninitiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
 				"res_all_tg_pt=%d\nmapped_lun=%u\n",
@@ -1927,7 +1927,7 @@ static int __core_scsi3_update_aptpl_buf(
 		/*
 		 * Include information about the associated SCSI target port.
 		 */
-		snprintf(tmp, 1024, "target_fabric=%s\ntarget_node=%s\n"
+		snprintf(tmp, 512, "target_fabric=%s\ntarget_node=%s\n"
 			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%u\nPR_REG_END:"
 			" %d\n", TPG_TFO(tpg)->get_fabric_name(),
 			TPG_TFO(tpg)->tpg_get_wwn(tpg),
@@ -1945,7 +1945,7 @@ static int __core_scsi3_update_aptpl_buf(
 	}
 	spin_unlock(&T10_RES(su_dev)->registration_lock);
 
-	 if (!(reg_count))
+	if (!(reg_count))
 		len += sprintf(buf+len, "No Registrations or Reservations");
 
 	return 0;
-- 
1.7.3.4



