From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/5] scsi: Return ENODATA on medium error
Date: Mon, 01 Jul 2013 18:12:51 +0900
Message-ID: <51D14813.6070803@ce.jp.nec.com>
References: <1372666331-66996-1-git-send-email-hare@suse.de>
	<1372666331-66996-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1372666331-66996-5-git-send-email-hare@suse.de>
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
Cc: Theodore Tso <tytso@mit.edu>, linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, James Bottomley <jbottomley@parallels.com>, device-mapper development <dm-devel@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/01/13 17:12, Hannes Reinecke wrote:
> When a medium error is detected the SCSI stack should return
> ENODATA to the upper layers.

Hi Hannes,

since you change the error code from -EREMOTEIO to -ENODATA/-ENOSPC,
upper layers that checks -EREMOTEIO have to be updated as well.

Something like below for dm-multipath.
It seems btrfs checking -EREMOTEIO, too.

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bdf26f5..15bf881 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1261,6 +1261,21 @@ static void activate_path(struct work_struct *work)
 				pg_init_done, pgpath);
 }
 
+static int maybe_path_failure(int error)
+{
+	switch(error) {
+	case -EOPNOTSUPP:
+	case -EREMOTEIO:
+	case -EILSEQ:
+	case -ENOSPC:
+	case -ENODATA:
+		return 0;
+	}
+
+	/* Anything else could be a path failure */
+	return 1;
+}
+
 /*
  * end_io handling
  */
@@ -1284,7 +1299,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
+	if (!maybe_path_failure(error))
 		return error;
 
 	if (mpio->pgpath)
