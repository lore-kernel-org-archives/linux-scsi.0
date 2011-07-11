From: akpm@linux-foundation.org
Subject: [patch for 3.0 1/3] drivers/scsi/pmcraid: reject negative request size
Date: Mon, 11 Jul 2011 14:08:23 -0700
Message-ID: <201107112108.p6BL8NQE003560@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1GKVI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 17:08:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, drosenberg@vsecurity.com, anil_ravindranath@pmc-sierra.com, stable@kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

There's a code path in pmcraid that can be reached via device ioctl that
causes all sorts of ugliness, including heap corruption or triggering the
OOM killer due to consecutive allocation of large numbers of pages.

First, the user can call pmcraid_chr_ioctl(), with a type
PMCRAID_PASSTHROUGH_IOCTL.  This calls through to
pmcraid_ioctl_passthrough().  Next, a pmcraid_passthrough_ioctl_buffer is
copied in, and the request_size variable is set to
buffer->ioarcb.data_transfer_length, which is an arbitrary 32-bit signed
value provided by the user.  If a negative value is provided here, bad
things can happen.  For example, pmcraid_build_passthrough_ioadls() is
called with this request_size, which immediately calls
pmcraid_alloc_sglist() with a negative size.  The resulting math on
allocating a scatter list can result in an overflow in the kzalloc() call
(if num_elem is 0, the sglist will be smaller than expected), or if
num_elem is unexpectedly large the subsequent loop will call alloc_pages()
repeatedly, a high number of pages will be allocated and the OOM killer
might be invoked.

It looks like preventing this value from being negative in
pmcraid_ioctl_passthrough() would be sufficient.  Something like this
might do:

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/pmcraid.c~drivers-scsi-pmcraid-reject-negative-request-size drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~drivers-scsi-pmcraid-reject-negative-request-size
+++ a/drivers/scsi/pmcraid.c
@@ -3871,6 +3871,9 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* If data is being written into the device, copy the data from user
_
