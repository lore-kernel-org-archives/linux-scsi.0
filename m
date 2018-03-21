From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Wed, 21 Mar 2018 15:01:54 -0400
Message-ID: <20180321150154.282ce8d7@gandalf.local.home>
References: <20180321153854.GB24312@kernel.org>
        <20180321185001.GB11249@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321185001.GB11249@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, linux-scsi@vger.kernel.org, Daniel Bristot de Oliveira <daniel@bristot.me>, "Luis Claudio R. =?UTF-8?B?R29uw6dhbHZlcw==?=" <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Mar 2018 11:50:01 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Mar 21, 2018 at 12:38:54PM -0300, Arnaldo Carvalho de Melo wrote:
> >  	assert_spin_locked(&cmd->t_state_lock);
> > -	WARN_ON_ONCE(!irqs_disabled());
> > +	WARN_ON_ONCE_NONRT(!irqs_disabled());  
> 
> I can't find where WARN_ON_ONCE_NONRT is defined.

It's only in the RT patch set. But that may be changing soon.

> 
> That being said I think we can just kill these asserts.  If we have irqs
> disabled spin_unlock_irq a few lines below should already warn.

I agree with Linus. This should just be some kind of
lockdep_assert_held_irqs_disabeld() or something like that.

-- Steve
