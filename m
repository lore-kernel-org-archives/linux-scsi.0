From: Falk Hueffner <falk.hueffner@student.uni-tuebingen.de>
Subject: Re: BUG: Kernel Panic: kernel-2.6.0-test9-bk21  for alpha in scsi context ll_rw_blk.c
Date: 17 Nov 2003 22:48:49 +0100
Sender: linux-alpha-owner@vger.kernel.org
Message-ID: <87islid5tq.fsf@student.uni-tuebingen.de>
References: <3FB92938.8040906@steudten.com>
	<87r806d6n6.fsf@student.uni-tuebingen.de> <3FB93EF6.807@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <3FB93EF6.807@steudten.com>
To: alpha@steudten.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thomas Steudten <alpha@steudten.com> writes:

> On http://steudten.com/alpha/perf.php4 you can read:
> See prefetch section:
> The Alpha 21264 initiates a prefetch operation by executing one of the
> load instructions as summarized in the table below. Note that the
> destination register is R31 or F31. When used as a source register,
> R31 and F31 return integer zero and floating point zero,
> respectively. When used as a destination register as shown below, R31
> and F31 denote the purpose of these instructions as a prefetch
> operation. Earlier Alpha implementations ignore these
> instructions. Some care must be taken as a prefetch with an invalid
> address must be dismissed by firmware and a prefetch can cause an
> alignment trap.

Well, the architecture manual requires these instructions have no
visible effect whatsoever, i. e. they never trap. It seems sensible to
me to enforce this also in kernel space, since this is what gcc
assumes.

-- 
	Falk
