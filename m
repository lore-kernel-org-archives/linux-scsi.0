From: Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH 0/2] scsi: ufs: add real time/inline crypto support to UFS HCD
Date: Tue, 11 Dec 2018 09:49:10 +0000
Message-ID: <20181211094910.GA28288@lvlogina.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mchehab+samsung@kernel.org, gregkh@linuxfoundation.org, davem@davemloft.net, akpm@linux-foundation.org, nicolas.ferre@microchip.com, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org, jbacik@fb.com, michaelcallahan@fb.com, snitzer@redhat.com, osandov@fb.com, keith.busch@intel.com, ming.lei@redhat.com, shli@fb.com, dennisszhou@gmail.com
Cc: adouglas@cadence.com, jank@cadence.com, rafalc@cadence.com, pthombar@cadence.com
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch series add inline / real time encryption support to UFS
host controller driver. It include following patches
0001-block-add-bi_crypto_ctx-variable-in-struct-bio.patch
Add 'void *bi_crypto_ctx' variable in 'struct bio' to embded crypto
configuration information, which is used by low level driver when
bio is processed. This field can also be useful to support inline
encryption in other protocols also.
0002-scsi-ufs-add-inline-crypto-support-to-UFS-HCD.patch
This patch depends on patch [0/1] in this series.
Patch include changes regarding UFS controller
crypto support. Inline crypto support is provided by using new
device mapper called 'crypt-ufs'. Inline encryption can be enabled on
UFS device by creating mapping using tool like dmsetup and mapper
'crypt-ufs'. Patch is tested on Cadence UFS controller which currently
support AES-ECB inline encryption.
As part of [PATCH 2/2], MAINTAINERS file is modified to add name as
supporter of ufshcd crypto files.

Regards,
Parshuram Thombare

Parshuram Thombare (2):
  block: add bi_crypto_ctx variable in struct bio
  scsi: ufs: add inline crypto support to UFS HCD

 MAINTAINERS                      |    7 +
 block/Kconfig                    |    5 +
 drivers/scsi/ufs/Kconfig         |   12 +
 drivers/scsi/ufs/Makefile        |    1 +
 drivers/scsi/ufs/ufshcd-crypto.c |  453 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  102 +++++++++
 drivers/scsi/ufs/ufshcd.c        |   27 +++-
 drivers/scsi/ufs/ufshcd.h        |    6 +
 drivers/scsi/ufs/ufshci.h        |    1 +
 include/linux/blk_types.h        |    4 +
 10 files changed, 617 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h
