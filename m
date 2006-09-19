From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptspi : min_period, max_offset, max_width,
	incorrectly set, resulting domain validation failing
Date: Mon, 18 Sep 2006 23:52:41 -0400
Message-ID: <1158637961.6390.75.camel@mulgrave.il.steeleye.com>
References: <20060918234546.GB7576@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60885 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752025AbWISD5h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 23:57:37 -0400
In-Reply-To: <20060918234546.GB7576@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-09-18 at 17:45 -0600, Eric Moore wrote:
> The default nego parameters are only usign values from NVRAM,
> which is incorrect. Typically you will find the NVRAM parameters
> set for U320 speeds, even when all the devices are U160.
> Thus its possible for the spi transport layer to try negotiating
> devices at a faster speed than it can support. In some cases,
> devices can not handle faster negoiation, and will never complete
> the command invoking scsi-mid layer error handling, or worse, hang the
> bus.

This analysis doesn't quit sound correct to me.  The SPI layer is
designed to use all the inquiry parameters to determine the max
settings.  We ignore anything the driver has done (in fact, we really
expect that before DV begins the device should be narrow async).

These heuristics, by the way, have been tweaked to try to avoid taking
devices through known problematic states (such as PPR negotiation on an
non-LVD bus).

> This patch will look at inquiry data, and determing the maximum nego a
> device
> can handle.   We still take into account the NVRAM settings.  The
> three routines that interpret the inquiry data for domain validation,
> are moved over from mptscish.c to mptspi.c; and  spi_min_period,
> spi_max_offset, and spi_max_width are set from
> mptspi_setTargetNegoParms.

All of this should be done already in the generic code ... it knows full
well that the min and max taken from the BIOS are likely
"overoptimistic" so it doesn't begin with them as the negotiation ... it
begins with whatever the device can support from its inquiry data and
then reduces these so as not to go over/under the min/max settings

Can you post the problem you're actually having?  If there's a
negotiation problem in the SPI transport class, it's likely not specific
to the mptspi driver.

James


