From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/2] Declare local symbols static
Date: Tue, 29 Mar 2016 10:55:35 -0400
Message-ID: <1459263335.30035.15.camel@localhost.localdomain>
References: <56F9740A.4060100@sandisk.com>  <56F9743C.8040301@sandisk.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbcC2Ozi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 10:55:38 -0400
In-Reply-To: <56F9743C.8040301@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2016-03-28 at 11:13 -0700, Bart Van Assche wrote:
> Avoid that building with W=1 causes gcc to report warnings about
> symbols that have not been declared.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 92ffd24..2b642b1 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -81,6 +81,7 @@ const char *scsi_host_state_name(enum scsi_host_state state)
>  	return name;
>  }
>  
> +#ifdef CONFIG_SCSI_DH
>  static const struct {
>  	unsigned char	value;
>  	char		*name;
> @@ -94,7 +95,7 @@ static const struct {
>  	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
>  };
>  
> -const char *scsi_access_state_name(unsigned char state)
> +static const char *scsi_access_state_name(unsigned char state)
>  {
>  	int i;
>  	char *name = NULL;
> @@ -107,6 +108,7 @@ const char *scsi_access_state_name(unsigned char state)
>  	}
>  	return name;
>  }
> +#endif
>  
>  static int check_set(unsigned long long *val, char *src)
>  {
> @@ -226,7 +228,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
>  }
>  
>  /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
> -struct device_attribute dev_attr_hstate =
> +static struct device_attribute dev_attr_hstate =
>  	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
>  
>  static ssize_t
> @@ -401,7 +403,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>  	NULL
>  };
>  
> -struct attribute_group scsi_shost_attr_group = {
> +static struct attribute_group scsi_shost_attr_group = {
>  	.attrs =	scsi_sysfs_shost_attrs,
>  };
>  

Could have been 2 patches, since the patch subject and the more
verbose description, along with the code, are really 2 separate
issues, but OK.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


