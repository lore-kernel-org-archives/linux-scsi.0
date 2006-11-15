From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Sony VGP-XL1B (200 disk CD/DVD jukebox)
Date: Wed, 15 Nov 2006 11:05:27 -0500
Message-ID: <455B3AC7.4040208@torque.net>
References: <1162685269.7801.16.camel@localhost.localdomain>	 <1162713408.7801.86.camel@localhost.localdomain>	 <454DB58F.7060401@s5r6.in-berlin.de> <1163578190.7801.187.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19349 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030625AbWKOQFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 11:05:50 -0500
In-Reply-To: <1163578190.7801.187.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394@lightn.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Josha Foust wrote:
<snip>

> My main remaining concern is with the safe operation of the unload
> command.  As I mentioned in a previous email, the media changer is
> perfectly happy to unload a disk from the drive while it is still
> spinning, obviously causing damage to the disk and possibly the changer.
> With the stop command that Dan Dennedy added in his patch to mtx, I can
> get the drive stopped if I retry until the command succeeds.  I am
> worried about race conditions, however.  Is there a way to lock a SCSI
> device for exclusive access so that I can guarantee a safe unload?  I.E.
> that the disk stays stopped while the media changer unloads it.

The PREVENT ALLOW MEDIUM REMOVAL command is defined for
SMC devices (see SPC-3 as SPC-4 has devolved that command
and it is yet to appear explicitly in SMC-3). That isn't
exactly what you asked for but it will impede a START
STOP UNIT (start_bit=0, loej_bit=1) command.

<snip>

Doug Gilbert
