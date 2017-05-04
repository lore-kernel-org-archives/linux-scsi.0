From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: cxlflash: Add hardware queues attribute
Date: Thu, 4 May 2017 13:09:30 +0300
Message-ID: <20170504100929.n4cuen56qu2mrmok@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39563 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbdEDKJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2017 06:09:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mrochs@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Hello Matthew R. Ochs,

This is a semi-automatic email about new static checker warnings.

The patch 3065267a80c8: "scsi: cxlflash: Add hardware queues 
attribute" from Apr 12, 2017, leads to the following Smatch complaint:

drivers/scsi/cxlflash/main.c:722 term_afu()
	 warn: variable dereferenced before check 'cfg->afu' (see line 719)

drivers/scsi/cxlflash/main.c
   718		 */
   719		for (k = cfg->afu->num_hwqs - 1; k >= 0; k--)
                         ^^^^^^^^
Patch introduces a new dereference.

   720			term_intr(cfg, UNMAP_THREE, k);
   721	
   722		if (cfg->afu)
                    ^^^^^^^^
But the existing code assumed it could be NULL.  Presumably it can't?

   723			stop_afu(cfg);
   724	

regards,
dan carpenter
