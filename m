From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Fri, 9 Oct 2009 14:53:19 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134554A@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:39116 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760492AbZJIJZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 05:25:04 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James and linux-scsi community,

Can you please let us know your feedback on my response to the queries raised by James so that I will proceed further based on your feedback?

Thanks,
Narasimha Reddy 

-----Original Message-----
From: Penchala Narasimha Reddy Chilakala, TLS-Chennai 
Sent: Wednesday, October 07, 2009 11:33 AM
To: James Bottomley
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode


Hi James and linux-scsi community,

Have you had a chance to look at my inline responses to the queries raised by James?

Thanks,
Narasimha Reddy

-----Original Message-----
From: Penchala Narasimha Reddy Chilakala, TLS-Chennai 
Sent: Wednesday, September 30, 2009 5:04 PM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai; James Bottomley
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

Hi James and linux-scsi community,

Sorry for missing a word "not" in the previous mail for the following inline response.

flags is the usual linux convention for this ... and that's what's used
throughout the rest of the file ... consistency on flags would be better
(for all the uses).

<Previous response> I do have any issue to replace "mflags" with "flags", but we have used this mflags in dpcsup.c, and commsup.c as well. We initially thought of using flags only, but flags variable is used by some other spinlock function in the same function in dpcsup.c so we do not have any other alternative and went with different name. So we used mflags for the management fib count across all the files.

<Correct response>
I do not have any issue to replace "mflags" with "flags", but we have used this mflags in dpcsup.c, and commsup.c as well. We initially thought of using flags only, but flags variable is used by some other spinlock function in the same function in dpcsup.c so we do not have any other alternative and went with different name. So we used mflags for the management fib count across all the files.



Thanks,
Narasimha Reddy
 

-----Original Message-----
From: Penchala Narasimha Reddy Chilakala, TLS-Chennai 
Sent: Wednesday, September 30, 2009 4:40 PM
To: James Bottomley
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

Hi James and linux-scsi community,

Thank you very much for your valuable feedback.

Please have a look at my inline responses and let me your opinion so that I will go ahead and do the necessary changes if required.

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Tuesday, September 29, 2009 7:50 PM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

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

<Narasimha Reddy> Actually, the issues are inter-linked each other even though customers reported the issues separately. So I feel that it would be better go with as single patch instead of separate patches.

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

<Narasimha Reddy>:   Yes, I agree with your comment, but the disclaimer will be added by HCL email-server for all outgoing mails outside HCL. I will talk to HCL IT service about this if it is serious issue. Please let me know.


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

<Narasimha Reddy>: I accept your suggestion as we can avoid two times execution of the same condition and redundancy. Earlier there was no check and comment before calling the aac_fib_complete function. We added a check to fix the issues and comment to understand that why we have done the change and it is easy for reviewing when we have comments like this. 

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

<Narasimha Reddy> I do have any issue to replace "mflags" with "flags", but we have used this mflags in dpcsup.c, and commsup.c as well. We initially thought of using flags only, but flags variable is used by some other spinlock function in the same function in dpcsup.c so we do not have any other alternative and went with different name. So we used mflags for the management fib count across all the files. 

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
You'll need to do an atomic test and increment somewhere.

<Narasimha Reddy>  We have tested it extensively this in our lab and client as well, we have not seen any race condition here as it is a starting point for any management commands, it is meant only for management commands, and not meant for IO commands. I strongly feel that there would not be any race condition.

For example:

1. Assume driver received a management comment from a application layer, 
2. On receiving, driver checks whether management fib count reached to its limit or not. 
3. If it reached to its limit, then it will return as -EBUSY to the application layer saying that no management fibs are available at this point of time. That means currently, all management fibs are in use. 

Other than the above, the code in here looks fine.

Thanks,

James




