From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Mon, 24 Mar 2008 23:09:08 -0400
Message-ID: <47E86CD4.7040502@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org>	 <1206128662.2961.37.camel@localhost.localdomain>	 <47E41C50.4020406@garzik.org>	 <1206133280.2961.45.camel@localhost.localdomain>	 <47E422F1.7080806@garzik.org>	 <1206133787.2961.52.camel@localhost.localdomain>	 <47E424E2.1030801@garzik.org>	 <1206136150.2961.79.camel@localhost.localdomain>	 <47E4383F.4030804@garzik.org> <1206139925.2961.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47901 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbYCYDJL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 23:09:11 -0400
In-Reply-To: <1206139925.2961.94.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> The current published API is the media_events file.  HAL is using that
> to indicate support for AN.  This is why we can't simply change it to 1
> wholesale because we'll confuse HAL (HAL still has to send polling
> events if AN isn't supported).
> 
> So, the best fix for 2.6.25 at the current -rc6 is to keep the meaning
> of the media_change file the same (0 for no AN, 1 for AN) and let HAL
> take the polled events via udev, which basically means it's preserving
> the behaviour and isn't a regression.
> 
> For 2.6.26 we can add a new media_events_polled (or some other name)
> file, fix the sysfs ro attribute and make them true writeable filters so
> some raving user can turn off polled events if they want and everyone
> will be happy.


So version 3 of the interface will be the first stable and usable one... 
sigh :/

It's just disheartening that the userspace filtering stuff (including 
interface) was disabled rather than fixed, given that that change came 
first and arguably the follow-on change (285e9670) was an abuse of the 
API that was never corrected -- which seems to be tacitly acknowledged 
since everyone seems to agree more than one flag is needed.

	Jeff


