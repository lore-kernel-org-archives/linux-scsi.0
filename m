From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Fix SessionType=Discovery RX context conn->conn_logout_comp hang
Date: Wed, 25 May 2011 18:31:12 -0700
Message-ID: <1306373472-20573-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James & Co.

Below is the one outstanding bugfix patch to apply on top of iscsi-target
PATCH-v5 for an initial .40-rc1 / .2.8.0-rc1 merge into scsi-misc.

Once again, thanks to Martin Svec for efficently tracking down this issue
and getting this patch tested+verified the initial merge code on .39-rc..

Thanks!

--nab

----------------------------------------------------------------------------

This patch fixes a bug in iscsi_target_rx_thread():ISCSI_OP_LOGOUT where
conn->conn_logout_comp was sleeping definately on wait_for_completion with
SessionType=Discovery.  This was occuring because the per connection NopIN
timer is correctly not enabled for discovery sessions, and hence does not
fire to trigger an connection failure event in iscsi_target_tx_thread() ->
iscsit_close_connection() in order to wakeup the sleeping RX thread context.

This patch changes the conn_logout_comp to use wait_for_completion_timeout()
for both cases and defines a SECONDS_FOR_LOGOUT_COMP of 15 seconds.

Reported-by & Tested-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      |    3 ++-
 drivers/target/iscsi/iscsi_target_core.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6bba5fd..964cadc 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4292,7 +4292,8 @@ restart:
 		case ISCSI_OP_LOGOUT:
 			ret = iscsit_handle_logout_cmd(conn, buffer);
 			if (ret > 0) {
-				wait_for_completion(&conn->conn_logout_comp);
+				wait_for_completion_timeout(&conn->conn_logout_comp,
+						SECONDS_FOR_LOGOUT_COMP * HZ);
 				goto transport_err;
 			} else if (ret < 0)
 				goto transport_err;
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index c7ca0a0..af24171 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -15,6 +15,7 @@
 #define ISCSI_RX_THREAD_TCP_TIMEOUT	2
 #define SECONDS_FOR_ASYNC_LOGOUT	10
 #define SECONDS_FOR_ASYNC_TEXT		10
+#define SECONDS_FOR_LOGOUT_COMP		15
 #define WHITE_SPACE			" \t\v\f\n\r"
 
 /* struct iscsi_node_attrib sanity values */
-- 
1.7.5.2
