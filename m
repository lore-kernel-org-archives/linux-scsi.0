From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: qedf: Add QLogic FastLinQ offload FCoE driver
 framework.
Date: Mon, 27 Feb 2017 19:47:09 +0300
Message-ID: <20170227163911.GA14561@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47786 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdB0Qrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 11:47:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chad.dupuis@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello Dupuis, Chad,

This is a semi-automatic email about new static checker warnings.

The patch 61d8658b4a43: "scsi: qedf: Add QLogic FastLinQ offload FCoE 
driver framework." from Feb 15, 2017, leads to the following Smatch 
complaint:

drivers/scsi/qedf/qedf_main.c:1565 qedf_vport_destroy()
	 warn: variable dereferenced before check 'vn_port->host' (see line 1551)

drivers/scsi/qedf/qedf_main.c
  1550		/* Detach from scsi-ml */
  1551		fc_remove_host(vn_port->host);
                               ^^^^^^^^^^^^^
Dereferenced inside function.

  1552		scsi_remove_host(vn_port->host);
  1553	
  1554		/*
  1555		 * Only try to release the exchange manager if the vn_port
  1556		 * configuration is complete.
  1557		 */
  1558		if (vn_port->state == LPORT_ST_READY)
  1559			fc_exch_mgr_free(vn_port);
  1560	
  1561		/* Free memory used by statistical counters */
  1562		fc_lport_free_stats(vn_port);
  1563	
  1564		/* Release Scsi_Host */
  1565		if (vn_port->host)
                    ^^^^^^^^^^^^^
Too late.

  1566			scsi_host_put(vn_port->host);
  1567	

regards,
dan carpenter
