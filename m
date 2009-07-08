From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 08 Jul 2009 16:44:05 +0000
Message-ID: <1247071445.4159.214.camel@mulgrave.site>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
	 <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	 <1247063244.4159.40.camel@mulgrave.site>  <1247069178.5973.6.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51143 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbZGHQoL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 12:44:11 -0400
In-Reply-To: <1247069178.5973.6.camel@desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2009-07-08 at 09:06 -0700, Daniel Walker wrote:
> On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
> > 
> > You might also try this patch from martin petersen:  it will print out
> > the actual command that's causing the problems ... that might give a
> > clue.
> > 
> > James
> 
> On the bugzilla entry ,
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13727
> 
> Thomas Meyer indicated it was (possibly) the following commit,
> 
> 018e0446890661504783f92388ecce7138c1566d
> 
> I added Jens to the CC ..

So thats:

commit 018e0446890661504783f92388ecce7138c1566d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 26 16:27:10 2009 +0200

    block: get rid of queue-private command filter

What this tends to suggest is that the command filter was blocking some
type of command sent from user space which is causing the problem, and
now we're letting it through.  Restoring the command filter will work
around the problem, but the root cause should be finding and fixing
whatever is issuing the commands in the first place.

James


