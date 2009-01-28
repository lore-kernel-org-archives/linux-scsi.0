From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/16] osd_uld: API for retrieving osd devices from
	Kernel
Date: Wed, 28 Jan 2009 16:32:56 +0000
Message-ID: <1233160376.3236.51.camel@localhost.localdomain>
References: <497C7B33.4080105@panasas.com>
	 <1232895483-19590-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52761 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbZA1Qc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 11:32:57 -0500
In-Reply-To: <1232895483-19590-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

On Sun, 2009-01-25 at 16:58 +0200, Boaz Harrosh wrote:
> Kernel clients like exofs can retrieve struct osd_dev(s)
> by means of below API.
> 
> + osduld_path_lookup() - given a path (e.g "/dev/osd0") locks and
> returns the corresponding struct osd_dev, which is then needed
> for subsequent libosd use.
> 
> + osduld_put_device() - free up use of an osd_dev.
> 
> Devices can be shared by multiple clients. The osd_uld_device's
> life time is governed by an embedded kref structure.
> 
> The osd_uld_device holds an extra reference to both it's
> char-device and it's scsi_device, and will release these just
> before the final deallocation.
> 
> There are three possible lock sources of the osd_uld_device
> 1. First and for most is the probe() function called by
>   scsi-ml upon a successful login into a target. Released in release()
>   when logout.
> 2. Second by user-mode file handles opened on the char-dev.
> 3. Third is here by Kernel users.
> All three locks must be removed before the osd_uld_device is freed.
> 
> The MODULE has three lock sources as well:
> 1. scsi-ml at probe() time, removed after release(). (login/logout)
> 2. The user-mode file handles open/close.
> 3. Import symbols by client modules like exofs.
> 
> TODO:
>   This API is not enough for the pNFS-objects LD. A more versatile
>   API will be needed. Proposed API could be:
>   struct osd_dev *osduld_sysid_lookup(const char id[OSD_SYSTEMID_LEN]);
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_uld.c   |   63 ++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/osd_initiator.h |    4 ++
>  2 files changed, 67 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index f6f9a99..cd4ca7c 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -173,6 +173,69 @@ static const struct file_operations osd_fops = {
>  	.unlocked_ioctl = osd_uld_ioctl,
>  };
>  
> +struct osd_dev *osduld_path_lookup(const char *path)

Is there no other way to do this?  A kernel component opening another
kernel component by device path is generally frowned upon.

The way it should work is to have a user space process initiate
everything because it can see the full device space and cope with the
problems that may occur on first open in user space.

> +{
> +	struct nameidata nd;
> +	struct inode *inode;
> +	struct cdev *cdev;
> +	struct osd_uld_device *uninitialized_var(oud);
> +	int error;
> +
> +	if (!path || !*path) {
> +		OSD_ERR("Mount with !path || !*path\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	error = path_lookup(path, LOOKUP_FOLLOW, &nd);
> +	if (error) {
> +		OSD_ERR("path_lookup of %s faild=>%d\n", path, error);
> +		return ERR_PTR(error);
> +	}
> +
> +	inode = nd.path.dentry->d_inode;
> +	error = -EINVAL; /* Not the right device e.g osd_uld_device */
> +	if (!S_ISCHR(inode->i_mode)) {
> +		OSD_DEBUG("!S_ISCHR()\n");
> +		goto out;
> +	}
> +
> +	cdev = inode->i_cdev;
> +	if (!cdev) {
> +		OSD_ERR("Before mounting an OSD Based filesystem\n");
> +		OSD_ERR("  user-mode must open+close the %s device\n", path);
> +		OSD_ERR("  Example: bash: echo < %s\n", path);
> +		goto out;
> +	}
> +
> +	/* The Magic wand. Is it our char-dev */
> +	/* TODO: Support sg devices */
> +	if (cdev->owner != THIS_MODULE) {
> +		OSD_ERR("Error mounting %s - is not an OSD device\n", path);
> +		goto out;
> +	}
> +
> +	oud = container_of(cdev, struct osd_uld_device, cdev);
> +
> +	__uld_get(oud);
> +	error = 0;
> +
> +out:
> +	path_put(&nd.path);
> +	return error ? ERR_PTR(error) : &oud->od;
> +}
> +EXPORT_SYMBOL(osduld_path_lookup);
> +
> +void osduld_put_device(struct osd_dev *od)
> +{
> +	if (od) {
> +		struct osd_uld_device *oud = container_of(od,
> +						struct osd_uld_device, od);
> +
> +		__uld_put(oud);
> +	}
> +}
> +EXPORT_SYMBOL(osduld_put_device);
> +
>  /*
>   * Scsi Device operations
>   */
> diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
> index a5dbbdd..e84dc7a 100644
> --- a/include/scsi/osd_initiator.h
> +++ b/include/scsi/osd_initiator.h
> @@ -33,6 +33,10 @@ struct osd_dev {
>  	unsigned def_timeout;
>  };
>  
> +/* Retrieve/return osd_dev(s) for use by Kernel clients */
> +struct osd_dev *osduld_path_lookup(const char *dev_name); /*Use IS_ERR/ERR_PTR*/
> +void osduld_put_device(struct osd_dev *od);
> +
>  /* Add/remove test ioctls from external modules */
>  typedef int (do_test_fn)(struct osd_dev *od, unsigned cmd, unsigned long arg);
>  int osduld_register_test(unsigned ioctl, do_test_fn *do_test);
> -- 
> 1.6.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

