From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Sat, 27 Dec 2008 12:20:55 +0100
Message-ID: <20081227112055.GB18819@elte.hu>
References: <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net> <20081211210917.GB27010@uranus.ravnborg.org> <4942BA85.3070408@vlnb.net> <1229118607.24995.18.camel@localhost.localdomain> <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com> <494A37E9.5000009@vlnb.net> <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com> <495137F4.9010404@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:37806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYL0LVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2008 06:21:38 -0500
Content-Disposition: inline
In-Reply-To: <495137F4.9010404@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


* Vladislav Bolkhovitin <vst@vlnb.net> wrote:

>> The word graph is actually here to explain here that we not only trace 
>> each function call but we can actually retrieve all of the call path of 
>> a function and then draw it as if it was C code:
>>
>>  0) ! 108.528 us  |            }
>>  0)               |            irq_exit() {
>>  0)               |              do_softirq() {
>>  0)               |                __do_softirq() {
>>  0)   0.895 us    |                  __local_bh_disable();
>>  0)               |                  run_timer_softirq() {
>>  0)   0.827 us    |                    hrtimer_run_pending();
>>  0)   1.226 us    |                    _spin_lock_irq();
>>  0)               |                    _spin_unlock_irq() {
>>  0)   6.550 us    |                  }
>>  0)   0.924 us    |                  _local_bh_enable();
>>  0) + 12.129 us   |                }
>>  0) + 13.911 us   |              }
>>  0)   0.707 us    |              idle_cpu();
>>  0) + 17.009 us   |            }
>>  0) ! 137.419 us  |          }
>>  0)   <========== |
>>  0)   1.045 us    |          }
>>  0) ! 148.908 us  |        }
>>  0) ! 151.022 us  |      }
>>  0) ! 153.022 us  |    }
>>  0)   0.963 us    |    journal_mark_dirty();
>>  0)   0.925 us    |    __brelse();
>
> Unfortunately, it lacks very useful "TASK-PID, CPU#, TIMESTAMP" header 
> fields..

those obscure readability in the typical usecases, but you can get them 
anytime via using this existing trace_options runtime switch:

  echo funcgraph-proc > /debug/tracing/trace_options 

resulting in traces like this:

# CPU TASK/PID     OVERHEAD/DURATION            FUNCTION CALLS
# |   |      |              |                   |   |   |   |
 ------------------------------------------
  0) distccd-28400  =>   cc1-30212
 ------------------------------------------

  0)   cc1-30212    |   0.270 us    |    }
  0)   cc1-30212    |               |    __do_fault() {
  0)   cc1-30212    |               |      filemap_fault() {
  0)   cc1-30212    |               |        find_lock_page() {
  0)   cc1-30212    |   0.453 us    |          find_get_page();
  0)   cc1-30212    |   0.997 us    |        }
  0)   cc1-30212    |               |        PageUptodate() {
  0)   cc1-30212    |   0.266 us    |          constant_test_bit();
  0)   cc1-30212    |   0.799 us    |        }
  0)   cc1-30212    |   0.379 us    |        mark_page_accessed();
  0)   cc1-30212    |   3.275 us    |      }
  0)   cc1-30212    |   0.276 us    |      _spin_lock();
  0)   cc1-30212    |   0.389 us    |      page_add_file_rmap();
  0)   cc1-30212    |               |      unlock_page() {
  0)   cc1-30212    |   0.266 us    |        page_waitqueue();
  0)   cc1-30212    |   0.381 us    |        __wake_up_bit();
  0)   cc1-30212    |   1.442 us    |      }
  0)   cc1-30212    |   6.897 us    |    }
  0)   cc1-30212    |+ 11.663 us    |  }
  0)   cc1-30212    |               |  up_read() {
  0)   cc1-30212    |   0.280 us    |    _spin_lock_irqsave();

Thanks,

	Ingo
