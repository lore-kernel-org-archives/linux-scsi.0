From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: [PATCH 1/2] target: drop spin_lock_assert() + irqs_disabled() combo
 checks
Date: Fri, 23 Mar 2018 18:17:36 +0100
Message-ID: <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "acme@kernel.org" <acme@kernel.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

There are a few functions which check for if the lock is held
(spin_lock_assert()) and the interrupts are disabled (irqs_disabled()).
>From looking at the code, each function is static, the caller is near by
and does spin_lock_irq|safe(). As Linus puts it:

|It's not like this is some function that is exported to random users,
|and we should check that the calling convention is right.
|
|This looks like "it may have been useful during coding to document
|things, but it's not useful long-term".

Remove those checks.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/target_core_tmr.c       | 2 --
 drivers/target/target_core_transport.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 9c7bc1ca341a..3d35dad1de2c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -114,8 +114,6 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 74b646f165d4..2c3ddb3a4124 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2954,9 +2954,6 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	__acquires(&cmd->t_state_lock)
 {
 
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
-
 	if (fabric_stop)
 		cmd->transport_state |= CMD_T_FABRIC_STOP;
 
@@ -3241,9 +3238,6 @@ static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
 	int ret;
 
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
-
 	if (!(cmd->transport_state & CMD_T_ABORTED))
 		return 0;
 	/*
-- 
2.16.2
