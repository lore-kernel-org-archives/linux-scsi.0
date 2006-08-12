From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 4/9] drivers/scsi/gdth_proc.c Removal of old scsi
 code
Date: Sat, 12 Aug 2006 23:02:43 +0200
Message-ID: <44DE41F3.3010604@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422695AbWHLVCM@vger.kernel.org>
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Achim Leubner <achim_leubner@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/gdth_proc.c linux-work/drivers/scsi/gdth_proc.c
--- linux-work-clean/drivers/scsi/gdth_proc.c	2006-08-12 01:51:16.000000000 +0200
+++ linux-work/drivers/scsi/gdth_proc.c	2006-08-12 20:48:42.000000000 +0200
@@ -4,7 +4,6 @@

 #include <linux/completion.h>

-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,
                    int inout)
 {
@@ -21,32 +20,6 @@ int gdth_proc_info(struct Scsi_Host *hos
     else
         return(gdth_get_info(buffer,start,offset,length,host,hanum,busnum));
 }
-#else
-int gdth_proc_info(char *buffer,char **start,off_t offset,int length,int hostno,
-                   int inout)
-{
-    int hanum,busnum,i;
-
-    TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
-            length,(int)offset,inout));
-
-    for (i = 0; i < gdth_ctr_vcount; ++i) {
-        if (gdth_ctr_vtab[i]->host_no == hostno)
-            break;
-    }
-    if (i == gdth_ctr_vcount)
-        return(-EINVAL);
-
-    hanum = NUMDATA(gdth_ctr_vtab[i])->hanum;
-    busnum= NUMDATA(gdth_ctr_vtab[i])->busnum;
-
-    if (inout)
-        return(gdth_set_info(buffer,length,gdth_ctr_vtab[i],hanum,busnum));
-    else
-        return(gdth_get_info(buffer,start,offset,length,
-                             gdth_ctr_vtab[i],hanum,busnum));
-}
-#endif

 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum)
