From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 3 Nov 2009 15:47:14 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8572@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <1257184004.2472.157.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:34944 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZKCKR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 05:17:26 -0500
In-Reply-To: <1257184004.2472.157.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,

My answers are inline to your queries.

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de]
Sent: Monday, November 02, 2009 11:17 PM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: 'linux-scsi@vger.kernel.org'; James Bottomley; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

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

<Narasimha Reddy>: As we know that if we do not keep bracket appropriately, some times compilers will behave differently and it may use different instructions and evaluate differently. So to avoid those kinds of issues, we added those brackets. It is not a code fix, but it is compiler fix (compilers should not interpret differently). If compiler interprets differently then the logic may behave differently as against to your intentional behavior.  I hope you agree with me.



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


<Narasimha Reddy>: My intention is not to prevent starvation, but my intention is that management fibs should not cross more than "AAC_NUM_MGT_FIB". During our testing, we have seen any racy condition.
Even no end user has reported such kind of problem. We have given a private build to end customers two months back. So far nobody reported the issue.

James




DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
