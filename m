From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [BUG] iscsi-target: deadlock because of iscsit_get_tpg()
Date: Tue, 19 May 2015 15:10:33 -0700
Message-ID: <1432073433.19713.25.camel@haakon3.risingtidesystems.com>
References: <555B9C3A.40106@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59628 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbESWKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 18:10:35 -0400
In-Reply-To: <555B9C3A.40106@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org, Sagi Grimberg <sagig@mellanox.com>

Hi Alexey,

On Tue, 2015-05-19 at 23:25 +0300, Alexey Khoroshilov wrote:
> Hello,
> 
> Our tool reports a potential double lock because of quite strange code
> in iscsit_get_tpg().
> 
> drivers/target/iscsi/iscsi_target_tpg.c:
> int iscsit_get_tpg(
> 	struct iscsi_portal_group *tpg)
> {
> 	int ret;
> 
> 	ret = mutex_lock_interruptible(&tpg->tpg_access_lock);
> 	return ((ret != 0) || signal_pending(current)) ? -1 : 0;
> }
> 
> If mutex_lock_interruptible() successfully acquires the mutex, but there
> is a pending signal, the function returns error, but it leaves the mutex
> held. Callers do not expect such behaviour that can lead to a deadlock.
> 
> Why the check for pending signal is needed here?
> 

Once upon a time, this was an un-interruptible lock.  The signal pending
was a check to allow userspace to break out of the operation with
SIGINT.

AFAICT, there's no reason why this is necessary anymore.

> Found by Linux Driver Verification project (linuxtesting.org).
> 
> 
> Similar dangerous pattern presents in a couple of other places:
> 
> drivers/target/iscsi/iscsi_target.c:
> int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
> {
> ...
> 	ret = down_interruptible(&tpg->np_login_sem);
> 	if ((ret != 0) || signal_pending(current))
> 		return -1;
> 
> 
> drivers/target/target_core_sbc.c:
> static sense_reason_t
> sbc_compare_and_write(struct se_cmd *cmd)
> {
> ...
> 	rc = down_interruptible(&dev->caw_sem);
> 	if ((rc != 0) || signal_pending(current)) {
> 		cmd->transport_complete_callback = NULL;
> 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> 	}
> 
> 

Ditto on these.

Applying the following patch to target-pending/master.

Thank you,

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 34871a6..74e6114 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -230,7 +230,7 @@ int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
         * Here we serialize access across the TIQN+TPG Tuple.
         */
        ret = down_interruptible(&tpg->np_login_sem);
-       if ((ret != 0) || signal_pending(current))
+       if (ret != 0)
                return -1;
 
        spin_lock_bh(&tpg->tpg_state_lock);
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.
index e8a2408..5e3295f 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -161,10 +161,7 @@ struct iscsi_portal_group *iscsit_get_tpg_from_np(
 int iscsit_get_tpg(
        struct iscsi_portal_group *tpg)
 {
-       int ret;
-
-       ret = mutex_lock_interruptible(&tpg->tpg_access_lock);
-       return ((ret != 0) || signal_pending(current)) ? -1 : 0;
+       return mutex_lock_interruptible(&tpg->tpg_access_lock);
 }
 
 void iscsit_put_tpg(struct iscsi_portal_group *tpg)
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 8855781..733824e 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -568,7 +568,7 @@ sbc_compare_and_write(struct se_cmd *cmd)
         * comparision using SGLs at cmd->t_bidi_data_sg..
         */
        rc = down_interruptible(&dev->caw_sem);
-       if ((rc != 0) || signal_pending(current)) {
+       if (rc != 0) {
                cmd->transport_complete_callback = NULL;
                return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
        }


