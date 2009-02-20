From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths
	until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 16:24:08 +0000
Message-ID: <1235147048.9025.9.camel@localhost.localdomain>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
	 <1235144182.3349.5.camel@localhost.localdomain>
	 <20090220155221.GU16841@parisc-linux.org>
	 <1235145795.9025.4.camel@localhost.localdomain>
	 <20090220161334.GV16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50986 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZBTQYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 11:24:12 -0500
In-Reply-To: <20090220161334.GV16841@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-02-20 at 09:13 -0700, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 10:03:15AM -0600, James Bottomley wrote:
> > > The port isn't coming out of standby state.  We send it a TEST_UNIT_READY,
> > > it replies with a 0x04/0x0b.  At that point, we currently decide to send
> > > it a START_STOP and wait 100 seconds.  This is clearly a crappy decision
> > > on our part, we should just bail.
> > 
> > So we should be bailing on manual intervention, TP standby and TP
> > unavailable?  It looks like TP assymetric access transition is waitable.
> 
> I think that's correct (and I think my version of this patch makes that
> clearer).
> 
> SPC 4r14 isn't clear on 'Asymmetric Access Transition' -- I can't tell
> whether that state is entered on transition *to* active, or *from*
> active, or both.

I think the point is that it's a transition:  Once it comes out of it we
either get access or we don't, so it's worth waiting to see what
happens.

> > It also looks like offline and notify (enable spinup) required are also
> > not worth waiting for ... although the latter is a SAS power management
> > state which it's not clear to me how to handle properly.
> 
> Offline is only applicable to M and V (Media Changer and Automation)
> devices, neither of which should be attached to by sd.

Makes sense

> I don't know what 'Enable Spinup' is for -- maybe Doug knows?  Sending a
> START_STOP to the device might be exactly what they intend for us to do.
> Under a 'First, Do No Harm' theory, perhaps we should leave well enough
> alone and just add Standby and Unavailable?

As I said, it's a SAS power management command related condition:  The
drive is limited to consuming a certain level of power and that's not
enough to spin up, so it won't spin up regardless of how many start unit
commands it gets sent until the power management control is changed to
allow it to consume enough power for the spinup.  I think it's ignorable
for now ... it probably means that when power management is added we
need to get the transport classes involved to send the appropriate sas
pm command.

James


