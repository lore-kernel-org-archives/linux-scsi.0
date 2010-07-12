From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16010] Mptlinux update problem but need
Date: Mon, 12 Jul 2010 15:30:34 GMT
Message-ID: <201007121530.o6CFUYVh017691@demeter.kernel.org>
References: <bug-16010-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44467 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0GLPag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2010 11:30:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6CFUYCu017693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jul 2010 15:30:34 GMT
In-Reply-To: <bug-16010-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16010


Ken Stailey <kstailey@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kstailey@yahoo.com




--- Comment #3 from Ken Stailey <kstailey@yahoo.com>  2010-07-12 15:30:29 ---
@dujun - Thanks

It's actually a double underscore: __data_len

diff against 4.22.00.00-2

--- mptsas.c.DIST    2009-11-12 05:17:05.000000000 -0500
+++ mptsas.c    2010-07-12 11:14:41.480493720 -0400
@@ -2754,8 +2754,8 @@
     /* do we need to support multiple segments? */
     if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
         printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-            ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
-            rsp->bio->bi_vcnt, rsp->data_len);
+            ioc->name, __func__, req->bio->bi_vcnt, req->__data_len,
+            rsp->bio->bi_vcnt, rsp->__data_len);
         return -EINVAL;
     }

@@ -2772,7 +2772,7 @@
     smpreq = (SmpPassthroughRequest_t *)mf;
     memset(smpreq, 0, sizeof(*smpreq));

-    smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);
+    smpreq->RequestDataLength = cpu_to_le16(req->__data_len - 4);
     smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;

     if (rphy)
@@ -2802,10 +2802,10 @@

     flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;

-    flagsLength |= (req->data_len - 4);
+    flagsLength |= (req->__data_len - 4);

     dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
-                      req->data_len, PCI_DMA_BIDIRECTIONAL);
+                      req->__data_len, PCI_DMA_BIDIRECTIONAL);
     if (!dma_addr_out)
         goto put_mf;
     ioc->add_sge(psge, flagsLength, dma_addr_out);
@@ -2818,9 +2818,9 @@
         MPI_SGE_FLAGS_END_OF_BUFFER;

     flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
-    flagsLength |= rsp->data_len + 4;
+    flagsLength |= rsp->__data_len + 4;
     dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
-                      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
+                      rsp->__data_len, PCI_DMA_BIDIRECTIONAL);
     if (!dma_addr_in)
         goto out_unmap;

@@ -2851,8 +2851,8 @@
         smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
         memcpy(req->sense, smprep, sizeof(*smprep));
         req->sense_len = sizeof(*smprep);
-        req->data_len = 0;
-        rsp->data_len -= smprep->ResponseDataLength;
+        req->__data_len = 0;
+        rsp->__data_len -= smprep->ResponseDataLength;
     } else {
         printk(MYIOC_s_ERR_FMT
             "%s: smp passthru reply failed to be returned\n",
@@ -2861,10 +2861,10 @@
     }
 out_unmap:
     if (dma_addr_out)
-        pci_unmap_single(ioc->pcidev, dma_addr_out, req->data_len,
+        pci_unmap_single(ioc->pcidev, dma_addr_out, req->__data_len,
                  PCI_DMA_BIDIRECTIONAL);
     if (dma_addr_in)
-        pci_unmap_single(ioc->pcidev, dma_addr_in, rsp->data_len,
+        pci_unmap_single(ioc->pcidev, dma_addr_in, rsp->__data_len,
                  PCI_DMA_BIDIRECTIONAL);
 put_mf:
     if (mf)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
