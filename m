From: Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Fri, 12 Dec 2008 16:50:07 -0500
Message-ID: <1229118607.24995.18.camel@localhost.localdomain>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
	 <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>  <4942BA85.3070408@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44213 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbYLLVyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 16:54:43 -0500
In-Reply-To: <4942BA85.3070408@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, fweisbec <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>


(Added Ingo and Frederic)

On Fri, 2008-12-12 at 22:24 +0300, Vladislav Bolkhovitin wrote: 
> Sam Ravnborg wrote:
> >>>>  drivers/scst/scst_lib.c      | 3689 
> >>>>  +++++++++++++++++++++++++++++++++++++
> >>>>  drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
> >>>>  drivers/scst/scst_module.c   |   69
> >>>>  drivers/scst/scst_priv.h     |  513 +++++
> >>>>  drivers/scst/scst_targ.c     | 5458 
> >>>>  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  8 files changed, 12435 insertions(+)
> >>> There was a lot af TRACE_ENTRY() / TRACE_EXIT() noise.
> >>> We should have proper tools for that by now (I hope).
> >> Sorry, I don't see such tools with, for instance, a possibility to be 
> >> compiled out in non-debug builds.
> >>
> >> From one side, I can agree, those TRACE_ENTRY()/TRACE_EXIT() statements 
> >> *may* look like a noise (I personally don't notice them), but, from 
> >> other side, in past times they have proved how usable they are. If an 
> >> SCST user has a problem, I simply ask him to make a debug build, then 
> >> enable entry_exit and some other logging levels, then reproduce the 
> >> problem and send me the logs. Then in most cases I can see what's wrong 
> >> and provide a fix without additional actions and questions.
> > 
> > I had ftrace in mind but it has not hit mainline yet.

I'm assuming you are talking about previous kernels. ftrace is in
2.6.27, and dynamic ftrace is back in 2.6.28-rcX

> > But will do before this patchset does.
> 
> Unfortunately, ftrace at the moment can't fully replace 
> TRACE_ENTRY()/TRACE_EXIT() statements, because it lacks:
> 
> 1. Doing trace in only some modules or source files. Noise from tracing 
> of the whole kernel is not needed if we investigate problem in only one 
> module (SCST in this case)

With dynamic ftrace you can pick and choose the what functions you want
to trace. 2.6.28 will not have the exit tracing, but 2.6.29 will (see
linux-tip for latest ftrace)

Here, for current 2.6.28, I can do:

# awk '$2=="t" && $4=="[e1000]" { print $3; }' \
   /proc/kallsyms  > /debug/tracing/set_ftrace_filter

and now only the e1000 functions will be traced.

# echo function > /debug/tracing/current_tracer

[root@bxrhel51 ~]# cat /debug/tracing/trace |head
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            sshd-3411  [000]   567.748887: e1000_xmit_frame <-dev_hard_start_xmit
            sshd-3411  [000]   567.748890: e1000_maybe_stop_tx <-e1000_xmit_frame
            sshd-3411  [000]   567.748893: e1000_maybe_stop_tx <-e1000_xmit_frame
          <idle>-0     [000]   567.748943: e1000_intr <-handle_IRQ_event
          <idle>-0     [000]   567.748948: e1000_clean <-net_rx_action
          <idle>-0     [000]   567.748949: e1000_unmap_and_free_tx_resource <-e1000_clean


I can pick any function I want to trace. The list of available functions
to trace is in /debug/tracing/available_filter_functions.


> .
> 
> 2. Ability to inject own messages in the output stream. It's needed to 
> have synchronized stream of output messages about both functions tracing 
> and what those functions doing. For instance:
> 
> entry in func1()
> adding cmd C to list L
> exit from func1()

Is this from within the driver?

By adding this simply patch:

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 872799b..b198dac 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -29,6 +29,8 @@
 #include "e1000.h"
 #include <net/ip6_checksum.h>
 
+#include <linux/ftrace.h>
+
 char e1000_driver_name[] = "e1000";
 static char e1000_driver_string[] = "Intel(R) PRO/1000 Network Driver";
 #define DRV_VERSION "7.3.20-k3-NAPI"
@@ -3810,6 +3812,8 @@ static int e1000_clean(struct napi_struct *napi, int budget)
 	if (tx_cleaned)
 		work_done = budget;
 
+	ftrace_printk("adapter is %p work_done: %d\n", adapter, work_done);
+
 	/* If budget not fully consumed, exit the polling mode */
 	if (work_done < budget) {
 		if (likely(adapter->itr_setting & 3))


I could do:

# awk '$2=="t" && $4=="[e1000]" { print $3; }' \
  /proc/kallsyms  > /debug/tracing/set_ftrace_filter
# echo 0 > /debug/tracing/tracing_enabled
# echo ftrace_printk > /debug/tracing/iter_ctrl
# echo function > /debug/tracing/current_tracer
# echo 1 > /debug/tracing/tracing_enabled
[wait]
# echo 0 > /debug/tracing/tracing_enabled
# cat /debug/tracing/trace | head
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            bash-3393  [000]   469.809904: e1000_clean_rx_irq <-e1000_clean
            bash-3393  [000]   469.809939: e1000_alloc_rx_buffers <-e1000_clean_rx_irq
            bash-3393  [000]   469.809940: e1000_check_64k_bound <-e1000_alloc_rx_buffers
            bash-3393  [000]   469.809945: e1000_clean: adapter is ffff88003d13a900 work_done: 64
            bash-3393  [000]   469.809946: e1000_clean <-net_rx_action



Note in 2.6.29 (and current tip): s/iter_ctrl/tracing_options/



> 
> Otherwise there would be 2 traces:
> 
> entry in func1()
> exit from func1()
> 
> and
> 
> adding cmd C to list L
> 
> which almost impossible to merge to analyze.

Perhaps you need to do it from userspace?

# echo 1 > /debug/tracing/tracing_enabled ; \
 echo hi > /debug/tracing/trace_marker ; \
 sleep 1 ; \
 echo bye > /debug/tracing/trace_marker ; \
 echo 0 > /debug/tracing/tracing_enabled 
# cat /debug/tracing/trace
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            bash-3393  [003]  1068.636510: 0: hi
          <idle>-0     [002]  1069.039891: e1000_intr <-handle_IRQ_event
          <idle>-0     [002]  1069.039898: e1000_clean <-net_rx_action
          <idle>-0     [002]  1069.039901: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [002]  1069.039950: e1000_alloc_rx_buffers <-e1000_clean_rx_irq
          <idle>-0     [002]  1069.039951: e1000_check_64k_bound <-e1000_alloc_rx_buffers
          <idle>-0     [002]  1069.039952: e1000_update_itr <-e1000_clean
[...]
          <idle>-0     [002]  1069.487184: e1000_intr <-handle_IRQ_event
          <idle>-0     [002]  1069.487190: e1000_clean <-net_rx_action
          <idle>-0     [002]  1069.487191: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [002]  1069.487192: e1000_update_itr <-e1000_clean
          <idle>-0     [002]  1069.487192: e1000_update_itr <-e1000_clean
            bash-3393  [003]  1069.638193: 0: bye



> 
> (Steven Rostedt added on CC)

Thanks.

-- Steve


