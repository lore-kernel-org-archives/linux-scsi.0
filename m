From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function '__symbol_get'
Date: Sun, 14 Jun 2009 07:51:07 -0700
Message-ID: <C27F8246C663564A84BB7AB343977242178EE78068@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <1244988911.4096.23.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3237 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZFNOvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2009 10:51:14 -0400
In-Reply-To: <1244988911.4096.23.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Sat, 2009-06-13 at 19:18 -0700, Michael Chan wrote:
> >
> > This will require some additional infra-structure.  We can look into
> > this when we support the 10G driver.  Thanks.
>
> So if you're going to redo it for the 10G driver, and without the 10G
> driver there really seems no need to have a call by
> reflection in there,
> why not simply do a direct call until the 10G driver is added?  This
> will save everyone potential hassle from what is a highly unusual
> interface.
>

There's an additional usage issue if we switch to a direct call.  The
cnic driver will now have a permanent reference on the bnx2 driver
after it is loaded.  Networking users will be unable to unload the
bnx2 driver once the cnic driver is loaded.

This may not be a serious issue, but one of the goals of the design is
to have minmal impact on networking users.  Since kernel 2.6, users
have been able to unload networking drivers at any time.

Thanks.


