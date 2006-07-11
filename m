From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptsas : reserving a channel for integrated raid
Date: Tue, 11 Jul 2006 15:11:22 -0400
Message-ID: <1152645083.3575.67.camel@mulgrave.il.steeleye.com>
References: <20060711162543.GA11553@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1505 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932088AbWGKTL0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 15:11:26 -0400
In-Reply-To: <20060711162543.GA11553@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-07-11 at 10:25 -0600, Eric Moore wrote:
> Recent changes in the sas transport layer have taken
> ownership of port_id(channel) assignments. Previously
> this was owned by the scsi lld, and mptsas code was written
> to reserve the channel beyond the last port id for integrated
> raid.  With this change in the transport layer, any non-raid devices
> that land on the reserved channel will not be detected due to
> improper firmware h:c:t:l mapping calculation.
> 
> This patch moves the reserved channel to -1. This can be
> easily changed to some other value in the future release
> since its a hash define.

I don't think -1 showing up in the channel field is a good idea ... I
bet it will confuse parsers of that information.

> Its higly doubtfull the transport layer would ever
> use up all the port ids, and wrap back around to zero since
> this is int.

Do we still need this channel number as port number stuff anyway?
Originally it was the outgoing phy that was identified in the channel,
but even that's no longer true.  Since the target ids are assigned per
HBA, they're unique enough without requiring additional channel
stuff ... how about killing the non zero channel in the sas transport
class and then you can simply use 1 for the raid virtual channel?

James


