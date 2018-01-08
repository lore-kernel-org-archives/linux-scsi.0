From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
Date: Mon, 8 Jan 2018 11:08:36 +0100
Message-ID: <20180108100836.GF3040@hirez.programming.kicks-ass.net>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87y3lbpvzp.fsf@xmission.com>
 <CAPcyv4hVisGeXbTH985Hb6dkYKA9Sr8wwZHudNF-CtH0=ADFug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hVisGeXbTH985Hb6dkYKA9Sr8wwZHudNF-CtH0=ADFug@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alan Cox <alan.cox@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Zhang Rui <rui.zhang@intel.com>, Linux-media@vg
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 05, 2018 at 10:30:16PM -0800, Dan Williams wrote:
> On Fri, Jan 5, 2018 at 6:22 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > In at least one place (mpls) you are patching a fast path.  Compile out
> > or don't load mpls by all means.  But it is not acceptable to change the
> > fast path without even considering performance.
> 
> Performance matters greatly, but I need help to identify a workload
> that is representative for this fast path to see what, if any, impact
> is incurred. Even better is a review that says "nope, 'index' is not
> subject to arbitrary userspace control at this point, drop the patch."

I think we're focussing a little too much on pure userspace. That is, we
should be saying under the attackers control. Inbound network packets
could equally be under the attackers control.

Sure, userspace is the most direct and highest bandwidth one, but I
think we should treat all (kernel) external values with the same
paranoia.
