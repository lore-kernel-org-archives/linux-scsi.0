From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: Re: [PATCH 1/1] scsi: fnic: add a space after %p in printf format
Date: Mon, 11 Dec 2017 23:54:49 +0100
Message-ID: <CAJfZ7=nnfyCV7PT8eHEu8iwKdbmPQjKzCbwA-t3KwEZqks1K0g@mail.gmail.com>
References: <20171210192311.5334-1-nicolas.iooss_linux@m4x.org> <1513030969.2747.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513030969.2747.19.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "kartilak@cisco.com" <kartilak@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 11, 2017 at 11:22 PM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
>
> On Sun, 2017-12-10 at 20:23 +0100, Nicolas Iooss wrote:
> > fnic_fcpio_icmnd_cmpl_handler() displays the value of sc with:
> >
> >     FNIC_SCSI_DBG(KERN_INFO...
> >         "... sc = 0x%p"
> >         "scsi_status ..."
> >         ...
> >
> > As the literal strings get merged, the function uses %ps instead of the
> > intended raw %p format. Fix this by inserting a space.
> >
> > Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> > ---
> >  drivers/scsi/fnic/fnic_scsi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> > index 242e2ee494a1..8cbd3c9f0b4c 100644
> > --- a/drivers/scsi/fnic/fnic_scsi.c
> > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > @@ -906,7 +906,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
> >
> >               FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> >                       "icmnd_cmpl abts pending "
> > -                       "hdr status = %s tag = 0x%x sc = 0x%p"
> > +                       "hdr status = %s tag = 0x%x sc = 0x%p "
> >                         "scsi_status = %x residual = %d\n",
>
> Since the %p format specifier already inserts a 0x prefix, shouldn't 0x%p be changed
> into %p?

Does it? On the kernel I use it does not, and the documentation for %p
does not show a 0x prefix
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/printk-formats.txt?h=v4.15-rc3#n57).

Nicolas
