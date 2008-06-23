From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/4] SCSI multibyte accessors
Date: Mon, 23 Jun 2008 09:54:33 -0600
Message-ID: <20080623155433.GH4392@parisc-linux.org>
References: <20080623151525.GE4392@parisc-linux.org> <1214235154.3310.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48715 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbYFWPyt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 11:54:49 -0400
Content-Disposition: inline
In-Reply-To: <1214235154.3310.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 23, 2008 at 10:32:34AM -0500, James Bottomley wrote:
> On Mon, 2008-06-23 at 09:15 -0600, Matthew Wilcox wrote:
> > Introduce scsi_{get,put}_u{16,24,32}
> > 
> > The u16 and u32 variants are just aliases for be16 and be32 unaligned
> > accessors.  u24 is open-coded byte accessors as the meaning of a
> > byteswapped u24 quantity isn't entirely unambiguous, but we know what
> > we want to accomplish with scsi_get_u24.
> > 
> > Also remove scsi_to_u32 and change its only user to scsi_get_u32().
> 
> If we're just doing this in the abstract, then we need a u64 as well for
> things like port addresses.

Ah, I hadn't noticed any u64s in the specs I've been looking at.
Trivial to add, updated patch below.  I'm not entirely doing this in the
abstract; patch 3/4 uses scsi_put_u16().

----

Introduce scsi_{get,put}_u{16,24,32,64}

The u16, u32 and u64 variants are just aliases for the big-endian
unaligned accessors.  u24 is written as open-coded byte accessors since
the meaning of a byteswapped u24 quantity isn't entirely unambiguous,
but we know what we want to accomplish with scsi_get_u24.

Also remove scsi_to_u32 and change its only user to scsi_get_u32().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index aefd865..b28ec39 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -541,10 +541,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	if (!res)
 		goto out;
 
-	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
-	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
-	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
-	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
+	phy->invalid_dword_count = scsi_get_u32(&resp[12]);
+	phy->running_disparity_error_count = scsi_get_u32(&resp[16]);
+	phy->loss_of_dword_sync_count = scsi_get_u32(&resp[20]);
+	phy->phy_reset_problem_count = scsi_get_u32(&resp[24]);
 
  out:
 	kfree(resp);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 32742c4..7be84b9 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -486,10 +486,28 @@ struct scsi_lun {
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
+
+/* SCSI is a big-endian protocol and does not align data naturally */
+#include <asm/unaligned.h>
+
+#define scsi_get_u16(addr)		get_unaligned_be16(addr)
+#define scsi_get_u32(addr)		get_unaligned_be32(addr)
+#define scsi_get_u64(addr)		get_unaligned_be64(addr)
+#define scsi_put_u16(data, addr)	put_unaligned_be16(data, addr)
+#define scsi_put_u32(data, addr)	put_unaligned_be32(data, addr)
+#define scsi_put_u64(data, addr)	put_unaligned_be64(data, addr)
+
+/* READ6 / WRITE6 contain a 24-bit quantity */
+static inline unsigned int scsi_get_u24(unsigned char *addr)
+{
+	return (addr[0] << 16) | (addr[1] << 8) | addr[2];
+}
+
+static inline void scsi_put_u24(unsigned int data, unsigned char *addr)
 {
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
+	addr[0] = data >> 16;
+	addr[1] = data >> 8;
+	addr[2] = data;
 }
 
 #endif /* _SCSI_SCSI_H */

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
