From: Kokachev Oleksiy <o.kokachev@samsung.com>
Subject: rescan_partitions() in SCSI disk driver
Date: Thu, 13 Jul 2006 12:27:51 +0900
Message-ID: <004001c6a62c$5290c8f0$73a5580a@swcenter.sec.samsung.co.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:40817 "EHLO
	mailout3.samsung.com") by vger.kernel.org with ESMTP
	id S932336AbWGMD2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 23:28:25 -0400
Received: from ep_mmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0J2B00JIAOAGIC@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 13 Jul 2006 12:27:52 +0900 (KST)
Received: from KOKACHEV ([10.88.165.115])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0J2B00JEGOAF9N@mmp1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 13 Jul 2006 12:27:51 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all.
I'm trying to make some modifications to SCSI driver to correctly sync
/proc/partitions when new disk is inserted.
To revalidate disk I used sd_revalidate_disk(), but this function revalidate
only disk info, but do not rescan partition table. How can I tell the driver
to correctly rescan part/ table? I've tried to use rescan_partitions()
function like below, but failed:
	struct scsi_disk *sdkp;
      bdev = bdget_disk(sdkp->disk, 0);
	rescan_partitions(sdkp->disk, bdev);
But in this case bdev->bd_disk is NULL. Why? What did I do not correct?
Thank for help.

