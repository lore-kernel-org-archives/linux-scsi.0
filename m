From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 00/34] cxlflash: Miscellaneous bug fixes and corrections
Date: Fri, 2 Oct 2015 12:07:32 -0500
Message-ID: <B0CDB2CE-13C0-4CFA-84C1-B90CB8288294@linux.vnet.ibm.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:45389 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbJBRHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 13:07:40 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 2 Oct 2015 13:07:39 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 4F06EC9005A
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2015 12:55:48 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t92H7aIZ62390432
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2015 17:07:36 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t92H7XLH000872
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2015 13:07:35 -0400
In-Reply-To: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi James,

This series has been fairly well vetted. With cxlflash being a new driver the majority
of these patches fix critical bugs. Is there anything else you're looking for in order to
get this set pulled into 4.3-rc?


-matt

> On Oct 1, 2015, at 10:52 AM, Matthew R. Ochs <mrochs@linux.vnet.ibm.com> wrote:
> 
> This patch set contains various fixes and corrections for issues that
> were found during test and code review. The series is based upon the
> code upstreamed in 4.3 and is intended for the rc phase. The entire
> set is bisectable. Please reference the changelog below for details
> on what has been altered from previous versions of this patch set.
> 
> v5 Changes:
> - Incorporate comments from Daniel Axtens
> - Incorporate comments from Andrew Donnellan 
> - Added additional clarifications to several commit messages
> - Specified some return codes as failures in "Fix function prolog..."
> - Made port online failure noisier in "Remove dual port online..."
> - Added patch to properly cleanup when encountering an unsupported AFU
> - Added patch to escalate a link reset on login timeout
> 
> v4 Changes:
> - Incorporate comments from Brian King
> - Removed unnecessary check_state() parameter from "Fix to avoid CXL..."
> - Added patch to fix potential deadlock on EEH
> - Removed patch to avoid state change collision
> - Changed fops initialization location in "Fix to avoid corrupting..."
> 
> v3 Changes:
> - Rebased the series on top of patch by Dan Carpenter ("a couple off...")
> - Incorporate comments from David Laight
> - Incorporate comments from Tomas Henzl
> - Incorporate comments from Brian King
> - Removed patch to stop interrupt processing on remove
> - Removed double scsi_device_put() from "Fix potential oops"
> - Fixed usage of scnprintf() in "Refine host/device attributes"
> - Removed unnecessary parenthesis from "Fix read capacity timeout"
> - Added patch to use correct operator for doubling delay
> - Changed location of cancel_work_sync() in "Fix to prevent workq..."
> - Removed local mutex from cxlflash_afu_sync() in "Fix to avoid state..."
> - Added patch to correctly identify a failed function in a trace
> - Added patch to fix a fops corruption bug
> 
> v2 Changes:
> - Incorporate comments from Ian Munsie
> - Rework commit messages to be more descriptive
> - Add state change serialization patch
> 
> Manoj Kumar (5):
>  cxlflash: Fix to avoid invalid port_sel value
>  cxlflash: Replace magic numbers with literals
>  cxlflash: Fix read capacity timeout
>  cxlflash: Fix to double the delay each time
>  cxlflash: Fix to escalate to LINK_RESET on login timeout
> 
> Matthew R. Ochs (29):
>  cxlflash: Fix potential oops following LUN removal
>  cxlflash: Fix data corruption when vLUN used over multiple cards
>  cxlflash: Fix to avoid sizeof(bool)
>  cxlflash: Fix context encode mask width
>  cxlflash: Fix to avoid CXL services during EEH
>  cxlflash: Correct naming of limbo state and waitq
>  cxlflash: Make functions static
>  cxlflash: Refine host/device attributes
>  cxlflash: Fix to avoid spamming the kernel log
>  cxlflash: Fix to avoid stall while waiting on TMF
>  cxlflash: Fix location of setting resid
>  cxlflash: Fix host link up event handling
>  cxlflash: Fix async interrupt bypass logic
>  cxlflash: Remove dual port online dependency
>  cxlflash: Fix AFU version access/storage and add check
>  cxlflash: Correct usage of scsi_host_put()
>  cxlflash: Fix to prevent workq from accessing freed memory
>  cxlflash: Correct behavior in device reset handler following EEH
>  cxlflash: Remove unnecessary scsi_block_requests
>  cxlflash: Fix function prolog parameters and return codes
>  cxlflash: Fix MMIO and endianness errors
>  cxlflash: Fix to prevent EEH recovery failure
>  cxlflash: Correct spelling, grammar, and alignment mistakes
>  cxlflash: Fix to prevent stale AFU RRQ
>  MAINTAINERS: Add cxlflash driver
>  cxlflash: Fix to avoid corrupting adapter fops
>  cxlflash: Correct trace string
>  cxlflash: Fix to avoid potential deadlock on EEH
>  cxlflash: Fix to avoid leaving dangling interrupt resources
> 
> MAINTAINERS                       |    9 +
> drivers/scsi/cxlflash/common.h    |   30 +-
> drivers/scsi/cxlflash/lunmgt.c    |    9 +-
> drivers/scsi/cxlflash/main.c      | 1549 ++++++++++++++++++++-----------------
> drivers/scsi/cxlflash/main.h      |    1 +
> drivers/scsi/cxlflash/sislite.h   |    8 +-
> drivers/scsi/cxlflash/superpipe.c |  204 +++--
> drivers/scsi/cxlflash/superpipe.h |   13 +-
> drivers/scsi/cxlflash/vlun.c      |   68 +-
> 9 files changed, 1055 insertions(+), 836 deletions(-)
> 
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

