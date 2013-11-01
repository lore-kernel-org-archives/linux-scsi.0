From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm80xx: Print SAS address of IO failed device.
Date: Fri, 1 Nov 2013 13:29:43 +0300
Message-ID: <20131101102943.GK29795@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22439 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3KAKcp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 06:32:45 -0400
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

drivers/scsi/pm8001/pm8001_hwi.c:2368 mpi_sata_completion()
	 error: we previously assumed 'pm8001_dev' could be null (see line 2327)

drivers/scsi/pm8001/pm8001_hwi.c
  2326	
  2327		if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
                     ^^^^^^^^^^
Existing check.

  2328			&& unlikely(!t || !t->lldd_task || !t->dev)) {
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
  2344				(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
  2345				for (i = 0 , j = 4; j <= 7 && i <= 3; i++ , j++)
  2346					sata_addr_low[i] = pm8001_ha->sas_addr[j];
  2347				for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
  2348					sata_addr_hi[i] = pm8001_ha->sas_addr[j];
  2349				memcpy(&temp_sata_addr_low, sata_addr_low,
  2350					sizeof(sata_addr_low));
  2351				memcpy(&temp_sata_addr_hi, sata_addr_hi,
  2352					sizeof(sata_addr_hi));
  2353				temp_sata_addr_hi = (((temp_sata_addr_hi >> 24) & 0xff)
  2354							|((temp_sata_addr_hi << 8) &
  2355							0xff0000) |
  2356							((temp_sata_addr_hi >> 8)
  2357							& 0xff00) |
  2358							((temp_sata_addr_hi << 24) &
  2359							0xff000000));
  2360				temp_sata_addr_low = ((((temp_sata_addr_low >> 24)
  2361							& 0xff) |
  2362							((temp_sata_addr_low << 8)
  2363							& 0xff0000) |
  2364							((temp_sata_addr_low >> 8)
  2365							& 0xff00) |
  2366							((temp_sata_addr_low << 24)
  2367							& 0xff000000)) +
  2368							pm8001_dev->attached_phy +
                                                        ^^^^^^^^^^^^^^^^^^^^^^^^
Patch introduces new unchecked dereference.

  2369							0x10);
  2370				PM8001_FAIL_DBG(pm8001_ha,

regards,
dan carpenter
