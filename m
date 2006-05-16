From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:30:42 -0500
Message-ID: <1147797042.3505.44.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
	 <4469F879.9020009@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27343 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751856AbWEPQcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:32:39 -0400
In-Reply-To: <4469F879.9020009@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

On Tue, 2006-05-16 at 12:06 -0400, Jeff Garzik wrote:
> Sigh.  They clearly do not have the same effect, because the above code 
> guarantees that a timeout is forced, regardless of whether the timer has 
> fired or not.  That in turn guarantees that the timeout callback 
> (->eh_timed_out) is called, and the cmd is in a very specific state.

the API claims to be forcibly aborting a command, which is *not* a
timeout  ... trying to pretend to the midlayer that it is is the wrong
processing model.  You may choose to call this API because of a class
internal timeout, but you don't need the callback notification that it
is a timeout in this case, you already know it is.

> Completion-or-timeout has none of these attributes.
> 
> Any alternative is forced to deal with two very different command, and 
> EH, states...  to achieve the same eventual result.  Thus, the code 
> presented is the one of least complexity, AFAICS.

James


