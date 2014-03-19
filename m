From: Oleg Nesterov <oleg@redhat.com>
Subject: please fix FUSION (Was: [v3.13][v3.14][Regression]
	kthread:makekthread_create()killable)
Date: Wed, 19 Mar 2014 19:29:10 +0100
Message-ID: <20140319182910.GA14511@redhat.com>
References: <20140316162512.GA9467@redhat.com> <201403172138.GFB43278.OOOFFSQLVHJMtF@I-love.SAKURA.ne.jp> <20140317142246.GA27453@redhat.com> <201403182103.BJC78148.tFOFHQOJLOMVSF@I-love.SAKURA.ne.jp> <20140318171620.GA10636@redhat.com> <201403192049.BBI39025.OVFMOOJtFSHFQL@I-love.SAKURA.ne.jp> <5329C22A.5070206@canonical.com> <20140319175253.GB11923@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140319175253.GB11923@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/19, Oleg Nesterov wrote:
>
> But please do not forget that the kernel crashes. Whatever else we do, this
> should be fixed anyway. And this should be fixed in driver.

drivers/message/fusion/ is obviously buggy.

mptsas_probe() does

		sh = scsi_host_alloc(...);
		if (!sh) {
			...
			goto out_mptsas_probe;
		}
		...
	out_mptsas_probe:
		mptscsih_remove(pdev);

and mptscsih_remove() blindly calls scsi_remove_host(ioc->sh) but ->sh
was not initialized, probably it is NULL.

and scsi_remove_host(host) obviously assumes that this pointer is valid.

I think we should wait for maintainers.

Oleg.
