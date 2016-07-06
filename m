From: Markus Mayer <markus.mayer@broadcom.com>
Subject: Re: [PATCH v2 0/7] lib: string: add functions to case-convert strings
Date: Tue, 5 Jul 2016 21:32:16 -0700
Message-ID: <CAGt4E5u_C9TVgJh5NUCSb6zM_UTazJPTPrsBO9K0atzXAopR8w@mail.gmail.com>
References: <1467751631-22878-1-git-send-email-mmayer@broadcom.com>
 <1467756874.16342.11.camel@perches.com> <CAGt4E5vqiUOVmgqY8OvRPNpoS54hZMOHid6ND4CRyb5p9y5ndw@mail.gmail.com>
 <1467759377.8360.12.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1467759377.8360.12.camel@perches.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-pm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 5 July 2016 at 15:56, Joe Perches <joe@perches.com> wrote:
> On Tue, 2016-07-05 at 15:36 -0700, Markus Mayer wrote:
>> On 5 July 2016 at 15:14, Joe Perches <joe@perches.com> wrote:
>> > On Tue, 2016-07-05 at 13:47 -0700, Markus Mayer wrote:
>> > > This series introduces a family of generic string case conversion
>> > > functions. This kind of functionality is needed in several places in
>> > > the kernel. Right now, everybody seems to be implementing their own
>> > > copy of this functionality.
>> > >
>> > > Based on the discussion of the previous version of this series[1] and
>> > > the use cases found in the kernel, it does look like having several
>> > > flavours of case conversion functions is beneficial. The use cases fall
>> > > into three categories:
>> > >     - copying a string and converting the case while specifying a
>> > >       maximum length to mimic strncpy()
>> > >     - copying a string and converting the case without specifying a
>> > >       length to mimic strcpy()
>> > >     - converting the case of a string in-place (i.e. modifying the
>> > >       string that was passed in)
>> > >
>> > > Consequently, I am proposing these new functions:
>> > >     char *strncpytoupper(char *dst, const char *src, size_t len);
>> > >     char *strncpytolower(char *dst, const char *src, size_t len);
>> > >     char *strcpytoupper(char *dst, const char *src);
>> > >     char *strcpytolower(char *dst, const char *src);
>> > >     char *strtoupper(char *s);
>> > >     char *strtolower(char *s);
>> > I think there isn't much value in anything other
>> > than strto.
>> >
>> > Using str[n]cpy followed by strto is
>> > pretty obvious and rarely used anyway.
>> First time around, folks were proposing the "copy" variants when I
>> submitted just strtolower() by itself[1]. They just asked for source
>> and destination parameters to strtolower(), but looking at the use
>> cases that wouldn't have worked so well. Hence it evolved into these 6
>> functions.
>>
>> Here's a breakdown of how the functions are being used (patches 2-7),
>> see also [2]:
>>
>> Patch 2: strncpytolower()
>> Patch 3: strtolower()
>> Patch 4: strncpytolower() and strtolower()
>> Patch 5: strtolower()
>> Patch 6: strcpytoupper()
>> Patch 7: strcpytoupper()
>>
>> So it does look like the copy + change case variant is more frequently
>> used than just strto.
>
> Are these functions useful?  <shrug> Not to me, not so much.

The use cases do exist. I'll leave it up to the maintainers to decide
whether duplicate implementations or potentially unused generic
functions are to be preferred.

What I do know is that I have a driver in the wings that also needs a
strolower() implementation. If this ends up not being accepted, I'll
have to add yet another driver-local strtolower() implementation to
the kernel. But if that's the decision then so be it.

> None of the functions would have the strcpy performance of
> the arch / asm
> versions of strcpy and the savings in overall
> code isn't significant (or
> measured?).

100% agreed. These functions won't set any speed records. Keep in mind
also that in 4 out of the 6 cases where I replaced local
implementations of "strcpytoXXX", the code was doing essentially the
same I am proposing here (no assembly code). Only 2 of the 6 called
strncpy() before, benefiting from optimized assembly implementations.
But they still had to walk the string explicitly afterwards to convert
the case, which probably means the overall speed won't change that
much using the functions proposed here.

> Of course none of the uses are runtime performance important.

That is also very true.

> This patch also adds always compiled functions that aren't used
> in many .configs.

It adds 2 functions (strncpytolower() and strncpytoupper()). The other
4 are static inline one-liners and won't show up anywhere if not used
(and if used the compiler will insert calls to strncpyto<lower|upper>
instead).

Regards,
-Markus
