From: Vladislav Bolkhovitine <vlls@hotbox.ru>
Subject: [PATCH] SCSI host ID assigment overoptimization removal in 2.4.18
Date: Thu, 18 Jul 2002 15:22:42 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020718152242.B4026@j4.msk.systemsix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by j4.msk.systemsix.com (8.11.2/8.11.2) id g6IBMgu04123
	for linux-scsi@vger.kernel.org; Thu, 18 Jul 2002 15:22:42 +0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is an overoptimization in SCSI host ID assigment algorithm in 2.4.18 
and possibly others, which lead to appearance of SCSI hosts with the same IDs. 

Simple scenario:
1. Add one adapter, host_id=0
2. Remove it
3. Add another adapter, its host_id=0
4. Add the adapter 1 again, it reuses its original scsi_host_no_list entry
	and gets host_id=0 as well. Oops.

When the adapter was being unregistered on step 2, max_scsi_hosts gets 
decremented to 0. During registration of the new host, it received 
host_id=max_scsi_hosts. On the step 4, the old entry in scsi_host_no_list 
was found and reused, thus we have two hosts with the same host_id 0.

So, it is impossible to use simultaneously scsi_host_no_list and host IDs 
reusing (i.e. max_scsi_hosts decrementing). I chose to remove the last one. 
Here is the patch against 2.4.18.

I was not able to find who is the maintainer of SCSI subsistem at the moment. 
Who is doing so, please consider the idea of this patch to include in the 
mainstream kernel.

Vlad

diff -urdN linux-2.4.18.orig/drivers/scsi/hosts.c linux-2.4.18.host_fix/drivers/scsi/hosts.c
--- linux-2.4.18.orig/drivers/scsi/hosts.c      Mon Feb 25 22:38:04 2002
+++ linux-2.4.18.host_fix/drivers/scsi/hosts.c  Wed Jul 17 17:08:47 2002
@@ -107,6 +107,17 @@
     if (shn) shn->host_registered = 0;
     /* else {} : This should not happen, we should panic here... */

+    /*
+     * With this algorithm together with scsi_host_no_list entry reusage
+     * from scsi_register() it is possible really easy to get two
+     * hosts with the same host_id. Simple scenario:
+     *  - add one adapter, host_id=0
+     *  - remove it
+     *  - add another adapter, its host_id=0
+     *  - add the adapter 1 again, it reuses its scsi_host_no_list entry
+     *     and gets host_id=0 as well. Oops.
+     */
+#if 0
     /* If we are removing the last host registered, it is safe to reuse
      * its host number (this avoids "holes" at boot time) (DB)
      * It is also safe to reuse those of numbers directly below which have
@@ -121,6 +132,7 @@
                break;
        }
     }
+#endif
