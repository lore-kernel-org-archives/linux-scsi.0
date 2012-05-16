From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Date: Wed, 16 May 2012 15:35:06 -0400
Message-ID: <20120516193506.GM22985@linux.intel.com>
References: <1337188023.3796.130.camel@schen9-DESK>
 <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2012 at 03:31:55PM -0400, chetan loke wrote:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (list_empty(&ram_device->commands)=
)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_process(ram_d=
evice->thread);
>=20
> Didn't look in detail but if the queue is empty then why would you
> want to wake up the kthread? What if you just wake_up after
> list_add_tail below?

If the list is non-empty, then the kthread has already been woken up
and doesn't need to be woken again.

> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&ram_cmnd->queue, &ram_=
device->commands);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(shost->host_lo=
ck, flags);
> > + =A0 =A0 =A0 } else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_ram_execute_command(cmnd);
> > + =A0 =A0 =A0 }
>=20
>=20
> Chetan Loke
