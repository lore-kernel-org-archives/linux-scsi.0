From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Patch] plug async scan race at 1st node scan
Date: Mon, 20 Aug 2007 10:02:45 -0400
Message-ID: <46C99F05.7070404@emulex.com>
References: <1187615436.3897.5.camel@localhost.localdomain> <20070820134918.GC30019@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52950 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHTOCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 10:02:51 -0400
In-Reply-To: <20070820134918.GC30019@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, tore@linpro.no

Well - depends on what the semantics of scan_start are.... to date, there
really are none....  and what does requiring it mean ?

What's implied is that you want "bring up link" to be enabled in scan_start().
Doable, but the code paths weren't put together expecting this, so it may be
a bit of work. I'll have to look at it.   Also, you're asking me to fix one
driver, without thinking about the structure in others.... I'd rather the
api itself locked down state/behavior, not simply the LLD coding.

Before starting, I'd rather we setting on what the semantics of the api is.
To the uninitiated, requiring a driver to call scsi_scan_host(), when the
transport drives all discovery, and where the scan_host really has nothing
to do with scanning, but rather creates a firewall delay to hold off serializing
of device enumerations - is all very confusing.  I'd rather we had a different
entry point for those things that supply start/finish routines and it was
named more in line with "start discovery delay".

Adding the notion of scan_start bringing up the link sounds reasonable. However,
how does this translate to other bus types ?

-- james s

Matthew Wilcox wrote:
> On Mon, Aug 20, 2007 at 09:10:35AM -0400, James Smart wrote:
>> In testing 2.6.23-rc3, there is a small window where the async-per-target
>> scan of the transport can beat the call from the LLDD to scsi_scan_host().
> 
> I'd assumed that events wouldn't come in until ->scan_start was called.
> I see lpfc doesn't have one; is it possible to restructure it to have one?
> 
> (In any case, good job tracking this down; it was really annoying me.)
> 
> Possibly we should be less forgiving, and require drivers to have a
> scan_start, otherwise they can't avoid this race.

