From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 15 Jun 2005 16:07:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506151603270.6561-100000@iolanthe.rowland.org>
References: <1118806139.5027.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27361 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261191AbVFOUHe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 16:07:34 -0400
In-Reply-To: <1118806139.5027.37.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 14 Jun 2005, James Bottomley wrote:

> > Won't this cause trouble in a hotplug environment?  A target or a LUN can 
> > be removed, and while it's still on the host's list a new target or LUN 
> > could be discovered with the same ID.  Having multiple entries on a list 
> > with the same ID sounds like a bad idea.  Is there some reason why these 
> > things aren't taken off their list as soon as they are removed?
> 
> It shouldn't, that's what rescan is about.  If the device isn't gone,
> you get the old device back again.

Is this wise?  With hotplugging, it's possible that the new device is
physically different from the one that was there before.  You don't want
to re-use an old structure with stale data in it when that happens.

Alan Stern

