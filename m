From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] ipr: Increase max concurrent oustanding commands
Date: Mon, 23 Feb 2015 15:32:30 +0300
Message-ID: <20150223123230.GA7141@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32530 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbBWMcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 07:32:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Hello Brian King,

This is a semi-automatic email about new static checker warnings.

The patch 89aad4283173: "[SCSI] ipr: Increase max concurrent
oustanding commands" from Mar 14, 2012, leads to the following Smatch
complaint:

drivers/scsi/ipr.c:9038 ipr_alloc_cmd_blks()
	 error: we previously assumed 'ioa_cfg->ipr_cmnd_list' could be null (see line 9037)

drivers/scsi/ipr.c
  9036	
  9037		if (!ioa_cfg->ipr_cmnd_list || !ioa_cfg->ipr_cmnd_list_dma) {
                     ^^^^^^^^^^^^^^^^^^^^^^
This can be NULL.

  9038			ipr_free_cmd_blks(ioa_cfg);
                                          ^^^^^^^
But we dereference it unconditionally inside the ipr_free_cmd_blks()
function when we check: "if (ioa_cfg->ipr_cmnd_list[i])".  These kinds
of magic free everything functions are almost always buggy but Smatch
missed this bug initialy and I had to update it.  I'll push the Smatch
change later this week.  It requires the cross function database to
trigger this warning.

  9039			return -ENOMEM;
  9040		}

regards,
dan carpenter
