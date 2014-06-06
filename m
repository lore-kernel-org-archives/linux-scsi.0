From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC Patch]: scsi: sysfs file cache_type not in sync with mode
 page
Date: Fri, 06 Jun 2014 15:55:14 -0700
Message-ID: <1402095314.2207.105.camel@dabdike.int.hansenpartnership.com>
References: <E1Wt1Sq-0000LA-Ez@bos-lpci1.kendall.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46762 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbaFFWzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 18:55:16 -0400
In-Reply-To: <E1Wt1Sq-0000LA-Ez@bos-lpci1.kendall.corp.akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pai <vpai@akamai.com>
Cc: ~t@akamai.com, linux-scsi@vger.kernel.org, ~c@akamai.com

On Fri, 2014-06-06 at 17:14 -0400, Pai wrote:
> Hi All,
> 
> I noticed that the sysfs file cache_type is not is sync with the information in the mode page. If we change the WCE attribute in the mode page (sdparm --set=WCE /dev/sda  and sdparm --clear=WCE /dev/sda) it does not reflect this in the sysfs file.
> 
> $ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type 
> write back
> 
> $ sdparm --clear=WCE /dev/sda
>     /dev/sda: TOSHIBA   AL13SEB600        0101
> 
> $ cat /sys/block/sda/device/scsi_disk/6\:0\:0\:0/cache_type 
> write back
> 
> Ideally cache_type should have changed to 'write through' or 'none'. I have a small one line change that can fix this one. This patch applies against the latest branch "linux-3.15-rc8". 
> 
> Few things to note:
> 1. revalidate_disk() also reads a whole bunch of other things from the mode page and I don't know if this will have any side effects. This call is made on store_cache_type as well, so I think it should be OK.
> 2. This is extra work which is not needed in most cases (mode pages hardly change). Is there an event that we can subscribe to when the modpages change?
> 
> Please review.
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index efcbcd1..5b65ccc 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -256,6 +256,7 @@ static ssize_t
>  cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	revalidate_disk(sdkp->disk);
>  	int ct = sdkp->RCD + 2*sdkp->WCE;
>  
>  	return snprintf(buf, 40, "%s\n", sd_cache_types[ct]);

The behaviour you describe is correct.  The cache type is probed once at
init.  If you change the cache behind the back of the linux code, you
have to expect that we won't see it.  We're definitely not doing a
revalidate on every write just in case, so by extension we expect that
to see it via sysfs either you change it through the provided interface
(writing to the cache_type file) or you inform the kernel if you change
it via other means by issuing the BLKRRPART ioctl.
James


