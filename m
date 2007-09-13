From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Thu, 13 Sep 2007 08:16:52 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org>
References: <20070913122652.GK25592@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760680AbXIMPTW@vger.kernel.org>
In-Reply-To: <20070913122652.GK25592@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org



On Thu, 13 Sep 2007, Jens Axboe wrote:
> +
> +	/*
> +	 * Ensure ordering with tag section
> +	 */
> +	smp_mb__before_clear_bit();
> +
> +	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {

You don't need the "smp_mb__before_clear_bit()" there.

The regular "clear_bit()" needs it, but the "test_and_xxx()" versions are 
architecturally defined to be memory barriers, exactly because they are 
regularly used for locking.

This is even documented - see Documentation/atomic_ops.txt.

		Linus
