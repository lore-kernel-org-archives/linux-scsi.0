From: Greg KH <greg@kroah.com>
Subject: Re: scsi calls kobject_put() in atomic context
Date: Tue, 17 Jan 2006 15:59:36 -0800
Message-ID: <20060117235936.GB16446@kroah.com>
References: <20060117004217.6329a9a8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:23527 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S932481AbWARAXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 19:23:17 -0500
Content-Disposition: inline
In-Reply-To: <20060117004217.6329a9a8.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2006 at 12:42:17AM -0800, Andrew Morton wrote:
> 
> So Greg added a might_sleep() to kobject_put().  Because on the final put()
> it will indeed do sleepy things.
> 
> Debug: sleeping function called from invalid context at drivers/base/core.c:343
> in_atomic():1, irqs_disabled():0
> 
> Call Trace: <IRQ> <ffffffff80126e07>{__might_sleep+190}
>        <ffffffff802a85ec>{put_device+27} <ffffffff802cd071>{scsi_put_command+186}
>        <ffffffff802d19ca>{scsi_next_command+45} <ffffffff802d1ad7>{scsi_end_request+197}
>        <ffffffff802d1d3b>{scsi_io_completion+447} <ffffffff80308fdf>{sd_rw_intr+559}
>        <ffffffff802cd76a>{scsi_finish_command+148} <ffffffff802d2514>{scsi_softirq_done+220}
>        <ffffffff80228472>{blk_done_softirq+127} <ffffffff8013404b>{__do_softirq+75}
>        <ffffffff8010f13e>{call_softirq+30} <ffffffff80110835>{do_softirq+51}
>        <ffffffff80134188>{irq_exit+63} <ffffffff801107f8>{do_IRQ+55}
>        <ffffffff8010bfb0>{mwait_idle+0} <ffffffff8010e11a>{ret_from_intr+0} <EOI>
>        <ffffffff8010bfb0>{mwait_idle+0} <ffffffff8010bfea>{mwait_idle+58}
>        <ffffffff8010bf7d>{cpu_idle+100} <ffffffff805a6a8b>{start_secondary+1155}
> 
> I guess we already knew about that problem.  Greg, I'll need to drop the
> patch to be able to make a halfway releasable kernel.

Heh, and you wanted me to add it to catch these kinds of things in the
first place :)

Oh well,

greg k-h
