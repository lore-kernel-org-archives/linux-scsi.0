From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: -Wswitch Clang warnings in drivers/scsi
Date: Mon, 8 Oct 2018 11:12:40 -0700
Message-ID: <CAKwvOdm8+zF48Osasi_7TrJAz51Zt+m2-7qMASLhT+M0NG4WjA@mail.gmail.com>
References: <20181004183047.GA1885@flashbox> <1538678069.230807.6.camel@acm.org>
 <20181004184540.GA17513@flashbox> <CAKwvOd=FrGZ-oh5Q9RGQD2GNORZrqwAZUzNYN+hTKkp5wrfrqw@mail.gmail.com>
 <20181005065754.GA18637@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005065754.GA18637@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: bvanassche@acm.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 4, 2018 at 11:57 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, Oct 04, 2018 at 02:16:49PM -0700, Nick Desaulniers wrote:
> > On Thu, Oct 4, 2018 at 11:45 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > On Thu, Oct 04, 2018 at 11:34:29AM -0700, Bart Van Assche wrote:
> > > > On Thu, 2018-10-04 at 11:30 -0700, Nathan Chancellor wrote:
> > > > > Hi SCSI folks,
> > > > >
> > > > > In an effort to get the kernel building warning free with Clang, we've
> > > > > come across an interesting occurrence in a few scsi drivers:
> > > > >
> > > > > drivers/scsi/hpsa.c:6533:7: warning: overflow converting case value to switch condition type (2148024833 to 18446744071562609153) [-Wswitch]
> > > > >         case CCISS_GETPCIINFO:
> > > > >              ^
> > > > > ./include/uapi/linux/cciss_ioctl.h:65:26: note: expanded from macro 'CCISS_GETPCIINFO'
> > > > > #define CCISS_GETPCIINFO _IOR(CCISS_IOC_MAGIC, 1, cciss_pci_info_struct)
> > > > >                          ^
> > > > > ./include/uapi/asm-generic/ioctl.h:86:28: note: expanded from macro '_IOR'
> > > > > #define _IOR(type,nr,size)      _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(size)))
> > > > >                                 ^
> > > > > ./include/uapi/asm-generic/ioctl.h:70:2: note: expanded from macro '_IOC'
> > > > >         (((dir)  << _IOC_DIRSHIFT) | \
> > > > >         ^
> > > > >
> > > > > I see this warning in drivers/scsi/hpsa.c and drivers/scsi/smartpqi/smartpqi_init.c
> > > > > on an arm64 allyesconfig build and it has also been reported in a couple of files in
> > > > > drivers/scsi/cxlflash.
> > > > >
> > > > > As the warning states, there is an overflow because the switch statement's value is of
> > > > > type int but the switch value is greater than INT_MAX. I did a brief sweep of the tree
> > > > > and it seems that all uses of _IOC in switch statement values either are small enough
> > > > > to fit into size int or the value is of size unsigned int.
> > > > >
> > > > > I am unsure of the implications of using a smaller _IOC value or converting all ioctls
> > > > > to expect a cmd of type unsigned int (especially since that has userspace implications)
> > > > > but I didn't see any negative ioctl commands. Some clarity and insight would be
> > > > > appreciated.
> > > >
> > > > Have you verified how gcc compiles these switch statements? Maybe gcc supports
> > > > switch / case statements on integral types that are larger than an int?
> >
> > GCC just doesn't warn when the case expression is greater than the
> > maximal representable value and thus would wrap (or appears to, this
> > is probably undefined behavior).  Using an unsigned int here is no
> > functional change:
> > https://godbolt.org/z/1IyYV4
> >
> > GCC and Clang do effectively the same thing as each other, and in the
> > cases of switching on an unsigned int vs signed int.
> >
>
> Regardless of how the overflow is handled within the switch statement,
> the overflow is also happening when passing in these values to the ioctl,
> right? I mean these case values are defined in the uapi files so that
> userspace can easily pass them in to the ioctl, meaning those values are
> being passed in as a signed integer and I would assume subsequently
> overflowing unless I'm just missing something here.

The kernel compiles its code with -fno-strict-overflow, which sets
-fwrapv, which makes signed integer overflow defined to wrap (the
default by the C standard is that signed integer overflow is undefined
behavior).  So while the kernel might be safe from undefined behavior,
the wrapped value being provided to userspace might be a problem.  If
userspace tries to use these definitions, I suspect they will likely
trigger the overflow at runtime.

>
> Nathan
>
> > > >
> > > > Bart.
> > >
> > > Hi Bart,
> > >
> > > That is entirely possible, I will do some research. I did build with GCC
> > > to see if there was any warning and there isn't so I'll be curious to
> > > see what is happening at a lower level.
> > >
> > > Thanks for the comment!
> > > Nathan
> >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
