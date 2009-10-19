From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: disk restart failure after suspend
Date: Mon, 19 Oct 2009 23:50:29 +0200
Message-ID: <4ADCDF25.8090908@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org> <4ADCCB0B.6060005@s5r6.in-berlin.de> <20091019202828.GA26338@mac.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbZJSVv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 17:51:58 -0400
In-Reply-To: <20091019202828.GA26338@mac.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel@tikei.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

Tino Keitel wrote:
> On Mon, Oct 19, 2009 at 22:24:43 +0200, Stefan Richter wrote:
> 
> [...]
> 
>>> No.  All it does is cause an error message to be printed in the system 
>>> log.  But it's possible that a failure lower down in the SCSI stack has 
>>> this effect.
>> I wonder what this might be.
> 
> I my case, XFS threw a lot of errors because of an incaccessible device
> and set the filesystem offline.

Perhaps this happens:

  - START STOP UNIT does not get through to the disk since
    firewire-sbp2 could not reconnect early enough.
  - The kernel _does not_ actually care, unlike I thought.
    It logs a device resume failure like Alan mentioned, then
    goes about its business.
  - Linux attempts to use the filesystem and issues read/ write/
    whatever requests.
  - Spindle motor is still off, disk returns errors.

At this moment, the target should fail these requests with a specific
sense code which tells the SCSI core that another START STOP UNIT is
required now.  However, it is just as likely that the target firmware
sends something nonsensical or nothing at all.  Or maybe the SCSI core
does even proceed to request START STOP UNIT but the firmware already
went belly-up.  Finally, SCSI core gives up and takes the disk offline.
-- 
Stefan Richter
-=====-==--= =-=- =--==
http://arcgraph.de/sr/
