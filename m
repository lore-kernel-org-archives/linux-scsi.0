From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: FCP target reset
Date: Tue, 04 Aug 2009 11:20:25 -0500
Message-ID: <1249402825.3939.7.camel@mulgrave.site>
References: <20090803162302.GA9872@schmichrtp.de.ibm.com>
	 <4A774AC8.8080805@emulex.com> <4A7847E4.8090304@interlog.com>
	 <4A785BED.7070608@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43176 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770AbZHDQU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 12:20:28 -0400
In-Reply-To: <4A785BED.7070608@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2009-08-04 at 12:03 -0400, James Smart wrote:
> 
> Douglas Gilbert wrote:
> > It looks like "target reset" is being phased out of SCSI
> > terminology and being partially replaced by "hard reset".
> 
> Well, there's still an "I_T Nexus Reset" within the TMF area, which FCP-4 
> provides no mapping for, but does define how to create a I_T Nexus loss event.
> 
> Headache is there's history... SPI BDRs did full target resets and killed i/o 
> for all initiators. Target Reset and FCP-2 gave same kind of semantic. FCP-3 
> and later tried to make initiators better citizens and isolate reset semantics 
> if possible. Unfortunately, there's lots of users that equate FC to SCSI, SCSI 
> to SPI, and assume SPI-like semantics. So changing things just to be 
> standard-compliant always seems to upset someone (and it's usually the most 
> critical someone).

The headache with dropping TDR is going to be SCSI-2 reservations.  They
need some type of reset to trigger release.  LUN reset will do it, but
it's a new addition and we don't currently have a SG_SCSI_RESET_XXX
allocated to it so there's no way userland can request it at the moment.

James


