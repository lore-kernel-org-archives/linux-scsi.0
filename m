From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Date: Wed, 16 May 2012 15:43:32 -0400
Message-ID: <20120516194332.GN22985@linux.intel.com>
References: <1337188023.3796.130.camel@schen9-DESK>
 <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
 <20120516193506.GM22985@linux.intel.com>
 <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2012 at 03:37:56PM -0400, chetan loke wrote:
> On Wed, May 16, 2012 at 3:35 PM, Matthew Wilcox <willy@linux.intel.co=
m> wrote:
> > On Wed, May 16, 2012 at 03:31:55PM -0400, chetan loke wrote:
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (list_empty(&ram_device->comman=
ds))
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_process(ra=
m_device->thread);
> >>
> >> Didn't look in detail but if the queue is empty then why would you
> >> want to wake up the kthread? What if you just wake_up after
> >> list_add_tail below?
> >
> > If the list is non-empty, then the kthread has already been woken u=
p
> > and doesn't need to be woken again.
>=20
> Sorry, not able to follow. wait_even_interruptible will put kthread t=
o
> sleep. So how will it be already awake?

Consider the following:

CPU 0			CPU 1
->queuecommand
lock
wakes kthread
queues command 1
unlock

->queuecommand
lock
			kthread wakes
			lock
queues command 2
unlock
			dequeues command 1
			dequeues command 2
			unlock


See?  No need to wake the kthread *if there's already something on the
queue*, because you know it was already woken by whoever put the first
command on the queue.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
