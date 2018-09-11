From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 11/11] compat_ioctl: move tape handling into drivers
Date: Tue, 11 Sep 2018 22:13:18 +0200
Message-ID: <CAK8P3a0nrNUpcYZiV7T14HXPfoiR4LyMM6E+8fP6AWgRMgDpxA@mail.gmail.com>
References: <20180908142837.2819693-1-arnd@arndb.de> <20180908142837.2819693-11-arnd@arndb.de>
 <20180909043746.GF19965@ZenIV.linux.org.uk> <CAK8P3a0evhaJGL_XdUjQhJDGyAh01UjLFkKx-Cq21htXmFsY2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0evhaJGL_XdUjQhJDGyAh01UjLFkKx-Cq21htXmFsY2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, osst@riede.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kai.Makisara@kolumbus.fi, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, IDE-ML <linux-ide@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, osst-users@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2018 at 5:36 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sun, Sep 9, 2018 at 6:38 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Sat, Sep 08, 2018 at 04:28:17PM +0200, Arnd Bergmann wrote:
> > > MTIOCPOS and MTIOCGET are incompatible between 32-bit and 64-bit user
> > > space, and traditionally have been translated in fs/compat_ioctl.c.
> > >
> > > To get rid of that translation handler, move a corresponding
> > > implementation into each of the four drivers implementing those commands.
> > >
> > > The interesting part of that is now in a new linux/mtio.h header that
> > > wraps the existing uapi/linux/mtio.h header and provides an abstraction
> > > to let drivers handle both cases easily.
> >
> > Ugh...  Frankly, this bool compat passed all way down looks wrong.
> > I can live with that; the question is whether block folks will be
> > OK with that thing...
>
> I have tried to come up with an alternative, but couldn't really find anything
> that is less ugly. Since nobody else complained, I'll resend this version
> along with the other patches.

Actually, there was one idea that Deepa mentioned for another subsystem
with a similar issue: instead of passing down the fact that we come from
a compat syscall through multiple function calls, the lowest ones
(put_user_mtpos, put_user_mtget) could call in_compat_syscall().

Would you prefer that?

      Arnd
