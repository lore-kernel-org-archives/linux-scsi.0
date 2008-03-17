From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH] scsi: The supplement for the arithmetic of iomem ofthe Type_B Adapter of arcmsr
Date: Mon, 17 Mar 2008 10:08:42 +0800
Message-ID: <003d01c887d3$d29fdb00$9a00a8c0@Nick>
References: <1205526414.2904.78.camel@localhost.localdomain>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:50726 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCQCIv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 22:08:51 -0400
In-Reply-To: <1205526414.2904.78.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk, 'Andrew Morton' <akpm@linux-foundation.org>

Hi James,
What a mess I made!! Terrible
As you suggest, I agree with you. (I hope this time I don't misconstrue
again.)
Thanks,
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Saturday, March 15, 2008 4:27 AM
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org; randy.dunlap@oracle.com; 'Tomas Henzl';
viro@ftp.linux.org.uk; 'Andrew Morton'
Subject: Re: [PATCH] scsi: The supplement for the arithmetic of iomem ofthe
Type_B Adapter of arcmsr

On Fri, 2008-03-14 at 20:51 +0800, nickcheng wrote:
> Subject: [PATCH] scsi: The supplement for the arithmetic of iomem of the
> Type_B Adapter
> Description:
> add the description for the change of the arithmetic of iomem of the
Type_B
> Adapter in ChangeLog.arcmsr 
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

I confused you when I said I want the change log clearer, didn't I? What
I meant was the *git* changelog that precedes the patch, not your
Changelog.arcmsr, which I don't think we really care about.

Can I suggest the below for the correct replacement for both of these
patches?

James

---

From: nickcheng <nick.cheng@areca.com.tw>
Subject: [SCSI] arcmsr: fix iounmap error for Type B adapter

The Type B Adapter teardown does iounmap on pointers subtracted by a
constant offset.  Since the offset is in bytes, we need the pointers to
be of type void * not uint32_t * so the subtraction is done in the
correct units and we iounmap the correct area.

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/arcmsr/arcmsr.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 0393707..3288be2 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -341,13 +341,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	uint32_t	__iomem *drv2iop_doorbell_reg;
-	uint32_t	__iomem *drv2iop_doorbell_mask_reg;
-	uint32_t	__iomem *iop2drv_doorbell_reg;
-	uint32_t	__iomem *iop2drv_doorbell_mask_reg;
-	uint32_t	__iomem *msgcode_rwbuffer_reg;
-	uint32_t	__iomem *ioctl_wbuffer_reg;
-	uint32_t	__iomem *ioctl_rbuffer_reg;
+	void		__iomem *drv2iop_doorbell_reg;
+	void		__iomem *drv2iop_doorbell_mask_reg;
+	void		__iomem *iop2drv_doorbell_reg;
+	void		__iomem *iop2drv_doorbell_mask_reg;
+	void		__iomem *msgcode_rwbuffer_reg;
+	void		__iomem *ioctl_wbuffer_reg;
+	void		__iomem *ioctl_rbuffer_reg;
 };
 
 /*
-- 
1.5.4.1



