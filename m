From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm80xx: Print SAS address of IO failed device.
Date: Fri, 1 Nov 2013 13:29:11 +0300
Message-ID: <20131101102911.GJ29795@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36388 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3KAKcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 06:32:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: AnandKumar.Santhanam@pmcs.com
Cc: linux-scsi@vger.kernel.org

Hello Anand Kumar Santhanam,

This is a semi-automatic email about new static checker warnings.

The patch cb269c26ed02: "[SCSI] pm80xx: Print SAS address of IO 
failed device." from Sep 17, 2013, leads to the following Smatch 
complaint:

drivers/scsi/pm8001/pm8001_hwi.c:2343 mpi_sata_completion()
	 error: we previously assumed 't->dev' could be null (see line 2319)

drivers/scsi/pm8001/pm8001_hwi.c
  2318		if (t) {
  2319			if (t->dev && (t->dev->lldd_dev))
                            ^^^^^
Exisiting check.

  2320				pm8001_dev = t->dev->lldd_dev;
  2321		} else {
  2322			PM8001_FAIL_DBG(pm8001_ha,
  2323				pm8001_printk("task null\n"));
  2324			return;
  2325		}
  2326	
  2327		if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
  2328			&& unlikely(!t || !t->lldd_task || !t->dev)) {
                                                           ^^^^^^^
Existing check.

  2329			PM8001_FAIL_DBG(pm8001_ha,
  2330				pm8001_printk("task or dev null\n"));
  2331			return;
  2332		}
  2333	
  2334		ts = &t->task_status;
  2335		if (!ts) {
  2336			PM8001_FAIL_DBG(pm8001_ha,
  2337				pm8001_printk("ts null\n"));
  2338			return;
  2339		}
  2340		/* Print sas address of IO failed device */
  2341		if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
  2342			(status != IO_UNDERFLOW)) {
  2343			if (!((t->dev->parent) &&
                               ^^^^^^^^
Patch introduces new unchecked dereference.

  2344				(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
  2345				for (i = 0 , j = 4; j <= 7 && i <= 3; i++ , j++)

regards,
dan carpenter
