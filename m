From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 13:56:23 +0900
Message-ID: <20070925102150V.tomof@acm.org>
References: <20070926025608.GA3899@parisc-linux.org>
	<46F9D328.4030801@garzik.org>
	<1190778353.8707.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:42203 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXIZE4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 00:56:42 -0400
In-Reply-To: <1190778353.8707.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jeff@garzik.org, matthew@wil.cx, tomof@acm.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 25 Sep 2007 22:45:53 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-09-25 at 23:34 -0400, Jeff Garzik wrote:
> > Matthew Wilcox wrote:
> > > On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
> > >> Are there any const-ness worries for scsi_host_template, or plans for 
> > >> the future?  I do not see any other examples of the host template 
> > >> members getting modified.
> > > 
> > > Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> > > I've come across trawling the horrible unmaintained drivers.  I'd love
> > > to see scsi_host_template become const, but it's not happening any time
> > > soon, and we can address this little piece when the time comes.
> > 
> > Well, sure, the driver is the owner of that memory.
> > 
> > We're talking about common code.
> > 
> > If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.
> 
> Well, I don't like mucking with the template either.
> 
> This whole mess is generated basically because the zero default of the
> template should be treated as initiator.  How about this, which makes
> that manifest?
> 
> James
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index adc9559..7e26440 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -342,7 +342,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> -	shost->active_mode = sht->supported_mode;
> +	if (sht->supported_mode == MODE_UNKNOWN)
> +		/* means we didn't set it ... default to INITIATOR */
> +		shost->active_mode = MODE_INITIATOR;
> +	else
> +		shost->active_mode = sht->supported_mode;
>  
>  	if (sht->max_host_blocked)
>  		shost->max_host_blocked = sht->max_host_blocked;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0088c4d..4965e9e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -209,11 +209,13 @@ show_shost_mode(unsigned int mode, char *buf)
>  static ssize_t show_shost_supported_mode(struct class_device *class_dev, char *buf)
>  {
>  	struct Scsi_Host *shost = class_to_shost(class_dev);
> +	unsigned int supported_mode = shost->hostt->supported_mode;
>  
> -	if (shost->hostt->supported_mode == MODE_UNKNOWN)
> -		return snprintf(buf, 20, "unknown\n");
> -	else
> -		return show_shost_mode(shost->hostt->supported_mode, buf);
> +	if (supported_mode == MODE_UNKNOWN)
> +		/* by default this should be initiator */
> +		supported_mode = MODE_INITIATOR;
> +
> +	return show_shost_mode(shost->hostt->supported_mode, buf);

should be:

return show_shost_mode(supported_mode, buf);

>  
>  static CLASS_DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
> 
