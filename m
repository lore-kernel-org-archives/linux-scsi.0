From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 2 Oct 2018 15:33:38 -0700
Message-ID: <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538503063.193396.6.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 2, 2018 at 10:57 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On Tue, 2018-10-02 at 10:24 -0700, Nick Desaulniers wrote:
> > On Mon, Oct 1, 2018 at 6:16 PM Bart Van Assche <bvanassche@acm.org> wrote:
> > > Additionally, zero initializers should be left out to minimize
> > > the size of object files.
> >
> > Sorry, my understanding was that global variables either occupy the
> > .bss section or the .data section, depending on whether they were
> > zero-initialized vs initialized to non-zero, respectively (where
> > non-initialized are treated as zero initialized).  Looks like without
> > the explicit zero initialization, compilers will put the symbols in a
> > "common" section, which `man 1 nm` says is also unitialized data.  I
> > didn't think .bss sections occupied space in an object file or binary;
> > the kernel's loader would set up the mappings at execution?  Can you
> > clarify?
>
> Explicitly initialized global and static variables end up in the .data
> section and need space in that section.

Unless the initial value is zero.
https://godbolt.org/z/curRoO

So you don't wind up with an increase in binary size simply by having
global variables initialized to zero, right?  Instead the kernel knows
to create a zero'd out mapping for bss.  You don't need a run of zeros
in the binary.

So I disagree when you said earlier "zero initializers should be left
out to minimize the size of object files." I assert they don't affect
the size of the binary.

If you had many global variables all initialized to zero, why would
you encode that many zeros in a binary, when you can just set a size
on the bss section and have the kernel create the appropriate sized
and zero'd mapping?

> That is not the case if the
> initializer is left out and these variables end up in the .bss section.

>From my above link, gcc will put globals without initializers into "common."

> From https://en.wikipedia.org/wiki/.bss:
>
> "In computer programming, the name .bss or bss is used by many compilers
> and linkers for the portion of an object file or executable containing
> statically-allocated variables that are not explicitly initialized to any
> value. It is often referred to as the "bss section" or "bss segment".
>
> Typically only the length of the bss section, but no data, is stored in
> the object file."
>
> This is why checkpatch warns if a global or static variable is initialized
> explicitly to zero. From scripts/checkpatch.pl:
>
> our $zero_initializer = qr{(?:(?:0[xX])?0+$Int_type?|NULL|false)\b};
>
> # check for global initialisers.
>
>                 if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*($zero_initializer)\s*;/) {
>                         if (ERROR("GLOBAL_INITIALISERS",
>                                   "do not initialise globals to $1\n" . $herecurr) && $fix) {
>                                 $fixed[$fixlinenr] =~ s/(^.$Type\s*$Ident(?:\s+$Modifier)*)\s*=\s*$zero_initializer\s*;/$1;/;
>                         }
>                 }
>
> # check for static initialisers.
>
>                 if ($line =~ /^\+.*\bstatic\s.*=\s*($zero_initializer)\s*;/) {
>                         if (ERROR("INITIALISED_STATIC",
>                                   "do not initialise statics to $1\n" . $herecurr) && $fix) {
>                                 $fixed[$fixlinenr] =~ s/(\bstatic\s.*?)\s*=\s*$zero_initializer\s*;/$1;/;
>                         }
>                 }
>
> Bart.



-- 
Thanks,
~Nick Desaulniers
