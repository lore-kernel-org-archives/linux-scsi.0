Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B689C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CBE61246
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbhI1SrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:05 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35722 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbhI1SrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854722; x=1664390722;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=PDhfMCRL7GgDDx8de7xTi+lX8vg1/0xL05ubEKP+V9s/SszPMtaqGww/
   pYV8IzZjoFI0fSutWJT8OtMk3V10Ga+7acFGtGKhol0MrHF/i20GRElvY
   7KN+oD9D2/eNFU9eRBR3/SbWgzQVrrUaTK1lmsniSMHunjj/tNbjcSAPB
   /cUOMYBiiG7z+m2DYRjVzGWB18I60avn8xFl5gWPgplc51oVvK4FfRt65
   372ppTHYJJpxS2KqzrTtpnpoGiUeV65s/OI+r8ed46p0Wp03Yjk8rux1V
   JSm7DKb/eV+gAMcKYdnq1dLIZaUk+eOU6KoDGj+VvHhLso+dwQ+IB0M1o
   A==;
IronPort-SDR: wGBs+TwHBH2b2OzJkmV06wEytpTAfmP3nzWSFgHeIXc9XJwoLAkGiwSmfqgZR36+HLxnT5TveE
 g5azmJEw7Z684VkgsFf2pm5s0aPIzghRCtG+6qRTQ6yIK7cdINE97gge1XbYdXengbRBjoJEIu
 ccb88enr8LAbcqATNeh2FdA8hJVZcwKGQ1fS8ZVXdAFUPsmF4oM5V08PnH02rp3HF7GPAnGwc/
 McSbXPKk1tW1TXlnB1hMvUd0sYMfmbvJ2acxYunexPue/Pq/9FBeRNtdDsoYwxUQxCKXDTbtIn
 8dW+j+k5CywriRN4Og2bseNy
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137712568"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:21 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:21 -0700
Subject: [PATCH 08/11] smartpqi: fix boot failure during lun rebuild
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:21 -0500
Message-ID: <163285472129.194893.10066078196474026373.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


