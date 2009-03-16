From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi tree build failure
Date: Mon, 16 Mar 2009 08:22:22 -0500
Message-ID: <1237209742.3257.33.camel@localhost.localdomain>
References: <20090316213945.e33f3427.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51686 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbZCPNW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Mar 2009 09:22:28 -0400
In-Reply-To: <20090316213945.e33f3427.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Eric Moore <eric.moore@lsi.com>, peter Bogdanovic <pbog@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-03-16 at 21:39 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/message/built-in.o:(.data.rel+0x88): multiple definition of `ioc_list'
> drivers/scsi/built-in.o:(.data.rel+0x2760): first defined here
> 
> Caused by commit 635374e7eb110e80d9918b8611198edd56a32975 ("[SCSI]
> mpt2sas v00.100.11.15").  ioc_list is not a good choice for a global
> name.  The other definition is in drivers/message/fusion/mptbase.c.
> 
> I have reverted that commit for today.

Eric,

Vould we get this one sorted out before the merge window opens? ... the
simple fix seems to be to rename ioc_list in mpt2sas ... and track down
any more global symbols with unfortunate names.

James


