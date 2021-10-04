Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C489C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE6D6136F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhJDMLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:5858 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJDMLb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532787"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532787"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927019"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:01 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH RFC 0/6] scsi: ufs: Start to make driver synchronization easier to understand
Date:   Mon,  4 Oct 2021 15:06:44 +0300
Message-Id: <20211004120650.153218-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Driver synchronization would be easier to understand if we used the
clk_scaling_lock as the only lock to provide either shared (down/up_read)
or exclusive (down/up_write) access to the host.

These patches make changes with that in mind, finally resulting in being
able to hold the down_write() lock for the entire error handler duration.

If this approach is acceptable, it could be extended to simplify the
the synchronization of PM vs error handler and Shutdown vs sysfs.


Adrian Hunter (6):
      scsi: ufs: Encapsulate clk_scaling_lock by inline functions
      scsi: ufs: Rename clk_scaling_lock to host_rw_sem
      scsi: ufs: Let ufshcd_[down/up]_read be nested within ufshcd_[down/up]_write
      scsi: ufs: Fix a possible dead lock in clock scaling
      scsi: ufs: Reorder dev_cmd locking
      scsi: ufs: Hold ufshcd_down_write() lock for entire error handler duration

 drivers/scsi/ufs/ufshcd.c | 104 +++++++++++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h |  41 +++++++++++++++++-
 2 files changed, 87 insertions(+), 58 deletions(-)


Regards
Adrian
