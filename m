From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 14:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFF2D45.1040203@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com> <20030629110205.A4728@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31634 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265714AbTF2SDe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:03:34 -0400
In-Reply-To: <20030629110205.A4728@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries Brouwer <aebr@win.tue.nl>, linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> Right now, we can handle this case with a slave_configure() function that
> sets use_10_for_ms and use_10_for_rw, like usb-storage does now.  The
> heuristic code in usb-storage is on the way out, once sr.c is converted (in
> progress).
> 
> Devices easily identified, heuristics gone, repeated code very minimal (2
> lines) -- sounds like a winner to me.  Actually, I have a feeling that any
> algorithm to try to determine MMC or not (complete with it's own heuristic
> to handle strange devices) will be much longer than those repeated 2 lines.

No argument, I'm sold :)  Sounds like a good plan.

That still doesn't address the issue use_10_for_ms being _too_ 
fine-grained, though:  mode sense is but one part of the larger picture.

We will still have duplicated ATAPI (and other?) logic in USB storage, 
ide-scsi, my driver, and elsewhere for items which are common to MMC. 
For many cases, it is silly to set a whole list of use_10_for_foo 
variables, when they are all unconditionally set to 1 when MMC is 
detected (->slave_configure).

So, a concrete suggestion would be:

Create 'mmc' bit for each scsi_device, set at slave_configure time. 
use_10_for_foo and other code can derive values from this.  i.e. provide 
enough information that can automatically set all those use_10_for_foo 
variables.

	Jeff


