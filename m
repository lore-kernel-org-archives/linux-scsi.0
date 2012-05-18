From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH 4/4] firewire: sbp2: remove overzealous alignment constraints
Date: Fri, 18 May 2012 22:26:21 +0200
Message-ID: <4FB6B06D.9010204@ladisch.de>
References: <4FB67AFC.7090402@ladisch.de>	<4FB67BDD.2030707@ladisch.de> <20120518210855.43cc7e0b@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54924 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758750Ab2ERU0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 16:26:43 -0400
In-Reply-To: <20120518210855.43cc7e0b@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Stefan Richter wrote:
> On May 18 Clemens Ladisch wrote at linux1394-devel:
>> The SBP-2/3 specifications do not require any alignment of data
>> buffers; only their own data structures need to be quadlet-aligned.
>
> SBP-2 clause 3.1.2.24 requires that system memory accepts quadlet r/w
> access.

Most of these definitions are just copied from IEC 13213; system
memory is allowed to accept block R/W requests, and SBP in fact
requires them.

> Memory which is not aligned at quadlet boundaries is not
> accessible by quadlet accesses per IEEE 1394 clause 6.2.5.2.2.

SBP-2 explicitly mentions unaligned accesses in 3.2.2, and 9.2 says:
| When page_table_present is zero, a page_size value of zero indicates
| that there are no alignment requirements.

>> This patch is perfectly safe because there is no actual change:
>> the SCSI framework uses a default block queue DMA alignment of
>> 32 bits anyway.
>
> This code was added after recommendation to set it explicitly in the
> driver:
> http://marc.info/?l=linux-scsi&m=120137366708017
> http://thread.gmane.org/gmane.linux.kernel.firewire.devel/11424

That recommendation was based on the assumption that quadlet alignment
would be actually needed.

> It is probably not going to happen that somebody decreases the SCSI
> default.  But perhaps we should still keep this explicit...?

Keeping this would be nothing more than paranoia.  But this a perfectly
fine sentiment for a maintainer dealing with real-world firmware, so
you might use the patch below instead.  (I'm not budging from my
interpretation of SBP-2.  :-)

--8<---------------------------------------------------------------->8--
firewire: sbp2: document the absence of alignment requirements

The SBP-2/3 specifications do not require any alignment of data
buffers; only their own data structures need to be quadlet-aligned.

Fix the comments to reflect this, but leave the actual alignment at
32 bits to avoid theoretical problems with target implementations
that might handle this incorrectly.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/sbp2.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -207,9 +207,8 @@ static const struct device *lu_dev(const struct sbp2_logical_unit *lu)
 #define SBP2_MAX_CDB_SIZE		16

 /*
- * The default maximum s/g segment size of a FireWire controller is
- * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
- * be quadlet-aligned, we set the length limit to 0xffff & ~3.
+ * The maximum SBP-2 data buffer size is 0xffff.  We quadlet-align this
+ * for compatibility with earlier versions of this driver.
  */
 #define SBP2_MAX_SEG_SIZE		0xfffc

@@ -1530,7 +1529,10 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)

 	sdev->allow_restart = 1;

-	/* SBP-2 requires quadlet alignment of the data buffers. */
+	/*
+	 * SBP-2 does not require any alignment, but we set it anyway
+	 * for compatibility with earlier versions of this driver.
+	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, 4 - 1);

 	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
