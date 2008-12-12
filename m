From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Fri, 12 Dec 2008 22:24:53 +0300
Message-ID: <4942BA85.3070408@vlnb.net>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net> <20081211210917.GB27010@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752493AbYLLTYz@vger.kernel.org>
In-Reply-To: <20081211210917.GB27010@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steven Rostedt <srostedt@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Sam Ravnborg wrote:
>>>>  drivers/scst/scst_lib.c      | 3689 
>>>>  +++++++++++++++++++++++++++++++++++++
>>>>  drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
>>>>  drivers/scst/scst_module.c   |   69
>>>>  drivers/scst/scst_priv.h     |  513 +++++
>>>>  drivers/scst/scst_targ.c     | 5458 
>>>>  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  8 files changed, 12435 insertions(+)
>>> There was a lot af TRACE_ENTRY() / TRACE_EXIT() noise.
>>> We should have proper tools for that by now (I hope).
>> Sorry, I don't see such tools with, for instance, a possibility to be 
>> compiled out in non-debug builds.
>>
>> From one side, I can agree, those TRACE_ENTRY()/TRACE_EXIT() statements 
>> *may* look like a noise (I personally don't notice them), but, from 
>> other side, in past times they have proved how usable they are. If an 
>> SCST user has a problem, I simply ask him to make a debug build, then 
>> enable entry_exit and some other logging levels, then reproduce the 
>> problem and send me the logs. Then in most cases I can see what's wrong 
>> and provide a fix without additional actions and questions.
> 
> I had ftrace in mind but it has not hit mainline yet.
> But will do before this patchset does.

Unfortunately, ftrace at the moment can't fully replace 
TRACE_ENTRY()/TRACE_EXIT() statements, because it lacks:

1. Doing trace in only some modules or source files. Noise from tracing 
of the whole kernel is not needed if we investigate problem in only one 
module (SCST in this case).

2. Ability to inject own messages in the output stream. It's needed to 
have synchronized stream of output messages about both functions tracing 
and what those functions doing. For instance:

entry in func1()
adding cmd C to list L
exit from func1()

Otherwise there would be 2 traces:

entry in func1()
exit from func1()

and

adding cmd C to list L

which almost impossible to merge to analyze.

(Steven Rostedt added on CC)

>>> We often ask for exported symbols to be documented - so one has
>>> a slight idea of their purpose.
>> They are documented, near their prototypes in the public header files, 
>> particularly, scst.h. It was done so, because it was supposed that one, 
>> writing a target driver or dev handler will have on hands the header 
>> files, not source code.
>>
>> Should we move those comments from the functions prototypes to the 
>> functions definitions?
> If there will be multiple implmentations of the same prototype
> we generally recommend to stick the comment in a .H file.
> But otherwise keep it close to the source it describe with the
> minimal hope that it gets updated.

OK, we will move descriptions of functions from prototypes to definitions.

> Oh - and we do not distribute a stripped down headers only
> version of the kernel. Users will see full kernel source.

Those headers are not stripped down. Better analogy is with C++ private 
and public class interfaces. Public SCST headers have public symbols for 
external modules (target drivers mainly), but private headers are for 
internal SCST use only. They are needed to better draw a boundary 
between public and internal private interfaces.

Thanks,
Vlad
