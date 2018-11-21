From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [PATCH v2] codafs: Fix build using bare-metal toolchain
Date: Wed, 21 Nov 2018 17:48:59 -0500
Message-ID: <308CF0BD-90AE-45D2-BAF9-D297A530B0F4@cs.cmu.edu>
References: <20181030202713.26203-1-semen.protsenko@linaro.org> <CAKaJLVu0h5woVtN5=Mh38ajACBZZQ3JHfRhkjNrwMwYXHEG-NQ@mail.gmail.com> <CAHp75Vd-ydncUWQtc8ziLpCMJRFCvjV=ueKB0wRgn7W-pnV09Q@mail.gmail.com> <20181121181042.4gzuniz2vzjikpwc@cs.cmu.edu> <CAKaJLVs4MUws7sPPdDk7hnjZ+Z1V0V6bGt=eWn=gsF_B+yULeg@mail.gmail.com> <CAKaJLVvHZwJHu_uZuUDtCZrD7EKY-5xpGhNZN7cQ2M4Bz9osDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKaJLVvHZwJHu_uZuUDtCZrD7EKY-5xpGhNZN7cQ2M4Bz9osDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: hch@lst.de, Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Praneeth Bajjuri <praneeth@ti.com>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

That actually makes a lot of sense.

Jan

On November 21, 2018 2:39:03 PM EST, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>+ Jan Harkes back to "To:" list, slipped away somehow...
>
>On Wed, Nov 21, 2018 at 9:36 PM Sam Protsenko
><semen.protsenko@linaro.org> wrote:
>>
>> On Wed, Nov 21, 2018 at 8:10 PM Jan Harkes <jaharkes@cs.cmu.edu>
>wrote:
>> >
>> > On Wed, Nov 21, 2018 at 06:41:13PM +0200, Andy Shevchenko wrote:
>> > > I'm not sure how you managed to miss people in this list (perhaps
>by
>> > > default you have suppress all Cc in your Git configuration), but
>I
>> > > guess we may gently ask Christoph to apply this in case Jan will
>not
>> > > appear.
>> >
>> > You have got to give me a little more than 10 minutes to respond
>before
>> > assuming that I would not appear... I don't think I've ignored any
>> > previous emails on this subject and the only issues has been some
>people
>> > not receiving my responses for unknown reasons (agressive spam
>filter?).
>> >
>> > I have no problem with this patch, have it sitting with some other
>> > non-urgent patches and in case it doesn't appear upstream it should
>> > piggyback with whatever I have to send.
>> >
>>
>> Thanks, Jan, really appreciate it. We need this patch to fix our
>tests
>> with allmodconfig configuration (in Linaro CI loops).
>>
>> > I still don't know why the bare-metal toolchain couldn't just add a
>> > -D__linux__.  I understand that this define is expected to be
>always
>> > present while compiling kernel headers so that there is no good
>reason
>> > to even bother testing for it, which is why I have no issue with
>the
>> > patch. But it seems it would make your life a lot easier if you had
>it
>> > defined.
>> >
>>
>> As I understand it, from toolchain's point of view, if __linux__ is
>> defined then it means that the program is being built *for* Linux
>> (i.e. we can use Linux specific features, ABI, like syscalls).
>> Checking this definition can make sense in uapi headers, but in
>kernel
>> code we shouldn't use it (as kernel is baremetal program and not
>> compiled for some OS). I presume that's why __linux__ is not defined
>> in bare-metal toolchains (as those don't provide Linux specific
>> features, libc, etc).
>>
>> > Jan
>> >
