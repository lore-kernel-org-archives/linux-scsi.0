From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Mon, 09 Jun 2014 10:29:06 -0700
Message-ID: <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
	 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54079 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbaFIR3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2014 13:29:10 -0400
In-Reply-To: <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Haber <steven@qumulo.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Mon, 2014-06-09 at 10:21 -0700, Steven Haber wrote:
> Thanks a bunch James! I patched and ran our suite over the weekend and
> didn't see any failures at all. I also didn't notice any side effects.
> I poked through the kernel logs and everything looked like it did
> before. I'll let you know if anything else weird crops up. Any idea
> when this will get checked in?

I'll do it as a bug fix, but I do need Jens to make sure nothing else
breaks first.  Best I can tell, the state model for compound commands
like flush doesn't expect us to change the request type ... nothing puts
it back to REQ_TYPE_FS.  In your case, the flush is the last command
sent, so there's no problem ... I just worry we will get an obscure
problem later on from something that does a BLOCK_PC prepared first
command.

James


