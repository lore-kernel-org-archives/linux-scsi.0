From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Improve shost_printk
Date: Tue, 02 Oct 2007 14:16:38 -0500
Message-ID: <1191352598.3530.127.camel@localhost.localdomain>
References: <20071002154522.GU12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41794 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752951AbXJBTQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 15:16:41 -0400
In-Reply-To: <20071002154522.GU12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 09:45 -0600, Matthew Wilcox wrote:
> Using dev_printk to implement shost_printk leads to somewhat lacklustre
> results:
> 
>  host2: SCSI BUS has been reset
> scsi2 : sym-2.2.3
> 
> By reimplementing shost_printk directly on top of printk, we can get
> the more pleasing:
> 
> scsi 0: SCSI BUS has been reset
> scsi 0: sym-2.2.3
> 
> It fits in well with
> 
> scsi 0:0:1:0: Optical Device    MATSHITA PD-1 LF-1000     A105 PQ: 0 ANSI: 2
> 
> I'm less sure about the part of this patch which applies to starget_printk.
> It would be quite awkward to find the scsi_host, print its number, then
> print the channel and id of the starget.  The compromise in this patch is to
> print:
> 
> scsi target0:0:1: Beginning Domain Validation
> 
> which at least doesn't penalise the caller of starget_printk.  Maybe we
> could stash a pointer to the scsi_host directly in scsi_target, or just
> the scsi_host's number.
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 5b79697..2268aa8 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -675,7 +675,7 @@ struct Scsi_Host {
>  	container_of(d, struct Scsi_Host, shost_classdev)
>  
>  #define shost_printk(prefix, shost, fmt, a...)	\
> -	dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
> +	printk(prefix "scsi %d: " fmt, (shost)->host_no , ##a)
>  
>  static inline void *shost_priv(struct Scsi_Host *shost)
>  {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index d5057bc..4437b60 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -202,7 +202,7 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
>  	to_scsi_target(class_dev->dev)
>  
>  #define starget_printk(prefix, starget, fmt, a...)	\
> -	dev_printk(prefix, &(starget)->dev, fmt, ##a)
> +	printk(prefix "scsi %s: " fmt, (starget)->dev.bus_id , ##a)

This is the bit I don't like. The idea is to consolidate all printing
through dev_printk so we can use it as a tap into the non existent
kernel logging infrastructure when someone gullible^Wenthusiastic enough
comes along to do it.
 
>  extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
>  		uint, uint, uint, void *hostdata);
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index adc9559..173de6d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -194,7 +194,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>  	struct scsi_host_template *sht = shost->hostt;
>  	int error = -EINVAL;
>  
> -	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
> +	shost_printk(KERN_INFO, shost, "%s\n", 
>  			sht->info ? sht->info(shost) : sht->name);
>  
>  	if (!shost->can_queue) {

