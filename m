From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: ERROR: "scsi_device_from_queue"
 [drivers/md/dm-multipath.ko] undefined!
Date: Mon, 12 Mar 2018 11:40:16 -0400
Message-ID: <20180312154016.GA29395@redhat.com>
References: <201803110354.yaesL1Mi%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201803110354.yaesL1Mi%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 10 2018 at  2:29pm -0500,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   3266b5bd97eaa72793df0b6e5a106c69ccc166c4
> commit: 8d47e65948ddea4398892946d9e50778a316b397 dm mpath: remove unnecessary NVMe branching in favor of scsi_dh checks
> date:   4 days ago
> config: x86_64-randconfig-x004-201810 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 8d47e65948ddea4398892946d9e50778a316b397
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "scsi_device_from_queue" [drivers/md/dm-multipath.ko] undefined!
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

This error is due to CONFIG_SCSI not being set.

DM commit 8d47e6594 ("dm mpath: remove unnecessary NVMe branching in
favor of scsi_dh checks") updated dm-mpath.c to call
scsi_device_from_queue() to determine if a device is SCSI.

The following patch fixes the buildbot reported case when CONFIG_SCSI
isn't set... but it is unclear if this is the best way forward.  I don't
want to make CONFIG_DM_MULTIPATH depend on CONFIG_SCSI, as such we
either need the following patch or the equivalent in a dm-mpath.c
wrapper.

Thoughts?

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ae177c..d6bcc96 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -333,7 +333,14 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
+#ifdef CONFIG_SCSI
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
+#else
+static inline struct scsi_device *scsi_device_from_queue(struct request_queue *q)
+{
+	return NULL;
+}
+#endif
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
