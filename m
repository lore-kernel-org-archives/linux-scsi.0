From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 08:52:21 -0700
Message-ID: <20090220155221.GU16841@parisc-linux.org>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net> <1235144182.3349.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47663 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZBTPwX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 10:52:23 -0500
Content-Disposition: inline
In-Reply-To: <1235144182.3349.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Feb 20, 2009 at 03:36:22PM +0000, James Bottomley wrote:
> > +                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 0x0b ||
> > sshdr.ascq == 0x0c) ) {
> > +                       break;  /* manual intervention required || Standby ||
> 
> This really doesn't look right ASC/ASCQ 0x04/0x0b is LUN not accessible;
> target *port* in standby state. That's supposed to be because it was put
> into a standby state according to SPC3(r23) 5.8.2.4.4
> 
> I don't see how a port (target) is expected to come out of standby with
> a LUN command.  The standard implies you need to do it with a set target
> port groups command.  What array is actually giving this?

The port isn't coming out of standby state.  We send it a TEST_UNIT_READY,
it replies with a 0x04/0x0b.  At that point, we currently decide to send
it a START_STOP and wait 100 seconds.  This is clearly a crappy decision
on our part, we should just bail.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
