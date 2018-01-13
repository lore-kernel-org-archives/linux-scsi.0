From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v2 00/19] prevent bounds-check bypass via speculative execution
Date: Fri, 12 Jan 2018 16:15:12 -0800
Message-ID: <CA+8MBb+H0FqciBw9nSO9L0fNQtiRvc_1TREitH9z89YxhtyFAQ@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Russell
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 11, 2018 at 5:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Should the array access in entry_SYSCALL_64_fastpath be made to use
> the masking approach?

That one has a bounds check for an inline constant.

     cmpq    $__NR_syscall_max, %rax

so should be safe.

The classic Spectre variant #1 code sequence is:

int array_size;

       if (x < array_size) {
               something with array[x]
       }

which runs into problems because the array_size variable may not
be in cache, and while the CPU core is waiting for the value it
speculates inside the "if" body.

The syscall entry is more like:

#define ARRAY_SIZE 10

     if (x < ARRAY_SIZE) {
          something with array[x]
     }

Here there isn't any reason for speculation. The core has the
value of 'x' in a register and the upper bound encoded into the
"cmp" instruction.  Both are right there, no waiting, no speculation.

-Tony
