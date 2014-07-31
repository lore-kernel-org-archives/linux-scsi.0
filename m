From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] scsi: hpsa.c:  Cleaning up code clarification using strlcpy
Date: Thu, 31 Jul 2014 08:56:20 -0500
Message-ID: <20140731135620.GZ14599@beardog.cce.hp.com>
References: <1406756812-20526-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46979 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGaN6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 09:58:12 -0400
Content-Disposition: inline
In-Reply-To: <1406756812-20526-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com

On Wed, Jul 30, 2014 at 11:46:52PM +0200, Rickard Strandqvist wrote:
> Code clarification using strlcpy instead of strncpy.
> And removed unnecessary memset
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/hpsa.c |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 31184b3..814d64d 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -315,16 +315,15 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
>  					 struct device_attribute *attr,
>  					 const char *buf, size_t count)
>  {
> -	int status, len;
> +	int status;
>  	struct ctlr_info *h;
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	char tmpbuf[10];
>  
>  	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>  		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	strlcpy(tmpbuf, buf,
> +		count > sizeof(tmpbuf) ? sizeof(tmpbuf) : count);

Are we doing the strlcpy thing?  Linus and GregKH didn't seem to like this 
kind of stuff all that much in some google+ comments I saw recently.

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5

	"... strlcpy requires the source to be 0 terminated, even if
	its longer than the target size."

which I don't know that we really want to rely on buf being
null terminated here.

Part of Linus's comment was:

	If you're actually copying from user space in the kernel, do

	   ret = strncpy_from_user(buf, userptr, len);
	   if (ret < 0) return ret;
	   if (ret == len) return -ETOOLONG;

	and you're ok (and 'ret' will be the length of the properly NUL-terminated string).

	Don't use strncpy(), don't use strlcpy(). 


>  	if (sscanf(tmpbuf, "%d", &status) != 1)
>  		return -EINVAL;
>  	h = shost_to_hba(shost);
> @@ -339,16 +338,15 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
>  					 struct device_attribute *attr,
>  					 const char *buf, size_t count)
>  {
> -	int debug_level, len;
> +	int debug_level;
>  	struct ctlr_info *h;
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	char tmpbuf[10];
>  
>  	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>  		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	strlcpy(tmpbuf, buf,
> +		count > sizeof(tmpbuf) ? sizeof(tmpbuf) : count);
>  	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
>  		return -EINVAL;
>  	if (debug_level < 0)
> @@ -5881,8 +5879,8 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
>  
>  static void init_driver_version(char *driver_version, int len)
>  {
> -	memset(driver_version, 0, len);
>  	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
> +	driver_version[len - 1] = '\0';

So this depends on strncpy actually putting those zeros on the end of that
string so as not to leak a partially uninitialized kernel buffer out into a pci
config space register on a device that could potentially get read later
from user space.  (using kzalloc for that particular buffer could alleviate
that dependency easily enough though) Plenty of places that are using strncpy
probably do not care whether those zeroes are padded on, but this one does
care, but that is not signaled to the reader of the code in any way here.
(a comment indicating the zero padding is actually wanted would suffice.)

None of this stuff is in performance critical paths.

-- steve

>  }
>  
>  static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)
> -- 
> 1.7.10.4
