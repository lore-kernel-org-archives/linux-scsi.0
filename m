From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 10/18] qla2xxx: prevent bounds-check bypass via
 speculative execution
Date: Thu, 11 Jan 2018 14:15:12 -0800
Message-ID: <CAPcyv4jQjwa5X6ctO7bU1Z3hfRGRTa6gDO3pSSo_HQHkjg4MFg@mail.gmail.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520104838.32271.7038801336240727574.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180106090322.GF4380@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20180106090322.GF4380@kroah.com>
Sender: linux-arch-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Netdev <netdev@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Alan Cox <alan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 6, 2018 at 1:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jan 05, 2018 at 05:10:48PM -0800, Dan Williams wrote:
>> Static analysis reports that 'handle' may be a user controlled value
>> that is used as a data dependency to read 'sp' from the
>> 'req->outstanding_cmds' array.  In order to avoid potential leaks of
>> kernel memory values, block speculative execution of the instruction
>> stream that could issue reads based on an invalid value of 'sp'. In this
>> case 'sp' is directly dereferenced later in the function.
>
> I'm pretty sure that 'handle' comes from the hardware, not from
> userspace, from what I can tell here.  If we want to start auditing
> __iomem data sources, great!  But that's a bigger task, and one I don't
> think we are ready to tackle...

I think it falls in the hygiene bucket of shutting off an array index
from a source that could be under attacker control. Should we leave
this one un-patched while we decide if we generally have a problem
with trusting completion 'tags' from hardware? My vote is patch it for
now.
