From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 12:28:19 -0500
Message-ID: <44087CB3.4010305@garzik.org>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com> <1141399404.3928.5.camel@mulgrave.il.steeleye.com> <440867B7.70703@s5r6.in-berlin.de> <1141403188.3928.16.camel@mulgrave.il.steeleye.com> <20060303170356.GA31136@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:33933 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030257AbWCCR20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 12:28:26 -0500
In-Reply-To: <20060303170356.GA31136@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@osdl.org>

Mike Anderson wrote:
> Well this may not be kernel issue, the perception to many users is that
> something is wrong with the IO subsystem.  I would agree we know how to
> solve this, but I have need seen any distro based mkinitrd scripts
> generate an initrd with a "wait for root dev" step. 
> 
> Does anyone know of a distro initrd / initramfs creation script that has
> this support? As a side note I do not understand historically why one
> would every want to leave the initrd without a root dev present and end in
> an oops.

s/oops/panic/, you mean.

IMO there are two philosophical positions here:

1) "the Linus position":  discovery should be in-kernel, because 
otherwise, users with a missing/screwed initrd will simply not be able 
to boot.

2) "the purist position":  discovery initiated/controlled by userland 
gives us a LOT more flexibility, and keeps obviously-userspace code out 
of the kernel.

Both have their merits:  The Linus position means all users will boot, 
but with the disadvantage that the kernel cannot know which SAS WWN is 
the desired boot device, and other state such as connection/topology 
parameters.  The purist position guarantees you the 
topology/rootdev/etc. that you want, but you MUST have the necessary 
initrd glue, otherwise the driver is useless.

A compromise position might be, do discovery in kernel, using hints from 
userspace IF AVAILABLE.

	Jeff

