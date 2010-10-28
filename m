From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: sym53c8xx_2 data corruption
Date: Wed, 27 Oct 2010 23:59:22 -0600
Message-ID: <20101028055922.GE32200@lackof.org>
References: <20101027012932.3CB6E4FB4@hiauly1.hia.nrc.ca> <1288155041.19649.354.camel@mulgrave.site> <alpine.DEB.1.10.1010271059230.31946@artax.karlin.mff.cuni.cz> <1288190807.4692.30.camel@mulgrave.site> <alpine.DEB.1.10.1010271803010.18202@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from complete.lackof.org ([198.49.126.79]:34513 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0J1GGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 02:06:40 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1010271803010.18202@artax.karlin.mff.cuni.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx

On Wed, Oct 27, 2010 at 06:19:32PM +0200, Mikulas Patocka wrote:
...
> Requeuing forever is dangerous anyway, a device returning QUEUE_FULL 
> constantly could deadlock the system. Question: is it better to risk a 
> deadlock with a broken device or to risk a false timeout under high load? 
> --- I don't know --- maybe there are valid cases where the device is 
> returning QUEUE_FULL for long time (some raid reconfiguration?) ... do you 
> know about them?

This was a problem in multi-initiator SCSI systems and I'm guessing also
an issue for FC SAN. Multiple hosts "compete" for filling the device's
available command slots. If all hosts used available queue_depth
(say 32 commands) and device only supported 64 commands at a time,
then the 65th command from host #3 might get QUEUEFULL status back.

I'm not sure what the difference is to BUSY status. Wikipedia
suggests "QUEUE_FULL" is a hint that the device is already
processing commands from the same initiator.

hth,
grant
