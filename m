From: Chuhong Yuan <hslester96@gmail.com>
Subject: Re: [PATCH] scsi: 3w-sas: Fix unterminated strncpy
Date: Mon, 5 Aug 2019 14:22:38 +0800
Message-ID: <CANhBUQ0KD9YqYWT-m7q-7FcqAwRstVPzh_s2rRmCCjwQYcivBQ@mail.gmail.com>
References: <20190730084047.26482-1-hslester96@gmail.com> <1564498597.4300.10.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564498597.4300.10.camel@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>
Cc: Adam Radford <aradford@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 30, 2019 at 10:56 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Tue, 2019-07-30 at 16:40 +0800, Chuhong Yuan wrote:
> > strncpy(dest, src, strlen(src)) leads to unterminated
> > dest, which is dangerous.
>
> I don't buy that.  The structure is only used for the
> TW_IOCTL_GET_COMPATIBILITY_INFO ioctl and all the fields for that are
> fixed width and are copied over as such.
>
> > Here driver_version's len is 32 and TW_DRIVER_VERSION
> > is shorter than 32.
> > Therefore strcpy is OK.
>
> The best practice for copying a string to a fixed width destination
> that does get printed within the kernel would be what the 3w-9xxx.c
> does
>
>         strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
>                 sizeof(tw_dev->tw_compat_info.driver_version));
>

This is right, and strscpy() is better than strlcpy(). strlcpy() is deprecated
now according to the documentation.
I choose strcpy() since it has better performance and there is no worry of
overflow here. And I find there are indeed some places using strcpy() to fix
this problem, like add_man_viewer() in tools/perf/builtin-help.c.

> But as I said, it doesn't really matter for a fixed width field that's
> never printed within the kernel.
>

I think it is not good to leave a exploitable place here, and fixing it does not
need much effort.

Regards,
Chuhong

> James
>
