From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in
	sgiwd93.c
Date: Wed, 03 Dec 2008 11:08:43 -0600
Message-ID: <1228324123.5551.25.camel@localhost.localdomain>
References: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
	 <46353.88.114.226.209.1228321494.squirrel@webmail.movial.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40272 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYLCRIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 12:08:44 -0500
In-Reply-To: <46353.88.114.226.209.1228321494.squirrel@webmail.movial.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

On Wed, 2008-12-03 at 18:24 +0200, Vorobiev Dmitri wrote:
> > This patch fixes the following compilation warning:
> >
> >   CC [M]  drivers/scsi/sgiwd93.o
> > drivers/scsi/sgiwd93.c:314: warning: initialization from incompatible
> > pointer type
> >
> 
> Hello James,
> 
> Any news about this one? I think this patch should go via linux-scsi,
> unless you would be insisting on pushing it via linux-mips, in which case
> I'll politely bug Ralf about it. :)

Looks OK for the local change.

Globally, having driver->remove and platform_driver->remove return int
instead of void looks wrong.  Particularly when the only use cases are
in drivers/base/ and they all ignore the return code.

Greg and Kay ... shouldn't we simply redefine the return values for the
remove methods in these structures to return void (and thus match the
use case)?

James


