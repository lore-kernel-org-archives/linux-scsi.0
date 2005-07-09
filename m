From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: [KJ] [PATCH 12/14] scsi/osst: use msleep() instead of
	schedule_timeout()
Date: Fri, 8 Jul 2005 17:15:37 -0700
Message-ID: <20050709001537.GR2596@us.ibm.com>
References: <20050709000324.GD2596@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============011469789001716135=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20050709000324.GD2596@us.ibm.com>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: osst@riede.org
Cc: Kernel-Janitors <kernel-janitors@lists.osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============011469789001716135==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Nishanth Aravamudan <nacc@us.ibm.com>

Description: Replace schedule_timeout() with msleep() to guarantee the
task delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 osst.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff -urp 2.6.13-rc2-kj/drivers/scsi/osst.c 2.6.13-rc2-kj-dev/drivers/scsi/osst.c
--- 2.6.13-rc2-kj/drivers/scsi/osst.c	2005-07-06 07:57:19.000000000 -0700
+++ 2.6.13-rc2-kj-dev/drivers/scsi/osst.c	2005-07-06 19:21:03.000000000 -0700
@@ -862,8 +862,7 @@ static int osst_recover_wait_frame(struc
 				retval = osst_write_error_recovery(STp, aSRpnt, 0);
 				break;
 			}
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout (HZ / OSST_POLL_PER_SEC);
+			msleep(1000 / OSST_POLL_PER_SEC);
 
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			memset(cmd, 0, MAX_COMMAND_SIZE);
@@ -1558,8 +1557,7 @@ static int osst_reposition_and_retry(str
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			msleep(100);
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1620,8 +1618,7 @@ static int osst_reposition_and_retry(str
 			debugging = 0;
 		}
 #endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);
+		msleep(100);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG

--===============011469789001716135==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============011469789001716135==--
