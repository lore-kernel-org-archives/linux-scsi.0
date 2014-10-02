From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: definitions for phy interface
Date: Thu, 2 Oct 2014 18:31:38 +0300
Message-ID: <20141002153138.GC11534@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaJBPbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 11:31:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: draviv@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Dolev Raviv,

This is a semi-automatic email about new static checker warnings.

The patch e785060ea3a1: "ufs: definitions for phy interface" from Sep 
25, 2014, leads to the following Smatch complaint:

drivers/scsi/ufs/ufshcd.c:5118 ufshcd_system_suspend()
	 error: we previously assumed 'hba' could be null (see line 5089)

drivers/scsi/ufs/ufshcd.c
  5088	
  5089		if (!hba || !hba->is_powered)
                    ^^^^
Existing check for NULL.

  5090			goto out;
  5091	

[ snip ]

  5115		ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
  5116	out:
  5117		if (!ret)
  5118			hba->is_sys_suspended = true;
                        ^^^^^^^^^^^^^^^^^^^^^
New unchecked dereference.  This is a One Err Bug caused by "out" label
style error handling.

  5119		return ret;
  5120	}

regards,
dan carpenter
