From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPT fusion SAS target numbering...
Date: Sun, 03 May 2009 20:00:22 +0000
Message-ID: <1241380822.5596.114.camel@mulgrave.int.hansenpartnership.com>
References: <1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
	 <20090502.170912.263716496.davem@davemloft.net>
	 <1241323833.3639.77.camel@mulgrave.int.hansenpartnership.com>
	 <20090503.124509.203910506.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51156 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZECUAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 16:00:23 -0400
In-Reply-To: <20090503.124509.203910506.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

On Sun, 2009-05-03 at 12:45 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sat, 02 May 2009 23:10:33 -0500
> 
> > I Understand, that's why it's like the Fibre persistent bindings.  There
> > are, unfortunately, good reasons why it can't be used as the target id,
> > but if we just exported the id, udev can create a device node using it
> > and you can mount via that device node in an across boot consistent
> > manner ... will that do?
> 
> I see no reason why you wouldn't want to use known perfectly good
> persistent SCSI target IDs computed by the card.

The technical reason is that the lifetime rules for the IDs in the card
firmware don't match the lifetime rules in the mid layer and target ids
in the mid layer have to be unique.  It's not a problem absent hotplug,
but SAS is a hotplug bus.

 ... unplug from phy1 and plug immediately into phy2 is the most
pathological case for this.

We could take the fusion target ID as a hint and only overrule it if it
would cause duplicate IDs, so get it right 95% of the time ... but I can
just bet we'd see a large number of complaints about the surprise factor
involved in the 5% of cases where we had to allocate a new id.

> It doesn't make any sense, and it is inconsistent with how any
> other piece of code in the world handles these values provided
> by the card.

We can export the values provided by the card, and udev can create a
device node based on them, thus giving apparent persistence to device
nodes with this, so that would solve the boot from and mount from issue.

James


