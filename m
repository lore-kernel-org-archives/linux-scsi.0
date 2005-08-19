From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: libata error handling
Date: Fri, 19 Aug 2005 16:03:15 -0400
Message-ID: <43063B03.8050008@adaptec.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org> <430556BF.5070004@pobox.com> <4306290B.6080608@adaptec.com> <20050819193853.GA1549@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965133AbVHSUDd@vger.kernel.org>
In-Reply-To: <20050819193853.GA1549@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On 08/19/05 15:38, Patrick Mansfield wrote:
> On Fri, Aug 19, 2005 at 02:46:35PM -0400, Luben Tuikov wrote:
> 
> 
>>Using the command time out hook and the strategy routine, gives _complete_
>>control over host recovery, and I really do mean _complete_.
>>
> 
> 
> I assume you mean hostt->eh_timed_out.

Hi Patrick, how are you?

Yes, this is what I meant, sorry for not being clear.

> Is anyone implmenting (or has implemented) a ->eh_timed_out function? I see
> none in mainline kernel.

Yes, I have.

> I was looking at using it in an LLDD, but hit two problems, and have
> started to work on an alternate approach of cancelling (aborting or wtf you
> want to call it) a list of commands in the eh thread.

The eh_timed_out + eh_strategy_handler is actually pretty perfect,
and _complete_, for any application and purpose in recovering a
LU/device/host (in that order ;-) ).

> The two problems I see with the hook are:
> 
> It calls the driver in interrupt context, so the called function can't
> sleep.

Consider this: When SCSI Core told you that the command timed out,
	A) it has already finished,
	B) it hasn't already finished.

In case A, you can return EH_HANDLED.  In case B, you return
EH_NOT_HANDLED, and deal with it in the eh_strategy_handler.
(Hint: you can still "finish" it from there.)

EH_RESET_TIMER is not really needed provided that
	- your interface infrastructure is in place,
	- you set the timeout value properly in slave_configure.

> There is no queueing or list mechanism, so LLDD's that can only cancel one
> command at a time will have problem.

See above.

	Luben
