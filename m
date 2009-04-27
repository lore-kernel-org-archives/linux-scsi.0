From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 27 Apr 2009 09:02:40 +0200
Message-ID: <87ljpmk29b.fsf@basil.nowhere.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756327AbZD0HDL@vger.kernel.org>
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> (Douglas W. Styner's message of "Thu, 23 Apr 2009 09:49:57 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Styner, Douglas W" <douglas.w.styner@intel.com> writes:

>
> ======oprofile 0.9.3 CPU_CLK_UNHALTED for top 30 functions
> Cycles% 2.6.24.2                   Cycles% 2.6.30-rc2
> 74.8578 <database>                   67.6966 <database>

The dip in database cycles is indeed worrying.

> 1.0500 qla24xx_start_scsi          1.1724 qla24xx_start_scsi
> 0.8089 schedule                    1.0578 qla24xx_intr_handler
> 0.5864 kmem_cache_alloc            0.8259 __schedule
> 0.4989 __blockdev_direct_IO        0.7451 kmem_cache_alloc
> 0.4357 __sigsetjmp                 0.4872 __blockdev_direct_IO
> 0.4152 copy_user_generic_string    0.4390 task_rq_lock
> 0.3953 qla24xx_intr_handler        0.4338 __sigsetjmp

And also why the qla24xx_intr_handler became ~2.5x as expensive.
Cc linux-scsi and qla24xx maintainers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
