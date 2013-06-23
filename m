From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/4] introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
Date: Sun, 23 Jun 2013 21:37:37 +0900
Message-ID: <1371991061-19437-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch set introduces sg_pcopy_from_buffer() and sg_pcopy_to_buffer(),
which copy data between a linear buffer and an SG list.

The only difference between sg_pcopy_{from,to}_buffer() and
sg_copy_{from,to}_buffer() is an additional argument that specifies
the number of bytes to skip the SG list before copying.

The main reason for introducing these functions is to fix a problem
in scsi_debug module.  And there is a local function in crypto/talitos
module, which can be replaced by sg_pcopy_to_buffer().

* Changes from v2
- Add Acked-by line
- Rename sg_miter_seek() to sg_miter_skip()
- Remove the restriction on when sg_miter_skip() can be called

* Changes from v1
- Separate the change that factors out sg_miter_get_next_page() from
  the patch "introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()"
- Add function comment for internal function sg_miter_seek()
- Simplify the assignment of sdb->resid in fill_from_dev_buffer() in
  scsi_debug

Akinobu Mita (4):
  lib/scatterlist: factor out sg_miter_get_next_page() from
    sg_miter_next()
  lib/scatterlist: introduce sg_pcopy_from_buffer() and
    sg_pcopy_to_buffer()
  crypto: talitos: use sg_pcopy_to_buffer()
  scsi_debug: fix do_device_access() with wrap around range

 drivers/crypto/talitos.c    |  60 +--------------------
 drivers/scsi/scsi_debug.c   |  48 +++++++++++++----
 include/linux/scatterlist.h |   5 ++
 lib/scatterlist.c           | 127 +++++++++++++++++++++++++++++++++++++-------
 4 files changed, 150 insertions(+), 90 deletions(-)

Cc: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

-- 
1.8.1.4
