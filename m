From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-2.6.23-mm1 crashed
Date: Sun, 14 Oct 2007 12:21:44 -0700
Message-ID: <20071014122144.f8e56ed9.akpm@linux-foundation.org>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbXJNTV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Oct 2007 15:21:58 -0400
In-Reply-To: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Milter <davemilter@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:

> I build linux-2.6.23-mm1 and try to boot it using qemu,
> and it crashed with trace like this:
> do_page_fault
> error_code
> lock_acquire
> _spin_lock_irqsave
> gdth_timeout
> run_timer_softirq
> __do_softirq
> do_softirq
> 
> I have screenshot, but have no idea, is it legal to include it, if I
> sent copy to lkml.
> config of kernel in attachment,
> I apply all three patches from hot-fixes.
> 

The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png

It would appear that gdth_timeout() is passing a bad pointer into
spin_lock_irqsave().
