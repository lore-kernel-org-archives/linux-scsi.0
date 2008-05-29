From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Date: Thu, 29 May 2008 09:55:12 -0500
Message-ID: <1212072912.3428.28.camel@localhost.localdomain>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
	 <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
	 <1212069932.3428.1.camel@localhost.localdomain>
	 <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53195 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344AbYE2OzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2008 10:55:23 -0400
In-Reply-To: <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerb Stralko <gerb.stralko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2008-05-29 at 10:35 -0400, Gerb Stralko wrote:
> So is that printk really needed?  Should the kernel even need to print
> a message like that, esp. if user-space is handling state updates and
> notifications.  Or do i need to configure hald to be quietier?   FWIW
> I'm using fedora core 9 and hald version:
> -bash-3.2$ /usr/sbin/hald --version
> HAL package version: 0.5.11

Actually, I misspoke; it's set internally via sets of ioctls.  However,
it's designed only to show on ioctls that do medium requiring things.

I'm also using FC9 and I see no such messages (and for noisy cgc,
they're printed out for every action on the CD).  You have some
application that's poking the CD wrongly (probably not hal), so you
really need to find out what it is.  It may be pointing to some other
error in the kernel that needs fixing, but simply removing the message
is covering up the issue.

To help track the application, you could update the printk to print out
current->comm and current->pid.  That would tell you who is responsible

James


