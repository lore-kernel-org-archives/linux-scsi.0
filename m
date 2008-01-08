From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 8 Jan 2008 07:01:51 -0700
Message-ID: <20080108140151.GD16309@parisc-linux.org>
References: <47837E06.5080406@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57851 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAHOBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 09:01:53 -0500
Content-Disposition: inline
In-Reply-To: <47837E06.5080406@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@novell.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 08, 2008 at 02:43:34PM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I have here a buggy firewire bridge (Prolific PL3507) which requires that each 'INQUIRY' command is followed by a 'READ CAPACITY' command. Otherwise any read will return invalid data (the payload is preceded by 36 empty bytes).
> 
> How to fix this? Sure one could add a hack to sbp2.c to always issue a READ CAPACITY after INQUIRY, but this somehow feels wrong ...

There's only one place in the scsi stack that issues INQUIRY --
scsi_scan.c [1].  sd is going to issue READ CAPACITY before it issues
any READ commands, so I don't see where you're having this problem.
Is it with some program issuing INQUIRY through SG_IO or something?

I have a hard time thinking this needs to be handled generically
because READ CAPACITY isn't in the Primary Command Set, unlike INQUIRY.
It's mandatory for SBC devices to implement it, but other devices
shouldn't even implement it.

My opinion is that it needs to be handled either in the application
issuing sg commands or in sbp2.

[1] yes, there are others, such as drivers and scsi_transport_spi, but
none relevant to sbp2.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
