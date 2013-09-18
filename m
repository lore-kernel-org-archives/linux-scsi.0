From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/4] Fixed a race condition and a rtnl_lock
 deadlock for bnx2fc
Date: Tue, 17 Sep 2013 22:30:54 -0700
Message-ID: <1379482254-4922-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: fcoe-devel <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Robert and all,

My name is Eddie and I'm taking over for Bhanu as the new maintainer
for bnx2fc (I'm also the current maintainer for bnx2i).  Please include
me in all bnx2fc related discussions moving forward.  Thanks!

The following is a set of patches which fixes a race condition and a
rtnl_lock in bnx2fc as described.

The first patch fixes the race condition between bnx2fc's SCSI_CMD timeout
handling and the SCSI layer's task abort handling.  There is a situation
where the corresponding scsi_done for the timed out SCSI_CMD would never
get called.

The second patch fixes a rtnl_lock deadlock in the rmmod bnx2x path where
the fcoemon's write to the ctlr->enabled sysfs control param made the call
to bnx2fc_disable which contented for the rtnl_lock.  In this path of
operation, there is no need to lock the netdev nor the interface
as the ctlr is directly passed from the store_ctlr_enabled routine and
the interface cannot be released until the this sysfs write is finished
anyway.  The __bnx2fc_enable/disable routine can continue to persist
even after the bnx2fc_enable/disable are deprecated.

I've also bumped the version to 2.4.1 in an effort to align the upstream
and the out-of-tree releases of bnx2fc.

Comments are welcome.  Thanks.

Eddie

Eddie Wai (4):
  BNX2FC:  Fixed a SCSI CMD cmpl race condition between ABTS and
    CLEANUP
  BNX2FC: hung task timeout warning observed when rmmod bnx2x with
    active FCoE targets
  BNX2FC: Bump version from 1.0.14 to 2.4.1
  MAINTAINER: Updated maintainer info for bnx2fc

 MAINTAINERS                       |    2 +-
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   62 +++++++++++++++++++++++++++---------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    6 +++
 4 files changed, 54 insertions(+), 18 deletions(-)
