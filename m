From: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>
Subject: RE: [PATCH 1/1] : Spinning up disk is observed on standby paths
 until timeout, resulting in longer path restoration time.
Date: Mon, 23 Feb 2009 11:48:53 +0000
Message-ID: <DB8E544DD4B3D346A36F2698103530AE292ABB05C1@GVW1105EXC.americas.hpqcorp.net>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
 <1235144182.3349.5.camel@localhost.localdomain>
 <20090220155221.GU16841@parisc-linux.org>
 <1235145795.9025.4.camel@localhost.localdomain>
 <20090220161334.GV16841@parisc-linux.org>
 <1235147048.9025.9.camel@localhost.localdomain>
 <20090220170431.GW16841@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:35854 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBWLtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2009 06:49:40 -0500
In-Reply-To: <20090220170431.GW16841@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

If this patch is valid , when can we expect this on mainstream kernel . I can help testing this patch when included in the kernel.

Narayanan
  

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx] 
Sent: Friday, February 20, 2009 10:35 PM
To: James Bottomley
Cc: Rengarajan, Narayanan (STSD); linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.

On Fri, Feb 20, 2009 at 04:24:08PM +0000, James Bottomley wrote:
> I think the point is that it's a transition:  Once it comes out of it 
> we either get access or we don't, so it's worth waiting to see what 
> happens.

I agree.  If we knew that it could only be transitioning to inactive, we could skip it.  This state probably only gets returned once in a blue moon anyway.

> > I don't know what 'Enable Spinup' is for -- maybe Doug knows?  
> > Sending a START_STOP to the device might be exactly what they intend for us to do.
> > Under a 'First, Do No Harm' theory, perhaps we should leave well 
> > enough alone and just add Standby and Unavailable?
> 
> As I said, it's a SAS power management command related condition:  The 
> drive is limited to consuming a certain level of power and that's not 
> enough to spin up, so it won't spin up regardless of how many start 
> unit commands it gets sent until the power management control is 
> changed to allow it to consume enough power for the spinup.  I think 
> it's ignorable for now ... it probably means that when power 
> management is added we need to get the transport classes involved to 
> send the appropriate sas pm command.

Looking at SAS2r14, I see that NOTIFY (ENABLE SPINUP) is a primitive, not a command.  If the SAS device is attached through an expander, I don't think we have a way to send that primitive to the device.  We must wait for the expander to send it.  If it's sirectly-connected, the initiator port is supposed to send it.  Presumably this is handled either by firmware on the HBA or by the HBA driver; either way, we don't seem to have a way today to get the HBA to send this primitive.

I think our current behaviour is correct for this command, so the patch
here: http://marc.info/?l=linux-scsi&m=123513805527153&w=2 is correct.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this operating system, but compare it to ours.  We can't possibly take such a retrograde step."
