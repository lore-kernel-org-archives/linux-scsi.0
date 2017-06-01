From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: [ufs]: [scsi]: BUG: spinlock recursion on CPU#4
Date: Thu, 1 Jun 2017 12:28:02 +0530
Message-ID: <bd79226b-833c-f53b-f92a-0c4ebffeb1ee@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "linux-arm-msm@vger.kernel.org; linux-kernel@vger.kernel.org; subhashj"@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

Recently, I came across an issue with the below call stack.

-000|arch_counter_get_cntvct(inline)
-000|__delay()
-001|__const_udelay(?)
-002|msm_trigger_wdog_bite()
-003|spin_dump(inline)
-003|spin_bug(lock = ?, ?)
-004|current_thread_info(inline)
-004|debug_spin_lock_before(inline)
-004|do_raw_spin_lock()
-005|raw_spin_lock_irqsave(lock = ?)
-006|blk_end_bidi_request(inline)
-006|blk_end_request_all(rq = ?, error = 0) <-- this tries to acquire 
the lock acquired by blk_delay_work (-024) and spinbug recursion occurs

-007|dm_end_request(clone = ?, error = 0)
-008|dm_done(inline)
-008|dm_softirq_done()
-009|blk_done_softirq()
-010|__read_once_size(inline)
-010|static_key_count(inline)
-010|static_key_false(inline)
-010|trace_softirq_exit(inline)
-010|__do_softirq()
-011|do_softirq_own_stack(inline)
-011|invoke_softirq(inline) <-- softirq is triggered because 
scsi_request_fn (-016) enabled interrupts on this cpu

-011|irq_exit()
-012|handle_IPI()
-013|gic_handle_irq()
-014|el1_irq(asm)
  -->|exception
-015|__raw_spin_unlock_irq(inline)
-015|raw_spin_unlock_irq(lock = ?)
-016|scsi_request_fn() <-- Unlocks the queue using spin_unlock, doesn't 
restore the flags, thus enabling the interrupts

-017|__blk_run_queue_uncond(inline)
-017|__blk_run_queue(q = ?)
-018|__elv_add_request()
-019|blk_insert_cloned_request() <-- acquires the queue lock & saves the 
flags

-020|dm_dispatch_clone_request(clone = ?, rq = ?)
-021|map_request()
-022|dm_request_fn()
-023|__blk_run_queue_uncond(inline)
-023|__blk_run_queue
-024|spin_unlock_irq(inline)
-024|blk_delay_work(?) <-- also acquires a queue lock, but this is a 
different queue, blk_end_request_all will reference this queue

-025|__read_once_size(inline)
-025|static_key_count(inline)
-025|static_key_false(inline)
-025|trace_workqueue_execute_end(inline)
-025|process_one_work()
-026|worker_thread()
-027|kthread()
-028|ret_from_fork(asm)
  ---|end of frame

Please can you check if this is actually a bug and my understanding is 
correct.
If so, I can put up a patch for the same.

-- 
Asutosh Das (asd)

Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
