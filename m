From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 06 Aug 2008 09:53:02 -0700
Message-ID: <1218041582.7493.19.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.64.0808061629220.10184@blonde.site>
	 <1218040613.7493.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52736 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYHFQxG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 12:53:06 -0400
In-Reply-To: <1218040613.7493.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 09:36 -0700, James Bottomley wrote:
> On Wed, 2008-08-06 at 16:34 +0100, Hugh Dickins wrote:
> >   PQual=0  Device_type=0  RMB=1  version=0x00  [no conformance
> > claimed]
> 
> We could try using this as the trigger.  I assume all DIF supporting
> devices must also claim conformance to SPC3/SBC2 or higher?

Just to formalise it, that would be this patch.  Hugh, could you try it?

Thanks,

James

---

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 291d56a..ffbc84a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -426,7 +426,7 @@ static inline int scsi_device_enclosure(struct scsi_device *sdev)
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
-	return sdev->inquiry[5] & (1<<0);
+	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \


