From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB storage problems (2.5.69 BK)
Date: Tue, 27 May 2003 10:35:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305271032430.779-100000@ida.rowland.org>
References: <UTC200305262302.h4QN2PF04675.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7684 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263619AbTE0OWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 10:22:42 -0400
In-Reply-To: <UTC200305262302.h4QN2PF04675.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: jochen@scram.de, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, 27 May 2003 Andries.Brouwer@cwi.nl wrote:

> (iii) maybe your device wants to return more bytes than 4;
>       the error is -EOVERFLOW, that is, "babble".
>       I expect my recent patch would help.
>       (have no time to dig it up, and will be away the coming days;
>        basically I think things are under control, we just need to
>        push these scsi changes, and then these usb changes)

Andries:

When you have a chance to work on it, maybe you could also consider the 
issue of the multiple retries in Jochen's log.  The scsi disk driver 
issued vastly more retries than necessary for commands that were doomed to 
fail anyway.  And when the retries ran out, the driver did not take the 
device offline but instead just moved on to try the next command -- again 
multiple times.  Why wasn't the error handler invoked?

Alan Stern

