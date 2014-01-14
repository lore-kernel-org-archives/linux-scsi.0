From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND v2 0/2] Hard disk S3 resume time optimization
Date: Tue, 14 Jan 2014 13:45:03 -0800
Message-ID: <20140114214503.GA1260@linux.intel.com>
References: <20140108005500.GA29556@linux.intel.com>
 <CAMHSBOXzU3Y=oH1Nzxash0wJvuc6Y9hoOcbvdstyOaO77QQLkA@mail.gmail.com>
 <20140114144325.GC12131@htj.dyndns.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63015 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaANVpV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jan 2014 16:45:21 -0500
Content-Disposition: inline
In-Reply-To: <20140114144325.GC12131@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Gwendal Grignou <gwendal@google.com>, Jej B <James.Bottomley@hansenpartnership.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, Jan 14, 2014 at 09:43:25AM -0500, Tejun Heo wrote:
> Hello, Gwendal.
> 
> On Mon, Jan 13, 2014 at 04:36:52PM -0800, Gwendal Grignou wrote:
> > Won't this patch defeat staggered spinup at resume? If you have a jbod
> > with a smallish power supply, with a 12V rail designed for the steady
> > state and 1 or 2 devices spinning up at once, you may be in trouble
> > when all the disks will want to spinup in same second.
> 
> Yeah, I think it would.  We never fully solved the staggered spinup
> problem and it probably is too late to invest into proper mechanism
> for that.  I think an easy workaround would be, say, have a kernel
> param which limits the max number of concurrent async wakeups and set
> the value to something reasonable - say, 2, which should give us most
> of benefits of async wakeup in vast majority of cases while avoiding
> blowing up PSUs on larger setups.

Does my patch actually have any affect on staggered spinup? I see that when
the HOST_CAP_SSS flag is detected it causes a PORT_CMD_SPIN_UP to be issued
during each port's resume. But the port resume calls themselves appear to
always be asynchronous, regardless of my patch's changes. (The ata_port
devices all have their power.async_suspend flags set, so the dpm_resume
call issues them all in parallel) So as far as I can tell I don't think 
I'm causing any harm.

I do see how my patch might hinder future attempts at staggered resume
handling, since it would effectively render the power.async_suspend flag
useless. Would it be wise for ata_port_resume to check the ata_port's 
power.async_suspend flag and only use asynchronous ata_port_request_pm 
if it's enabled?

> 
> Thanks.
> 
> -- 
> tejun
