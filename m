From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: -Wswitch Clang warnings in drivers/scsi
Date: Thu, 18 Oct 2018 23:51:04 -0700
Message-ID: <20181019065104.GA27170@flashbox>
References: <20181004183047.GA1885@flashbox>
 <1538678069.230807.6.camel@acm.org>
 <20181004184540.GA17513@flashbox>
 <CAKwvOd=FrGZ-oh5Q9RGQD2GNORZrqwAZUzNYN+hTKkp5wrfrqw@mail.gmail.com>
 <20181005065754.GA18637@flashbox>
 <1539024429.64374.40.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539024429.64374.40.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 08, 2018 at 11:47:09AM -0700, Bart Van Assche wrote:
> On Thu, 2018-10-04 at 23:57 -0700, Nathan Chancellor wrote:
> > Regardless of how the overflow is handled within the switch statement,
> > the overflow is also happening when passing in these values to the ioctl,
> > right? I mean these case values are defined in the uapi files so that
> > userspace can easily pass them in to the ioctl, meaning those values are
> > being passed in as a signed integer and I would assume subsequently
> > overflowing unless I'm just missing something here.
> 
> From the user space header <sys/ioctl.h>:
> 
> extern int ioctl (int __fd, unsigned long int __request, ...) __THROW;
> 
> From the kernel header <linux/fs.h>:
> 
> 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> 
> Why has the second argument been declared as "unsigned long" in the glibc
> headers and as "unsigned int" in the kernel headers? That's not clear to me.
> 
> Bart.
> 

Hi Bart,

Sorry it took me so long to reply, somehow this email got lost in my
inbox...

Unfortuntely, I am unsure why there is that discrepency between the
headers. I tried to do some research but I didn't come up with much.

However, I did test changing the type of ioctl/compat_ioctl's cmd
parameter to 'unsigned int' and came up with the following diff (rather
large so sharing via a gist instead of pasting here):

https://gist.github.com/nathanchance/8febc92735f4228574cb0464520f0f6f

I'll obviously draft up a proper commit message before formally sending
but I can address any major concerns before that happens. I checked
every single ioctl for a negative value and there aren't any so I think
this change makes sense to fix this warning.

Cheers,
Nathan
