From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] aacraid: missing capable() check in compat ioctl
Date: Tue, 29 Oct 2013 22:11:06 +0300
Message-ID: <20131029191105.GE21820@longonot.mountain>
References: <20131025144452.GA28451@ngolde.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27008 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3J2TOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 15:14:17 -0400
Content-Disposition: inline
In-Reply-To: <20131025144452.GA28451@ngolde.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Nico Golde <nico@ngolde.de>, security@kernel.org

In d496f94d22d1 ('[SCSI] aacraid: fix security weakness') we added a
check on CAP_SYS_RAWIO to the ioctl.  The compat ioctls need the check
as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 408a42e..f0d432c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -771,6 +771,8 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
