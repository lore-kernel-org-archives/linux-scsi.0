From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 10/18] qla2xxx: prevent bounds-check bypass via
 speculative execution
Date: Sat, 6 Jan 2018 10:03:22 +0100
Message-ID: <20180106090322.GF4380@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520104838.32271.7038801336240727574.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151520104838.32271.7038801336240727574.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, peterz@infradead.org, netdev@vger.kernel.org, qla2xxx-upstream@qlogic.com, tglx@linutronix.de, torvalds@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 05, 2018 at 05:10:48PM -0800, Dan Williams wrote:
> Static analysis reports that 'handle' may be a user controlled value
> that is used as a data dependency to read 'sp' from the
> 'req->outstanding_cmds' array.  In order to avoid potential leaks of
> kernel memory values, block speculative execution of the instruction
> stream that could issue reads based on an invalid value of 'sp'. In this
> case 'sp' is directly dereferenced later in the function.

I'm pretty sure that 'handle' comes from the hardware, not from
userspace, from what I can tell here.  If we want to start auditing
__iomem data sources, great!  But that's a bigger task, and one I don't
think we are ready to tackle...

thanks,

greg k-h
