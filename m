From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Wed, 23 May 2012 17:00:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231657540.1248-100000@iolanthe.rowland.org>
References: <20120523.140451.386112705611304887.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120523.140451.386112705611304887.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dan.j.williams@intel.com, JBottomley@Parallels.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 May 2012, David Miller wrote:

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
> >     
> >     sd injects and synchronizes probe work on the global kernel-wide domain.
> >     This runs into conflict with PM that wants to perform resume actions in
> >     async context:

...

> >     Provide a 'scsi_sd_probe_domain' so that async probe actions actions can
> >     be flushed without regard for the state of PM, and allow for the resume
> >     path to handle devices that have transitioned from SDEV_QUIESCE to
> >     SDEV_DEL prior to resume.

Does reverting just the part of the commit that touches scsi_lib.c make 
any difference?

If not, does leaving that part in and reverting all the rest of the 
commit make any difference?

Alan Stern
