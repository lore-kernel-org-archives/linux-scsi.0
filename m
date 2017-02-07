From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Tue, 7 Feb 2017 15:57:12 +0300
Message-ID: <20170207125712.GA31376@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34058 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbdBGM5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 07:57:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch 327825574132: "scsi_dh_rdac: switch to
scsi_execute_req_flags()" from Nov 3, 2016, leads to the following
static checker warning:

	drivers/scsi/device_handler/scsi_dh_rdac.c:551 send_mode_select()
	error: potential NULL dereference 'ctlr->ms_sdev'.

drivers/scsi/device_handler/scsi_dh_rdac.c
   529  static void send_mode_select(struct work_struct *work)
   530  {
   531          struct rdac_controller *ctlr =
   532                  container_of(work, struct rdac_controller, ms_work);
   533          struct scsi_device *sdev = ctlr->ms_sdev;
   534          struct rdac_dh_data *h = sdev->handler_data;
   535          int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
   536          struct rdac_queue_data *tmp, *qdata;
   537          LIST_HEAD(list);
   538          unsigned char cdb[COMMAND_SIZE(MODE_SELECT_10)];
   539          struct scsi_sense_hdr sshdr;
   540          unsigned int data_size;
   541          u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
   542                  REQ_FAILFAST_DRIVER;
   543  
   544          spin_lock(&ctlr->ms_lock);
   545          list_splice_init(&ctlr->ms_head, &list);
   546          ctlr->ms_queued = 0;
   547          ctlr->ms_sdev = NULL;
                ^^^^^^^^^^^^^^^^^^^^
We set this to NULL.

   548          spin_unlock(&ctlr->ms_lock);
   549  
   550   retry:
   551          data_size = rdac_failover_get(ctlr, &list, cdb);
                                              ^^^^
Then dereference it here inside this function.

   552  
   553          RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
   554                  "%s MODE_SELECT command",
   555                  (char *) h->ctlr->array_name, h->ctlr->index,
   556                  (retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
   557  

regards,
dan carpenter
