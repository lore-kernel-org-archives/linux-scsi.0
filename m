From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: [PATCH] 2.4.23-pre8: fixing deferred SCSI adapter registration (resubmitted)
Date: Sat, 25 Oct 2003 15:27:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF5A4520B2.8F9E19FE-ONC1256DCA.0048E6B8-C1256DCA.004A503E@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-4.de.ibm.com ([194.196.100.237]:65427 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S262198AbTJYN1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2003 09:27:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com
Cc: linux-scsi@vger.kernel.org

Hi,

I am resubmitting this fix as 2 issues of the original patch haved surfaced
(scsi_host_template needs to be added anyway regardless of the
fact that no scsi_host might have been added in the first instance;
accounting of detected scsi_hosts needs to be done in scsi_register() /
scsi_unregister() in order to avoid miscalculation).
The patch has also missed the 2.4.23-pre7 cutoff, fortunately.
Please consider applying for 2.4.23-pre8.

Cheers,
Martin Peschke



diff -ur linux-2.4.23-pre8-reference/drivers/scsi/hosts.c linux-2.4.23-pre8/drivers/scsi/hosts.c
--- linux-2.4.23-pre8-reference/drivers/scsi/hosts.c  2003-06-13 16:51:36.000000000 +0200
+++ linux-2.4.23-pre8/drivers/scsi/hosts.c      2003-10-25 15:14:31.000000000 +0200
@@ -88,6 +88,24 @@
 scsi_unregister(struct Scsi_Host * sh){
     struct Scsi_Host * shpnt;
     Scsi_Host_Name *shn;
+    char name[10];
+
+    /* kill error handling thread */
+    if (sh->hostt->use_new_eh_code
+        && sh->ehandler != NULL) {
+            DECLARE_MUTEX_LOCKED(sem);
+
+            sh->eh_notify = &sem;
+            send_sig(SIGHUP, sh->ehandler, 1);
+            down(&sem);
+            sh->eh_notify = NULL;
+    }
+
+    /* remove proc entry */
+#ifdef CONFIG_PROC_FS
+    sprintf(name, "%d", sh->host_no);
+    remove_proc_entry(name, sh->hostt->proc_dir);
+#endif

     if(scsi_hostlist == sh)
      scsi_hostlist = sh->next;
@@ -108,6 +126,7 @@
     /* else {} : This should not happen, we should panic here... */

     next_scsi_host--;
+    sh->hostt->present--;

     kfree((char *) sh);
 }
@@ -122,6 +141,7 @@
     Scsi_Host_Name *shn, *shn2;
     int flag_new = 1;
     const char * hname;
+    char *name;
     size_t hname_len;
     retval = (struct Scsi_Host *)kmalloc(sizeof(struct Scsi_Host) + j,
                               (tpnt->unchecked_isa_dma && j ?
@@ -252,6 +272,37 @@
         }
     }

+#ifdef CONFIG_PROC_FS
+    build_proc_dir_entry(retval);
+#endif
+
+    /* Start error handling thread */
+    if (retval->hostt->use_new_eh_code) {
+            DECLARE_MUTEX_LOCKED(sem);
+
+            retval->eh_notify = &sem;
+            kernel_thread((int (*)(void *)) scsi_error_handler,
+                          (void *) retval, 0);
+
+            /*
+             * Now wait for the kernel error thread to initialize itself
+             * as it might be needed when we scan the bus.
+             */
+            down(&sem);
+            retval->eh_notify = NULL;
+    }
+
+    tpnt->present++;
+
+    if (tpnt->info) {
+            name = (char *)tpnt->info(retval);
+    } else {
+            name = (char *)tpnt->name;
+    }
+    printk(KERN_INFO "scsi%d : %s\n",          /* And print a little message */
+                   retval->host_no, name);
+
+
     return retval;
 }

diff -ur linux-2.4.23-pre8-reference/drivers/scsi/hosts.h linux-2.4.23-pre8/drivers/scsi/hosts.h
--- linux-2.4.23-pre8-reference/drivers/scsi/hosts.h  2003-06-13 16:51:36.000000000 +0200
+++ linux-2.4.23-pre8/drivers/scsi/hosts.h      2003-10-25 15:13:39.000000000 +0200
@@ -471,7 +471,10 @@

 extern Scsi_Host_Template * scsi_hosts;

-extern void build_proc_dir_entries(Scsi_Host_Template  *);
+#ifdef CONFIG_PROC_FS
+extern void build_proc_dir(Scsi_Host_Template *);
+extern void build_proc_dir_entry(struct Scsi_Host *);
+#endif

 /*
  *  scsi_init initializes the scsi hosts.
diff -ur linux-2.4.23-pre8-reference/drivers/scsi/scsi.c linux-2.4.23-pre8/drivers/scsi/scsi.c
--- linux-2.4.23-pre8-reference/drivers/scsi/scsi.c   2003-08-25 13:44:42.000000000 +0200
+++ linux-2.4.23-pre8/drivers/scsi/scsi.c 2003-10-25 15:14:31.000000000 +0200
@@ -1868,7 +1868,6 @@
      struct Scsi_Host *shpnt;
      Scsi_Device *SDpnt;
      struct Scsi_Device_Template *sdtpnt;
-     const char *name;
      unsigned long flags;
      int out_of_space = 0;

@@ -1895,10 +1894,17 @@

      if (tpnt->use_new_eh_code) {
            spin_lock_irqsave(&io_request_lock, flags);
-           tpnt->present = tpnt->detect(tpnt);
+           tpnt->detect(tpnt);
            spin_unlock_irqrestore(&io_request_lock, flags);
-     } else
-           tpnt->present = tpnt->detect(tpnt);
+     } else      tpnt->detect(tpnt);
+
+     /* Add the new driver to /proc/scsi (directory only) */
+#ifdef CONFIG_PROC_FS
+     build_proc_dir(tpnt);
+#endif
+
+     tpnt->next = scsi_hosts;      /* Add to the linked list */
+     scsi_hosts = tpnt;

      if (tpnt->present) {
            if (pcount == next_scsi_host) {
@@ -1918,47 +1924,6 @@
                        return 1;
                  }
            }
-           tpnt->next = scsi_hosts;      /* Add to the linked list */
-           scsi_hosts = tpnt;
-
-           /* Add the new driver to /proc/scsi */
-#ifdef CONFIG_PROC_FS
-           build_proc_dir_entries(tpnt);
-#endif
-
-
-           /*
-            * Add the kernel threads for each host adapter that will
-            * handle error correction.
-            */
-           for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
-                 if (shpnt->hostt == tpnt && shpnt->hostt->use_new_eh_code) {
-                       DECLARE_MUTEX_LOCKED(sem);
-
-                       shpnt->eh_notify = &sem;
-                       kernel_thread((int (*)(void *)) scsi_error_handler,
-                                   (void *) shpnt, 0);
-
-                       /*
-                        * Now wait for the kernel error thread to initialize itself
-                        * as it might be needed when we scan the bus.
-                        */
-                       down(&sem);
-                       shpnt->eh_notify = NULL;
-                 }
-           }
-
-           for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
-                 if (shpnt->hostt == tpnt) {
-                       if (tpnt->info) {
-                             name = tpnt->info(shpnt);
-                       } else {
-                             name = tpnt->name;
-                       }
-                       printk(KERN_INFO "scsi%d : %s\n",         /* And print a little message */
-                              shpnt->host_no, name);
-                 }
-           }

            /* The next step is to call scan_scsis here.  This generates the
             * Scsi_Devices entries
@@ -2036,7 +2001,6 @@
      struct Scsi_Device_Template *sdtpnt;
      struct Scsi_Host *sh1;
      struct Scsi_Host *shpnt;
-     char name[10];    /* host_no>=10^9? I don't think so. */

      /* get the big kernel lock, so we don't race with open() */
      lock_kernel();
@@ -2135,22 +2099,6 @@
            }
      }

-     /*
-      * Next, kill the kernel error recovery thread for this host.
-      */
-     for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
-           if (shpnt->hostt == tpnt
-               && shpnt->hostt->use_new_eh_code
-               && shpnt->ehandler != NULL) {
-                 DECLARE_MUTEX_LOCKED(sem);
-
-                 shpnt->eh_notify = &sem;
-                 send_sig(SIGHUP, shpnt->ehandler, 1);
-                 down(&sem);
-                 shpnt->eh_notify = NULL;
-           }
-     }
-
      /* Next we free up the Scsi_Cmnd structures for this host */

      for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
@@ -2178,9 +2126,6 @@
            if (shpnt->hostt != tpnt)
                  continue;
            pcount = next_scsi_host;
-           /* Remove the /proc/scsi directory entry */
-           sprintf(name,"%d",shpnt->host_no);
-           remove_proc_entry(name, tpnt->proc_dir);
            if (tpnt->release)
                  (*tpnt->release) (shpnt);
            else {
@@ -2197,7 +2142,6 @@
            }
            if (pcount == next_scsi_host)
                  scsi_unregister(shpnt);
-           tpnt->present--;
      }

      /*
diff -ur linux-2.4.23-pre8-reference/drivers/scsi/scsi_proc.c linux-2.4.23-pre8/drivers/scsi/scsi_proc.c
--- linux-2.4.23-pre8-reference/drivers/scsi/scsi_proc.c    2003-06-13 16:51:36.000000000 +0200
+++ linux-2.4.23-pre8/drivers/scsi/scsi_proc.c  2003-10-25 15:13:39.000000000 +0200
@@ -120,35 +120,34 @@
      return(ret);
 }

-void build_proc_dir_entries(Scsi_Host_Template * tpnt)
-{
-     struct Scsi_Host *hpnt;
-     char name[10];    /* see scsi_unregister_host() */
+void build_proc_dir_entry(struct Scsi_Host *shpnt) {
+     char name[10]; /* host_no>=10^9? I don't think so. */
+     struct proc_dir_entry *p;
+
+     if(shpnt->hostt->proc_dir) {
+           sprintf(name, "%d", shpnt->host_no);
+           p = create_proc_read_entry(
+                 name,
+                 S_IFREG | S_IRUGO | S_IWUSR,
+                 shpnt->hostt->proc_dir,
+                 proc_scsi_read,
+                 (void *) shpnt
+           );
+           if (!p)
+                 panic("Not enough memory to register SCSI HBA in /proc/scsi !\n");
+           p->write_proc=proc_scsi_write;
+           p->owner = shpnt->hostt->module;
+     }
+}

+void build_proc_dir(Scsi_Host_Template * tpnt)
+{
      tpnt->proc_dir = proc_mkdir(tpnt->proc_name, proc_scsi);
-        if (!tpnt->proc_dir) {
-                printk(KERN_ERR "Unable to proc_mkdir in scsi.c/build_proc_dir_entries");
-                return;
-        }
-     tpnt->proc_dir->owner = tpnt->module;
-
-     hpnt = scsi_hostlist;
-     while (hpnt) {
-           if (tpnt == hpnt->hostt) {
-                 struct proc_dir_entry *p;
-                 sprintf(name,"%d",hpnt->host_no);
-                 p = create_proc_read_entry(name,
-                             S_IFREG | S_IRUGO | S_IWUSR,
-                             tpnt->proc_dir,
-                             proc_scsi_read,
-                             (void *)hpnt);
-                 if (!p)
-                       panic("Not enough memory to register SCSI HBA in /proc/scsi !\n");
-                 p->write_proc=proc_scsi_write;
-                 p->owner = tpnt->module;
-           }
-           hpnt = hpnt->next;
+     if (!tpnt->proc_dir) {
+           printk(KERN_ERR "Unable to proc_mkdir in scsi.c/build_proc_dir_entries");
+           return;
      }
+     tpnt->proc_dir->owner = tpnt->module;
 }

 /*




---------------------- Forwarded by Martin Peschke3/Germany/IBM on
25/10/2003 15:20 ---------------------------

Martin Peschke3
23/10/2003 19:08

To:    marcelo.tosatti@cyclades.com
cc:    linux-scsi@vger.kernel.org
From:  Martin Peschke3/Germany/IBM@IBMDE
Subject:    [PATCH] 2.4.23-pre: fixing deferred SCSI adapter registration


Hi,

The following patch coutesy of Stefan Bader fixes the 2.4 SCSI adapter
registration, which fatally goes wrong when done at a later time
than an HBA driver's registration. This has hampered the addition of
SCSI adapters which become available at any later point in time.

As the then-maintainer of the SCSI mid-layer confirmed, the deferred
registration of SCSI adapters should be possible,
(http://marc.theaimsgroup.com/?l=linux-scsi&m=96283633428905&w=2)
though it later turned out to be flawed by some misplaced chunks of code,
which need to be considered as a bug.

The problem with the current 2.4 code is that a couple of setup things
are only done when an HBA driver is registered while these steps ought
to be exercised each time an adapter is registered, independent of
time and circumstance of the emergence of a new adapter. This includes
the creation of an error recovery thread and a procfs-entry per adapter.

As far as I know, dynamic adapter addition has been mainly a domain of
the zSeries HBA driver (zfcp), but it is also a valid requirement for any
other technology capable of detecting and adding adapters on-the-fly,
like Hotplug PCI.

The original patch was posted some time ago last year and received
positive feedback.
(http://marc.theaimsgroup.com/?l=linux-scsi&m=101559609329580&w=2)
It got probably lost because SCSI maintainance in 2.4 is rather unsettled.

It was also used as base for similar functionality in 2.5
(http://marc.theaimsgroup.com/?l=linux-scsi&m=103117214824710&w=2)

The patch has been proved reliable in SuSE kernels since last year.
I am convinced it should go into the mainline kernel.

I have adopted the patch to 2.4.23-pre7, regression test included.
Please apply.

best regards,
Martin Peschke


---- original patch removed ----

