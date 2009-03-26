From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] lpfc : add module parameter that allows
	adapter	instances to avoid attachment
Date: Thu, 26 Mar 2009 15:54:09 -0500
Message-ID: <1238100849.3342.58.camel@localhost.localdomain>
References: <1238097300.27023.2.camel@ogier>
	 <1238098747.3342.54.camel@localhost.localdomain>
	 <49CBE772.80304@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36902 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761621AbZCZUyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 16:54:08 -0400
In-Reply-To: <49CBE772.80304@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2009-03-26 at 16:37 -0400, James Smart wrote:
> The oem requirement we have explicitly states not to use the unbind interface
> (we proposed unbind at first as well).
> 
> The issue is what happens on the link while we are bound for that short
> amount of time. It confuses the things on the other side of the link.
> There's a secondary driver that ends up binding to the adapters we exclude,
> and the things on the other side only expected to see the second driver.

OK, so it sounds like a proposed extension to the generic unbind
interfaces where you specify a no_bind list on the kernel or module
command line.

Also (as Randy pointed out) you don't account for the domain.  However,
you could just by not bothering to convert the string to numbers for the
compare, just compare on dev->bus_id ... which is how a generic one
would work.

James


