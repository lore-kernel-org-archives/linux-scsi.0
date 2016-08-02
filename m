From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] bfa: fix W=1 build warnings
Date: Tue,  2 Aug 2016 17:22:45 +0200
Message-ID: <20160802152250.1964074-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:59716 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021AbcHBPXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 11:23:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>, Arnd Bergmann <arnd@arndb.de>

I tried to build an allmodconfig kernel with W=1, and the bfa
driver stuck out for having the most warnings in one file, so
I decided to send patches for all of these and make the driver
build cleanly with the extra warnings enabled.

As most warnings were for functions that lacked a 'static',
I marked them that way, and also used a script to look for
further functions that have a declaration but can also be static.

Overall, this saves around 10% of the size of the driver
module:

   text	   data	    bss	    dec	    hex	filename
 232027	   3012	    976	 236015	  399ef	drivers/scsi/bfa/bfa-before.o
 221851	   2996	    908	 225755	  371db	drivers/scsi/bfa/bfa-after.o

	Arnd

Arnd Bergmann (5):
  bfa: mark symbols static where possible
  bfa: remove unused variables
  bfa: rename some global variables
  bfa: remove unused functions from fbbuild.c
  bfa: remove more unused functions

 drivers/scsi/bfa/bfa.h           |  17 --
 drivers/scsi/bfa/bfa_core.c      |  54 +---
 drivers/scsi/bfa/bfa_fcbuild.c   | 609 +--------------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h   |  90 ------
 drivers/scsi/bfa/bfa_fcpim.c     |  81 +++---
 drivers/scsi/bfa/bfa_fcpim.h     |  26 --
 drivers/scsi/bfa/bfa_fcs.c       |  31 +-
 drivers/scsi/bfa/bfa_fcs.h       |  54 ----
 drivers/scsi/bfa/bfa_fcs_lport.c | 211 +++-----------
 drivers/scsi/bfa/bfa_fcs_rport.c |  48 +--
 drivers/scsi/bfa/bfa_ioc.c       |  83 ++----
 drivers/scsi/bfa/bfa_ioc.h       |  25 --
 drivers/scsi/bfa/bfa_ioc_cb.c    |   3 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  12 +-
 drivers/scsi/bfa/bfa_plog.h      |   8 -
 drivers/scsi/bfa/bfa_port.c      |   6 +-
 drivers/scsi/bfa/bfa_port.h      |   1 -
 drivers/scsi/bfa/bfa_svc.c       |  95 ++----
 drivers/scsi/bfa/bfa_svc.h       |  17 --
 drivers/scsi/bfa/bfad.c          | 128 ++++----
 drivers/scsi/bfa/bfad_attr.c     |   9 +-
 drivers/scsi/bfa/bfad_bsg.c      | 224 +++++++-------
 drivers/scsi/bfa/bfad_drv.h      |  49 +---
 drivers/scsi/bfa/bfad_im.c       |  29 +-
 drivers/scsi/bfa/bfad_im.h       |  10 -
 25 files changed, 395 insertions(+), 1525 deletions(-)

-- 
2.9.0

