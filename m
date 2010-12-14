From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Tue, 14 Dec 2010 10:53:30 +0100
Message-ID: <4D073E9A.3000608@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org> <1292194113.2989.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292194113.2989.9.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On 12/12/2010 11:48 PM, James Bottomley wrote:
> The analysis above isn't quite correct, I'm afraid.  We use the
> execute_in_process_context() not to avoid deadlocks, but to acquire
> process context if we don't have it because the API allows calling from
> sites at interrupt context.  The point of using
> execute_in_process_context() is that we actually want to make use of the
> user context if we have one ... there's no point using a workqueue in
> that case, because there's nothing to be gained (except to slow
> everything down).  We have no ordering constraints (the traditional
> reason for using workqueues) so this is purely about context.

Sure, what I tried to say was that the change couldn't introduce
deadlock no matter how it was used.  Sure execute_in_process_context()
would be slightly more efficient, but it currently is used a few times
only in quite cold paths where optimization isn't necessary at all and
the API is somewhat incomplete in that it doesn't provide ordering or
synchronization APIs.

So, unless there's a compelling reason, let's remove it.  It has been
there for quite some time now and hasn't grown any other users.  There
wouldn't be any noticeable difference for the current users either.
If you really like to keep it in the current users, let's move it into
SCSI.  I don't see much reason to keep it as a part of generic
workqueue API in its current form.

Thank you.

-- 
tejun
