From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 13:14:17 -0500
Message-ID: <4970CE79.1080002@novell.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>	 <20090114163557.11e097f2.akpm@linux-foundation.org>	 <20090115012147.GW29283@parisc-linux.org>	 <20090114180431.f4a96543.akpm@linux-foundation.org>	 <1232028766.5966.10.camel@localhost.localdomain>	 <20090115094442.b6394544.akpm@linux-foundation.org>	 <20090115180052.GG29283@parisc-linux.org> <1232043287.21980.65.camel@localhost.localdomain> <496F8421.3070703@novell.com> <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com> <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB45B@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig23678B990F433679EAC85FC0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36108 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936745AbZAPSL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 13:11:26 -0500
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB45B@azsmsx501.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Steven Rostedt <srostedt@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig23678B990F433679EAC85FC0
Content-Type: multipart/mixed;
 boundary="------------080709000308020607050200"

This is a multi-part message in MIME format.
--------------080709000308020607050200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ma, Chinang wrote:
> Gregory.=20
> I will test the resched-ipi instrumentation patch with our OLTP if you =
can post the patch and some instructions.
> Thanks,
> -Chinang
>  =20

Hi Chinang,
  Please find a patch attached which applies to linus.git as of today.=20
You will also want to enable CONFIG_FUNCTION_TRACER as well as the trace
components.  Here is my system:

ghaskins@dev:~/sandbox/git/linux-2.6-rt> grep TRACE .config
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_TRACEPOINTS=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_BLK_DEV_IO_TRACE=3Dy
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_X86_PTRACE_BTS=3Dy
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_SOUND_TRACEINIT=3Dy
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_NOP_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_HW_BRANCH_TRACER=3Dy
CONFIG_TRACER_MAX_TRACE=3Dy
CONFIG_FUNCTION_TRACER=3Dy
CONFIG_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_IRQSOFF_TRACER=3Dy
CONFIG_SYSPROF_TRACER=3Dy
CONFIG_SCHED_TRACER=3Dy
CONFIG_CONTEXT_SWITCH_TRACER=3Dy
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
CONFIG_POWER_TRACER=3Dy
CONFIG_STACK_TRACER=3Dy
CONFIG_HW_BRANCH_TRACER=3Dy
CONFIG_DYNAMIC_FTRACE=3Dy
CONFIG_FTRACE_MCOUNT_RECORD=3Dy
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_KVM_TRACE is not set


Then on your booted system, do:

echo sched_switch > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_enabled
$run_oltp && echo 0 > /sys/kernel/debug/tracing/tracing_enabled

(where $run_oltp is your suite)

Then, email the contents of /sys/kernel/debug/tracing/trace to me

-Greg


--------------080709000308020607050200
Content-Type: text/x-patch;
 name="instrumentation.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="instrumentation.patch"

ftrace instrumentation for RT tasks

From: Gregory Haskins <ghaskins@novell.com>

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kernel/smp.c |    2 ++
 include/linux/sched.h |    6 ++++++
 kernel/sched.c        |    3 +++
 kernel/sched_rt.c     |   10 ++++++++++
 4 files changed, 21 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index e6faa33..468abeb 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,6 +118,7 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
+	ftrace_printk("cpu %d\n", cpu);
 	send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
=20
@@ -171,6 +172,7 @@ static void native_smp_send_stop(void)
  */
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
+	ftrace_printk("NEEDS_RESCHED\n");
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..a320692 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2094,8 +2094,14 @@ static inline int test_tsk_thread_flag(struct task=
_struct *tsk, int flag)
 	return test_ti_thread_flag(task_thread_info(tsk), flag);
 }
=20
+# define ftrace_printk(fmt...) __ftrace_printk(_THIS_IP_, fmt)
+extern int
+__ftrace_printk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
 static inline void set_tsk_need_resched(struct task_struct *tsk)
 {
+	ftrace_printk("%s/%d\n", tsk->comm, tsk->pid);
 	set_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
 }
=20
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..d55fcf1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1874,6 +1874,9 @@ void set_task_cpu(struct task_struct *p, unsigned i=
nt new_cpu)
 		      *new_cfsrq =3D cpu_cfs_rq(old_cfsrq, new_cpu);
 	u64 clock_offset;
=20
+	ftrace_printk("migrate %s/%d [%d] -> [%d]\n",
+		      p->comm, p->pid, task_cpu(p), new_cpu);
+
 	clock_offset =3D old_rq->clock - new_rq->clock;
=20
 	trace_sched_migrate_task(p, task_cpu(p), new_cpu);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 954e1a8..59cf64b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1102,6 +1102,8 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
=20
+	ftrace_printk("attempting push\n");
+
  retry:
 	if (unlikely(next_task =3D=3D rq->curr)) {
 		WARN_ON(1);
@@ -1139,6 +1141,8 @@ static int push_rt_task(struct rq *rq)
 		goto out;
 	}
=20
+	ftrace_printk("%s/%d\n", next_task->comm, next_task->pid);
+
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
@@ -1180,6 +1184,8 @@ static int pull_rt_task(struct rq *this_rq)
 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
=20
+	ftrace_printk("attempting pull\n");
+
 	next =3D pick_next_task_rt(this_rq);
=20
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
@@ -1234,6 +1240,10 @@ static int pull_rt_task(struct rq *this_rq)
=20
 			ret =3D 1;
=20
+			ftrace_printk("pull %s/%d [%d] -> [%d]\n",
+				      p->comm, p->pid,
+				      src_rq->cpu, this_rq->cpu);
+
 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);

--------------080709000308020607050200--

--------------enig23678B990F433679EAC85FC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklwznkACgkQlOSOBdgZUxkTRgCeM5YiPR+fR5/jFBYmufbjUSSb
ACIAn16gqamBR6NyIp9w5vNLwk/9M4Wt
=kjU2
-----END PGP SIGNATURE-----

--------------enig23678B990F433679EAC85FC0--
