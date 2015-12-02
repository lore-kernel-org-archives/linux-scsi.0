From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scsi:fixes 16/18] warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS
 which has unmet direct dependencies (SCSI_LOWLEVEL && ..)
Date: Wed, 02 Dec 2015 13:36:58 -0800
Message-ID: <1449092218.2203.56.camel@HansenPartnership.com>
References: <201512030535.NePJi7kq%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45138 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbbLBVhA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2015 16:37:00 -0500
In-Reply-To: <201512030535.NePJi7kq%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, kbuild-all@01.org, linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>

On Thu, 2015-12-03 at 05:02 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git fixes
> head:   136dc13bf2988d987682e60558bb9b9873215f29
> commit: b840c3627b6f4f856b333a14a72f8ed86da2f86c [16/18] mpt3sas: Add dummy Kconfig option for backwards compatibility
> config: mips-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout b840c3627b6f4f856b333a14a72f8ed86da2f86c
>         # save the attached .config to linux build tree
>         make.cross ARCH=mips 
> 
> All warnings (new ones prefixed by >>):
> 
> warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS which has unmet direct
> dependencies (SCSI_LOWLEVEL && PCI && SCSI)

That's unfortunate.  The problem is that select and depend don't
interact because Kconfig doesn't have a SAT solver, so depend picks up
dependencies and select does onward selects, but select doesn't pick up
dependencies.  To fix this, we need to add the correct dependencies to
the MPT2SAS option like this.

James

---

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 25dc38f..b736dbc 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -76,6 +76,7 @@ config SCSI_MPT2SAS
 	tristate "Legacy MPT2SAS config option"
 	default n
 	select SCSI_MPT3SAS
+	depends on PCI && SCSI
 	---help---
 	Dummy config option for backwards compatiblity: configure the MPT3SAS
 	driver instead.


