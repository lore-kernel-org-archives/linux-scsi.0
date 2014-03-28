From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] be2iscsi: Fix handling timed out MBX completion from FW
Date: Fri, 28 Mar 2014 11:41:37 +0300
Message-ID: <20140328084137.GS25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaC1Ily (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2014 04:41:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello Jayamohan Kallickal,

The patch 1957aa7f6246: "[SCSI] be2iscsi: Fix handling timed out MBX
completion from FW" from Jan 29, 2014, leads to the following static
checker warning:

	drivers/scsi/be2iscsi/be_main.c:5581 beiscsi_dev_probe()
	error: memset() '&phba->ctrl.ptag_state[i]->tag_mem_state' too small (24 vs 32)

drivers/scsi/be2iscsi/be_main.c
  5576          for (i = 0; i < MAX_MCC_CMD; i++) {
  5577                  init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
  5578                  phba->ctrl.mcc_tag[i] = i + 1;
  5579                  phba->ctrl.mcc_numtag[i + 1] = 0;
  5580                  phba->ctrl.mcc_tag_available++;
  5581                  memset(&phba->ctrl.ptag_state[i].tag_mem_state, 0,
  5582                         sizeof(struct beiscsi_mcc_tag_state));
                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Probably this this be change to sizeof(struct be_dma_mem struct)?  It
looks like we are corrupting memory a bit here.

  5583          }

regards,
dan carpenter
