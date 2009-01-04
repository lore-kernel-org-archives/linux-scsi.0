From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up kernel boot
Date: Sun, 04 Jan 2009 20:05:26 +0100
Message-ID: <87k59aops9.fsf@basil.nowhere.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090104092857.5fbf6b2d@infradead.org> (Arjan van de Ven's message of "Sun, 4 Jan 2009 09:28:57 -0800")
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
> +static int async_manager_thread(void *unused)
> +{
> +	int max_threads;
> +	DECLARE_WAITQUEUE(wq, current);
> +	add_wait_queue(&async_new, &wq);
> +
> +	while (!kthread_should_stop()) {
> +		int tc, ec;
> +
> +		/*
> +		 * Maximum number of worker threads.
> +		 * Even on the smallest machine we want 8
> +		 * Scaling by 4 per logical CPU
> +		 * But no more than 256 to not overload stuff too much
> +		 * (and yes these are magic numbers that might need tuning)
> +		 * Calculated dynamic because early on the nr of online cpus
> +		 * is 1...
> +		 */
> +		max_threads = 4 + 4 * num_online_cpus();
> +		if (max_threads > 256)
> +			max_threads = 256;
> +
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		tc = atomic_read(&thread_count);
> +		rmb();
> +		ec = atomic_read(&entry_count);
> +
> +		while (tc < ec && tc < max_threads) {
> +			kthread_run(async_thread, NULL, "async/%i", tc);
> +			atomic_inc(&thread_count);
> +			tc++;
> +		}
> +
> +		schedule();

Surely the thread should die again boot up? On module load
synchronisity is usually not a problem.

Personally I think it would be better to make this more generic.
Various subsystems have thread pool implementations now, and this
is just another variant that except for the sequence stuff
isn't all that much different. So it would be better to have 
a generic worker thread manager that just supports these
barriers too.

-andi

-- 
ak@linux.intel.com
