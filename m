From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Tue, 18 Oct 2011 17:45:42 +0200
Message-ID: <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
References: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
 <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <4E96E2FF.6070601@linux.vnet.ibm.com>
 <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>
 <4E9BEB68.1050707@ce.jp.nec.com>
 <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
 <4E9D7FA8.9000000@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E9D7FA8.9000000@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2011 at 10:31:20PM +0900, Jun'ichi Nomura wrote:
> On 10/17/11 23:06, James Bottomley wrote:
> > On Mon, 2011-10-17 at 17:46 +0900, Jun'ichi Nomura wrote:
> >> On 10/15/11 01:03, James Bottomley wrote:
> >>> On Thu, 2011-10-13 at 15:09 +0200, Steffen Maier wrote:
> >>>> Initially, we encountered use-after-free bugs in
> >>>> scsi_print_command / scsi_dispatch_cmd
> >>>> http://marc.info/?l=linux-scsi&m=130824013229933&w=2
> >>
> >> It is interesting that both this and the older report
> >> got oopsed in scsi_log_send(), while there are other
> >> dereferences of 'cmd' around scsi_dispatch_cmd().
> >> Are there any reason they are special? Just by accident?
> > 
> > Right, that's why it looks like the command area got freed rather than
> > the command pointer was bogus (6b is a poison free pattern).  Perhaps if
> > the reporter could pin down the failing source line, we'd know better
> > what was going on?
> 
> Yeah, that might be useful.

The struct scsi_cmnd that was passed to scsi_log_send() was already freed
(contents completely 6b6b6b...).
Since SLUB debugging was turned on we can see that it was freed from
__scsi_put_command(). Not too much of a surprise.

> One remote possibility I imagined is if the submitting process
> took very long after blk_start_request until scsi_dispatch_cmd
> and timeout handler kicks in, can cmd be freed?
> 
> Also Tejun's report here could be related to possible data corruption:
>   [PATCH] block: make gendisk hold a reference to its queue
>   https://lkml.org/lkml/2011/10/16/148
> 
> Though I haven't hit the reported oops myself,
> a process closing a removed device may modify freed memory.
> And his patch will fix it.
> 
> So if the problem is easily reproducible, I think it's worth
> trying his patch to see if the problem disappear.

In addition it might be worthwhile to apply this small slub patch as well,
so that we get a full trace of the caller in the object which was freed:

---
 mm/slub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -27,6 +27,7 @@
 #include <linux/memory.h>
 #include <linux/math64.h>
 #include <linux/fault-inject.h>
+#include <linux/stacktrace.h>
 
 #include <trace/events/kmem.h>
 
@@ -191,11 +192,14 @@ static LIST_HEAD(slab_caches);
 /*
  * Tracking user of a slab.
  */
+#define SAVE_TRACE_NUM 30
 struct track {
 	unsigned long addr;	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
+	unsigned long trace[SAVE_TRACE_NUM];
+	unsigned long long stamp;
 };
 
 enum track_item { TRACK_ALLOC, TRACK_FREE };
@@ -397,10 +401,17 @@ static void set_track(struct kmem_cache
 	struct track *p = get_track(s, object, alloc);
 
 	if (addr) {
+		struct stack_trace trace = {
+			.max_entries = SAVE_TRACE_NUM,
+			.entries = p->trace,
+		};
+
 		p->addr = addr;
 		p->cpu = smp_processor_id();
 		p->pid = current->pid;
 		p->when = jiffies;
+		p->stamp = get_clock();
+		save_stack_trace(&trace);
 	} else
 		memset(p, 0, sizeof(struct track));
 }
