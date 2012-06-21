From: Fengguang Wu <fengguang.wu@intel.com>
Subject: lpfc: problems with -Werror
Date: Thu, 21 Jun 2012 09:30:18 +0800
Message-ID: <20120621013018.GA7244@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab2FUBaV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jun 2012 21:30:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Iannicelli <alex.iannicelli@emulex.com>
Cc: James Smart <james.smart@emulex.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Hi Alex,

In commit d438bd3aef ("Add -Werror compilation flag") you added this:

+ccflags-y += -Werror

Now I run into a number of gcc errors when running randconfig tests.
They smell like false warnings. I don't quite understand why you made
that "-Werror" conditional and only fail on CONFIG_SCSI_LPFC=y.  But
if you prefer to keep that -Werror, I'll send a (perhaps silly) patch
to quiet these error messages.

drivers/scsi/lpfc/lpfc_sli.c:3654:3: error: 'resp_data' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:3637:2: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
arch/x86/include/asm/io.h:63:1: error: 'hc_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:3510:18: error: 'status' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:4068:17: error: 'status' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:3777:23: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:3742:9: error: 'status' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:6694:21: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:6693:18: error: 'word0' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:9718:12: error: 'creg_val' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:9872:2: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:10235:14: error: 'control' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:10176:9: error: 'hc_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:10152:12: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:10447:9: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_sli.c:10551:8: error: 'hc_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_els.c:95:2: error: 'ha_copy' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_els.c:4731:11: error: 'cmd' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_els.c:4731:11: error: 'length' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_init.c:522:9: error: 'status' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_attr.c:1491:12: error: 'creg_val' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_bsg.c:358:12: error: 'creg_val' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_bsg.c:615:12: error: 'creg_val' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/lpfc/lpfc_bsg.c:1385:12: error: 'creg_val' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Thanks,
Fengguang
