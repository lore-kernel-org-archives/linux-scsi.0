From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 10:15:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526171514.GA1332@us.ibm.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com> <1085590517.2116.439.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:26871 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265659AbUEZRPO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 13:15:14 -0400
Content-Disposition: inline
In-Reply-To: <1085590517.2116.439.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> I'd really like to see all fibre events (like loop up/down, device
> add/remove) handled inside the FC transport class.  From there, it
> probably still make sense to use hotplug as the mechanism for importing
> user policy.

Currently there are no hotplug events generated from SCSI except those
from add / remove of sysfs related structures. Are you suggesting that
SCSI should call call_usermodehelper and generate events?

The general issue I believe Martin is investigating is in the context of
device mapper multi-path (Martin correct me if I have this incorrect).
In the failure transition of a path a scsi_device can be marked
offline.  Until the device is restored path checking / re-enablement
cannot proceed. One issue is that path testing tools need to have SCSI
specific knowledge to know to change a device state. The second issue is
that while this could be done with a daemon it would appear a more
efficient method would be some form of state / event notification of
device and transport specific events.

-andmike
--
Michael Anderson
andmike@us.ibm.com

