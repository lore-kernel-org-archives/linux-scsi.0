From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 15:52:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF5396.1030303@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com> <40CF4207.9050108@adaptec.com> <20040615192045.GA13704@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:7560 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265890AbUFOTw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 15:52:56 -0400
In-Reply-To: <20040615192045.GA13704@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> In the patch as is you overload the eh_cmd_timed_out template function

But this method doesn't exist. How can I be overloading it?

> to mean the LLDD wants to try to handle timed out commands plus start /
> restart / stop the timers. This would appear to limit the interface to
> the LLDD doing both operations which should be separate decisions?

I don't understand what you mean here.
 
> Also in the comments for the patch you mention that the LLDD may decide
> to resubmit the IO which I assume is why you would want to have control
> of the timers, but wouldn't the LLDD need to also consult if the IO
> should be resubmitted which propagates these tests and could result in
> inconsistent policy.

But the LLDD *does* know if the IO is to resubmitted, it doesn't have to
consult anyone.  Hint: targets are *passive*, and thus the stipuations in SAM.

That is, if IO is NOT to be continued, then SCSI Core should call
a TMF, ABORT TASK or ABORT TASK SET, via eh_abort_handler(<cmd>).
(Yes, the eh interface doesn't do 1:1 TMF mapping.)

This is how SCSI Core communicates with LLDD, it's not the case that
LLDD asks SCSI Core each and every time for each and every decision.
First it's not by spec, and second it is unattainable both due to
the hardware reasons mentioned by Doug and I and due to the
recovery quirks.

I really don't see why this is such a big deal when SCSI Core
and LLDDs are unaffected.  It is just an _optional_ method
and will do good for SCSI Core. I promise. ;-)

-- 
Luben


