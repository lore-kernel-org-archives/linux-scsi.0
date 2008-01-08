From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 20:32:03 +0100
Message-ID: <4783CFB3.7030108@s5r6.in-berlin.de>
References: <47837E06.5080406@novell.com> <20080108140151.GD16309@parisc-linux.org> <4783B93B.70307@s5r6.in-berlin.de> <20080108182205.GG16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33169 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbYAHTdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 14:33:03 -0500
In-Reply-To: <20080108182205.GG16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> According to SPC4r05a, READ CAPACITY(10) (opcode 25) is Mandatory for D,
> W and O.  READ CAPACITY (opcode 25) is Optional for R.  READ CARD
> CAPACITY (also opcode 25) is Mandatory for K.
[...]
> According to this table (D.2 for anyone following along at home), RBC
> devices are not supposed to implement it.

RBC (last draft in 1999, last amendment in 2003) and SPC4 (last draft in
2007) are in contradiction in this regard.  It looks like an error in
SPC4 to me.

[...]
> It would be thoroughly inappropriate to put this workaround in the
> midlayer.  sbp2 isn't a good place either, but it's better than
> sg/sd/scsi_ioctl/...

Three workarounds are possible, all of them work at the command set level:
  - Inject READ CAPACITY after INQUIRY.
  - Don't let INQUIRY through to the device (except the kernel's initial
    one) and return synthesized inquiry data to the application.
  - Don't issue INQUIRY at all (except the kernel's initial one).

*None* of these workarounds belongs into SCSI midlayer nor into anything
below it.  Most certainly not into the SBP-2 transport layer.  If at
all, the SBP-2 layer could contain a detection of affected firmwares,
but not the workaround itself.

Since userspace is issuing the problematic commands, one /might/ think
about implementing the workaround directly at the kernel's userspace
interface.  You could think of it as a filter then.  If you don't like
such a filtering, leave the workaround to userspace.  And the latter is
IMO most preferrable, like James already wrote:  Don't let hald issue
INQUIRY in the first place.
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
