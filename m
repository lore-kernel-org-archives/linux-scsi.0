From: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 10/28] proc: Add proc_mkdir_data() [RFC]
Date: Tue, 16 Apr 2013 18:39:55 -0300
Message-ID: <516DC52B.7090705@redhat.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jerry Chuang <jerry-chuang@realtek.com>, linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Em 16-04-2013 15:26, David Howells escreveu:
> Add proc_mkdir_data() to allow procfs directories to be created that are
> annotated at the time of creation with private data rather than doing this
> post-creation.  This means no access is then required to the proc_dir_entry
> struct to set this.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org
> cc: linux-wireless@vger.kernel.org
> ---
>
>   drivers/message/i2o/i2o_proc.c         |    8 ++------
>   drivers/scsi/megaraid.c                |    4 ++--
>   drivers/staging/rtl8192u/r8192U_core.c |    3 +--

For the three patches that touch rtl8192u (patches 10, 12 and 14):

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

>   fs/proc/generic.c                      |   30 ++++++++++++------------------
>   include/linux/proc_fs.h                |   11 ++++++++---
>   5 files changed, 25 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
> index 70a840f..b7d87cd 100644
> --- a/drivers/message/i2o/i2o_proc.c
> +++ b/drivers/message/i2o/i2o_proc.c
> @@ -1913,14 +1913,12 @@ static void i2o_proc_device_add(struct proc_dir_entry *dir,
>
>   	osm_debug("adding device /proc/i2o/%s/%s\n", dev->iop->name, buff);
>
> -	devdir = proc_mkdir(buff, dir);
> +	devdir = proc_mkdir_data(buff, 0, dir, dev);
>   	if (!devdir) {
>   		osm_warn("Could not allocate procdir!\n");
>   		return;
>   	}
>
> -	devdir->data = dev;
> -
>   	i2o_proc_create_entries(devdir, generic_dev_entries, dev);
>
>   	/* Inform core that we want updates about this device's status */
> @@ -1954,12 +1952,10 @@ static int i2o_proc_iop_add(struct proc_dir_entry *dir,
>
>   	osm_debug("adding IOP /proc/i2o/%s\n", c->name);
>
> -	iopdir = proc_mkdir(c->name, dir);
> +	iopdir = proc_mkdir_data(c->name, 0, dir, c);
>   	if (!iopdir)
>   		return -1;
>
> -	iopdir->data = c;
> -
>   	i2o_proc_create_entries(iopdir, i2o_proc_generic_iop_entries, c);
>
>   	list_for_each_entry(dev, &c->devices, list)
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index a1c90bd..ef3384d 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -2818,12 +2818,12 @@ mega_create_proc_entry(int index, struct proc_dir_entry *parent)
>
>   	sprintf(string, "hba%d", adapter->host->host_no);
>
> -	dir = adapter->controller_proc_dir_entry = proc_mkdir(string, parent);
> +	dir = adapter->controller_proc_dir_entry =
> +		proc_mkdir_data(string, 0, parent, adapter);
>   	if(!dir) {
>   		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
>   		return;
>   	}
> -	dir->data = adapter;
>
>   	for (f = mega_proc_files; f->name; f++) {
>   		de = proc_create_data(f->name, S_IRUSR, dir, &mega_proc_fops,
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
> index 433c3df..d81d7d5 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -672,13 +672,12 @@ void rtl8192_proc_init_one(struct net_device *dev)
>   	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
>
>   	if (rtl8192_proc) {
> -		priv->dir_dev = proc_mkdir(dev->name, rtl8192_proc);
> +		priv->dir_dev = proc_mkdir_data(dev->name, 0, rtl8192_proc, dev);
>   		if (!priv->dir_dev) {
>   			RT_TRACE(COMP_ERR, "Unable to initialize /proc/net/rtl8192/%s\n",
>   				 dev->name);
>   			return;
>   		}
> -		priv->dir_dev->data = dev;
>
>   		for (f = rtl8192_proc_files; f->name[0]; f++) {
>   			if (!proc_create_data(f->name, S_IFREG | S_IRUGO,
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 5f6f6c3..4074da5 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -428,13 +428,17 @@ struct proc_dir_entry *proc_symlink(const char *name,
>   }
>   EXPORT_SYMBOL(proc_symlink);
>
> -struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
> -		struct proc_dir_entry *parent)
> +struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
> +		struct proc_dir_entry *parent, void *data)
>   {
>   	struct proc_dir_entry *ent;
>
> +	if (mode == 0)
> +		mode = S_IRUGO | S_IXUGO;
> +
>   	ent = __proc_create(&parent, name, S_IFDIR | mode, 2);
>   	if (ent) {
> +		ent->data = data;
>   		if (proc_register(parent, ent) < 0) {
>   			kfree(ent);
>   			ent = NULL;
> @@ -442,29 +446,19 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
>   	}
>   	return ent;
>   }
> -EXPORT_SYMBOL(proc_mkdir_mode);
> +EXPORT_SYMBOL_GPL(proc_mkdir_data);
>
> -struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> -		struct proc_dir_entry *parent)
> +struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
> +				       struct proc_dir_entry *parent)
>   {
> -	struct proc_dir_entry *ent;
> -
> -	ent = __proc_create(&parent, name, S_IFDIR | S_IRUGO | S_IXUGO, 2);
> -	if (ent) {
> -		ent->data = net;
> -		if (proc_register(parent, ent) < 0) {
> -			kfree(ent);
> -			ent = NULL;
> -		}
> -	}
> -	return ent;
> +	return proc_mkdir_data(name, mode, parent, NULL);
>   }
> -EXPORT_SYMBOL_GPL(proc_net_mkdir);
> +EXPORT_SYMBOL(proc_mkdir_mode);
>
>   struct proc_dir_entry *proc_mkdir(const char *name,
>   		struct proc_dir_entry *parent)
>   {
> -	return proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
> +	return proc_mkdir_data(name, 0, parent, NULL);
>   }
>   EXPORT_SYMBOL(proc_mkdir);
>
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 80d9e24..e5d8f69 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -73,6 +73,8 @@ extern int remove_proc_subtree(const char *name, struct proc_dir_entry *parent);
>   extern struct proc_dir_entry *proc_symlink(const char *,
>   		struct proc_dir_entry *, const char *);
>   extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);
> +extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
> +					      struct proc_dir_entry *, void *);
>   extern struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
>   			struct proc_dir_entry *parent);
>
> @@ -82,9 +84,6 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
>   	return proc_create_data(name, mode, parent, proc_fops, NULL);
>   }
>
> -extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> -	struct proc_dir_entry *parent);
> -
>   extern void proc_set_size(struct proc_dir_entry *, loff_t);
>   extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
>   #else
> @@ -153,4 +152,10 @@ static inline void *PDE_DATA(const struct inode *inode)
>   	return PROC_I(inode)->pde->data;
>   }
>
> +static inline struct proc_dir_entry *proc_net_mkdir(
> +	struct net *net, const char *name, struct proc_dir_entry *parent)
> +{
> +	return proc_mkdir_data(name, 0, parent, net);
> +}
> +
>   #endif /* _LINUX_PROC_FS_H */
>
