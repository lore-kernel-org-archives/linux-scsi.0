From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch for iriver-mp3player
Date: Mon, 7 Jun 2004 10:36:22 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406071017090.1800-100000@ida.rowland.org>
References: <20040606223250.GA15574@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10756 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264685AbUFGOgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 10:36:23 -0400
In-Reply-To: <20040606223250.GA15574@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tobias Lieber <little.tobias@gmx.de>, Javier Marcet <lists@marcet.info>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 6 Jun 2004, Matthew Dharm wrote:

> We're actually trying to figure out the 'right way' to do this now.  Our
> expectation is that there is some algorithmic way to determine if this bit
> is "right" or not, as Windows seems to get it right without
> white/blacklisting.

The two problems are similar but not quite the same.  The Panasonic
DMC-LC40 camera reports correctly that it has removable media but then
gets confused when it receives ALLOW MEDIUM REMOVAL.  The iRiver flash MP3
player reports _incorrectly_ that it has removable media (that's what
Javier says) and then gets confused when it receives PREVENT-ALLOW MEDIUM 
REMOVAL.

It seems clear that the correct solution for the Panasonic is to clear the 
sdev->lockable flag.  Is that also the correct solution for the iRiver, or 
should we change the RMB flag in the INQUIRY response?  Clearing the 
lockable flag is a lot easier and less invasive.

Alan Stern

