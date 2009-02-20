From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 09:13:34 -0700
Message-ID: <20090220161334.GV16841@parisc-linux.org>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net> <1235144182.3349.5.camel@localhost.localdomain> <20090220155221.GU16841@parisc-linux.org> <1235145795.9025.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38761 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZBTQNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 11:13:35 -0500
Content-Disposition: inline
In-Reply-To: <1235145795.9025.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Feb 20, 2009 at 10:03:15AM -0600, James Bottomley wrote:
> > The port isn't coming out of standby state.  We send it a TEST_UNIT_READY,
> > it replies with a 0x04/0x0b.  At that point, we currently decide to send
> > it a START_STOP and wait 100 seconds.  This is clearly a crappy decision
> > on our part, we should just bail.
> 
> So we should be bailing on manual intervention, TP standby and TP
> unavailable?  It looks like TP assymetric access transition is waitable.

I think that's correct (and I think my version of this patch makes that
clearer).

SPC 4r14 isn't clear on 'Asymmetric Access Transition' -- I can't tell
whether that state is entered on transition *to* active, or *from*
active, or both.

> It also looks like offline and notify (enable spinup) required are also
> not worth waiting for ... although the latter is a SAS power management
> state which it's not clear to me how to handle properly.

Offline is only applicable to M and V (Media Changer and Automation)
devices, neither of which should be attached to by sd.

I don't know what 'Enable Spinup' is for -- maybe Doug knows?  Sending a
START_STOP to the device might be exactly what they intend for us to do.
Under a 'First, Do No Harm' theory, perhaps we should leave well enough
alone and just add Standby and Unavailable?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
