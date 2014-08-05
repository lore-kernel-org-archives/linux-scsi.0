From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Tue, 05 Aug 2014 14:46:38 -0400
Message-ID: <yq161i6epv5.fsf@sermon.lab.mkp.net>
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
	<CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
	<yq1r41bkgdp.fsf@sermon.lab.mkp.net>
	<CAK=zhgp_v_sdt+VLDs1Mxxi8Cg4nZNnzgQ=d228h+Ht2EpdEqw@mail.gmail.com>
	<yq138dpgr6z.fsf@sermon.lab.mkp.net>
	<CAK=zhgoEhW7fT7SV6ZkzgFa_A49W9quzWOgXb=DH3D_CrMAdDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgoEhW7fT7SV6ZkzgFa_A49W9quzWOgXb=DH3D_CrMAdDw@mail.gmail.com>
	(Sreekanth Reddy's message of "Wed, 30 Jul 2014 20:25:14 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

Patch was mangled and I had to apply every single hunk by hand. Please
use git send-email.

+static int dma_mask;
+
+static int
+_base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                int sleep_flag);
+static int
+_base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                int sleep_flag);
+static int
+_base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int timeout,
+                 int sleep_flag);
+static int
+_base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
+    u32 *request, int reply_bytes, u16 *reply, int timeout, int sleep_flag);
+static int
+_base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);

Are you sure you need all these? _base_get_ioc_facts was the only one
that needed to be declared in my original patch.

+    if (ioc->rdpq_array_enable)
+        sz = reply_post_free_sz;
+    else {
+        if (_base_is_controller_msix_enabled(ioc))
+            sz = reply_post_free_sz * ioc->reply_queue_count;
+        else
+            sz = reply_post_free_sz;
+    }

sz = reply_post_free_sz;
if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
   sz *= ioc->reply_queue_count;

+    ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
+        (ioc->reply_queue_count):1,
+        sizeof(struct reply_post_struct), GFP_KERNEL);

You're special casing the !rdpq code path again. Why don't you just make
sure reply_queue_count is always correct?

+    do {
+        ioc->reply_post[i].reply_post_free =
+            pci_pool_alloc(ioc->reply_post_free_dma_pool,
+            GFP_KERNEL,
+            &ioc->reply_post[i].reply_post_free_dma);
+        if (!ioc->reply_post[i].reply_post_free) {
+            printk(MPT2SAS_ERR_FMT
+            "reply_post_free pool: pci_pool_alloc failed\n",
+            ioc->name);
+            goto out;
+        }
+        memset(ioc->reply_post[i].reply_post_free, 0, sz);
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "reply post free pool (0x%p): depth(%d),"
+            "element_size(%d), pool_size(%d kB)\n", ioc->name,
+            ioc->reply_post[i].reply_post_free,
+            ioc->reply_post_queue_depth, 8, sz/1024));
+        dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+            "reply_post_free_dma = (0x%llx)\n", ioc->name,
+            (unsigned long long)
+            ioc->reply_post[i].reply_post_free_dma));
+        total_sz += sz;
+    } while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));

Same thing. I think:

     for (i = 0; i < ioc->reply_queue_count ; i++) {

was much clearer.

If reply_queue_count is ever inconsistent wrt. ioc->rdpq_array_enable
and _base_is_controller_msix_enabled(ioc) then that's an orthogonal
problem that you should address directly instead of working around it
several places in the code.

-- 
Martin K. Petersen	Oracle Linux Engineering
