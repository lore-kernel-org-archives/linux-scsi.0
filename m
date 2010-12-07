From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH v2 2/3] dm mpath: propagate target errors
	immediately
Date: Tue,  7 Dec 2010 18:16:41 -0500
Message-ID: <1291763802-8251-3-git-send-email-snitzer@redhat.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, vst@vlnb.net, linux-kernel@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, jack@suse.cz, j-nomura@ce.jp.nec.com, rwheeler@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

DM now has more information about the nature of the underlying storage
failure.  Path failure is avoided if a request failed due to a target
error.  Instead the target error is immediately passed up the stack.

Discard requests that fail due to non-target errors may now be retried.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..071529a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1270,16 +1270,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
-		return error;
-
-	if (clone->cmd_flags & REQ_DISCARD)
-		/*
-		 * Pass all discard request failures up.
-		 * FIXME: only fail_path if the discard failed due to a
-		 * transport problem.  This requires precise understanding
-		 * of the underlying failure (e.g. the SCSI sense).
-		 */
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
 		return error;
 
 	if (mpio->pgpath)
-- 
1.7.2.3
