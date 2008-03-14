From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: The supplement for the arithmetic of iomem of
	the Type_B Adapter of arcmsr
Date: Fri, 14 Mar 2008 15:26:54 -0500
Message-ID: <1205526414.2904.78.camel@localhost.localdomain>
References: <000201c885d2$1814ecb0$9a00a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60501 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbYCNU06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 16:26:58 -0400
In-Reply-To: <000201c885d2$1814ecb0$9a00a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk, 'Andrew Morton' <akpm@linux-foundation.org>

On Fri, 2008-03-14 at 20:51 +0800, nickcheng wrote:
> Subject: [PATCH] scsi: The supplement for the arithmetic of iomem of the
> Type_B Adapter
> Description:
> add the description for the change of the arithmetic of iomem of the Type_B
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



