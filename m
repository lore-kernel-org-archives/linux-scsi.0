From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Wed, 21 Mar 2018 11:50:01 -0700
Message-ID: <20180321185001.GB11249@infradead.org>
References: <20180321153854.GB24312@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180321153854.GB24312@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 21, 2018 at 12:38:54PM -0300, Arnaldo Carvalho de Melo wrote:
>  	assert_spin_locked(&cmd->t_state_lock);
> -	WARN_ON_ONCE(!irqs_disabled());
> +	WARN_ON_ONCE_NONRT(!irqs_disabled());

I can't find where WARN_ON_ONCE_NONRT is defined.

That being said I think we can just kill these asserts.  If we have irqs
disabled spin_unlock_irq a few lines below should already warn.
