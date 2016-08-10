From: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Subject: RE: [PATCH 0/5] bfa: fix W=1 build warnings
Date: Wed, 10 Aug 2016 05:28:02 +0000
Message-ID: <MWHPR11MB1901695069BD8CDA17D8AF19901D0@MWHPR11MB1901.namprd11.prod.outlook.com>
References: <20160802152250.1964074-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160802152250.1964074-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Baoyou Xie <baoyou.xie@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
    Thanks for the patches. Changes look fine to me, other than a minor change in patch-1 and the build issue due to the removal of bfa_isr_disable()declaration.

Thanks,
Sudarsana

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de] 
Sent: 02 August 2016 20:53
To: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>; Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>; Martin K . Petersen <martin.petersen@oracle.com>; linux-scsi <linux-scsi@vger.kernel.org>; linux-kernel <linux-kernel@vger.kernel.org>; Baoyou Xie <baoyou.xie@linaro.org>; Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] bfa: fix W=1 build warnings

I tried to build an allmodconfig kernel with W=1, and the bfa driver stuck out for having the most warnings in one file, so I decided to send patches for all of these and make the driver build cleanly with the extra warnings enabled.

As most warnings were for functions that lacked a 'static', I marked them that way, and also used a script to look for further functions that have a declaration but can also be static.

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
 drivers/scsi/bfa/bfa_fcs_lport.c | 211 +++-----------  drivers/scsi/bfa/bfa_fcs_rport.c |  48 +--
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
