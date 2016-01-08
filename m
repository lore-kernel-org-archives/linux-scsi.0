From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V2 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Fri, 8 Jan 2016 23:37:15 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F3EE6@BBYEXM01.pmc-sierra.internal>
References: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452151344-417-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <DDB9C85B850785449757F9914A034FCB4450951E@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48580 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbcAHXhQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2016 18:37:16 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4450951E@G9W0766.americas.hpqcorp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "thenzl@redhat.com" <thenzl@redhat.com>, David Carroll <David.Carroll@pmcs.com>

Hello Shane,

> -----Original Message-----
> From: Seymour, Shane M [mailto:shane.seymour@hpe.com]
> Sent: Thursday, January 7, 2016 9:58 PM
> To: Raghava Aditya Renukunta; JBottomley@odin.com; linux-
> scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh; jthumshirn@suse.de; thenzl@redhat.com; David
> Carroll
> Subject: RE: [PATCH V2 7/9] aacraid: Fix AIF triggered IOP_RESET
> 
> Is there still a race in the code so the same issue can happen even with this
> patch?
> 
> When __aac_shutdown is called it clears out the events and stops the kernel
> thread and
> then it calls aac_send_shutdown which sets adapter_shutdown. The ioctl
> path checks
> adapter_shutdown then allows the ioctl to proceed so is there still a window
> where someone
> can get past the checks and restart the kernel thread? To me it looks likely it's
> a very small
> window but it still appears to be there because you don't prevent ioctl calls
> from continuing
> until after you've stopped the kernel thread. It seems as though
> adapter_shutdown needs to
> get set at the very start of __aac_shutdown as well to prevent any more
> requests from
> being queued when __aac_shutdown gets called.

I agree aac_send_shutdown needs to be called first thing in 
__aac_shutdown, to prevent ioctls from coming through.
 

> Also since one CPU may be setting the value of adapter_shutdown when
> another one is
> reading it and you don't use any kind of lock to control access to the value are
> you going to
> have SMP coherency issues with the value of adapter_shutdown? That is you
> read it as 0
> because the CPU that changed it to 1 has it in a register and hasn't stored it
> yet. For example
> in the ioctl checking case:
> 
> static long aac_cfg_ioctl(struct file *file,
>                 unsigned int cmd, unsigned long arg)
> {
>         int ret;
>         struct aac_dev *aac;
>         aac = (struct aac_dev *)file->private_data;
>         if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
>                 return -EPERM;
>         mutex_lock(&aac_mutex);
>         ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
>         mutex_unlock(&aac_mutex);
> 
>         return ret;
> }
> 
> It could be loaded speculatively and you don't know for sure that it's value is
> correct at
> the time you do the test.

Yes, that is true, I think making aac->adapter_shutdown as  atomic variable will 
Prevent SMP coherency issues.

I will make the necessary changes and resubmit this series.

Thank you very much for your Feedback Shane.

Regards,
Raghava Aditya

> Thanks
> Shane
