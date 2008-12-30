From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Tue, 30 Dec 2008 22:03:04 +0100
Message-ID: <20081230210303.GB6151@nowhere>
References: <20081211210917.GB27010@uranus.ravnborg.org> <4942BA85.3070408@vlnb.net> <1229118607.24995.18.camel@localhost.localdomain> <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com> <494A37E9.5000009@vlnb.net> <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com> <495137F4.9010404@vlnb.net> <20081227112055.GB18819@elte.hu> <495A56A8.1030208@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:1591 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYL3VDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 16:03:10 -0500
Content-Disposition: inline
In-Reply-To: <495A56A8.1030208@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Tue, Dec 30, 2008 at 08:13:12PM +0300, Vladislav Bolkhovitin wrote:
> Ingo Molnar, on 12/27/2008 02:20 PM wrote:
>> * Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>
>>>> The word graph is actually here to explain here that we not only 
>>>> trace each function call but we can actually retrieve all of the 
>>>> call path of a function and then draw it as if it was C code:
>>>>
>>>>  0) ! 108.528 us  |            }
>>>>  0)               |            irq_exit() {
>>>>  0)               |              do_softirq() {
>>>>  0)               |                __do_softirq() {
>>>>  0)   0.895 us    |                  __local_bh_disable();
>>>>  0)               |                  run_timer_softirq() {
>>>>  0)   0.827 us    |                    hrtimer_run_pending();
>>>>  0)   1.226 us    |                    _spin_lock_irq();
>>>>  0)               |                    _spin_unlock_irq() {
>>>>  0)   6.550 us    |                  }
>>>>  0)   0.924 us    |                  _local_bh_enable();
>>>>  0) + 12.129 us   |                }
>>>>  0) + 13.911 us   |              }
>>>>  0)   0.707 us    |              idle_cpu();
>>>>  0) + 17.009 us   |            }
>>>>  0) ! 137.419 us  |          }
>>>>  0)   <========== |
>>>>  0)   1.045 us    |          }
>>>>  0) ! 148.908 us  |        }
>>>>  0) ! 151.022 us  |      }
>>>>  0) ! 153.022 us  |    }
>>>>  0)   0.963 us    |    journal_mark_dirty();
>>>>  0)   0.925 us    |    __brelse();
>>> Unfortunately, it lacks very useful "TASK-PID, CPU#, TIMESTAMP" 
>>> header fields..
>>
>> those obscure readability in the typical usecases, but you can get them 
>> anytime via using this existing trace_options runtime switch:
>>
>>   echo funcgraph-proc > /debug/tracing/trace_options 
>>
>> resulting in traces like this:
>>
>> # CPU TASK/PID     OVERHEAD/DURATION            FUNCTION CALLS
>> # |   |      |              |                   |   |   |   |
>>  ------------------------------------------
>>   0) distccd-28400  =>   cc1-30212
>>  ------------------------------------------
>>
>>   0)   cc1-30212    |   0.270 us    |    }
>>   0)   cc1-30212    |               |    __do_fault() {
>>   0)   cc1-30212    |               |      filemap_fault() {
>>   0)   cc1-30212    |               |        find_lock_page() {
>>   0)   cc1-30212    |   0.453 us    |          find_get_page();
>>   0)   cc1-30212    |   0.997 us    |        }
>>   0)   cc1-30212    |               |        PageUptodate() {
>>   0)   cc1-30212    |   0.266 us    |          constant_test_bit();
>>   0)   cc1-30212    |   0.799 us    |        }
>>   0)   cc1-30212    |   0.379 us    |        mark_page_accessed();
>>   0)   cc1-30212    |   3.275 us    |      }
>>   0)   cc1-30212    |   0.276 us    |      _spin_lock();
>>   0)   cc1-30212    |   0.389 us    |      page_add_file_rmap();
>>   0)   cc1-30212    |               |      unlock_page() {
>>   0)   cc1-30212    |   0.266 us    |        page_waitqueue();
>>   0)   cc1-30212    |   0.381 us    |        __wake_up_bit();
>>   0)   cc1-30212    |   1.442 us    |      }
>>   0)   cc1-30212    |   6.897 us    |    }
>>   0)   cc1-30212    |+ 11.663 us    |  }
>>   0)   cc1-30212    |               |  up_read() {
>>   0)   cc1-30212    |   0.280 us    |    _spin_lock_irqsave();
>
> This view is OK for us, I can suggest only two things:
>
> 1. Add an option to disable "OVERHEAD/DURATION", it isn't needed in our  
> case of SCSI commands processing troubleshooting, hence would only hurt  
> readability and (I guess) add not needed overhead.


You can disable the overhead but not yet the duration.
But it's on my TODO list and should be available for 2.6.30


> 2. If possible, make the view more compact, i.e. with less spaces on  
> each line. Our tracing lines can be quite long.
>
> Thanks,
> Vlad
>

I'm not sure... The spaces are mostly here to keep fixed width columns, 
in case we have huge durations, or long cmdlines...

