From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RESEND v2 0/2] Hard disk S3 resume time optimization
Date: Tue, 14 Jan 2014 09:43:25 -0500
Message-ID: <20140114144325.GC12131@htj.dyndns.org>
References: <20140108005500.GA29556@linux.intel.com>
 <CAMHSBOXzU3Y=oH1Nzxash0wJvuc6Y9hoOcbvdstyOaO77QQLkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMHSBOXzU3Y=oH1Nzxash0wJvuc6Y9hoOcbvdstyOaO77QQLkA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: todd.e.brandt@linux.intel.com, Jej B <James.Bottomley@hansenpartnership.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Gwendal.

On Mon, Jan 13, 2014 at 04:36:52PM -0800, Gwendal Grignou wrote:
> Won't this patch defeat staggered spinup at resume? If you have a jbod
> with a smallish power supply, with a 12V rail designed for the steady
> state and 1 or 2 devices spinning up at once, you may be in trouble
> when all the disks will want to spinup in same second.

Yeah, I think it would.  We never fully solved the staggered spinup
problem and it probably is too late to invest into proper mechanism
for that.  I think an easy workaround would be, say, have a kernel
param which limits the max number of concurrent async wakeups and set
the value to something reasonable - say, 2, which should give us most
of benefits of async wakeup in vast majority of cases while avoiding
blowing up PSUs on larger setups.

Thanks.

-- 
tejun
