From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: Add support for clock gating
Date: Thu, 2 Oct 2014 18:30:54 +0300
Message-ID: <20141002153054.GA11534@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaJBPbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 11:31:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stummala@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Sahitya Tummala,

The patch 1ab27c9cf8b6: "ufs: Add support for clock gating" from Sep
25, 2014, leads to the following static checker warning:

	drivers/scsi/ufs/ufshcd.c:4474 __ufshcd_setup_clocks()
	warn: we tested 'ret' before and it was 'false'

drivers/scsi/ufs/ufshcd.c
  4467                  ret = hba->vops->setup_clocks(hba, on);
  4468  out:
  4469          if (ret) {
  4470                  list_for_each_entry(clki, head, list) {
  4471                          if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
  4472                                  clk_disable_unprepare(clki->clk);
  4473                  }
  4474          } else if (!ret && on) {
                           ^^^^
Not needed.

  4475                  spin_lock_irqsave(hba->host->host_lock, flags);
  4476                  hba->clk_gating.state = CLKS_ON;
  4477                  spin_unlock_irqrestore(hba->host->host_lock, flags);
  4478          }
  4479          return ret;
  4480  }


regards,
dan carpenter
