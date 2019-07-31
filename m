From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 15/29] compat_ioctl: move tape handling into drivers
Date: Wed, 31 Jul 2019 17:47:33 +0200
Message-ID: <CAK8P3a05o37-JPU4RcDGACbhXtLXLn8hWYfkmZskh1r7z8Zo0g@mail.gmail.com>
References: <20190730192552.4014288-1-arnd@arndb.de> <20190730195819.901457-1-arnd@arndb.de>
 <20190730195819.901457-3-arnd@arndb.de> <20190731105039.GB3488@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190731105039.GB3488@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, IDE-ML <linux-ide@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 31, 2019 at 12:51 PM Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> On Tue, Jul 30, 2019 at 09:55:31PM +0200, Arnd Bergmann wrote:
> > MTIOCPOS and MTIOCGET are incompatible between 32-bit and 64-bit user
> > space, and traditionally have been translated in fs/compat_ioctl.c.
> >
> > To get rid of that translation handler, move a corresponding
> > implementation into each of the four drivers implementing those commands.
> >
> > The interesting part of that is now in a new linux/mtio.h header that
> > wraps the existing uapi/linux/mtio.h header and provides an abstraction
> > to let drivers handle both cases easily. Using an in_compat_syscall()
> > check, the caller does not have to keep track of whether this was
> > called through .unlocked_ioctl() or .compat_ioctl().
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Besides the two minor things below
>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks a lot for the reviewed. Both issues are fixed now, and
I'm pushing out new git branches after adding the other Acks
I got so far.

      Arnd
