From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: Thu, 24 Jul 2003 11:47:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1382692704.1059068823@aslan.btc.adaptec.com>
References: <20030724151233.E9280@laokoon.bug.net> <1059057411.6798.30.camel@carwash.duncangibb.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:44166 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263590AbTGXRaP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 13:30:15 -0400
In-Reply-To: <1059057411.6798.30.camel@carwash.duncangibb.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>, Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Cc: linux-scsi@vger.kernel.org

> If I try to scan something, Xsane hangs for a while, then recovers OK. 
> But if I put a CD in the Yamaha drive, anything which touches the scsi
> subsystem from then on will hang.

It looks like you have a very flakey bus.  The BSY line is probably
glitching.  In the trace you provided, we successfully selected the
device at ID 3 and are waiting for the target to take us to the first
phase.  The REQ for that phase never occurs and in fact the BSY line
is not always driven.  Very, very weird.  The target controls both
the REQ and BSY lines, so this is either a problem with the target,
your cabling, or your termination.

--
Justin

