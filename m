From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 09:56:48 -0600
Message-ID: <1297785408.3015.22.camel@mulgrave.site>
References: <4D5A9631.6050708@ngs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1BOP4x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2011 10:56:53 -0500
In-Reply-To: <4D5A9631.6050708@ngs.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bokhan Artem <aptem@ngs.ru>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-02-15 at 21:05 +0600, Bokhan Artem wrote:
> Hello!
> 
> I'm trying to get/set sctserc (SMART Command Transport Error Recovery 
> Control) data from sata disk attached to lsi megaraid controller with 
> smartmontools, but this function does not work.
> 
> I want to figure out: is this driver or firmware issue? May someone to 
> help to fix this?
> 
> The issue can be described as follows:
> 
> The ATA PASS-THROUGH(16) implementation in the SAT layer of the megaraid 
> driver or firmware does not return the ATA output registers if 
> requested. This violates SAT standard (http://www.t10.org/drafts.htm#SAT).
> 
> Expected: If CK_COND (bit 5 of CDB[2]) is set, ATA PASS-THROUGH(16) 
> (CDB[0] = 0x85) shall return a CHECK CONDITION even if the ATA command 
> completed successfully, and return the ATA output registers in the sense 
> data using ATA return descriptor format (descriptor code 0x09).
> 
> Observed: If CK_COND is set and the ATA command completed successfully, 
> ATA PASS-THROUGH(16) does not return a CHECK CONDITION or the sense data 
> does not contain an ATA return descriptor.

>From the description, it's a firmware issue ... the driver tends to
return exactly what the firmware tells it.  There's definitely no
special processing for ATA_12 or ATA_16 commands, they're treated as
normal SCSI ones, so if there's no SAM_STAT_CHECK_CONDITION, the
firmware isn't sending one.

James


