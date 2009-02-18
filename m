From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12733] mpt fusion driver crashes with LSI22320SE
	installed and BIOS ACPI turned off
Date: Wed, 18 Feb 2009 15:31:30 +0000
Message-ID: <1234971090.3225.11.camel@localhost.localdomain>
References: <20090217234024.35389108040@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36583 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbZBRPbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 10:31:33 -0500
In-Reply-To: <20090217234024.35389108040@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-02-17 at 15:40 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12733
> 
> 
> 
> 
> 
> ------- Comment #2 from mvolaski@aecom.yu.edu  2009-02-17 15:40 -------
> With an LSI 8704ELP and LSI SAS3081E-R present and ACPI off, the board works
> fine. Only the presence of an LSI 22320 causes a crash. 
> 
> I don't know about the interrupt number. When I receive the cards back, I can
> can try to find out.
> 
> Our vendor has tested at least one other manufacturer's board with the LSI
> 22320 and it, too, shows the same crashing behavior when ACPI is turned off.

But the point is that I don't think this is a MPT bug ... it's using the
IRQ line the platform code assigns to it.  If that IRQ line is wrong,
you get the symptoms you're displaying (misrouted IRQ).

I'm not even sure this is a bug:  some modern motherboards simply can't
be configured without ACPI because there's no way to get the IRQ routing
information otherwise.

If your motherboard isn't one of these, then it could be a failure of
the non-ACPI IRQ routing platform code.  None of this can be diagnosed
from the snippet of the log you posted.

James


