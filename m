From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: generating a Linux WWN?
Date: Wed, 3 Oct 2007 20:23:14 -0700
Message-ID: <7579f7fb0710032023x6773075ga0342033e8f6f3a4@mail.gmail.com>
References: <20071003.151729.95504687.davem@davemloft.net>
	 <189434.76759.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:12670 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXJDDXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 23:23:16 -0400
Received: by wa-out-1112.google.com with SMTP id v27so44146wah
        for <linux-scsi@vger.kernel.org>; Wed, 03 Oct 2007 20:23:15 -0700 (PDT)
In-Reply-To: <189434.76759.qm@web31810.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

> But having a WWN generator in the kernel, although not terribly
> difficult to write, makes it possible to create an inconsistent
> storage domain.  It is that possibility which troubles me,
> due to the intention of SAS WWNs.

But one should make sure that you *do* create a consistent storage
domain. If you can seed the system with a couple dozen free WWNs for
use when/if needed, why not?

People are content to believe that UUID generation is sufficiently
unique, and for the bit space it occupies that's probably a reasonable
clain. But you can't jam that into the smaller bit space WWNs.

For smaller bit spaces like 64 bit WWNs, you cannot, as you correctly
point out, generate reliably unique numbers all by youself. The
closest you could probably come is using a type 5 WWN with a known
single OUI and then use "seconds since January 1 2007" as a serial
number in the 36 bit VID space that gives you about 8 years before it
wraps- the likely collision rate here would be pretty low.

A much better choice is to get real stamped serial number WWNs. I also
hold with some of the other folks on this discussion that some of this
is policy that the admin should be allowed to choose. After they've
segmented the company's main fabric by choosing unwisely and
forgetting to practice safe zoning we'll choose to buy them a drink or
two.
