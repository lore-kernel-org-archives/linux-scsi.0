From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 15:11:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608211508520.5767-100000@iolanthe.rowland.org>
References: <20060821185152.GF29299@vienna.egenera.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37645 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750782AbWHUTLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:11:41 -0400
In-Reply-To: <20060821185152.GF29299@vienna.egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 21 Aug 2006, Philip R. Auld wrote:

> > Let's take the case of a fictional device that has a vendor string
> > 
> > TJD\0Hje9
> > 
> > I say that should be printed as "TJD     ".  You say that should be
> > printed as "TJD Hje9".
> 
> Sure, but what if the Hje9 is not garbage. It's still available in the
> proposed patch. It's lost if you overwrite it with spaces. Maybe the
> TJD Hje9 requires special handling :)
> 
> If it turns out to be garbage couldn't the blacklist entry be set to TJD
> and only match the first 3 characters? (I haven't looked at how the
> comparison is made).
> 
> Indeed it may look better treating the NUL as the end, but I'm arguing
> that assuming anything about the intent of the engineer who wrote the
> out of spec code is probably a mistake.

In cases like this, I tend to think it's hopeless to guess at what the 
original engineer had in mind.  The best course is to minimize 
user-visible changes, which means interpreting the NUL the same as we have 
all along -- as a terminator.

Alan Stern

