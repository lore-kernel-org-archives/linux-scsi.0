From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Thu, 18 Dec 2008 14:45:45 +0300
Message-ID: <494A37E9.5000009@vlnb.net>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>	 <20081210191213.GA15273@uranus.ravnborg.org>	 <49414DBE.6070801@vlnb.net>	 <20081211210917.GB27010@uranus.ravnborg.org>	 <4942BA85.3070408@vlnb.net>	 <1229118607.24995.18.camel@localhost.localdomain>	 <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020403000909000503050306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:54395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYLRLpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 06:45:38 -0500
In-Reply-To: <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ingo Molnar <mingo@elte.hu>

This is a multi-part message in MIME format.
--------------020403000909000503050306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Frédéric Weisbecker, on 12/14/2008 03:35 AM wrote:
> 2008/12/13 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Also (maybe I simply miss something) looks like ftrace doesn't trace exit
>> from functions, only entrance to them. Is it true? Is it possibly to log
>> exit from functions as well?
> 
> That's true with 2.6.28, the function tracer traces on function entries only.
> But there is an add-on on ftrace which let one to trace on entry and
> on return, the function
> graph tracer. This tracer uses this facility to output a graph of
> function calls and measure
> the time elapsed during each function call.
> You can also register two custom handlers to do some things you need
> on entry and on return.

Word "graph" is quite confusing. We don't need any graphs, we need a 
plain execution path tracing as in the attached example (this is what's 
currently done).

>> All the above functionality is almost what we need. The only thing left,
>> which I forgot to mention, is possibility to log also functions return value
>> on exit. This is what TRACE_EXIT_RES() in SCST does. Is it possible to add
>> those?
> 
> I want to add that on the function graph tracer. That can be done
> pretty easily. The only
> problem comes with the type of the return value. Would this tracer be
> supposed to always
> return a 64 bits value regardless of the real typ of the value? There
> would be some pointless bytes
> on most return values. I don't know how to proceed for this problem.

I think if tracer always returns machine word, as Ingo suggested, as 
"%d(%x)" it would be more then sufficient. In the rest of 0.01% of cases 
it wouldn't be hard to print a non-standard return value using 
ftrace_printk() just before returning it.

>> And one more question. Is it possible to redirect ftrace tracing to serial
>> console or any other console (netconsole?)? It can be helpful to investigate
>> hard lockups in IRQ or with IRQs disabled.
>>
>> Thanks!
>> Vlad
>>
> 
> I would find it useful too. I thought about something like using
> early_printk or something like
> that...I don't know. That would be good to redirect the output to the
> tty device of the user choice.

That would make ftrace a complete debug logging subsystem.

--------------020403000909000503050306
Content-Type: text/plain;
 name="exm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="exm"

Dec 15 17:09:48 linux-c07e kernel: [  738.535571] [2519]: ENTRY dev_user_ioctl
Dec 15 17:09:48 linux-c07e kernel: [  738.535582] [2519]: dev_user_ioctl:1735:REGISTER_DEVICE
Dec 15 17:09:48 linux-c07e kernel: [  738.535589] [2519]: ENTRY dev_user_register_dev
Dec 15 17:09:48 linux-c07e kernel: [  738.535601] [2519]: ENTRY sgv_pool_create
Dec 15 17:09:48 linux-c07e kernel: [  738.535610] [2519]: ENTRY sgv_pool_init
Dec 15 17:09:48 linux-c07e kernel: [  738.535616] [2519]: sgv_pool_init:997:name dev0, sizeof(*obj)=52, clustering_type=0
Dec 15 17:09:48 linux-c07e kernel: [  738.535626] [2519]: sgv_pool_init:1026:pages=1, size=76
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=2, size=100
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=4, size=148
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=8, size=244
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=16, size=436
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=32, size=820
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=64, size=1588
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=128, size=3124
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=256, size=52
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=512, size=52
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=1024, size=52
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT sgv_pool_init: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT sgv_pool_create: 1
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY sgv_pool_create
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY sgv_pool_init
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:997:name dev0-clust, sizeof(*obj)=52, clustering_type=1
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=1, size=80
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=2, size=108
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=4, size=164
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=8, size=276
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=16, size=500
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=32, size=948
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=64, size=1844
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=128, size=3636
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=256, size=1076
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=512, size=2100
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: sgv_pool_init:1026:pages=1024, size=52
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT sgv_pool_init: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT sgv_pool_create: 1
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY __dev_user_set_opt
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: __dev_user_set_opt:2580:dev dev0, parse_type 0, on_free_cmd_type 1, memory_reuse_type 1, partial_transfers_type 0, partial_len 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY dev_user_setup_functions
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT dev_user_setup_functions
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT __dev_user_set_opt: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: dev_user_register_dev:2499:dev b7bffad0, name dev0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY __scst_register_virtual_dev_driver
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT scst_dev_handler_check: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: scst: __scst_register_virtual_dev_driver:1036:Virtual device handler dh-dev0 for type 1 registered successfully
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT __scst_register_virtual_dev_driver: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY scst_register_virtual_device
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT scst_dev_handler_check: 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY scst_suspend_activity
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: scst_suspend_activity:484:suspend_count 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: ENTRY scst_susp_wait
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: scst_susp_wait:463:wait_event() returned 0
Dec 15 17:09:48 linux-c07e kernel: [  738.538862] [2519]: EXIT scst_susp_wait: 0

--------------020403000909000503050306--
