From: Steven Rostedt <srostedt@redhat.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 14:09:19 -0500
Message-ID: <1232132959.21980.103.camel@localhost.localdomain>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
	 <1232043287.21980.65.camel@localhost.localdomain>
	 <496F8421.3070703@novell.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com>
	 <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB45B@azsmsx501.amr.corp.intel.com>
	 <4970CE79.1080002@novell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43653 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763486AbZAPTKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 14:10:01 -0500
In-Reply-To: <4970CE79.1080002@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gregory Haskins <ghaskins@novell.com>
Cc: "Ma, Chinang" <chinang.ma@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>


On Fri, 2009-01-16 at 13:14 -0500, Gregory Haskins wrote:
> Ma, Chinang wrote:
> > Gregory. 
> > I will test the resched-ipi instrumentation patch with our OLTP if you can post the patch and some instructions.
> > Thanks,
> > -Chinang
> >   
> 
> Hi Chinang,
>   Please find a patch attached which applies to linus.git as of today. 
> You will also want to enable CONFIG_FUNCTION_TRACER as well as the trace
> components.  Here is my system:
> 

I don't see why CONFIG_FUNCTION_TRACER is needed.

> ghaskins@dev:~/sandbox/git/linux-2.6-rt> grep TRACE .config
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_TRACEPOINTS=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_PREEMPT_RCU_TRACE is not set
> CONFIG_X86_PTRACE_BTS=y
> # CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_SOUND_TRACEINIT=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_HW_BRANCH_TRACER=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_SYSPROF_TRACER=y
> CONFIG_SCHED_TRACER=y

This CONFIG_SCHED_TRACER should be enough.

-- Steve

> CONFIG_CONTEXT_SWITCH_TRACER=y
> # CONFIG_BOOT_TRACER is not set
> # CONFIG_TRACE_BRANCH_PROFILING is not set
> CONFIG_POWER_TRACER=y
> CONFIG_STACK_TRACER=y
> CONFIG_HW_BRANCH_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_KVM_TRACE is not set
> 
> 
> Then on your booted system, do:
> 
> echo sched_switch > /sys/kernel/debug/tracing/current_tracer
> echo 1 > /sys/kernel/debug/tracing/tracing_enabled
> $run_oltp && echo 0 > /sys/kernel/debug/tracing/tracing_enabled
> 
> (where $run_oltp is your suite)
> 
> Then, email the contents of /sys/kernel/debug/tracing/trace to me
> 
> -Greg
> 

