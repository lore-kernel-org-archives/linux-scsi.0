From: Anatoliy Glagolev <glagolig@gmail.com>
Subject: Re: [PATCH] bsg referencing bus driver module
Date: Thu, 19 Apr 2018 15:10:09 -0700
Message-ID: <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
References: <CANFzKepsGq0EHX4GPtC0RZOWqVf2fTJ6uA2WH-SZNsBuwMJ5KA@mail.gmail.com>
 <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com, jthumshirn@suse.de, hare@suse.com, bblock@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Updated: rebased on recent Linux, cc-ed maintainers per instructions
in MAINTAINERS file

>From df939b80d02bf37b21efaaef8ede86cfd39b0cb8 Mon Sep 17 00:00:00 2001
From: Anatoliy Glagolev <aglagolev@purestorage.com>
Date: Thu, 19 Apr 2018 15:06:06 -0600
Subject: [PATCH] bsg referencing parent module

Fixing a bug when bsg layer holds the last reference to device
when the device's module has been unloaded. Upon dropping the
reference the device's release function may touch memory of
the unloaded module.
---
 block/bsg-lib.c                  | 24 ++++++++++++++++++++++--
 block/bsg.c                      | 29 ++++++++++++++++++++++++++---
 drivers/scsi/scsi_transport_fc.c |  8 ++++++--
 include/linux/bsg-lib.h          |  4 ++++
 include/linux/bsg.h              |  5 +++++
 5 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index fc2e5ff..90c28fd 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -309,6 +309,25 @@ struct request_queue *bsg_setup_queue(struct
device *dev, const char *name,
  bsg_job_fn *job_fn, int dd_job_size,
  void (*release)(struct device *))
 {
+ return bsg_setup_queue_ex(dev, name, job_fn, dd_job_size, release,
+ NULL);
+}
+EXPORT_SYMBOL_GPL(bsg_setup_queue);
+
+/**
+ * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
+ * @dev: device to attach bsg device to
+ * @name: device to give bsg device
+ * @job_fn: bsg job handler
+ * @dd_job_size: size of LLD data needed for each job
+ * @release: @dev release function
+ * @dev_module: @dev's module
+ */
+struct request_queue *bsg_setup_queue_ex(struct device *dev, const char *name,
+ bsg_job_fn *job_fn, int dd_job_size,
+ void (*release)(struct device *),
+ struct module *dev_module)
+{
  struct request_queue *q;
  int ret;

@@ -331,7 +350,8 @@ struct request_queue *bsg_setup_queue(struct
device *dev, const char *name,
  blk_queue_softirq_done(q, bsg_softirq_done);
  blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);

- ret = bsg_register_queue(q, dev, name, &bsg_transport_ops, release);
+ ret = bsg_register_queue_ex(q, dev, name, &bsg_transport_ops, release,
+ dev_module);
  if (ret) {
  printk(KERN_ERR "%s: bsg interface failed to "
        "initialize - register queue\n", dev->kobj.name);
@@ -343,4 +363,4 @@ struct request_queue *bsg_setup_queue(struct
device *dev, const char *name,
  blk_cleanup_queue(q);
  return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(bsg_setup_queue);
+EXPORT_SYMBOL_GPL(bsg_setup_queue_ex);
diff --git a/block/bsg.c b/block/bsg.c
index defa06c..6920c5b 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -750,7 +750,8 @@ static struct bsg_device *__bsg_get_device(int
minor, struct request_queue *q)
  return bd;
 }

-static struct bsg_device *bsg_get_device(struct inode *inode, struct
file *file)
+static struct bsg_device *bsg_get_device(struct inode *inode, struct
file *file,
+ struct bsg_class_device **pbcd)
 {
  struct bsg_device *bd;
  struct bsg_class_device *bcd;
@@ -766,6 +767,7 @@ static struct bsg_device *bsg_get_device(struct
inode *inode, struct file *file)

  if (!bcd)
  return ERR_PTR(-ENODEV);
+ *pbcd = bcd;

  bd = __bsg_get_device(iminor(inode), bcd->queue);
  if (bd)
@@ -781,22 +783,34 @@ static struct bsg_device *bsg_get_device(struct
inode *inode, struct file *file)
 static int bsg_open(struct inode *inode, struct file *file)
 {
  struct bsg_device *bd;
+ struct bsg_class_device *bcd;

- bd = bsg_get_device(inode, file);
+ bd = bsg_get_device(inode, file, &bcd);

  if (IS_ERR(bd))
  return PTR_ERR(bd);

  file->private_data = bd;
+ if (bcd->parent_module) {
+ if (!try_module_get(bcd->parent_module)) {
+ bsg_put_device(bd);
+ return -ENODEV;
+ }
+ }
  return 0;
 }

 static int bsg_release(struct inode *inode, struct file *file)
 {
+ int ret;
  struct bsg_device *bd = file->private_data;
+ struct module *parent_module = bd->queue->bsg_dev.parent_module;

  file->private_data = NULL;
- return bsg_put_device(bd);
+ ret = bsg_put_device(bd);
+ if (parent_module)
+ module_put(parent_module);
+ return ret;
 }

 static __poll_t bsg_poll(struct file *file, poll_table *wait)
@@ -922,6 +936,14 @@ int bsg_register_queue(struct request_queue *q,
struct device *parent,
  const char *name, const struct bsg_ops *ops,
  void (*release)(struct device *))
 {
+ return bsg_register_queue_ex(q, parent, name, ops, release, NULL);
+}
+
+int bsg_register_queue_ex(struct request_queue *q, struct device *parent,
+ const char *name, const struct bsg_ops *ops,
+ void (*release)(struct device *),
+ struct module *parent_module)
+{
  struct bsg_class_device *bcd;
  dev_t dev;
  int ret;
@@ -958,6 +980,7 @@ int bsg_register_queue(struct request_queue *q,
struct device *parent,
  bcd->parent = get_device(parent);
  bcd->release = release;
  bcd->ops = ops;
+ bcd->parent_module = parent_module;
  kref_init(&bcd->ref);
  dev = MKDEV(bsg_major, bcd->minor);
  class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index be3be0f..f21f7d2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3772,17 +3772,21 @@ static int fc_bsg_dispatch(struct bsg_job *job)
  struct fc_internal *i = to_fc_internal(shost->transportt);
  struct request_queue *q;
  char bsg_name[20];
+ struct module *shost_module = NULL;

  fc_host->rqst_q = NULL;

  if (!i->f->bsg_request)
  return -ENOTSUPP;

+ if (shost->hostt)
+ shost_module = shost->hostt->module;
+
  snprintf(bsg_name, sizeof(bsg_name),
  "fc_host%d", shost->host_no);

- q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size,
- NULL);
+ q = bsg_setup_queue_ex(dev, bsg_name, fc_bsg_dispatch,
+ i->f->dd_bsg_size, NULL, shost_module);
  if (IS_ERR(q)) {
  dev_err(dev,
  "fc_host%d: bsg interface failed to initialize - setup queue\n",
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 28a7ccc..232c855 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -74,6 +74,10 @@ void bsg_job_done(struct bsg_job *job, int result,
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
  bsg_job_fn *job_fn, int dd_job_size,
  void (*release)(struct device *));
+struct request_queue *bsg_setup_queue_ex(struct device *dev, const char *name,
+ bsg_job_fn *job_fn, int dd_job_size,
+ void (*release)(struct device *),
+ struct module *dev_module);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0c7dd9c..0e7c26c 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -23,11 +23,16 @@ struct bsg_class_device {
  struct kref ref;
  const struct bsg_ops *ops;
  void (*release)(struct device *);
+ struct module *parent_module;
 };

 int bsg_register_queue(struct request_queue *q, struct device *parent,
  const char *name, const struct bsg_ops *ops,
  void (*release)(struct device *));
+int bsg_register_queue_ex(struct request_queue *q, struct device *parent,
+ const char *name, const struct bsg_ops *ops,
+ void (*release)(struct device *),
+ struct module *parent_module);
 int bsg_scsi_register_queue(struct request_queue *q, struct device *parent);
 void bsg_unregister_queue(struct request_queue *q);
 #else
-- 
1.9.1


On Thu, Apr 19, 2018 at 10:07 AM, Anatoliy Glagolev <glagolig@gmail.com> wrote:
> +linux-block
>
> On Tue, Apr 17, 2018 at 1:05 PM, Anatoliy Glagolev <glagolig@gmail.com> wrote:
>> Description: bsg_release may crash while decrementing reference to the
>> parent device with the following stack:
>>
>> [16834.636216,07] Call Trace:
>>                              ...   scsi_proc_hostdir_rm
>> [16834.641944,07]  [<ffffffff8141723f>] scsi_host_dev_release+0x3f/0x130
>> [16834.647740,07]  [<ffffffff813e4f82>] device_release+0x32/0xa0
>> [16834.653423,07]  [<ffffffff812dc6c7>] kobject_cleanup+0x77/0x190
>> [16834.659002,07]  [<ffffffff812dc585>] kobject_put+0x25/0x50
>> [16834.664430,07]  [<ffffffff813e5277>] put_device+0x17/0x20
>> [16834.669740,07]  [<ffffffff812d0334>] bsg_kref_release_function+0x24/0x30
>> [16834.675007,07]  [<ffffffff812d14a6>] bsg_release+0x166/0x1d0
>> [16834.680148,07]  [<ffffffff8119ba2b>] __fput+0xcb/0x1d0
>> [16834.685156,07]  [<ffffffff8119bb6e>] ____fput+0xe/0x10
>> [16834.690017,07]  [<ffffffff81077476>] task_work_run+0x86/0xb0
>> [16834.694781,07]  [<ffffffff81057043>] exit_to_usermode_loop+0x6b/0x9a
>> [16834.699466,07]  [<ffffffff81002875>] syscall_return_slowpath+0x55/0x60
>> [16834.704110,07]  [<ffffffff8172d615>] int_ret_from_sys_call+0x25/0x9f
>>
>> if the parent driver implementing the device has unloaded. To address
>> the problem, taking a reference to the parent driver module.
>>
>> Note: this is a follow-up to earlier discussion "[PATCH] Waiting for
>> scsi_host_template release".
>>
>> ---
>>  block/bsg.c                      | 31 +++++++++++++++++++++++++++----
>>  drivers/scsi/scsi_transport_fc.c |  3 ++-
>>  include/linux/bsg.h              |  5 +++++
>>  3 files changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/bsg.c b/block/bsg.c
>> index b9a5361..0aa7d74 100644
>> --- a/block/bsg.c
>> +++ b/block/bsg.c
>> @@ -798,7 +798,8 @@ found:
>>   return bd;
>>  }
>>
>> -static struct bsg_device *bsg_get_device(struct inode *inode, struct
>> file *file)
>> +static struct bsg_device *bsg_get_device(struct inode *inode, struct
>> file *file,
>> + struct bsg_class_device **pbcd)
>>  {
>>   struct bsg_device *bd;
>>   struct bsg_class_device *bcd;
>> @@ -814,6 +815,7 @@ static struct bsg_device *bsg_get_device(struct
>> inode *inode, struct file *file)
>>
>>   if (!bcd)
>>   return ERR_PTR(-ENODEV);
>> + *pbcd = bcd;
>>
>>   bd = __bsg_get_device(iminor(inode), bcd->queue);
>>   if (bd)
>> @@ -829,22 +831,34 @@ static struct bsg_device *bsg_get_device(struct
>> inode *inode, struct file *file)
>>  static int bsg_open(struct inode *inode, struct file *file)
>>  {
>>   struct bsg_device *bd;
>> + struct bsg_class_device *bcd;
>>
>> - bd = bsg_get_device(inode, file);
>> + bd = bsg_get_device(inode, file, &bcd);
>>
>>   if (IS_ERR(bd))
>>   return PTR_ERR(bd);
>>
>>   file->private_data = bd;
>> + if (bcd->parent_module) {
>> + if (!try_module_get(bcd->parent_module)) {
>> + bsg_put_device(bd);
>> + return -ENODEV;
>> + }
>> + }
>>   return 0;
>>  }
>>
>>  static int bsg_release(struct inode *inode, struct file *file)
>>  {
>> + int ret;
>>   struct bsg_device *bd = file->private_data;
>> + struct module *parent_module = bd->queue->bsg_dev.parent_module;
>>
>>   file->private_data = NULL;
>> - return bsg_put_device(bd);
>> + ret = bsg_put_device(bd);
>> + if (parent_module)
>> + module_put(parent_module);
>> + return ret;
>>  }
>>
>>  static unsigned int bsg_poll(struct file *file, poll_table *wait)
>> @@ -977,6 +991,14 @@ EXPORT_SYMBOL_GPL(bsg_unregister_queue);
>>  int bsg_register_queue(struct request_queue *q, struct device *parent,
>>         const char *name, void (*release)(struct device *))
>>  {
>> + return bsg_register_queue_ex(q, parent, name, release, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(bsg_register_queue);
>> +
>> +int bsg_register_queue_ex(struct request_queue *q, struct device *parent,
>> +          const char *name, void (*release)(struct device *),
>> +          struct module *parent_module)
>> +{
>>   struct bsg_class_device *bcd;
>>   dev_t dev;
>>   int ret;
>> @@ -1012,6 +1034,7 @@ int bsg_register_queue(struct request_queue *q,
>> struct device *parent,
>>   bcd->queue = q;
>>   bcd->parent = get_device(parent);
>>   bcd->release = release;
>> + bcd->parent_module = parent_module;
>>   kref_init(&bcd->ref);
>>   dev = MKDEV(bsg_major, bcd->minor);
>>   class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
>> @@ -1039,7 +1062,7 @@ unlock:
>>   mutex_unlock(&bsg_mutex);
>>   return ret;
>>  }
>> -EXPORT_SYMBOL_GPL(bsg_register_queue);
>> +EXPORT_SYMBOL_GPL(bsg_register_queue_ex);
>>
>>  static struct cdev bsg_cdev;
>>
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
>> index 24eaaf6..c153f80 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -4064,7 +4064,8 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct
>> fc_host_attrs *fc_host)
>>   blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
>>   blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
>>
>> - err = bsg_register_queue(q, dev, bsg_name, NULL);
>> + err = bsg_register_queue_ex(q, dev, bsg_name, NULL,
>> + shost->hostt->module);
>>   if (err) {
>>   printk(KERN_ERR "fc_host%d: bsg interface failed to "
>>   "initialize - register queue\n",
>> diff --git a/include/linux/bsg.h b/include/linux/bsg.h
>> index 7173f6e..fe41e83 100644
>> --- a/include/linux/bsg.h
>> +++ b/include/linux/bsg.h
>> @@ -12,11 +12,16 @@ struct bsg_class_device {
>>   struct request_queue *queue;
>>   struct kref ref;
>>   void (*release)(struct device *);
>> + struct module *parent_module;
>>  };
>>
>>  extern int bsg_register_queue(struct request_queue *q,
>>        struct device *parent, const char *name,
>>        void (*release)(struct device *));
>> +extern int bsg_register_queue_ex(struct request_queue *q,
>> +         struct device *parent, const char *name,
>> +         void (*release)(struct device *),
>> +         struct module *parent_module);
>>  extern void bsg_unregister_queue(struct request_queue *);
>>  #else
>>  static inline int bsg_register_queue(struct request_queue *q,
>> --
>> 1.9.1
