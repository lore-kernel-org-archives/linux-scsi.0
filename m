Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C2EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 15:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B98D61B1C
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 15:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhJBPr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Oct 2021 11:47:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:12596 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhJBPrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Oct 2021 11:47:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10125"; a="205187474"
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="205187474"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2021 08:46:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="557080976"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Oct 2021 08:46:02 -0700
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
Subject: [PATCH 0/2] scsi: ufs: Do not exit reset of error functions unless operational
Date:   Sat,  2 Oct 2021 18:45:48 +0300
Message-Id: <20211002154550.128511-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Callers of ufshcd_reset_and_restore() and ufshcd_err_handler() expect them
to return in an operational state. However, the code does not check the
state before exiting.  Here are a couple of patches to correct that.


Adrian Hunter (2):
      scsi: ufs: Do not exit ufshcd_reset_and_restore() unless operational or dead
      scsi: ufs: Do not exit ufshcd_err_handler() unless operational or dead

 drivers/scsi/ufs/ufshcd.c | 66 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 18 deletions(-)


Regards
Adrian
