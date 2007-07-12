From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Thu, 12 Jul 2007 17:43:42 +0300
Message-ID: <46963E1E.9050601@panasas.com>
References: <468CDB3C.4060500@panasas.com> <468CF58E.1020901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24933 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933265AbXGLOnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 10:43:51 -0400
In-Reply-To: <468CF58E.1020901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
>   - The old scsi_{alloc,free}_sgtable() is no longer exported. This will break scsi_sgt
>     which will need to be converted to new implementation.

Hi Tomo.

Just for completion of the RFC I would like to have A quick draft patch
that converts stgt to the proposed scsi_sgtable implementation. If you
are busy, I have looked, it should not be too difficult for me to do it.
Do you want that I try? or maybe you could do something quick?

I think a start would be

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index f5a1dda..eecfe70 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -157,6 +157,9 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
+extern struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask);
+extern void scsi_free_sgtable(struct scsi_sgtable *sgt);
+
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
