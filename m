From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 10:03:08 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0301060956210.740-100000@ida.rowland.org>
References: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: mdharm-kernel@one-eyed-alien.net, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Sun, 5 Jan 2003 Andries.Brouwer@cwi.nl wrote:

> The SCSI code has no means of knowing the actual length transferred,
> so has no choice but to believe the length byte in the reply.
> But the USB code does the transferring itself, and knows precisely
> how many bytes were transferred. If 36 bytes were transferred and
> the additional length byte is 0, indicating a length of 5, then the
> USB code can fix the response and change the additional length byte
> to 31, indicating a length of 36. That way the SCSI code knows that
> not 5 but 36 bytes are valid, and it gets actual vendor and model strings.

I'm not familiar with the details of the SCSI code you are referring to,
but usb-storage does make available the actual transfer length.  All the
transport routine paths set the resid field of the Scsi_Cmnd structure
properly.  With this information, there should be no difficulty in
determining how many bytes were transferred.  (Maybe the setting doesn't
percolate up to the particular code you mention -- and maybe other host
adapter drivers don't set resid correctly so you cannot rely on its value.
I don't know what other problems might crop up.)

Alan Stern

