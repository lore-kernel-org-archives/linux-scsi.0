From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDDreentrancy
Date: Tue, 27 Aug 2002 17:04:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6BE940.98A85C26@splentec.com>
References: <OF3E535470.2D9A9A9D-ONC1256C22.002A3928@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7RL3vH14523
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2002 17:03:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Aron Zeh wrote:
> 
> That's exactly where my question comes in. How do we see that an
> asynchronous
> reconfiguration on unit level has taken place? Unit Attentions are only
> reported
> in piggy-back fashion on top of a command per the standard you quoted (if I
> did not misread it).
> If a unit was just added to the configuration (and holds "unit was just
> powered on" attention)
> then I cannot see how Linux could find out.

Yes, we have a similar conundrum.

Well, a notification is needed just because the transport has to know
in order to process properly any resevations/etc.

But all this is transport specific and UA is what SAM-3 specifies
as per Target/Initiator architecture (client/server). (SAM-3, 4.6(.1)) 

This model is properly preserved in Linux by the Scsi_Host_Template.

> So you're ruling out the use of transport specific hotplug notifications
> like RSCN on FC?

Not really ``ruling out'', but you can notify of such an event by other
means.

> I currently cannot quite see how this would work. Isn't there always the
> need to interpret reconfigurations of the hardware used to transport SAM-3
> data on a lower level? Or has SAM-3 some capabilites for doing just that
> that I have missed?

SAM-3 doesn't provide for ``hotplugging''. It's the whole server/client
architecture.

Since a human/robot is doing the hotplugging, such events can be
notified of by other means.

-- 
Luben
