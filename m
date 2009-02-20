From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths
	until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 10:03:15 -0600
Message-ID: <1235145795.9025.4.camel@localhost.localdomain>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
	 <1235144182.3349.5.camel@localhost.localdomain>
	 <20090220155221.GU16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53152 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbZBTQDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 11:03:18 -0500
In-Reply-To: <20090220155221.GU16841@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-02-20 at 08:52 -0700, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 03:36:22PM +0000, James Bottomley wrote:
> > > +                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 0x0b ||
> > > sshdr.ascq == 0x0c) ) {
> > > +                       break;  /* manual intervention required || Standby ||
> > 
> > This really doesn't look right ASC/ASCQ 0x04/0x0b is LUN not accessible;
> > target *port* in standby state. That's supposed to be because it was put
> > into a standby state according to SPC3(r23) 5.8.2.4.4
> > 
> > I don't see how a port (target) is expected to come out of standby with
> > a LUN command.  The standard implies you need to do it with a set target
> > port groups command.  What array is actually giving this?
> 
> The port isn't coming out of standby state.  We send it a TEST_UNIT_READY,
> it replies with a 0x04/0x0b.  At that point, we currently decide to send
> it a START_STOP and wait 100 seconds.  This is clearly a crappy decision
> on our part, we should just bail.

So we should be bailing on manual intervention, TP standby and TP
unavailable?  It looks like TP assymetric access transition is waitable.

It also looks like offline and notify (enable spinup) required are also
not worth waiting for ... although the latter is a SAS power management
state which it's not clear to me how to handle properly.

James


