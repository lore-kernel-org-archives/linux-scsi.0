From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Sat, 20 Dec 2008 14:06:53 +0100
Message-ID: <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
	 <20081210191213.GA15273@uranus.ravnborg.org>
	 <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <4943CAAB.4050008@vlnb.net>
	 <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
	 <494A37E9.5000009@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:40055 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYLTNGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Dec 2008 08:06:55 -0500
In-Reply-To: <494A37E9.5000009@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ingo Molnar <mingo@elte.hu>

Hi Vladislav,

2008/12/18 Vladislav Bolkhovitin <vst@vlnb.net>:
> Fr=E9d=E9ric Weisbecker, on 12/14/2008 03:35 AM wrote:
>>
>> 2008/12/13 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>
>>> Also (maybe I simply miss something) looks like ftrace doesn't trac=
e exit
>>> from functions, only entrance to them. Is it true? Is it possibly t=
o log
>>> exit from functions as well?
>>
>> That's true with 2.6.28, the function tracer traces on function entr=
ies
>> only.
>> But there is an add-on on ftrace which let one to trace on entry and
>> on return, the function
>> graph tracer. This tracer uses this facility to output a graph of
>> function calls and measure
>> the time elapsed during each function call.
>> You can also register two custom handlers to do some things you need
>> on entry and on return.
>
> Word "graph" is quite confusing. We don't need any graphs, we need a =
plain
> execution path tracing as in the attached example (this is what's cur=
rently
> done).


The word graph is actually here to explain here that we not only trace
each function call
but we can actually retrieve all of the call path of a function and
then draw it as if it was
C code:

 0) ! 108.528 us  |            }
 0)               |            irq_exit() {
 0)               |              do_softirq() {
 0)               |                __do_softirq() {
 0)   0.895 us    |                  __local_bh_disable();
 0)               |                  run_timer_softirq() {
 0)   0.827 us    |                    hrtimer_run_pending();
 0)   1.226 us    |                    _spin_lock_irq();
 0)               |                    _spin_unlock_irq() {
 0)   6.550 us    |                  }
 0)   0.924 us    |                  _local_bh_enable();
 0) + 12.129 us   |                }
 0) + 13.911 us   |              }
 0)   0.707 us    |              idle_cpu();
 0) + 17.009 us   |            }
 0) ! 137.419 us  |          }
 0)   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D |
 0)   1.045 us    |          }
 0) ! 148.908 us  |        }
 0) ! 151.022 us  |      }
 0) ! 153.022 us  |    }
 0)   0.963 us    |    journal_mark_dirty();
 0)   0.925 us    |    __brelse();


>>> All the above functionality is almost what we need. The only thing =
left,
>>> which I forgot to mention, is possibility to log also functions ret=
urn
>>> value
>>> on exit. This is what TRACE_EXIT_RES() in SCST does. Is it possible=
 to
>>> add
>>> those?
>>
>> I want to add that on the function graph tracer. That can be done
>> pretty easily. The only
>> problem comes with the type of the return value. Would this tracer b=
e
>> supposed to always
>> return a 64 bits value regardless of the real typ of the value? Ther=
e
>> would be some pointless bytes
>> on most return values. I don't know how to proceed for this problem.
>
> I think if tracer always returns machine word, as Ingo suggested, as
> "%d(%x)" it would be more then sufficient. In the rest of 0.01% of ca=
ses it
> wouldn't be hard to print a non-standard return value using ftrace_pr=
intk()
> just before returning it.
>

Yeah, I will do some tests to see if I can have a relevant result....


>>> And one more question. Is it possible to redirect ftrace tracing to
>>> serial
>>> console or any other console (netconsole?)? It can be helpful to
>>> investigate
>>> hard lockups in IRQ or with IRQs disabled.
>>>
>>> Thanks!
>>> Vlad
>>>
>>
>> I would find it useful too. I thought about something like using
>> early_printk or something like
>> that...I don't know. That would be good to redirect the output to th=
e
>> tty device of the user choice.
>
> That would make ftrace a complete debug logging subsystem.


ditto, I will try to do something to early_printk() a trace instead of
inserting into the ring buffer.
That could be a trace_option as an example.


> Dec 15 17:09:48 linux-c07e kernel: [  738.535571] [2519]: ENTRY
> dev_user_ioctl
> Dec 15 17:09:48 linux-c07e kernel: [  738.535582] [2519]:
> dev_user_ioctl:1735:REGISTER_DEVICE
> Dec 15 17:09:48 linux-c07e kernel: [  738.535589] [2519]: ENTRY
> dev_user_register_dev
> Dec 15 17:09:48 linux-c07e kernel: [  738.535601] [2519]: ENTRY
> sgv_pool_create
> Dec 15 17:09:48 linux-c07e kernel: [  738.535610] [2519]: ENTRY
> sgv_pool_init
> Dec 15 17:09:48 linux-c07e kernel: [  738.535616] [2519]:
> sgv_pool_init:997:name dev0, sizeof(*obj)=3D52, clustering_type=3D0
> Dec 15 17:09:48 linux-c07e kernel: [  738.535626] [2519]:
> sgv_pool_init:1026:pages=3D1, size=3D76
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D2, size=3D100
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D4, size=3D148
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D8, size=3D244
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D16, size=3D436
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D32, size=3D820
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D64, size=3D1588
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D128, size=3D3124
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D256, size=3D52
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D512, size=3D52
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D1024, size=3D52
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> sgv_pool_init: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> sgv_pool_create: 1
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> sgv_pool_create
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> sgv_pool_init
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:997:name dev0-clust, sizeof(*obj)=3D52, clustering_type=
=3D1
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D1, size=3D80
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D2, size=3D108
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D4, size=3D164
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D8, size=3D276
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D16, size=3D500
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D32, size=3D948
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D64, size=3D1844
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D128, size=3D3636
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D256, size=3D1076
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D512, size=3D2100
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> sgv_pool_init:1026:pages=3D1024, size=3D52
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> sgv_pool_init: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> sgv_pool_create: 1
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> __dev_user_set_opt
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> __dev_user_set_opt:2580:dev dev0, parse_type 0, on_free_cmd_type 1,
> memory_reuse_type 1, partial_transfers_type 0, partial_len 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> dev_user_setup_functions
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> dev_user_setup_functions
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> __dev_user_set_opt: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> dev_user_register_dev:2499:dev b7bffad0, name dev0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> __scst_register_virtual_dev_driver
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> scst_dev_handler_check: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: scst:
> __scst_register_virtual_dev_driver:1036:Virtual device handler dh-dev=
0 for
> type 1 registered successfully
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> __scst_register_virtual_dev_driver: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> scst_register_virtual_device
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> scst_dev_handler_check: 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> scst_suspend_activity
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> scst_suspend_activity:484:suspend_count 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY
> scst_susp_wait
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]:
> scst_susp_wait:463:wait_event() returned 0
> Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT
> scst_susp_wait: 0
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
