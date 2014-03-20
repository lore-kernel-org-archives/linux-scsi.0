From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: please fix FUSION (Was: [v3.13][v3.14][Regression]
	kthread:makekthread_create()killable)
Date: Thu, 20 Mar 2014 20:23:07 +0100
Message-ID: <20140320192307.GA11883@redhat.com>
References: <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp> <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp> <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com> <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <532B1B67.5050104@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/20, Joseph Salisbury wrote:
>
> On 03/19/2014 03:42 PM, Oleg Nesterov wrote:
> > On 03/19, Oleg Nesterov wrote:
> >> On 03/19, Oleg Nesterov wrote:
> >>> But please do not forget that the kernel crashes. Whatever else we do, this
> >>> should be fixed anyway. And this should be fixed in driver.
> >> drivers/message/fusion/ is obviously buggy.
> > Perhaps this is the only problem and Tetsuo is right, this driver
> > really needs more than 30 secs to probe...
> >
> > But if you have a bit of free time, perhaps you can try the stupid
> > debugging patch below ;) Not sure it will help, but who knows.
> >
> > Oleg.
>
> There was some testing done with your test kernel.  The data collected
> while running your kernel is available in the bug report:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705/comments/58

Joseph, thanks a lot.

I'll try to read the logs tomorrow, but at first glance Tetsuo was right,
I do not see a "long" sleep in that log. And it shows that the hack around
kthread_run() in scsi_host_alloc() won't help. I am wondering why I didn't
realize this before ;)

Hmm. Perhaps we should simply change mptsas_init() to block all signals
until we have the right fix.

Oleg.
