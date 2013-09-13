From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm mpath: do not fail path on -ENOSPC
Date: Fri, 13 Sep 2013 14:54:30 +0900
Message-ID: <5232A896.80803@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Since ENOSPC is a target-side error, dm-mpath should just pass the error
information to upper layer instead of retrying itself with path failover.
Otherwise it will end up failing all paths down while path checkers find
all paths ok.

ENOSPC can now be returned from SCSI device after commit a9d6ceb8
("[SCSI] return ENOSPC on thin provisioning failure").

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 1 +
 1 file changed, 1 insertion(+)

The patch is not actually tested as I don't have such a storage at my hand.
Hannes, please let me know if you didn't change noretry_error() intentionally.

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b759a12..075747e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1268,6 +1268,7 @@ static int noretry_error(int error)
 	case -EREMOTEIO:
 	case -EILSEQ:
 	case -ENODATA:
+	case -ENOSPC:
 		return 1;
 	}
 
