From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Thu, 22 Mar 2007 13:21:49 +0300
Message-ID: <460258BD.9080606@vlnb.net>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <460020DF.6090203@torque.net> <460099DD.2050706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:38577 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934093AbXCVKkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 06:40:09 -0400
In-Reply-To: <460099DD.2050706@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: dougg@torque.net, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br

Tejun Heo wrote:
> Hello, Douglas.
> 
> Douglas Gilbert wrote:
> 
>>Tejun,
>>I note at this point that the IMMED bit in the
>>START STOP UNIT cdb is clear. [The code might
>>note that as well.] All SCSI disks that I have
>>seen, implement the IMMED bit and according to
>>the SAT standard, so should SAT layers like the
>>one in libata.
>>
>>With the IMMED bit clear:
>>  - on spin up, it will wait until disk is ready.
>>    Okay unless there are a lot of disks, in
>>    which case we could ask Matthew Wilcox for help
>>  - on spin down, will wait until media is
>>    stopped. That could be 20 seconds, and if there
>>    were multiple disks ....
>>
>>I guess the question is do we need to wait until a
>>disk is spun down before dropping power to it
>>and suspending.
> 
> 
> I think we do.  As we're issuing SYNCHRONIZE CACHE prior to spinning
> down disks, it's probably okay to drop power early data-integrity-wise
> but still...
> 
> We can definitely use IMMED=1 during resume (needs to be throttled
> somehow tho).  This helps even when there is only one disk.  We can let
> the disk spin up in the background and proceed with the rest of resuming
> process.  Unfortunately, libata SAT layer doesn't do IMMED and even if
> it does (I've tried and have a patch available) it doesn't really work
> because during host resume each port enters EH and resets and
> revalidates each device.  Many if not most ATA harddisks don't respond
> to reset or IDENTIFY till it's fully spun up meaning libata EH has to
> wait for all drives to spin up.  libata EH runs inside SCSI EH thread
> meaning SCSI comman issue blocks till libata EH finishes resetting the
> port.  So, IMMED or not, sd gotta wait for libata disks.
> 
> If we want to do parallel spin down, PM core needs to be updated such
> that there are two events - issue and done - somewhat similar to what
> SCSI is doing to probe devices parallelly.  If we're gonna do that, we
> maybe can apply the same mechanism to resume path so that we can do
> things parallelly IMMED or not.

Seems, there is another way of doing a bank spin up / spin down: doing 
it in two passes. On the first pass START_STOP will be issued with 
IMMED=1 on all devices, then on the second pass START_STOP will be 
issued with IMMED=0. So the devices will spin up / spin down in the 
parallel, but synchronously, hence the needed result will be achieved 
with minimal code changes, although it will indeed need upper layer 
changes in struct device_driver's suspend(), resume(), etc. callers.

Vlad
