From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Remove 'unhandled error code' messages
Date: Thu, 10 Nov 2011 08:55:18 -0600
Message-ID: <1320936918.3040.1.camel@dabdike.int.hansenpartnership.com>
References: <1320934327-8384-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39775 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1KJOzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 09:55:44 -0500
In-Reply-To: <1320934327-8384-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-11-10 at 15:12 +0100, Hannes Reinecke wrote:
> scsi_io_completion() tries to take some action based on
> the command result and sense code. It also displays
> 'unhandled error code' or 'unhandled sense code' in case
> no special handling was found.
> This serves as an additional source of confusion to
> the unsuspecting user, as the message in fact means
> 'everything okay, no special casing required',
> and not 'oh gosh, something has happened and the system
> couldn't deal with it'.

It means we're just about to fail the command with an error.  That's not
really an everything ok case.

Sometimes, you're right, this is the correct thing to do silently, but
often it's not.  So, same question to you as to Rob: What are the
circumstances you want silent failure for and can you special case them?

James


