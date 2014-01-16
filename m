From: Gwendal Grignou <gwendal@google.com>
Subject: Re: [PATCH/RESEND v2 0/2] Hard disk S3 resume time optimization
Date: Thu, 16 Jan 2014 14:43:40 -0800
Message-ID: <CAMHSBOWBPWY=prExE9yX1O0cbejikfCcABbttge9W-9hCbv4Kg@mail.gmail.com>
References: <20140108005500.GA29556@linux.intel.com> <CAMHSBOXzU3Y=oH1Nzxash0wJvuc6Y9hoOcbvdstyOaO77QQLkA@mail.gmail.com>
 <20140114144325.GC12131@htj.dyndns.org> <20140114214503.GA1260@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:49777 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAPWoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 17:44:00 -0500
Received: by mail-qe0-f44.google.com with SMTP id 1so3294374qee.31
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2014 14:44:00 -0800 (PST)
In-Reply-To: <20140114214503.GA1260@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

You're right, staggered spinup is not enforced today when the disks
are behind several ATA ports. Only the disks behind a port multiplier
are spun up one at a time.
We are currently waiting for all the device(s) on the slowest port to
resume to continue.
Gwendal.

On Tue, Jan 14, 2014 at 1:45 PM, Todd E Brandt
<todd.e.brandt@linux.intel.com> wrote:
> On Tue, Jan 14, 2014 at 09:43:25AM -0500, Tejun Heo wrote:
>> Hello, Gwendal.
>>
>> On Mon, Jan 13, 2014 at 04:36:52PM -0800, Gwendal Grignou wrote:
>> > Won't this patch defeat staggered spinup at resume? If you have a jbod
>> > with a smallish power supply, with a 12V rail designed for the steady
>> > state and 1 or 2 devices spinning up at once, you may be in trouble
>> > when all the disks will want to spinup in same second.
>>
>> Yeah, I think it would.  We never fully solved the staggered spinup
>> problem and it probably is too late to invest into proper mechanism
>> for that.  I think an easy workaround would be, say, have a kernel
>> param which limits the max number of concurrent async wakeups and set
>> the value to something reasonable - say, 2, which should give us most
>> of benefits of async wakeup in vast majority of cases while avoiding
>> blowing up PSUs on larger setups.
>
> Does my patch actually have any affect on staggered spinup? I see that when
> the HOST_CAP_SSS flag is detected it causes a PORT_CMD_SPIN_UP to be issued
> during each port's resume. But the port resume calls themselves appear to
> always be asynchronous, regardless of my patch's changes. (The ata_port
> devices all have their power.async_suspend flags set, so the dpm_resume
> call issues them all in parallel) So as far as I can tell I don't think
> I'm causing any harm.
>
> I do see how my patch might hinder future attempts at staggered resume
> handling, since it would effectively render the power.async_suspend flag
> useless. Would it be wise for ata_port_resume to check the ata_port's
> power.async_suspend flag and only use asynchronous ata_port_request_pm
> if it's enabled?
>
>>
>> Thanks.
>>
>> --
>> tejun
