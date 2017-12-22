From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: fix iscsi-related kernel-doc warnings
Date: Fri, 22 Dec 2017 14:08:27 -0800
Message-ID: <44a0f532-b1e9-e0cf-4a61-d592a4306f61@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in drivers/scsi/ that are related to iscsi
support interfaces.

Fixes these kernel-doc warnings: (tested by adding these files to a new
target.rst documentation file: WIP)

../drivers/scsi/libiscsi.c:2740: warning: No description found for parameter 'dd_size'
../drivers/scsi/libiscsi.c:2740: warning: No description found for parameter 'id'
../drivers/scsi/libiscsi.c:2961: warning: No description found for parameter 'cls_conn'
../drivers/scsi/iscsi_tcp.c:313: warning: No description found for parameter 'conn'
../drivers/scsi/iscsi_tcp.c:363: warning: No description found for parameter 'conn'
../drivers/scsi/libiscsi_tcp.c:810: warning: No description found for parameter 'tcp_conn'
../drivers/scsi/libiscsi_tcp.c:810: warning: No description found for parameter 'segment'
../drivers/scsi/libiscsi_tcp.c:887: warning: No description found for parameter 'offloaded'
../drivers/scsi/libiscsi_tcp.c:887: warning: No description found for parameter 'status'
../drivers/scsi/libiscsi_tcp.c:887: warning: Excess function parameter 'offload' description in 'iscsi_tcp_recv_skb'
../drivers/scsi/libiscsi_tcp.c:964: warning: Excess function parameter 'conn' description in 'iscsi_tcp_task_init'
../drivers/scsi/libiscsi_tcp.c:964: warning: Excess function parameter 'sc' description in 'iscsi_tcp_task_init'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	"Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc:	linux-scsi@vger.kernel.org
Cc:	target-devel@vger.kernel.org
Cc:	Sagi Grimberg <sagi@grimberg.me>
Cc:	linux-rdma@vger.kernel.org
Cc:	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc:	"Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/iscsi_tcp.c    |    2 ++
 drivers/scsi/libiscsi.c     |    4 +++-
 drivers/scsi/libiscsi_tcp.c |    9 +++++----
 3 files changed, 10 insertions(+), 5 deletions(-)

--- linux-next-20171221.orig/drivers/scsi/libiscsi.c
+++ linux-next-20171221/drivers/scsi/libiscsi.c
@@ -2722,8 +2722,10 @@ static void iscsi_host_dec_session_cnt(s
  * @iscsit: iscsi transport template
  * @shost: scsi host
  * @cmds_max: session can queue
+ * @dd_size: private driver data size, added to session allocation size
  * @cmd_task_size: LLD task private data size
  * @initial_cmdsn: initial CmdSN
+ * @id: target ID to add to this session
  *
  * This can be used by software iscsi_transports that allocate
  * a session per scsi host.
@@ -2951,7 +2953,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_setup);
 
 /**
  * iscsi_conn_teardown - teardown iscsi connection
- * cls_conn: iscsi class connection
+ * @cls_conn: iscsi class connection
  *
  * TODO: we may need to make this into a two step process
  * like scsi-mls remove + put host
--- linux-next-20171221.orig/drivers/scsi/iscsi_tcp.c
+++ linux-next-20171221/drivers/scsi/iscsi_tcp.c
@@ -307,6 +307,7 @@ static int iscsi_sw_tcp_xmit_segment(str
 
 /**
  * iscsi_sw_tcp_xmit - TCP transmit
+ * @conn: iscsi connection
  **/
 static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 {
@@ -357,6 +358,7 @@ error:
 
 /**
  * iscsi_tcp_xmit_qlen - return the number of bytes queued for xmit
+ * @conn: iscsi connection
  */
 static inline int iscsi_sw_tcp_xmit_qlen(struct iscsi_conn *conn)
 {
--- linux-next-20171221.orig/drivers/scsi/libiscsi_tcp.c
+++ linux-next-20171221/drivers/scsi/libiscsi_tcp.c
@@ -798,6 +798,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn
 
 /**
  * iscsi_tcp_hdr_recv_done - process PDU header
+ * @tcp_conn: iSCSI TCP connection
+ * @segment: the buffer segment being processed
  *
  * This is the callback invoked when the PDU header has
  * been received. If the header is followed by additional
@@ -876,9 +878,10 @@ EXPORT_SYMBOL_GPL(iscsi_tcp_recv_segment
  * @conn: iscsi connection
  * @skb: network buffer with header and/or data segment
  * @offset: offset in skb
- * @offload: bool indicating if transfer was offloaded
+ * @offloaded: bool indicating if transfer was offloaded
+ * @status: iscsi TCP status result
  *
- * Will return status of transfer in status. And will return
+ * Will return status of transfer in @status. And will return
  * number of bytes copied.
  */
 int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
@@ -955,9 +958,7 @@ EXPORT_SYMBOL_GPL(iscsi_tcp_recv_skb);
 
 /**
  * iscsi_tcp_task_init - Initialize iSCSI SCSI_READ or SCSI_WRITE commands
- * @conn: iscsi connection
  * @task: scsi command task
- * @sc: scsi command
  */
 int iscsi_tcp_task_init(struct iscsi_task *task)
 {
