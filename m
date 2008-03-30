From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] sysfs: allow the group is_visible() method to
	return a mode and add an update API
Date: Sun, 30 Mar 2008 11:54:42 -0500
Message-ID: <1206896083.4224.40.camel@localhost.localdomain>
References: <1206134832.2961.64.camel@localhost.localdomain>
	 <20080321222635.GA2674@kroah.com>
	 <1206208949.4393.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40634 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbYC3Qyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 12:54:46 -0400
In-Reply-To: <1206208949.4393.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 2008-03-22 at 13:02 -0500, James Bottomley wrote:
> On Fri, 2008-03-21 at 15:26 -0700, Greg KH wrote:
> > On Fri, Mar 21, 2008 at 04:27:12PM -0500, James Bottomley wrote:
> > > We have a problem in scsi_transport_spi in that we need to customise
> > > not only the visibility of the attributes, but also their mode.  Fix
> > > this by making the is_visible() callback return a mode, with 0
> > > indicating is not visible.
> > > 
> > > Also add a sysfs_update_group() API to allow us to change either the
> > > visibility or mode of the files at any time on the fly.
> > > 
> > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > ---
> > > 
> > > Greg, can I take this through SCSI, please ... assuming it's OK?  We
> > > need this to fix up the SPI transport class.
> > 
> > Sure.  But can you document that "update" field a bit more so we can
> > remember what it means in the future?
> 
> How about this?  I also added docbook for create and update attribute
> group.

Can I get an ACK from someone from sysfs for this, please?

James

> James
> 
> ---
> 
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Thu, 20 Mar 2008 20:47:52 -0500
> Subject: [SCSI] sysfs: make group is_valid return a mode_t
> 
> We have a problem in scsi_transport_spi in that we need to customise
> not only the visibility of the attributes, but also their mode.  Fix
> this by making the is_visible() callback return a mode, with 0
> indicating is not visible.
> 
> Also add a sysfs_update_group() API to allow us to change either the
> visibility or mode of the files at any time on the fly.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  fs/sysfs/file.c       |   14 ++++++--
>  fs/sysfs/group.c      |   77 +++++++++++++++++++++++++++++++++++++++++-------
>  fs/sysfs/sysfs.h      |    2 +
>  include/linux/sysfs.h |    4 ++-
>  4 files changed, 80 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 6f5954a..8f7ee10 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -490,11 +490,10 @@ const struct file_operations sysfs_file_operations = {
>  	.poll		= sysfs_poll,
>  };
>  
> -
> -int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
> -		   int type)
> +int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
> +			const struct attribute *attr, int type, mode_t amode)
>  {
> -	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
> +	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
>  	struct sysfs_addrm_cxt acxt;
>  	struct sysfs_dirent *sd;
>  	int rc;
> @@ -515,6 +514,13 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
>  }
>  
> 
> +int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
> +		   int type)
> +{
> +	return sysfs_add_file_mode(dir_sd, attr, type, attr->mode);
> +}
> +
> +
>  /**
>   *	sysfs_create_file - create an attribute file for an object.
>   *	@kobj:	object we're creating for. 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index 4779049..dac9383 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -23,30 +23,41 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  	int i;
>  
>  	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
> -		if (!grp->is_visible ||
> -		    grp->is_visible(kobj, *attr, i))
> -			sysfs_hash_and_remove(dir_sd, (*attr)->name);
> +		sysfs_hash_and_remove(dir_sd, (*attr)->name);
>  }
>  
>  static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
> -			const struct attribute_group *grp)
> +			const struct attribute_group *grp, int update)
>  {
>  	struct attribute *const* attr;
>  	int error = 0, i;
>  
> -	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++)
> -		if (!grp->is_visible ||
> -		    grp->is_visible(kobj, *attr, i))
> -			error |=
> -				sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
> +	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> +		mode_t mode = 0;
> +
> +		/* in update mode, we're changing the permissions or
> +		 * visibility.  Do this by first removing then
> +		 * re-adding (if required) the file */
> +		if (update)
> +			sysfs_hash_and_remove(dir_sd, (*attr)->name);
> +		if (grp->is_visible) {
> +			mode = grp->is_visible(kobj, *attr, i);
> +			if (!mode)
> +				continue;
> +		}
> +		error = sysfs_add_file_mode(dir_sd, *attr, SYSFS_KOBJ_ATTR,
> +					    (*attr)->mode | mode);
> +		if (unlikely(error))
> +			break;
> +	}
>  	if (error)
>  		remove_files(dir_sd, kobj, grp);
>  	return error;
>  }
>  
> 
> -int sysfs_create_group(struct kobject * kobj, 
> -		       const struct attribute_group * grp)
> +static int internal_create_group(struct kobject *kobj, int update,
> +				 const struct attribute_group *grp)
>  {
>  	struct sysfs_dirent *sd;
>  	int error;
> @@ -60,7 +71,7 @@ int sysfs_create_group(struct kobject * kobj,
>  	} else
>  		sd = kobj->sd;
>  	sysfs_get(sd);
> -	error = create_files(sd, kobj, grp);
> +	error = create_files(sd, kobj, grp, update);
>  	if (error) {
>  		if (grp->name)
>  			sysfs_remove_subdir(sd);
> @@ -69,6 +80,47 @@ int sysfs_create_group(struct kobject * kobj,
>  	return error;
>  }
>  
> +/**
> + * sysfs_create_group - given a directory kobject, create an attribute group
> + * @kobj:	The kobject to create the group on
> + * @grp:	The attribute group to create
> + *
> + * This function creates a group for the first time.  It will explicitly
> + * warn and error if any of the attribute files being created already exist.
> + *
> + * Returns 0 on success or error.
> + */
> +int sysfs_create_group(struct kobject *kobj,
> +		       const struct attribute_group *grp)
> +{
> +	return internal_create_group(kobj, 0, grp);
> +}
> +
> +/**
> + * sysfs_update_group - given a directory kobject, create an attribute group
> + * @kobj:	The kobject to create the group on
> + * @grp:	The attribute group to create
> + *
> + * This function updates an attribute group.  Unlike
> + * sysfs_create_group(), it will explicitly not warn or error if any
> + * of the attribute files being created already exist.  Furthermore,
> + * if the visibility of the files has changed through the is_visible()
> + * callback, it will update the permissions and add or remove the
> + * relevant files.
> + *
> + * The primary use for this function is to call it after making a change
> + * that affects group visibility.
> + *
> + * Returns 0 on success or error.
> + */
> +int sysfs_update_group(struct kobject *kobj,
> +		       const struct attribute_group *grp)
> +{
> +	return internal_create_group(kobj, 1, grp);
> +}
> +
> +
> +
>  void sysfs_remove_group(struct kobject * kobj, 
>  			const struct attribute_group * grp)
>  {
> @@ -95,4 +147,5 @@ void sysfs_remove_group(struct kobject * kobj,
>  
> 
>  EXPORT_SYMBOL_GPL(sysfs_create_group);
> +EXPORT_SYMBOL_GPL(sysfs_update_group);
>  EXPORT_SYMBOL_GPL(sysfs_remove_group);
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 52aaa8c..2915959 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -155,6 +155,8 @@ extern const struct file_operations sysfs_file_operations;
>  int sysfs_add_file(struct sysfs_dirent *dir_sd,
>  		   const struct attribute *attr, int type);
>  
> +int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
> +			const struct attribute *attr, int type, mode_t amode);
>  /*
>   * bin.c
>   */
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 0f388af..07d9c12 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -32,7 +32,7 @@ struct attribute {
>  
>  struct attribute_group {
>  	const char		*name;
> -	int			(*is_visible)(struct kobject *,
> +	mode_t			(*is_visible)(struct kobject *,
>  					      struct attribute *, int);
>  	struct attribute	**attrs;
>  };
> @@ -105,6 +105,8 @@ void sysfs_remove_link(struct kobject *kobj, const char *name);
>  
>  int __must_check sysfs_create_group(struct kobject *kobj,
>  				    const struct attribute_group *grp);
> +int sysfs_update_group(struct kobject *kobj,
> +		       const struct attribute_group *grp);
>  void sysfs_remove_group(struct kobject *kobj,
>  			const struct attribute_group *grp);
>  int sysfs_add_file_to_group(struct kobject *kobj,

