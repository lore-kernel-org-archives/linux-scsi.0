From: Tejun Heo <tj@kernel.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 10:17:23 -0700
Message-ID: <20120725171723.GB32378@google.com>
References: <4FFB8A86.7000009@farcaster.org>
 <4FFCBA4C.4000502@farcaster.org>
 <4FFD6F3D.2030708@matthiasprager.de>
 <4FFD8410.7050604@matthiasprager.de>
 <20120717180932.GB2878@google.com>
 <5005BF7D.2050703@matthiasprager.de>
 <20120717200136.GC24336@google.com>
 <500A9D7C.8080801@matthiasprager.de>
 <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
 <1343225953.12094.55.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46491 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2GYRRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 13:17:30 -0400
Content-Disposition: inline
In-Reply-To: <1343225953.12094.55.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthias Prager <linux@matthiasprager.de>, Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org

Hello, James.

On Wed, Jul 25, 2012 at 06:19:13PM +0400, James Bottomley wrote:
> > I haven't consulted SAT but it seems like a bug in SAS driver or
> > firmware.  If it's a driver bug, we better fix it there.  If a
> > firmware bug, working around those is one of major roles of drivers,
> > so I think setting allow_restart is fine.
> 
> Actually, I don't think so.  SAT-2 section 8.12.2 does say 
> 
>         if the device is in the stopped state as the result of
>         processing a START STOP UNIT command (see 9.11), then the SATL
>         shall terminate the TEST UNIT READY command with CHECK CONDITION
>         status with the sense key set to NOT READY and the additional
>         sense code of LOGICAL UNIT NOT READY, INITIALIZING COMMAND
>         REQUIRED;
> 
> START STOP UNIT (with START=0) translates to STANDBY IMMEDIATE, and
> that's what hdparm -y issues.  We don't see this in /drivers/ata because
> TEST UNIT READY always returns success.

Urgh... ATA device in standby mode is ready for any command and
definitely doesn't need an "initializing command".  Oh, well...

> So it looks like the mpt2sas SAT is doing the correct thing and we only
> don't see this problem in normal SATA devices because of a bug in the
> libata-scsi SAT.

libata is inconsistent with the standard but I think the standard is
wrong here. :(

Thanks.

-- 
tejun
