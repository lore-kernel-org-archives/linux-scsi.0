From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Sun, 12 Dec 2010 16:48:33 -0600
Message-ID: <1292194113.2989.9.camel@mulgrave.site>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CBD95DC.8000001@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-10-19 at 14:58 +0200, Tejun Heo wrote:
> SCSI is the only subsystem which uses execute_in_process_context().
> With the recent workqueue updates, unconditionally using work wouldn't
> cause deadlocks around execution resources and the two places where
> SCSI uses them are cold paths where using work unconditionally
> wouldn't make any difference.  Drop execute_in_process_context() and
> use work directly.

Sorry, managed to lose this until the ping.

The analysis above isn't quite correct, I'm afraid.  We use the
execute_in_process_context() not to avoid deadlocks, but to acquire
process context if we don't have it because the API allows calling from
sites at interrupt context.  The point of using
execute_in_process_context() is that we actually want to make use of the
user context if we have one ... there's no point using a workqueue in
that case, because there's nothing to be gained (except to slow
everything down).  We have no ordering constraints (the traditional
reason for using workqueues) so this is purely about context.

Alan stern recently did an analysis (at least for the target reap) that
says we actually have no interrupt context call sites, so abandoning the
execute_in_process_context() for a direct call in that case might make
sense.

James
