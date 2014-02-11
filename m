From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Tue, 11 Feb 2014 10:56:38 -0600
Message-ID: <52FA5646.4070009@tributary.com>
References: <1392030699-105348-1-git-send-email-hare@suse.de> <52F91535.4010905@tributary.com> <52F9E00B.7070707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:57341 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBKQ4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2014 11:56:45 -0500
In-Reply-To: <52F9E00B.7070707@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 2/11/2014 2:32 AM, Hannes Reinecke wrote:
> The problem with page 0x80 is that (per spec) it's vendor-defined. So there
> is no guarantee for it to be unique in any sense. Which makes it rather
> impractical for normal use.
> 
> Hence we typically rely on page 0x83 to identify a device, be it for udev
> or multipath.

	AFAIK is not vendor defined page, its just not marked as "mandatory" by T10.
For tape (which I what I thought brought much of this on) it is basically
mandatory. Which is another place where the spec doesn't sync with the real
world.

	That is because it is the _ONLY_ vendor neutral method to autoconfigure tape
libraries. The tape libraries export the drive serial numbers via READ ELEMENT
STATUS, dvcid=1. Which means its the de facto method for backup/media manager
applications. A tape/media changer device that crashes or fails to return useful
0x80 information will have a very short life in the market.

	For sure, it would work better than the existing method being used by udev (for
tape), which fails (per my other posting) because there is often insufficient
information in 0x83 to uniquely identify devices.




	
