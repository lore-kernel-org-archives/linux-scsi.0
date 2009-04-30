From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] block: add rq->resid_len
Date: Thu, 30 Apr 2009 10:59:10 +0900
Message-ID: <49F905EE.2020407@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>	 <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

James Bottomley wrote:
> This looks good (although I'd like to test it first).

Yeah, this will need quite a bit of testing.

> Might it not be better to have an accessor setting resid_len?  All
> the other patches in the series insulate users from the actual
> members of struct request by accessors, so this is a bit the odd man
> out.

I actually think it's better to expose resid_len in this case as the
semantics of the field is - initialized to zero on issue, contains
residual count on completion and whatever it contains inbetween is
upto the low level driver.  Request position or length are different
as they must contain well defined values throughout request processing
and both block layer and low level driver should agree on what they
mean.

Fancy words aside, it basically boils down to allowing llds to do
either "rq->resid_len = blk_rq_bytes() - xferred" on completion or
"rq->resid_len = blk_rq_bytes()" on issue and "rq->resid_len -=
increments" while processing.

It would be better to check that the value is sane on completion tho.

Thanks.

-- 
tejun
