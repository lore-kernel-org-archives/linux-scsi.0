From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Wed, 17 May 2017 17:01:53 +0200
Message-ID: <20170517150153.2eamcjtc4frx2cae@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170504174427.6hebbnqwfgems6dg@linutronix.de>
 <yq1inlass3y.fsf@oracle.com>
 <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local>
 <1494343100.2688.34.camel@linux.vnet.ibm.com>
 <alpine.OSX.2.00.1705121149580.1329@n6024mn55p0yw1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:46377 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdEQPCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 11:02:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1705121149580.1329@n6024mn55p0yw1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On 2017-05-12 11:55:52 [-0400], Chad Dupuis wrote:
> Ok, I believe I've found the issue here.  The machine that the test has 
> performed on had many more possible CPUs than active CPUs.  We calculate 
> which CPU to the work time on in bnx2fc_process_new_cqes() like this:
> 
> unsigned int cpu = wqe % num_possible_cpus();
> 
> Since not all CPUs are active, we were trying to schedule work on 
> non-active CPUs which meant that the upper layers were never notified of 
> the completion.  With this change:
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c 
> b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> index c2288d6..6f08e43 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -1042,7 +1042,12 @@ static int bnx2fc_process_new_cqes(struct 
> bnx2fc_rport *tgt)
>                         /* Pending work request completion */
>                         struct bnx2fc_work *work = NULL;
>                         struct bnx2fc_percpu_s *fps = NULL;
> -                       unsigned int cpu = wqe % num_possible_cpus();
> +                       unsigned int cpu = wqe % num_active_cpus();
> +
> +                       /* Sanity check cpu to make sure it's online */
> +                       if (!cpu_active(cpu))
> +                               /* Default to CPU 0 */
> +                               cpu = 0;
>  
>                         work = bnx2fc_alloc_work(tgt, wqe);
>                         if (work) {
> 
> The issue is fixed.
> 
> Sebastian, can you add this change to your patch set?

Are sure that you can reliably reproduce the issue and fix it with the
patch above? Because this patch:

diff --git a/init/main.c b/init/main.c
index b0c11cbf5ddf..483a971b1fd2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -997,6 +997,12 @@ static int __ref kernel_init(void *unused)
              "See Linux Documentation/admin-guide/init.rst for guidance.");
 }
 
+static void workfn(struct work_struct *work)
+{
+       pr_err("%s() %d\n", __func__, raw_smp_processor_id());
+}
+static DECLARE_WORK(work, workfn);
+
 static noinline void __init kernel_init_freeable(void)
 {
        /*
@@ -1040,6 +1046,15 @@ static noinline void __init kernel_init_freeable(void)
 
        (void) sys_dup(0);
        (void) sys_dup(0);
+       {
+
+               cpu_down(3);
+               pr_err("%s() num possible: %d\n", __func__, num_possible_cpus());
+               pr_err("%s() num online  : %d\n", __func__, num_online_cpus());
+               pr_err("%s() 3 active    : %d\n", __func__, cpu_active(3));
+               schedule_work_on(3, &work);
+               ssleep(5);
+       }
        /*
         * check if there is an early userspace init.  If yes, let it do all
         * the work

produces this output:
[    1.960313] Unregister pv shared memory for cpu 3
[    1.997000] kernel_init_freeable() num possible: 8
[    1.998073] kernel_init_freeable() num online  : 7
[    1.999125] kernel_init_freeable() 3 active    : 0
[    2.000337] workfn() 1

which means, CPU3 is offline and work runs on CPU1 instead. So it does
already what you suggest except that chances are, that it is not run on
CPU0 in this case (but on another CPU).

So it either takes some time for wait_for_completion(&io_req->tm_done);
to come back _or_ there is a leak somewhere where a complete() is
somehow missing / racing against something.

Sebastian
