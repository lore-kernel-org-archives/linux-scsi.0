From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: 05 Oct 2004 09:56:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096988167.2064.7.camel@mulgrave>
References: <1096401785.13936.5.camel@localhost.localdomain>	<1096467125.2028.11.camel@m
	ulgrave> 	<20041005114951.GD22396@krispykreme.ozlabs.ibm.com>
	<1096984590.1765.2.camel@mulgrave>  <4162B345.9000806@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41104 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269012AbUJEO4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 10:56:11 -0400
In-Reply-To: <4162B345.9000806@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 09:44, Mark Lord wrote:
> There seem to be other holes/races in this and related code.
> 
> The QStor driver implements hot insertion/removal of drives.
> 
> One thing it has to cope with at present is, after notifying
> the mid-layer that a drive has been removed, the mid-layer calls
> back with a synchronize-cache command for that drive..

This is expected behaviour.  For orderly removal an cache sync command
must be sent to drives with a writeback cache before they're powered
down.  For forced ejection, the driver has to error the command.

James


