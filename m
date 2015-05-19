From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [BUG] iscsi-target: deadlock because of iscsit_get_tpg()
Date: Tue, 19 May 2015 23:25:30 +0300
Message-ID: <555B9C3A.40106@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Our tool reports a potential double lock because of quite strange code
in iscsit_get_tpg().

drivers/target/iscsi/iscsi_target_tpg.c:
int iscsit_get_tpg(
	struct iscsi_portal_group *tpg)
{
	int ret;

	ret = mutex_lock_interruptible(&tpg->tpg_access_lock);
	return ((ret != 0) || signal_pending(current)) ? -1 : 0;
}

If mutex_lock_interruptible() successfully acquires the mutex, but there
is a pending signal, the function returns error, but it leaves the mutex
held. Callers do not expect such behaviour that can lead to a deadlock.

Why the check for pending signal is needed here?

Found by Linux Driver Verification project (linuxtesting.org).


Similar dangerous pattern presents in a couple of other places:

drivers/target/iscsi/iscsi_target.c:
int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
{
...
	ret = down_interruptible(&tpg->np_login_sem);
	if ((ret != 0) || signal_pending(current))
		return -1;


drivers/target/target_core_sbc.c:
static sense_reason_t
sbc_compare_and_write(struct se_cmd *cmd)
{
...
	rc = down_interruptible(&dev->caw_sem);
	if ((rc != 0) || signal_pending(current)) {
		cmd->transport_complete_callback = NULL;
		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
	}


--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
