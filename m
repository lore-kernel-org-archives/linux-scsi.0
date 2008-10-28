From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Tue, 28 Oct 2008 09:43:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810280935420.2549-100000@iolanthe.rowland.org>
References: <49070D63.6050706@emulex.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34273 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752614AbYJ1NnP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 09:43:15 -0400
In-Reply-To: <49070D63.6050706@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, =?ISO-8859-1?Q?=D6rjan_Nordlund?= <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 28 Oct 2008, James Smart wrote:

> Checking the payload like this is really hokey - but probably works.

I agree completely; it _is_ hokey.  There is precedent, however -- 
scsi_mode_sense() behaves similarly.

> Have we lost all notion from the LLDD on what the actual payload length 
> was (calculated by expected transfer length and resid) ?

In short: Yes, we have.  That information is discarded by
scsi_execute().

>  Seems like a 
> much better idea than just checking contents.

Again I agree.  The SCSI midlayer simply is not designed around the
idea of LLD's returning an actual transfer length.  I have no idea why
not -- I wasn't there when the SCSI core was initially designed.  :-)

Alan Stern

