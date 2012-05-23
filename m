From: James Bottomley <jejbbe@hansenpartnership.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Wed, 23 May 2012 23:56:10 +0100
Message-ID: <1337813770.3013.37.camel@dabdike.int.hansenpartnership.com>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
	 <20120522.151217.278388169416093561.davem@davemloft.net>
	 <alpine.SOC.1.00.1205231945480.12326@math.ut.ee>
	 <20120523.140451.386112705611304887.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120523.140451.386112705611304887.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dan.j.williams@intel.com, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-23 at 14:04 -0400, David Miller wrote:
> From: Meelis Roos <mroos@linux.ee>
> Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)
> 
> CC:'ing interested parties.
> 
> >> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> >> > them work (including 3 different sparc64 machines with real scsi disks), 
> >> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> >> > is recognized but no partitions. 3.3.0 works fine, as did something 
> >> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> >> > yet since I have none with remote console at the moment.
> >> 
> >> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
> >> possibility could be the sparc64 NOBOOTMEM conversion that went into
> >> the merge window.
> > 
> > Bisecting leads to this commit:
> > 
> > a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
> > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > Author: Dan Williams <dan.j.williams@intel.com>
> > Date:   Thu Mar 22 17:05:11 2012 -0700
> > 
> >     [SCSI] sd: limit the scope of the async probe domain

My theory is that this is an init problem: The assumption in a lot of
our code is that async_synchronize_full() waits for everything ... even
the domain specific async schedules, which isn't true.

The code in init that makes this assumption is wait_for_device_probe().
There's also a fun async_synchronize_full() in init_post() that assumes
it can free the init memory after, which would fail badly if anything in
init used an async domain.

So either we fix the assumptions or we can't use domain specific async
schedules.

James
