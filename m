From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 3/3] 2.5 hosts.c and scsi_host list cleanup
Date: Wed, 11 Sep 2002 08:28:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020911152831.GC1339@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e1.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g8BGQuEG169566
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2002 12:27:00 -0400
Received: from hmsbounty (sig-9-65-1-80.mts.ibm.com [9.65.1.80])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g8BGQr72235740
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2002 10:26:55 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have updated my previous patch on clean ups to the scsi_host lists.
This patch is against 2.5.34.

The full patch is available at:

http://www-124.ibm.com/storageio/gen-io/patch-scsi_host_lists-2.5.34-1.gz

-andmike

The removal of direct reference to the old lists and addition of new
interface functions.

 acorn/scsi/acornscsi.c            |    6 ++----
 acorn/scsi/arxescsi.c             |    8 ++------
 acorn/scsi/cumana_2.c             |    8 ++------
 acorn/scsi/eesox.c                |    8 ++------
 acorn/scsi/powertec.c             |    8 ++------
 block/cciss_scsi.c                |   21 ++-------------------
 scsi/53c700.c                     |    6 ++----
 scsi/aic7xxx/aic7xxx_linux_host.h |    1 -
 scsi/cpqfcTSinit.c                |    4 +---
 scsi/fcal.c                       |    4 +---
 scsi/ips.h                        |    3 ---
 scsi/pcmcia/aha152x_stub.c        |    3 ++-
 scsi/pcmcia/fdomain_stub.c        |    3 ++-
 scsi/pcmcia/nsp_cs.c              |    3 ++-
 scsi/pcmcia/qlogic_stub.c         |    3 ++-
 scsi/sg.c                         |    6 ++++--
 scsi/wd33c93.c                    |    5 +----
 17 files changed, 29 insertions(+), 71 deletions(-)

diff -Nru a/drivers/acorn/scsi/acornscsi.c b/drivers/acorn/scsi/acornscsi.c
--- a/drivers/acorn/scsi/acornscsi.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/acorn/scsi/acornscsi.c	Tue Sep 10 14:57:07 2002
@@ -3005,14 +3005,12 @@
 			int length, int host_no, int inout)
 {
     int pos, begin = 0, devidx;
-    struct Scsi_Host *instance = scsi_hostlist;
+    struct Scsi_Host *instance;
     Scsi_Device *scd;
     AS_Host *host;
     char *p = buffer;
 
-    for (instance = scsi_hostlist;
-	    instance && instance->host_no != host_no;
-		instance = instance->next);
+    instance = scsi_shost_hn_get(host_no);
 
     if (inout == 1 || !instance)
 	return -EINVAL;
diff -Nru a/drivers/acorn/scsi/arxescsi.c b/drivers/acorn/scsi/arxescsi.c
--- a/drivers/acorn/scsi/arxescsi.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/acorn/scsi/arxescsi.c	Tue Sep 10 14:57:07 2002
@@ -384,15 +384,11 @@
 			    int length, int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host = scsi_hostlist;
+	struct Scsi_Host *host;
 	ARXEScsi_Info *info;
 	Scsi_Device *scd;
 
-	while (host) {
-		if (host->host_no == host_no)
-			break;
-		host = host->next;
-	}
+	host = scsi_shost_hn_get(host_no);
 	if (!host)
 		return 0;
 
diff -Nru a/drivers/acorn/scsi/cumana_2.c b/drivers/acorn/scsi/cumana_2.c
--- a/drivers/acorn/scsi/cumana_2.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/acorn/scsi/cumana_2.c	Tue Sep 10 14:57:07 2002
@@ -498,15 +498,11 @@
 			    int length, int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host = scsi_hostlist;
+	struct Scsi_Host *host;
 	CumanaScsi2_Info *info;
 	Scsi_Device *scd;
 
-	while (host) {
-		if (host->host_no == host_no)
-			break;
-		host = host->next;
-	}
+	host = scsi_shost_hn_get(host_no);
 	if (!host)
 		return 0;
 
diff -Nru a/drivers/acorn/scsi/eesox.c b/drivers/acorn/scsi/eesox.c
--- a/drivers/acorn/scsi/eesox.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/acorn/scsi/eesox.c	Tue Sep 10 14:57:07 2002
@@ -499,15 +499,11 @@
 			    int length, int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host = scsi_hostlist;
+	struct Scsi_Host *host;
 	EESOXScsi_Info *info;
 	Scsi_Device *scd;
 
-	while (host) {
-		if (host->host_no == host_no)
-			break;
-		host = host->next;
-	}
+	host = scsi_shost_hn_get(host_no);
 	if (!host)
 		return 0;
 
diff -Nru a/drivers/acorn/scsi/powertec.c b/drivers/acorn/scsi/powertec.c
--- a/drivers/acorn/scsi/powertec.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/acorn/scsi/powertec.c	Tue Sep 10 14:57:07 2002
@@ -404,15 +404,11 @@
 			    int length, int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host = scsi_hostlist;
+	struct Scsi_Host *host;
 	PowerTecScsi_Info *info;
 	Scsi_Device *scd;
 
-	while (host) {
-		if (host->host_no == host_no)
-			break;
-		host = host->next;
-	}
+	host = scsi_shost_hn_get(host_no);
 	if (!host)
 		return 0;
 
diff -Nru a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/block/cciss_scsi.c	Tue Sep 10 14:57:07 2002
@@ -1250,8 +1250,6 @@
 	return length;
 }
 
-/* It's a pity that we need this, but, we do... */
-extern struct Scsi_Host *scsi_hostlist;  /* from ../scsi/hosts.c */
 
 int
 cciss_scsi_proc_info(char *buffer, /* data buffer */
@@ -1268,24 +1266,9 @@
 	ctlr_info_t *ci;
 	int cntl_num;
 
-	/* Lets see if we can find our Scsi_Host... 
-	   this might be kind of "bad", searching scis_hostlist this way
-	   but how else can we find the scsi host?  I think I've seen
-	   this coded both ways, (circular list and null terminated list)
-	   I coded it to work either way, since I wasn't sure.  */
 
-	sh = scsi_hostlist;
-	found=0;
-	do {
-		if (sh == NULL) break;
-		if (sh->host_no == hostnum) {
-			found++;
-			break;
-		}
-		sh = sh->next;
-	} while (sh != scsi_hostlist && sh != NULL);
-
-	if (sh == NULL || found == 0) /* This really shouldn't ever happen. */
+	sh = scsi_shost_hn_get(hostnum);
+	if (sh == NULL) /* This really shouldn't ever happen. */
 		return -EINVAL;
 
 	ci = (ctlr_info_t *) sh->hostdata[0];
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/53c700.c	Tue Sep 10 14:57:07 2002
@@ -1718,13 +1718,11 @@
 {
 	static char buf[4096];	/* 1 page should be sufficient */
 	int len = 0;
-	struct Scsi_Host *host = scsi_hostlist;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 	Scsi_Device *SDp;
 
-	while(host != NULL && host->host_no != host_no)
-		host = host->next;
-
+	host = scsi_shost_hn_get(host_no);
 	if(host == NULL)
 		return 0;
 
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_linux_host.h b/drivers/scsi/aic7xxx/aic7xxx_linux_host.h
--- a/drivers/scsi/aic7xxx/aic7xxx_linux_host.h	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/aic7xxx/aic7xxx_linux_host.h	Tue Sep 10 14:57:07 2002
@@ -63,7 +63,6 @@
  * to do with card config are filled in after the card is detected.
  */
 #define AIC7XXX	{						\
-	next: NULL,						\
 	module: NULL,						\
 	proc_dir: NULL,						\
 	proc_info: ahc_linux_proc_info,				\
diff -Nru a/drivers/scsi/cpqfcTSinit.c b/drivers/scsi/cpqfcTSinit.c
--- a/drivers/scsi/cpqfcTSinit.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/cpqfcTSinit.c	Tue Sep 10 14:57:07 2002
@@ -934,9 +934,7 @@
   char buf[81];
 
   // Search the Scsi host list for our controller
-  for (host=scsi_hostlist; host; host=host->next)
-    if (host->host_no == hostno)
-      break;
+  host = scsi_shost_hn_get(hostno);
 
   if (!host) return -ESRCH;
 
diff -Nru a/drivers/scsi/fcal.c b/drivers/scsi/fcal.c
--- a/drivers/scsi/fcal.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/fcal.c	Tue Sep 10 14:57:07 2002
@@ -210,9 +210,7 @@
 	char *pos = buffer;
 	int i, j;
 
-	for (host=scsi_hostlist; host; host=host->next)
-		if (host->host_no == hostno)
-                      break;
+	host = scsi_shost_hn_get(hostno);
 
 	if (!host) return -ESRCH;
 
diff -Nru a/drivers/scsi/ips.h b/drivers/scsi/ips.h
--- a/drivers/scsi/ips.h	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/ips.h	Tue Sep 10 14:57:07 2002
@@ -425,7 +425,6 @@
     */
 #if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)
  #define IPS {                            \
-    next : NULL,                          \
     module : NULL,                        \
     proc_info : NULL,                     \
     proc_dir : NULL,                      \
@@ -455,7 +454,6 @@
 }
 #elif LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)
  #define IPS {                            \
-    next : NULL,                          \
     module : NULL,                        \
     proc_info : NULL,                     \
     name : NULL,                          \
@@ -484,7 +482,6 @@
 }
 #else
  #define IPS {                            \
-    next : NULL,                          \
     module : NULL,                        \
     proc_info : NULL,                     \
     name : NULL,                          \
diff -Nru a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/pcmcia/aha152x_stub.c	Tue Sep 10 14:57:07 2002
@@ -294,7 +294,8 @@
 
     tail = &link->dev;
     info->ndev = 0;
-    for (host = scsi_hostlist; host; host = host->next)
+    for (host = scsi_shost_get_next(NULL); host;
+	 host = scsi_shost_get_next(host))
 	if (host->hostt == &driver_template)
 	    for (dev = host->host_queue; dev; dev = dev->next) {
 	    u_long arg[2], id;
diff -Nru a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/pcmcia/fdomain_stub.c	Tue Sep 10 14:57:07 2002
@@ -258,7 +258,8 @@
 
     tail = &link->dev;
     info->ndev = 0;
-    for (host = scsi_hostlist; host; host = host->next)
+    for (host = scsi_shost_get_next(NULL); host;
+	 host = scsi_shost_get_next(host))
 	if (host->hostt == &driver_template)
 	    for (dev = host->host_queue; dev; dev = dev->next) {
 	    u_long arg[2], id;
diff -Nru a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/pcmcia/nsp_cs.c	Tue Sep 10 14:57:07 2002
@@ -1520,7 +1520,8 @@
 	DEBUG(0, "GET_SCSI_INFO\n");
 	tail = &link->dev;
 	info->ndev = 0;
-	for (host = scsi_hostlist; host != NULL; host = host->next) {
+	for (host = scsi_shost_get_next(NULL); host;
+	     host = scsi_shost_get_next(host))
 		if (host->hostt == &driver_template) {
 			for (dev = host->host_queue; dev != NULL; dev = dev->next) {
 				u_long arg[2], id;
diff -Nru a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/pcmcia/qlogic_stub.c	Tue Sep 10 14:57:07 2002
@@ -281,7 +281,8 @@
 
     tail = &link->dev;
     info->ndev = 0;
-    for (host = scsi_hostlist; host; host = host->next)
+	for (host = scsi_shost_get_next(NULL); host;
+	     host = scsi_shost_get_next(host))
 	if (host->hostt == &driver_template)
 	    for (dev = host->host_queue; dev; dev = dev->next) {
 	    u_long arg[2], id;
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/sg.c	Tue Sep 10 14:57:07 2002
@@ -3061,7 +3061,8 @@
 	struct Scsi_Host *shp;
 	int k;
 
-	for (k = 0, shp = scsi_hostlist; shp; shp = shp->next, ++k) {
+	for (k = 0, shp = scsi_shost_get_next(NULL); shp;
+	     shp = scsi_shost_get_next(shp), ++k) {
 		for (; k < shp->host_no; ++k)
 			PRINT_PROC("-1\t-1\t-1\t-1\t-1\t-1\n");
 		PRINT_PROC("%u\t%hu\t%hd\t%hu\t%d\t%d\n",
@@ -3105,7 +3106,8 @@
 	char buff[SG_MAX_HOST_STR_LEN];
 	char *cp;
 
-	for (k = 0, shp = scsi_hostlist; shp; shp = shp->next, ++k) {
+	for (k = 0, shp = scsi_shost_get_next(NULL); shp;
+	     shp = scsi_shost_get_next(shp), ++k) {
 		for (; k < shp->host_no; ++k)
 			PRINT_PROC("<no active host>\n");
 		strncpy(buff, shp->hostt->info ? shp->hostt->info(shp) :
diff -Nru a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c	Tue Sep 10 14:57:07 2002
+++ b/drivers/scsi/wd33c93.c	Tue Sep 10 14:57:07 2002
@@ -1871,10 +1871,7 @@
 int x,i;
 static int stop = 0;
 
-   for (instance=scsi_hostlist; instance; instance=instance->next) {
-      if (instance->host_no == hn)
-         break;
-      }
+   instance = scsi_shost_hn_get(hn);
    if (!instance) {
       printk("*** Hmm... Can't find host #%d!\n",hn);
       return (-ESRCH);
