From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: please fix FUSION (Was:
	[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
Date: Mon, 24 Mar 2014 18:01:15 +0100
Message-ID: <20140324170115.GA30307@redhat.com>
References: <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp> <20140322192511.GA14811@redhat.com> <1395521330.2143.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395521330.2143.51.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joseph.salisbury@canonical.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/22, James Bottomley wrote:
>
> OK, the fix from the SCSI point of view is to make the mpt teardown path
> actually work.  The whole thing looks to be a complete mess because
> there's another place where it will do the wrong thing in
> mptscsih_remove().  You always have to call mpt_detach() otherwise the
> device doesn't get removed from the lists.  In theory this patch fixes
> both bugs in the driver.

Yes, I obviously thought about the same change ;)

But note that mpt_detach() doesn't look correct too. This is almost
off-topic, but still...

At least it needs s/cancel_delayed_work/cancel_delayed_work_sync/ to
sync with mpt_fault_reset_work().

And it is not clear if it is safe to simply destroy ->fw_event_q,
perhaps it can't have the pending works if the caller is teardown
path, and otherwise we rely on mptsas_cleanup_fw_event_q(), I do
not know... but mptsas_cleanup_fw_event_q() needs _sync too I guess,
and obviously mptsas_free_fw_event() should be called unconditionally.

OTOH, mpt_attach() doesn't verify that ->fw_event_q was created
succesfully. And, if mpt_do_ioc_recovery() fails it destroys
->reset_work_q but not ->fw_event_q. Looks like this driver needs
some cleanups.

> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1176,10 +1176,14 @@ mptscsih_remove(struct pci_dev *pdev)
>  	MPT_SCSI_HOST		*hd;
>  	int sz1;
>
> +	if (!host)
> +		/* not brought up far enough to do scsi_host_attach() */
                                                   ^^^^^^^^^^^^^^^^
scsi_host_alloc ;)

> +		goto out;
> +

Yes, I think this is correct. mpt_attach() does kzalloc(MPT_ADAPTER) so
we can probably rely on ->sh == NULL if _alloc failed.

Oleg.
