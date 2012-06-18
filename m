From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: drivers/scsi/lpfc/lpfc_scsi.c and CONFIG_SCSI_LPFC_DEBUG_FS
Date: Mon, 18 Jun 2012 15:20:23 -0500
Message-ID: <20120618202022.GB5782@burratino>
References: <4FDEE28A.3000005@papp.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2FRUU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 16:20:28 -0400
Content-Disposition: inline
In-Reply-To: <4FDEE28A.3000005@papp.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gabor Z. Papp" <gzp@papp.hu>
Cc: Richard Yao <ryao@gentoo.org>, Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, James Smart <james.smart@emulex.com>, Alex Iannicelli <alex.iannicelli@emulex.com>

Hi,

Gabor Z. Papp wrote:

> Greg,
>
> please consider to add this fix to drivers/scsi/lpfc/lpfc_scsi.c,
> it can't be compiled if CONFIG_SCSI_LPFC_DEBUG_FS didn't set.
>
> --- /usr/src/linux-3.4.3/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-17 20:21:44.000000000 +0200
> +++ lpfc_scsi.c	2012-06-05 16:23:05.000000000 +0200
> @@ -1897,7 +1897,9 @@
>  	dma_addr_t physaddr;
>  	int i = 0, num_bde = 0, status;
>  	int datadir = sc->sc_data_direction;
> +#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>  	uint32_t rc;
> +#endif
[...]

Cc-ing James, James, and Alex to let them know about the regression.
This regression was introduced by

  d438bd3aef8e [SCSI] lpfc 8.3.30: Add -Werror compilation flag

It is worked around in mainline by

  0829a19a6142 [SCSI] lpfc 8.3.31: Fix build warnings when debugfs is not defined

and is still unfixed in 3.4.y.

Unfortunately, that warning fix still leaves the build brittle and
depending on details of the compiler implementation.  A less fragile
fix which should be more acceptable for stable would be the following.
Just my opinion, though...

-- >8 --
Subject: lpfc: disable -Werror

Using -Werror means that whenever a compiler developer gets a bright
idea for a new warning, your build is broken.  Great fun as a linting
tool in a controlled build environment during development; not so much
fun when the person compiling is a non-developer just trying to deploy
the driver using whatever compiler is lying around.

In particular, 3.4.y kernels need this change to avoid
-Werror=unused-variable build failures when compiling without
CONFIG_SCSI_LPFC_DEBUG_FS set.

Reported-by: Richard Yao <ryao@gentoo.org>
Reported-by: Gabor Z. Papp <gzp@papp.hu>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org (>= 3.4)
---
 drivers/scsi/lpfc/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index fe5d396aca73..d40b29d83c75 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -22,8 +22,6 @@
 ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
 ccflags-$(GCOV) += -O0
 
-ccflags-y += -Werror
-
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\
-- 
1.7.11.rc3

