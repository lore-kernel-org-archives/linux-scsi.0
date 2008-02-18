From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Mon, 18 Feb 2008 10:18:40 -0600
Message-ID: <1203351520.3324.27.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
	 <1203089323.3058.20.camel@localhost.localdomain>
	 <47B9958A.8080104@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47650 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYBRQSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 11:18:45 -0500
In-Reply-To: <47B9958A.8080104@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Mon, 2008-02-18 at 22:26 +0800, Keith Hopkins wrote:
> Well, that made life interesting....
>   but didn't seem to fix anything.
> 
> The behavior is about the same as before, but with more verbose
> errors.  I failed one member of the raid and had it rebuild as a
> test...which hangs for a while and the drive falls off-line.

Actually, it now finds the task and tries to do error handling for
it ... so we've now uncovered bugs in the error handler.  It may not
look like it, but this is actually progress.  Although, I'm afraid it's
going to be a bit like peeling an onion: every time one error gets
fixed, you just get to the next layer of errors.

> Please grab the dmesg output in all its gory glory from here:
> http://wiki.hopnet.net/dokuwiki/lib/exe/fetch.php?media=myit:sas:dmesg-20080218-wpatch-fail.txt.gz
> 
> The drive is a Dell OEM drive, but it's not in a Dell system.  There
> is at least one firmware (S527) upgrade for it, but the Dell loader
> refuses to load it (because it isn't in a Dell system...)
> Does anyone know a generic way to load a new firmware onto a SAS drive?

The firmware upgrade tools are usually vendor specific, though because
the format of the firmware file is vendor specific.  Could you just put
it in a dell box to upgrade?

James


