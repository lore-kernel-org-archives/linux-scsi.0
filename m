From: chetan loke <loke.chetan@gmail.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O testing
Date: Wed, 16 May 2012 15:31:55 -0400
Message-ID: <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
References: <1337188023.3796.130.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2012 at 1:07 PM, Tim Chen <tim.c.chen@linux.intel.com> =
wrote:

> + =C2=A0 =C2=A0 =C2=A0 while (!kthread_should_stop()) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct scsi_cmnd *=
cmnd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct scsi_ram_cm=
nd *ram_cmnd;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(=
host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (list_empty(&ra=
m_device->commands)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 set_current_state(TASK_INTERRUPTIBLE);

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_unlock_irq(host->host_lock);

The spin_[un]lock/ variants don't match.


> +static int scsi_ram_queuecommand(struct Scsi_Host *shost, struct scs=
i_cmnd *cmnd)
=2E...

> + =C2=A0 =C2=A0 =C2=A0 if (use_thread) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(=
shost->host_lock, flags);

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (list_empty(&ra=
m_device->commands))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 wake_up_process(ram_device->thread);

Didn't look in detail but if the queue is empty then why would you
want to wake up the kthread? What if you just wake_up after
list_add_tail below?


> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&ram=
_cmnd->queue, &ram_device->commands);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(shost->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_ram_execute_c=
ommand(cmnd);
> + =C2=A0 =C2=A0 =C2=A0 }


Chetan Loke
