From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 00/19] prevent bounds-check bypass via speculative execution
Date: Thu, 18 Jan 2018 08:58:08 -0800
Message-ID: <CAPcyv4gPLx74CAHGGrC3R-fgrh0vUmCbLNXZ0f7PTiKi0f+hCQ@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
 <CAPcyv4gPcV7MRumSJNz6nDw=HhKO4MK2QqKbj4uc_6APsSFr+g@mail.gmail.com> <20180118131837.GA20783@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180118131837.GA20783@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, Alexei Starovoitov <ast@kernel.org>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 18, 2018 at 5:18 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Dan, Linus,
>
> On Thu, Jan 11, 2018 at 05:41:08PM -0800, Dan Williams wrote:
>> On Thu, Jan 11, 2018 at 5:19 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Thu, Jan 11, 2018 at 4:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> >>
>> >> This series incorporates Mark Rutland's latest ARM changes and adds
>> >> the x86 specific implementation of 'ifence_array_ptr'. That ifence
>> >> based approach is provided as an opt-in fallback, but the default
>> >> mitigation, '__array_ptr', uses a 'mask' approach that removes
>> >> conditional branches instructions, and otherwise aims to redirect
>> >> speculation to use a NULL pointer rather than a user controlled value.
>> >
>> > Do you have any performance numbers and perhaps example code
>> > generation? Is this noticeable? Are there any microbenchmarks showing
>> > the difference between lfence use and the masking model?
>>
>> I don't have performance numbers, but here's a sample code generation
>> from __fcheck_files, where the 'and; lea; and' sequence is portion of
>> array_ptr() after the mask generation with 'sbb'.
>>
>>         fdp = array_ptr(fdt->fd, fd, fdt->max_fds);
>>      8e7:       8b 02                   mov    (%rdx),%eax
>>      8e9:       48 39 c7                cmp    %rax,%rdi
>>      8ec:       48 19 c9                sbb    %rcx,%rcx
>>      8ef:       48 8b 42 08             mov    0x8(%rdx),%rax
>>      8f3:       48 89 fe                mov    %rdi,%rsi
>>      8f6:       48 21 ce                and    %rcx,%rsi
>>      8f9:       48 8d 04 f0             lea    (%rax,%rsi,8),%rax
>>      8fd:       48 21 c8                and    %rcx,%rax
>>
>>
>> > Having both seems good for testing, but wouldn't we want to pick one in the end?
>>
>> I was thinking we'd keep it as a 'just in case' sort of thing, at
>> least until the 'probably safe' assumption of the 'mask' approach has
>> more time to settle out.
>
> From the arm64 side, the only concern I have (and this actually applies to
> our CSDB sequence as well) is the calculation of the array size by the
> caller. As Linus mentioned at the end of [1], if the determination of the
> size argument is based on a conditional branch, then masking doesn't help
> because you bound within the wrong range under speculation.
>
> We ran into this when trying to use masking to protect our uaccess routines
> where the conditional bound is either KERNEL_DS or USER_DS. It's possible
> that a prior conditional set_fs(KERNEL_DS) could defeat the masking and so
> we'd need to throw some heavy barriers in set_fs to make it robust.

At least in the conditional mask case near set_fs() usage the approach
we are taking is to use a barrier. I.e. the following guidance from
Linus:

"Basically, the rule is trivial: find all 'stac' users, and use address
masking if those users already integrate the limit check, and lfence
they don't."

...which translates to narrow the pointer for get_user() and use a
barrier  for __get_user().
