From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH v2 -mm 4/6] ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
Date: Mon, 9 Jun 2008 19:44:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806091937580.6791@localhost.localdomain>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
  <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212682248.13549.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1212682248.13549.48.camel@localhost.localdomain>
Sender: linux-arch-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, linux-arch@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thu, 5 Jun 2008, James Bottomley wrote:

> I'm also not keen on the use of current->stack.  It looks like this
> commit:
> 
> commit f7e4217b007d1f73e7e3cf10ba4fea4a608c603f
> Author: Roman Zippel <zippel@linux-m68k.org>
> Date:   Wed May 9 02:35:17 2007 -0700
> 
>     rename thread_info to stack
> 
> Introduced a task_stack_page() accessor to get this instead, so perhaps
> we should use it (I've cc'd Roman and linux-arch for opinions).

This helper was mainly introduced to help with the transition from direct 
thread_info access. I don't see this field go away or change somehow in 
the near future, so direct access of stack is IMO ok, but we already have 
the helper, so using it to improve readability is fine too.

bye, Roman
