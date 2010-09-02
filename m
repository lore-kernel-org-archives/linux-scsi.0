From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [RFC 02/22] configfs: Add struct configfs_item_operations->check_link() in configfs_unlink()
Date: Thu, 2 Sep 2010 00:31:07 -0400
Message-ID: <201009020031.08750.konrad@darnok.org>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:52954 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0IBF7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 01:59:20 -0400
In-Reply-To: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Monday 30 August 2010 05:20:25 Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds a optional struct configfs_item_operations->check_link()
> check called in fs/configfs/symlink.c:configfs_unlink() that can be used by
> configfs consumers to check for an explict struct config_group dependence
> with active symlink and fail with -EPERM before the unlink(2) syscall is
> allowed to occur.
>
> Currently without this patch, there is not a method that a consumer can
> tell configfs_unlink() that it needs to fail for this particular case. 
> Allowing ->check_link() to propigate up the errno to VFS is also another
> option for the call, but currently for TCM using the existing -EPERM in
> configfs_unlink() is fine here.
>
> Note this patch is used by TCM v4 generic configfs fabric module
> infrastructure to allow  explict Initiator Port MappedLUNs symlinks to
> create a dependency for the fabric TPG Port LUNs living in a configfs group
> that is not a direct struct config_group parent.
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  fs/configfs/symlink.c    |   13 +++++++++++++
>  include/linux/configfs.h |    1 +
>  2 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index 0f3eb41..b8010de 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -205,6 +205,19 @@ int configfs_unlink(struct inode *dir, struct dentry
> *dentry) parent_item = configfs_get_config_item(dentry->d_parent);
>  	type = parent_item->ci_type;
>
> +	/*
> +	 * See if the underlying struct config_item has dependent
> +	 * symlinks, and should return -EPERM here.
> +	 */
> +	if (type && type->ct_item_ops &&
> +	    type->ct_item_ops->check_link) {
> +		if (type->ct_item_ops->check_link(parent_item,
> +					sl->sl_target) != 0) {
> +			config_item_put(parent_item);
> +			goto out;
> +		}
> +	}
> +
>  	spin_lock(&configfs_dirent_lock);
>  	list_del_init(&sd->s_sibling);
>  	spin_unlock(&configfs_dirent_lock);
> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
> index ddb7a97..7c01d86 100644
> --- a/include/linux/configfs.h
> +++ b/include/linux/configfs.h
> @@ -226,6 +226,7 @@ struct configfs_item_operations {
>  	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute
> *,char *); ssize_t	(*store_attribute)(struct config_item *,struct
> configfs_attribute *,const char *, size_t); int (*allow_link)(struct
> config_item *src, struct config_item *target); +	int (*check_link)(struct
> config_item *src, struct config_item *target); int (*drop_link)(struct
> config_item *src, struct config_item *target); };

You might want to copy these folks:

git/linux$ scripts/get_maintainer.pl -f fs/configfs/symlink.c
Joel Becker <joel.becker@oracle.com>
Tejun Heo <tj@kernel.org>
Al Viro <viro@zeniv.linux.org.uk>

