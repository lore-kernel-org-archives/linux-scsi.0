From: Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: [PATCH] qlogicpti: use request_firmware
Date: Sun, 11 Jan 2009 11:49:40 +0530
Message-ID: <1231654780.3959.22.camel@jaswinder.satnam>
References: <1231600926.5806.131.camel@macbook.infradead.org>
	 <1231603097.3642.25.camel@localhost.localdomain>
	 <1231615150.5806.137.camel@macbook.infradead.org>
	 <1231630239.3642.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbZAKGVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2009 01:21:54 -0500
In-Reply-To: <1231630239.3642.56.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>

On Sat, 2009-01-10 at 17:30 -0600, James Bottomley wrote:
> On Sat, 2009-01-10 at 19:19 +0000, David Woodhouse wrote:
> > On Sat, 2009-01-10 at 09:58 -0600, James Bottomley wrote:
> > > I'm assuming this fixes the open firmware conversion bug?
> > 
> > Which bug was that?
> 
> This one:
> 
> Subject: 	linux-next: scsi tree build failure
> Date: 	Wed, 31 Dec 2008 03:16:39 +1100 (Tue, 10:16 CST)
> 
> 
> Hi James,
> 
> Today's linux-next build (sparc defconfig) failed like this:
> 
> drivers/scsi/qlogicpti.c: In function 'qlogicpti_load_firmware':
> drivers/scsi/qlogicpti.c:480: error: 'struct qlogicpti' has no member
> named 'sdev'
> 
> An interaction between commit 68175399c8b5ee90960e78c1bb8e3353e71fbf33
> ("[SCSI] qlogicpti: use request_firmware") from the scsi tree and commit
> 5dc2536bb8d8adb5fdfbe76cd6fdcdf9de3f40f8 ("qlogicpti: Convert to pure OF
> driver") which is in Linus' tree.
> 
> The version of the firmware commit that has been in the firmware tree
> since Nov 19 has this conflict corrected.
> 
> I have left it for today (as it is getting way to late).  Please fix it
> up for tomorrow.
> 

I am sorry, it was my typo mistake because I was doing manual merge and
I do not have toolchain to check it but linux-next and David patch was
correct. Thats why I am thankful to Stephen to fix typos in qlogicpti.

So I prepared all 3 SCSI firmware patches based on latest scsi-misc-2.6 . Please pull it.

The following changes since commit 8efdbd01b6b99c4470c7dd2c40b78d242abbd23a:
  Martin K. Petersen (1):
        [SCSI] scsi_debug: DIF/DIX support

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/scsi-misc-2.6.git master

Jaswinder Singh Rajput (3):
      qla1280: use request_firmware
      advansys: use request_firmware
      qlogicpti: use request_firmware

 drivers/scsi/advansys.c            | 1737 ++---------------------------
 drivers/scsi/ql1040_fw.h           | 2130 ------------------------------------
 drivers/scsi/ql12160_fw.h          | 1811 ------------------------------
 drivers/scsi/ql1280_fw.h           | 2048 ----------------------------------
 drivers/scsi/qla1280.c             |  121 ++-
 drivers/scsi/qla1280.h             |    6 +
 drivers/scsi/qlogicpti.c           |   65 +-
 drivers/scsi/qlogicpti_asm.c       | 1160 --------------------
 firmware/Makefile                  |    5 +
 firmware/WHENCE                    |   37 +
 firmware/advansys/3550.bin.ihex    |  317 ++++++
 firmware/advansys/38C0800.bin.ihex |  336 ++++++
 firmware/advansys/38C1600.bin.ihex |  398 +++++++
 firmware/advansys/mcode.bin.ihex   |  147 +++
 firmware/qlogic/1040.bin.ihex      | 2111 +++++++++++++++++++++++++++++++++++
 firmware/qlogic/12160.bin.ihex     | 1771 ++++++++++++++++++++++++++++++
 firmware/qlogic/1280.bin.ihex      | 2008 +++++++++++++++++++++++++++++++++
 firmware/qlogic/isp1000.bin.ihex   | 1158 ++++++++++++++++++++
 18 files changed, 8524 insertions(+), 8842 deletions(-)
 delete mode 100644 drivers/scsi/ql1040_fw.h
 delete mode 100644 drivers/scsi/ql12160_fw.h
 delete mode 100644 drivers/scsi/ql1280_fw.h
 delete mode 100644 drivers/scsi/qlogicpti_asm.c
 create mode 100644 firmware/advansys/3550.bin.ihex
 create mode 100644 firmware/advansys/38C0800.bin.ihex
 create mode 100644 firmware/advansys/38C1600.bin.ihex
 create mode 100644 firmware/advansys/mcode.bin.ihex
 create mode 100644 firmware/qlogic/1040.bin.ihex
 create mode 100644 firmware/qlogic/12160.bin.ihex
 create mode 100644 firmware/qlogic/1280.bin.ihex
 create mode 100644 firmware/qlogic/isp1000.bin.ihex

Thanks
--
JSR

