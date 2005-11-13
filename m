From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 16:51:09 -0500
Message-ID: <1131918669.3759.3.camel@mulgrave>
References: <20051113180358.35896.qmail@web88004.mail.re2.yahoo.com>
	 <1131906086.3291.10.camel@mulgrave>  <43779709.5070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14006 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750751AbVKMVwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 16:52:17 -0500
In-Reply-To: <43779709.5070404@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Graham Knap <graham.knap@rogers.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Sun, 2005-11-13 at 14:42 -0500, Doug Ledford wrote:
> The device is on a non-LVD bus.  Certain devices were created back when 
> the spec still stated that using PPR negotiation messages on a non-LVD 
> bus was a no-no.  As the echo buffer was an addition to support DV, and 
> originally DV wasn't intended to be used on non-LVD busses, it might 
> stand to reason that this device simply is going tits up because we are 
> attempting to use the echo buffer while in SE mode.  Checking that 
> PPR/DT is valid (not just between controller and device, but also given 
> bus mode) and only using echo buffer DV when all LVD conditions are met 
> would likely solve the problem (assuming that the problem is what you 
> are referring to).

I think so (pending confirmation of the patch working).  The current DV
code assumes that if the device claims DT support in the INQUIRY data
*and* it returns a valid descriptor to the READ_BUFFER descriptors
command then enhanced DV should be attempted.

What I'm contemplating doing (which is what you also suggest) is
tightening up the check so if the standard DV read tests produce a
negotiation that doesn't set DT then we won't attempt enhanced DV

James


