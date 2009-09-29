From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 29 Sep 2009 09:19:52 -0500
Message-ID: <1254233992.3942.39.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E91345523@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZI2OT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 10:19:56 -0400
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E91345523@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Tue, 2009-09-29 at 14:17 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Hi James and linux-scsi community,
> 
>        I would request you that please review the attached patch and do the needful to incorporate the patch in up-coming release. I am happy to provide if any additional info is required to accept the patch.
> 
> From: Narasimha Reddy <ServeRAIDDriver@hcl.in>
> 
>         The attached patch was generated for fixing the following issues. These issues were reported by Cisco, SAP and some other customers as well.
> 
> Regarding the testing of fixes:
> --------------------------------
> 
>         These particular problems were reported by Cisco and SAP and customers as well. Cisco reported on RHEL4 U6 and SAP reported on SLES9 SP4 and SLES10 SP2. We added these fixes on RHEL4 U6 and gave a private build to IBM and Cisco. Cisco and IBM tested it for more than 15 days and they reported that they did not see the issue so far. Before the fix, Cisco used to see the issue within 5 days. We generated a patch for SLES9 SP4 and SLES10 SP2 and submitted to Novell. Novell applied the patch and gave a test build to SAP. SAP tested and reported that the build is working properly.
> 
> We also tested in our lab using the tools "dishogsync", which is IO stress tool and the tool was provided by Cisco.
> 
> Issue1: File System going into read-only mode
> ---------
> 
> Root cause:
> -----------
>        The driver tends to not free the memory (FIB) when the management request exits prematurely. The accumulation of such un-freed memory causes the driver to fail to allocate anymore memory (FIB) and hence return 0x70000 value to the upper layer, which puts the file system into read only mode.
> 
> Fix details:
> ------------
>      The fix makes sure to free the memory (FIB) even if the request exits prematurely hence ensuring the driver wouldn't run out of memory (FIBs).
> 
> 
> Issue2:
> -------
>         False Raid Alert occurs- when the Physical Drives and Logical drives are reported as deleted or added, even though there is no change done on the system
> 
> Root cause:
> -----------
>         Driver IOCTLs is signaled with EINTR while waiting on response from the lower layers. Returning "EINTR" will never initiate internal retry.
> 
> Fix details:
> ------------
>         The issue was fixed by replacing "EINTR" with "ERESTARTSYS" for mid-layer retries.
> 
> 
> Signed-off-by: Narasimha Reddy <ServeRAIDDriver@hcl.in>

Would it be possible to split this into two patches, one that fixes each
issue?  That makes it easier for distro backporting and bisection
checking if something goes wrong with the fix

>        Please find the attached patch file "community_aac24701.patch", which has been generated for the issues we fixed and "email" file "community_aac24701.email", which has been generated for the statistics like number of lines inserted and deleted, errors etc.

That's fine ... I note you're using outlook, which is known to mangle
inline patches.

> Regards - Narasimha Reddy
> 
> 
> DISCLAIMER:
> -----------------------------------------------------------------------------------------------------------------------
> 
> The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
> It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
> this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
> Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
> this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
> received this email in error please delete it and notify the sender immediately. Before opening any mail and 
> attachments please check them for viruses and defect.
> 
> -----------------------------------------------------------------------------------------------------------------------

It does look a bit odd to have a disclaimer like this on an email you've
just sent to a public list ...


> diff -purN a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c     2009-09-10 03:43:59.000000000 +0530
> +++ b/drivers/scsi/aacraid/aachba.c     2009-09-25 11:43:12.000000000 +0530
> @@ -293,7 +293,10 @@ int aac_get_config_status(struct aac_dev
>                         status = -EINVAL;
>                 }
>         }
> -       aac_fib_complete(fibptr);
> +       /* Do not set XferState to zero unless receives a response from F/W */
> +       if (status >= 0)
> +               aac_fib_complete(fibptr);

This can just move under the if (status >= 0) below, can't it?

> +
>         /* Send a CT_COMMIT_CONFIG to enable discovery of devices */
>         if (status >= 0) {

[...]


> @@ -842,13 +842,22 @@ static int aac_get_pci_info(struct aac_d
>  int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
>  {
>         int status;
> +       unsigned long mflags;

flags is the usual linux convention for this ... and that's what's used
throughout the rest of the file ... consistency on flags would be better
(for all the uses).

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
> -       if(status != -ENOTTY)
> +       if (status != -ENOTTY)
>                 return status;

It seems to me from the above that the intention of manage_lock is to
protect management_fib_count?  If so, there's a race here, isn't there,
because you check the count under the lock, but then drop the lock which
makes the count vulnerable to change again before you get to
aac_fib_send()?  If you really don't want to go over AAC_NUM_MGT_FIB,
you'll need to do an atomic test and increment somewhere.

Other than the above, the code in here looks fine.

Thanks,

James



