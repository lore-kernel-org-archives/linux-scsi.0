From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 02 Oct 2018 10:57:43 -0700
Message-ID: <1538503063.193396.6.camel@acm.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
         <10b12992-3570-4646-374b-82cbd7276839@acm.org>
         <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-10-02 at 10:24 -0700, Nick Desaulniers wrote:
+AD4 On Mon, Oct 1, 2018 at 6:16 PM Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4 wrote:
+AD4 +AD4 Additionally, zero initializers should be left out to minimize
+AD4 +AD4 the size of object files.
+AD4 
+AD4 Sorry, my understanding was that global variables either occupy the
+AD4 .bss section or the .data section, depending on whether they were
+AD4 zero-initialized vs initialized to non-zero, respectively (where
+AD4 non-initialized are treated as zero initialized).  Looks like without
+AD4 the explicit zero initialization, compilers will put the symbols in a
+AD4 +ACI-common+ACI section, which +AGA-man 1 nm+AGA says is also unitialized data.  I
+AD4 didn't think .bss sections occupied space in an object file or binary+ADs
+AD4 the kernel's loader would set up the mappings at execution?  Can you
+AD4 clarify?

Explicitly initialized global and static variables end up in the .data
section and need space in that section. That is not the case if the
initializer is left out and these variables end up in the .bss section.
>From https://en.wikipedia.org/wiki/.bss:

+ACI-In computer programming, the name .bss or bss is used by many compilers
and linkers for the portion of an object file or executable containing
statically-allocated variables that are not explicitly initialized to any
value. It is often referred to as the +ACI-bss section+ACI or +ACI-bss segment+ACI.

Typically only the length of the bss section, but no data, is stored in
the object file.+ACI

This is why checkpatch warns if a global or static variable is initialized
explicitly to zero. From scripts/checkpatch.pl:

our +ACQ-zero+AF8-initializer +AD0 qr+AHs(?:(?:0+AFs-xX+AF0)?0+-+ACQ-Int+AF8-type?+AHw-NULL+AHw-false)+AFw-b+AH0AOw

+ACM check for global initialisers.

                if (+ACQ-line +AD0Afg /+AF4AXAArACQ-Type+AFw-s+ACoAJA-Ident(?:+AFw-s+-+ACQ-Modifier)+ACoAXA-s+ACoAPQBc-s+ACo(+ACQ-zero+AF8-initializer)+AFw-s+ACoAOw-/) +AHs
                        if (ERROR(+ACI-GLOBAL+AF8-INITIALISERS+ACI,
                                  +ACI-do not initialise globals to +ACQ-1+AFw-n+ACI . +ACQ-herecurr) +ACYAJg +ACQ-fix) +AHs
                                +ACQ-fixed+AFsAJA-fixlinenr+AF0 +AD0Afg s/(+AF4.+ACQ-Type+AFw-s+ACoAJA-Ident(?:+AFw-s+-+ACQ-Modifier)+ACo)+AFw-s+ACoAPQBc-s+ACoAJA-zero+AF8-initializer+AFw-s+ACoAOw-/+ACQ-1+ADs-/+ADs
                        +AH0
                +AH0

+ACM check for static initialisers.

                if (+ACQ-line +AD0Afg /+AF4AXAAr.+ACoAXA-bstatic+AFw-s.+ACoAPQBc-s+ACo(+ACQ-zero+AF8-initializer)+AFw-s+ACoAOw-/) +AHs
                        if (ERROR(+ACI-INITIALISED+AF8-STATIC+ACI,
                                  +ACI-do not initialise statics to +ACQ-1+AFw-n+ACI . +ACQ-herecurr) +ACYAJg +ACQ-fix) +AHs
                                +ACQ-fixed+AFsAJA-fixlinenr+AF0 +AD0Afg s/(+AFw-bstatic+AFw-s.+ACo?)+AFw-s+ACoAPQBc-s+ACoAJA-zero+AF8-initializer+AFw-s+ACoAOw-/+ACQ-1+ADs-/+ADs
                        +AH0
                +AH0

Bart.
