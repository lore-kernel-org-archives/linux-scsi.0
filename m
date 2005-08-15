From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 10:53:54 -0500
Message-ID: <1124121234.5089.14.camel@mulgrave>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com>
	 <1124119431.5089.9.camel@mulgrave>  <4300B7C4.8060400@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:33484 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964806AbVHOPyE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:54:04 -0400
In-Reply-To: <4300B7C4.8060400@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 11:41 -0400, Luben Tuikov wrote:
> Hmm, you've 
>     "found an actual use for channel (exposing underlying physical discs
>      of raid devices)".
> 
> I'm completely befuddled James.

For RAID cards in the SCSI subsystem that export RAID devices as SCSI
devices, there's a need of a standard way to get at the underlying
devices (for DV, parameter setting or configuration).  The idea is to
expose these devices on a non zero channel.

> What if we didn't have "channel" (SPI leftover) in the first place?
> Or, if an LU is implemented as a RAID device, how do you find out its
> individual disks?

It's not a SPI leftover.  It's used by HBA's that have two channels that
genuinely share resources.  Although most modern SCSI cards simply have
two chips (and hence two separate HBAs) per channel, there are a few, of
which the qlogic fc card is one, that still have this one chip per two
channels model.

> Is there a spec or standard that you're following in doing this?

It's an OS abstraction, so no.

James


