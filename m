From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Thu, 5 Jun 2003 13:50:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030605205010.GD2154@beaverton.ibm.com>
References: <20030603203243.GA9018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:35824 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S265110AbTFEUeK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 16:34:10 -0400
Content-Disposition: inline
In-Reply-To: <20030603203243.GA9018@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

I ran your series of patches. The ips driver was missed in your updates I
attached the patch below. David Jeffery may want a wrapper for 2.4/2.5
compatibility.

Christoph Hellwig [hch@lst.de] wrote:
> Currently this is juist a new name for scsi_register, but we make
> sure new-style drivers never call scsi_register/scsi_unregister
> but always scsi_host_alloc/scsi_host_put in this patch so the
> next patch can introduce code specific to legacy drivers in
> the former.  Also cleanup scsi_register/scsi_host_alloc a bit.
> 
> 
> +
> +	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
>

We could move the host_no to scsi_sysfs_init_host and use the
class->subsys.rwsem to protect this.


-andmike
--
Michael Anderson
andmike@us.ibm.com

 drivers/scsi/ips.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ips.c~ips_scsi_alloc_fix drivers/scsi/ips.c
--- hch-scsi-misc-2.5/drivers/scsi/ips.c~ips_scsi_alloc_fix	Thu Jun  5 00:12:53 2003
+++ hch-scsi-misc-2.5-andmike/drivers/scsi/ips.c	Thu Jun  5 00:14:28 2003
@@ -725,7 +725,7 @@ ips_release(struct Scsi_Host *sh) {
    free_irq(ha->irq, ha);
 
    IPS_REMOVE_HOST(sh);
-   scsi_unregister(sh);
+   scsi_host_put(sh);
 
    ips_released_controllers++;
 
@@ -6732,7 +6732,7 @@ static int
 ips_register_scsi( int index){
 	struct Scsi_Host *sh;
 	ips_ha_t *ha, *oldha = ips_ha[index];
-	sh = scsi_register(&ips_driver_template, sizeof(ips_ha_t));
+	sh = scsi_host_alloc(&ips_driver_template, sizeof(ips_ha_t));
 	if(!sh) {
 		IPS_PRINTK(KERN_WARNING, oldha->pcidev, "Unable to register controller with SCSI subsystem\n");
 		return -1;
@@ -6743,7 +6743,7 @@ ips_register_scsi( int index){
 	/* Install the interrupt handler with the new ha */
 	if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to install interrupt handler\n" );
-		scsi_unregister(sh);
+		scsi_host_put(sh);
 		return -1;
 	}
 

_

