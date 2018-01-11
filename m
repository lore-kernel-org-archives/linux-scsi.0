From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
Date: Thu, 11 Jan 2018 17:34:52 +0100
Message-ID: <4408b424-1a85-326a-6506-02fde32bf8b8@iogearbox.net>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.LRH.2.00.1801092017330.27010@gjva.wvxbf.pm>
 <CAPcyv4gccDQYx9urpagnBo-TqNLoQ00gEoE7kp+JXNKsmFxcHw@mail.gmail.com>
 <20180109205549.osb25c4r2h2n2wqx@treble>
 <nycvar.YFH.7.76.1801111052310.11852@cbobk.fhfr.pm>
 <CAPcyv4jRbHZH9OWD_6DmeA=MGr+2cy83LGqMCjK_nj79Pug4NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jRbHZH9OWD_6DmeA=MGr+2cy83LGqMCjK_nj79Pug4NQ@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jiri Kosina <jikos@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Zhang Rui <rui.z>
List-Id: linux-scsi@vger.kernel.org

On 01/11/2018 04:58 PM, Dan Williams wrote:
> On Thu, Jan 11, 2018 at 1:54 AM, Jiri Kosina <jikos@kernel.org> wrote:
>> On Tue, 9 Jan 2018, Josh Poimboeuf wrote:
>>> On Tue, Jan 09, 2018 at 11:44:05AM -0800, Dan Williams wrote:
>>>> On Tue, Jan 9, 2018 at 11:34 AM, Jiri Kosina <jikos@kernel.org> wrote:
>>>>> On Fri, 5 Jan 2018, Dan Williams wrote:
>>>>>
>>>>> [ ... snip ... ]
>>>>>> Andi Kleen (1):
>>>>>>       x86, barrier: stop speculation for failed access_ok
>>>>>>
>>>>>> Dan Williams (13):
>>>>>>       x86: implement nospec_barrier()
>>>>>>       [media] uvcvideo: prevent bounds-check bypass via speculative execution
>>>>>>       carl9170: prevent bounds-check bypass via speculative execution
>>>>>>       p54: prevent bounds-check bypass via speculative execution
>>>>>>       qla2xxx: prevent bounds-check bypass via speculative execution
>>>>>>       cw1200: prevent bounds-check bypass via speculative execution
>>>>>>       Thermal/int340x: prevent bounds-check bypass via speculative execution
>>>>>>       ipv6: prevent bounds-check bypass via speculative execution
>>>>>>       ipv4: prevent bounds-check bypass via speculative execution
>>>>>>       vfs, fdtable: prevent bounds-check bypass via speculative execution
>>>>>>       net: mpls: prevent bounds-check bypass via speculative execution
>>>>>>       udf: prevent bounds-check bypass via speculative execution
>>>>>>       userns: prevent bounds-check bypass via speculative execution
>>>>>>
>>>>>> Mark Rutland (4):
>>>>>>       asm-generic/barrier: add generic nospec helpers
>>>>>>       Documentation: document nospec helpers
>>>>>>       arm64: implement nospec_ptr()
>>>>>>       arm: implement nospec_ptr()
>>>>>
>>>>> So considering the recent publication of [1], how come we all of a sudden
>>>>> don't need the barriers in ___bpf_prog_run(), namely for LD_IMM_DW and
>>>>> LDX_MEM_##SIZEOP, and something comparable for eBPF JIT?
>>>>>
>>>>> Is this going to be handled in eBPF in some other way?
>>>>>
>>>>> Without that in place, and considering Jann Horn's paper, it would seem
>>>>> like PTI doesn't really lock it down fully, right?
>>>>
>>>> Here is the latest (v3) bpf fix:
>>>>
>>>> https://patchwork.ozlabs.org/patch/856645/
>>>>
>>>> I currently have v2 on my 'nospec' branch and will move that to v3 for
>>>> the next update, unless it goes upstream before then.
>>
>> Daniel, I guess you're planning to send this still for 4.15?
> 
> It's pending in the bpf.git tree:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=b2157399cc9

Sorry for the delay, just noticed the question now since not on Cc either:
It made it into in DaveM's tree already and part of his latest pull-req
to Linus.

>>> That patch seems specific to CONFIG_BPF_SYSCALL.  Is the bpf() syscall
>>> the only attack vector?  Or are there other ways to run bpf programs
>>> that we should be worried about?
>>
>> Seems like Alexei is probably the only person in the whole universe who
>> isn't CCed here ... let's fix that.
> 
> He will be cc'd on v2 of this series which will be available later today.
