From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 02 Nov 2009 11:46:44 -0600
Message-ID: <1257184004.2472.157.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E91345523@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbZKBRqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 12:46:47 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E91345523@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Tue, 2009-09-29 at 14:17 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:

> @@ -593,10 +593,10 @@ static int aac_send_raw_srb(struct aac_d
>                                 u64 addr;
>                                 void* p;
>                                 if (upsg->sg[i].count >
> -                                   (dev->adapter_info.options &
> +                                   ((dev->adapter_info.options &
>                                      AAC_OPT_NEW_COMM) ?
>                                       (dev->scsi_host_ptr->max_sectors
> << 9) :
> -                                     65536) {
> +                                     65536)) {
>                                         rcode = -EINVAL;
>                                         goto cleanup;
>                                 }
> @@ -645,10 +645,10 @@ static int aac_send_raw_srb(struct aac_d
>                                 u64 addr;
>                                 void* p;
>                                 if (usg->sg[i].count >
> -                                   (dev->adapter_info.options &
> +                                   ((dev->adapter_info.options &
>                                      AAC_OPT_NEW_COMM) ?
>                                       (dev->scsi_host_ptr->max_sectors
> << 9) :
> -                                     65536) {
> +                                     65536)) {
>                                         rcode = -EINVAL;
>                                         goto cleanup;
>                                 }
> @@ -695,10 +695,10 @@ static int aac_send_raw_srb(struct aac_d
>                                 uintptr_t addr;
>                                 void* p;
>                                 if (usg->sg[i].count >
> -                                   (dev->adapter_info.options &
> +                                   ((dev->adapter_info.options &
>                                      AAC_OPT_NEW_COMM) ?
>                                       (dev->scsi_host_ptr->max_sectors
> << 9) :
> -                                     65536) {
> +                                     65536)) {
>                                         rcode = -EINVAL;
>                                         goto cleanup;
>                                 }
> @@ -734,10 +734,10 @@ static int aac_send_raw_srb(struct aac_d
>                                 dma_addr_t addr;
>                                 void* p;
>                                 if (upsg->sg[i].count >
> -                                   (dev->adapter_info.options &
> +                                   ((dev->adapter_info.options &
>                                      AAC_OPT_NEW_COMM) ?
>                                       (dev->scsi_host_ptr->max_sectors
> << 9) :
> -                                     65536) {
> +                                     65536)) {
>                                         rcode = -EINVAL;
>                                         goto cleanup;
>                                 }

This is all spurious bracket addition; it doesn't really have any place
in a code fix.


> @@ -842,13 +842,22 @@ static int aac_get_pci_info(struct aac_d
>  int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
>  {
>         int status;
> +       unsigned long mflags;
>  
>         /*
>          *      HBA gets first crack
>          */
>  
> +       spin_lock_irqsave(&dev->manage_lock, mflags);
> +       if (dev->management_fib_count > AAC_NUM_MGT_FIB) {
> +               printk(KERN_INFO "No management Fibs Available:%d\n",
> +                                               dev->management_fib_count);
> +               spin_unlock_irqrestore(&dev->manage_lock, mflags);
> +               return -EBUSY;
> +       }
> +       spin_unlock_irqrestore(&dev->manage_lock, mflags);
>         status = aac_dev_ioctl(dev, cmd, arg);

I can see what you're trying to do: limit the number of ioctl created
fibs to prevent starvation, but this mechanism is completely racy.  The
check is too far away from the increment.  It looks fixable just by
doing the increment within the lock here and decrementing if something
fails.

James



