From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] ufs: add support for query requests
Date: Tue, 7 May 2013 17:25:41 +0300
Message-ID: <20130507142540.GA20764@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23034 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3EGOZs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 10:25:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: draviv@codeaurora.org
Cc: linux-scsi@vger.kernel.org, kbuild@01.org

Hello Dolev Raviv,

This is a semi-automatic email about new static checker warnings.

The patch 3aee47c623a3: "[SCSI] ufs: add support for query requests"
from May 2, 2013, leads to the following Smatch complaint:

drivers/scsi/ufs/ufshcd.c:723 ufshcd_query_request()
	 error: we previously assumed 'hba' could be null (see line 722)

drivers/scsi/ufs/ufshcd.c
   721	
   722		if (!hba || !query || !response) {
                    ^^^^
New check.

   723			dev_err(hba->dev,
                                ^^^^^^^^
New dereference.

   724				"%s: NULL pointer hba = %p, query = %p response = %p\n",
   725				__func__, hba, query, response);

regards,
dan carpenter
