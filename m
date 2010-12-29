From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/scsi/gdth{_proc.c}.c: Add missing call to gdth_ioctl_free
Date: Wed, 29 Dec 2010 15:57:54 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1012291557270.8559@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add missing call to gdth_ioctl_free before aborting.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buf,ha,len,addr,E;
@@

buf = gdth_ioctl_alloc(ha, len, FALSE, &addr)
... when != false buf != NULL
    when != true buf == NULL
    when != \(E = buf\|buf = E\)
    when != gdth_ioctl_free(ha, len, buf, addr)
*return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This code is badly indented throughout, making the patch look like it is
badly indented.

 drivers/scsi/gdth.c      |    4 +++-
 drivers/scsi/gdth_proc.c |   16 ++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 0572b9b..6527543 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -365,8 +365,10 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     len = 0;
                     begin = pos;
                 }
-                if (pos > offset + length)
+		if (pos > offset + length) {
+		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
                     goto stop_output;
+		}
             }
         }
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
@@ -450,8 +452,10 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     len = 0;
                     begin = pos;
                 }
-                if (pos > offset + length)
+		if (pos > offset + length) {
+		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
                     goto stop_output;
+		}
             } while (drv_no != -1);
              
             if (is_mirr) {
@@ -472,8 +476,10 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                 len = 0;
                 begin = pos;
             }
-            if (pos > offset + length)
+	    if (pos > offset + length) {
+		gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
                 goto stop_output;
+	    }
         }       
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
@@ -542,8 +548,10 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     len = 0;
                     begin = pos;
                 }
-                if (pos > offset + length)
+		if (pos > offset + length) {
+		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
                     goto stop_output;
+		}
             }
         }
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7636570..3242bca 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4273,8 +4273,10 @@ static int ioc_general(void __user *arg, char *cmnd)
     }
 
     rval = __gdth_execute(ha->sdev, &gen.command, cmnd, gen.timeout, &gen.info);
-    if (rval < 0)
+    if (rval < 0) {
+	gdth_ioctl_free(ha, gen.data_len+gen.sense_len, buf, paddr);
         return rval;
+    }
     gen.status = rval;
 
     if (copy_to_user(arg + sizeof(gdth_ioctl_general), buf, 
