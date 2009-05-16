From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
Date: Sun, 17 May 2009 07:18:18 +0900
Message-ID: <4A0F3BAA.1050907@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org> <4A0EC2AD.20704@ru.mvista.com> <4A0ECF8E.6000209@kernel.org> <4A0F1A55.8080701@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0F1A55.8080701@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hello, Sergei.

Sergei Shtylyov wrote:
>> Similar response as the if/else one on the other thread.  Is it really
>> any significantly better?  The 'duplication' here is basically one
>> liner
> 
>   Not true, it's 3-liner. I wouldn't bother with one liner.

The final result is...

	req = blk_fetch_request(q);
	while (req) {
		int err = -EIO;

That looks like one liner to me.

>> after the peek/fetch change
> 
>   The peek/fetch code itself is duplicated. :-/

Do you mean by inlining?  Please note that blk_fetch_request() is not
inlined anymore after Fujita's bidi end_request cleanup patches.

>> and when the duplication is minimal,
>> I usually find it clearer to put the loop condition at the while
>> clause itself.
> 
>   No problem, we could just keep an old form of *while* loop.
> 
>> If you think it's significantly better,
> 
>   I do hink it avoids duplicating peek/fetch code.
> 
>> please go ahead and submit the patch but to me the change you're
>> proposing is
>> basically cosmetic and not even a clearly better one at that.
> 
> Should probably look at the resulting assembly to see how much it's
> differrent.

Do you seriously think it's worthwhile to optimize the request loop
according to assembly generation?  That sounds like a bad case of over
(micro) optimization to me.  It's not gonna make any noticeable
difference and the changes you make today can be irrelevant or even
deterimental tomorrow depending on any number of parameters.  Please
don't do it for performance reasons.

Thanks.

-- 
tejun
