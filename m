From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Mon, 25 Jul 2011 23:51:11 -0700
Message-ID: <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110725163739.5c19b04d.akpm@linux-foundation.org>
	 <20110725165057.9701f16b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110725165057.9701f16b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-07-25 at 16:50 -0700, Andrew Morton wrote:
> On Mon, 25 Jul 2011 16:37:39 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 23 Jul 2011 16:16:15 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > Please go ahead and pull from:
> > > 
> > >   master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge
> > 
> > i386 allyesconfig:
> > 
> > ERROR: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!
> > 
> > somewhere in drivers/target/target_core_transport.c:transport_allocate_data_tasks().
> 
> Probably the best place to fix this is within DIV_ROUND_UP(): make it
> handle 64-bits on 32-bit.
> 
> This will have the pleasing side-effect of breaking
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c, which felt a need to duplicate the
> existing DIV_ROUND_UP() implementation.
> 

Thanks for the input everyone.  :)

How about the following to add a new DIV_ROUND_UP_ULL macro, and enable
it's usage within the offending transport_allocate_data_tasks() change
causing the regression in question for target_core_mod..?

Is there anything else that should be done to avoid unnecessary 64-bit
divide instruction slowness for generic 32-bit arch operation here..?

Thank you,

--nab

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a244c90..8032e1e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4054,17 +4054,16 @@ static int transport_allocate_data_tasks(
        struct se_task *task;
        struct se_device *dev = cmd->se_dev;
        unsigned long flags;
-       sector_t sectors;
        int task_count, i, ret;
-       sector_t dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
+       sector_t sectors, dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
        u32 sector_size = dev->se_sub_dev->se_dev_attrib.block_size;
        struct scatterlist *sg;
        struct scatterlist *cmd_sg;
 
        WARN_ON(cmd->data_length % sector_size);
        sectors = DIV_ROUND_UP(cmd->data_length, sector_size);
-       task_count = DIV_ROUND_UP(sectors, dev_max_sectors);
-
+       task_count = DIV_ROUND_UP_ULL(sectors, dev_max_sectors);
+       
        cmd_sg = sgl;
        for (i = 0; i < task_count; i++) {
                unsigned int task_size;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 953352a..d66cba7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -56,6 +56,17 @@
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#define DIV_ROUND_UP_ULL(n,d) (                                \
+{                                                      \
+       unsigned long long _tmp = n, _off;              \
+       int _res;                                       \
+       /* Round up using asm/div64.h:do_div */         \
+       _off = do_div(_tmp, d);                         \
+       if (_off != 0)                                  \
+               _tmp++;                                 \
+       _res = _tmp;                                    \
+}                                                      \
+)
 
 /* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
 #define roundup(x, y) (                                        \
