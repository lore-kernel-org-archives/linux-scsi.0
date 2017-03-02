From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: qedf: Add QLogic FastLinQ offload FCoE driver
 framework.
Date: Thu, 2 Mar 2017 23:28:18 +0300
Message-ID: <20170302202818.GA10877@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42153 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdCBU3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 15:29:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chad.dupuis@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello Dupuis, Chad,

The patch 61d8658b4a43: "scsi: qedf: Add QLogic FastLinQ offload FCoE
driver framework." from Feb 15, 2017, leads to the following static
checker warning:

	drivers/scsi/qedf/qedf_main.c:1168 qedf_rport_event_handler()
	warn: 'rval' can be either negative or positive

drivers/scsi/qedf/qedf_main.c
  1005  static int qedf_offload_connection(struct qedf_ctx *qedf,
  1006          struct qedf_rport *fcport)
  1007  {
  1008          struct qed_fcoe_params_offload conn_info;
  1009          u32 port_id;
  1010          u8 lport_src_id[3];
  1011          int rval;
  1012          uint16_t total_sqe = (fcport->sq_mem_size / sizeof(struct fcoe_wqe));
  1013  
  1014          QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_CONN, "Offloading connection "
  1015                     "portid=%06x.\n", fcport->rdata->ids.port_id);
  1016          rval = qed_ops->acquire_conn(qedf->cdev, &fcport->handle,
  1017              &fcport->fw_cid, &fcport->p_doorbell);
  1018          if (rval) {
  1019                  QEDF_WARN(&(qedf->dbg_ctx), "Could not acquire connection "
  1020                             "for portid=%06x.\n", fcport->rdata->ids.port_id);
  1021                  rval = 1; /* For some reason qed returns 0 on failure here */

What kind of an error is 1 supposed to indicate?  This needs to be
not a magic number and commented.

  1022                  goto out;
  1023          }
  1024  
  1025          QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_CONN, "portid=%06x "
  1026                     "fw_cid=%08x handle=%d.\n", fcport->rdata->ids.port_id,
  1027                     fcport->fw_cid, fcport->handle);
  1028  
  1029          memset(&conn_info, 0, sizeof(struct qed_fcoe_params_offload));
  1030  

regards,
dan carpenter
