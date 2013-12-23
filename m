From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Mon, 23 Dec 2013 10:12:57 -0800
Message-ID: <CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
References: <1387366123-3950-1-git-send-email-Viswas.G@pmcs.com>
	<52B8357D.60202@redhat.com>
	<52B83B89.9040700@gmail.com>
	<CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal>
	<CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com>
	<52B8518B.4060204@gmail.com>
	<52B8569D.4050101@redhat.com>
	<CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
	<20131223163410.GA28220@redhat.com>
	<20131223172744.GA2069@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131223172744.GA2069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 23, 2013 at 9:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> In short, is this code
>
>         spinlock_t LOCK;
>         unsigned long FLAGS;
>
>         void my_lock(void)
>         {
>                 spin_lock_irqsave(&LOCK, FLAGS);
>         }
>
>         void my_unlock(void)
>         {
>                 spin_unlock_irqrestore(&LOCK, FLAGS);
>         }
>
> correct or not?

Hell no. "flags" needs to be a thread-private variable, or at least
protected some way (ie the above could work if everything is inside a
bigger lock, to serialize access to FLAGS).

                    Linus
