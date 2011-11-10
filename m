From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Remove 'unhandled error code' messages
Date: Thu, 10 Nov 2011 09:44:07 -0600
Message-ID: <1320939847.11745.7.camel@dabdike.int.hansenpartnership.com>
References: <1320934327-8384-1-git-send-email-hare@suse.de>
	 <1320936918.3040.1.camel@dabdike.int.hansenpartnership.com>
	 <4EBBEB61.1090903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40027 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab1KJPoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 10:44:09 -0500
In-Reply-To: <4EBBEB61.1090903@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-11-10 at 16:18 +0100, Hannes Reinecke wrote:
> On 11/10/2011 03:55 PM, James Bottomley wrote:
> > On Thu, 2011-11-10 at 15:12 +0100, Hannes Reinecke wrote:
> >> scsi_io_completion() tries to take some action based on
> >> the command result and sense code. It also displays
> >> 'unhandled error code' or 'unhandled sense code' in case
> >> no special handling was found.
> >> This serves as an additional source of confusion to
> >> the unsuspecting user, as the message in fact means
> >> 'everything okay, no special casing required',
> >> and not 'oh gosh, something has happened and the system
> >> couldn't deal with it'.
> >
> > It means we're just about to fail the command with an error.  That's not
> > really an everything ok case.
> >
> > Sometimes, you're right, this is the correct thing to do silently, but
> > often it's not.  So, same question to you as to Rob: What are the
> > circumstances you want silent failure for and can you special case them?
> >
> The whole point here is: It's not silent, even when the 
> 'description' is not set.

So all we do is a random dump of result, sense and command.

That doesn't look like an improvement to me.

We've had a set of discussions and proposals:

http://marc.info/?t=131854150100005
http://marc.info/?t=131806586600055

But nothing really leaps out as the solution.  What the system is saying
is that we encountered an error but it's not one of our handled cases,
so we're just going to fail the command and hope for the best.

James


