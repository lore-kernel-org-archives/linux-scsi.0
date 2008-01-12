From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Only print SCSI data direction warning once for a
	command
Date: Sat, 12 Jan 2008 13:36:24 -0600
Message-ID: <1200166584.3656.36.camel@localhost.localdomain>
References: <200801020703.01180.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50725 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643AbYALTgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 14:36:31 -0500
In-Reply-To: <200801020703.01180.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net

On Wed, 2008-01-02 at 07:03 +0100, Andi Kleen wrote:
> When I use cdparanoia my logs get spammed a lot by
> 
> printk: 464 messages suppressed.
> sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
>    program cdparanoia not setting count and/or reply_len properly
> printk: 1078 messages suppressed.
> 
> and many more of those. With this patch the message is only printed once
> for a command in a row.

My reaction is that the intent of these warnings is to try to get people
to fix broken applications, so I'm not sure any action is appropriate;
however, it's Doug's driver, so I'll defer to him.

Even if he does say yes, though, your patch looks wrong.  It's still
going to spew the 

printk: 1078 messages suppressed.

to the log because they come from printk_ratelimit().  So all you've
done is halved the volume of flow to the logs and left a dangling printk
suppressed message that keeps spewing, so I don't think the patch even
does what you describe it as doing ...  if you reverse the order of the
operands in the if() it will ...

James


