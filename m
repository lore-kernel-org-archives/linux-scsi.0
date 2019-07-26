From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: initio: Make some functions static
Date: Fri, 26 Jul 2019 21:58:14 +0800
Message-ID: <20190726135814.48760-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix sparse warnings:

drivers/scsi/initio.c:881:22: warning: symbol 'initio_find_busy_scb' was not declared. Should it be static?
drivers/scsi/initio.c:919:22: warning: symbol 'initio_find_done_scb' was not declared. Should it be static?
drivers/scsi/initio.c:1657:5: warning: symbol 'initio_state_7' was not declared. Should it be static?
drivers/scsi/initio.c:1743:5: warning: symbol 'initio_xpad_in' was not declared. Should it be static?
drivers/scsi/initio.c:1767:5: warning: symbol 'initio_xpad_out' was not declared. Should it be static?
drivers/scsi/initio.c:1792:5: warning: symbol 'initio_status_msg' was not declared. Should it be static?
drivers/scsi/initio.c:1842:5: warning: symbol 'int_initio_busfree' was not declared. Should it be static?
drivers/scsi/initio.c:1912:5: warning: symbol 'int_initio_resel' was not declared. Should it be static?
drivers/scsi/initio.c:2368:5: warning: symbol 'initio_bus_device_reset' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/initio.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 41fd64c..ed9e87a 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -864,7 +864,8 @@ static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 	return;
 }
 
-struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
+static struct
+scsi_ctrl_blk *initio_find_busy_scb(struct initio_host *host, u16 tarlun)
 {
 	struct scsi_ctrl_blk *tmp, *prev;
 	u16 scbp_tarlun;
@@ -902,7 +903,8 @@ static void initio_append_done_scb(struct initio_host * host, struct scsi_ctrl_b
 	}
 }
 
-struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host * host)
+static struct
+scsi_ctrl_blk *initio_find_done_scb(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *tmp;
 
@@ -1640,7 +1642,7 @@ static int initio_state_6(struct initio_host * host)
  *
  */
 
-int initio_state_7(struct initio_host * host)
+static int initio_state_7(struct initio_host *host)
 {
 	int cnt, i;
 
@@ -1726,7 +1728,7 @@ static int initio_xfer_data_out(struct initio_host * host)
 	return 0;		/* return to OS, wait xfer done , let jas_isr come in */
 }
 
-int initio_xpad_in(struct initio_host * host)
+static int initio_xpad_in(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1750,7 +1752,7 @@ int initio_xpad_in(struct initio_host * host)
 	}
 }
 
-int initio_xpad_out(struct initio_host * host)
+static int initio_xpad_out(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1775,7 +1777,7 @@ int initio_xpad_out(struct initio_host * host)
 	}
 }
 
-int initio_status_msg(struct initio_host * host)
+static int initio_status_msg(struct initio_host *host)
 {				/* status & MSG_IN */
 	struct scsi_ctrl_blk *scb = host->active;
 	u8 msg;
@@ -1825,7 +1827,7 @@ int initio_status_msg(struct initio_host * host)
 
 
 /* scsi bus free */
-int int_initio_busfree(struct initio_host * host)
+static int int_initio_busfree(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 
@@ -1895,7 +1897,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
  *	and continue processing that command.
  */
 
-int int_initio_resel(struct initio_host * host)
+static int int_initio_resel(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb;
 	struct target_control *active_tc;
@@ -2351,7 +2353,7 @@ static void initio_select_atn3(struct initio_host * host, struct scsi_ctrl_blk *
  *	Perform a device reset and abort all pending SCBs for the
  *	victim device
  */
-int initio_bus_device_reset(struct initio_host * host)
+static int initio_bus_device_reset(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
-- 
2.7.4
