Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0DBC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 11:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiB1Lhf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 06:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiB1Lhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 06:37:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7875B70F77
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 03:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646048216; x=1677584216;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vrM/+608hXm9cpuwgeLxXTqUt9uetDH6/rbIvBmKbWk=;
  b=Zq92tjXY5ybZdBmB7h4mkMGFD1UWLrip2KANVSwBWDR7ynjKks61KxiG
   BA0o4KYIHCS/Utf8C+K5D6eK1WM5BGEMF3XEmc/1tetcvmGF2cTamrGp0
   8eXtAeoI1EQ7nKmDCd4UCfx8CiLJlTvoUlXGOkKiXjXmb//FxRIuqgMLb
   RWAkMhfKfzqPVIOUjf7caO9mYgmIA7PT7WJwJ9RBAVusIYGyYx9kCzHeN
   WHABLXyXsaCygshCwJ57Rthb7UzuScDdTcHgU3PGE4246PjTspYuxHuw4
   aJgYV0fC6t5CloSnRRV8jzjUTlUOm3wL+BUoVjfxtmixz12Hu5wu73Lg4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252789315"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252789315"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 03:36:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="629602621"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Feb 2022 03:36:53 -0800
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
Subject: [PATCH V4 0/2] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Mon, 28 Feb 2022 13:36:50 +0200
Message-Id: <20220228113652.970857-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Here is V4 to address comments by Martin.  See patches for version history.

Summary:

Kernel messages produced during runtime PM can cause a never-ending
cycle because user space utilities (e.g. journald or rsyslog) write the
messages back to storage, causing runtime resume, more messages, and so
on.

Messages that tell of things that are expected to happen, are arguably
unnecessary, so make changes to suppress them for the UFS driver.


Adrian Hunter (2):
      scsi: Add quiet_suspend flag for SCSI devices to suppress some PM messages
      scsi: ufs: Fix runtime PM messages never-ending cycle

 drivers/scsi/scsi_error.c  |  9 +++++++--
 drivers/scsi/sd.c          |  6 ++++--
 drivers/scsi/ufs/ufshcd.c  | 21 +++++++++++++++++++--
 include/scsi/scsi_device.h |  6 ++++++
 4 files changed, 36 insertions(+), 6 deletions(-)


Regards
Adrian
